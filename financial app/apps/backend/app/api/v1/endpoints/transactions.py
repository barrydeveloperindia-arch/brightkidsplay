from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.core.database import get_sync_db
from app.models import Transaction, Account
from typing import List, Optional, Any
from pydantic import BaseModel
import uuid

router = APIRouter()

@router.get("/", response_model=List[dict])
def read_transactions(
    skip: int = 0, 
    limit: int = 50, 
    search: Optional[str] = None,
    category: Optional[str] = None,
    account_id: Optional[str] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    type: Optional[str] = None,
    db: Session = Depends(get_sync_db)
):
    """
    Fetch transactions with filtering and search.
    """
    query = db.query(Transaction)
    
    # Filters
    if search:
        search_term = f"%{search}%"
        query = query.filter(Transaction.description.ilike(search_term))
        
    if category and category != "All":
        query = query.filter(Transaction.category == category)
        
    if account_id and account_id != "All":
        query = query.filter(Transaction.account_id == uuid.UUID(account_id))
        
    if type and type != "All":
        query = query.filter(Transaction.type == type)
        
    if start_date:
        query = query.filter(Transaction.transaction_date >= start_date)
        
    if end_date:
        query = query.filter(Transaction.transaction_date <= end_date)
        
    # Order by Date DESC
    txns = query.order_by(Transaction.transaction_date.desc()).offset(skip).limit(limit).all()
    
    # Account Map (Optimization: Fetch accounts to show names)
    # Ideally should use a join, but for now map in memory or just return ID
    # Frontend can lookup if it has account list, or we enrich here.
    # Let's enrich here if account_id is present.
    
    # Helper to fetch account names if needed? 
    # For now, let's just return the raw data + enriched account name if possible.
    # To avoid N+1, let's join Account or lazy load.
    # Simple approach: Return account_id, frontend has the map from /accounts endpoint.
    
    return [
        {
            "id": str(t.transaction_id),
            "date": t.transaction_date,
            "description": t.description,
            "amount": t.amount,
            "type": t.type,
            "category": t.category,
            "tags": t.tags or [], 
            "account_id": str(t.account_id) if t.account_id else None
        } 
        for t in txns
    ]

class TransactionUpdate(BaseModel):
    category: Optional[str] = None
    tags: Optional[List[str]] = None
    narration: Optional[str] = None

@router.patch("/{transaction_id}")
def update_transaction(
    transaction_id: str, 
    txn_update: TransactionUpdate, 
    db: Session = Depends(get_sync_db)
):
    """
    Update a transaction's changeable fields (tags, category, narration).
    """
    try:
        # Check valid UUID
        txn_uuid = uuid.UUID(transaction_id)
        
        # Fetch
        txn = db.query(Transaction).filter(Transaction.transaction_id == txn_uuid).first()
        if not txn:
            raise HTTPException(status_code=404, detail="Transaction not found")
        
        # Update
        if txn_update.category is not None:
            txn.category = txn_update.category
            
        if txn_update.tags is not None:
            # Ensure it's treated as a list even if DB is picky
            txn.tags = txn_update.tags
            
        if txn_update.narration is not None:
            txn.narration = txn_update.narration
            
        db.commit()
        db.refresh(txn)
        
        return {
            "id": str(txn.transaction_id),
            "category": txn.category,
            "tags": txn.tags,
            "narration": txn.narration,
            "status": "updated"
        }
        
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid Transaction ID format")
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
