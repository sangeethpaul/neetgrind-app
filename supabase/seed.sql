-- NEETcoach Seed Data
-- Run AFTER migration in Supabase SQL Editor

-- ============================================================
-- SUBJECTS
-- ============================================================
INSERT INTO public.subjects (name, slug, color, icon) VALUES
  ('Physics',   'physics',   '#3B82F6', '⚛️'),
  ('Chemistry', 'chemistry', '#10B981', '🧪'),
  ('Biology',   'biology',   '#F59E0B', '🧬')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- TOPICS
-- ============================================================
TRUNCATE TABLE public.topics RESTART IDENTITY CASCADE;
-- ============================================================
INSERT INTO public.topics (subject_id, name, slug, description) VALUES
((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 1', 'chemistry-class-11-ch-1', 'NCERT PDF for Chemistry Class 11 - Chapter 1'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 2', 'chemistry-class-11-ch-2', 'NCERT PDF for Chemistry Class 11 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 3', 'chemistry-class-11-ch-3', 'NCERT PDF for Chemistry Class 11 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 4', 'chemistry-class-11-ch-4', 'NCERT PDF for Chemistry Class 11 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 6', 'chemistry-class-11-ch-6', 'NCERT PDF for Chemistry Class 11 - Chapter 6'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 7', 'chemistry-class-11-ch-7', 'NCERT PDF for Chemistry Class 11 - Chapter 7'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 11 - Chapter 8', 'chemistry-class-11-ch-8', 'NCERT PDF for Chemistry Class 11 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 2', 'chemistry-class-12-ch-2', 'NCERT PDF for Chemistry Class 12 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 3', 'chemistry-class-12-ch-3', 'NCERT PDF for Chemistry Class 12 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 4', 'chemistry-class-12-ch-4', 'NCERT PDF for Chemistry Class 12 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 8', 'chemistry-class-12-ch-8', 'NCERT PDF for Chemistry Class 12 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 9', 'chemistry-class-12-ch-9', 'NCERT PDF for Chemistry Class 12 - Chapter 9'),
  ((SELECT id FROM public.subjects WHERE slug = 'chemistry'), 'Chemistry Class 12 - Chapter 10', 'chemistry-class-12-ch-10', 'NCERT PDF for Chemistry Class 12 - Chapter 10'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 2', 'physics-class-11-ch-2', 'NCERT PDF for Physics Class 11 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 3', 'physics-class-11-ch-3', 'NCERT PDF for Physics Class 11 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 4', 'physics-class-11-ch-4', 'NCERT PDF for Physics Class 11 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 5', 'physics-class-11-ch-5', 'NCERT PDF for Physics Class 11 - Chapter 5'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 6', 'physics-class-11-ch-6', 'NCERT PDF for Physics Class 11 - Chapter 6'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 7', 'physics-class-11-ch-7', 'NCERT PDF for Physics Class 11 - Chapter 7'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 8', 'physics-class-11-ch-8', 'NCERT PDF for Physics Class 11 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 9', 'physics-class-11-ch-9', 'NCERT PDF for Physics Class 11 - Chapter 9'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 10', 'physics-class-11-ch-10', 'NCERT PDF for Physics Class 11 - Chapter 10'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 11', 'physics-class-11-ch-11', 'NCERT PDF for Physics Class 11 - Chapter 11'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 12', 'physics-class-11-ch-12', 'NCERT PDF for Physics Class 11 - Chapter 12'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 13', 'physics-class-11-ch-13', 'NCERT PDF for Physics Class 11 - Chapter 13'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 11 - Chapter 14', 'physics-class-11-ch-14', 'NCERT PDF for Physics Class 11 - Chapter 14'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 1', 'physics-class-12-ch-1', 'NCERT PDF for Physics Class 12 - Chapter 1'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 2', 'physics-class-12-ch-2', 'NCERT PDF for Physics Class 12 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 3', 'physics-class-12-ch-3', 'NCERT PDF for Physics Class 12 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 4', 'physics-class-12-ch-4', 'NCERT PDF for Physics Class 12 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 5', 'physics-class-12-ch-5', 'NCERT PDF for Physics Class 12 - Chapter 5'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 6', 'physics-class-12-ch-6', 'NCERT PDF for Physics Class 12 - Chapter 6'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 7', 'physics-class-12-ch-7', 'NCERT PDF for Physics Class 12 - Chapter 7'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 8', 'physics-class-12-ch-8', 'NCERT PDF for Physics Class 12 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 9', 'physics-class-12-ch-9', 'NCERT PDF for Physics Class 12 - Chapter 9'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 10', 'physics-class-12-ch-10', 'NCERT PDF for Physics Class 12 - Chapter 10'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 11', 'physics-class-12-ch-11', 'NCERT PDF for Physics Class 12 - Chapter 11'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 12', 'physics-class-12-ch-12', 'NCERT PDF for Physics Class 12 - Chapter 12'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 13', 'physics-class-12-ch-13', 'NCERT PDF for Physics Class 12 - Chapter 13'),
  ((SELECT id FROM public.subjects WHERE slug = 'physics'), 'Physics Class 12 - Chapter 14', 'physics-class-12-ch-14', 'NCERT PDF for Physics Class 12 - Chapter 14'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 1', 'biology-class-11-ch-1', 'NCERT PDF for Biology Class 11 - Chapter 1'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 2', 'biology-class-11-ch-2', 'NCERT PDF for Biology Class 11 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 3', 'biology-class-11-ch-3', 'NCERT PDF for Biology Class 11 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 4', 'biology-class-11-ch-4', 'NCERT PDF for Biology Class 11 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 5', 'biology-class-11-ch-5', 'NCERT PDF for Biology Class 11 - Chapter 5'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 6', 'biology-class-11-ch-6', 'NCERT PDF for Biology Class 11 - Chapter 6'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 7', 'biology-class-11-ch-7', 'NCERT PDF for Biology Class 11 - Chapter 7'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 8', 'biology-class-11-ch-8', 'NCERT PDF for Biology Class 11 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 9', 'biology-class-11-ch-9', 'NCERT PDF for Biology Class 11 - Chapter 9'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 10', 'biology-class-11-ch-10', 'NCERT PDF for Biology Class 11 - Chapter 10'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 13', 'biology-class-11-ch-13', 'NCERT PDF for Biology Class 11 - Chapter 13'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 14', 'biology-class-11-ch-14', 'NCERT PDF for Biology Class 11 - Chapter 14'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 15', 'biology-class-11-ch-15', 'NCERT PDF for Biology Class 11 - Chapter 15'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 17', 'biology-class-11-ch-17', 'NCERT PDF for Biology Class 11 - Chapter 17'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 18', 'biology-class-11-ch-18', 'NCERT PDF for Biology Class 11 - Chapter 18'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 11 - Chapter 19', 'biology-class-11-ch-19', 'NCERT PDF for Biology Class 11 - Chapter 19'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 2', 'biology-class-12-ch-2', 'NCERT PDF for Biology Class 12 - Chapter 2'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 3', 'biology-class-12-ch-3', 'NCERT PDF for Biology Class 12 - Chapter 3'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 4', 'biology-class-12-ch-4', 'NCERT PDF for Biology Class 12 - Chapter 4'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 5', 'biology-class-12-ch-5', 'NCERT PDF for Biology Class 12 - Chapter 5'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 6', 'biology-class-12-ch-6', 'NCERT PDF for Biology Class 12 - Chapter 6'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 7', 'biology-class-12-ch-7', 'NCERT PDF for Biology Class 12 - Chapter 7'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 8', 'biology-class-12-ch-8', 'NCERT PDF for Biology Class 12 - Chapter 8'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 10', 'biology-class-12-ch-10', 'NCERT PDF for Biology Class 12 - Chapter 10'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 11', 'biology-class-12-ch-11', 'NCERT PDF for Biology Class 12 - Chapter 11'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 12', 'biology-class-12-ch-12', 'NCERT PDF for Biology Class 12 - Chapter 12'),
  ((SELECT id FROM public.subjects WHERE slug = 'biology'), 'Biology Class 12 - Chapter 13', 'biology-class-12-ch-13', 'NCERT PDF for Biology Class 12 - Chapter 13')

ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- NCERT CONTENT (PDFs)
-- ============================================================
INSERT INTO public.ncert_content (topic_id, title, markdown_body, pdf_url) VALUES
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-1'), 'Chemistry Class 11 - Chapter 1 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech101.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-2'), 'Chemistry Class 11 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-3'), 'Chemistry Class 11 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-4'), 'Chemistry Class 11 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-6'), 'Chemistry Class 11 - Chapter 6 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech106.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-7'), 'Chemistry Class 11 - Chapter 7 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech201.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-11-ch-8'), 'Chemistry Class 11 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_11/kech202.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-2'), 'Chemistry Class 12 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-3'), 'Chemistry Class 12 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-4'), 'Chemistry Class 12 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-8'), 'Chemistry Class 12 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech203.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-9'), 'Chemistry Class 12 - Chapter 9 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech204.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'chemistry-class-12-ch-10'), 'Chemistry Class 12 - Chapter 10 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Chemistry/Class_12/lech205.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-2'), 'Physics Class 11 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-3'), 'Physics Class 11 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-4'), 'Physics Class 11 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-5'), 'Physics Class 11 - Chapter 5 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph105.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-6'), 'Physics Class 11 - Chapter 6 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph106.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-7'), 'Physics Class 11 - Chapter 7 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph107.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-8'), 'Physics Class 11 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph201.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-9'), 'Physics Class 11 - Chapter 9 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph202.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-10'), 'Physics Class 11 - Chapter 10 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph203.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-11'), 'Physics Class 11 - Chapter 11 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph204.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-12'), 'Physics Class 11 - Chapter 12 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph205.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-13'), 'Physics Class 11 - Chapter 13 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph206.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-11-ch-14'), 'Physics Class 11 - Chapter 14 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_11/keph207.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-1'), 'Physics Class 12 - Chapter 1 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph101.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-2'), 'Physics Class 12 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-3'), 'Physics Class 12 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-4'), 'Physics Class 12 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-5'), 'Physics Class 12 - Chapter 5 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph105.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-6'), 'Physics Class 12 - Chapter 6 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph106.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-7'), 'Physics Class 12 - Chapter 7 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph107.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-8'), 'Physics Class 12 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph108.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-9'), 'Physics Class 12 - Chapter 9 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph201.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-10'), 'Physics Class 12 - Chapter 10 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph202.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-11'), 'Physics Class 12 - Chapter 11 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph203.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-12'), 'Physics Class 12 - Chapter 12 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph204.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-13'), 'Physics Class 12 - Chapter 13 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph205.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'physics-class-12-ch-14'), 'Physics Class 12 - Chapter 14 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Physics/Class_12/leph206.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-1'), 'Biology Class 11 - Chapter 1 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo101.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-2'), 'Biology Class 11 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-3'), 'Biology Class 11 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-4'), 'Biology Class 11 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-5'), 'Biology Class 11 - Chapter 5 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo105.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-6'), 'Biology Class 11 - Chapter 6 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo106.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-7'), 'Biology Class 11 - Chapter 7 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo107.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-8'), 'Biology Class 11 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo108.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-9'), 'Biology Class 11 - Chapter 9 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo109.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-10'), 'Biology Class 11 - Chapter 10 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo110.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-13'), 'Biology Class 11 - Chapter 13 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo113.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-14'), 'Biology Class 11 - Chapter 14 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo114.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-15'), 'Biology Class 11 - Chapter 15 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo115.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-17'), 'Biology Class 11 - Chapter 17 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo117.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-18'), 'Biology Class 11 - Chapter 18 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo118.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-11-ch-19'), 'Biology Class 11 - Chapter 19 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_11/kebo119.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-2'), 'Biology Class 12 - Chapter 2 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo102.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-3'), 'Biology Class 12 - Chapter 3 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo103.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-4'), 'Biology Class 12 - Chapter 4 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo104.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-5'), 'Biology Class 12 - Chapter 5 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo105.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-6'), 'Biology Class 12 - Chapter 6 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo106.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-7'), 'Biology Class 12 - Chapter 7 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo107.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-8'), 'Biology Class 12 - Chapter 8 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo108.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-10'), 'Biology Class 12 - Chapter 10 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo110.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-11'), 'Biology Class 12 - Chapter 11 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo111.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-12'), 'Biology Class 12 - Chapter 12 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo112.pdf'),
  ((SELECT id FROM public.topics WHERE slug = 'biology-class-12-ch-13'), 'Biology Class 12 - Chapter 13 — NCERT PDF', 'PDF Viewer Only', '/pdfs/Biology/Class_12/lebo113.pdf');


-- ============================================================
-- MCQ QUESTIONS — Laws of Motion (topic_id = 1)
-- ============================================================
INSERT INTO public.questions (topic_id, question_text, option_a, option_b, option_c, option_d, correct_option, explanation)
SELECT t.id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.correct_option, q.explanation
FROM public.topics t
CROSS JOIN (
  VALUES 
    ('A body is said to be in equilibrium when the net force acting on it is:', 'maximum', 'zero', 'minimum', 'constant', 'B', 'Equilibrium means the net force is zero, so there is no acceleration.'),
    ('Newton''s first law of motion defines:', 'acceleration', 'force', 'inertia', 'momentum', 'C', 'Newton''s first law defines inertia — the tendency of an object to resist changes in its state of motion.'),
    ('A 5 kg object accelerates at 3 m/s². What is the net force?', '8 N', '2 N', '15 N', '0.6 N', 'C', 'F = ma = 5 × 3 = 15 N'),
    ('The unit of momentum is:', 'N/s', 'kg⋅m/s', 'J/s', 'kg⋅m/s²', 'B', 'Momentum p = mv has units of kg⋅m/s.'),
    ('When a gun is fired, the gun recoils. This demonstrates:', 'First law', 'Second law', 'Third law', 'Law of gravitation', 'C', 'Action-reaction pair — Newton''s Third Law.'),
    ('The rate of change of momentum of a body is equal to the:', 'velocity', 'acceleration', 'applied force', 'kinetic energy', 'C', 'Newton''s Second Law: F = dp/dt'),
    ('A body of mass 10 kg is moving with velocity 5 m/s. Its momentum is:', '2 kg⋅m/s', '50 kg⋅m/s', '0.5 kg⋅m/s', '15 kg⋅m/s', 'B', 'p = mv = 10 × 5 = 50 kg⋅m/s'),
    ('Friction force is always:', 'parallel to the surface and opposes motion', 'perpendicular to the surface', 'equal to the applied force', 'independent of the normal force', 'A', 'Friction acts along the surface, opposing the direction of motion.'),
    ('The coefficient of static friction is always:', 'less than kinetic friction', 'greater than or equal to kinetic friction', 'equal to kinetic friction', 'zero', 'B', 'μs ≥ μk because static friction must be overcome before motion begins.'),
    ('An impulse of 20 N⋅s is applied to a body. The change in momentum is:', '20 J', '20 kg⋅m/s', '20 m/s', '20 N', 'B', 'Impulse = Change in momentum = 20 kg⋅m/s'),
    ('Inertia of a body depends on its:', 'velocity', 'acceleration', 'mass', 'shape', 'C', 'Inertia is directly proportional to mass.'),
    ('A 2 kg ball moving at 4 m/s collides with a wall and rebounds at 4 m/s. Change in momentum is:', '0', '8 kg⋅m/s', '16 kg⋅m/s', '4 kg⋅m/s', 'C', 'Δp = m(v_f - v_i) = 2(4 - (-4)) = 16 kg⋅m/s')
) AS q(question_text, option_a, option_b, option_c, option_d, correct_option, explanation);

