import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import SessionLocal
from models.models import Article, Topic
from services.rss_fetcher import fetch_all_articles
from services.categorizer import categorize_all
from services.text_processor import process_all


def run():
    db = SessionLocal()
    try:
        # 1. Récupérer tous les topics depuis la BDD
        topics = db.query(Topic).all()
        print(f"📚 {len(topics)} topics chargés depuis la BDD")

        # 2. Fetcher les articles RSS
        articles = fetch_all_articles()

        # 3. Nettoyage 
        articles = process_all(articles)

        # 4. Catégoriser les articles
        categorized = categorize_all(articles, topics)

        # 5. Sauvegarder en BDD
        added = 0
        skipped = 0

        for article_data in categorized:
            # Évite les doublons via l'URL
            existing = db.query(Article).filter(
                Article.url == article_data["url"]
            ).first()
            if existing:
                skipped += 1
                continue

            article = Article(
                title=article_data["title"],
                content=article_data["content"],
                cleaned_content=article_data.get("cleaned_content", ""),  # ← NOUVEAU
                source=article_data["source"],
                url=article_data["url"],
                date=article_data["date"],
                topic_ids=article_data["topic_ids"],
            )
            db.add(article)
            added += 1

        db.commit()
        print(f"\n🎉 {added} articles sauvegardés, {skipped} doublons ignorés")

    except Exception as e:
        db.rollback()
        print(f"❌ Erreur : {e}")
    finally:
        db.close()


if __name__ == "__main__":
    run()