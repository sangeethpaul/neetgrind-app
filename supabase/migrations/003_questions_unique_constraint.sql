-- Add unique constraint to questions to allow upserts and prevent duplicates
ALTER TABLE public.questions 
ADD CONSTRAINT questions_unique_topic_text UNIQUE (topic_id, question_text);
