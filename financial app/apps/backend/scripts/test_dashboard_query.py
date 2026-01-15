import asyncio
import sys
import os
import traceback

# Add backend to path logic to be robust
current_dir = os.path.dirname(os.path.abspath(__file__)) # .../apps/backend/scripts
backend_dir = os.path.dirname(current_dir) # .../apps/backend
if backend_dir not in sys.path:
    sys.path.append(backend_dir)

from app.core.database import AsyncSessionLocal, get_sync_db
from app.models import Transaction, Base
from sqlalchemy import func, select, text

async def test_async_query():
    print("\n--- Testing Async Connection ---")
    try:
        print(f"Engine type: {type(AsyncSessionLocal.kw['bind'])}")
    except:
        print("Could not inspect bind type")
        
    async with AsyncSessionLocal() as session:
        try:
            print("Executing Simple Query (select 1)...")
            result = await session.execute(text("SELECT 1"))
            print(f"Result: {result.scalar()}")
            
            print("Executing Spend Query...")
            stmt = select(func.sum(Transaction.amount)).filter(Transaction.type == 'DEBIT')
            result = await session.execute(stmt)
            val = result.scalar()
            print(f"Async Spend: {val}")
            
        except Exception as e:
            print("ERROR IN ASYNC TEST:")
            traceback.print_exc()

def test_sync_query():
    print("\n--- Testing Sync Connection (Used by Dashboard) ---")
    try:
        # get_sync_db is a generator
        db_gen = get_sync_db()
        db = next(db_gen)
        print("Got sync session.")
        
        try:
            print("Executing Simple Query (select 1)...")
            res = db.execute(text("SELECT 1"))
            print(f"Result: {res.scalar()}")
            
            print("Executing Dashboard Spend Query...")
            query_spend = text("SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE type = 'DEBIT'")
            res_spend = db.execute(query_spend)
            total_spend = res_spend.scalar()
            print(f"Sync Spend: {total_spend}")
            
        except Exception as e:
            print("ERROR IN SYNC TEST:")
            traceback.print_exc()
        finally:
            db.close()
            
    except Exception as e:
        print("FAILED TO GET SYNC SESSION:")
        traceback.print_exc()

async def main():
    if sys.platform == 'win32':
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    
    await test_async_query()
    test_sync_query()

if __name__ == "__main__":
    asyncio.run(main())
