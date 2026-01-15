import sys
import os
from sqlalchemy import func

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account

def check_duplicates():
    db = SyncSessionLocal()
    
    # Get Legacy Account
    legacy_acc = db.query(Account).filter(Account.institution_id == "legacy").first()
    if not legacy_acc:
        print("No Legacy account.")
        return

    legacy_txns = db.query(Transaction).filter(Transaction.account_id == legacy_acc.account_id).all()
    
    # Get all other transactions
    other_txns = db.query(Transaction).filter(Transaction.account_id != legacy_acc.account_id).all()
    
    print(f"Legacy: {len(legacy_txns)}")
    print(f"Named: {len(other_txns)}")
    
    # Build Lookup for Named
    # Key: date + amount + description (approx)
    named_map = set()
    for t in other_txns:
        key = f"{t.transaction_date}|{t.amount}|{t.description}"
        named_map.add(key)
        
    # Check overlap
    duplicates = 0
    for t in legacy_txns:
        key = f"{t.transaction_date}|{t.amount}|{t.description}"
        if key in named_map:
            duplicates += 1
            
    print(f"Overlap (Potential Duplicates): {duplicates}")
    
    if duplicates > 0:
        print("Recommendation: Delete Legacy duplicates.")
        
    db.close()

if __name__ == "__main__":
    check_duplicates()
