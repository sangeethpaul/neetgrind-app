import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { BookOpen, Zap, Trophy, Flame, Target, ChevronRight } from "lucide-react";
import Link from "next/link";

export default async function DashboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Fetch profile
  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  // Leaderboard rank
  const { data: allProfiles } = await supabase
    .from("profiles")
    .select("id, total_score")
    .order("total_score", { ascending: false });
  const rank = (allProfiles?.findIndex((p) => p.id === user.id) ?? -1) + 1;

  const score = profile?.total_score ?? 0;

  const menuItems = [
    {
      href: "/dashboard/study",
      title: "FUEL",
      subtitle: "STUDY NCERT NOTES",
      desc: "Exhaustive fact-based review of Biology, Chemistry, and Physics chapters.",
      color: "from-blue-600/20 via-blue-500/10 to-transparent border-blue-500/25 hover:border-blue-500/50 shadow-blue-500/5 hover:shadow-blue-500/10",
      textColor: "text-blue-400",
      accentBg: "bg-blue-500/10",
      icon: BookOpen,
    },
    {
      href: "/dashboard/test",
      title: "SMASH",
      subtitle: "TAKE MOCK TESTS",
      desc: "Practice with custom 10-MCQ challenges under time constraints with real scoring.",
      color: "from-amber-600/20 via-amber-500/10 to-transparent border-amber-500/25 hover:border-amber-500/50 shadow-amber-500/5 hover:shadow-amber-500/10",
      textColor: "text-amber-400",
      accentBg: "bg-amber-500/10",
      icon: Zap,
    },
    {
      href: "/dashboard/leaderboard",
      title: "CLIMB",
      subtitle: "LEADERBOARD",
      desc: "Compare score rankings and view the absolute top NEET aspirants.",
      color: "from-purple-600/20 via-purple-500/10 to-transparent border-purple-500/25 hover:border-purple-500/50 shadow-purple-500/5 hover:shadow-purple-500/10",
      textColor: "text-purple-400",
      accentBg: "bg-purple-500/10",
      icon: Trophy,
    },
  ];

  return (
    <div className="space-y-8 w-full max-w-xl mx-auto flex-1 flex flex-col justify-center select-none">
      {/* Hand-drawn look brand header */}
      <div className="text-center space-y-1 animate-fade-in-up">
        <h2 className="font-poppins font-black text-4xl tracking-tight text-white relative inline-block">
          NeetGrind
          <div className="absolute left-0 right-0 h-1.5 bg-gradient-to-r from-blue-500 via-teal-400 to-amber-500 rounded-full mt-1.5" />
        </h2>
        <div className="pt-4 flex items-center justify-center gap-1.5 text-muted-foreground text-sm font-semibold">
          <span>👋 Welcome, {profile?.username ?? "Scholar"}</span>
          <span className="text-white/20">•</span>
          <span className="flex items-center gap-1 text-amber-400 font-bold bg-amber-500/10 px-2 py-0.5 rounded-full text-xs">
            <Flame className="w-3 h-3 fill-current" />
            {profile?.streak_days ?? 0} Day Streak
          </span>
        </div>
      </div>

      {/* Main Menu Stack */}
      <div className="space-y-4 animate-fade-in-up delay-100">
        {menuItems.map((item) => (
          <Link key={item.title} href={item.href} className="block group">
            <Card className={`glass-card bg-slate-950/40 border bg-gradient-to-r ${item.color} rounded-2xl overflow-hidden hover:scale-[1.01] transition-all duration-300 cursor-pointer`}>
              <CardContent className="p-6 flex items-center justify-between gap-4">
                <div className="flex items-center gap-4">
                  <div className={`w-12 h-12 rounded-xl ${item.accentBg} flex items-center justify-center border border-white/5`}>
                    <item.icon className={`w-5 h-5 ${item.textColor}`} />
                  </div>
                  <div className="text-left">
                    <p className={`text-[10px] font-black tracking-[0.2em] opacity-80 ${item.textColor}`}>
                      {item.subtitle}
                    </p>
                    <h3 className="font-poppins font-black text-2xl text-white tracking-tight mt-0.5">
                      {item.title}
                    </h3>
                    <p className="text-xs text-muted-foreground mt-1 leading-relaxed max-w-sm">
                      {item.desc}
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:text-white group-hover:translate-x-1 transition-all flex-shrink-0" />
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>

      {/* Mini Stats Bar */}
      <div className="grid grid-cols-3 gap-3 animate-fade-in-up delay-200">
        {[
          { label: "Total Score", value: score.toLocaleString(), icon: Target, color: "text-blue-400 bg-blue-500/5" },
          { label: "Tests Taken", value: profile?.tests_taken ?? 0, icon: Zap, color: "text-emerald-400 bg-emerald-500/5" },
          { label: "Global Rank", value: rank > 0 ? `#${rank}` : "—", icon: Trophy, color: "text-purple-400 bg-purple-500/5" },
        ].map((stat) => (
          <div key={stat.label} className={`glass-card bg-slate-950/20 border border-white/5 rounded-xl px-3 py-2.5 flex flex-col items-center justify-center ${stat.color}`}>
            <p className="text-[9px] font-bold text-muted-foreground uppercase tracking-wider text-center">{stat.label}</p>
            <p className="text-lg font-black tracking-tight text-white mt-0.5">{stat.value}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
