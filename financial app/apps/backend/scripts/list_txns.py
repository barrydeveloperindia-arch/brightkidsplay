import sys
import os

# Add parent dir to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction

def list_descriptions():
    db = SyncSessionLocal()
    txns = db.query(Transaction).limit(20).all()
    
    print("\n--- SAMPLE TRANSACTIONS ---")
    for t in txns:
        print(f"DESC: '{t.description}' | CAT: {t.category}")
        
    db.close()

if __name__ == "__main__":
    list_descriptions()
