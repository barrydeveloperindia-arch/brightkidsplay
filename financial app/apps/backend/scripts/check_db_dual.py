import asyncio
import sys
import os
from sqlalchemy import create_engine, text, inspect
from sqlalchemy.ext.asyncio import create_async_engine

# Defines
URL_ASYNC = "postgresql+asyncpg://postgres:admin@localhost:5432/financial_app"
URL_SYNC = "postgresql://postgres:admin@localhost:5432/financial_app"

async def check_async():
    print(f"--- Checking ASYNC ({URL_ASYNC}) ---")
    try:
        engine = create_async_engine(URL_ASYNC, echo=False)
        async with engine.connect() as conn:
            # List tables
            result = await conn.execute(text("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"))
            tables = result.scalars().all()
            print(f"ASYNC Tables found: {tables}")
            
            if 'transactions' in tables:
                cnt = await conn.execute(text("SELECT count(*) FROM transactions"))
                print(f"Transaction Count: {cnt.scalar()}")
            else:
                print("Transactions table NOT found in Async.")
    except Exception as e:
        print(f"ASYNC Error: {e}")

    except Exception as e:
        print(f"ASYNC Error: {e}")

def check_sync(url, label):
    print(f"\n--- Checking SYNC ({label}) ---")
    try:
        engine = create_engine(url, echo=False)
        with engine.connect() as conn:
            # Check DB Name
            db_name = conn.execute(text("SELECT current_database()")).scalar()
            print(f"Connected to DB: {db_name}")
            
             # List tables
            result = conn.execute(text("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"))
            tables = result.scalars().all()
            print(f"SYNC Tables found: {tables}")

            if 'transactions' in tables:
                cnt = conn.execute(text("SELECT count(*) FROM transactions"))
                print(f"Transaction Count: {cnt.scalar()}")
            else:
                print("Transactions table NOT found.")

    except Exception as e:
        print(f"SYNC Error: {e}")

if __name__ == "__main__":
    if sys.platform == 'win32':
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
        
    # Async Check
    asyncio.run(check_async())
    
    # Sync Checks
    check_sync("postgresql://postgres:admin@localhost:5432/financial_app", "LOCALHOST")
    check_sync("postgresql://postgres:admin@127.0.0.1:5432/financial_app", "127.0.0.1")
