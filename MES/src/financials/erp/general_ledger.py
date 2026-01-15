from typing import List, Dict, Any
import uuid
from datetime import datetime

class GeneralLedger:
    """
    Core Double-Entry Bookkeeping System.
    """
    def __init__(self):
        # In-memory mock of the Ledger database tables
        self.accounts = {
            "1200": {"id": "acc-ar", "name": "Accounts Receivable", "balance": 0.0},
            "4000": {"id": "acc-rev", "name": "Sales Revenue", "balance": 0.0},
            "5000": {"id": "acc-cogs", "name": "COGS", "balance": 0.0}
        }
        self.journal_entries = []

    def post_journal_entry(self, description: str, lines: List[Dict[str, Any]]) -> str:
        """
        Validates (Debits == Credits) and commits a transaction.
        lines structure: [{"account_code": "1200", "debit": 100.0, "credit": 0.0}, ...]
        """
        # 1. Validate Balance
        total_debit = sum(l.get("debit", 0) for l in lines)
        total_credit = sum(l.get("credit", 0) for l in lines)
        
        if abs(total_debit - total_credit) > 0.01:
            raise ValueError(f"Journal Entry Unbalanced! Dr: {total_debit}, Cr: {total_credit}")

        # 2. Record Entry
        entry_id = str(uuid.uuid4())
        entry_record = {
            "id": entry_id,
            "date": datetime.now().isoformat(),
            "description": description,
            "lines": lines
        }
        self.journal_entries.append(entry_record)
        
        # 3. Update Account Balances (Simplified)
        for line in lines:
            code = line["account_code"]
            if code in self.accounts:
                # Naive balance update (Asset: Dr increases, Liability/Equity: Cr increases)
                # For this MVP, we just sum net change.
                net_change = line.get("debit", 0) - line.get("credit", 0)
                self.accounts[code]["balance"] += net_change
                
        print(f"[GL] Posted Entry {entry_id}: {description} (Total: {total_debit})")
        return entry_id

    def get_trial_balance(self) -> Dict[str, float]:
        return {acc["name"]: acc["balance"] for acc in self.accounts.values()}
