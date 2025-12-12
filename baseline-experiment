import openai
from pyswip import Prolog

openai.api_key = 'your_api_key'

def translate_to_prolog(nl_query):
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=f"Translate this to Prolog: {nl_query}",
        max_tokens=100
    )
    return response.choices[0].text.strip()

def run_prolog_code(prolog_code):
    with open("temp.pl", "w") as f:
        f.write(prolog_code)
    prolog = Prolog()
    prolog.consult("temp.pl")
    return list(prolog.query("bird(X)"))
