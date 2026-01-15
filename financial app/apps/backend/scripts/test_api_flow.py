import requests
import os
import sys

BASE_URL = "http://localhost:8000/api/v1"

def test_flow():
    print("🚀 Starting API E2E Test...\n")

    # 1. Find a valid PDF (SBI)
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    sbi_file = os.path.join(base_dir, "SBI AURAM/SBI Card Statement_0017_25-10-2025.pdf")
    
    if not os.path.exists(sbi_file):
        print(f"❌ Test file not found: {sbi_file}")
        return

    print(f"📄 Using Real File: {os.path.basename(sbi_file)}")

    # 2. Upload to /parser
    url_parser = f"{BASE_URL}/parser/"
    print(f"📤 Uploading to {url_parser}...")
    
    try:
        with open(sbi_file, 'rb') as f:
            files = {'file': (os.path.basename(sbi_file), f, 'application/pdf')}
            response = requests.post(url_parser, files=files)
            
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Parser Success! Parsed {len(data)} transactions.")
            # Verify structure
            if data and 'merchant_normalized' in data[0]:
                 print(f"   Sample: {data[0]['description']} -> {data[0]['merchant_normalized']} ({data[0]['amount']})")
        else:
            print(f"❌ Parser Failed: {response.status_code} - {response.text}")
            return

    except Exception as e:
        print(f"❌ Exception during upload: {e}")
        return

    print("\n-------------------------------------------------\n")

    # 3. Fetch from /transactions
    url_txns = f"{BASE_URL}/transactions/"
    print(f"📥 Fetching from {url_txns}...")
    
    try:
        response = requests.get(url_txns)
        if response.status_code == 200:
            txns = response.json()
            print(f"✅ Fetch Success! Found {len(txns)} total transactions in store.")
            
            # Check if our SBI transactions are there
            sbi_txns = [t for t in txns if t.get('metadata', {}).get('bank') == 'SBI']
            print(f"   Confirmed {len(sbi_txns)} SBI transactions present.")
        else:
            print(f"❌ Fetch Failed: {response.status_code} - {response.text}")
            
    except Exception as e:
        print(f"❌ Exception during fetch: {e}")

if __name__ == "__main__":
    test_flow()
