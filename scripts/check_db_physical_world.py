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

def check():
    res = supabase.table("topics").select("*, ncert_content(*)").eq("slug", "physics-class-11-ch-1").execute()
    print("Database Record for physics-class-11-ch-1:")
    print(res.data)

if __name__ == "__main__":
    check()
