import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account

def inspect_legacy():
    db = SyncSessionLocal()
    
    # 1. Get Legacy Account
    legacy = db.query(Account).filter(Account.institution_id == "legacy").first()
    if not legacy:
        print("Legacy Import account not found.")
        return
        
    print(f"Legacy Account ID: {legacy.account_id}")
    
    # 2. Get Transactions
    txns = db.query(Transaction).filter(Transaction.account_id == legacy.account_id).limit(50).all()
    
    print("\n--- Legacy Transaction Samples ---")
    for t in txns:
        print(f"[{t.transaction_date}] {t.description[:50]}... (Ref: {t.reference_number})")
        
    db.close()

if __name__ == "__main__":
    inspect_legacy()
