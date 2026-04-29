import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import SessionLocal
from models.models import Article, Analysis
from services.ai_summarizer import generate_summary


def run_analysis_pipeline(limit: int = 10):
    """
    Génère les résumés IA pour les articles qui n'en ont pas encore.
    limit = nombre max d'articles à traiter par run (pour ne pas exploser le quota Groq)
    """
    db = SessionLocal()
    try:
        # Récupère les articles sans analyse
        analysed_ids = db.query(Analysis.article_id).subquery()
        articles = (
            db.query(Article)
            .filter(Article.id.notin_(analysed_ids))
            .filter(Article.cleaned_content != None)
            .limit(limit)
            .all()
        )

        print(f"📝 {len(articles)} articles à analyser...")

        success = 0
        failed = 0

        for article in articles:
            print(f"  → {article.title[:60]}...")

            summary = generate_summary(
                title=article.title,
                content=article.cleaned_content or article.content or ""
            )

            if summary:
                analysis = Analysis(
                    article_id=article.id,
                    summary=summary,
                    perspectives={},  # sera rempli à l'étape 7
                )
                db.add(analysis)
                db.commit()
                success += 1
            else:
                failed += 1

        print(f"\n🎉 {success} analyses générées, {failed} échecs")

    except Exception as e:
        db.rollback()
        print(f"❌ Erreur : {e}")
    finally:
        db.close()


if __name__ == "__main__":
    run_analysis_pipeline(limit=10)