-- Migration 006: Remove Rationalized Chapters and Update Foreign Key Constraints
-- Recreates topic_id foreign keys on test_sessions and calendar_events with ON DELETE CASCADE / SET NULL,
-- then deletes the 19 rationalized chapters from public.topics.

BEGIN;

-- Update public.test_sessions constraint to cascade deletes when a topic is removed
ALTER TABLE public.test_sessions 
  DROP CONSTRAINT IF EXISTS test_sessions_topic_id_fkey,
  ADD CONSTRAINT test_sessions_topic_id_fkey 
    FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;

-- Update public.calendar_events constraint to set NULL when a topic is removed
ALTER TABLE public.calendar_events 
  DROP CONSTRAINT IF EXISTS calendar_events_topic_id_fkey,
  ADD CONSTRAINT calendar_events_topic_id_fkey 
    FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE SET NULL;

-- Delete the 19 rationalized chapters
DELETE FROM public.topics WHERE slug IN (
  'physics-class-11-ch-1',
  'physics-class-12-ch-15',
  'chemistry-class-11-ch-5',
  'chemistry-class-11-ch-9',
  'chemistry-class-11-ch-10',
  'chemistry-class-11-ch-11',
  'chemistry-class-11-ch-14',
  'chemistry-class-12-ch-1',
  'chemistry-class-12-ch-5',
  'chemistry-class-12-ch-6',
  'chemistry-class-12-ch-7',
  'chemistry-class-12-ch-15',
  'chemistry-class-12-ch-16',
  'biology-class-11-ch-11',
  'biology-class-11-ch-12',
  'biology-class-11-ch-16',
  'biology-class-12-ch-1',
  'biology-class-12-ch-9',
  'biology-class-12-ch-16'
);

COMMIT;
