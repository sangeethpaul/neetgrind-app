"""
Optional module providing GBNF Grammar constrained decoding via llama-cpp-python.
This requires the model to be running locally using llama.cpp instead of Ollama.
"""

GBNF_MCQ_GRAMMAR = r'''
root ::= "{" ws "\"mcqs\"" ws ":" ws "[" ws mcq ("," ws mcq)* ws "]" ws "}"
mcq ::= "{" ws "\"question_text\"" ws ":" ws string "," ws "\"option_a\"" ws ":" ws string "," ws "\"option_b\"" ws ":" ws string "," ws "\"option_c\"" ws ":" ws string "," ws "\"option_d\"" ws ":" ws string "," ws "\"correct_option\"" ws ":" ws option_letter "," ws "\"explanation\"" ws ":" ws string ws "}"
option_letter ::= "\"A\"" | "\"B\"" | "\"C\"" | "\"D\""
string ::= "\"" ([^"\\] | "\\" (["\\/bfnrt] | "u" [0-9a-fA-F]{4}))* "\""
ws ::= [ \t\n]*
'''

def generate_mcq_llama_cpp(model_path: str, prompt: str):
    """
    Example function to use llama-cpp-python with GBNF grammar.
    Requires `pip install llama-cpp-python`.
    """
    try:
        from llama_cpp import Llama, LlamaGrammar
    except ImportError:
        raise ImportError("llama-cpp-python is not installed. Please install it to use GBNF grammar.")
        
    grammar = LlamaGrammar.from_string(GBNF_MCQ_GRAMMAR)
    llm = Llama(model_path=model_path, n_ctx=4096)
    
    output = llm(
        prompt,
        max_tokens=1024,
        grammar=grammar,
        temperature=0.3
    )
    
    import json
    return json.loads(output["choices"][0]["text"])
