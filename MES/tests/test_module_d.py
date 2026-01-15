from src.financials.invoicing.generator import InvoiceGenerator

def test_internal_erp():
    print("=== Testing Internal ERP Module (Double-Entry Logic) ===")
    
    generator = InvoiceGenerator()
    
    # 1. Print Initial Trial Balance (Mock)
    print("\n[GL] Initial Trial Balance:")
    print(generator.gl.get_trial_balance())
    
    # 2. Simulate Job Completion -> Invoice -> GL Post
    completed_job = {
        "job_id": "JOB-999",
        "order_id": "ORD-ERP-TEST",
        "customer_id": "INTERNAL-CORP",
        "machine_id": "CNC-001",
        "material": "Steel",
        "runtime_minutes": 60, # $150/hr = $150
        "material_usage": 2.0  # 2 * $50 = $100
    }
    # Expected: $250 + overhead
    
    invoice = generator.generate_invoice_for_job(completed_job)
    
    print(f"\n[Result] Invoice {invoice['invoice_number']} Status: {invoice['status']}")
    
    # 3. Check Trial Balance Update
    print("\n[GL] Updated Trial Balance:")
    tb = generator.gl.get_trial_balance()
    print(tb)
    
    # Verify Double Entry Logic
    ar_bal = tb["Accounts Receivable"]
    rev_bal = tb["Sales Revenue"]
    
    if ar_bal == invoice['total'] and rev_bal == invoice['total']:
        print("\n✅ SUCCESS: Double Entry Validated (AR Debited, Revenue Credited)")
    else:
        print("\n❌ FAILURE: Balances do not match invoice total")

if __name__ == "__main__":
    test_internal_erp()
