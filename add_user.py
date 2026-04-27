#!/usr/bin/env python3
"""Add a new user to the database"""
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from backend.models.models import Base, User
from backend.auth import get_password_hash

DATABASE_URL = "sqlite:///./incorrupto.db"

def add_user():
    engine = create_engine(
        DATABASE_URL, connect_args={"check_same_thread": False}
    )
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        user_data = {
            "email": "alexben3005@yahoo.fr",
            "first_name": "Alexandre",
            "last_name": "Ben",
            "age": 23,
            "password": "ABC123",
            "preferences": {"theme": "dark", "notifications": True}
        }
        
        # Check if user exists
        existing = db.query(User).filter(User.email == user_data["email"]).first()
        if existing:
            print(f"❌ Utilisateur {user_data['email']} existe déjà")
            return
        
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
        db.commit()
        print(f"✅ Utilisateur ajouté : {user_data['email']} ({user_data['first_name']} {user_data['last_name']}, {user_data['age']} ans)")
    except Exception as e:
        db.rollback()
        print(f"❌ Erreur : {e}")
    finally:
        db.close()

if __name__ == "__main__":
    add_user()
