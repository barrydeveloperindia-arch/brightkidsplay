from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.api import api_router

app = FastAPI(title="Financial Super-App API", version="1.0.0")

# CORS Configuration
origins = [
    "http://localhost:3000", # Web App
    "http://localhost:8081", # Expo (Sample Port)
    "*", # For development convenience
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api/v1")

@app.on_event("startup")
async def startup_event():
    # Auto-migrate: Create tables if they don't exist
    from app.core.database import engine
    from app.models.base import Base
    # Ensure all models are imported so they are registered in Base.metadata
    from app.models import User, Account, Transaction, Budget
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("Database tables created/verified.")

@app.get("/health")
def health_check():
    return {"status": "healthy"}
