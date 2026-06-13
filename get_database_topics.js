global.WebSocket = class {}; // Mock WebSocket for Node.js 20

const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const rootEnv = fs.readFileSync('.env.local', 'utf8');
const env = {};
rootEnv.split('\n').forEach(line => {
  const parts = line.split('=');
  if (parts.length >= 2) {
    env[parts[0].trim()] = parts.slice(1).join('=').trim().replace(/['"]/g, '');
  }
});

const SUPABASE_URL = env.SUPABASE_URL || env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_KEY = env.SUPABASE_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("Missing Supabase credentials.");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: false }
});

async function run() {
  const { data: subjects, error: errSub } = await supabase.from("subjects").select("id, name, slug").order("id");
  if (errSub) {
    console.error(errSub);
    process.exit(1);
  }
  const { data: topics, error: errTop } = await supabase.from("topics").select("id, name, slug, subject_id");
  if (errTop) {
    console.error(errTop);
    process.exit(1);
  }

  const results = {};

  for (const subject of subjects) {
    const subject_topics = topics.filter(t => t.subject_id === subject.id);
    results[subject.slug] = [];
    for (const classNum of ["11", "12"]) {
      const class_topics = subject_topics.filter(t => t.slug.includes(`-class-${classNum}-`));
      class_topics.sort((a, b) => {
        const chA = parseInt(a.slug.split("-ch-")[1]) || 999;
        const chB = parseInt(b.slug.split("-ch-")[1]) || 999;
        return chA - chB;
      });
      for (const t of class_topics) {
        results[subject.slug].push({
          slug: t.slug,
          name: t.name
        });
      }
    }
  }

  console.log(JSON.stringify(results, null, 2));
}

run();
