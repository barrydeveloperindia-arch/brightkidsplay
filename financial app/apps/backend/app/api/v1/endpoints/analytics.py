from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func, extract
from app.core.database import get_sync_db
from app.models import Transaction, Account
from typing import List, Dict, Any, Optional
from pydantic import BaseModel

router = APIRouter()

class TrendPoint(BaseModel):
    period: str # YYYY or YYYY-MM
    spend: float
    income: float

class CardAnalytics(BaseModel):
    account_name: str
    total_spend: float
    trend: List[TrendPoint]

@router.get("/card-trends", response_model=List[CardAnalytics])
def get_card_trends(
    period_type: str = "month", # 'year' or 'month'
    year: Optional[int] = None, 
    db: Session = Depends(get_sync_db)
):
    """
    Get spending trends grouped by Account (Card).
    Uses efficient SQL grouping.
    """
    
    # Date format string for PostgreSQL
    date_fmt = 'YYYY-MM' if period_type == 'month' else 'YYYY'
    
    # 1. Query: Group by Account + Period
    # Select account_id, TO_CHAR(date), SUM(amount)
    
    query = db.query(
        Transaction.account_id,
        func.to_char(Transaction.transaction_date, date_fmt).label('period'),
        func.sum(Transaction.amount).label('total_spend')
    ).filter(
        Transaction.type == 'DEBIT' # Debits only
    )

    if year and period_type == 'month':
         query = query.filter(extract('year', Transaction.transaction_date) == year)

    rows = query.group_by(
        Transaction.account_id,
        func.to_char(Transaction.transaction_date, date_fmt)
    ).all()
    
    # 2. Fetch Account Names
    acc_ids = {r[0] for r in rows if r[0]}
    accounts = db.query(Account).filter(Account.account_id.in_(acc_ids)).all()
    acc_map = {a.account_id: f"{a.institution_name} - {a.masked_account_number}" for a in accounts}
    
    # 3. Restructure Data
    # Map: AccountID -> { total: X, trend: [...] }
    grouped = {}
    
    for r in rows:
        acc_id = r[0]
        period = r[1]
        spend = abs(float(r[2] or 0)) # Convert to positive for visualization
        
        # Determine Name
        name = acc_map.get(acc_id, "Unclassified / Cash")
        
        if name not in grouped:
            grouped[name] = {"total_spend": 0, "trend": []}
            
        grouped[name]["total_spend"] += spend
        grouped[name]["trend"].append({"period": period, "spend": spend, "income": 0})
        
    # Convert to List
    results = []
    for name, data in grouped.items():
        # Sort trend by date
        data["trend"].sort(key=lambda x: x["period"])
        
        results.append({
            "account_name": name,
            "total_spend": data["total_spend"],
            "trend": data["trend"]
        })
        
    return results
