import re


# Mentions parasites fréquentes dans les flux RSS français
UNWANTED_PHRASES = [
    "lire aussi",
    "lire la suite",
    "abonnez-vous",
    "abonnez vous",
    "réservé aux abonnés",
    "article réservé",
    "pour aller plus loin",
    "à lire aussi",
    "en savoir plus",
    "notre sélection",
    "publicité",
    "newsletter",
    "inscrivez-vous",
    "cliquez ici",
]


def clean_text(text: str) -> str:
    """
    Nettoie un texte brut issu d'un flux RSS.
    - Supprime les espaces multiples et sauts de ligne inutiles
    - Supprime les mentions parasites (pub, abonnement...)
    - Normalise la ponctuation
    """
    if not text:
        return ""

    # Minuscules pour la détection des phrases parasites
    text_lower = text.lower()

    # Supprime les lignes contenant des mentions parasites
    lines = text.split("\n")
    cleaned_lines = []
    for line in lines:
        line_lower = line.lower().strip()
        if any(phrase in line_lower for phrase in UNWANTED_PHRASES):
            continue
        cleaned_lines.append(line)
    text = "\n".join(cleaned_lines)

    # Supprime les URLs résiduelles
    text = re.sub(r'http\S+', '', text)

    # Supprime les caractères spéciaux parasites
    text = re.sub(r'[«»""„]', '"', text)  # normalise les guillemets
    text = re.sub(r'[–—]', '-', text)      # normalise les tirets
    text = re.sub(r'\s+', ' ', text)       # espaces multiples → un seul
    text = re.sub(r'\n+', '\n', text)      # sauts de ligne multiples → un seul

    return text.strip()


def is_french(text: str) -> bool:
    """
    Détection simple de la langue française par mots-clés fréquents.
    Évite d'installer une lib externe lourde.
    """
    if not text or len(text) < 20:
        return False

    french_indicators = [
        " le ", " la ", " les ", " des ", " du ", " de ", " en ",
        " un ", " une ", " est ", " sont ", " avec ", " pour ",
        " dans ", " sur ", " par ", " que ", " qui ", " pas ",
        " plus ", " cette ", " ces ", " leur ", " leurs ",
    ]

    text_lower = text.lower()
    matches = sum(1 for word in french_indicators if word in text_lower)

    # Si au moins 4 indicateurs français trouvés → considéré comme français
    return matches >= 4


def process_article(article: dict) -> dict | None:
    """
    Prend un article brut et retourne un article nettoyé.
    Retourne None si l'article n'est pas en français ou trop court.
    """
    title = clean_text(article.get("title", ""))
    content = clean_text(article.get("content", ""))

    # Filtre les articles trop courts
    if len(content) < 30 and len(title) < 10:
        return None

    # Filtre les articles non-français
    full_text = f"{title} {content}"
    if not is_french(full_text):
        return None

    return {
        **article,
        "title": title,
        "cleaned_content": content,  # version propre pour l'IA
    }


def process_all(articles: list[dict]) -> list[dict]:
    """
    Traite tous les articles et retourne uniquement ceux qui sont valides.
    """
    results = []
    filtered = 0

    for article in articles:
        processed = process_article(article)
        if processed:
            results.append(processed)
        else:
            filtered += 1

    print(f"✅ {len(results)} articles valides après nettoyage")
    print(f"⚠️  {filtered} articles filtrés (trop courts ou non-français)")

    return results