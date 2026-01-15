from fastapi import APIRouter, HTTPException, UploadFile, File, Depends
from typing import List, Dict, Any
import datetime
import os
import io
import pdfplumber
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.services.parser.factory import ParserFactory
from app.services.enrichment.normalizer import MerchantNormalizer
from app.services.parser.exceptions import UnsupportedStatementError
from app.core.database import get_db
from app.models import User, Account, Transaction

router = APIRouter()

@router.post("/", response_model=List[Dict[str, Any]])
async def parse_statement(
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db)
):
    """
    Parses uploaded PDF statement and saves to PostgreSQL.
    """
    try:
        # 0. Extract Text
        content = await file.read()
        raw_text = ""
        
        try:
            with pdfplumber.open(io.BytesIO(content)) as pdf:
                for page in pdf.pages:
                    text = page.extract_text()
                    if text:
                        raw_text += text + "\n"
        except Exception as e:
             raise HTTPException(status_code=400, detail=f"Invalid PDF: {str(e)}")

        # OCR FALLBACK
        needs_ocr = False
        if not raw_text.strip():
            needs_ocr = True
        elif raw_text.count("(cid:") > 10: 
            needs_ocr = True
            raw_text = "" 
            
        if needs_ocr:
            try:
                import pytesseract
                from PIL import Image
                import shutil
                
                t_path = shutil.which("tesseract")
                if not t_path:
                     # Common Windows paths
                     paths = [
                        r"C:\Program Files\Tesseract-OCR\tesseract.exe",
                        r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe",
                        os.path.expandvars(r"%LOCALAPPDATA%\Tesseract-OCR\tesseract.exe")
                     ]
                     for p in paths:
                         if os.path.exists(p):
                             pytesseract.pytesseract.tesseract_cmd = p
                             break
                
                with pdfplumber.open(io.BytesIO(content)) as pdf:
                    for i, page in enumerate(pdf.pages):
                        im = page.to_image(resolution=300).original
                        text = pytesseract.image_to_string(im)
                        raw_text += text + "\n"
                        
            except ImportError:
                 raise HTTPException(status_code=500, detail="OCR dependencies missing.")
            except Exception as e:
                 raise HTTPException(status_code=500, detail=f"OCR Processing Failed: {str(e)}")

        if not raw_text.strip():
             raise HTTPException(status_code=400, detail="Empty PDF or Scanned Image (OCR Failed)")

        # A. Get Parser Strategy
        parser = ParserFactory.get_parser(raw_text)
        
        # B. Parse Transactions
        raw_transactions = parser.parse()
        
        # C. Database Integration
        
        # 1. Get or Create Default User (MVP)
        result = await db.execute(select(User).filter(User.email == "admin@example.com"))
        user = result.scalars().first()
        if not user:
            user = User(
                email="admin@example.com",
                phone_number="9999999999",
                password_hash="hashed_secret",
                full_name="Admin User"
            )
            db.add(user)
            await db.commit()
            await db.refresh(user)

        # 2. Get or Create Account
        if raw_transactions:
            first_txn = raw_transactions[0]
            bank_name = first_txn.get("metadata", {}).get("bank", "UNKNOWN_BANK")
        else:
            bank_name = "UNKNOWN_BANK"

        # Simple account dedup by bank name for MVP. 
        # Ideally we'd parse account number from statement.
        result = await db.execute(select(Account).filter(
            Account.user_id == user.user_id,
            Account.institution_name == bank_name
        ))
        account = result.scalars().first()
        if not account:
            account = Account(
                user_id=user.user_id,
                institution_id=bank_name.upper(),
                institution_name=bank_name,
                account_type="CREDIT_CARD", 
                masked_account_number=f"XXXX-{hash(file.filename) % 10000}", 
                current_balance=0.0
            )
            db.add(account)
            await db.commit()
            await db.refresh(account)

        # 3. Save Transactions
        enriched_transactions = []
        for txn_data in raw_transactions:
            # Normalize
            normalized_merchant = MerchantNormalizer.normalize(txn_data['description'])
            
            # Create Model
            # Ensure Amount is float
            amt = float(txn_data['amount'])
            
            # Create object
            db_txn = Transaction(
                account_id=account.account_id,
                transaction_date=datetime.datetime.strptime(txn_data['date'], "%d/%m/%Y"), 
                amount=amt,
                currency=txn_data.get('currency', 'INR'),
                description=txn_data['description'],
                type=txn_data.get('type', 'DEBIT'),
                category=txn_data.get('category', 'UNCATEGORIZED'),
                status="POSTED",
                narration=f"File: {file.filename} | Orig: {txn_data.get('metadata', {}).get('original_desc', '')}"
            )
            db.add(db_txn)
            
            # Output format
            txn_data['id'] = "PENDING_COMMIT" # Or use UUID if we gen it manually
            txn_data['merchant_normalized'] = normalized_merchant
            enriched_transactions.append(txn_data)
        
        await db.commit()
            
        return enriched_transactions

    except UnsupportedStatementError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        import traceback
        traceback.print_exc() 
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")
