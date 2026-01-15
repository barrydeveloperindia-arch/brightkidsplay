import sys
import os

# Add parent dir to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal, sync_engine
from app.models import CategoryRule, Base

def seed_rules():
    db = SyncSessionLocal()
    
    # Ensure Table Exists
    Base.metadata.create_all(bind=sync_engine)
    
    # Default Rules
    rules = [
        {
            "name": "Uber/Ola -> Transport",
            "keywords": ["uber", "ola", "rapido", "taxi"],
            "target_category": "Transport",
            "target_tags": ["taxi", "commute"]
        },
        {
            "name": "Zomato/Swiggy -> Food",
            "keywords": ["zomato", "swiggy", "blinkit", "instamart"],
            "target_category": "Food & Dining",
            "target_tags": ["delivery"]
        },
        {
            "name": "Amazon/Flipkart -> Shopping",
            "keywords": ["amazon", "flipkart", "amzn"],
            "target_category": "Shopping",
            "target_tags": ["online"]
        },
        {
            "name": "Netflix/Spotify -> Subscription",
            "keywords": ["netflix", "spotify", "prime", "hotstar"],
            "target_category": "Entertainment",
            "target_tags": ["subscription"]
        }
    ]
    
    print("Seeding Rules...")
    for r in rules:
        exists = db.query(CategoryRule).filter(CategoryRule.name == r["name"]).first()
        if not exists:
            rule = CategoryRule(
                name=r["name"],
                keywords=r["keywords"],
                target_category=r["target_category"],
                target_tags=r["target_tags"]
            )
            db.add(rule)
            print(f"Added Rule: {r['name']}")
        else:
            print(f"Skipped: {r['name']} (Exists)")
            
    db.commit()
    db.close()
    print("Seeding Complete!")

if __name__ == "__main__":
    seed_rules()
