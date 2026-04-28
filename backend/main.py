from datetime import timedelta
import logging

from fastapi import FastAPI, Depends, HTTPException, Request, status
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from .auth import (
    ACCESS_TOKEN_EXPIRE_MINUTES,
    authenticate_user,
    create_access_token,
    get_current_user,
    get_password_hash,
)
from .database import get_db
from .models.models import User, Topic, Article
from .schemas import Token, UserCreate, UserRead

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Incorrupto Backend", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(Exception)
async def all_exception_handler(request: Request, exc: Exception):
    logger.exception("Unhandled error")
    return JSONResponse(
        status_code=500,
        content={"detail": str(exc), "type": type(exc).__name__},
    )

@app.get("/")
async def root():
    return {"message": "Bienvenue sur l'API Incorrupto"}

@app.get("/health")
async def health():
    return {"status": "OK"}

@app.post("/register", response_model=UserRead)
def register(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    db_user = User(
        email=user.email,
        password=get_password_hash(user.password),
        preferences=user.preferences or {},
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.post("/login", response_model=Token)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)
):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
    )
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/me", response_model=UserRead)
def read_me(current_user: User = Depends(get_current_user)):
    return current_user

# ── Topics ────────────────────────────────────────────────────────────

@app.get("/topics")
def get_topics(db: Session = Depends(get_db)):
    topics = db.query(Topic).all()
    return [
        {
            "id": t.id,
            "name": t.name,
            "category": t.category,
            "excerpt": t.excerpt,
        }
        for t in topics
    ]


@app.get("/topics/{topic_id}/articles")
def get_topic_articles(topic_id: int, db: Session = Depends(get_db)):
    articles = db.query(Article).filter(
        Article.topic_ids.contains([topic_id])
    ).order_by(Article.date.desc()).all()

    return [
        {
            "id": a.id,
            "title": a.title,
            "content": a.content,
            "source": a.source,
            "url": a.url,
            "date": str(a.date),
        }
        for a in articles
    ]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)