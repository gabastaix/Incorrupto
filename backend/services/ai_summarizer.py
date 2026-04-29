import os
from groq import Groq
from dotenv import load_dotenv

load_dotenv()

client = Groq(api_key=os.getenv("GROQ_API_KEY"))

SUMMARY_PROMPT = """Tu es un journaliste factuel et neutre. 
Ton rôle est de résumer un article de presse en 3 à 5 phrases claires et objectives.

Règles strictes :
- Aucun jugement, aucune opinion
- Uniquement les faits présents dans l'article
- Langage simple et accessible
- Toujours en français
- Pas de formule d'introduction comme "Cet article parle de..."
- Commence directement par les faits

Article à résumer :
{article_text}

Résumé factuel :"""


def generate_summary(title: str, content: str) -> str | None:
    """
    Génère un résumé factuel d'un article via Groq/Llama.
    Retourne le résumé ou None en cas d'erreur.
    """
    # On combine titre + contenu pour donner plus de contexte
    article_text = f"Titre : {title}\n\n{content}"

    # Si l'article est trop court, pas besoin de résumé
    if len(content) < 50:
        return None

    try:
        response = client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=[
                {
                    "role": "user",
                    "content": SUMMARY_PROMPT.format(article_text=article_text)
                }
            ],
            temperature=0.3,   # basse = plus factuel, moins créatif
            max_tokens=300,    # ~3-5 phrases
        )
        return response.choices[0].message.content.strip()

    except Exception as e:
        print(f"❌ Erreur Groq : {e}")
        return None


if __name__ == "__main__":
    test_title = "Réforme des retraites : l'Assemblée nationale adopte le texte en première lecture"
    test_content = """
    L'Assemblée nationale a adopté mardi soir en première lecture le projet de loi de réforme des retraites 
    porté par le gouvernement Borne, par 49 voix pour et 41 contre. Le texte prévoit un relèvement progressif 
    de l'âge légal de départ à la retraite de 62 à 64 ans d'ici 2030, ainsi qu'une accélération de la montée 
    en charge du dispositif de carrières longues pour ceux ayant commencé à travailler avant 20 ans.
    
    Le Premier ministre Édouard Philippe avait présenté ce projet comme "indispensable" pour garantir 
    l'équilibre financier du système de retraites face au vieillissement démographique. Selon les projections 
    du Conseil d'orientation des retraites, sans réforme, le déficit du système atteindrait 13,5 milliards 
    d'euros en 2030. Le gouvernement estime que ce texte permettra d'économiser 17,7 milliards d'euros par an 
    d'ici 2030.
    
    Huit syndicats, dont la CGT, FO, la CFE-CGC et la CFDT, ont immédiatement réagi en annonçant une 
    journée de mobilisation nationale le 19 janvier, appelant les travailleurs de tous secteurs à faire 
    grève. La CGT a qualifié cette réforme d'"injuste et brutale", pointant particulièrement son impact 
    sur les travailleurs aux carrières hachées et les femmes, dont les pensions sont en moyenne 40% 
    inférieures à celles des hommes.
    
    Du côté de l'opposition, Jean-Luc Mélenchon a dénoncé "un passage en force antidémocratique", 
    tandis que Marine Le Pen a estimé que "les Français ne sont pas dupes". Les Républicains, eux, 
    ont voté pour le texte tout en demandant des "aménagements" sur la pénibilité. Le Sénat examinera 
    le projet de loi à partir du 2 février.
    
    Plusieurs économistes interrogés par Le Monde soulignent que la réforme repose sur des hypothèses 
    de croissance "optimistes" à 1,3% par an, alors que la Banque de France prévoit une croissance 
    de 0,7% en 2023. D'autres experts, comme ceux de l'OFCE, proposent des alternatives comme 
    la taxation des revenus du capital ou une retraite à points modulable.
    
    Des manifestations ont eu lieu dans plusieurs grandes villes françaises dès l'annonce du vote, 
    rassemblant selon les syndicats plus de 250 000 personnes à Paris, Lyon, Marseille et Bordeaux. 
    Les forces de l'ordre ont fait état de 142 interpellations sur l'ensemble du territoire et de 
    quelques incidents en marge des cortèges à Paris et Nantes.
    """
    summary = generate_summary(test_title, test_content)
    print(f"Résumé généré :\n{summary}")