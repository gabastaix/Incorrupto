import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database import SessionLocal
from models.models import Topic

TOPICS = [
    # ── Politique ──────────────────────────────────────────────────────
    {
        "name": "Gouvernement & Assemblée",
        "category": "Politique",
        "keywords": ["gouvernement", "assemblée nationale", "parlement", "premier ministre", "macron", "élysée"],
        "excerpt": "Actualités du pouvoir exécutif et législatif français."
    },
    {
        "name": "Élections",
        "category": "Politique",
        "keywords": ["élection", "vote", "scrutin", "candidat", "sondage", "législatives", "présidentielle"],
        "excerpt": "Résultats, sondages et enjeux électoraux."
    },
    {
        "name": "Immigration",
        "category": "Politique",
        "keywords": ["immigration", "migrants", "asile", "frontière", "expulsion", "sans-papiers"],
        "excerpt": "Débats et politiques autour de l'immigration en France."
    },

    # ── Économie ───────────────────────────────────────────────────────
    {
        "name": "Budget & Finances publiques",
        "category": "Économie",
        "keywords": ["budget", "déficit", "dette publique", "dépenses", "impôts", "fiscalité"],
        "excerpt": "Les grands équilibres financiers de l'État français."
    },
    {
        "name": "Pouvoir d'achat",
        "category": "Économie",
        "keywords": ["pouvoir d'achat", "inflation", "prix", "salaire", "smic", "coût de la vie"],
        "excerpt": "Inflation, salaires et conditions de vie des Français."
    },
    {
        "name": "Emploi & Chômage",
        "category": "Économie",
        "keywords": ["emploi", "chômage", "licenciement", "recrutement", "marché du travail", "chômeurs"],
        "excerpt": "Évolution du marché du travail en France."
    },

    # ── Énergie ────────────────────────────────────────────────────────
    {
        "name": "Nucléaire français",
        "category": "Énergie",
        "keywords": ["nucléaire", "EPR", "EDF", "centrale", "réacteur", "électronucléaire"],
        "excerpt": "L'avenir du parc nucléaire et les projets de nouveaux réacteurs."
    },
    {
        "name": "Énergies renouvelables",
        "category": "Énergie",
        "keywords": ["renouvelable", "éolien", "solaire", "photovoltaïque", "hydraulique", "transition énergétique"],
        "excerpt": "Développement des énergies vertes en France."
    },
    {
        "name": "Prix de l'énergie",
        "category": "Énergie",
        "keywords": ["prix de l'électricité", "facture énergie", "gaz", "carburant", "tarif réglementé"],
        "excerpt": "Évolution des prix de l'électricité, du gaz et du carburant."
    },

    # ── Société ────────────────────────────────────────────────────────
    {
        "name": "Éducation",
        "category": "Société",
        "keywords": ["éducation", "école", "lycée", "université", "baccalauréat", "enseignant", "professeur"],
        "excerpt": "Réformes et actualités du système éducatif français."
    },
    {
        "name": "Santé & Hôpital",
        "category": "Société",
        "keywords": ["santé", "hôpital", "médecin", "sécurité sociale", "remboursement", "désert médical"],
        "excerpt": "Le système de santé français, ses défis et réformes."
    },
    {
        "name": "Justice & Police",
        "category": "Société",
        "keywords": ["justice", "tribunal", "police", "gendarmerie", "crime", "prison", "condamnation"],
        "excerpt": "Actualités judiciaires et forces de l'ordre."
    },
    {
        "name": "Retraites",
        "category": "Société",
        "keywords": ["retraite", "pension", "âge de départ", "cotisation", "réforme des retraites"],
        "excerpt": "Le débat sur le système de retraites français."
    },

    # ── International ──────────────────────────────────────────────────
    {
        "name": "Guerre en Ukraine",
        "category": "International",
        "keywords": ["ukraine", "russie", "guerre", "otan", "zelensky", "poutine", "conflit"],
        "excerpt": "Le conflit russo-ukrainien et ses répercussions mondiales."
    },
    {
        "name": "États-Unis",
        "category": "International",
        "keywords": ["états-unis", "usa", "trump", "biden", "washington", "maison blanche", "congrès américain"],
        "excerpt": "Politique américaine et relations franco-américaines."
    },
    {
        "name": "Union Européenne",
        "category": "International",
        "keywords": ["union européenne", "bruxelles", "commission européenne", "parlement européen", "zone euro"],
        "excerpt": "Décisions et enjeux de l'Union Européenne."
    },

    # ── Environnement ──────────────────────────────────────────────────
    {
        "name": "Climat & Réchauffement",
        "category": "Environnement",
        "keywords": ["climat", "réchauffement", "CO2", "émissions", "COP", "gaz à effet de serre"],
        "excerpt": "La crise climatique et les engagements de la France."
    },
    {
        "name": "Biodiversité",
        "category": "Environnement",
        "keywords": ["biodiversité", "espèces", "déforestation", "océan", "pollinisateur", "extinction"],
        "excerpt": "Protection de la nature et des espèces menacées."
    },
    {
        "name": "Pollution",
        "category": "Environnement",
        "keywords": ["pollution", "qualité de l'air", "pesticide", "plastique", "eau potable", "microplastique"],
        "excerpt": "Pollution de l'air, de l'eau et des sols en France."
    },
    {
        "name": "Agriculture & Alimentation",
        "category": "Environnement",
        "keywords": ["agriculture", "agriculteur", "pesticide", "bio", "alimentation", "élevage", "paysan"],
        "excerpt": "Les défis de l'agriculture française face à l'environnement."
    },
]


def seed_topics():
    db = SessionLocal()
    try:
        added = 0
        skipped = 0
        for t in TOPICS:
            existing = db.query(Topic).filter(Topic.name == t["name"]).first()
            if existing:
                skipped += 1
                continue
            topic = Topic(
                name=t["name"],
                category=t["category"],
                keywords=t["keywords"],
                excerpt=t["excerpt"],
            )
            db.add(topic)
            added += 1

        db.commit()
        print(f"✅ {added} sujets ajoutés, {skipped} déjà existants.")
    except Exception as e:
        db.rollback()
        print(f"❌ Erreur : {e}")
    finally:
        db.close()


if __name__ == "__main__":
    seed_topics()