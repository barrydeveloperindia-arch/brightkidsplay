from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from ..services.setu_client import setu_client
from ..models import get_db, FinancialAccount, Consent, Transaction

router = APIRouter(prefix="/data", tags=["data"])

@router.get("/summary")
async def get_summary(db: Session = Depends(get_db)):
    # Calculate Net Worth from DB records
    accounts = db.query(FinancialAccount).all()
    
    total_net_worth = 0.0
    account_list = []
    
    for acc in accounts:
        try:
            # Clean balance string to float
            balance_str = acc.current_balance
            # Remove currency symbols if present (simple check)
            balance = float(balance_str.replace("INR", "").replace(",", "").strip())
            total_net_worth += balance
            account_list.append({
                "masked_number": acc.masked_account_number,
                "type": acc.account_type,
                "balance": balance,
                "currency": "INR" # Assuming INR for now
            })
        except ValueError:
            continue
            
    return {
        "net_worth": total_net_worth,
        "currency": "INR",
        "account_count": len(account_list),
        "accounts_breakdown": account_list
    }

from ..services.data_parser import data_parser

from fastapi import APIRouter, Depends, HTTPException, Header

@router.get("/fetch/{consent_id}")
async def fetch_financial_data(consent_id: str, db: Session = Depends(get_db), x_mode: str = Header("LIVE", alias="x-mode")):
    # Verify consent exists in DB (optional strictness)
    consent = db.query(Consent).filter(Consent.consent_handle == consent_id).first()
    
    # Fetch fresh data
    data = await setu_client.fetch_data(consent_id, mode=x_mode)
    
    # Persist to DB
    if "accounts" in data:
        # For simplicity in this prototype, we'll clear old accounts for this consent and re-add
        if consent:
            db.query(FinancialAccount).filter(FinancialAccount.consent_id == consent.id).delete()
            db.commit()
            
            for acc in data["accounts"]:
                # Normalize using parser
                parsed_acc = data_parser.normalize(acc)
                
                db_account = FinancialAccount(
                    consent_id=consent.id,
                    account_type=parsed_acc["type"],
                    bank_name=acc.get("bank", "Mock Bank"), 
                    masked_account_number=parsed_acc["masked_number"],
                    current_balance=str(parsed_acc["balance"]) 
                )
                db.add(db_account)
                db.flush() # Flush to get ID for transactions
                
                # Parse and save transactions
                if "transactions" in acc:
                    parsed_txns = data_parser.parse_transactions(acc["transactions"])
                    for txn in parsed_txns:
                        # Simple date parsing fix for prototype
                        try:
                            txn_date = datetime.strptime(txn["date"], "%Y-%m-%dT%H:%M:%SZ")
                        except:
                            txn_date = datetime.utcnow()
                            
                        db_txn = Transaction(
                            account_id=db_account.id,
                            amount=txn["amount"],
                            txn_type=txn["type"],
                            date=txn_date,
                            description=txn["description"]
                        )
                        db.add(db_txn)
                        
            db.commit()
    
    return data

@router.get("/transactions")
async def get_all_transactions(db: Session = Depends(get_db)):
    """
    Returns a unified list of transactions across all accounts, ordered by date.
    """
    txns = db.query(Transaction).order_by(Transaction.date.desc()).all()
    return txns
