import re
from typing import List, Dict, Any
from .base import StatementParserService

class HdfcStatementParser(StatementParserService):
    """
    Parser strategy for HDFC Credit Card Statements.
    """
    
    # Regex to capture transaction line items
    # Date | Description | Amount | Ref Number (Simplified)
    # Example: 14/01/2026        # Regex for HDFC: "13/09/2025| 08:28 Description ... Amount" or similar
        # We need to be flexible with the separators and time
        # Group 1: Date (DD/MM/YYYY)
        # Group 2: Description (greedy)
        # Group 3: Amount (with commas)
        # Group 4: Cr/Dr indicator (optional, usually inferred from section but sometimes present)
        
        # Look for Date first
    date_pattern = re.compile(r"(\d{2}/\d{2}/\d{4})")
    NEU_COIN_PATTERN = re.compile(r"NeuCoins.*?(\d+)")

    @classmethod
    def supports(cls, raw_content: str) -> bool:
        # HDFC identifiers
        return "HDFC Bank" in raw_content or "HDFC" in raw_content

    def parse(self) -> List[Dict[str, Any]]:
        transactions = []
        lines = self.raw_content.split('\n')
        
        current_section = "DOMESTIC" # Default

        for line in lines:
            line = line.strip()
            
            # Detect sections (Domestic vs International)
            if "Domestic Transactions" in line:
                current_section = "DOMESTIC"
                continue
            elif "International Transaction" in line:
                current_section = "INTERNATIONAL"
                continue

            # 3. Transaction Parsing
            match = self.date_pattern.search(line)
            if not match:
                 continue
            
            date_str = match.group(1)
            
            # Check for BPPY exclusion
            if "BPPY" in line or "CC PAYMENT" in line:
               continue
            
            # Split line by date to get the rest
            parts = line.split(date_str)
            if len(parts) < 2: 
                continue
                
            rest = parts[1].strip()
            # Remove pipe or time if present
            rest = re.sub(r"^[|]\s*\d{2}:\d{2}\s*", "", rest)
            rest = re.sub(r"^[|]\s*", "", rest)

            # Now try to extract amount from the rest
            amount_match = re.search(r"([A-Z]*)\s*([\d,]+\.\d{2})\s*([A-Z]*)", rest, re.IGNORECASE)
            
            if not amount_match:
                continue
            
            prefix = amount_match.group(1) or ""
            amount_str = amount_match.group(2)
            suffix = amount_match.group(3) or ""
            
            # Check for Credit indicators
            is_credit = "C" in prefix.upper() or "CR" in prefix.upper() or \
                        "C" in suffix.upper() or "CR" in suffix.upper()
            
            # Description is everything before an amount match
            desc = rest[:amount_match.start()].strip()
            
            # Clean description of leading pipes/time again just in case
            desc = re.sub(r"^[|]\s*\d{2}:\d{2}\s*", "", desc)
            desc = re.sub(r"^[|]\s*", "", desc).strip()
            
            amount = float(amount_str.replace(',', ''))
            type_flag = "CREDIT" if is_credit else "DEBIT"
            
            if type_flag == "DEBIT":
                amount = -abs(amount)
            else:
                amount = abs(amount)

            # 4. Rewards Extraction (NeuCoins)
            rewards_earned = 0
            neu_match = self.NEU_COIN_PATTERN.search(line)
            if neu_match:
                rewards_earned = int(neu_match.group(1))

            transactions.append({
                "date": date_str,
                "description": desc.strip(),
                "amount": amount,
                "currency": "INR",
                "type": type_flag,
                "category": "UNCATEGORIZED", # Will be enriched later
                "metadata": {
                    "bank": "HDFC",
                    "section": current_section,
                    "neu_coins": rewards_earned
                }
            })

        return transactions
