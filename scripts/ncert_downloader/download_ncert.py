import os
import requests
from tqdm import tqdm

# Mapping of NEET Essential Books
# Format: {Subject: {Class: [Book Codes]}}
BOOKS = {
    "Biology": {
        "11": ["kebo1"], # Class 11 Biology
        "12": ["lebo1"], # Class 12 Biology
    },
    "Physics": {
        "11": ["keph1", "keph2"], # Class 11 Part 1 & 2
        "12": ["leph1", "leph2"], # Class 12 Part 1 & 2
    },
    "Chemistry": {
        "11": ["kech1", "kech2"], # Class 11 Part 1 & 2
        "12": ["lech1", "lech2"], # Class 12 Part 1 & 2
    }
}

BASE_URL = "https://ncert.nic.in/textbook/pdf/"
OUTPUT_DIR = "ncert_library"

def download_file(url, folder, filename):
    local_filename = os.path.join(folder, filename)
    if os.path.exists(local_filename):
        print(f"  [Skipped] {filename} already exists.")
        return

    try:
        response = requests.get(url, stream=True, timeout=10)
        if response.status_code == 200:
            total_size = int(response.headers.get('content-length', 0))
            with open(local_filename, 'wb') as f:
                with tqdm(total=total_size, unit='B', unit_scale=True, desc=f"  {filename}") as pbar:
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)
                        pbar.update(len(chunk))
        else:
            print(f"  [Failed] HTTP {response.status_code} for {filename}")
    except Exception as e:
        print(f"  [Error] {filename}: {e}")

def main():
    print("🚀 Starting NEETcoach NCERT Downloader...")
    
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    for subject, classes in BOOKS.items():
        print(f"\n📚 Processing {subject}...")
        for class_num, codes in classes.items():
            class_dir = os.path.join(OUTPUT_DIR, subject, f"Class_{class_num}")
            if not os.path.exists(class_dir):
                os.makedirs(class_dir)

            for code in codes:
                # NCERT books usually have a 'ps' (preface) and then chapters 01, 02...
                # We will attempt to download the first 25 chapters for each book
                for i in range(1, 26):
                    chapter_code = f"{i:02d}"
                    filename = f"{code}{chapter_code}.pdf"
                    url = f"{BASE_URL}{code}{chapter_code}.pdf"
                    
                    # We only print the start of a book to avoid too much noise
                    if i == 1:
                        print(f"  ⬇️ Downloading Book {code} (Class {class_num})...")
                    
                    download_file(url, class_dir, filename)

    print("\n✅ Download complete! Files stored in 'ncert_library' folder.")

if __name__ == "__main__":
    # Check for requests library
    try:
        import requests
    except ImportError:
        print("❌ Error: 'requests' and 'tqdm' libraries are required.")
        print("💡 Run: pip install requests tqdm")
        exit(1)
        
    main()
