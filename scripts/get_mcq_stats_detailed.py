import os
import sys
from pathlib import Path
from collections import defaultdict
from dotenv import load_dotenv

root_env = Path("/Users/chennainest/NEETcoach/neet-coach-app/.env.local")
load_dotenv(root_env)

SUPABASE_URL = os.environ.get("SUPABASE_URL", os.environ.get("NEXT_PUBLIC_SUPABASE_URL", ""))
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Error: Missing SUPABASE_URL or SUPABASE_KEY.")
    sys.exit(1)

from supabase import create_client

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def generate_report():
    # Fetch subjects
    sub_res = supabase.table("subjects").select("id, name, slug").order("id").execute()
    subjects = {s['id']: s for s in sub_res.data}
    
    # Fetch topics
    topics_res = supabase.table("topics").select("id, name, slug, subject_id").execute()
    topics = topics_res.data
    
    # Fetch all questions to count per topic
    questions_res = supabase.table("questions").select("topic_id").execute()
    mcq_counts = defaultdict(int)
    for q in questions_res.data:
        mcq_counts[q['topic_id']] += 1
        
    print("# NEETcoach MCQ Status Report\n")
    
    for sub_id, sub_info in sorted(subjects.items()):
        print(f"## {sub_info['name']}")
        print("=" * len(sub_info['name']))
        
        sub_topics = [t for t in topics if t["subject_id"] == sub_id]
        
        for class_num in ["11", "12"]:
            class_topics = [t for t in sub_topics if f"-class-{class_num}-" in t["slug"]]
            
            def get_ch_num(t):
                try:
                    return int(t["slug"].split("-ch-")[-1])
                except ValueError:
                    return 999
            
            class_topics.sort(key=get_ch_num)
            
            if not class_topics:
                continue
                
            print(f"\n### Class {class_num}")
            
            completed = []
            pending = []
            
            for t in class_topics:
                ch = t["slug"].split("-ch-")[-1]
                count = mcq_counts[t["id"]]
                info_str = f"Chapter {ch}: **{t['name']}** ({count} MCQs)"
                if count > 0:
                    completed.append(info_str)
                else:
                    pending.append(f"Chapter {ch}: **{t['name']}**")
                    
            print("\n**✅ Completed / In Progress:**")
            if completed:
                for item in completed:
                    print(f"- {item}")
            else:
                print("- *None*")
                
            print("\n**⏳ Yet to be created:**")
            if pending:
                for item in pending:
                    print(f"- {item}")
            else:
                print("- *None*")
            print()

if __name__ == "__main__":
    generate_report()
