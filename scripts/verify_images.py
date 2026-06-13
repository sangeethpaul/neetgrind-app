import re
import sys
from pathlib import Path

def verify():
    page_path = Path("/Users/chennainest/NEETcoach/neet-coach-app/src/app/dashboard/study/page.tsx")
    if not page_path.exists():
        print("❌ page.tsx does not exist!")
        sys.exit(1)
        
    content = page_path.read_text(encoding="utf-8")
    
    # Extract physicsPhotos array
    phys_match = re.search(r"const physicsPhotos = \[(.*?)\];", content, re.DOTALL)
    chem_match = re.search(r"const chemistryPhotos = \[(.*?)\];", content, re.DOTALL)
    bio_match = re.search(r"const biologyPhotos = \[(.*?)\];", content, re.DOTALL)
    
    if not (phys_match and chem_match and bio_match):
        print("❌ Could not extract all photo arrays!")
        sys.exit(1)
        
    def extract_urls(match_str):
        urls = []
        for line in match_str.split("\n"):
            line = line.strip()
            # extract string literal in quotes
            u = re.findall(r'"([^"]*)"', line)
            if u:
                urls.append(u[0])
        return urls

    phys_urls = extract_urls(phys_match.group(1))
    chem_urls = extract_urls(chem_match.group(1))
    bio_urls = extract_urls(bio_match.group(1))
    
    print(f"Physics images count: {len(phys_urls)} (Expected: 30)")
    print(f"Chemistry images count: {len(chem_urls)} (Expected: 30)")
    print(f"Biology images count: {len(bio_urls)} (Expected: 38)")
    
    errors = 0
    if len(phys_urls) != 30:
        print("❌ Physics count is not 30!")
        errors += 1
    if len(chem_urls) != 30:
        print("❌ Chemistry count is not 30!")
        errors += 1
    if len(bio_urls) != 38:
        print("❌ Biology count is not 38!")
        errors += 1
        
    # Check uniqueness
    all_urls = phys_urls + chem_urls + bio_urls
    seen = set()
    duplicates = set()
    for u in all_urls:
        if u in seen:
            duplicates.add(u)
        seen.add(u)
        
    if duplicates:
        print(f"❌ Found duplicate URLs ({len(duplicates)}):")
        for d in duplicates:
            print(f"  - {d}")
        errors += 1
    else:
        print("✅ No duplicate URLs found across all subjects! Uniqueness is guaranteed.")
        
    if errors > 0:
        sys.exit(1)
    else:
        print("🎉 Verification passed!")

if __name__ == "__main__":
    verify()
