"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { Question } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { buttonVariants } from "@/components/ui/button";
import { Dialog, DialogContent } from "@/components/ui/dialog";
import {
  Clock,
  ChevronLeft,
  ChevronRight,
  CheckCircle2,
  XCircle,
  Minus,
  Trophy,
  ArrowRight,
  Loader2,
} from "lucide-react";
import Link from "next/link";
import { cn } from "@/lib/utils";

const SECONDS_PER_QUESTION = 30;

interface Props {
  topicSlug: string;
  topicName: string;
}

type AnswerState = Record<number, string>;

export default function TestInterface({ topicSlug, topicName }: Props) {
  const router = useRouter();
  const [questions, setQuestions] = useState<Question[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentQ, setCurrentQ] = useState(0);
  const [answers, setAnswers] = useState<AnswerState>({});
  const [timeLeft, setTimeLeft] = useState(SECONDS_PER_QUESTION);
  const [submitted, setSubmitted] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<{
    score: number; correct: number; wrong: number; unattempted: number;
  } | null>(null);
  const startTime = useRef(Date.now());

  // Load questions
  useEffect(() => {
    async function load() {
      const res = await fetch(`/api/questions?topic=${topicSlug}&limit=10`);
      const data = await res.json();
      setQuestions(data.questions ?? []);
      setLoading(false);
    }
    load();
  }, [topicSlug]);

  const handleSubmit = useCallback(async (finalAnswers: AnswerState = answers) => {
    if (submitting || submitted) return;
    setSubmitting(true);
    const elapsed = Math.round((Date.now() - startTime.current) / 1000);
    const res = await fetch("/api/submit-test", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ topicSlug, answers: finalAnswers, durationSeconds: elapsed }),
    });
    const data = await res.json();
    setResult({ score: data.score, correct: data.correct, wrong: data.wrong, unattempted: data.unattempted });
    setSubmitted(true);
    setSubmitting(false);
  }, [submitting, submitted, topicSlug, answers]);

  const handleNext = useCallback(() => {
    if (currentQ < questions.length - 1) {
      setCurrentQ(currentQ + 1);
      setTimeLeft(SECONDS_PER_QUESTION);
    } else {
      handleSubmit();
    }
  }, [currentQ, questions.length, handleSubmit]);

  // Timer
  useEffect(() => {
    if (loading || submitted) return;
    if (timeLeft <= 0) {
      handleNext();
      return;
    }
    const timer = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(timer);
  }, [loading, submitted, timeLeft, handleNext]);

  // Reset timer when manually switching questions
  const goToQuestion = (index: number) => {
    setCurrentQ(index);
    setTimeLeft(SECONDS_PER_QUESTION);
  };

  const answered = Object.keys(answers).length;
  const q = questions[currentQ];

  if (loading) {
    return (
      <div className="fixed inset-0 flex items-center justify-center bg-background z-[100]">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="w-8 h-8 animate-spin text-blue-400" />
          <p className="text-muted-foreground">Loading questions…</p>
        </div>
      </div>
    );
  }

  if (questions.length === 0) {
    return (
      <div className="fixed inset-0 flex items-center justify-center bg-background z-[100]">
        <div className="text-center">
          <h2 className="font-poppins text-xl font-semibold mb-2">No questions available</h2>
          <p className="text-muted-foreground mb-6">Questions for this topic are being added.</p>
          <Link href="/dashboard/study" className={buttonVariants()}>← Back to Topics</Link>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* Full-screen distraction-free test UI */}
      <div className="fixed inset-0 bg-background z-[60] flex flex-col">
        {/* Minimal top bar */}
        <div className="border-b border-white/8 px-6 py-3 flex items-center justify-between">
          <div>
            <span className="text-xs text-muted-foreground">Mock Test · </span>
            <span className="text-sm font-medium">{topicName}</span>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-sm text-muted-foreground">
              Q{currentQ + 1} / {questions.length}
            </span>
            <div className={`flex items-center gap-1.5 text-sm font-mono font-semibold px-4 py-1.5 rounded-lg border transition-colors ${
              timeLeft < 5 ? "text-red-400 bg-red-500/15 border-red-500/30 animate-pulse" :
              timeLeft < 10 ? "text-amber-400 bg-amber-500/15 border-amber-500/30" :
              "text-blue-400 bg-blue-500/10 border-blue-500/20"
            }`}>
              <Clock className="w-4 h-4" />
              {timeLeft}s
            </div>
          </div>
        </div>

        {/* Progress bar */}
        <div className="h-1 bg-white/5">
          <div
            className="h-full bg-gradient-to-r from-blue-500 to-amber-500 transition-all duration-300"
            style={{ width: `${(timeLeft / SECONDS_PER_QUESTION) * 100}%` }}
          />
        </div>

        {/* Question area */}
        <div className="flex-1 overflow-y-auto flex items-start justify-center px-4 py-10 md:py-20">
          <div className="w-full max-w-2xl">
            <div className="flex items-center gap-3 mb-8">
              <div className="w-10 h-10 rounded-xl bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-sm font-bold text-blue-300">
                {currentQ + 1}
              </div>
              <div className="text-sm text-muted-foreground">
                {answered} of {questions.length} completed
              </div>
            </div>

            <h2 className="font-poppins text-2xl font-semibold leading-snug mb-10">
              {q.question_text}
            </h2>

            <div className="grid gap-3">
              {(["A", "B", "C", "D"] as const).map((opt) => {
                const optText = q[`option_${opt.toLowerCase()}` as keyof Question] as string;
                const selected = answers[q.id] === opt;
                return (
                  <button
                    key={opt}
                    onClick={() => setAnswers((prev) => ({ ...prev, [q.id]: opt }))}
                    className={`w-full flex items-center gap-4 p-5 rounded-2xl border text-left transition-all duration-200 group ${
                      selected
                        ? "bg-blue-600/20 border-blue-500/60 text-foreground ring-1 ring-blue-500/20"
                        : "border-white/8 hover:border-white/20 hover:bg-white/5 text-foreground"
                    }`}
                  >
                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-sm font-bold flex-shrink-0 transition-colors ${
                      selected ? "bg-blue-500 text-white shadow-lg shadow-blue-500/20" : "bg-white/5 text-muted-foreground group-hover:bg-white/10"
                    }`}>
                      {opt}
                    </div>
                    <span className="text-base font-medium leading-relaxed">{optText}</span>
                  </button>
                );
              })}
            </div>

            {/* Navigation */}
            <div className="flex items-center justify-between mt-12 pt-8 border-t border-white/5">
              <Button
                variant="ghost"
                onClick={() => goToQuestion(Math.max(0, currentQ - 1))}
                disabled={currentQ === 0}
                className="rounded-xl h-11"
              >
                <ChevronLeft className="w-4 h-4 mr-2" />
                Previous
              </Button>

              <div className="hidden sm:flex gap-1.5 flex-wrap justify-center">
                {questions.map((q, i) => (
                  <button
                    key={q.id}
                    onClick={() => goToQuestion(i)}
                    className={`w-7 h-7 rounded-lg text-xs font-bold transition-all ${
                      i === currentQ
                        ? "bg-blue-500 text-white scale-110 shadow-lg shadow-blue-500/20"
                        : answers[q.id]
                        ? "bg-emerald-500/20 text-emerald-400 border border-emerald-500/20"
                        : "bg-white/5 text-muted-foreground hover:bg-white/10"
                    }`}
                  >
                    {i + 1}
                  </button>
                ))}
              </div>

              {currentQ < questions.length - 1 ? (
                <Button
                  onClick={handleNext}
                  className="bg-blue-600 hover:bg-blue-500 text-white rounded-xl h-11 px-6 font-semibold"
                >
                  Next
                  <ChevronRight className="w-4 h-4 ml-2" />
                </Button>
              ) : (
                <Button
                  onClick={() => handleSubmit()}
                  disabled={submitting}
                  className="bg-gradient-to-r from-amber-500 to-amber-400 text-black font-bold hover:from-amber-400 rounded-xl h-11 px-8 shadow-lg shadow-amber-500/20"
                >
                  {submitting ? <Loader2 className="w-4 h-4 animate-spin" /> : "Finish Test"}
                </Button>
              )}
            </div>

            <div className="mt-8 text-center">
              <button
                onClick={() => handleSubmit()}
                disabled={submitting}
                className="text-xs font-medium text-muted-foreground hover:text-red-400 transition-colors uppercase tracking-widest flex items-center justify-center gap-2 mx-auto"
              >
                <XCircle className="w-3 h-3" />
                Quit and Submit Result
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Score Summary Modal */}
      <Dialog open={submitted && !!result}>
        <DialogContent className="glass-card border-white/15 max-w-md">
          <div className="text-center space-y-6 py-2">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-amber-500/20 to-amber-500/5 border border-amber-500/30 flex items-center justify-center mx-auto animate-count-up">
              <Trophy className="w-8 h-8 text-amber-400" />
            </div>

            <div>
              <h2 className="font-poppins text-2xl font-bold mb-1">Test Complete!</h2>
              <p className="text-muted-foreground text-sm">{topicName}</p>
            </div>

            <div className={`text-5xl font-poppins font-bold animate-count-up ${
              (result?.score ?? 0) > 0 ? "text-emerald-400" : "text-red-400"
            }`}>
              {(result?.score ?? 0) > 0 ? "+" : ""}{result?.score ?? 0}
            </div>
            <p className="text-xs text-muted-foreground -mt-4">NEET Score</p>

            <div className="grid grid-cols-3 gap-3">
              <div className="glass-card rounded-xl p-3 border-emerald-500/20">
                <CheckCircle2 className="w-5 h-5 text-emerald-400 mx-auto mb-1" />
                <div className="text-xl font-bold text-emerald-400">{result?.correct ?? 0}</div>
                <div className="text-xs text-muted-foreground">Correct</div>
              </div>
              <div className="glass-card rounded-xl p-3 border-red-500/20">
                <XCircle className="w-5 h-5 text-red-400 mx-auto mb-1" />
                <div className="text-xl font-bold text-red-400">{result?.wrong ?? 0}</div>
                <div className="text-xs text-muted-foreground">Wrong</div>
              </div>
              <div className="glass-card rounded-xl p-3 border-white/10">
                <Minus className="w-5 h-5 text-muted-foreground mx-auto mb-1" />
                <div className="text-xl font-bold">{result?.unattempted ?? 0}</div>
                <div className="text-xs text-muted-foreground">Skipped</div>
              </div>
            </div>

            <p className="text-xs text-muted-foreground bg-white/5 rounded-lg px-3 py-2">
              +4 per correct · –1 per wrong · 0 per skipped
            </p>

            <div className="flex gap-3">
              <button
                className={cn(buttonVariants({ variant: "outline" }), "flex-1 border-white/15")}
                onClick={() => router.push("/dashboard/study")}
              >
                Try Another
              </button>
              <button
                className={cn(buttonVariants(), "flex-1 bg-gradient-to-r from-blue-600 to-blue-500")}
                onClick={() => router.push("/dashboard/leaderboard")}
              >
                Leaderboard <ArrowRight className="w-4 h-4 ml-2" />
              </button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
