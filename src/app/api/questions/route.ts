import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const topicSlug = searchParams.get("topic");
  const limit = parseInt(searchParams.get("limit") ?? "10", 10);

  if (!topicSlug) {
    return NextResponse.json({ error: "topic param required" }, { status: 400 });
  }

  const supabase = await createClient();

  // Resolve topic
  const { data: topic } = await supabase
    .from("topics")
    .select("id")
    .eq("slug", topicSlug)
    .single();

  if (!topic) {
    return NextResponse.json({ error: "Topic not found" }, { status: 404 });
  }

  // Fetch all questions for topic
  const { data: questions, error } = await supabase
    .from("questions")
    .select("id, question_text, option_a, option_b, option_c, option_d, correct_option, explanation")
    .eq("topic_id", topic.id);

  if (error || !questions) {
    return NextResponse.json({ error: "Failed to fetch questions" }, { status: 500 });
  }

  // Shuffle and take limit
  const shuffled = questions.sort(() => Math.random() - 0.5).slice(0, limit);

  return NextResponse.json({ questions: shuffled });
}
