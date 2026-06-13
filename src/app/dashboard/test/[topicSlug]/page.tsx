import { createClient } from "@/lib/supabase/server";
import { notFound, redirect } from "next/navigation";
import TestInterface from "@/components/TestInterface";

interface Props {
  params: Promise<{ topicSlug: string }>;
}

export default async function TestPage({ params }: Props) {
  const { topicSlug } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: topic } = await supabase
    .from("topics")
    .select("id, name, slug")
    .eq("slug", topicSlug)
    .single();

  if (!topic) notFound();

  return <TestInterface topicSlug={topicSlug} topicName={topic.name} />;
}
