import uuid
from datetime import datetime
from typing import Dict, Any
from ..costing.engine import CostingEngine
from ..erp.general_ledger import GeneralLedger

class InvoiceGenerator:
    """
    Orchestrates billing triggering.
    """
    def __init__(self):
        self.costing = CostingEngine()
        self.gl = GeneralLedger()
        
    def generate_invoice_for_job(self, job_context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Calculates costs, generates invoice record, and posts to Internal GL.
        """
        # 1. Calculate Costs
        costs = self.costing.calculate_job_cost(
            machine_id=job_context["machine_id"],
            material=job_context["material"],
            runtime_minutes=job_context["runtime_minutes"],
            material_usage=job_context["material_usage"]
        )
        
        # 2. specific Invoice Record
        invoice = {
            "invoice_id": str(uuid.uuid4()),
            "invoice_number": f"INV-{int(datetime.now().timestamp())}",
            "order_id": job_context.get("order_id"),
            "customer_id": job_context.get("customer_id"),
            "total": costs["total_excl_tax"],
            "currency": costs["currency"],
            "status": "DRAFT"
        }
        
        print(f"[Billing] Invoice {invoice['invoice_number']} generated locally. Total: ${invoice['total']}")
        
        # 3. Post to Internal General Ledger (Double Entry)
        # Debit Accounts Receivable (Asset) | Credit Sales Revenue (Income)
        try:
            journal_lines = [
                {"account_code": "1200", "debit": invoice["total"], "credit": 0.0}, # Dr AR
                {"account_code": "4000", "debit": 0.0, "credit": invoice["total"]}  # Cr Sales
            ]
            entry_id = self.gl.post_journal_entry(
                description=f"Invoice {invoice['invoice_number']} for Job {job_context.get('job_id')}",
                lines=journal_lines
            )
            
            invoice["erp_reference"] = entry_id
            invoice["status"] = "POSTED_TO_GL"
            
        except ValueError as e:
            print(f"[Billing] GL Posting Failed: {e}")
            invoice["status"] = "GL_ERROR"
        
        return invoice
