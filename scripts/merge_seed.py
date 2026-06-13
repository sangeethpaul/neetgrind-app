with open("supabase/seed.sql", "r") as f:
    old_seed = f.read()

parts = old_seed.split("-- ============================================================\n-- TOPICS")
subjects_part = parts[0]

parts2 = parts[1].split("-- ============================================================\n-- MCQ QUESTIONS")
questions_part = "-- ============================================================\n-- MCQ QUESTIONS" + parts2[1]

with open("generated_seed.sql", "r") as f:
    new_topics_content = f.read()

with open("supabase/seed.sql", "w") as f:
    f.write(subjects_part)
    f.write(new_topics_content)
    f.write(questions_part)
