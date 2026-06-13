import re
import fitz  # PyMuPDF
from pydantic import BaseModel
from openai import OpenAI
import time
import logging

# Configure basic logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# --- Pydantic Schema for Simple Mode ---
class MCQSchema(BaseModel):
    question_text: str
    option_a: str
    option_b: str
    option_c: str
    option_d: str
    correct_option: str
    explanation: str

class MCQListSchema(BaseModel):
    mcqs: list[MCQSchema]

# --- PDF & Text Utilities ---
def extract_pdf_text(uploaded_file) -> str:
    """Extract text from an uploaded PDF file."""
    doc = fitz.open(stream=uploaded_file.read(), filetype="pdf")
    text = ""
    for page in doc:
        text += page.get_text("text") + "\n"
    return text

def chunk_text(text: str, chunk_size: int = 2000) -> list[str]:
    """Split text into overlapping chunks of roughly `chunk_size` characters."""
    words = text.split()
    chunks = []
    current_chunk = []
    current_length = 0
    
    for word in words:
        current_chunk.append(word)
        current_length += len(word) + 1
        if current_length >= chunk_size:
            chunks.append(" ".join(current_chunk))
            # Keep the last 50 words for overlap
            current_chunk = current_chunk[-50:]
            current_length = sum(len(w) + 1 for w in current_chunk)
            
    if current_chunk and len(current_chunk) > 50:
        chunks.append(" ".join(current_chunk))
    return chunks

# --- Multi-Stage Pipeline (COLING 2025 Adapted) ---

def _call_llm(client: OpenAI, model: str, prompt: str, temperature: float = 0.3) -> str:
    """Helper to call Ollama via OpenAI client."""
    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=temperature,
        extra_body={"think": False} # Disable think blocks for clean output if applicable
    )
    return response.choices[0].message.content.strip()

def _extract_facts(client: OpenAI, model: str, chunk: str, num_facts: int = 3, logs: list = None) -> list[str]:
    prompt = (
        f"Extract exactly {num_facts} distinct, highly factual concepts from the following text that are suitable for a NEET biology/chemistry/physics exam.\n"
        "Output ONLY the facts as a bulleted list, starting each with '- '.\n\n"
        f"TEXT:\n{chunk}"
    )
    res = _call_llm(client, model, prompt, temperature=0.1)
    if logs is not None: logs.append({"stage": "Extraction", "prompt": prompt, "response": res})
    
    facts = []
    for line in res.split("\n"):
        line = line.strip()
        if line.startswith("-") or line.startswith("*"):
            facts.append(line.lstrip("-*").strip())
    
    # Fallback if no bullets found
    if not facts and res:
        facts = [f.strip() for f in res.split("\n") if f.strip()][:num_facts]
        
    return facts[:num_facts]

def _generate_qa(client: OpenAI, model: str, fact: str, logs: list = None) -> tuple[str, str]:
    prompt = (
        f"Based on this fact: '{fact}'\n\n"
        "Create a challenging multiple-choice question stem and the correct answer.\n"
        "Output your response strictly in this exact format:\n"
        "QUESTION: <your question here>\n"
        "ANSWER: <your correct answer here>\n"
        "Do not include any other text."
    )
    for attempt in range(2):
        res = _call_llm(client, model, prompt, temperature=0.3)
        if logs is not None: logs.append({"stage": f"QA Generation (Attempt {attempt+1})", "prompt": prompt, "response": res})
        
        q_match = re.search(r"QUESTION:\s*(.+?)(?=\nANSWER:|$)", res, re.IGNORECASE | re.DOTALL)
        a_match = re.search(r"ANSWER:\s*(.+)", res, re.IGNORECASE | re.DOTALL)
        
        if q_match and a_match:
            return q_match.group(1).strip(), a_match.group(1).strip()
            
    # Fallback if regex fails completely
    return f"What is true regarding: {fact}?", "It is a verified fact from the text."

def _generate_distractors(client: OpenAI, model: str, question: str, answer: str, logs: list = None) -> list[str]:
    prompt = (
        f"Question: {question}\nCorrect Answer: {answer}\n\n"
        "Generate exactly 3 plausible but INCORRECT options (distractors) for this question.\n"
        "Output ONLY the 3 distractors as a bulleted list starting with '- '.\n"
        "Do not include the correct answer or any introductory text."
    )
    for attempt in range(2):
        res = _call_llm(client, model, prompt, temperature=0.6)
        if logs is not None: logs.append({"stage": f"Distractor Generation (Attempt {attempt+1})", "prompt": prompt, "response": res})
        
        distractors = []
        for line in res.split("\n"):
            line = line.strip()
            if line.startswith("-") or line.startswith("*"):
                distractors.append(line.lstrip("-*").strip())
                
        if len(distractors) >= 3:
            return distractors[:3]
            
    # Fallback
    return ["All of the above", "None of the above", "Cannot be determined"]

def generate_mcq_multistage(client: OpenAI, model: str, chunk: str, num_questions: int = 3, logs: list = None) -> list[dict]:
    """Execute the robust multi-stage pipeline."""
    mcqs = []
    
    # 1. Extract facts
    facts = _extract_facts(client, model, chunk, num_facts=num_questions, logs=logs)
    
    for fact in facts:
        if not fact: continue
        
        # 2. Q & A
        question, answer = _generate_qa(client, model, fact, logs=logs)
        
        # 3. Distractors
        distractors = _generate_distractors(client, model, question, answer, logs=logs)
        
        # Assemble
        import random
        options = [answer] + distractors
        # Pad if short
        while len(options) < 4: options.append("Invalid Option")
        options = options[:4]
        
        random.shuffle(options)
        correct_idx = options.index(answer)
        correct_letter = ["A", "B", "C", "D"][correct_idx]
        
        mcqs.append({
            "question_text": question,
            "option_a": options[0],
            "option_b": options[1],
            "option_c": options[2],
            "option_d": options[3],
            "correct_option": correct_letter,
            "explanation": f"Based on the fact: {fact}"
        })
        
    return mcqs

# --- Simple Mode (JSON Schema Enforced) ---

def generate_mcq_simple(client: OpenAI, model: str, chunk: str, num_questions: int = 3, logs: list = None) -> list[dict]:
    """Use the model's native JSON output capability."""
    prompt = (
        f"Generate exactly {num_questions} NEET-level multiple choice questions based on the following text.\n\n"
        f"TEXT:\n{chunk}"
    )
    
    # For Ollama >= 0.3.0, we can pass a strict JSON schema
    schema = MCQListSchema.model_json_schema()
    
    res = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3,
        response_format={
            "type": "json_schema",
            "json_schema": {
                "name": "mcq_list",
                "schema": schema,
                "strict": True
            }
        },
        extra_body={"think": False} # Prevent reasoning tokens from breaking JSON parsing
    )
    
    raw_json = res.choices[0].message.content
    if logs is not None: logs.append({"stage": "Simple Mode JSON", "prompt": prompt, "response": raw_json})
    
    import json
    try:
        data = json.loads(raw_json)
        return data.get("mcqs", [])
    except Exception as e:
        logger.error(f"Failed to parse JSON: {e}")
        if logs is not None: logs.append({"stage": "Error", "prompt": "", "response": f"JSON Parse Error: {e}"})
        return []
