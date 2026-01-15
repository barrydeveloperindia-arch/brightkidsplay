import sys
import os

# Add the 'app' directory to the python path so imports work
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from app.services.parser.factory import ParserFactory
from app.services.enrichment.normalizer import MerchantNormalizer

def run_verification():
    print("running backend verification...\n")

    # 1. Mock Data
    hdfc_mock = """
    Statement for HDFC Bank Credit Card
    14/01/2026 IND*AMAZON.IN 1,200.00
    15/01/2026 RAZ*SWIGGY 450.00
    NeuCoins Earned: 50
    """

    sbi_mock = """
    SBI Card Statement (Aurum)
    12/01/2026 UBER INDIA 500.00 D
    13/01/2026 PAYMENT RECEIVED 10,000.00 C
    Status: NPA
    Total Dues: 15,000.00
    """

    icici_mock = """
    ICICI Bank Credit Card Statement
    Spends Overview
    10/01/2026 123456 RAZ*ZOMATO 20 600.00 Dr
    11/01/2026 789012 CRED BBPS Payment 0 1,500.00 Dr
    """

    test_cases = [
        ("HDFC", hdfc_mock),
        ("SBI", sbi_mock),
        ("ICICI", icici_mock)
    ]

    for bank_name, content in test_cases:
        print(f"--- Testing {bank_name} ---")
        try:
            # A. Parser Factory
            parser = ParserFactory.get_parser(content)
            print(f"✅ Parser Detected: {parser.__class__.__name__}")
            
            # B. Parse
            transactions = parser.parse()
            print(f"✅ Parsed {len(transactions)} transactions")
            
            # C. Enrichment (Normalization)
            for txn in transactions:
                original_desc = txn['description']
                clean_name = MerchantNormalizer.normalize(original_desc)
                print(f"   - [{txn['date']}] {original_desc} -> {clean_name} | Amount: {txn['amount']} | Meta: {txn.get('metadata')}")
        
        except Exception as e:
            print(f"❌ Error: {e}")
        
        print("\n")

if __name__ == "__main__":
    run_verification()
