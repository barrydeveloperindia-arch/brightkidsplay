from src.financials.invoicing.generator import InvoiceGenerator

def test_module_c():
    print("=== Testing Module C: Automated Billing ===")
    
    generator = InvoiceGenerator()
    
    # Mock Completed Job Data
    completed_job = {
        "order_id": "ORD-1002",
        "customer_id": "CUST-55",
        "machine_id": "CNC-HighPerf-05", # $250/hr
        "material": "Inconel",             # $800/unit
        "runtime_minutes": 120,            # 2 hours => $500
        "material_usage": 0.5              # 0.5 units => $400
    }
    # Expected approx: $500 + $400 = $900 + 15% overhead ($135) = $1035
    
    print("\n--- Generating Invoice for Completed Job ---")
    print(f"Job Details: Machine={completed_job['machine_id']}, Runtime={completed_job['runtime_minutes']}min")
    
    invoice = generator.generate_invoice_for_job(completed_job)
    
    print(f"\n[Result] Invoice Generated:")
    print(f"ID: {invoice['invoice_number']}")
    print(f"Total: ${invoice['total']}")
    print(f"Status: {invoice['status']}")
    print(f"ERP ref: {invoice['erp_reference']}")
    
    print("\n=== Module C Test Complete ===")

if __name__ == "__main__":
    test_module_c()
