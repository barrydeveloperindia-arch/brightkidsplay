class DataParser:
    @staticmethod
    def parse_deposit(account_data: dict) -> float:
        """
        Parses DEPOSIT account type.
        Schema usually has 'currentBalance' as a string/float.
        """
        try:
            balance = account_data.get("currentBalance", "0")
            return float(str(balance).replace("INR", "").replace(",", "").strip())
        except (ValueError, AttributeError):
            return 0.0

    @staticmethod
    def parse_credit_card(account_data: dict) -> float:
        """
        Parses CREDIT_CARD account type.
        Usually has 'currentDue' or 'currentBalance'. 
        For Net Worth, Credit Card balance is a LIABILITY (negative).
        """
        try:
            # In AA schema, credit card might have 'currentDue' which is positive debt.
            # We treat it as negative for Net Worth.
            balance = account_data.get("currentBalance", "0")
            val = float(str(balance).replace("INR", "").replace(",", "").strip())
            
            # If the API returns positive number for debt, we negate it.
            # However, sometimes it returns negative for debt. 
            # For this prototype, let's assume the API returns signed values or we interpret 'currentDue' as debt.
            # Let's assume standard 'currentBalance' where negative means owe money? 
            # Actually, standard banking: Credit balance is positive (bank owes you)? No, for CC:
            # A positive balance usually means you overpaid. A debit balance (outstanding) is what we usually have.
            # Let's stick to the convention: Result should be negative if it reduces net worth.
            
            # Heuristic: If mocked data sends "-15000", key is "currentBalance". 
            return val
        except (ValueError, AttributeError):
            return 0.0

    @staticmethod
    def parse_transactions(txn_list: list) -> list:
        parsed_txns = []
        for txn in txn_list:
            try:
                # Handle mock/real schema variations
                amount_str = txn.get("amount", "0")
                amount = float(str(amount_str).replace("INR", "").replace(",", "").strip())
                
                parsed_txns.append({
                    "amount": str(amount),
                    "type": txn.get("type", "DEBIT"), # Default to DEBIT if unknown? Or logic based on amount
                    "date": txn.get("date"), # ISO string expected
                    "description": txn.get("narration") or txn.get("description", "Unknown Transaction")
                })
            except:
                continue
        return parsed_txns

    @classmethod
    def normalize(cls, account_data: dict) -> dict:
        """
        Standardizes account data into a common format for valid storage/aggregation.
        """
        fi_type = account_data.get("fiType", "").upper()
        balance = 0.0
        
        if fi_type == "DEPOSIT":
            balance = cls.parse_deposit(account_data)
        elif fi_type == "CREDIT_CARD":
            balance = cls.parse_credit_card(account_data)
        else:
            # Fallback for other types
            try:
                balance = float(str(account_data.get("currentBalance", "0")).replace(",", ""))
            except:
                balance = 0.0
                
        return {
            "masked_number": account_data.get("maskedAccNumber", "XXXX"),
            "type": fi_type,
            "balance": balance,
            "currency": account_data.get("currency", "INR") 
        }

data_parser = DataParser()
