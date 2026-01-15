import asyncio
import asyncpg

async def check(user, password, dbname="postgres"):
    dsn = f"postgresql://{user}:{password}@127.0.0.1:5432/{dbname}" if password else f"postgresql://{user}@127.0.0.1:5432/{dbname}"
    try:
        conn = await asyncpg.connect(dsn)
        await conn.close()
        print(f"SUCCESS: {dsn}")
        with open("db_success.txt", "w") as f:
            f.write(dsn)
        return True
    except Exception as e:
        print(f"FAILED {user}/{password}: {e}")
        return False

async def main():
    creds = [
        ("postgres", "password"),
        ("postgres", "postgres"),
        ("postgres", "admin"),
        ("postgres", "root"),
        ("postgres", None), # No password
        ("admin", "admin"),
        ("admin", "password"), # User used this in config
    ]
    
    for u, p in creds:
        if await check(u, p):
            break

if __name__ == "__main__":
    asyncio.run(main())
