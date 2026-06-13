-- NEETcoach Database Schema
-- Run this in the Supabase SQL Editor

-- ============================================================
-- PROFILES (extends Supabase auth.users)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username    TEXT UNIQUE NOT NULL,
  avatar_url  TEXT,
  total_score INTEGER NOT NULL DEFAULT 0,
  tests_taken INTEGER NOT NULL DEFAULT 0,
  streak_days INTEGER NOT NULL DEFAULT 0,
  last_active DATE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view all profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Function to auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', SPLIT_PART(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- SUBJECTS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.subjects (
  id         SERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  slug       TEXT UNIQUE NOT NULL,
  color      TEXT NOT NULL DEFAULT '#3B82F6',
  icon       TEXT NOT NULL DEFAULT '📚'
);

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read subjects" ON public.subjects FOR SELECT USING (true);

-- ============================================================
-- TOPICS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.topics (
  id         SERIAL PRIMARY KEY,
  subject_id INTEGER NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  slug       TEXT UNIQUE NOT NULL,
  description TEXT
);

ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read topics" ON public.topics FOR SELECT USING (true);

-- ============================================================
-- NCERT CONTENT (Markdown)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.ncert_content (
  id           SERIAL PRIMARY KEY,
  topic_id     INTEGER NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  markdown_body TEXT NOT NULL,
  pdf_url      TEXT,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.ncert_content ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read ncert content" ON public.ncert_content FOR SELECT USING (true);

-- ============================================================
-- QUESTIONS (MCQ Bank)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.questions (
  id             SERIAL PRIMARY KEY,
  topic_id       INTEGER NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  question_text  TEXT NOT NULL,
  option_a       TEXT NOT NULL,
  option_b       TEXT NOT NULL,
  option_c       TEXT NOT NULL,
  option_d       TEXT NOT NULL,
  correct_option TEXT NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D')),
  explanation    TEXT
);

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read questions" ON public.questions FOR SELECT USING (true);

-- ============================================================
-- TEST SESSIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.test_sessions (
  id               SERIAL PRIMARY KEY,
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  topic_id         INTEGER NOT NULL REFERENCES public.topics(id),
  score            INTEGER NOT NULL DEFAULT 0,
  correct          INTEGER NOT NULL DEFAULT 0,
  wrong            INTEGER NOT NULL DEFAULT 0,
  unattempted      INTEGER NOT NULL DEFAULT 0,
  duration_seconds INTEGER,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.test_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own test sessions" ON public.test_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own test sessions" ON public.test_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- CALENDAR EVENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.calendar_events (
  id         SERIAL PRIMARY KEY,
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date       DATE NOT NULL,
  subject_id INTEGER REFERENCES public.subjects(id),
  topic_id   INTEGER REFERENCES public.topics(id),
  event_type TEXT NOT NULL CHECK (event_type IN ('study', 'test', 'revision')),
  completed  BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own calendar events" ON public.calendar_events
  FOR ALL USING (auth.uid() = user_id);
