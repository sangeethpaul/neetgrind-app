import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Load credentials
root_env = Path("/Users/chennainest/NEETcoach/neet-coach-app/.env.local")
load_dotenv(root_env)

SUPABASE_URL = os.environ.get("SUPABASE_URL", os.environ.get("NEXT_PUBLIC_SUPABASE_URL", ""))
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", os.environ.get("SUPABASE_KEY", ""))

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Error: Missing SUPABASE_URL or SUPABASE_KEY in environment.")
    sys.exit(1)

try:
    from supabase import create_client, Client
except ImportError:
    print("❌ Error: 'supabase' package is not installed. Install via pip install supabase.")
    sys.exit(1)

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def parse_markdown(filepath):
    subjects_map = {
        "Biology": "biology",
        "Physics": "physics",
        "Chemistry": "chemistry"
    }
    curriculum = {}
    current_subject = None
    current_class = None

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith("## "):
                # Subject header, e.g. "## 🧬 Biology"
                parts = line.replace("## ", "").split()
                if parts:
                    subject_name = parts[-1].strip()
                    if subject_name in subjects_map:
                        current_subject = subjects_map[subject_name]
                        curriculum[current_subject] = {}
            elif line.startswith("### Class "):
                current_class = int(line.replace("### Class ", "").strip())
                if current_subject:
                    curriculum[current_subject][current_class] = []
            elif line and line[0].isdigit() and "." in line:
                parts = line.split(".", 1)
                try:
                    chap_num = int(parts[0].strip())
                    title = parts[1].strip()
                    if current_subject and current_class is not None:
                        curriculum[current_subject][current_class].append((chap_num, title))
                except ValueError:
                    pass
    return curriculum

def main():
    ref_path = Path("/Users/chennainest/.gemini/antigravity/brain/b2742669-e704-427a-9230-04542203ce44/ncert_chapters_reference.md")
    if not ref_path.exists():
        print(f"❌ Error: Reference file {ref_path} not found.")
        sys.exit(1)

    curriculum = parse_markdown(ref_path)
    
    # Verify Biology Class 11 parsed correctly
    bio_11 = curriculum.get("biology", {}).get(11, [])
    if len(bio_11) != 22:
        print(f"❌ Error: Expected 22 chapters for Biology Class 11, found {len(bio_11)}.")
        sys.exit(1)

    print("🚀 Generating SQL script for Database Syllabus Realignment & Descriptive Naming...")

    # Custom mapping of Biology Class 11 PDFs
    bio_11_pdf_map = {
        1: "kebo101.pdf",
        2: "kebo102.pdf",
        3: "kebo103.pdf",
        4: "kebo104.pdf",
        5: "kebo105.pdf",
        6: "kebo106.pdf",
        7: "kebo107.pdf",
        8: "kebo108.pdf",
        9: "kebo109.pdf",
        10: "kebo110.pdf",
        13: "kebo111.pdf",
        14: "kebo112.pdf",
        15: "kebo113.pdf",
        17: "kebo114.pdf",
        18: "kebo115.pdf",
        19: "kebo116.pdf",
        20: "kebo117.pdf",
        21: "kebo118.pdf",
        22: "kebo119.pdf"
    }

    sql_lines = [
        "-- ============================================================",
        "-- SYLLABUS REALIGNMENT & DESCRIPTIVE CHAPTER TITLES",
        "-- Auto-generated migration script",
        "-- ============================================================",
        "BEGIN;"
    ]

    # Step 1: Biology Class 11 slug updates (reverse order to avoid unique constraints)
    rename_mapping = [
        (19, 22), (18, 21), (17, 20), (16, 19), (15, 18), (14, 17), (13, 15), (12, 14), (11, 13)
    ]

    sql_lines.append("\n-- Step 1: Realign Biology Class 11 sequential slugs in reverse order")
    for old_ch, new_ch in rename_mapping:
        old_slug = f"biology-class-11-ch-{old_ch}"
        new_slug = f"biology-class-11-ch-{new_ch}"
        title = [t for num, t in bio_11 if num == new_ch][0].replace("'", "''")
        
        sql_lines.append(
            f"UPDATE public.topics SET "
            f"slug = '{new_slug}', "
            f"name = '{title}', "
            f"description = 'NCERT Topic for Biology Class 11 — {title}' "
            f"WHERE slug = '{old_slug}';"
        )

    # Step 2: Insert missing chapters for Biology Class 11
    sql_lines.append("\n-- Step 2: Insert missing traditional chapters for Biology Class 11")
    missing_ch_list = [11, 12, 16]
    for ch in missing_ch_list:
        slug = f"biology-class-11-ch-{ch}"
        title = [t for num, t in bio_11 if num == ch][0].replace("'", "''")
        sql_lines.append(
            f"INSERT INTO public.topics (subject_id, slug, name, description) "
            f"VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), "
            f"'{slug}', '{title}', 'NCERT Topic for Biology Class 11 — {title}') "
            f"ON CONFLICT (slug) DO UPDATE SET name = '{title}';"
        )

    # Step 3: Update descriptive names for all other topics across all subjects
    sql_lines.append("\n-- Step 3: Update all topic names and descriptions across all subjects")
    for subject, classes in curriculum.items():
        for class_num, chapters in classes.items():
            for ch_num, title in chapters:
                slug = f"{subject}-class-{class_num}-ch-{ch_num}"
                title_escaped = title.replace("'", "''")
                
                # Check if it's already one of the inserted missing chapters to avoid redundant work
                if subject == "biology" and class_num == 11 and ch_num in missing_ch_list:
                    continue
                    
                sql_lines.append(
                    f"UPDATE public.topics SET "
                    f"name = '{title_escaped}', "
                    f"description = 'NCERT Topic for {subject.capitalize()} Class {class_num} — {title_escaped}' "
                    f"WHERE slug = '{slug}';"
                )

    # Step 4: Align public.ncert_content pdf_urls and titles
    sql_lines.append("\n-- Step 4: Align public.ncert_content titles and pdf_urls")
    for subject, classes in curriculum.items():
        for class_num, chapters in classes.items():
            for ch_num, title in chapters:
                slug = f"{subject}-class-{class_num}-ch-{ch_num}"
                title_escaped = title.replace("'", "''")
                ncert_title = f"{title_escaped} — NCERT PDF"
                
                # Biology Class 11 specific mapping
                if subject == "biology" and class_num == 11:
                    pdf_file = bio_11_pdf_map.get(ch_num)
                    if pdf_file:
                        pdf_url = f"'/pdfs/Biology/Class_11/{pdf_file}'"
                        markdown_body = "'PDF Viewer Only'"
                    else:
                        pdf_url = "NULL"
                        markdown_body = "'NCERT PDF is not available online for this deleted/rationalized chapter. However, MCQ practice remains fully supported.'"
                    
                    # Delete if exists, then insert
                    sql_lines.append(
                        f"DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = '{slug}');"
                    )
                    sql_lines.append(
                        f"INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) "
                        f"VALUES ((SELECT id FROM public.topics WHERE slug = '{slug}'), '{ncert_title}', {markdown_body}, {pdf_url});"
                    )
                else:
                    # For all other subjects, update title if already exists, else insert with placeholder pdf_url
                    # We can use COALESCE/SELECT to match what migrate_curriculum.py generated
                    # Let's just update the title where topic_id matches
                    sql_lines.append(
                        f"UPDATE public.ncert_content SET title = '{ncert_title}' "
                        f"WHERE topic_id = (SELECT id FROM public.topics WHERE slug = '{slug}');"
                    )

    sql_lines.append("COMMIT;")

    sql_content = "\n".join(sql_lines)
    sql_file_path = Path("/Users/chennainest/NEETcoach/neet-coach-app/scripts/migrate_descriptive_titles.sql")
    sql_file_path.write_text(sql_content, encoding="utf-8")
    print(f"✅ Generated SQL migration script at: {sql_file_path}")

if __name__ == "__main__":
    main()
