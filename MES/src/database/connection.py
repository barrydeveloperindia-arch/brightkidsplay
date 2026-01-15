from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os

# Using SQLite for local development ease, but compatible with PostgreSQL logic
# In production: "postgresql://user:password@localhost/mes_db"
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./mes.db")

engine = create_engine(
    DATABASE_URL, 
    connect_args={"check_same_thread": False} if "sqlite" in DATABASE_URL else {}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
