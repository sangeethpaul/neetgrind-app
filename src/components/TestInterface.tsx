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

  const loadQuestions = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch(`/api/questions?topic=${topicSlug}&limit=10`);
      const data = await res.json();
      setQuestions(data.questions ?? []);
    } catch (err) {
      console.error("Failed to load questions:", err);
    } finally {
      setLoading(false);
    }
  }, [topicSlug]);

  // Load questions
  useEffect(() => {
    loadQuestions();
  }, [loadQuestions]);

  const handleRetake = useCallback(async () => {
    setAnswers({});
    setCurrentQ(0);
    setTimeLeft(SECONDS_PER_QUESTION);
    setSubmitted(false);
    setResult(null);
    startTime.current = Date.now();
    await loadQuestions();
  }, [loadQuestions]);

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

  if (submitted && result) {
    return (
      <div className="fixed inset-0 bg-background z-[60] flex flex-col animate-fade-in">
        {/* Top bar */}
        <div className="border-b border-white/8 px-6 py-4 flex items-center justify-between bg-black/30 backdrop-blur-md">
          <div>
            <span className="text-xs text-muted-foreground">Review Session · </span>
            <span className="text-sm font-semibold">{topicName}</span>
          </div>
          <div>
            <Button
              onClick={handleRetake}
              className="bg-gradient-to-r from-amber-500 to-amber-400 text-black font-bold hover:from-amber-400 rounded-xl h-9 px-4 text-xs shadow-md"
            >
              Smash Again
            </Button>
          </div>
        </div>

        {/* Scrollable content */}
        <div className="flex-1 overflow-y-auto px-4 py-8 flex justify-center">
          <div className="w-full max-w-2xl space-y-8 pb-16">
            
            {/* Scorecard Card */}
            <div className="glass-card rounded-3xl p-8 border-white/10 text-center space-y-6 bg-white/5 backdrop-blur-md">
              <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-amber-500/20 to-amber-500/5 border border-amber-500/30 flex items-center justify-center mx-auto">
                <Trophy className="w-7 h-7 text-amber-400" />
              </div>
              <div>
                <h2 className="font-poppins text-2xl font-bold">Smash Session Complete!</h2>
                <p className="text-muted-foreground text-sm">Review your questions and explanations below.</p>
              </div>

              <div className="flex justify-center items-baseline gap-2">
                <span className={`text-6xl font-poppins font-black ${
                  result.score > 0 ? "text-emerald-400" : "text-red-400"
                }`}>
                  {result.score > 0 ? "+" : ""}{result.score}
                </span>
                <span className="text-sm text-muted-foreground">NEET Score</span>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div className="glass-card rounded-2xl p-4 border-emerald-500/10 bg-emerald-500/5">
                  <CheckCircle2 className="w-5 h-5 text-emerald-400 mx-auto mb-1" />
                  <div className="text-2xl font-black text-emerald-400">{result.correct}</div>
                  <div className="text-xs text-emerald-300 font-semibold">Correct</div>
                </div>
                <div className="glass-card rounded-2xl p-4 border-red-500/10 bg-red-500/5">
                  <XCircle className="w-5 h-5 text-red-400 mx-auto mb-1" />
                  <div className="text-2xl font-black text-red-400">{result.wrong}</div>
                  <div className="text-xs text-red-300 font-semibold">Wrong</div>
                </div>
                <div className="glass-card rounded-2xl p-4 border-white/5 bg-white/5">
                  <Minus className="w-5 h-5 text-muted-foreground mx-auto mb-1" />
                  <div className="text-2xl font-black">{result.unattempted}</div>
                  <div className="text-xs text-muted-foreground font-semibold">Skipped</div>
                </div>
              </div>

              <div className="flex gap-3 pt-2">
                <Button
                  onClick={handleRetake}
                  className="flex-1 bg-gradient-to-r from-amber-500 to-amber-400 text-black font-bold hover:from-amber-400 rounded-xl h-11"
                >
                  Smash Again
                </Button>
                <Link
                  href="/dashboard/study"
                  className={cn(buttonVariants({ variant: "outline" }), "flex-1 border-white/10 rounded-xl h-11")}
                >
                  Try Another
                </Link>
                <Link
                  href="/dashboard/leaderboard"
                  className={cn(buttonVariants({ variant: "outline" }), "flex-1 border-white/10 rounded-xl h-11")}
                >
                  Leaderboard <ArrowRight className="w-4 h-4 ml-2" />
                </Link>
              </div>
            </div>

            {/* Questions Detailed Review List */}
            <div className="space-y-6">
              <h3 className="font-poppins text-lg font-bold">Detailed Review</h3>
              {questions.map((q, idx) => {
                const userAns = answers[q.id];
                const correctAns = q.correct_option;
                const isCorrect = userAns === correctAns;

                return (
                  <div key={q.id} className="glass-card rounded-3xl p-6 border-white/8 space-y-6 bg-white/2">
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-bold uppercase tracking-wider text-muted-foreground">
                        Question {idx + 1}
                      </span>
                      {userAns === undefined ? (
                        <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-white/5 text-muted-foreground">
                          Skipped (0 XP)
                        </span>
                      ) : isCorrect ? (
                        <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                          Correct (+4 XP)
                        </span>
                      ) : (
                        <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-red-500/10 text-red-400 border border-red-500/20">
                          Incorrect (-1 XP)
                        </span>
                      )}
                    </div>

                    <h4 className="font-poppins text-lg font-medium leading-snug">
                      {q.question_text}
                    </h4>

                    <div className="grid gap-3">
                      {(["A", "B", "C", "D"] as const).map((opt) => {
                        const optText = q[`option_${opt.toLowerCase()}` as keyof Question] as string;
                        const isCorrectOpt = opt === correctAns;
                        const isSelectedOpt = opt === userAns;

                        let optStyle = "border-white/5 opacity-70 pointer-events-none";
                        let icon = (
                          <div className="w-7 h-7 rounded-lg bg-white/5 text-muted-foreground flex items-center justify-center text-xs font-bold flex-shrink-0">
                            {opt}
                          </div>
                        );

                        if (isCorrectOpt) {
                          optStyle = "bg-emerald-500/10 border-emerald-500/30 text-foreground ring-1 ring-emerald-500/10 pointer-events-none";
                          icon = (
                            <div className="w-7 h-7 rounded-lg bg-emerald-500 text-white flex items-center justify-center text-xs font-bold flex-shrink-0 shadow-lg shadow-emerald-500/20">
                              <CheckCircle2 className="w-3.5 h-3.5" />
                            </div>
                          );
                        } else if (isSelectedOpt) {
                          optStyle = "bg-red-500/10 border-red-500/30 text-foreground ring-1 ring-red-500/10 pointer-events-none";
                          icon = (
                            <div className="w-7 h-7 rounded-lg bg-red-500 text-white flex items-center justify-center text-xs font-bold flex-shrink-0 shadow-lg shadow-red-500/20">
                              <XCircle className="w-3.5 h-3.5" />
                            </div>
                          );
                        }

                        return (
                          <div
                            key={opt}
                            className={cn(
                              "w-full flex items-center gap-4 p-4 rounded-xl border text-left text-sm",
                              optStyle
                            )}
                          >
                            {icon}
                            <span className="font-medium leading-relaxed">{optText}</span>
                          </div>
                        );
                      })}
                    </div>

                    {/* Explanation */}
                    <div className="mt-6 p-5 rounded-2xl bg-blue-500/5 border border-blue-500/10 space-y-2">
                      <div className="flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-blue-300">
                        <span>💡</span> Explanation
                      </div>
                      <p className="text-sm leading-relaxed text-muted-foreground">
                        {q.explanation || `The correct option is ${correctAns}.`}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Bottom Retake Buttons */}
            <div className="flex gap-4 pt-6 justify-center">
              <Button
                onClick={handleRetake}
                className="bg-gradient-to-r from-amber-500 to-amber-400 text-black font-bold hover:from-amber-400 rounded-xl h-12 px-8 shadow-lg shadow-amber-500/25"
              >
                Smash Again
              </Button>
              <Link
                href="/dashboard/study"
                className={cn(buttonVariants({ variant: "outline" }), "border-white/10 rounded-xl h-12 px-8")}
              >
                Choose Another Subject
              </Link>
            </div>

          </div>
        </div>
      </div>
    );
  }

  return (
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
  );
}
