import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account
from sqlalchemy import func

def check_accounts():
    db = SyncSessionLocal()
    
    grouped = db.query(Transaction.account_id, func.count(Transaction.transaction_id)).group_by(Transaction.account_id).all()
    
    print("\n--- Transaction Distribution ---")
    for acc_id, count in grouped:
        if acc_id:
            acc = db.query(Account).filter(Account.account_id == acc_id).first()
            name = f"{acc.institution_name} ({acc.institution_id})"
        else:
            name = "NULL (Unlinked)"
            
        print(f"{name}: {count} transactions")
        
    db.close()

if __name__ == "__main__":
    check_accounts()
