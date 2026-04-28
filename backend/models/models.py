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
    followed_topics = relationship("UserTopic", back_populates="user")

class Topic(Base):
    __tablename__ = 'topics'

    id       = Column(Integer, primary_key=True, index=True)
    name     = Column(String, nullable=False)        # ex: "Nucléaire français"
    category = Column(String, nullable=False)        # ex: "Énergie"
    keywords = Column(JSON, nullable=False)          # ex: ["nucléaire", "EPR", "EDF"]
    excerpt  = Column(String, nullable=True)         # courte description affichée dans l'app

    user_topics = relationship("UserTopic", back_populates="topic")


class UserTopic(Base):
    __tablename__ = 'user_topics'

    id       = Column(Integer, primary_key=True, index=True)
    user_id  = Column(Integer, ForeignKey('users.id'), nullable=False)
    topic_id = Column(Integer, ForeignKey('topics.id'), nullable=False)

    user  = relationship("User", back_populates="followed_topics")
    topic = relationship("Topic", back_populates="user_topics")

class Article(Base):
    __tablename__ = 'articles'

    id        = Column(Integer, primary_key=True, index=True)
    title     = Column(String, nullable=False)
    content   = Column(Text, nullable=True)
    source    = Column(String, nullable=False)
    url       = Column(String, unique=True, nullable=True)   # ← NOUVEAU
    date      = Column(DateTime, nullable=True)
    category  = Column(String, nullable=True)
    topic_ids = Column(JSON, nullable=True)                  # ← NOUVEAU

class Analysis(Base):
    __tablename__ = 'analyses'

    id = Column(Integer, primary_key=True, index=True)
    article_id = Column(Integer, ForeignKey('articles.id'), nullable=False)
    summary = Column(Text, nullable=False)  # résumé factuel
    perspectives = Column(JSON, nullable=False)  # perspectives politiques

    article = relationship("Article")