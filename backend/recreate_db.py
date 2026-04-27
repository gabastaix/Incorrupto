import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models.models import Base

# Utiliser la même base que l'app
SQLALCHEMY_DATABASE_URL = "sqlite:///./incorrupto.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

def recreate_db():
    """Drop all tables and recreate schema from models"""
    print("Dropping all tables...")
    Base.metadata.drop_all(bind=engine)
    
    print("Creating tables...")
    Base.metadata.create_all(bind=engine)
    
    print("Database schema recreated successfully!")

if __name__ == "__main__":
    recreate_db()
