import re
import datetime
from typing import List, Dict, Any
from .base import StatementParserService

class HsbcStatementParser(StatementParserService):
    """
    Parser strategy for HSBC Credit Card Statements.
    Often scanned/OCR based.
    Format: Description ... Amount
    Dates might be in a separate column (OCR reads them separately), 
    so date association is best-effort (or defaults to statement month).
    """

    # Generic Line: "DESCRIPTION  1,234.00"
    # We look for lines ending in a number with 2 decimal places
    TXN_PATTERN = re.compile(r"(.+?)\s+([\d,]+\.\d{2})[A-Za-z]*$")

    @classmethod
    def supports(cls, raw_content: str) -> bool:
        return "HSBC" in raw_content.upper() and ("CREDIT CARD" in raw_content.upper() or "STATEMENT" in raw_content.upper())

    def parse(self) -> List[Dict[str, Any]]:
        transactions = []
        lines = self.raw_content.split('\n')
        
        # 1. Try to find a reference date from the content (e.g., "16NOV")
        # useful to determine the month/year.
        ref_year = datetime.datetime.now().year
        ref_month = datetime.datetime.now().month
        
        # 2. Iterate lines
        for line in lines:
            line = line.strip()
            # distinct features of HSBC txn lines
            if "OPENING BALANCE" in line or "Payment due date" in line:
                continue
                
            match = self.TXN_PATTERN.search(line)
            if not match:
                continue
                
            desc, amount_str = match.groups()
            desc = desc.strip()
            
            # Filter noise
            if len(desc) < 5 or "TOTAL" in desc.upper() or "PAGE" in desc.upper():
                continue

            try:
                amount = float(amount_str.replace(",", ""))
            except:
                continue

            # Type Detection
            # HSBC: Payments usually have "CR" or "PAYMENT RECEIVED"
            # Here in OCR log: "BBPS PMT" (Bill Payment) -> Debit
            is_credit = False
            if "PAYMENT RECEIVED" in desc.upper() or "CR" in line.upper():
                is_credit = True
            
            # Logic: If it's a payment TO the card, it's credit.
            # "BBPS PMT" usually means paying a bill -> Debit.
            
            if is_credit:
                type_flag = "CREDIT"
                amount = abs(amount)
            else:
                type_flag = "DEBIT"
                amount = -abs(amount)
            
            # Date: Since we prefer row-based and dates are desynced in OCR,
            # we assign a "Unknown" or the 1st of the month.
            # IMPROVEMENT: If we tracked the "16NOV" lines earlier, we could try to guess,
            # but for now, functional reliability > perfect date alignment.
            date_str = f"01/{ref_month:02d}/{ref_year}"
            
            # Clean description
            # Remove trailing garbage from OCR
            desc = re.sub(r"[^a-zA-Z0-9\s\.\-\*]", "", desc)

            transactions.append({
                "date": date_str,
                "description": desc,
                "amount": amount,
                "currency": "INR",
                "type": type_flag,
                "category": "UNCATEGORIZED",
                "metadata": {
                    "bank": "HSBC",
                    "original_desc": line,
                    "note": "Date approximated due to OCR layout"
                }
            })
            
        return transactions
