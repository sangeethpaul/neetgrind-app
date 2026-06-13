"use client";

import { createClient } from "@/lib/supabase/client";
import { useEffect, useState, Suspense } from "react";
import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { BookOpen, Zap, Loader2, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";
import { useSearchParams } from "next/navigation";

type Subject = {
  id: number;
  name: string;
  slug: string;
  icon: string;
  topics: any[];
};

const physicsPhotos = [
  "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/FourMetricInstruments.JPG/500px-FourMetricInstruments.JPG",
  "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/ParabolicWaterTrajectory.jpg/500px-ParabolicWaterTrajectory.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Porsche_race_car_Verschuur_amk.jpg/500px-Porsche_race_car_Verschuur_amk.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Baseball_pitching_motion_2004.jpg/500px-Baseball_pitching_motion_2004.jpg",
  "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/UGC_1810_and_UGC_1813_in_Arp_273_%28captured_by_the_Hubble_Space_Telescope%29.jpg/500px-UGC_1810_and_UGC_1813_in_Arp_273_%28captured_by_the_Hubble_Space_Telescope%29.jpg",
  "https://images.unsplash.com/photo-1595914271038-f1e1cb02fbf6?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Blaise_Pascal_Versailles.JPG/500px-Blaise_Pascal_Versailles.JPG",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Dehnungsfuge.jpg/500px-Dehnungsfuge.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Carnot_heat_engine_2.svg/500px-Carnot_heat_engine_2.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/6/6d/Translational_motion.gif",
  "https://upload.wikimedia.org/wikipedia/commons/2/25/Animated-mass-spring.gif",
  "https://images.unsplash.com/photo-1505118380757-91f5f5632de0?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/VFPt_charges_plus_minus_thumb.svg/500px-VFPt_charges_plus_minus_thumb.svg.png",
  "https://images.unsplash.com/photo-1461088945293-0c17689e48ac?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Plasma_globe_60th.jpg/500px-Plasma_globe_60th.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/0/08/MagnetEZ.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/7/72/Electromagnetic_induction_-_solenoid_to_loop_-_animation.gif",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Types_of_current.svg/500px-Types_of_current.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/a/a6/Dipole_xmting_antenna_animation_4_408x318x150ms.gif",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/ANDY7187.jpg/500px-ANDY7187.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Laser_Interference.JPG/500px-Laser_Interference.JPG",
  "https://upload.wikimedia.org/wikipedia/commons/8/8f/Sail-Force1.gif",
  "https://images.unsplash.com/photo-1507413245164-6160d8298b31?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Nucleus_drawing.svg/500px-Nucleus_drawing.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Arduino_ftdi_chip-1.jpg/500px-Arduino_ftdi_chip-1.jpg",
  "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=400&q=80"
];

const chemistryPhotos = [
  "https://images.unsplash.com/photo-1603126857599-f6e157fa2fe6?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Bohr_atom_model.svg/500px-Bohr_atom_model.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Colour_18-col_PT_with_labels.svg/500px-Colour_18-col_PT_with_labels.svg.png",
  "https://images.unsplash.com/photo-1530026405186-ed1ea0ac7a63?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Bromine_vial_in_acrylic_cube.jpg/500px-Bromine_vial_in_acrylic_cube.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Activation_energy.svg/500px-Activation_energy.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Hydrostatic_equilibrium.png/500px-Hydrostatic_equilibrium.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/16._%D0%A0%D0%B5%D0%B0%D0%BA%D1%86%D0%B8%D1%98%D0%B0_%D0%BC%D0%B5%D1%93%D1%83_%D1%81%D0%B8%D0%BB%D0%BD%D0%BE_%D0%BE%D0%BA%D1%81%D0%B8%D0%B4%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BE_%D0%B8_%D1%80%D0%B5%D0%B4%D1%83%D0%BA%D1%86%D0%B8%D0%BE%D0%BD%D0%BE_%D1%81%D1%80%D0%B5%D0%B4%D1%81%D1%82%D0%B2%D0%BE.webm/500px--16._%D0%A0%D0%B5%D0%B0%D0%BA%D1%86%D0%B8%D1%98%D0%B0_%D0%BC%D0%B5%D1%93%D1%83_%D1%81%D0%B8%D0%BB%D0%BD%D0%BE_%D0%BE%D0%BA%D1%81%D0%B8%D0%B4%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BE_%D0%B8_%D1%80%D0%B5%D0%B4%D1%83%D0%BA%D1%86%D0%B8%D0%BE%D0%BD%D0%BE_%D1%81%D1%80%D0%B5%D0%B4%D1%81%D1%82%D0%B2%D0%BE.webm.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Hydrogen_discharge_tube.jpg/500px-Hydrogen_discharge_tube.jpg",
  "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1617155093730-a8bf47be792d?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1532187643603-ba119ca4109e?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/All-Solid-State_Battery.png/500px-All-Solid-State_Battery.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/SaltInWaterSolutionLiquid.jpg/500px-SaltInWaterSolutionLiquid.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Faraday_and_Daniell.jpg/500px-Faraday_and_Daniell.jpg",
  "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/8/82/Selfassembly_Organic_Semiconductor_Trixler_LMU.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Processing_gold.jpg/500px-Processing_gold.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Simple_Periodic_Table_Chart-blocks.svg/500px-Simple_Periodic_Table_Chart-blocks.svg.png",
  "https://images.unsplash.com/photo-1518733057014-a3db25e6e87a?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Cisplatin-3D-balls.png/500px-Cisplatin-3D-balls.png",
  "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1527061011665-3652c757a4d4?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1607619056574-7b8d304f3c6f?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1526613095530-a99ad414030a?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80"
];

const biologyPhotos = [
  "https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Biological_classification_L_Pengo_vflip.svg/500px-Biological_classification_L_Pengo_vflip.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Fr%C3%BChling_bl%C3%BChender_Kirschenbaum.jpg/500px-Fr%C3%BChling_bl%C3%BChender_Kirschenbaum.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Tree_of_Life%2C_Disney%27s_Animal_Kingdom.jpg/500px-Tree_of_Life%2C_Disney%27s_Animal_Kingdom.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Angelica_gigas.jpg/500px-Angelica_gigas.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Ranunculus_repens_1_%28cropped%29.JPG/500px-Ranunculus_repens_1_%28cropped%29.JPG",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Emphysema_H_and_E.jpg/500px-Emphysema_H_and_E.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/6/6c/HeLa_cells_stained_with_Hoechst_33258.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Myoglobin.png/500px-Myoglobin.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Normal_Cell_Life_Cycle.png/500px-Normal_Cell_Life_Cycle.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Xylem_and_phloem_diagram.svg/500px-Xylem_and_phloem_diagram.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/NRCSMO02023_-_Missouri_%284769%29%28NRCS_Photo_Gallery%29.jpg/500px-NRCSMO02023_-_Missouri_%284769%29%28NRCS_Photo_Gallery%29.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Photosynthesis_en.svg/500px-Photosynthesis_en.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/CellRespiration.svg/500px-CellRespiration.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Auxin.jpg/500px-Auxin.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Skeletal_Structure_of_Cyclic_D-Fructose.svg/500px-Skeletal_Structure_of_Cyclic_D-Fructose.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Respiratory_system_complete_en.svg/500px-Respiratory_system_complete_en.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/General_circulation-vorticity_diagram.svg/500px-General_circulation-vorticity_diagram.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Urinary_System_Large_Unlabeled.jpg/500px-Urinary_System_Large_Unlabeled.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/d/dd/Muybridge_race_horse_animated.gif",
  "https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Endocrine_English.svg/500px-Endocrine_English.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Kalanchoe_veg.jpg/500px-Kalanchoe_veg.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Sexual_cycle_N-2N.svg/500px-Sexual_cycle_N-2N.svg.png",
  "https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Angolan_community_members_at_HIV_AIDS_outreach_event_%285686747785%29.jpg/500px-Angolan_community_members_at_HIV_AIDS_outreach_event_%285686747785%29.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/d/d3/Gregor_Mendel.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Hybridogenesis_in_water_frogs_gametes.svg/500px-Hybridogenesis_in_water_frogs_gametes.svg.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Darwin_Tree_1837.png/500px-Darwin_Tree_1837.png",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/US_Department_of_Health_and_Human_Services_seal.svg/500px-US_Department_of_Health_and_Human_Services_seal.svg.png",
  "https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?auto=format&fit=crop&w=400&q=80",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/E_coli_at_10000x%2C_original.jpg/500px-E_coli_at_10000x%2C_original.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Faculty_of_Food_Engineering_and_Biotechnology_4.jpg/500px-Faculty_of_Food_Engineering_and_Biotechnology_4.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Euphorbia_tithymaloides.jpg/500px-Euphorbia_tithymaloides.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Storni_1000128.JPG/500px-Storni_1000128.JPG",
  "https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?auto=format&fit=crop&w=400&q=80"
];

function hashStringToInt(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  return Math.abs(hash);
}

function getTopicIndex(subject: string, slug: string): number {
  const classMatch = slug.match(/-class-(\d+)-/);
  const chapMatch = slug.match(/-ch-(\d+)$/);
  if (!classMatch || !chapMatch) {
    return Math.abs(hashStringToInt(slug)) % 10;
  }
  
  const classNum = parseInt(classMatch[1]);
  const chapNum = parseInt(chapMatch[1]);
  
  if (subject === "physics") {
    if (classNum === 11) return Math.min(14, Math.max(0, chapNum - 1));
    if (classNum === 12) return Math.min(29, Math.max(15, 15 + (chapNum - 1)));
  }
  
  if (subject === "chemistry") {
    if (classNum === 11) return Math.min(13, Math.max(0, chapNum - 1));
    if (classNum === 12) return Math.min(29, Math.max(14, 14 + (chapNum - 1)));
  }
  
  if (subject === "biology") {
    if (classNum === 11) return Math.min(21, Math.max(0, chapNum - 1));
    if (classNum === 12) return Math.min(37, Math.max(22, 22 + (chapNum - 1)));
  }
  
  return 0;
}

function getChapterImage(subject: string, title: string, slug: string): string {
  const s = (subject || "physics").toLowerCase();
  const idx = getTopicIndex(s, slug || title);
  
  if (s === "physics") {
    return physicsPhotos[idx % physicsPhotos.length];
  }
  if (s === "chemistry") {
    return chemistryPhotos[idx % chemistryPhotos.length];
  }
  if (s === "biology") {
    return biologyPhotos[idx % biologyPhotos.length];
  }
  
  return physicsPhotos[0];
}

function StudyPageContent() {
  const searchParams = useSearchParams();
  const subjectParam = searchParams.get("subject");

  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeClass, setActiveClass] = useState<string>("all");

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data } = await supabase
        .from("subjects")
        .select("*, topics(id, name, slug, description, ncert_content(id))")
        .order("id");
      if (data) {
        setSubjects(data);
      }
      setLoading(false);
    }
    load();
  }, []);

  const subjectMeta: Record<string, { desc: string; color: string; hoverColor: string; bgTint: string; shadow: string }> = {
    biology: {
      desc: "Botany & Zoology NCERT chapters",
      color: "border-amber-500/30 hover:border-amber-500/60 text-amber-400",
      hoverColor: "hover:bg-amber-500/10",
      bgTint: "from-amber-600/20 via-amber-500/5 to-transparent",
      shadow: "shadow-amber-500/5",
    },
    chemistry: {
      desc: "Organic, Inorganic & Physical chemistry",
      color: "border-emerald-500/30 hover:border-emerald-500/60 text-emerald-400",
      hoverColor: "hover:bg-emerald-500/10",
      bgTint: "from-emerald-600/20 via-emerald-500/5 to-transparent",
      shadow: "shadow-emerald-500/5",
    },
    physics: {
      desc: "Mechanics, Electrodynamics & Optics",
      color: "border-blue-500/30 hover:border-blue-500/60 text-blue-400",
      hoverColor: "hover:bg-blue-500/10",
      bgTint: "from-blue-600/20 via-blue-500/5 to-transparent",
      shadow: "shadow-blue-500/5",
    },
  };

  if (loading) {
    return (
      <div className="h-[60vh] flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  // --- STATE A: Subject Selection (No Subject query param active) ---
  if (!subjectParam) {
    return (
      <div className="space-y-6 w-full max-w-xl mx-auto flex-1 flex flex-col justify-center select-none animate-fade-in-up">
        <div className="text-center space-y-1">
          <p className="text-xs text-muted-foreground font-black tracking-widest uppercase">FUEL MODE</p>
          <h2 className="font-poppins font-black text-3xl text-white tracking-tight">Select Subject</h2>
          <p className="text-xs text-muted-foreground max-w-sm mx-auto leading-relaxed">
            Choose a subject to read NCERT reference materials and practice summaries.
          </p>
        </div>

        <div className="space-y-4">
          {subjects.map((sub) => {
            const meta = subjectMeta[sub.slug] || subjectMeta.physics;
            return (
              <Link key={sub.id} href={`/dashboard/study?subject=${sub.slug}`} className="block group">
                <Card className={cn(
                  "glass-card bg-slate-950/40 border bg-gradient-to-r rounded-2xl overflow-hidden hover:scale-[1.01] transition-all duration-300 cursor-pointer",
                  meta.bgTint, meta.color, meta.shadow
                )}>
                  <CardContent className="p-5 flex items-center justify-between gap-4">
                    <div className="flex items-center gap-4">
                      <div className="w-12 h-12 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center text-2xl select-none">
                        {sub.icon}
                      </div>
                      <div className="text-left">
                        <h3 className="font-poppins font-black text-xl text-white tracking-tight">
                          {sub.name.toUpperCase()}
                        </h3>
                        <p className="text-xs text-muted-foreground mt-0.5 leading-relaxed">
                          {meta.desc}
                        </p>
                      </div>
                    </div>
                    <ChevronRight className="w-5 h-5 text-muted-foreground group-hover:text-white group-hover:translate-x-1 transition-all flex-shrink-0" />
                  </CardContent>
                </Card>
              </Link>
            );
          })}
        </div>
      </div>
    );
  }

  // --- STATE B: Chapter Grid (Subject query param is active) ---
  const currentSubject = subjects.find(s => s.slug === subjectParam);
  if (!currentSubject) {
    return (
      <div className="text-center p-8">
        <p className="text-red-400 font-bold">Subject not found.</p>
        <Link href="/dashboard/study" className="text-xs text-blue-400 hover:underline mt-2 inline-block">
          Return to Subjects
        </Link>
      </div>
    );
  }

  const meta = subjectMeta[currentSubject.slug] || subjectMeta.physics;

  let filteredTopics = currentSubject.topics || [];
  if (activeClass !== "all") {
    filteredTopics = filteredTopics.filter(t => t.slug.includes(`-class-${activeClass}-`));
  }

  // Sort chapters numerically by class then chapter
  filteredTopics.sort((a, b) => {
    const classMatchA = a.slug.match(/-class-(\d+)-/);
    const classMatchB = b.slug.match(/-class-(\d+)-/);
    const classA = classMatchA ? parseInt(classMatchA[1]) : 0;
    const classB = classMatchB ? parseInt(classMatchB[1]) : 0;
    
    if (classA !== classB) return classA - classB;

    const chapMatchA = a.slug.match(/-ch-(\d+)$/);
    const chapMatchB = b.slug.match(/-ch-(\d+)$/);
    const chapA = chapMatchA ? parseInt(chapMatchA[1]) : 0;
    const chapB = chapMatchB ? parseInt(chapMatchB[1]) : 0;
    
    return chapA - chapB;
  });

  return (
    <div className="space-y-6 animate-fade-in-up w-full">
      {/* Class filter tabs */}
      <div className="flex items-center justify-between gap-4 border-b border-white/5 pb-4">
        <p className="text-xs font-black uppercase text-muted-foreground tracking-wider">
          {filteredTopics.length} Chapters
        </p>
        <div className="flex p-0.5 bg-white/5 rounded-xl border border-white/5 w-fit select-none">
          {["all", "11", "12"].map((c) => (
            <button
              key={c}
              onClick={() => setActiveClass(c)}
              className={cn(
                "px-3 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider transition-all duration-300",
                activeClass === c
                  ? "bg-white/10 text-white shadow-sm ring-1 ring-white/10"
                  : "text-muted-foreground hover:text-white"
              )}
            >
              {c === "all" ? "All Classes" : `Class ${c}`}
            </button>
          ))}
        </div>
      </div>

      {/* Grid of Chapter Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {filteredTopics.map((topic) => (
          <Card 
            key={topic.id} 
            className="glass-card bg-slate-950/40 border border-white/10 rounded-2xl overflow-hidden flex flex-col justify-between h-[340px] hover:translate-y-[-2px] transition-all duration-300 group"
          >
            {/* 80% Chapter Image Block (no rounding) */}
            <div className="h-[75%] w-full relative overflow-hidden bg-slate-950">
              <img 
                src={getChapterImage(currentSubject.slug, topic.name, topic.slug)} 
                alt={topic.name} 
                className="w-full h-full object-cover group-hover:scale-[1.02] transition-transform duration-700 opacity-90" 
                loading="lazy"
                onError={(e) => {
                  e.currentTarget.src = `https://picsum.photos/seed/${topic.slug}/400/300`;
                }}
              />
            </div>

            {/* Chapter title & details */}
            <div className="px-3 pt-2 pb-1 text-center">
              <h3 className="font-poppins font-black text-xs text-white leading-tight line-clamp-2 select-text">
                {topic.name.toUpperCase()}
              </h3>
            </div>

            {/* Bottom button bar: FUEL & SMASH */}
            <div className="w-full bg-slate-950 border-t border-white/5 flex items-center justify-between px-3 py-2 gap-2 select-none">
              <Link href={`/dashboard/study/${topic.slug}`} className="flex-1">
                <Button 
                  variant="ghost" 
                  className="w-full text-[10px] font-black uppercase tracking-widest h-8 flex items-center justify-center gap-1.5 text-white/80 hover:bg-white/5 hover:text-white transition-colors border border-white/10 rounded-xl"
                >
                  <BookOpen className="w-3.5 h-3.5 text-blue-400" />
                  FUEL
                </Button>
              </Link>
              <Link href={`/dashboard/test/${topic.slug}`} className="flex-1">
                <Button 
                  className="w-full text-[10px] font-black uppercase tracking-widest h-8 flex items-center justify-center gap-1.5 bg-amber-500/10 hover:bg-amber-500/25 text-amber-400 border border-amber-500/30 rounded-xl transition-all shadow-sm"
                >
                  <Zap className="w-3.5 h-3.5 fill-current" />
                  SMASH
                </Button>
              </Link>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}

export default function StudyPage() {
  return (
    <Suspense fallback={
      <div className="h-[60vh] flex items-center justify-center">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    }>
      <StudyPageContent />
    </Suspense>
  );
}
