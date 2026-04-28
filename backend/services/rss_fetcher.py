import feedparser
import httpx
from datetime import datetime
from bs4 import BeautifulSoup

RSS_SOURCES = [
    {
        "name": "Le Monde",
        "url": "https://www.lemonde.fr/rss/une.xml",
    },
    {
        "name": "Le Figaro",
        "url": "https://www.lefigaro.fr/rss/figaro_actualites.xml",
    },
    {
        "name": "Libération",
        "url": "https://www.liberation.fr/arc/outboundfeeds/rss/",
    },
    {
        "name": "France Info",
        "url": "https://www.francetvinfo.fr/titres.rss",
    },
    {
        "name": "L'Express",
        "url": "https://www.lexpress.fr/arc/outboundfeeds/rss/",
    },
    {
        "name": "BFM TV",
        "url": "https://www.bfmtv.com/rss/news-24-7/",
    },
]


def clean_html(text: str) -> str:
    """Enlève les balises HTML d'un texte."""
    if not text:
        return ""
    soup = BeautifulSoup(text, "html.parser")
    return soup.get_text(separator=" ").strip()


def fetch_all_articles() -> list[dict]:
    """
    Lit tous les flux RSS et retourne une liste d'articles bruts.
    Chaque article est un dict avec : title, content, source, url, date
    """
    all_articles = []

    for source in RSS_SOURCES:
        print(f"📡 Fetching {source['name']}...")
        try:
            feed = feedparser.parse(source["url"])

            for entry in feed.entries:
                # Titre
                title = clean_html(entry.get("title", "")).strip()
                if not title:
                    continue

                # Contenu / résumé
                content = ""
                if "content" in entry:
                    content = clean_html(entry.content[0].value)
                elif "summary" in entry:
                    content = clean_html(entry.summary)

                # URL
                url = entry.get("link", "")

                # Date
                date = None
                if "published_parsed" in entry and entry.published_parsed:
                    date = datetime(*entry.published_parsed[:6])

                all_articles.append({
                    "title": title,
                    "content": content,
                    "source": source["name"],
                    "url": url,
                    "date": date or datetime.now(),
                })

            print(f"  ✅ {len(feed.entries)} articles récupérés")

        except Exception as e:
            print(f"  ❌ Erreur sur {source['name']} : {e}")

    print(f"\n📦 Total : {len(all_articles)} articles récupérés")
    return all_articles


if __name__ == "__main__":
    articles = fetch_all_articles()
    # Affiche les 3 premiers pour vérifier
    for a in articles[:3]:
        print(f"\n--- {a['source']} ---")
        print(f"Titre : {a['title']}")
        print(f"Date  : {a['date']}")
        print(f"Contenu : {a['content'][:100]}...")