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

def verify():
    print("=== Verification of Biology Class 11 Topics ===")
    
    # Query topics and ncert_content
    topics_res = supabase.table("topics").select("id, name, slug, description").eq("subject_id", 3).execute()
    topics = topics_res.data
    
    # Filter class 11
    bio_11_topics = [t for t in topics if "class-11" in t["slug"]]
    
    # Sort by chapter number from slug
    def get_ch_num(t):
        try:
            return int(t["slug"].split("-ch-")[-1])
        except ValueError:
            return 999
            
    bio_11_topics.sort(key=get_ch_num)
    
    print(f"Found {len(bio_11_topics)} topics for Biology Class 11:")
    print(f"{'Chapter':<8} | {'Slug':<25} | {'Topic Name':<45} | {'PDF URL':<40}")
    print("-" * 125)
    
    for t in bio_11_topics:
        ch_num = t["slug"].split("-ch-")[-1]
        # Fetch ncert_content for this topic
        content_res = supabase.table("ncert_content").select("title, pdf_url").eq("topic_id", t["id"]).execute()
        pdf_url = "None"
        if content_res.data:
            pdf_url = content_res.data[0]["pdf_url"] or "None"
        print(f"{ch_num:<8} | {t['slug']:<25} | {t['name']:<45} | {pdf_url:<40}")

if __name__ == "__main__":
    verify()
