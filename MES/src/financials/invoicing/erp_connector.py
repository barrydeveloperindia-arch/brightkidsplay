from typing import Dict, Any

class ERPConnector:
    """
    Abstracts communication with external Accounting Systems (SAP, QuickBooks).
    """
    def __init__(self, platform: str = "QuickBooks"):
        self.platform = platform
        
    def sync_invoice(self, invoice_data: Dict[str, Any]) -> str:
        """
        Pushes invoice to ERP and returns external reference ID.
        """
        print(f"[ERP] Connecting to {self.platform} API...")
        # Mock API call
        print(f"[ERP] Creating Invoice for Order {invoice_data.get('order_id')} Amount: {invoice_data.get('total')}")
        
        # Return mock External ID
        return f"QB-{invoice_data.get('invoice_number', '1000')}"
