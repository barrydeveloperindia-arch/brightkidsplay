import asyncio
import asyncpg

async def check_data():
    conn = await asyncpg.connect("postgresql://postgres:admin@127.0.0.1:5432/financial_app")
    try:
        users = await conn.fetchval("SELECT COUNT(*) FROM users")
        accounts = await conn.fetchval("SELECT COUNT(*) FROM accounts")
        transactions = await conn.fetchval("SELECT COUNT(*) FROM transactions")
        
        print(f"Users: {users}")
        print(f"Accounts: {accounts}")
        print(f"Transactions: {transactions}")
        
    except Exception as e:
        print(f"Error: {e}")
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(check_data())
