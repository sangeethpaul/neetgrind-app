import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json();
  const { topicSlug, answers, durationSeconds } = body as {
    topicSlug: string;
    answers: Record<number, string>;
    durationSeconds: number;
  };

  // Resolve topic
  const { data: topic } = await supabase
    .from("topics")
    .select("id")
    .eq("slug", topicSlug)
    .single();
  if (!topic) return NextResponse.json({ error: "Topic not found" }, { status: 404 });

  // Fetch questions with correct answers
  const questionIds = Object.keys(answers).map(Number);
  const { data: questions } = await supabase
    .from("questions")
    .select("id, correct_option")
    .in("id", questionIds);

  if (!questions) return NextResponse.json({ error: "Questions not found" }, { status: 404 });

  // Score calculation — NEET: +4 correct, -1 wrong, 0 unattempted
  let correct = 0;
  let wrong = 0;
  let unattempted = 0;

  for (const q of questions) {
    const userAnswer = answers[q.id];
    if (!userAnswer) {
      unattempted++;
    } else if (userAnswer === q.correct_option) {
      correct++;
    } else {
      wrong++;
    }
  }
  const score = correct * 4 - wrong * 1;

  // Insert test session
  const { data: session } = await supabase
    .from("test_sessions")
    .insert({
      user_id: user.id,
      topic_id: topic.id,
      score,
      correct,
      wrong,
      unattempted,
      duration_seconds: durationSeconds,
    })
    .select("*")
    .single();

  // Update profile total_score and tests_taken
  const { data: profile } = await supabase
    .from("profiles")
    .select("total_score, tests_taken, streak_days, last_active")
    .eq("id", user.id)
    .single();

  if (profile) {
    const today = new Date().toISOString().split("T")[0];
    const lastActive = profile.last_active;
    const yesterday = new Date(Date.now() - 86400000).toISOString().split("T")[0];

    let streak = profile.streak_days;
    if (lastActive === yesterday) {
      streak += 1; // continuing streak
    } else if (lastActive !== today) {
      streak = 1; // reset streak
    }

    await supabase
      .from("profiles")
      .update({
        total_score: Math.max(0, profile.total_score + score),
        tests_taken: profile.tests_taken + 1,
        streak_days: streak,
        last_active: today,
      })
      .eq("id", user.id);
  }

  return NextResponse.json({ session, score, correct, wrong, unattempted });
}
