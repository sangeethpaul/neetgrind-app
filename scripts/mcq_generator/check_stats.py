import os
from collections import defaultdict
from pathlib import Path
from supabase import create_client

import config as cfg

def count_pdfs():
    print("--- PDF COUNTS ---")
    total_pdfs = 0
    for subject in ["Biology", "Physics", "Chemistry"]:
        subject_dir = cfg.NCERT_LIBRARY / subject
        if not subject_dir.exists():
            continue
        count11 = len(list((subject_dir / "Class_11").glob("*.pdf"))) if (subject_dir / "Class_11").exists() else 0
        count12 = len(list((subject_dir / "Class_12").glob("*.pdf"))) if (subject_dir / "Class_12").exists() else 0
        total_pdfs += count11 + count12
        print(f"{subject}: {count11 + count12} PDFs (Class 11: {count11}, Class 12: {count12})")
    print(f"Total PDFs: {total_pdfs}\n")

def count_mcqs():
    print("--- MCQ COUNTS IN DB ---")
    client = create_client(cfg.SUPABASE_URL, cfg.SUPABASE_KEY)
    
    # Get all subjects
    subjects_res = client.table("subjects").select("id, name").execute()
    subjects = {s['id']: s['name'] for s in subjects_res.data}
    
    # Get all topics
    topics_res = client.table("topics").select("id, subject_id, name").execute()
    topics = {t['id']: {'name': t['name'], 'subject_id': t['subject_id']} for t in topics_res.data}
    
    # Get MCQ counts (Supabase PostgREST allows counting, or we can just fetch all and group)
    mcqs_res = client.table("questions").select("topic_id").execute()
    
    mcq_counts = defaultdict(int)
    for q in mcqs_res.data:
        mcq_counts[q['topic_id']] += 1
        
    subject_counts = defaultdict(int)
    
    if not mcqs_res.data:
        print("0 MCQs found in the database.")
        return

    for topic_id, count in mcq_counts.items():
        if topic_id in topics:
            topic_name = topics[topic_id]['name']
            subject_id = topics[topic_id]['subject_id']
            subject_name = subjects.get(subject_id, "Unknown")
            subject_counts[subject_name] += count
            
    for subject_name, total in subject_counts.items():
        print(f"\nSubject: {subject_name} (Total MCQs: {total})")
        for topic_id, count in mcq_counts.items():
            if topic_id in topics and subjects.get(topics[topic_id]['subject_id']) == subject_name:
                print(f"  - {topics[topic_id]['name']}: {count} MCQs")
                
    print(f"\nTotal MCQs: {sum(subject_counts.values())}")

if __name__ == "__main__":
    count_pdfs()
    count_mcqs()
