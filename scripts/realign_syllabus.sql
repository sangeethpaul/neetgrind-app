-- ============================================================
-- SYLLABUS REALIGNMENT & PDF URL CORRECTIONS
-- Generated programmatically to correct shift errors
-- ============================================================
BEGIN;

-- ------------------------------------------------------------
-- Subject: Physics
-- ------------------------------------------------------------

-- Class 11
-- physics-class-11-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Units and Measurements', 'physics-class-11-ch-2', 'NCERT Notes and study materials for Units and Measurements') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-2'), 'Units and Measurements — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph101.pdf');
-- physics-class-11-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Motion in a Straight Line', 'physics-class-11-ch-3', 'NCERT Notes and study materials for Motion in a Straight Line') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-3'), 'Motion in a Straight Line — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph102.pdf');
-- physics-class-11-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Motion in a Plane', 'physics-class-11-ch-4', 'NCERT Notes and study materials for Motion in a Plane') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-4'), 'Motion in a Plane — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph103.pdf');
-- physics-class-11-ch-5
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Laws of Motion', 'physics-class-11-ch-5', 'NCERT Notes and study materials for Laws of Motion') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-5');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-5'), 'Laws of Motion — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph104.pdf');
-- physics-class-11-ch-6
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Work, Energy and Power', 'physics-class-11-ch-6', 'NCERT Notes and study materials for Work, Energy and Power') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-6');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-6'), 'Work, Energy and Power — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph105.pdf');
-- physics-class-11-ch-7
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'System of Particles and Rotational Motion', 'physics-class-11-ch-7', 'NCERT Notes and study materials for System of Particles and Rotational Motion') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-7');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-7'), 'System of Particles and Rotational Motion — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph106.pdf');
-- physics-class-11-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Gravitation', 'physics-class-11-ch-8', 'NCERT Notes and study materials for Gravitation') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-8'), 'Gravitation — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph107.pdf');
-- physics-class-11-ch-9
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Mechanical Properties of Solids', 'physics-class-11-ch-9', 'NCERT Notes and study materials for Mechanical Properties of Solids') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-9');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-9'), 'Mechanical Properties of Solids — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph201.pdf');
-- physics-class-11-ch-10
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Mechanical Properties of Fluids', 'physics-class-11-ch-10', 'NCERT Notes and study materials for Mechanical Properties of Fluids') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-10');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-10'), 'Mechanical Properties of Fluids — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph202.pdf');
-- physics-class-11-ch-11
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Thermal Properties of Matter', 'physics-class-11-ch-11', 'NCERT Notes and study materials for Thermal Properties of Matter') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-11');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-11'), 'Thermal Properties of Matter — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph203.pdf');
-- physics-class-11-ch-12
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Thermodynamics', 'physics-class-11-ch-12', 'NCERT Notes and study materials for Thermodynamics') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-12');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-12'), 'Thermodynamics — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph204.pdf');
-- physics-class-11-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Kinetic Theory', 'physics-class-11-ch-13', 'NCERT Notes and study materials for Kinetic Theory') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-13'), 'Kinetic Theory — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph205.pdf');
-- physics-class-11-ch-14
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Oscillations', 'physics-class-11-ch-14', 'NCERT Notes and study materials for Oscillations') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-14');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-14'), 'Oscillations — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph206.pdf');
-- physics-class-11-ch-15
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Waves', 'physics-class-11-ch-15', 'NCERT Notes and study materials for Waves') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-15');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-15'), 'Waves — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph207.pdf');

-- Class 12
-- physics-class-12-ch-1
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Electric Charges and Fields', 'physics-class-12-ch-1', 'NCERT Notes and study materials for Electric Charges and Fields') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-1');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-1'), 'Electric Charges and Fields — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph101.pdf');
-- physics-class-12-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Electrostatic Potential and Capacitance', 'physics-class-12-ch-2', 'NCERT Notes and study materials for Electrostatic Potential and Capacitance') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-2'), 'Electrostatic Potential and Capacitance — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph102.pdf');
-- physics-class-12-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Current Electricity', 'physics-class-12-ch-3', 'NCERT Notes and study materials for Current Electricity') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-3'), 'Current Electricity — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph103.pdf');
-- physics-class-12-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Moving Charges and Magnetism', 'physics-class-12-ch-4', 'NCERT Notes and study materials for Moving Charges and Magnetism') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-4'), 'Moving Charges and Magnetism — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph104.pdf');
-- physics-class-12-ch-5
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Magnetism and Matter', 'physics-class-12-ch-5', 'NCERT Notes and study materials for Magnetism and Matter') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-5');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-5'), 'Magnetism and Matter — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph105.pdf');
-- physics-class-12-ch-6
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Electromagnetic Induction', 'physics-class-12-ch-6', 'NCERT Notes and study materials for Electromagnetic Induction') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-6');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-6'), 'Electromagnetic Induction — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph106.pdf');
-- physics-class-12-ch-7
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Alternating Current', 'physics-class-12-ch-7', 'NCERT Notes and study materials for Alternating Current') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-7');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-7'), 'Alternating Current — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph107.pdf');
-- physics-class-12-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Electromagnetic Waves', 'physics-class-12-ch-8', 'NCERT Notes and study materials for Electromagnetic Waves') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-8'), 'Electromagnetic Waves — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph108.pdf');
-- physics-class-12-ch-9
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Ray Optics and Optical Instruments', 'physics-class-12-ch-9', 'NCERT Notes and study materials for Ray Optics and Optical Instruments') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-9');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-9'), 'Ray Optics and Optical Instruments — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph201.pdf');
-- physics-class-12-ch-10
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Wave Optics', 'physics-class-12-ch-10', 'NCERT Notes and study materials for Wave Optics') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-10');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-10'), 'Wave Optics — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph202.pdf');
-- physics-class-12-ch-11
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Dual Nature of Radiation and Matter', 'physics-class-12-ch-11', 'NCERT Notes and study materials for Dual Nature of Radiation and Matter') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-11');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-11'), 'Dual Nature of Radiation and Matter — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph203.pdf');
-- physics-class-12-ch-12
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Atoms', 'physics-class-12-ch-12', 'NCERT Notes and study materials for Atoms') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-12');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-12'), 'Atoms — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph204.pdf');
-- physics-class-12-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Nuclei', 'physics-class-12-ch-13', 'NCERT Notes and study materials for Nuclei') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-13'), 'Nuclei — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph205.pdf');
-- physics-class-12-ch-14
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Semiconductor Electronics: Materials, Devices and Simple Circuits', 'physics-class-12-ch-14', 'NCERT Notes and study materials for Semiconductor Electronics: Materials, Devices and Simple Circuits') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-14');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-14'), 'Semiconductor Electronics: Materials, Devices and Simple Circuits — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph206.pdf');
-- ------------------------------------------------------------
-- Subject: Chemistry
-- ------------------------------------------------------------

-- Class 11
-- chemistry-class-11-ch-1
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Some Basic Concepts of Chemistry', 'chemistry-class-11-ch-1', 'NCERT Notes and study materials for Some Basic Concepts of Chemistry') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-1');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-1'), 'Some Basic Concepts of Chemistry — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech101.pdf');
-- chemistry-class-11-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Structure of Atom', 'chemistry-class-11-ch-2', 'NCERT Notes and study materials for Structure of Atom') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-2'), 'Structure of Atom — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech102.pdf');
-- chemistry-class-11-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Classification of Elements and Periodicity in Properties', 'chemistry-class-11-ch-3', 'NCERT Notes and study materials for Classification of Elements and Periodicity in Properties') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-3'), 'Classification of Elements and Periodicity in Properties — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech103.pdf');
-- chemistry-class-11-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemical Bonding and Molecular Structure', 'chemistry-class-11-ch-4', 'NCERT Notes and study materials for Chemical Bonding and Molecular Structure') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-4'), 'Chemical Bonding and Molecular Structure — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech104.pdf');
-- chemistry-class-11-ch-6
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Thermodynamics', 'chemistry-class-11-ch-6', 'NCERT Notes and study materials for Thermodynamics') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-6');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-6'), 'Thermodynamics — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech105.pdf');
-- chemistry-class-11-ch-7
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Equilibrium', 'chemistry-class-11-ch-7', 'NCERT Notes and study materials for Equilibrium') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-7');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-7'), 'Equilibrium — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech106.pdf');
-- chemistry-class-11-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Redox Reactions', 'chemistry-class-11-ch-8', 'NCERT Notes and study materials for Redox Reactions') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-8'), 'Redox Reactions — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech201.pdf');
-- chemistry-class-11-ch-12
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Organic Chemistry: Some Basic Principles and Techniques', 'chemistry-class-11-ch-12', 'NCERT Notes and study materials for Organic Chemistry: Some Basic Principles and Techniques') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-12');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-12'), 'Organic Chemistry: Some Basic Principles and Techniques — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech202.pdf');
-- chemistry-class-11-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Hydrocarbons', 'chemistry-class-11-ch-13', 'NCERT Notes and study materials for Hydrocarbons') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-13'), 'Hydrocarbons — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech203.pdf');

-- Class 12
-- chemistry-class-12-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Solutions', 'chemistry-class-12-ch-2', 'NCERT Notes and study materials for Solutions') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-2'), 'Solutions — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech101.pdf');
-- chemistry-class-12-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Electrochemistry', 'chemistry-class-12-ch-3', 'NCERT Notes and study materials for Electrochemistry') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-3'), 'Electrochemistry — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech102.pdf');
-- chemistry-class-12-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemical Kinetics', 'chemistry-class-12-ch-4', 'NCERT Notes and study materials for Chemical Kinetics') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-4'), 'Chemical Kinetics — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech103.pdf');
-- chemistry-class-12-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'The d- and f-Block Elements', 'chemistry-class-12-ch-8', 'NCERT Notes and study materials for The d- and f-Block Elements') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-8'), 'The d- and f-Block Elements — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech104.pdf');
-- chemistry-class-12-ch-9
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Coordination Compounds', 'chemistry-class-12-ch-9', 'NCERT Notes and study materials for Coordination Compounds') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-9');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-9'), 'Coordination Compounds — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech105.pdf');
-- chemistry-class-12-ch-10
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Haloalkanes and Haloarenes', 'chemistry-class-12-ch-10', 'NCERT Notes and study materials for Haloalkanes and Haloarenes') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-10');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-10'), 'Haloalkanes and Haloarenes — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech201.pdf');
-- chemistry-class-12-ch-11
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Alcohols, Phenols and Ethers', 'chemistry-class-12-ch-11', 'NCERT Notes and study materials for Alcohols, Phenols and Ethers') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-11');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-11'), 'Alcohols, Phenols and Ethers — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech202.pdf');
-- chemistry-class-12-ch-12
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Aldehydes, Ketones and Carboxylic Acids', 'chemistry-class-12-ch-12', 'NCERT Notes and study materials for Aldehydes, Ketones and Carboxylic Acids') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-12');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-12'), 'Aldehydes, Ketones and Carboxylic Acids — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech203.pdf');
-- chemistry-class-12-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Amines', 'chemistry-class-12-ch-13', 'NCERT Notes and study materials for Amines') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-13'), 'Amines — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech204.pdf');
-- chemistry-class-12-ch-14
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Biomolecules', 'chemistry-class-12-ch-14', 'NCERT Notes and study materials for Biomolecules') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-14');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-14'), 'Biomolecules — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech205.pdf');
-- ------------------------------------------------------------
-- Subject: Biology
-- ------------------------------------------------------------

-- Class 11
-- biology-class-11-ch-1
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'The Living World', 'biology-class-11-ch-1', 'NCERT Notes and study materials for The Living World') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-1');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-1'), 'The Living World — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo101.pdf');
-- biology-class-11-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biological Classification', 'biology-class-11-ch-2', 'NCERT Notes and study materials for Biological Classification') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-2'), 'Biological Classification — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo102.pdf');
-- biology-class-11-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Plant Kingdom', 'biology-class-11-ch-3', 'NCERT Notes and study materials for Plant Kingdom') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-3'), 'Plant Kingdom — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo103.pdf');
-- biology-class-11-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Animal Kingdom', 'biology-class-11-ch-4', 'NCERT Notes and study materials for Animal Kingdom') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-4'), 'Animal Kingdom — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo104.pdf');
-- biology-class-11-ch-5
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Morphology of Flowering Plants', 'biology-class-11-ch-5', 'NCERT Notes and study materials for Morphology of Flowering Plants') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-5');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-5'), 'Morphology of Flowering Plants — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo105.pdf');
-- biology-class-11-ch-6
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Anatomy of Flowering Plants', 'biology-class-11-ch-6', 'NCERT Notes and study materials for Anatomy of Flowering Plants') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-6');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-6'), 'Anatomy of Flowering Plants — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo106.pdf');
-- biology-class-11-ch-7
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Structural Organisation in Animals', 'biology-class-11-ch-7', 'NCERT Notes and study materials for Structural Organisation in Animals') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-7');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-7'), 'Structural Organisation in Animals — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo107.pdf');
-- biology-class-11-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Cell: The Unit of Life', 'biology-class-11-ch-8', 'NCERT Notes and study materials for Cell: The Unit of Life') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-8'), 'Cell: The Unit of Life — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo108.pdf');
-- biology-class-11-ch-9
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biomolecules', 'biology-class-11-ch-9', 'NCERT Notes and study materials for Biomolecules') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-9');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-9'), 'Biomolecules — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo109.pdf');
-- biology-class-11-ch-10
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Cell Cycle and Cell Division', 'biology-class-11-ch-10', 'NCERT Notes and study materials for Cell Cycle and Cell Division') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-10');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-10'), 'Cell Cycle and Cell Division — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo110.pdf');
-- biology-class-11-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Photosynthesis in Higher Plants', 'biology-class-11-ch-13', 'NCERT Notes and study materials for Photosynthesis in Higher Plants') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-13'), 'Photosynthesis in Higher Plants — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo111.pdf');
-- biology-class-11-ch-14
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Respiration in Plants', 'biology-class-11-ch-14', 'NCERT Notes and study materials for Respiration in Plants') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-14');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-14'), 'Respiration in Plants — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo112.pdf');
-- biology-class-11-ch-15
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Plant Growth and Development', 'biology-class-11-ch-15', 'NCERT Notes and study materials for Plant Growth and Development') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-15');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-15'), 'Plant Growth and Development — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo113.pdf');
-- biology-class-11-ch-17
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Breathing and Exchange of Gases', 'biology-class-11-ch-17', 'NCERT Notes and study materials for Breathing and Exchange of Gases') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-17');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-17'), 'Breathing and Exchange of Gases — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo114.pdf');
-- biology-class-11-ch-18
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Body Fluids and Circulation', 'biology-class-11-ch-18', 'NCERT Notes and study materials for Body Fluids and Circulation') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-18');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-18'), 'Body Fluids and Circulation — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo115.pdf');
-- biology-class-11-ch-19
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Excretory Products and their Elimination', 'biology-class-11-ch-19', 'NCERT Notes and study materials for Excretory Products and their Elimination') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-19');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-19'), 'Excretory Products and their Elimination — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo116.pdf');
-- biology-class-11-ch-20
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Locomotion and Movement', 'biology-class-11-ch-20', 'NCERT Notes and study materials for Locomotion and Movement') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-20');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-20'), 'Locomotion and Movement — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo117.pdf');
-- biology-class-11-ch-21
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Neural Control and Coordination', 'biology-class-11-ch-21', 'NCERT Notes and study materials for Neural Control and Coordination') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-21');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-21'), 'Neural Control and Coordination — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo118.pdf');
-- biology-class-11-ch-22
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Chemical Coordination and Integration', 'biology-class-11-ch-22', 'NCERT Notes and study materials for Chemical Coordination and Integration') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-22');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-22'), 'Chemical Coordination and Integration — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo119.pdf');

-- Class 12
-- biology-class-12-ch-2
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Sexual Reproduction in Flowering Plants', 'biology-class-12-ch-2', 'NCERT Notes and study materials for Sexual Reproduction in Flowering Plants') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-2');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-2'), 'Sexual Reproduction in Flowering Plants — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo101.pdf');
-- biology-class-12-ch-3
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Human Reproduction', 'biology-class-12-ch-3', 'NCERT Notes and study materials for Human Reproduction') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-3');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-3'), 'Human Reproduction — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo102.pdf');
-- biology-class-12-ch-4
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Reproductive Health', 'biology-class-12-ch-4', 'NCERT Notes and study materials for Reproductive Health') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-4');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-4'), 'Reproductive Health — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo103.pdf');
-- biology-class-12-ch-5
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Principles of Inheritance and Variation', 'biology-class-12-ch-5', 'NCERT Notes and study materials for Principles of Inheritance and Variation') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-5');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-5'), 'Principles of Inheritance and Variation — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo104.pdf');
-- biology-class-12-ch-6
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Molecular Basis of Inheritance', 'biology-class-12-ch-6', 'NCERT Notes and study materials for Molecular Basis of Inheritance') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-6');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-6'), 'Molecular Basis of Inheritance — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo105.pdf');
-- biology-class-12-ch-7
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Evolution', 'biology-class-12-ch-7', 'NCERT Notes and study materials for Evolution') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-7');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-7'), 'Evolution — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo106.pdf');
-- biology-class-12-ch-8
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Human Health and Disease', 'biology-class-12-ch-8', 'NCERT Notes and study materials for Human Health and Disease') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-8');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-8'), 'Human Health and Disease — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo107.pdf');
-- biology-class-12-ch-10
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Microbes in Human Welfare', 'biology-class-12-ch-10', 'NCERT Notes and study materials for Microbes in Human Welfare') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-10');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-10'), 'Microbes in Human Welfare — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo108.pdf');
-- biology-class-12-ch-11
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biotechnology: Principles and Processes', 'biology-class-12-ch-11', 'NCERT Notes and study materials for Biotechnology: Principles and Processes') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-11');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-11'), 'Biotechnology: Principles and Processes — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo109.pdf');
-- biology-class-12-ch-12
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biotechnology and its Applications', 'biology-class-12-ch-12', 'NCERT Notes and study materials for Biotechnology and its Applications') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-12');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-12'), 'Biotechnology and its Applications — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo110.pdf');
-- biology-class-12-ch-13
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Organisms and Populations', 'biology-class-12-ch-13', 'NCERT Notes and study materials for Organisms and Populations') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-13');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-13'), 'Organisms and Populations — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo111.pdf');
-- biology-class-12-ch-14
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Ecosystem', 'biology-class-12-ch-14', 'NCERT Notes and study materials for Ecosystem') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-14');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-14'), 'Ecosystem — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo112.pdf');
-- biology-class-12-ch-15
INSERT INTO public.topics (subject_id, name, slug, description) VALUES ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biodiversity and Conservation', 'biology-class-12-ch-15', 'NCERT Notes and study materials for Biodiversity and Conservation') ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;
DELETE FROM public.ncert_content WHERE topic_id = (SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-15');
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-15'), 'Biodiversity and Conservation — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo113.pdf');

COMMIT;