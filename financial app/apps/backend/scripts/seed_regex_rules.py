import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SyncSessionLocal, sync_engine
from app.models import CategoryRule, Base

def seed_regex_rules():
    db = SyncSessionLocal()
    
    # Ensure tables
    try:
        Base.metadata.create_all(bind=sync_engine)
    except:
        pass # Might already exist

    # MASTER REGEX PATTERNS
    # Using regex syntax directly in keywords.
    # The RuleEngine will join these with '|' and compile.
    rules = [
        {
            "name": "Health & Medical",
            "keywords": [
                r"(?i).*(pharmacy|medplus|apollo|hospital|clinic|dr\.?\s|chemist|medico|diagnostics|health|1mg|pharmeasy|lab).*"
            ],
            "target_category": "Health & Medicine",
            "target_tags": ["health", "medical"]
        },
        {
            "name": "Travel & Stay",
            "keywords": [
                r"(?i).*(hotel|resort|stay|inn|bnb|motel|taj|marriott|hyatt|oyo|airbnb|room).*",
                r"(?i).*(uber|ola|rapido|taxi|cab|ride|commute|auto|park\+|fastag|parking).*",
                r"(?i).*(irctc|rail|train|metro|flight|air|indigo|vistara|cathay|emirates|qatar|lufthansa|british\s?airways|air\s?india|spicejet|yatra|makemytrip|goibibo|easemytrip|booking\.com).*"
            ],
            "target_category": "Travel",
            "target_tags": ["travel"]
        },
        {
            "name": "Food & Dining",
            "keywords": [
                r"(?i).*(zomato|swiggy|blinkit|freshmenu|eats|food).*",
                r"(?i).*(pizza|burger|coffee|cafe|restaurant|bistro|dining|biryani|kitchen|dhaba|bakers|bakery|sweets|snacks|tea|chai|barista|starbucks).*"
            ],
            "target_category": "Food & Dining",
            "target_tags": ["food", "dining"]
        },
        {
            "name": "Utilities & Bills",
            "keywords": [
                r"(?i).*(electri|power|bij(i)?li|vitaran|discom|bescom|tata\s?sky|dth|broadband|fibernet|wifi|internet).*",
                r"(?i).*(airtel|jio|vodafone|vi\s?postpaid|bsnl|mtnl|billdesk|recharge|mobile).*",
                r"(?i).*(gas|water|municipality|corporation|tax).*"
            ],
            "target_category": "Utilities",
            "target_tags": ["bills", "utility"]
        },
        {
            "name": "Shopping & Retail",
            "keywords": [
                r"(?i).*(amazon|flipkart|myntra|ajio|meesho|nykaa|tatacliq|reliancedigital|croma).*",
                r"(?i).*(retail|store|mart|market|bazaar|supermarket|grocery|grofers|bigbasket|dmart|spencers).*",
                r"(?i).*(fashion|clothing|apparels|trends|pantaloons|lifestyle|shoppers\s?stop|westside|decathlon|uniqlo|zara|h&m).*"
            ],
            "target_category": "Shopping",
            "target_tags": ["shopping"]
        },
        {
            "name": "Credit Card Bill",
            "keywords": [
                r"(?i).*(credit\s?card\s?payment|cred\s|autopay|billdesk|cms|payment\s?received|card\s?repayment).*"
            ],
            "target_category": "Credit Card Bill",
            "target_tags": ["cc_payment", "bill"]
        },
        {
            "name": "Entertainment",
            "keywords": [
                r"(?i).*(netflix|spotify|prime|hotstar|disney|sonyliv|zee5|youtube|subscription|apple\s?music|gaana|jiosaavn).*",
                r"(?i).*(cinema|movie|pvr|inox|cinepolis|bookmyshow|entertainment|games|gaming|steam|playstation).*"
            ],
            "target_category": "Entertainment",
            "target_tags": ["entertainment", "subscription"]
        },
        {
            "name": "Salary & Income",
            "keywords": [
                r"(?i).*(salary|credit\s?interest|dividend|refund|cashback|bonus|stipend).*"
            ],
            "target_category": "Income",
            "target_tags": ["income"]
        },
        {
            "name": "Investment",
            "keywords": [
                r"(?i).*(zerodha|groww|upstox|kite|mutual\s?fund|sip|lic|insurance|premium|policy|stocks|share).*"
            ],
            "target_category": "Investment",
            "target_tags": ["investment"]
        }
    ]
    
    print("Seeding MASTER REGEX Rules...")
    
    # Optional: Clear old rules to avoid conflicts if needed, or just append.
    # For now, we append/update.
    
    for r in rules:
        # Check if rule with same name exists
        existing = db.query(CategoryRule).filter(CategoryRule.name == r["name"]).first()
        if existing:
            print(f"Updating Rule: {r['name']}")
            existing.keywords = r["keywords"] # Update keywords to regex patterns
            existing.target_category = r["target_category"]
            existing.target_tags = r["target_tags"]
        else:
            print(f"Creating Rule: {r['name']}")
            rule = CategoryRule(
                name=r["name"],
                keywords=r["keywords"],
                target_category=r["target_category"],
                target_tags=r["target_tags"]
            )
            db.add(rule)
            
    db.commit()
    db.close()
    print("Regex Seeding Complete! 🚀")

if __name__ == "__main__":
    seed_regex_rules()
