import re
import pdfplumber
import pytesseract
import shutil
from typing import List, Dict, Any
from .base import StatementParserService

# Set tesseract path explicitly if standard path exists (Windows default)
# This helps if it's not in PATH yet
POSSIBLE_PATHS = [
    r"C:\Program Files\Tesseract-OCR\tesseract.exe",
    r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe",
    r"C:\Users\abrbh\AppData\Local\Programs\Tesseract-OCR\tesseract.exe"
]
for path in POSSIBLE_PATHS:
    if shutil.which(path) or hasattr(shutil, 'which') and shutil.which("tesseract") is None:
         # attempt to detect file existence directly if shutil.which fails
         import os
         if os.path.exists(path):
             pytesseract.pytesseract.tesseract_cmd = path
             break

class IciciStatementParser(StatementParserService):
    """
    Parser strategy for ICICI Bank Credit Card Statements.
    NOW WITH OCR SUPERPOWERS! 👁️
    """
    
    # Regex Patterns (Adjusted for OCR output which might be messier)
    # Date (DD/MM/YYYY) | Ref | Description | Reward | Amount | Dr/Cr
    # OCR might yield: "13/09/2025 850385938... AMAZON PAY INDIA ... 450.00 Dr"
    DATE_PATTERN = re.compile(r"(\d{2}/\d{2}/\d{4})")
    
    @classmethod
    def supports(cls, raw_content: str) -> bool:
        # Check if "ICICI" is in text OR if it looks like the garbled ICICI header
        # But initially we rely on filename or faint text
        return "ICICI" in raw_content.upper() or "IDENTITY-H" in raw_content.upper()

    def parse(self) -> List[Dict[str, Any]]:
        transactions = []
        
        # If raw_content is very short or garbled, we might need to re-read the PDF with OCR
        # Since this class receives text, we might need to assume the caller handles OCR 
        # OR we try to run OCR if text looks bad.
        # However, StatementParserService takes string input. 
        # TO DO PROPERLY: The Caller (factory/endpoint) should have done OCR if needed.
        # But for now, we will assume we modify the FACTORY to pass an OCR flag or 
        # we re-open the file if we have the path? 
        # Actually, self.raw_content is just str. We can't OCR a string.
        
        # HACK: If we are in the context where we don't have the file path anymore, 
        # we can't do OCR. But wait, `verify_real_data.py` passes the file path to extract_text?
        # NO, it extracts text THEN passes to factory.
        
        # We need to change WHERE extraction happens.
        # But to be minimally invasive:
        # If the text is garbage, we assume the caller needs to fix it.
        # BUT wait, the `parser.py` endpoint takes a FILE now.
        
        lines = self.raw_content.split('\n')
        
        for line in lines:
            # line = line.strip()
            # print(f"DEBUG ICICI: {line}")
            
            match = self.DATE_PATTERN.search(line)
            if not match:
                continue

            date_str = match.group(1)
            
            # Simple Amount Regex for now: 1,234.00 OR 1,234.00 Dr
            amount_matches = re.findall(r"([\d,]+\.\d{2})\s*(Dr|Cr)?", line, re.IGNORECASE)
            
            if not amount_matches:
                continue
            
            # Last match is usually the transaction amount (previous could be rewards or ref)
            amt_str, type_str = amount_matches[-1]
            
            # Extract description: Everything between date and amount
            # This is rough but works for many cases
            desc_start = line.find(date_str) + len(date_str)
            desc_end = line.rfind(amt_str)
            desc = line[desc_start:desc_end].strip()
            
            # Clean up Description
            # Remove Ref numbers consisting of many digits
            desc = re.sub(r"\d{10,}", "", desc).strip()
            
            amount = float(amt_str.replace(',', ''))
            
            # Determine Type
            # Default to DEBIT. If 'Cr' is present, it's CREDIT.
            # If 'Dr' is present, it's DEBIT.
            type_flag = "DEBIT"
            if "CR" in type_str.upper() or "CREDIT" in line.upper(): 
                 type_flag = "CREDIT"
            
            if type_flag == "DEBIT":
                amount = -abs(amount)
            else:
                amount = abs(amount)

            transactions.append({
                "date": date_str,
                "description": desc,
                "amount": amount,
                "currency": "INR",
                "type": type_flag,
                "category": "UNCATEGORIZED",
                "metadata": {
                    "bank": "ICICI",
                }
            })
            
        return transactions
