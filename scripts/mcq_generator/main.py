#!/usr/bin/env python3
"""
main.py — CLI entrypoint for the NEETcoach MCQ Generator.

Usage examples:
  python main.py --dry-run --subject Biology --class 11
  python main.py --subject Biology --class 11
  python main.py --subject all
  python main.py --pdf kebo101.pdf
  python main.py --subject Physics --sql-only
"""

from __future__ import annotations
import argparse
import logging
import sys
import time
from pathlib import Path
from collections import defaultdict

# Add script directory to path so relative imports work
sys.path.insert(0, str(Path(__file__).parent))

from tqdm import tqdm

import config as cfg
from config import CHAPTER_TOPIC_MAP, NCERT_LIBRARY, validate_config
from pipeline import process_chapter
from db_writer import write_mcqs
from schemas import MCQRecord

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s │ %(levelname)s │ %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)

# ── Subject → folder name mapping ────────────────────────────────────────────
SUBJECT_FOLDERS = {
    "biology":   "Biology",
    "physics":   "Physics",
    "chemistry": "Chemistry",
}


def discover_pdfs(
    subject_filter: str | None,
    class_filter: str | None,
    single_pdf: str | None,
) -> list[tuple[Path, str, str]]:
    """
    Returns list of (pdf_path, subject, chapter_code) tuples to process.
    """
    results: list[tuple[Path, str, str]] = []

    if single_pdf:
        # --pdf mode: find the PDF anywhere in the library
        for subject_dir in NCERT_LIBRARY.iterdir():
            if not subject_dir.is_dir():
                continue
            for class_dir in subject_dir.iterdir():
                if not class_dir.is_dir():
                    continue
                pdf_path = class_dir / single_pdf
                if pdf_path.exists():
                    code = pdf_path.stem  # e.g. "kebo101"
                    return [(pdf_path, subject_dir.name, code)]
        logger.error(f"❌ PDF not found in library: {single_pdf}")
        return []

    for subject_name, folder_name in SUBJECT_FOLDERS.items():
        if subject_filter and subject_filter.lower() not in ("all", subject_name):
            continue

        subject_dir = NCERT_LIBRARY / folder_name
        if not subject_dir.exists():
            logger.warning(f"⚠️  Subject directory not found: {subject_dir}")
            continue

        for class_dir in sorted(subject_dir.iterdir()):
            if not class_dir.is_dir():
                continue

            # Filter by class (e.g. "11" matches "Class_11")
            if class_filter and f"Class_{class_filter}" != class_dir.name:
                continue

            for pdf_path in sorted(class_dir.glob("*.pdf")):
                code = pdf_path.stem  # e.g. "kebo101"
                results.append((pdf_path, folder_name, code))

    return results


def resolve_topic_id(topic_slug: str, supabase_url: str, supabase_key: str) -> int | None:
    """Look up topic_id from Supabase by slug (cached in a module-level dict)."""
    cache = _topic_id_cache()
    if topic_slug in cache:
        return cache[topic_slug]

    try:
        from supabase import create_client
        client = create_client(supabase_url, supabase_key)
        result = (
            client.table("topics")
            .select("id")
            .eq("slug", topic_slug)
            .limit(1)
            .execute()
        )
        if result.data and len(result.data) > 0:
            tid = result.data[0]["id"]
            cache[topic_slug] = tid
            return tid
    except Exception as e:
        logger.debug(f"Topic lookup failed for '{topic_slug}': {e}")

    return None


_TOPIC_ID_CACHE: dict[str, int] = {}


def _topic_id_cache() -> dict[str, int]:
    return _TOPIC_ID_CACHE


def main() -> None:
    parser = argparse.ArgumentParser(
        description="NEETcoach MCQ Generator — COLING 2025 three-stage pipeline",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main.py --dry-run --subject Biology --class 11
  python main.py --subject Biology --class 12
  python main.py --subject all
  python main.py --pdf kebo101.pdf
  python main.py --subject Physics --sql-only
        """,
    )
    parser.add_argument("--subject", default="all",
                        choices=["all", "Biology", "Physics", "Chemistry"],
                        help="Subject to process (default: all)")
    parser.add_argument("--class", dest="class_num",
                        choices=["11", "12"],
                        help="Class to process (default: both)")
    parser.add_argument("--pdf", metavar="FILENAME",
                        help="Process a single PDF (e.g. kebo101.pdf)")
    parser.add_argument("--dry-run", action="store_true",
                        help="Run pipeline without LLM calls or DB writes (test mode)")
    parser.add_argument("--sql-only", action="store_true",
                        help="Generate SQL file only, skip Supabase API write")
    parser.add_argument("--mcq-count", type=int, default=cfg.MCQ_PER_CHAPTER,
                        help=f"MCQs per chapter (default: {cfg.MCQ_PER_CHAPTER})")
    parser.add_argument("--verbose", "-v", action="store_true",
                        help="Show debug-level output")

    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    # ── Validate environment ──────────────────────────────────────────────────
    if not args.dry_run:
        try:
            validate_config()
        except EnvironmentError as e:
            logger.error(str(e))
            sys.exit(1)

    # ── Discover PDFs ─────────────────────────────────────────────────────────
    pdfs = discover_pdfs(
        subject_filter=args.subject if args.subject != "all" else None,
        class_filter=args.class_num,
        single_pdf=args.pdf,
    )

    if not pdfs:
        logger.error("❌ No PDF files found matching the given filters.")
        sys.exit(1)

    logger.info(f"\n{'='*60}")
    logger.info(f"  🚀 NEETcoach MCQ Generator")
    logger.info(f"  📚 PDFs to process : {len(pdfs)}")
    logger.info(f"  🎯 MCQs per chapter: {args.mcq_count}")
    active_model = cfg.OLLAMA_MODEL if cfg.LLM_PROVIDER == "ollama" else cfg.GEMINI_MODEL
    logger.info(f"  🤖 Provider/Model  : {cfg.LLM_PROVIDER.upper()} / {active_model}")
    logger.info(f"  {'🔍 DRY RUN MODE — no LLM / DB writes' if args.dry_run else '✅ LIVE MODE'}")
    logger.info(f"{'='*60}\n")

    # ── Main processing loop ──────────────────────────────────────────────────
    all_mcqs: list[MCQRecord] = []
    stats: dict = defaultdict(int)
    failed_chapters: list[str] = []

    with tqdm(pdfs, desc="Processing chapters", unit="ch") as pbar:
        for pdf_path, subject, chapter_code in pbar:
            pbar.set_postfix({"file": pdf_path.name, "mcqs": len(all_mcqs)})

            # Look up topic slug and ID
            topic_slug = CHAPTER_TOPIC_MAP.get(chapter_code)
            if not topic_slug:
                logger.warning(f"  ⚠️  No topic mapping for '{chapter_code}' — skipping")
                stats["skipped"] += 1
                continue

            # Resolve topic_id from Supabase (or use 0 for dry-run)
            topic_id = 0
            if not args.dry_run:
                topic_id = resolve_topic_id(topic_slug, cfg.SUPABASE_URL, cfg.SUPABASE_KEY)
                if topic_id is None:
                    logger.warning(
                        f"  ⚠️  Topic slug '{topic_slug}' not found in DB — skipping"
                    )
                    stats["skipped"] += 1
                    continue

            logger.info(f"\n📂 {subject} │ {pdf_path.name} → topic '{topic_slug}' (id={topic_id})")

            try:
                start = time.time()
                mcqs = process_chapter(
                    pdf_path,
                    topic_id,
                    subject,
                    target_mcqs=args.mcq_count,
                    dry_run=args.dry_run,
                )
                elapsed = time.time() - start

                all_mcqs.extend(mcqs)
                stats["chapters_processed"] += 1
                stats["total_mcqs"] += len(mcqs)
                logger.info(f"  ⏱️  {elapsed:.1f}s | {len(mcqs)} MCQs generated")

            except Exception as e:
                logger.error(f"  ❌ Failed: {pdf_path.name} → {e}")
                failed_chapters.append(pdf_path.name)
                stats["failed"] += 1
                continue

    # ── Write results ─────────────────────────────────────────────────────────
    if all_mcqs:
        logger.info(f"\n{'='*60}")
        logger.info("  📝 Writing MCQs...")
        subject_label = args.subject.lower().replace(" ", "_")
        write_result = write_mcqs(
            all_mcqs,
            supabase_url=cfg.SUPABASE_URL,
            supabase_key=cfg.SUPABASE_KEY,
            label=subject_label,
            dry_run=args.dry_run,
            sql_only=args.sql_only,
        )
    else:
        write_result = {"total_mcqs": 0, "sql_file": None}

    # ── Final Report ──────────────────────────────────────────────────────────
    logger.info(f"\n{'='*60}")
    logger.info("  📊 GENERATION SUMMARY")
    logger.info(f"{'='*60}")
    logger.info(f"  Chapters processed : {stats['chapters_processed']}")
    logger.info(f"  Chapters skipped   : {stats['skipped']}")
    logger.info(f"  Chapters failed    : {stats['failed']}")
    logger.info(f"  Total MCQs         : {write_result['total_mcqs']}")
    if not args.dry_run:
        logger.info(f"  DB inserted        : {write_result.get('db_inserted', 0)}")
        logger.info(f"  DB skipped (dupes) : {write_result.get('db_skipped', 0)}")
    if write_result.get("sql_file"):
        logger.info(f"  SQL backup         : {write_result['sql_file']}")
    if failed_chapters:
        logger.warning(f"\n  ⚠️  Failed chapters: {', '.join(failed_chapters)}")
    logger.info(f"{'='*60}\n")

    if stats["failed"] > 0 and stats["chapters_processed"] == 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
