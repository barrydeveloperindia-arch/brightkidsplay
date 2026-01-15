from typing import List
from sqlalchemy.orm import Session
from app.models.rule import CategoryRule
from app.models.transaction import Transaction

class RuleEngine:
    def __init__(self, db: Session):
        self.rules = db.query(CategoryRule).all()

    def apply(self, txn: Transaction):
        """
        Applies loaded rules to a transaction instance using Regex.
        Modifies txn in-place.
        """
        if not txn.description:
            return

        import re

        for rule in self.rules:
            # Compile keywords into a single regex pattern or check individually
            # Treating each keyword in rule.keywords as a potential regex pattern
            
            match_found = False
            for pattern in rule.keywords:
                if not pattern: continue
                try:
                    # Attempt regex search
                    # We use re.IGNORECASE as a fallback if not in pattern, 
                    # but our seed patterns have (?i)
                    if re.search(pattern, txn.description, re.IGNORECASE):
                        match_found = True
                        break
                except re.error:
                    # Fallback to simple substring if bad regex
                    if pattern.lower() in txn.description.lower():
                        match_found = True
                        break
            
            if match_found:
                # Apply Category
                if rule.target_category:
                    txn.category = rule.target_category
                
                # Apply Tags
                if rule.target_tags:
                    current_tags = set(txn.tags or [])
                    current_tags.update(rule.target_tags)
                    txn.tags = list(current_tags)
                    
                print(f"Match [{rule.name}] -> {txn.description[:30]}...")
