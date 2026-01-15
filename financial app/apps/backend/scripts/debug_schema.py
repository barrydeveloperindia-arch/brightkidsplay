import asyncio
import asyncpg

async def check_schema():
    conn = await asyncpg.connect("postgresql://postgres:admin@127.0.0.1:5432/financial_app")
    try:
        rows = await conn.fetch("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
        print("TABLES IN PUBLIC SCHEMA:")
        for row in rows:
            print(f"- {row['table_name']}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(check_schema())
