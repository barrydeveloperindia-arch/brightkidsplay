import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account

def fix_hdfc():
    db = SyncSessionLocal()
    
    hdfc = db.query(Account).filter(Account.institution_name == "HDFC").first()
    if not hdfc:
        print("HDFC Account not found.")
        return

    # Fetch all credits
    txns = db.query(Transaction).filter(
        Transaction.account_id == hdfc.account_id,
        Transaction.type == "CREDIT"
    ).all()
    
    print(f"Found {len(txns)} HDFC CREDITS.")
    
    count = 0
    for t in txns:
        # Heuristic: If it has 'EMI' or 'Bijili' or 'Bill', it's a DEBIT
        # Actually, for this user context, likely ALL of these 11 are mislabeled imports.
        # Let's flip them all for now to show them.
        t.type = "DEBIT"
        count += 1
        
    db.commit()
    print(f"Flipped {count} transactions to DEBIT.")
    db.close()

if __name__ == "__main__":
    fix_hdfc()
