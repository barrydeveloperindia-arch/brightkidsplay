import sys
import os

# Add parent dir to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction, CategoryRule
from app.services.rule_engine import RuleEngine

def apply_rules_history():
    db = SyncSessionLocal()
    rule_engine = RuleEngine(db)
    
    print("Fetching all transactions...")
    transactions = db.query(Transaction).all()
    print(f"Found {len(transactions)} transactions.")
    
    updated_count = 0
    
    for txn in transactions:
        original_category = txn.category
        original_tags = list(txn.tags or [])
        
        # Apply Rules
        rule_engine.apply(txn)
        
        # Check if changed
        if txn.category != original_category or set(txn.tags or []) != set(original_tags):
            print(f"Updated: {txn.description[:30]}... | {original_category} -> {txn.category} | Tags: {txn.tags}")
            updated_count += 1
            
    if updated_count > 0:
        db.commit()
        print(f"Successfully updated {updated_count} transactions.")
    else:
        print("No transactions matched existing rules.")
        
    db.close()

if __name__ == "__main__":
    apply_rules_history()
