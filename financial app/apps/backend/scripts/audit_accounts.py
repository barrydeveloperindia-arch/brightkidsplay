import sys
import os
from sqlalchemy import func

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account

def audit_accounts():
    db = SyncSessionLocal()
    
    # 1. Get Counts
    counts = db.query(Transaction.account_id, func.count(Transaction.transaction_id)).group_by(Transaction.account_id).all()
    count_map = {acc_id: count for acc_id, count in counts}
    
    # 2. Get Accounts
    accounts = db.query(Account).all()
    
    print("\n| Account Name | Institution ID | Count |")
    print("|---|---|---|")
    
    total_tracked = 0
    for acc in accounts:
        count = count_map.get(acc.account_id, 0)
        total_tracked += count
        print(f"| {acc.institution_name} | {acc.institution_id} | {count} |")
        
    # Check for NULL
    null_count = count_map.get(None, 0)
    if null_count > 0:
        print(f"| **Unlinked / NULL** | - | {null_count} |")
        
    print(f"\n**Total Transactions**: {total_tracked + null_count}")
    db.close()

if __name__ == "__main__":
    audit_accounts()
