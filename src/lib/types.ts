export type Subject = {
  id: number
  name: string
  slug: string
  color: string
  icon: string
}

export type Topic = {
  id: number
  subject_id: number
  name: string
  slug: string
  description: string | null
  subjects?: Subject
}

export type NcertContent = {
  id: number
  topic_id: number
  title: string
  markdown_body: string
  pdf_url?: string | null
  updated_at: string
}

export type Question = {
  id: number
  topic_id: number
  question_text: string
  option_a: string
  option_b: string
  option_c: string
  option_d: string
  correct_option: 'A' | 'B' | 'C' | 'D'
  explanation: string | null
}

export type Profile = {
  id: string
  username: string
  avatar_url: string | null
  total_score: number
  tests_taken: number
  streak_days: number
  last_active: string | null
  created_at: string
}

export type TestSession = {
  id: number
  user_id: string
  topic_id: number
  score: number
  correct: number
  wrong: number
  unattempted: number
  duration_seconds: number | null
  created_at: string
}

export type CalendarEvent = {
  id: number
  user_id: string
  date: string
  subject_id: number | null
  topic_id: number | null
  event_type: 'study' | 'test' | 'revision'
  completed: boolean
  created_at: string
  subjects?: Subject
  topics?: Topic
}

export type LeaderboardEntry = Profile & { rank: number }
