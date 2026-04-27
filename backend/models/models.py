from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    first_name = Column(String, nullable=True)  # prénom
    last_name = Column(String, nullable=True)   # nom
    age = Column(Integer, nullable=True)         # âge
    preferences = Column(JSON)  # thèmes choisis

class Topic(Base):
    __tablename__ = 'topics'

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)  # ex: Trump, écologie

class Article(Base):
    __tablename__ = 'articles'

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    source = Column(String, nullable=False)  # Le Monde, Figaro…
    date = Column(DateTime, default=datetime.datetime.utcnow)
    category = Column(String)

class Analysis(Base):
    __tablename__ = 'analyses'

    id = Column(Integer, primary_key=True, index=True)
    article_id = Column(Integer, ForeignKey('articles.id'), nullable=False)
    summary = Column(Text, nullable=False)  # résumé factuel
    perspectives = Column(JSON, nullable=False)  # perspectives politiques

    article = relationship("Article")