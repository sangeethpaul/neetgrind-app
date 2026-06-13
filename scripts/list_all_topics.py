import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Load credentials
root_env = Path("/Users/chennainest/NEETcoach/neet-coach-app/.env.local")
load_dotenv(root_env)

SUPABASE_URL = os.environ.get("SUPABASE_URL", os.environ.get("NEXT_PUBLIC_SUPABASE_URL", ""))
SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Error: Missing SUPABASE_URL or SUPABASE_KEY.")
    sys.exit(1)

try:
    from supabase import create_client, Client
except ImportError:
    print("❌ Error: supabase package not installed.")
    sys.exit(1)

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def list_topics():
    # Fetch all subjects
    sub_res = supabase.table("subjects").select("id, name, slug").order("id").execute()
    subjects = sub_res.data
    
    # Fetch all topics
    topics_res = supabase.table("topics").select("id, name, slug, subject_id").execute()
    topics = topics_res.data
    
    for subject in subjects:
        print(f"\n==================================================")
        print(f"SUBJECT: {subject['name']}")
        print(f"==================================================")
        
        subject_topics = [t for t in topics if t["subject_id"] == subject["id"]]
        
        # Group by class
        for class_num in ["11", "12"]:
            class_topics = [t for t in subject_topics if f"-class-{class_num}-" in t["slug"]]
            
            def get_ch_num(t):
                try:
                    return int(t["slug"].split("-ch-")[-1])
                except ValueError:
                    return 999
            
            class_topics.sort(key=get_ch_num)
            
            print(f"\n--- Class {class_num} ---")
            for t in class_topics:
                ch = t["slug"].split("-ch-")[-1]
                print(f"Chapter {ch}: {t['name']}")

if __name__ == "__main__":
    list_topics()
