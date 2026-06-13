"use client";

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { useEffect, useState } from "react";
import { Progress } from "@/components/ui/progress";

interface Props {
  content: string;
}

export default function MarkdownViewer({ content }: Props) {
  const [readProgress, setReadProgress] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      const el = document.documentElement;
      const scrolled = el.scrollTop;
      const total = el.scrollHeight - el.clientHeight;
      if (total > 0) setReadProgress(Math.round((scrolled / total) * 100));
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <>
      {/* Reading progress bar */}
      <div className="fixed top-0 left-0 right-0 z-50 h-0.5">
        <div
          className="h-full bg-gradient-to-r from-blue-500 to-amber-500 transition-all duration-150"
          style={{ width: `${readProgress}%` }}
        />
      </div>

      {/* Content card */}
      <div className="glass-card rounded-2xl border-white/8 p-8 md:p-10">
        {readProgress > 5 && (
          <div className="flex items-center justify-end gap-2 mb-4 text-xs text-muted-foreground">
            <div className="h-1 w-24 bg-white/10 rounded-full overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-blue-500 to-amber-500 transition-all"
                style={{ width: `${readProgress}%` }}
              />
            </div>
            <span>{readProgress}% read</span>
          </div>
        )}
        <div className="markdown-content">
          <ReactMarkdown remarkPlugins={[remarkGfm]}>{content}</ReactMarkdown>
        </div>
      </div>
    </>
  );
}
