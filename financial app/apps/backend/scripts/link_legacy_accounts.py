import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, Account

def link_legacy():
    db = SyncSessionLocal()
    
    # Check for unlinked
    unlinked_count = db.query(Transaction).filter(Transaction.account_id == None).count()
    if unlinked_count == 0:
        print("No unlinked transactions found.")
        return

    print(f"Found {unlinked_count} unlinked transactions.")
    
    # Create Legacy Account
    account = db.query(Account).filter(Account.institution_name == "Legacy Import").first()
    if not account:
        account = Account(
            institution_id="legacy",
            institution_name="Legacy Import",
            account_type="SAVINGS", 
            masked_account_number="XXXX"
        )
        db.add(account)
        db.commit()
        db.refresh(account)
        print("Created 'Legacy Import' account.")
        
    # Link
    db.query(Transaction).filter(Transaction.account_id == None).update(
        {Transaction.account_id: account.account_id}, 
        synchronize_session=False
    )
    
    db.commit()
    print(f"Linked {unlinked_count} transactions to 'Legacy Import'.")
    db.close()

if __name__ == "__main__":
    link_legacy()
