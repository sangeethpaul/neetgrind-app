import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Trophy, Flame, Target } from "lucide-react";

const TIER_CONFIG = {
  gold: { min: 500, label: "🥇 Gold", color: "text-amber-400", bg: "bg-amber-500/15 border-amber-500/30" },
  silver: { min: 200, label: "🥈 Silver", color: "text-slate-300", bg: "bg-slate-500/15 border-slate-500/30" },
  bronze: { min: 50, label: "🥉 Bronze", color: "text-orange-400", bg: "bg-orange-500/15 border-orange-500/30" },
  beginner: { min: 0, label: "📚 Beginner", color: "text-blue-400", bg: "bg-blue-500/15 border-blue-500/30" },
};

function getTier(score: number) {
  if (score >= 500) return TIER_CONFIG.gold;
  if (score >= 200) return TIER_CONFIG.silver;
  if (score >= 50) return TIER_CONFIG.bronze;
  return TIER_CONFIG.beginner;
}

function getRankStyle(rank: number) {
  if (rank === 1) return "text-amber-400 text-xl font-bold";
  if (rank === 2) return "text-slate-300 text-lg font-bold";
  if (rank === 3) return "text-orange-400 text-lg font-bold";
  return "text-muted-foreground text-sm";
}

function getRankIcon(rank: number) {
  if (rank === 1) return "🥇";
  if (rank === 2) return "🥈";
  if (rank === 3) return "🥉";
  return `#${rank}`;
}

export default async function LeaderboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profiles } = await supabase
    .from("profiles")
    .select("id, username, total_score, tests_taken, streak_days")
    .order("total_score", { ascending: false })
    .limit(50);

  const currentUserRank = (profiles?.findIndex((p) => p.id === user.id) ?? -1) + 1;
  const currentUserProfile = profiles?.find((p) => p.id === user.id);

  return (
    <div className="max-w-xl mx-auto space-y-6 w-full select-none">
      {/* Tier legend */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 animate-fade-in-up delay-100">
        {Object.values(TIER_CONFIG).map((tier) => (
          <div key={tier.label} className={`rounded-xl border px-3 py-2 text-xs font-medium ${tier.bg} ${tier.color} text-center`}>
            {tier.label}
            <div className="text-xs opacity-60 mt-0.5">≥ {tier.min} pts</div>
          </div>
        ))}
      </div>

      {/* Your rank card */}
      {currentUserProfile && currentUserRank > 0 && (
        <Card className="glass-card border-blue-500/30 bg-blue-600/10 animate-fade-in-up delay-100">
          <CardContent className="pt-4 pb-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="text-lg font-bold text-blue-400">#{currentUserRank}</div>
                <Avatar className="w-9 h-9 border-2 border-blue-500/40">
                  <AvatarFallback className="bg-blue-600/20 text-blue-300 text-sm">
                    {currentUserProfile.username.slice(0, 2).toUpperCase()}
                  </AvatarFallback>
                </Avatar>
                <div>
                  <p className="text-sm font-medium">{currentUserProfile.username} <span className="text-xs text-blue-400">(You)</span></p>
                  <p className="text-xs text-muted-foreground">{currentUserProfile.tests_taken} tests taken</p>
                </div>
              </div>
              <div className="text-right">
                <div className="font-poppins text-xl font-bold text-blue-300">{currentUserProfile.total_score}</div>
                <div className="text-xs text-muted-foreground">pts</div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Top 3 podium */}
      {profiles && profiles.length >= 3 && (
        <div className="flex items-end justify-center gap-4 py-4 animate-fade-in-up delay-200">
          {/* 2nd */}
          <div className="text-center flex-1">
            <Avatar className="w-12 h-12 mx-auto border-2 border-slate-400/40 mb-2">
              <AvatarFallback className="bg-slate-600/20 text-slate-300">
                {profiles[1].username.slice(0, 2).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="text-sm font-medium truncate">{profiles[1].username}</div>
            <div className="font-poppins font-bold text-slate-300">{profiles[1].total_score}</div>
            <div className="bg-slate-500/20 rounded-xl py-6 mt-2 border border-slate-500/20 text-2xl">🥈</div>
          </div>
          {/* 1st */}
          <div className="text-center flex-1">
            <div className="text-lg mb-1">👑</div>
            <Avatar className="w-14 h-14 mx-auto border-2 border-amber-400/50 mb-2">
              <AvatarFallback className="bg-amber-600/20 text-amber-300 text-lg">
                {profiles[0].username.slice(0, 2).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="text-sm font-medium truncate">{profiles[0].username}</div>
            <div className="font-poppins font-bold text-amber-400">{profiles[0].total_score}</div>
            <div className="bg-amber-500/20 rounded-xl py-8 mt-2 border border-amber-500/30 text-2xl">🥇</div>
          </div>
          {/* 3rd */}
          <div className="text-center flex-1">
            <Avatar className="w-12 h-12 mx-auto border-2 border-orange-400/40 mb-2">
              <AvatarFallback className="bg-orange-600/20 text-orange-300">
                {profiles[2].username.slice(0, 2).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div className="text-sm font-medium truncate">{profiles[2].username}</div>
            <div className="font-poppins font-bold text-orange-400">{profiles[2].total_score}</div>
            <div className="bg-orange-500/20 rounded-xl py-5 mt-2 border border-orange-500/20 text-2xl">🥉</div>
          </div>
        </div>
      )}

      {/* Full rankings table */}
      <Card className="glass-card border-white/8 animate-fade-in-up delay-300">
        <CardHeader className="pb-3">
          <CardTitle className="text-base font-semibold">All Rankings</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <div className="divide-y divide-white/8">
            {profiles?.map((profile, index) => {
              const rank = index + 1;
              const tier = getTier(profile.total_score);
              const isMe = profile.id === user.id;
              return (
                <div
                  key={profile.id}
                  className={`flex items-center gap-4 px-5 py-3.5 transition-colors ${
                    isMe ? "bg-blue-600/10" : "hover:bg-white/3"
                  } animate-fade-in-up`}
                  style={{ animationDelay: `${index * 40}ms` }}
                >
                  {/* Rank */}
                  <div className={`w-8 text-center ${getRankStyle(rank)}`}>
                    {getRankIcon(rank)}
                  </div>

                  {/* Avatar */}
                  <Avatar className="w-8 h-8 flex-shrink-0">
                    <AvatarFallback className="text-xs bg-white/8">
                      {profile.username.slice(0, 2).toUpperCase()}
                    </AvatarFallback>
                  </Avatar>

                  {/* Name */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className={`text-sm font-medium truncate ${isMe ? "text-blue-300" : ""}`}>
                        {profile.username}
                        {isMe && <span className="text-xs text-blue-400 ml-1">You</span>}
                      </span>
                    </div>
                    <div className="flex items-center gap-3 text-xs text-muted-foreground mt-0.5">
                      <span className="flex items-center gap-1">
                        <Target className="w-3 h-3" />
                        {profile.tests_taken} tests
                      </span>
                      {profile.streak_days > 0 && (
                        <span className="flex items-center gap-1 text-amber-400">
                          <Flame className="w-3 h-3" />
                          {profile.streak_days}d streak
                        </span>
                      )}
                    </div>
                  </div>

                  {/* Tier */}
                  <Badge className={`text-xs hidden sm:flex ${tier.bg} ${tier.color}`}>
                    {tier.label}
                  </Badge>

                  {/* Score */}
                  <div className="text-right">
                    <div className={`font-poppins font-bold ${tier.color}`}>
                      {profile.total_score.toLocaleString()}
                    </div>
                    <div className="text-xs text-muted-foreground">pts</div>
                  </div>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
