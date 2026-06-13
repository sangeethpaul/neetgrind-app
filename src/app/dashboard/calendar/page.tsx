import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import LearningCalendar from "@/components/LearningCalendar";

export default async function CalendarPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Fetch calendar events for current month
  const now = new Date();
  const firstDay = new Date(now.getFullYear(), now.getMonth(), 1).toISOString().split("T")[0];
  const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0).toISOString().split("T")[0];
  const { data: calendarEvents } = await supabase
    .from("calendar_events")
    .select("*, subjects(name, color, icon), topics(name)")
    .eq("user_id", user.id)
    .gte("date", firstDay)
    .lte("date", lastDay);

  return (
    <div className="space-y-6 max-w-xl mx-auto w-full select-none">
      <div className="animate-fade-in-up">
        <LearningCalendar
          userId={user.id}
          events={calendarEvents ?? []}
        />
      </div>
    </div>
  );
}
