import sys
import os
from collections import Counter
import re

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal
from app.models import Transaction

def analyze_uncategorized():
    db = SyncSessionLocal()
    
    # Fetch all uncategorized
    uncategorized = db.query(Transaction).filter(
        (Transaction.category == 'Uncategorized') | (Transaction.category == None)
    ).all()
    
    print(f"Total Uncategorized Transactions: {len(uncategorized)}\n")
    
    # Extract meaningful tokens (simple normalization)
    descriptions = [t.description for t in uncategorized if t.description]
    
    # 1. Exact Description Frequency
    print("--- Top Frequent Descriptions (Exact) ---")
    exact_counts = Counter(descriptions).most_common(10)
    for desc, count in exact_counts:
        print(f"{count}x : {desc}")
        
    print("\n--- Potential Missing Keywords (Token Analysis) ---")
    # Tokenize: Split by space, keep only alpha > 3 chars
    tokens = []
    for d in descriptions:
        words = re.findall(r'[a-zA-Z]{3,}', d.lower())
        tokens.extend(words)
        
    common_tokens = Counter(tokens).most_common(20)
    ignore_list = ['payment', 'transfer', 'upi', 'from', 'bank', 'ref', 'txn', 'imps', 'neft', 'date']
    
    for token, count in common_tokens:
        if token not in ignore_list:
            print(f"{count}x : {token}")
            
    db.close()

if __name__ == "__main__":
    analyze_uncategorized()
