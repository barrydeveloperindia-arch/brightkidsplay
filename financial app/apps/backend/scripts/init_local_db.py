import asyncio
import asyncpg

async def init_db():
    # Connect to default 'postgres' database
    conn = await asyncpg.connect("postgresql://postgres:admin@127.0.0.1:5432/postgres")
    try:
        # Check if financial_app exists
        exists = await conn.fetchval("SELECT 1 FROM pg_database WHERE datname = 'financial_app'")
        if not exists:
            print("Creating database financial_app...")
            await conn.execute('CREATE DATABASE financial_app')
            print("✅ Database created.")
        else:
            print("Database financial_app already exists.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(init_db())
