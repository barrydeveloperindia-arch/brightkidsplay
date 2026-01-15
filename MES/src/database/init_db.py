from src.database.connection import engine, Base
from src.database.models import Machine, Order, DispatchQueue, Invoice

def init_db():
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("Database tables created successfully!")

if __name__ == "__main__":
    init_db()
