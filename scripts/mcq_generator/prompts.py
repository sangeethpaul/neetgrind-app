"""
prompts.py — Three LangChain ChatPromptTemplates implementing the
COLING 2025 three-stage MCQ generation pipeline.

Stage 1 — EXTRACTION: Extract key testable facts from raw NCERT text.
Stage 2 — QUESTION:   Generate a question + correct answer for one fact.
Stage 3 — DISTRACTOR: Generate 3 plausible wrong options for the question.
"""

from langchain_core.prompts import ChatPromptTemplate

# ── Stage 1: Extraction Prompt ────────────────────────────────────────────────
EXTRACTION_PROMPT = ChatPromptTemplate.from_messages([
    (
        "system",
        """You are an expert NCERT Biology/Physics/Chemistry content analyst for NEET preparation.
Your job is to extract EVERY key testable fact from NCERT chapter text that can become a high-quality MCQ question.

Focus on facts that:
- Can be tested in a single MCQ question
- Are unambiguous and factually verifiable
- Cover: definitions, formulas, processes, comparisons, scientists/discoveries
- Are commonly tested in NEET examinations

Identify and extract absolutely every distinct scientific concept, definition, equation, exception, and property mentioned. Do not leave any testable information out.

Output ONLY valid JSON in this exact format:
{{
  "facts": [
    {{"fact": "...", "category": "definition|formula|process|comparison|application"}},
    ...
  ]
}}"""
    ),
    (
        "human",
        """Extract EVERY testable fact from this NCERT chapter text chunk. 
Aim for at least 40 distinct facts if the text allows.

SUBJECT: {subject}
CHAPTER: {chapter_title}

---
{chapter_text}
---

Return JSON only. No markdown, no explanation."""
    ),
])

# ── Stage 2: Question Generation Prompt ──────────────────────────────────────
QUESTION_PROMPT = ChatPromptTemplate.from_messages([
    (
        "system",
        """You are an expert NEET MCQ question writer with 10+ years of experience.
Write a single high-quality MCQ question based on the given fact.

Rules:
1. The question must be clear and unambiguous
2. The correct answer must be factually accurate and from the fact provided
3. The explanation must cite the key concept clearly
4. Avoid "all of the above" or "none of the above" patterns
5. Use NEET-style phrasing (scientific, precise language)
6. Do NOT include option choices, labels (e.g. A), B), C), D)), or answers inside the question_text itself. The question_text must contain only the question body.
7. Do NOT start explanations with phrases like "Based on the fact that..." or "Based on the fact...". State the explanation directly.

Output ONLY valid JSON in this exact format:
{{
  "question_text": "...",
  "correct_answer": "...",
  "explanation": "..."
}}""",
    ),
    (
        "human",
        """Write one MCQ question based on this NCERT fact:

SUBJECT: {subject}
FACT: {fact}
CATEGORY: {category}

Return JSON only. No markdown, no explanation.""",
    ),
])

# ── Stage 3: Distractor Generation Prompt ────────────────────────────────────
DISTRACTOR_PROMPT = ChatPromptTemplate.from_messages([
    (
        "system",
        """You are an expert at creating plausible but incorrect MCQ distractors for NEET.

Distractor quality rules:
1. Each distractor must be WRONG but PLAUSIBLE — a student who hasn't studied might choose it
2. Distractors should be similar in length and style to the correct answer
3. Use common misconceptions, related-but-wrong facts, or slightly altered values
4. Never repeat the correct answer, even paraphrased
5. Avoid obviously absurd options

Output ONLY valid JSON in this exact format:
{{
  "distractor_1": "...",
  "distractor_2": "...",
  "distractor_3": "..."
}}""",
    ),
    (
        "human",
        """Create 3 plausible wrong answer options for this NEET question:

QUESTION: {question_text}
CORRECT ANSWER: {correct_answer}
SUBJECT: {subject}

Requirements:
- Each distractor must be factually WRONG
- Must be believable to an unprepared student
- Similar length to the correct answer

Return JSON only.""",
    ),
])


# ── Stage 4: COLING 2025 Evaluation Prompt ──────────────────────────────────
JUDGE_PROMPT = ChatPromptTemplate.from_messages([
    (
        "system",
        """You are a senior NEET Exam Auditor. Your task is to evaluate a Multiple Choice Question (MCQ) for pedagogical quality, clarity, and NEET-relevance.

Criteria:
1. Pedagogical Value: Does it test a core scientific concept, not a trivial fact?
2. Clarity: Is the question text unambiguous?
3. Plausibility: Are the distractors (wrong options) plausible and not obviously silly?
4. Soundness: Is there exactly one correct answer?

Output ONLY valid JSON:
{{
  "score": 1-10,
  "reason": "Brief justification",
  "pedagogical_value": "Description of concept tested",
  "clarity_score": 1-10
}}"""
    ),
    (
        "human",
        """Evaluate this MCQ for {subject}:

QUESTION: {question_text}
OPTIONS:
A) {option_a}
B) {option_b}
C) {option_c}
D) {option_d}

CORRECT OPTION: {correct_option}
EXPLANATION: {explanation}

Return JSON only."""
    )
])
