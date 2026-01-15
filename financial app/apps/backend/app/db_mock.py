from typing import List, Dict, Any

# Simple in-memory storage for demonstration purposes
# In a real app, this would be a database connection
TRANSACTIONS_STORE: List[Dict[str, Any]] = []

def add_transactions(transactions: List[Dict[str, Any]]):
    TRANSACTIONS_STORE.extend(transactions)

def get_transactions():
    return TRANSACTIONS_STORE
