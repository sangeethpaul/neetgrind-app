import { createClient } from "@/lib/supabase/server";
import { notFound, redirect } from "next/navigation";
import MarkdownViewer from "@/components/MarkdownViewer";
import { Badge } from "@/components/ui/badge";
import { buttonVariants } from "@/components/ui/button";
import Link from "next/link";
import { ArrowLeft, Zap, BookOpen } from "lucide-react";
import { cn } from "@/lib/utils";

interface Props {
  params: Promise<{ topicSlug: string }>;
}

export default async function TopicStudyPage({ params }: Props) {
  const { topicSlug } = await params;
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: topic } = await supabase
    .from("topics")
    .select("*, subjects(name, icon, color, slug), ncert_content(*)")
    .eq("slug", topicSlug)
    .single();

  if (!topic) notFound();

  const content = topic.ncert_content?.[0];

  const subjectAccent: Record<string, string> = {
    physics: "text-blue-400 bg-blue-500/15 border-blue-500/30",
    chemistry: "text-emerald-400 bg-emerald-500/15 border-emerald-500/30",
    biology: "text-amber-400 bg-amber-500/15 border-amber-500/30",
  };
  const accent = subjectAccent[topic.subjects?.slug ?? ""] ?? "text-blue-400 bg-blue-500/15 border-blue-500/30";

  return (
    <div className="max-w-4xl mx-auto w-full select-none">
      {/* Header */}
      <div className="mb-8 animate-fade-in-up">
        <div className="flex items-center gap-2 mb-3">
          <Badge className={`text-xs ${accent}`}>
            {topic.subjects?.icon} {topic.subjects?.name}
          </Badge>
          <Badge className="text-xs bg-white/8 text-muted-foreground border-white/10">
            <BookOpen className="w-3 h-3 mr-1" />
            NCERT Notes
          </Badge>
        </div>
        <h1 className="font-poppins text-3xl font-bold mb-2">{topic.name}</h1>
        {topic.description && (
          <p className="text-muted-foreground">{topic.description}</p>
        )}
      </div>

      {/* PDF content */}
      <div className="animate-fade-in-up delay-100">
        {content && content.pdf_url ? (
          <div className="w-full h-[800px] rounded-2xl overflow-hidden border border-white/10 glass-card">
            <iframe 
              src={`${content.pdf_url}#toolbar=0`} 
              className="w-full h-full"
              title={`PDF viewer for ${topic.name}`}
            />
          </div>
        ) : content && content.pdf_url === null ? (
          <div className="glass-card rounded-2xl p-12 text-center border-amber-500/20 bg-gradient-to-br from-amber-600/10 to-amber-500/5">
            <BookOpen className="w-12 h-12 text-amber-400 mx-auto mb-4 opacity-80" />
            <h3 className="font-poppins text-xl font-bold mb-2 text-amber-400">Rationalized Chapter</h3>
            <p className="text-muted-foreground text-sm max-w-lg mx-auto leading-relaxed">
              NCERT PDF is not available online for this deleted/rationalized chapter. However, MCQ practice remains fully supported.
            </p>
          </div>
        ) : content ? (
          <MarkdownViewer content={content.markdown_body} />
        ) : (
          <div className="glass-card rounded-2xl p-12 text-center">
            <BookOpen className="w-12 h-12 text-muted-foreground mx-auto mb-4 opacity-50" />
            <h3 className="font-poppins text-lg font-semibold mb-2">Content Coming Soon</h3>
            <p className="text-muted-foreground text-sm">NCERT notes for this topic are being prepared.</p>
          </div>
        )}
      </div>

      {/* CTA: Start test */}
      <div className="mt-10 mb-6 p-6 glass-card rounded-2xl border-white/10 flex flex-col sm:flex-row items-center justify-between gap-4 animate-fade-in-up delay-200">
        <div>
          <h3 className="font-poppins font-semibold">Ready to test your knowledge?</h3>
          <p className="text-sm text-muted-foreground">Take a 10-question mock test on {topic.name}</p>
        </div>
        <Link
          href={`/dashboard/test/${topicSlug}`}
          className={cn(
            buttonVariants(),
            "bg-gradient-to-r from-amber-500 to-amber-400 hover:from-amber-400 hover:to-amber-300 text-black font-semibold shrink-0"
          )}
        >
          <Zap className="w-4 h-4 mr-2" />
          Start Test
        </Link>
      </div>
    </div>
  );
}
