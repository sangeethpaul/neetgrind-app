import streamlit as st
import pandas as pd
import json
from openai import OpenAI

from pipeline_local import extract_pdf_text, chunk_text, generate_mcq_multistage, generate_mcq_simple
import os
from pathlib import Path
from dotenv import load_dotenv

# Load .env.local from the root project folder
root_env = Path(__file__).resolve().parents[2] / ".env.local"
if root_env.exists():
    load_dotenv(root_env)

SUPABASE_URL = os.environ.get("SUPABASE_URL", os.environ.get("NEXT_PUBLIC_SUPABASE_URL", ""))
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", os.environ.get("SUPABASE_KEY", ""))

try:
    from supabase import create_client, Client
    supabase_client = create_client(SUPABASE_URL, SUPABASE_KEY) if SUPABASE_URL and SUPABASE_KEY else None
except ImportError:
    supabase_client = None

st.set_page_config(page_title="Local MCQ Generator", layout="wide")

# --- Initialize session state ---
if "mcqs" not in st.session_state:
    st.session_state.mcqs = []
if "logs" not in st.session_state:
    st.session_state.logs = []
if "extracted_chunks" not in st.session_state:
    st.session_state.extracted_chunks = []

# --- Sidebar Configuration ---
with st.sidebar:
    st.header("⚙️ Configuration")
    
    # Check Ollama available models if possible (we assume a local server at 11434)
    model_name = st.selectbox(
        "Local Ollama Model", 
        ["gemma4:e4b", "gemma:2b", "gemma:7b", "llama3:8b", "mistral", "qwen2.5:7b"],
        index=0
    )
    
    api_base = st.text_input("Ollama Endpoint URL", value="http://localhost:11434/v1")
    
    st.divider()
    
    mode = st.radio("Generation Mode", ["Multi-Stage (Robust Regex)", "Simple Mode (JSON Schema)"])
    use_simple = mode == "Simple Mode (JSON Schema)"
    
    st.divider()
    
    num_qs_per_chunk = st.slider("Target MCQs per Chunk", min_value=1, max_value=5, value=3)
    chunk_size = st.slider("Chunk Size (characters)", min_value=1000, max_value=5000, value=2000, step=500)
    
    st.divider()
    
    st.header("🐛 Debug Logs")
    if st.button("Clear Logs"):
        st.session_state.logs = []
    
    with st.expander("View Raw LLM Outputs"):
        for log in st.session_state.logs:
            st.markdown(f"**Stage:** {log['stage']}")
            with st.chat_message("user"): st.text(log['prompt'])
            with st.chat_message("assistant"): st.text(log['response'])
            st.divider()

# --- Main App ---
st.title("📚 Local NEET MCQ Generator")
st.markdown("Generate MCQs using your local LLM via Ollama. No cloud API costs, fully private.")

tab_generate, tab_import, tab_quiz = st.tabs(["📝 Generate", "📁 Import MCQs", "🎮 Quiz Mode"])

with tab_generate:
    # 1. Input Section
    input_method = st.radio("Input Method", ["PDF Upload", "Paste Text"], horizontal=True)
    
    raw_text = ""
    if input_method == "PDF Upload":
        uploaded_file = st.file_uploader("Upload NCERT PDF", type="pdf")
        if uploaded_file is not None:
            with st.spinner("Extracting text from PDF..."):
                raw_text = extract_pdf_text(uploaded_file)
            st.success(f"Extracted {len(raw_text)} characters.")
    else:
        raw_text = st.text_area("Paste content here", height=200)

    # 2. Generation Section
    if st.button("🚀 Generate MCQs", type="primary", disabled=not raw_text):
        st.session_state.mcqs = []
        st.session_state.logs = []
        
        client = OpenAI(base_url=api_base, api_key="ollama")
        chunks = chunk_text(raw_text, chunk_size=chunk_size)
        st.session_state.extracted_chunks = chunks
        
        progress_bar = st.progress(0)
        status_text = st.empty()
        
        for i, chunk in enumerate(chunks):
            status_text.text(f"Processing chunk {i+1} of {len(chunks)}...")
            
            chunk_logs = []
            if use_simple:
                mcqs = generate_mcq_simple(client, model_name, chunk, num_qs_per_chunk, logs=chunk_logs)
            else:
                mcqs = generate_mcq_multistage(client, model_name, chunk, num_qs_per_chunk, logs=chunk_logs)
                
            st.session_state.mcqs.extend(mcqs)
            st.session_state.logs.extend(chunk_logs)
            
            progress_bar.progress((i + 1) / len(chunks))
            
        status_text.text(f"✅ Generated {len(st.session_state.mcqs)} total MCQs!")

with tab_import:
    st.subheader("📁 Import Pre-generated MCQs")
    st.markdown("Upload a previously downloaded `.json` or `.csv` file to view it, test it, or upload it to Supabase.")
    
    uploaded_mcq_file = st.file_uploader("Upload MCQ file (JSON or CSV)", type=["json", "csv"])
    if uploaded_mcq_file is not None:
        try:
            if uploaded_mcq_file.name.endswith(".json"):
                uploaded_mcq_file.seek(0)
                imported_mcqs = json.load(uploaded_mcq_file)
            else:
                uploaded_mcq_file.seek(0)
                df_imported = pd.read_csv(uploaded_mcq_file)
                imported_mcqs = df_imported.to_dict(orient="records")
            
            st.info(f"Parsed {len(imported_mcqs)} MCQs from file.")
            if st.button("📥 Load into App", type="primary"):
                st.session_state.mcqs = imported_mcqs
                st.success(f"Successfully loaded {len(imported_mcqs)} MCQs! Go to the 'Quiz Mode' tab to test them or use the section below to save to Supabase.")
        except Exception as e:
            st.error(f"Failed to parse file: {e}")

# --- Shared Output and Upload Sections (outside tabs) ---
if st.session_state.mcqs:
    st.divider()
    st.subheader(f"📊 Active MCQs ({len(st.session_state.mcqs)} Questions)")
    
    # Display as a dataframe
    df = pd.DataFrame(st.session_state.mcqs)
    st.dataframe(df)
    
    col1, col2 = st.columns(2)
    with col1:
        json_str = json.dumps(st.session_state.mcqs, indent=2)
        st.download_button("⬇️ Download JSON", data=json_str, file_name="mcqs.json", mime="application/json")
    with col2:
        csv_data = df.to_csv(index=False)
        st.download_button("⬇️ Download CSV", data=csv_data, file_name="mcqs.csv", mime="text/csv")
        
    if supabase_client is not None:
        st.divider()
        st.subheader("☁️ Save to Database")
        
        try:
            res = supabase_client.table("topics").select("id, name, slug").execute()
            topics = res.data
        except Exception as e:
            st.error(f"Failed to fetch topics: {e}")
            topics = []
            
        if topics:
            def parse_topic_slug(slug: str) -> tuple[str, str, int]:
                parts = slug.split('-')
                subject = "Unknown"
                class_num = ""
                ch_num = 0
                
                if slug.startswith("biology"):
                    subject = "Biology"
                elif slug.startswith("chemistry"):
                    subject = "Chemistry"
                elif slug.startswith("physics"):
                    subject = "Physics"
                else:
                    subject_part = slug.split('-class-')[0] if '-class-' in slug else ""
                    subject = subject_part.capitalize() or "Unknown"
                    
                if 'class' in parts:
                    try:
                        idx = parts.index('class')
                        if idx + 1 < len(parts):
                            class_num = parts[idx + 1]
                    except Exception:
                        pass
                        
                if 'ch' in parts:
                    try:
                        idx = parts.index('ch')
                        if idx + 1 < len(parts):
                            ch_num = int(parts[idx + 1])
                    except Exception:
                        pass
                        
                return subject, class_num, ch_num

            def get_topic_sort_key(t):
                subj, cls_str, ch_num = parse_topic_slug(t.get('slug', ''))
                try:
                    cls_val = int(cls_str)
                except ValueError:
                    cls_val = 999
                return (subj, cls_val, ch_num, t.get('name', ''))

            topics = sorted(topics, key=get_topic_sort_key)
            
            topic_options = {}
            for t in topics:
                subj, cls, ch = parse_topic_slug(t.get('slug', ''))
                if subj != "Unknown" and cls and ch > 0:
                    label = f"{subj} Class {cls} │ Chapter {ch}: {t['name']}"
                else:
                    label = f"{t['name']} ({t['slug']})"
                
                # Ensure unique keys
                if label in topic_options:
                    label = f"{label} ({t['slug']})"
                topic_options[label] = t['id']
                
            selected_topic_label = st.selectbox("Select Topic", list(topic_options.keys()))
            selected_topic_id = topic_options[selected_topic_label]
            
            if st.button("💾 Upload to Supabase"):
                with st.spinner("Uploading to database..."):
                    # Build slug/ID lookup maps for smart mapping
                    slug_to_id = {t['slug']: t['id'] for t in topics}
                    valid_ids = {t['id'] for t in topics}
                    
                    rows = []
                    for mcq in st.session_state.mcqs:
                        target_id = None
                        
                        # 1. Try slug mapping
                        mcq_slug = mcq.get("slug")
                        if mcq_slug and mcq_slug in slug_to_id:
                            target_id = slug_to_id[mcq_slug]
                            
                        # 2. Try topic_id mapping
                        if target_id is None:
                            mcq_tid = mcq.get("topic_id")
                            if mcq_tid is not None:
                                try:
                                    mcq_tid_int = int(mcq_tid)
                                    if mcq_tid_int in valid_ids:
                                        target_id = mcq_tid_int
                                except (ValueError, TypeError):
                                    pass
                                    
                        # 3. Fallback to dropdown selection
                        if target_id is None:
                            target_id = selected_topic_id
                            
                        row = {
                            "topic_id": target_id,
                            "question_text": mcq.get("question_text"),
                            "option_a": mcq.get("option_a"),
                            "option_b": mcq.get("option_b"),
                            "option_c": mcq.get("option_c"),
                            "option_d": mcq.get("option_d"),
                            "correct_option": mcq.get("correct_option"),
                            "explanation": mcq.get("explanation")
                        }
                        rows.append(row)
                        
                    try:
                        result = supabase_client.table("questions").upsert(rows, on_conflict="question_text,topic_id").execute()
                        st.success(f"Successfully uploaded {len(rows)} MCQs to database!")
                    except Exception as e:
                        st.error(f"Upload failed: {e}")
        else:
            st.warning("No topics found in the database. Please ensure the topics table is populated.")
    else:
        st.info("Supabase connection not configured. Add SUPABASE_URL and SUPABASE_KEY to .env.local to enable database uploads.")


with tab_quiz:
    if not st.session_state.mcqs:
        st.info("Generate some MCQs first to play the quiz!")
    else:
        st.subheader("Quiz Mode")
        
        for idx, mcq in enumerate(st.session_state.mcqs):
            st.markdown(f"**Q{idx+1}: {mcq['question_text']}**")
            options = ["A", "B", "C", "D"]
            option_texts = [mcq['option_a'], mcq['option_b'], mcq['option_c'], mcq['option_d']]
            
            choice = st.radio(f"Select option for Q{idx+1}:", options, format_func=lambda x: f"{x}) {option_texts[options.index(x)]}", key=f"q_{idx}")
            
            if st.button(f"Check Answer {idx+1}", key=f"btn_{idx}"):
                if choice == mcq['correct_option']:
                    st.success("Correct!")
                else:
                    st.error(f"Wrong! The correct answer is {mcq['correct_option']}.")
                st.info(f"**Explanation:** {mcq['explanation']}")
            st.divider()
