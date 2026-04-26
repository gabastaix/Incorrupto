import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from backend.database import SessionLocal
from backend.models.models import User
from backend.auth import get_password_hash

def seed_users():
    db = SessionLocal()
    try:
        # Liste des utilisateurs fictifs
        users_data = [
            {"email": "alice@example.com", "password": "password123", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "bob@example.com", "password": "securepass456", "preferences": {"theme": "light", "notifications": False}},
            {"email": "charlie@example.com", "password": "mypassword789", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "diana@example.com", "password": "testpass000", "preferences": {"theme": "light", "notifications": True}},
            {"email": "eve@example.com", "password": "randompwd111", "preferences": {"theme": "dark", "notifications": False}},
        ]

        for user_data in users_data:
            # Vérifier si l'utilisateur existe déjà
            existing_user = db.query(User).filter(User.email == user_data["email"]).first()
            if existing_user:
                print(f"Utilisateur {user_data['email']} existe déjà, ignoré.")
                continue

            # Créer l'utilisateur
            hashed_password = get_password_hash(user_data["password"])
            db_user = User(
                email=user_data["email"],
                password=hashed_password,
                preferences=user_data["preferences"]
            )
            db.add(db_user)
            print(f"Utilisateur {user_data['email']} ajouté.")

        db.commit()
        print("Tous les utilisateurs fictifs ont été ajoutés avec succès.")
    except Exception as e:
        db.rollback()
        print(f"Erreur lors de l'ajout des utilisateurs : {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_users()