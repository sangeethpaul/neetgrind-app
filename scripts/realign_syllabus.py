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
    print("❌ Error: Missing SUPABASE_URL or SUPABASE_KEY.")
    sys.exit(1)

try:
    from supabase import create_client, Client
except ImportError:
    print("❌ Error: supabase package not installed.")
    sys.exit(1)

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Define the curriculum
# format: { subject_slug: { class_num: { ch_num: (name, pdf_filename) } } }
CURRICULUM = {
    "physics": {
        11: {
            1: ("Physical World", None),
            2: ("Units and Measurements", "keph101.pdf"),
            3: ("Motion in a Straight Line", "keph102.pdf"),
            4: ("Motion in a Plane", "keph103.pdf"),
            5: ("Laws of Motion", "keph104.pdf"),
            6: ("Work, Energy and Power", "keph105.pdf"),
            7: ("System of Particles and Rotational Motion", "keph106.pdf"),
            8: ("Gravitation", "keph107.pdf"),
            9: ("Mechanical Properties of Solids", "keph201.pdf"),
            10: ("Mechanical Properties of Fluids", "keph202.pdf"),
            11: ("Thermal Properties of Matter", "keph203.pdf"),
            12: ("Thermodynamics", "keph204.pdf"),
            13: ("Kinetic Theory", "keph205.pdf"),
            14: ("Oscillations", "keph206.pdf"),
            15: ("Waves", "keph207.pdf")
        },
        12: {
            1: ("Electric Charges and Fields", "leph101.pdf"),
            2: ("Electrostatic Potential and Capacitance", "leph102.pdf"),
            3: ("Current Electricity", "leph103.pdf"),
            4: ("Moving Charges and Magnetism", "leph104.pdf"),
            5: ("Magnetism and Matter", "leph105.pdf"),
            6: ("Electromagnetic Induction", "leph106.pdf"),
            7: ("Alternating Current", "leph107.pdf"),
            8: ("Electromagnetic Waves", "leph108.pdf"),
            9: ("Ray Optics and Optical Instruments", "leph201.pdf"),
            10: ("Wave Optics", "leph202.pdf"),
            11: ("Dual Nature of Radiation and Matter", "leph203.pdf"),
            12: ("Atoms", "leph204.pdf"),
            13: ("Nuclei", "leph205.pdf"),
            14: ("Semiconductor Electronics: Materials, Devices and Simple Circuits", "leph206.pdf"),
            15: ("Communication Systems", None)
        }
    },
    "chemistry": {
        11: {
            1: ("Some Basic Concepts of Chemistry", "kech101.pdf"),
            2: ("Structure of Atom", "kech102.pdf"),
            3: ("Classification of Elements and Periodicity in Properties", "kech103.pdf"),
            4: ("Chemical Bonding and Molecular Structure", "kech104.pdf"),
            5: ("States of Matter", None),
            6: ("Thermodynamics", "kech105.pdf"),
            7: ("Equilibrium", "kech106.pdf"),
            8: ("Redox Reactions", "kech201.pdf"),
            9: ("Hydrogen", None),
            10: ("The s-Block Elements", None),
            11: ("The p-Block Elements", None),
            12: ("Organic Chemistry: Some Basic Principles and Techniques", "kech202.pdf"),
            13: ("Hydrocarbons", "kech203.pdf"),
            14: ("Environmental Chemistry", None)
        },
        12: {
            1: ("The Solid State", None),
            2: ("Solutions", "lech101.pdf"),
            3: ("Electrochemistry", "lech102.pdf"),
            4: ("Chemical Kinetics", "lech103.pdf"),
            5: ("Surface Chemistry", None),
            6: ("General Principles and Processes of Isolation of Elements", None),
            7: ("The p-Block Elements", None),
            8: ("The d- and f-Block Elements", "lech104.pdf"),
            9: ("Coordination Compounds", "lech105.pdf"),
            10: ("Haloalkanes and Haloarenes", "lech201.pdf"),
            11: ("Alcohols, Phenols and Ethers", "lech202.pdf"),
            12: ("Aldehydes, Ketones and Carboxylic Acids", "lech203.pdf"),
            13: ("Amines", "lech204.pdf"),
            14: ("Biomolecules", "lech205.pdf"),
            15: ("Polymers", None),
            16: ("Chemistry in Everyday Life", None)
        }
    },
    "biology": {
        11: {
            1: ("The Living World", "kebo101.pdf"),
            2: ("Biological Classification", "kebo102.pdf"),
            3: ("Plant Kingdom", "kebo103.pdf"),
            4: ("Animal Kingdom", "kebo104.pdf"),
            5: ("Morphology of Flowering Plants", "kebo105.pdf"),
            6: ("Anatomy of Flowering Plants", "kebo106.pdf"),
            7: ("Structural Organisation in Animals", "kebo107.pdf"),
            8: ("Cell: The Unit of Life", "kebo108.pdf"),
            9: ("Biomolecules", "kebo109.pdf"),
            10: ("Cell Cycle and Cell Division", "kebo110.pdf"),
            11: ("Transport in Plants", None),
            12: ("Mineral Nutrition", None),
            13: ("Photosynthesis in Higher Plants", "kebo111.pdf"),
            14: ("Respiration in Plants", "kebo112.pdf"),
            15: ("Plant Growth and Development", "kebo113.pdf"),
            16: ("Digestion and Absorption", None),
            17: ("Breathing and Exchange of Gases", "kebo114.pdf"),
            18: ("Body Fluids and Circulation", "kebo115.pdf"),
            19: ("Excretory Products and their Elimination", "kebo116.pdf"),
            20: ("Locomotion and Movement", "kebo117.pdf"),
            21: ("Neural Control and Coordination", "kebo118.pdf"),
            22: ("Chemical Coordination and Integration", "kebo119.pdf")
        },
        12: {
            1: ("Reproduction in Organisms", None),
            2: ("Sexual Reproduction in Flowering Plants", "lebo101.pdf"),
            3: ("Human Reproduction", "lebo102.pdf"),
            4: ("Reproductive Health", "lebo103.pdf"),
            5: ("Principles of Inheritance and Variation", "lebo104.pdf"),
            6: ("Molecular Basis of Inheritance", "lebo105.pdf"),
            7: ("Evolution", "lebo106.pdf"),
            8: ("Human Health and Disease", "lebo107.pdf"),
            9: ("Strategies for Enhancement in Food Production", None),
            10: ("Microbes in Human Welfare", "lebo108.pdf"),
            11: ("Biotechnology: Principles and Processes", "lebo109.pdf"),
            12: ("Biotechnology and its Applications", "lebo110.pdf"),
            13: ("Organisms and Populations", "lebo111.pdf"),
            14: ("Ecosystem", "lebo112.pdf"),
            15: ("Biodiversity and Conservation", "lebo113.pdf"),
            16: ("Environmental Issues", None)
        }
    }
}

def get_subject_map():
    res = supabase.table("subjects").select("id, slug").execute()
    return {s["slug"]: s["id"] for s in res.data}

def realign():
    print("🔄 Starting syllabus realignment...")
    subject_map = get_subject_map()
    
    # Track existing topics to see what we have
    existing_topics_res = supabase.table("topics").select("id, slug").execute()
    existing_topics = {t["slug"]: t["id"] for t in existing_topics_res.data}
    
    for subj_slug, classes in CURRICULUM.items():
        subject_id = subject_map.get(subj_slug)
        if not subject_id:
            print(f"❌ Error: Subject slug '{subj_slug}' not found in database.")
            continue
            
        print(f"\nProcessing {subj_slug.capitalize()}...")
        for class_num, chapters in classes.items():
            print(f"  Class {class_num}:")
            for ch_num, (name, pdf_file) in chapters.items():
                slug = f"{subj_slug}-class-{class_num}-ch-{ch_num}"
                description = f"NCERT Notes and study materials for {name}"
                
                # Check if it exists
                topic_id = existing_topics.get(slug)
                
                if topic_id:
                    # Update name and description
                    supabase.table("topics").update({
                        "name": name,
                        "description": description
                    }).eq("id", topic_id).execute()
                    print(f"    [Updated] Topic: {slug} -> '{name}'")
                else:
                    # Insert
                    new_topic = {
                        "subject_id": subject_id,
                        "name": name,
                        "slug": slug,
                        "description": description
                    }
                    insert_res = supabase.table("topics").insert(new_topic).execute()
                    topic_id = insert_res.data[0]["id"]
                    print(f"    [Created] Topic: {slug} -> '{name}'")
                
                # NCERT content
                pdf_url = f"/pdfs/{subj_slug.capitalize()}/Class_{class_num}/{pdf_file}" if pdf_file else None
                content_title = f"{name} — NCERT PDF"
                
                # Check if ncert_content exists for this topic
                content_res = supabase.table("ncert_content").select("id").eq("topic_id", topic_id).execute()
                if content_res.data:
                    content_id = content_res.data[0]["id"]
                    supabase.table("ncert_content").update({
                        "title": content_title,
                        "pdf_url": pdf_url
                    }).eq("id", content_id).execute()
                else:
                    new_content = {
                        "topic_id": topic_id,
                        "title": content_title,
                        "markdown_body": "PDF Viewer Only",
                        "pdf_url": pdf_url
                    }
                    supabase.table("ncert_content").insert(new_content).execute()
                print(f"      Mapped PDF URL: {pdf_url}")
                
    print("\n✅ Syllabus realignment complete!")

if __name__ == "__main__":
    realign()
