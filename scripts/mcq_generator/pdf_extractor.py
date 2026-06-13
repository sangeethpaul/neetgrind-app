"""
pdf_extractor.py — Extract and clean text from NCERT PDF chapters.

Uses PyMuPDF (fitz) which handles NCERT's multi-column layouts well.
Strips headers, footers, page numbers, and normalises whitespace.
"""

from __future__ import annotations
import re
from pathlib import Path

try:
    import fitz  # PyMuPDF
except ImportError:
    raise ImportError(
        "PyMuPDF not installed. Run: pip install pymupdf"
    )


# ── Token counting helper (rough: 1 token ≈ 4 chars) ─────────────────────────
def _count_tokens_rough(text: str) -> int:
    return len(text) // 4


def _clean_text(raw: str) -> str:
    """Remove NCERT-specific noise from extracted PDF text."""
    lines = raw.split("\n")
    cleaned = []

    for line in lines:
        line = line.strip()

        # Skip blank lines
        if not line:
            continue

        # Skip pure page numbers (e.g. "45", "Chapter 3")
        if re.fullmatch(r"\d{1,3}", line):
            continue

        # Skip NCERT header/footer patterns
        if re.match(
            r"^(NCERT|National Council|©|Reprint|Not for|www\.ncert)", line, re.I
        ):
            continue

        # Skip very short fragmented lines (column break artefacts)
        if len(line) < 4:
            continue

        cleaned.append(line)

    # Collapse multiple blank lines
    text = "\n".join(cleaned)
    text = re.sub(r"\n{3,}", "\n\n", text)

    # Normalise whitespace within lines
    text = re.sub(r"[ \t]{2,}", " ", text)

    return text.strip()


def extract_chapter_text(pdf_path: Path | str) -> str:
    """
    Extract all text from an NCERT chapter PDF.

    Returns:
        Cleaned text string ready for the LLM pipeline.
    """
    pdf_path = Path(pdf_path)
    if not pdf_path.exists():
        raise FileNotFoundError(f"PDF not found: {pdf_path}")

    doc = fitz.open(str(pdf_path))
    raw_pages = []

    for page in doc:
        # Use "text" mode for simple extraction; handles most NCERT layouts
        raw_pages.append(page.get_text("text"))  # type: ignore[attr-defined]

    doc.close()
    raw = "\n".join(raw_pages)
    return _clean_text(raw)


def chunk_text(
    text: str,
    max_tokens: int = 3000,
    overlap_tokens: int = 200,
) -> list[str]:
    """
    Split long chapter text into overlapping chunks so no fact spans a boundary.

    Args:
        text:           Full chapter text.
        max_tokens:     Rough token limit per chunk (1 token ≈ 4 chars).
        overlap_tokens: Tokens of overlap between chunks for context continuity.

    Returns:
        List of text chunks.
    """
    max_chars = max_tokens * 4
    overlap_chars = overlap_tokens * 4

    if len(text) <= max_chars:
        return [text]

    chunks: list[str] = []
    start = 0

    while start < len(text):
        end = start + max_chars

        # Try to break at a paragraph boundary
        if end < len(text):
            para_break = text.rfind("\n\n", start, end)
            if para_break != -1 and para_break > start + max_chars // 2:
                end = para_break

        chunks.append(text[start:end].strip())
        start = end - overlap_chars

    return [c for c in chunks if len(c) > 100]  # drop tiny trailing chunks


def get_chapter_title(pdf_path: Path | str) -> str:
    """
    Extract the chapter title from the first page of the PDF.
    Falls back to the filename stem if extraction fails.
    """
    pdf_path = Path(pdf_path)
    try:
        doc = fitz.open(str(pdf_path))
        first_page_text = doc[0].get_text("text")  # type: ignore[attr-defined]
        doc.close()

        lines = [l.strip() for l in first_page_text.split("\n") if l.strip()]
        # The chapter title is usually one of the first non-trivial lines
        for line in lines[:15]:
            if len(line) > 8 and not re.match(r"^\d", line):
                return line[:80]
    except Exception:
        pass

    return pdf_path.stem.upper()
