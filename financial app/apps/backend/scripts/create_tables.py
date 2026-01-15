import asyncio
import os
import sys

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), "apps", "backend"))

from app.core.database import engine, Base
# Import models to register them with Base
from app.models import User, Account, Transaction 

async def create_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("✅ Tables created successfully.")

if __name__ == "__main__":
    asyncio.run(create_tables())
