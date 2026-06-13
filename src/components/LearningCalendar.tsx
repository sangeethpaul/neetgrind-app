"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { CalendarEvent } from "@/lib/types";
import { ChevronLeft, ChevronRight, Plus, BookOpen, Zap, RefreshCw } from "lucide-react";

const DAYS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

const EVENT_CONFIG = {
  study: { label: "Study", color: "bg-blue-500", dot: "bg-blue-400", icon: BookOpen },
  test: { label: "Test", color: "bg-amber-500", dot: "bg-amber-400", icon: Zap },
  revision: { label: "Revision", color: "bg-purple-500", dot: "bg-purple-400", icon: RefreshCw },
};

interface Props {
  userId: string;
  events: CalendarEvent[];
}

export default function LearningCalendar({ userId, events: initialEvents }: Props) {
  const supabase = createClient();
  const [events, setEvents] = useState<CalendarEvent[]>(initialEvents);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [showModal, setShowModal] = useState(false);
  const [newEventType, setNewEventType] = useState<"study" | "test" | "revision">("study");
  const [saving, setSaving] = useState(false);

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();

  const firstDayOfMonth = new Date(year, month, 1).getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  const prevMonth = () => setCurrentDate(new Date(year, month - 1, 1));
  const nextMonth = () => setCurrentDate(new Date(year, month + 1, 1));

  const getEventsForDate = (day: number) => {
    const dateStr = `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
    return events.filter((e) => e.date === dateStr);
  };

  const todayStr = new Date().toISOString().split("T")[0];

  const handleDayClick = (day: number) => {
    const dateStr = `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
    setSelectedDate(dateStr);
    setShowModal(true);
  };

  const handleAddEvent = async () => {
    if (!selectedDate) return;
    setSaving(true);
    const { data, error } = await supabase
      .from("calendar_events")
      .insert({
        user_id: userId,
        date: selectedDate,
        event_type: newEventType,
      })
      .select("*")
      .single();
    if (!error && data) {
      setEvents((prev) => [...prev, data as CalendarEvent]);
    }
    setSaving(false);
    setShowModal(false);
  };

  const toggleComplete = async (eventId: number, current: boolean) => {
    await supabase
      .from("calendar_events")
      .update({ completed: !current })
      .eq("id", eventId);
    setEvents((prev) => prev.map((e) => (e.id === eventId ? { ...e, completed: !current } : e)));
  };

  const selectedDateEvents = events.filter((e) => e.date === selectedDate);

  // Today's events
  const todayEvents = events.filter((e) => e.date === todayStr);

  return (
    <>
      <Card className="glass-card border-white/8">
        <CardHeader className="flex flex-row items-center justify-between pb-4">
          <CardTitle className="font-poppins text-lg flex items-center gap-2">
            📅 Learning Calendar
          </CardTitle>
          <div className="flex items-center gap-2">
            <div className="flex items-center gap-3 text-xs text-muted-foreground">
              {Object.entries(EVENT_CONFIG).map(([key, cfg]) => (
                <span key={key} className="flex items-center gap-1">
                  <span className={`w-2 h-2 rounded-full ${cfg.dot}`} />
                  {cfg.label}
                </span>
              ))}
            </div>
          </div>
        </CardHeader>
        <CardContent>
          {/* Month navigation */}
          <div className="flex items-center justify-between mb-4">
            <Button variant="ghost" size="icon" onClick={prevMonth} className="h-8 w-8">
              <ChevronLeft className="w-4 h-4" />
            </Button>
            <span className="font-poppins font-semibold text-base">
              {MONTHS[month]} {year}
            </span>
            <Button variant="ghost" size="icon" onClick={nextMonth} className="h-8 w-8">
              <ChevronRight className="w-4 h-4" />
            </Button>
          </div>

          {/* Day headers */}
          <div className="grid grid-cols-7 mb-2">
            {DAYS.map((d) => (
              <div key={d} className="text-center text-xs text-muted-foreground font-medium py-1">
                {d}
              </div>
            ))}
          </div>

          {/* Calendar grid */}
          <div className="grid grid-cols-7 gap-1">
            {/* Empty cells */}
            {Array.from({ length: firstDayOfMonth }).map((_, i) => (
              <div key={`empty-${i}`} />
            ))}
            {/* Days */}
            {Array.from({ length: daysInMonth }).map((_, i) => {
              const day = i + 1;
              const dateStr = `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
              const dayEvents = getEventsForDate(day);
              const isToday = dateStr === todayStr;
              return (
                <button
                  key={day}
                  onClick={() => handleDayClick(day)}
                  className={`relative h-10 rounded-lg flex flex-col items-center justify-start pt-1 text-sm transition-all hover:bg-white/8 ${
                    isToday
                      ? "bg-blue-600/25 border border-blue-500/50 text-blue-300 font-semibold"
                      : "text-foreground"
                  }`}
                >
                  <span className="text-xs">{day}</span>
                  {dayEvents.length > 0 && (
                    <div className="flex gap-0.5 mt-0.5">
                      {dayEvents.slice(0, 3).map((ev) => (
                        <div
                          key={ev.id}
                          className={`w-1.5 h-1.5 rounded-full ${EVENT_CONFIG[ev.event_type].dot} ${ev.completed ? "opacity-40" : ""}`}
                        />
                      ))}
                    </div>
                  )}
                </button>
              );
            })}
          </div>

          {/* Today's agenda */}
          {todayEvents.length > 0 && (
            <div className="mt-4 pt-4 border-t border-white/8">
              <p className="text-xs font-medium text-muted-foreground uppercase tracking-wider mb-2">Today's Agenda</p>
              <div className="space-y-2">
                {todayEvents.map((ev) => {
                  const cfg = EVENT_CONFIG[ev.event_type];
                  return (
                    <div
                      key={ev.id}
                      className={`flex items-center gap-2 p-2 rounded-lg ${ev.completed ? "opacity-50" : ""}`}
                    >
                      <div className={`w-6 h-6 rounded-md ${cfg.color} bg-opacity-20 flex items-center justify-center`}>
                        <cfg.icon className="w-3 h-3" />
                      </div>
                      <span className={`text-sm ${ev.completed ? "line-through" : ""}`}>{cfg.label}</span>
                      {ev.topics?.name && (
                        <span className="text-xs text-muted-foreground">— {ev.topics.name}</span>
                      )}
                      <button
                        onClick={() => toggleComplete(ev.id, ev.completed)}
                        className="ml-auto text-xs text-muted-foreground hover:text-foreground"
                      >
                        {ev.completed ? "✓ Done" : "Mark done"}
                      </button>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Add event dialog */}
      <Dialog open={showModal} onOpenChange={setShowModal}>
        <DialogContent className="glass-card border-white/15 max-w-sm">
          <DialogHeader>
            <DialogTitle className="font-poppins">
              {selectedDate ? new Date(selectedDate + "T00:00:00").toLocaleDateString("en-IN", { weekday: "long", day: "numeric", month: "long" }) : ""}
            </DialogTitle>
          </DialogHeader>

          {/* Existing events */}
          {selectedDateEvents.length > 0 && (
            <div className="space-y-2 mb-3">
              {selectedDateEvents.map((ev) => {
                const cfg = EVENT_CONFIG[ev.event_type];
                return (
                  <div key={ev.id} className="flex items-center gap-2 text-sm p-2 rounded-lg bg-white/5">
                    <div className={`w-2 h-2 rounded-full ${cfg.dot}`} />
                    <span>{cfg.label}</span>
                    {ev.completed && <Badge className="text-xs ml-auto bg-emerald-500/15 text-emerald-400 border-emerald-500/30">Done</Badge>}
                  </div>
                );
              })}
            </div>
          )}

          <div className="space-y-3">
            <p className="text-sm text-muted-foreground">Add a new event:</p>
            <div className="grid grid-cols-3 gap-2">
              {(["study", "test", "revision"] as const).map((type) => {
                const cfg = EVENT_CONFIG[type];
                return (
                  <button
                    key={type}
                    onClick={() => setNewEventType(type)}
                    className={`p-3 rounded-xl text-xs font-medium border transition-all ${
                      newEventType === type
                        ? `${cfg.color} bg-opacity-20 border-current text-white`
                        : "border-white/10 text-muted-foreground hover:border-white/20"
                    }`}
                  >
                    <cfg.icon className="w-4 h-4 mx-auto mb-1" />
                    {cfg.label}
                  </button>
                );
              })}
            </div>
            <Button
              onClick={handleAddEvent}
              disabled={saving}
              className="w-full bg-gradient-to-r from-blue-600 to-blue-500"
            >
              <Plus className="w-4 h-4 mr-2" />
              {saving ? "Saving..." : "Add Event"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}
