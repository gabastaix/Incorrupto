import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models.models import Base, User
from auth import get_password_hash

# Utiliser une base temporaire
SQLALCHEMY_DATABASE_URL = "sqlite:///./incorrupto_temp.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

def seed_users():
    db = SessionLocal()
    try:
        # Liste des utilisateurs fictifs
        users_data = [
            {"email": "alice@example.com", "first_name": "Alice", "last_name": "Dupont", "age": 28, "password": "password123", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "bob@example.com", "first_name": "Bob", "last_name": "Martin", "age": 35, "password": "securepass456", "preferences": {"theme": "light", "notifications": False}},
            {"email": "charlie@example.com", "first_name": "Charlie", "last_name": "Leclerc", "age": 42, "password": "mypassword789", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "diana@example.com", "first_name": "Diana", "last_name": "Sanchez", "age": 31, "password": "testpass000", "preferences": {"theme": "light", "notifications": True}},
            {"email": "eve@example.com", "first_name": "Eve", "last_name": "Rousseau", "age": 26, "password": "randompwd111", "preferences": {"theme": "dark", "notifications": False}},
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
                first_name=user_data["first_name"],
                last_name=user_data["last_name"],
                age=user_data["age"],
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