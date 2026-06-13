-- ============================================================
-- Migration 002: Allow MCQ Generator to insert questions
-- ============================================================
-- Run this ONCE in the Supabase SQL Editor before using the
-- MCQ generator script with the publishable (anon) key.
--
-- Dashboard → SQL Editor → New query → paste → Run
-- ============================================================

-- Allow server-side scripts to insert questions
CREATE POLICY "Allow insert for authenticated or service role"
  ON public.questions
  FOR INSERT
  WITH CHECK (true);

-- Allow the MCQ generator to look up topic IDs by slug
-- (topics table already has SELECT policy, so this is a no-op safety check)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'topics' AND policyname = 'Everyone can read topics'
  ) THEN
    CREATE POLICY "Everyone can read topics" ON public.topics FOR SELECT USING (true);
  END IF;
END $$;
