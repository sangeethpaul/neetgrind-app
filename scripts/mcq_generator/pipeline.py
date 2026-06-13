"""
pipeline.py — Core LangChain LCEL pipeline implementing the
COLING 2025 three-stage MCQ generation strategy.

Flow per chapter chunk:
  text → [EXTRACT] → facts[] → [QUESTION] → drafts[] → [DISTRACTOR] → MCQRecord[]
"""

from __future__ import annotations
import json
import logging
import time
from pathlib import Path

from langchain_core.output_parsers import StrOutputParser
from tenacity import (
    retry,
    stop_after_attempt,
    wait_exponential,
    retry_if_exception_type,
)

from config import (
    GEMINI_API_KEY,
    GEMINI_MODEL,
    LLM_PROVIDER,
    OLLAMA_MODEL,
    OLLAMA_BASE_URL,
    MCQ_PER_CHAPTER,
    MAX_RETRIES,
    CHAPTER_TOPIC_MAP,
)
from prompts import (
    EXTRACTION_PROMPT,
    QUESTION_PROMPT,
    DISTRACTOR_PROMPT,
    JUDGE_PROMPT,
)
from schemas import (
    ExtractionOutput,
    QuestionDraft,
    DistractorOutput,
    MCQRecord,
    JudgeOutput,
)
from pdf_extractor import extract_chapter_text, chunk_text, get_chapter_title

logger = logging.getLogger(__name__)


def _build_llm(temperature: float = 0.3):
    """Instantiate either Gemini or local Ollama model."""
    if LLM_PROVIDER == "ollama":
        try:
            from langchain_ollama import ChatOllama
            return ChatOllama(
                model=OLLAMA_MODEL,
                base_url=OLLAMA_BASE_URL,
                temperature=temperature,
            )
        except ImportError:
            logger.error("langchain-ollama not installed. Defaulting to Google.")
    
    from langchain_google_genai import ChatGoogleGenerativeAI
    return ChatGoogleGenerativeAI(
        model=GEMINI_MODEL,
        temperature=temperature,
        api_key=GEMINI_API_KEY,
        max_retries=2,
    )


# ── Retry decorator for all LLM calls ────────────────────────────────────────
def _retry_decorator():
    return retry(
        stop=stop_after_attempt(5),
        wait=wait_exponential(multiplier=2, min=5, max=70),
        retry=retry_if_exception_type((Exception,)),
        reraise=True,
    )


@_retry_decorator()
def _extract_facts(
    llm: any,
    chapter_text: str,
    subject: str,
    chapter_title: str,
) -> ExtractionOutput:
    """Stage 1: Extract key facts from a chapter chunk."""
    chain = EXTRACTION_PROMPT | llm | StrOutputParser()
    raw = chain.invoke({
        "chapter_text": chapter_text[:12000],  # Hard cap for safety
        "subject": subject,
        "chapter_title": chapter_title,
    })
    # Parse JSON response
    raw = raw.strip()
    if raw.startswith("```"):
        raw = "\n".join(raw.split("\n")[1:-1])
    data = json.loads(raw)
    return ExtractionOutput.model_validate(data)


@_retry_decorator()
def _generate_question(
    llm: any,
    fact: str,
    category: str,
    subject: str,
) -> QuestionDraft:
    """Stage 2: Generate question + correct answer from a fact."""
    chain = QUESTION_PROMPT | llm | StrOutputParser()
    raw = chain.invoke({
        "fact": fact,
        "category": category,
        "subject": subject,
    })
    raw = raw.strip()
    if raw.startswith("```"):
        raw = "\n".join(raw.split("\n")[1:-1])
    data = json.loads(raw)
    return QuestionDraft.model_validate(data)


@_retry_decorator()
def _generate_distractors(
    llm: any,
    question_text: str,
    correct_answer: str,
    subject: str,
) -> DistractorOutput:
    """Stage 3: Generate 3 plausible wrong options."""
    chain = DISTRACTOR_PROMPT | llm | StrOutputParser()
    raw = chain.invoke({
        "question_text": question_text,
        "correct_answer": correct_answer,
        "subject": subject,
    })
    raw = raw.strip()
    if raw.startswith("```"):
        raw = "\n".join(raw.split("\n")[1:-1])
    data = json.loads(raw)
    return DistractorOutput.model_validate(data)


@_retry_decorator()
def _evaluate_mcq(llm: any, mcq: MCQRecord, subject: str) -> JudgeOutput:
    """COLING 2025 Approach: Self-Evaluation stage to ensure high pedagogical quality."""
    chain = JUDGE_PROMPT | llm | StrOutputParser()
    raw = chain.invoke({
        "question_text": mcq.question_text,
        "option_a": mcq.option_a,
        "option_b": mcq.option_b,
        "option_c": mcq.option_c,
        "option_d": mcq.option_d,
        "correct_option": mcq.correct_option,
        "explanation": mcq.explanation,
        "subject": subject,
    })
    raw = raw.strip()
    if raw.startswith("```"):
        raw = "\n".join(raw.split("\n")[1:-1])
    data = json.loads(raw)
    return JudgeOutput.model_validate(data)


def process_chapter(
    pdf_path: Path,
    topic_id: int,
    subject: str,
    *,
    target_mcqs: int = MCQ_PER_CHAPTER,
    dry_run: bool = False,
) -> list[MCQRecord]:
    """
    Full three-stage pipeline for one NCERT chapter PDF.

    Args:
        pdf_path:    Path to the chapter PDF.
        topic_id:    Supabase topic_id for this chapter.
        subject:     Subject name (Biology/Physics/Chemistry).
        target_mcqs: Number of MCQs to generate.
        dry_run:     If True, skip LLM calls and return dummy records.

    Returns:
        List of validated MCQRecord objects.
    """
    chapter_title = get_chapter_title(pdf_path)
    logger.info(f"  📖 Chapter: {chapter_title}")

    if dry_run:
        logger.info("  🔍 [DRY RUN] Skipping LLM — returning mock MCQ")
        return [_make_mock_mcq(topic_id, chapter_title)]

    # Only build LLM clients when actually needed (not in dry-run)
    llm_extract = _build_llm(temperature=0.2)
    llm_question = _build_llm(temperature=0.4)
    llm_distract = _build_llm(temperature=0.7)  # More creative for distractors


    # ── Step 1: Extract text and chunk if needed ──────────────────────────────
    chapter_text = extract_chapter_text(pdf_path)
    chunks = chunk_text(chapter_text, max_tokens=3500)
    logger.info(f"  📄 {len(chunks)} chunk(s) | ~{len(chapter_text)//4} tokens total")

    all_mcqs: list[MCQRecord] = []
    seen_questions: set[str] = set()

    for chunk_idx, chunk_text_part in enumerate(chunks):
        # ── Stage 1: Extract facts ────────────────────────────────────────────
        try:
            extraction = _extract_facts(
                llm_extract, chunk_text_part, subject, chapter_title
            )
        except Exception as e:
            logger.warning(f"  ⚠️  Extraction failed for chunk {chunk_idx + 1}: {e}")
            continue

        # ── Stages 2 & 3: Question + Distractors per fact ────────────────────
        for fact_obj in extraction.facts:

            try:
                # Stage 2
                draft = _generate_question(
                    llm_question, fact_obj.fact, fact_obj.category, subject
                )

                # Deduplicate
                q_key = draft.question_text.lower()[:60]
                if q_key in seen_questions:
                    continue
                seen_questions.add(q_key)

                # Stage 3
                distractors = _generate_distractors(
                    llm_distract,
                    draft.question_text,
                    draft.correct_answer,
                    subject,
                )

                # Assemble final MCQ with randomised option positions
                mcq = MCQRecord.assemble(
                    topic_id=topic_id,
                    draft=draft,
                    distractors=distractors,
                )

                # ── COLING 2025 Evaluation Stage ─────────────────────────────
                judgment = _evaluate_mcq(llm_question, mcq, subject)
                if judgment.score < 7:
                    logger.warning(f"  🚩 MCQ rejected (Score {judgment.score}): {judgment.reason}")
                    continue
                
                all_mcqs.append(mcq)
                logger.info(f"    ✅ Q: {mcq.question_text[:60]}… (Score: {judgment.score})")

                # Rate limiting: 10s delay to respect Gemini free tier limits (15 RPM)
                # No delay needed if using local Ollama!
                if LLM_PROVIDER != "ollama":
                    time.sleep(10.0)

            except Exception as e:
                logger.warning(f"  ⚠️  Failed on fact: {fact_obj.fact[:40]}… → {e}")
                continue

    logger.info(f"  ✨ Generated {len(all_mcqs)} MCQs for {pdf_path.name}")
    return all_mcqs


def _make_mock_mcq(topic_id: int, chapter_title: str) -> MCQRecord:
    """Returns a placeholder MCQ for dry-run testing."""
    return MCQRecord(
        topic_id=topic_id,
        question_text=f"[DRY RUN] What is the main topic of '{chapter_title[:40]}'?",
        option_a="Option A (correct)",
        option_b="Option B (wrong)",
        option_c="Option C (wrong)",
        option_d="Option D (wrong)",
        correct_option="A",
        explanation="This is a dry-run placeholder. No real LLM call was made.",
    )
