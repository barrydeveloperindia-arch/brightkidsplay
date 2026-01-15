import os
import requests
import sys

BASE_URL = "http://localhost:8000/api/v1/parser/"
STATEMENTS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))

def upload_all():
    print(f"🚀 Starting Batch Upload from: {STATEMENTS_DIR}\n")
    
    if not os.path.exists(STATEMENTS_DIR):
        print(f"❌ Statements directory not found: {STATEMENTS_DIR}")
        return

    count = 0
    success_count = 0
    
    for root, dirs, files in os.walk(STATEMENTS_DIR):
        # Filter out Axis folders
        if "axis" in root.lower():
            continue
            
        for file in files:
            if file.lower().endswith('.pdf'):
                # Filter out Axis files if any leak through
                if "axis" in file.lower():
                    continue
                
                file_path = os.path.join(root, file)
                print(f"📤 Uploading: {file}...", end=" ")
                
                try:
                    with open(file_path, 'rb') as f:
                        files_payload = {'file': (file, f, 'application/pdf')}
                        response = requests.post(BASE_URL, files=files_payload)
                        
                    if response.status_code == 200:
                        data = response.json()
                        txn_count = len(data)
                        print(f"✅ Success! ({txn_count} txns)")
                        success_count += 1
                    else:
                        print(f"❌ Failed: {response.status_code}")
                        # print(f"   Response: {response.text[:100]}...")
                except Exception as e:
                    print(f"❌ Error: {e}")
                
                count += 1

    print("\n-------------------------------------------------")
    print(f"🎉 Batch Upload Complete.")
    print(f"Total Files Attempted: {count}")
    print(f"Successful Uploads: {success_count}")

if __name__ == "__main__":
    upload_all()
