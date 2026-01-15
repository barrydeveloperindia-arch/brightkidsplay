from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.core.database import get_sync_db
from app.models import Budget, Transaction
from pydantic import BaseModel
from typing import List, Optional

router = APIRouter()

class BudgetSetRequest(BaseModel):
    category: str
    month: str # YYYY-MM
    limit: float

class BudgetProgress(BaseModel):
    category: str
    limit: float
    spend: float
    percentage: float

@router.post("/set")
def set_budget(req: BudgetSetRequest, db: Session = Depends(get_sync_db)):
    """
    Set or update a budget for a category/month.
    """
    existing = db.query(Budget).filter(
        Budget.category == req.category, 
        Budget.month == req.month
    ).first()
    
    if existing:
        existing.limit_amount = req.limit
    else:
        new_budget = Budget(
            category=req.category,
            month=req.month,
            limit_amount=req.limit
        )
        db.add(new_budget)
    
    db.commit()
    return {"status": "Budget set", "category": req.category, "limit": req.limit}

@router.get("/progress", response_model=List[BudgetProgress])
def get_budget_progress(month: str, db: Session = Depends(get_sync_db)):
    """
    Get progress for all categories with a budget for the given month.
    """
    budgets = db.query(Budget).filter(Budget.month == month).all()
    results = []
    
    for b in budgets:
        # Calculate spend for this category in this month
        # Note: This checks strictly transaction_date matching month string if we do string check?
        # Better: use date range.
        
        # Parse month YYYY-MM
        year, m = map(int, month.split('-'))
        
        total_spend = db.query(func.sum(Transaction.amount)).filter(
            Transaction.category == b.category,
            func.extract('year', Transaction.transaction_date) == year,
            func.extract('month', Transaction.transaction_date) == m,
            Transaction.type == 'DEBIT' # Only count spends?
        ).scalar() or 0.0
        
        total_spend = abs(total_spend) # Ensure positive
        
        pct = (total_spend / b.limit_amount * 100) if b.limit_amount > 0 else 0
        
        results.append({
            "category": b.category,
            "limit": b.limit_amount,
            "spend": total_spend,
            "percentage": round(pct, 1)
        })
        
    return results
