import os
import shutil

SOURCE_DIR = "scripts/ncert_downloader/ncert_library"
DEST_DIR = "public/pdfs"

def migrate():
    print("Starting migration...")
    
    subjects_map = {
        "Physics": "physics",
        "Chemistry": "chemistry",
        "Biology": "biology"
    }

    if not os.path.exists(DEST_DIR):
        os.makedirs(DEST_DIR)

    topics_sql = "-- ============================================================\n-- TOPICS\n-- ============================================================\nINSERT INTO public.topics (subject_id, name, slug, description) VALUES\n"
    content_sql = "-- ============================================================\n-- NCERT CONTENT (PDFs)\n-- ============================================================\nINSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES\n"

    topic_id = 1
    topic_values = []
    content_values = []

    for subject in os.listdir(SOURCE_DIR):
        subject_dir = os.path.join(SOURCE_DIR, subject)
        if not os.path.isdir(subject_dir): continue

        for class_name in os.listdir(subject_dir):
            class_dir = os.path.join(subject_dir, class_name)
            if not os.path.isdir(class_dir): continue

            # Create destination dirs
            dest_subject_dir = os.path.join(DEST_DIR, subject, class_name)
            os.makedirs(dest_subject_dir, exist_ok=True)

            # Sort PDFs
            pdfs = sorted([f for f in os.listdir(class_dir) if f.endswith(".pdf")])
            for idx, pdf in enumerate(pdfs):
                src_path = os.path.join(class_dir, pdf)
                dest_path = os.path.join(dest_subject_dir, pdf)
                
                # Copy file
                shutil.copy2(src_path, dest_path)

                chapter_num = idx + 1
                topic_name = f"{subject} {class_name.replace('_', ' ')} - Chapter {chapter_num}"
                topic_slug = f"{subjects_map[subject]}-{class_name.lower().replace('_', '-')}-ch-{chapter_num}"
                public_url = f"/pdfs/{subject}/{class_name}/{pdf}"

                # Topic SQL
                topic_values.append(f"  ((SELECT id FROM public.subjects WHERE slug = '{subjects_map[subject]}'), '{topic_name}', '{topic_slug}', 'NCERT PDF for {topic_name}')")

                # Content SQL (markdown_body is required but we'll use pdf_url primarily, so we provide empty string or short note for markdown_body)
                content_values.append(f"({topic_id}, '{topic_name} — NCERT PDF', 'PDF Viewer Only', '{public_url}')")
                
                topic_id += 1

    topics_sql += ",\n".join(topic_values) + "\nON CONFLICT (slug) DO NOTHING;\n\n"
    content_sql += ",\n".join(content_values) + ";\n\n"

    print(f"Generated {topic_id - 1} topics.")

    # Write SQL to a file for manual review / integration
    with open("generated_seed.sql", "w") as f:
        f.write(topics_sql)
        f.write(content_sql)
        
    print("Migration script completed. Data written to generated_seed.sql")

if __name__ == "__main__":
    migrate()
