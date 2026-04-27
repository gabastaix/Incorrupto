import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models.models import Base, User

# Utiliser la même base que l'app
SQLALCHEMY_DATABASE_URL = "sqlite:///./incorrupto.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def check_users():
    db = SessionLocal()
    try:
        users = db.query(User).all()
        print(f'Nombre d\'utilisateurs: {len(users)}')
        for u in users:
            print(f'{u.email}: {u.password[:20]}...')
    finally:
        db.close()

if __name__ == "__main__":
    check_users()