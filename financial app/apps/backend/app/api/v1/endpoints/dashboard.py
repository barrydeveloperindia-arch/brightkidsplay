from fastapi import APIRouter, Depends, HTTPException
from typing import List, Dict, Any
from sqlalchemy.orm import Session
from sqlalchemy import text
import traceback

from app.core.database import get_sync_db

router = APIRouter()

@router.get("/stats", response_model=Dict[str, Any])
def get_dashboard_stats(db: Session = Depends(get_sync_db)):
    """
    Fetch aggregated stats for the dashboard using Sync SQL for stability.
    """
    try:
        # 1. Total Spend (DEBIT)
        # Note: Amount is stored as positive float usually, but strict check needed?
        # In parser: amount = float(txn_data['amount']).
        # Type is 'DEBIT' or 'CREDIT'.
        # We process DEBIT as Spend (Absolute).
        query_spend = text("SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE type = 'DEBIT'")
        res_spend = db.execute(query_spend)
        total_spend = res_spend.scalar()
        
        # 2. Total Income (CREDIT)
        query_income = text("SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE type = 'CREDIT'")
        res_income = db.execute(query_income)
        total_income = res_income.scalar()
        
        # 3. Category Breakup (Top 5)
        # Postgres specific
        query_cat = text("""
            SELECT category, SUM(amount) as val 
            FROM transactions 
            WHERE type = 'DEBIT' 
            GROUP BY category 
            ORDER BY val DESC
        """)
        res_cat = db.execute(query_cat)
        categories = [{"name": row[0] or "Uncategorized", "value": float(row[1])} for row in res_cat.all()]
        
        # 4. Monthly Trend (Last 6 Months)
        # Postgres: to_char or date_trunc
        query_trend = text("""
            SELECT to_char(transaction_date, 'YYYY-MM') as mth, SUM(amount) as val
            FROM transactions
            WHERE type = 'DEBIT'
            GROUP BY mth
            ORDER BY mth ASC
            LIMIT 12
        """)
        res_trend = db.execute(query_trend)
        trend = [{"month": row[0], "spend": float(row[1])} for row in res_trend.all()]

        return {
            "total_spend": float(total_spend),
            "total_income": float(total_income),
            "net_balance": float(total_income) - float(total_spend), 
            "category_breakup": categories,
            "monthly_trend": trend
        }
        
    except Exception as e:
        print("ERROR IN DASHBOARD API:")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
