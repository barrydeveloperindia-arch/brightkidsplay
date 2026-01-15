from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base
import os

# Use environment variable or default to local docker instance
# Force asyncpg and disable echo to prevent greenlet issues
DATABASE_URL = "postgresql+asyncpg://postgres:admin@localhost:5432/financial_app"

# Create Async Engine
engine = create_async_engine(DATABASE_URL, echo=False)

# Create Async Session Factory
AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False
)

# Dependency for FastAPI Endpoints
# Dependency for FastAPI Endpoints
async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()

# Sync fallback for problematic windows environments
from sqlalchemy import create_engine
from sqlalchemy.orm import Session
SYNC_DATABASE_URL = "postgresql://postgres:admin@localhost:5432/financial_app"
sync_engine = create_engine(SYNC_DATABASE_URL, echo=False)
SyncSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=sync_engine)

def get_sync_db():
    db = SyncSessionLocal()
    try:
        yield db
    finally:
        db.close()
