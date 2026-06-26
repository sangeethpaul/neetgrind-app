import os
import sys
from pathlib import Path

# Define the curriculum
# format: { subject_slug: { class_num: { ch_num: (name, pdf_filename) } } }
CURRICULUM = {
    "physics": {
        11: {
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
            14: ("Semiconductor Electronics: Materials, Devices and Simple Circuits", "leph206.pdf")
        }
    },
    "chemistry": {
        11: {
            1: ("Some Basic Concepts of Chemistry", "kech101.pdf"),
            2: ("Structure of Atom", "kech102.pdf"),
            3: ("Classification of Elements and Periodicity in Properties", "kech103.pdf"),
            4: ("Chemical Bonding and Molecular Structure", "kech104.pdf"),
            6: ("Thermodynamics", "kech105.pdf"),
            7: ("Equilibrium", "kech106.pdf"),
            8: ("Redox Reactions", "kech201.pdf"),
            12: ("Organic Chemistry: Some Basic Principles and Techniques", "kech202.pdf"),
            13: ("Hydrocarbons", "kech203.pdf")
        },
        12: {
            2: ("Solutions", "lech101.pdf"),
            3: ("Electrochemistry", "lech102.pdf"),
            4: ("Chemical Kinetics", "lech103.pdf"),
            8: ("The d- and f-Block Elements", "lech104.pdf"),
            9: ("Coordination Compounds", "lech105.pdf"),
            10: ("Haloalkanes and Haloarenes", "lech201.pdf"),
            11: ("Alcohols, Phenols and Ethers", "lech202.pdf"),
            12: ("Aldehydes, Ketones and Carboxylic Acids", "lech203.pdf"),
            13: ("Amines", "lech204.pdf"),
            14: ("Biomolecules", "lech205.pdf")
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
            13: ("Photosynthesis in Higher Plants", "kebo111.pdf"),
            14: ("Respiration in Plants", "kebo112.pdf"),
            15: ("Plant Growth and Development", "kebo113.pdf"),
            17: ("Breathing and Exchange of Gases", "kebo114.pdf"),
            18: ("Body Fluids and Circulation", "kebo115.pdf"),
            19: ("Excretory Products and their Elimination", "kebo116.pdf"),
            20: ("Locomotion and Movement", "kebo117.pdf"),
            21: ("Neural Control and Coordination", "kebo118.pdf"),
            22: ("Chemical Coordination and Integration", "kebo119.pdf")
        },
        12: {
            2: ("Sexual Reproduction in Flowering Plants", "lebo101.pdf"),
            3: ("Human Reproduction", "lebo102.pdf"),
            4: ("Reproductive Health", "lebo103.pdf"),
            5: ("Principles of Inheritance and Variation", "lebo104.pdf"),
            6: ("Molecular Basis of Inheritance", "lebo105.pdf"),
            7: ("Evolution", "lebo106.pdf"),
            8: ("Human Health and Disease", "lebo107.pdf"),
            10: ("Microbes in Human Welfare", "lebo108.pdf"),
            11: ("Biotechnology: Principles and Processes", "lebo109.pdf"),
            12: ("Biotechnology and its Applications", "lebo110.pdf"),
            13: ("Organisms and Populations", "lebo111.pdf"),
            14: ("Ecosystem", "lebo112.pdf"),
            15: ("Biodiversity and Conservation", "lebo113.pdf")
        }
    }
}

def generate():
    sql_lines = [
        "-- ============================================================",
        "-- SYLLABUS REALIGNMENT & PDF URL CORRECTIONS",
        "-- Generated programmatically to correct shift errors",
        "-- ============================================================",
        "BEGIN;",
        ""
    ]
    
    # We will process each subject and update the topics and ncert_content
    for subj_slug, classes in CURRICULUM.items():
        sql_lines.append(f"-- ------------------------------------------------------------")
        sql_lines.append(f"-- Subject: {subj_slug.capitalize()}")
        sql_lines.append(f"-- ------------------------------------------------------------")
        
        for class_num, chapters in classes.items():
            sql_lines.append(f"\n-- Class {class_num}")
            for ch_num, (name, pdf_file) in chapters.items():
                slug = f"{subj_slug}-class-{class_num}-ch-{ch_num}"
                description = f"NCERT Notes and study materials for {name}"
                name_escaped = name.replace("'", "''")
                desc_escaped = description.replace("'", "''")
                
                # Check if it exists or insert/update
                sql_lines.append(f"-- {slug}")
                sql_lines.append(
                    f"INSERT INTO public.topics (subject_id, name, slug, description) "
                    f"VALUES ((SELECT id FROM public.subjects WHERE slug = '{subj_slug}'), '{name_escaped}', '{slug}', '{desc_escaped}') "
                    f"ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;"
                )
                
                # NCERT content mapping
                pdf_url = f"/pdfs/{subj_slug.capitalize()}/Class_{class_num}/{pdf_file}" if pdf_file else None
                pdf_url_val = f"'{pdf_url}'" if pdf_url else "NULL"
                content_title = f"{name_escaped} — NCERT PDF"
                
                # Insert or update NCERT content using ON CONFLICT (topic_id) if exists, wait! ncert_content has topic_id but is not unique. 
                # To make it robust, we delete existing ncert_content for the topic_id first and then insert!
                sql_lines.append(
                    f"DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = '{slug}');"
                )
                sql_lines.append(
                    f"INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) "
                    f"VALUES ((SELECT id FROM public.topics WHERE slug = '{slug}'), '{content_title}', 'PDF Viewer Only', {pdf_url_val});"
                )
                
    sql_lines.append("\nCOMMIT;")
    
    output_path = Path("/Users/chennainest/NEETcoach/neet-coach-app/scripts/realign_syllabus.sql")
    output_path.write_text("\n".join(sql_lines), encoding="utf-8")
    print(f"✅ Generated SQL migration script at: {output_path}")

if __name__ == "__main__":
    generate()
