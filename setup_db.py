#!/usr/bin/env python3
"""
Setup script: recreate database and seed with users
"""
import sys
import os

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from backend.models.models import Base, User
from backend.auth import get_password_hash

DATABASE_URL = "sqlite:///./backend/incorrupto.db"

def setup_database():
    engine = create_engine(
        DATABASE_URL, connect_args={"check_same_thread": False}
    )
    
    # Drop and recreate
    print("Dropping all tables...")
    Base.metadata.drop_all(bind=engine)
    
    print("Creating tables...")
    Base.metadata.create_all(bind=engine)
    
    # Seed users
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()
    
    try:
        users_data = [
            {"email": "alice@example.com", "first_name": "Alice", "last_name": "Dupont", "age": 28, "password": "password123", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "bob@example.com", "first_name": "Bob", "last_name": "Martin", "age": 35, "password": "securepass456", "preferences": {"theme": "light", "notifications": False}},
            {"email": "charlie@example.com", "first_name": "Charlie", "last_name": "Leclerc", "age": 42, "password": "mypassword789", "preferences": {"theme": "dark", "notifications": True}},
            {"email": "diana@example.com", "first_name": "Diana", "last_name": "Sanchez", "age": 31, "password": "testpass000", "preferences": {"theme": "light", "notifications": True}},
            {"email": "eve@example.com", "first_name": "Eve", "last_name": "Rousseau", "age": 26, "password": "randompwd111", "preferences": {"theme": "dark", "notifications": False}},
        ]
        
        for user_data in users_data:
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
            print(f"✓ {user_data['email']} ({user_data['first_name']} {user_data['last_name']}, {user_data['age']} ans)")
        
        db.commit()
        print("\n✅ Database setup complete!")
    except Exception as e:
        db.rollback()
        print(f"❌ Error: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    setup_database()
