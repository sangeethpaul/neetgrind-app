import Link from "next/link";
import { buttonVariants } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { BookOpen, Zap, Trophy, Calendar, ArrowRight, Star } from "lucide-react";
import { cn } from "@/lib/utils";

export default function HomePage() {
  const features = [
    {
      icon: Calendar,
      title: "Learning Calendar",
      description: "Plan your study schedule with a colour-coded calendar. Track progress across Physics, Chemistry & Biology.",
      color: "text-blue-400",
      bg: "bg-blue-500/10",
    },
    {
      icon: BookOpen,
      title: "NCERT Study Mode",
      description: "Distraction-free NCERT Markdown reader with scroll tracking. Read, highlight, and master every concept.",
      color: "text-emerald-400",
      bg: "bg-emerald-500/10",
    },
    {
      icon: Zap,
      title: "Mock Test Mode",
      description: "10 random MCQs per topic with a countdown timer. NEET scoring (+4/–1) in a minimalist interface.",
      color: "text-amber-400",
      bg: "bg-amber-500/10",
    },
    {
      icon: Trophy,
      title: "Gamified Leaderboard",
      description: "Earn XP, unlock Gold/Silver/Bronze tiers, and climb the global leaderboard after every test.",
      color: "text-purple-400",
      bg: "bg-purple-500/10",
    },
  ];

  const stats = [
    { value: "3", label: "Subjects" },
    { value: "15+", label: "Topics" },
    { value: "180+", label: "MCQs" },
    { value: "+4/–1", label: "NEET Scoring" },
  ];

  return (
    <div className="min-h-screen hero-gradient">
      {/* Navigation */}
      <nav className="border-b border-white/8 backdrop-blur-md sticky top-0 z-50 bg-background/60">
        <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-500 to-amber-500 flex items-center justify-center">
              <Star className="w-4 h-4 text-white" />
            </div>
            <span className="font-poppins font-bold text-xl gradient-text">NeetGrind</span>
          </div>
          <div className="flex items-center gap-3">
            <Link
              href="/login"
              className={cn(buttonVariants({ variant: "ghost", size: "sm" }))}
            >
              Sign In
            </Link>
            <Link
              href="/signup"
              className={cn(
                buttonVariants({ size: "sm" }),
                "bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-500 hover:to-blue-400"
              )}
            >
              Get Started Free
            </Link>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="max-w-7xl mx-auto px-6 pt-24 pb-20 text-center">
        <div className="animate-fade-in-up">
          <Badge className="mb-6 bg-blue-500/15 text-blue-300 border-blue-500/30 text-sm px-4 py-1.5">
            🎯 Built for NEET 2025 aspirants
          </Badge>
          <h1 className="font-poppins text-5xl md:text-7xl font-bold mb-6 leading-tight">
            Crack NEET with{" "}
            <span className="gradient-text">Smart Preparation</span>
          </h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-10 leading-relaxed">
            Your all-in-one NEET prep portal — personalised study calendar, NCERT
            notes, timed mock tests, and a gamified leaderboard to keep you motivated.
          </p>
          <div className="flex items-center justify-center gap-4 flex-wrap">
            <Link
              href="/signup"
              className={cn(
                buttonVariants({ size: "lg" }),
                "bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-500 hover:to-blue-400 glow-blue text-base px-8 h-12"
              )}
            >
              Start Preparing Now <ArrowRight className="ml-2 w-4 h-4" />
            </Link>
            <Link
              href="/login"
              className={cn(
                buttonVariants({ variant: "outline", size: "lg" }),
                "text-base px-8 h-12 border-white/15"
              )}
            >
              Sign In
            </Link>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-20 animate-fade-in-up delay-200">
          {stats.map((stat) => (
            <div key={stat.label} className="glass-card rounded-2xl p-6">
              <div className="font-poppins text-3xl font-bold gradient-text">{stat.value}</div>
              <div className="text-sm text-muted-foreground mt-1">{stat.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* Features */}
      <section className="max-w-7xl mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="font-poppins text-4xl font-bold mb-4">Everything You Need to Succeed</h2>
          <p className="text-muted-foreground text-lg">Four powerful pillars of NEET preparation</p>
        </div>
        <div className="grid md:grid-cols-2 gap-6">
          {features.map((feature, i) => (
            <div
              key={feature.title}
              className="glass-card rounded-2xl p-8 hover:border-white/15 transition-all duration-300 hover:translate-y-[-2px] animate-fade-in-up"
              style={{ animationDelay: `${i * 100}ms` }}
            >
              <div className={`w-12 h-12 rounded-xl ${feature.bg} flex items-center justify-center mb-5`}>
                <feature.icon className={`w-6 h-6 ${feature.color}`} />
              </div>
              <h3 className="font-poppins text-xl font-semibold mb-3">{feature.title}</h3>
              <p className="text-muted-foreground leading-relaxed">{feature.description}</p>
            </div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="max-w-7xl mx-auto px-6 py-20">
        <div className="glass-card rounded-3xl p-12 text-center relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-blue-600/10 to-amber-500/10 rounded-3xl" />
          <div className="relative z-10">
            <h2 className="font-poppins text-4xl font-bold mb-4">Ready to Ace NEET?</h2>
            <p className="text-muted-foreground text-lg mb-8">
              Join thousands of students on their NEET journey. It's free to start.
            </p>
            <Link
              href="/signup"
              className={cn(
                buttonVariants({ size: "lg" }),
                "bg-gradient-to-r from-amber-500 to-amber-400 hover:from-amber-400 hover:to-amber-300 text-black font-semibold glow-gold text-base px-10 h-12"
              )}
            >
              Create Free Account <ArrowRight className="ml-2 w-4 h-4" />
            </Link>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-white/8 py-8 text-center text-muted-foreground text-sm">
        <p>© 2025 NeetGrind · Built for NEET Aspirants</p>
      </footer>
    </div>
  );
}
