import re
import datetime
from typing import List, Dict, Any
from .base import StatementParserService

class AmexStatementParser(StatementParserService):
    """
    Parser strategy for American Express Statements.
    Format: "Month DD  Description  Amount"
    """
    
    # Header Date: "Prepared for ... 05/10/2025"
    HEADER_DATE_PATTERN = re.compile(r"(\d{2}/\d{2}/\d{4})")
    
    # Transaction Line: "September 13 DESCRIPTION... 94,555.00"
    # Note: Description can conform to anything, so capture mostly alphanumeric
    TXN_PATTERN = re.compile(r"^\s*([A-Z][a-z]+ \d{2})\s+(.+?)\s+([\d,]+\.\d{2})")
    
    # Payment Received often indicates Credit
    PAYMENT_KEYWORDS = ["PAYMENT RECEIVED", "CREDIT"]

    @classmethod
    def supports(cls, raw_content: str) -> bool:
        return "AMERICAN EXPRESS" in raw_content.upper() or "AMEX" in raw_content.upper()

    def parse(self) -> List[Dict[str, Any]]:
        transactions = []
        lines = self.raw_content.split('\n')
        
        # 1. Attempt to find Statement Date/Year from header
        statement_year = datetime.datetime.now().year # Default
        for line in lines[:20]: # Check first 20 lines
            match = self.HEADER_DATE_PATTERN.search(line)
            if match:
                try:
                    dt = datetime.datetime.strptime(match.group(1), "%d/%m/%Y")
                    statement_year = dt.year
                    break
                except:
                    pass
        
        # 2. Parse Transactions
        for i, line in enumerate(lines):
            line = line.strip()
            match = self.TXN_PATTERN.search(line)
            
            if not match:
                continue
                
            date_part, desc, amount_str = match.groups()
            
            # Clean Description
            desc = desc.strip()
            # If description ends with "Rs", strip it
            if desc.endswith(" Rs"): 
                desc = desc[:-3]

            # Amount
            try:
                amount = float(amount_str.replace(",", ""))
            except:
                amount = 0.0
            
            # Type Detection
            is_credit = False
            
            # Check explicit Keywords in description
            if any(k in desc.upper() for k in self.PAYMENT_KEYWORDS):
                is_credit = True
            
            # Check Next Line for "Card Number ... CR"
            if i + 1 < len(lines):
                next_line = lines[i+1].strip()
                if next_line.endswith(" CR"):
                    is_credit = True
            
            if is_credit:
                type_flag = "CREDIT"
                amount = abs(amount) # Positive
            else:
                type_flag = "DEBIT"
                amount = -abs(amount) # Negative

            # Parse Date
            try:
                txn_date = datetime.datetime.strptime(f"{date_part} {statement_year}", "%B %d %Y")
                date_str = txn_date.strftime("%d/%m/%Y")
            except:
                date_str = date_part # Fallback

            transactions.append({
                "date": date_str,
                "description": desc,
                "amount": amount,
                "currency": "INR",
                "type": type_flag,
                "category": "UNCATEGORIZED",
                "metadata": {
                    "bank": "AMEX",
                    "original_desc": desc
                }
            })
            
        return transactions
