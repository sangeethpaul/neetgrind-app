"use client";

import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { Home, ArrowLeft, LogOut, Loader2 } from "lucide-react";
import { useState, useEffect, Suspense } from "react";

function HeaderContent() {
  const pathname = usePathname();
  const router = useRouter();
  const searchParams = useSearchParams();
  const [loading, setLoading] = useState(false);

  const subjectParam = searchParams.get("subject");
  const isMainMenu = pathname === "/dashboard";
  const isActiveTest = pathname.startsWith("/dashboard/test/") && pathname !== "/dashboard/test";
  const isStudyDetail = pathname.startsWith("/dashboard/study/") && pathname !== "/dashboard/study";

  // Hide header entirely in active tests for distraction-free concentration
  if (isActiveTest) return null;

  async function handleSignOut() {
    setLoading(true);
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/login");
    router.refresh();
  }

  // Determine Title
  let title = "NeetGrind";
  if (pathname === "/dashboard/study") {
    title = subjectParam ? subjectParam.toUpperCase() : "FUEL";
  } else if (pathname === "/dashboard/test") {
    title = subjectParam ? subjectParam.toUpperCase() : "SMASH";
  } else if (pathname === "/dashboard/leaderboard") {
    title = "CLIMB";
  } else if (pathname === "/dashboard/calendar") {
    title = "CALENDAR";
  } else if (isStudyDetail) {
    // Extract subject name from slug (e.g. biology-class-11-ch-1)
    if (pathname.includes("/biology-")) title = "BIOLOGY";
    else if (pathname.includes("/chemistry-")) title = "CHEMISTRY";
    else if (pathname.includes("/physics-")) title = "PHYSICS";
    else title = "FUEL";
  }

  // Determine Back Destination
  let backHref = "/dashboard";
  if (pathname === "/dashboard/study" && subjectParam) {
    backHref = "/dashboard/study";
  } else if (pathname === "/dashboard/test" && subjectParam) {
    backHref = "/dashboard/test";
  } else if (isStudyDetail) {
    let subjectSlug = "biology";
    if (pathname.includes("/chemistry-")) subjectSlug = "chemistry";
    else if (pathname.includes("/physics-")) subjectSlug = "physics";
    backHref = `/dashboard/study?subject=${subjectSlug}`;
  }

  return (
    <header className="w-full border-b border-white/8 backdrop-blur-md sticky top-0 z-50 bg-background/80 select-none">
      <div className="max-w-4xl mx-auto px-4 h-16 flex items-center justify-between">
        {/* Left: Home Button */}
        <div className="w-20 flex justify-start">
          {!isMainMenu ? (
            <Link
              href="/dashboard"
              className={cn(
                buttonVariants({ variant: "ghost", size: "icon" }),
                "rounded-xl border border-white/10 bg-white/5 hover:bg-white/10 h-10 w-10 text-white transition-all duration-300"
              )}
              title="Home"
            >
              <Home className="w-4 h-4" />
            </Link>
          ) : (
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-amber-500 flex items-center justify-center shadow-lg shadow-blue-500/20">
              <span className="text-white font-bold text-xs">NG</span>
            </div>
          )}
        </div>

        {/* Center: Title */}
        <h1 className="font-poppins font-black text-xl tracking-wider text-white text-center flex-1">
          {title}
        </h1>

        {/* Right: Back Button / Logout */}
        <div className="w-20 flex justify-end">
          {isMainMenu ? (
            <button
              onClick={handleSignOut}
              disabled={loading}
              className={cn(
                buttonVariants({ variant: "ghost", size: "icon" }),
                "rounded-xl border border-white/10 bg-white/5 hover:bg-red-500/10 hover:text-red-400 hover:border-red-500/20 h-10 w-10 transition-all duration-300"
              )}
              title="Sign Out"
            >
              {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <LogOut className="w-4 h-4" />}
            </button>
          ) : (
            <Link
              href={backHref}
              className={cn(
                buttonVariants({ variant: "ghost", size: "sm" }),
                "rounded-xl border border-white/10 bg-white/5 hover:bg-white/10 px-3 h-10 text-[10px] font-black uppercase tracking-wider text-white transition-all duration-300 flex items-center gap-1"
              )}
            >
              <ArrowLeft className="w-3 h-3" />
              Back
            </Link>
          )}
        </div>
      </div>
    </header>
  );
}

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex flex-col bg-background selection:bg-primary/30">
      <Suspense fallback={<div className="h-16 w-full border-b border-white/8 bg-background/80" />}>
        <HeaderContent />
      </Suspense>

      <main className="flex-1 flex flex-col w-full max-w-4xl mx-auto px-4 py-8 md:py-12 animate-fade-in-up">
        {children}
      </main>
    </div>
  );
}
