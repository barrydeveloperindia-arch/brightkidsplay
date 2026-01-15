import os
import requests
import sys

BASE_URL = "http://localhost:8000/api/v1/parser/"
STATEMENTS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))

def populate_dashboard():
    print(f"🚀 Starting MASS Population from: {STATEMENTS_DIR}\n")
    
    if not os.path.exists(STATEMENTS_DIR):
        print(f"❌ Statements directory not found: {STATEMENTS_DIR}")
        return

    count = 0
    success_count = 0
    
    # Supported Banks: We now exclude only AXIS (Password)
    # ICICI, HDFC, SBI, AMEX, HSBC are GO.
    
    for root, dirs, files in os.walk(STATEMENTS_DIR):
        folder_name = os.path.basename(root).upper()
        
        # Skip Axis for now (Check full path to catch subfolders)
        if "AXIS" in root.upper():
            # print(f"⏭️  Skipping Axis Folder: {root}")
            continue
            
        for file in files:
            if file.lower().endswith('.pdf'):
                # Secondary Axis check
                if "AXIS" in file.upper():
                    continue
                
                file_path = os.path.join(root, file)
                print(f"📤 Uploading: {folder_name}/{file}...", end=" ", flush=True)
                
                try:
                    with open(file_path, 'rb') as f:
                        # 60 second timeout because OCR might take time
                        files_payload = {'file': (file, f, 'application/pdf')}
                        response = requests.post(BASE_URL, files=files_payload, timeout=60)
                        
                    if response.status_code == 200:
                        data = response.json()
                        txn_count = len(data)
                        print(f"✅ Success! ({txn_count} txns)")
                        success_count += 1
                        
                        # Print Sample
                        if txn_count > 0:
                            print(f"       Sample: {data[0]['merchant_normalized']} | {data[0]['amount']}")
                            
                    else:
                        print(f"❌ Failed: {response.status_code}")
                        # print(f"Response: {response.text[:100]}")
                        
                except Exception as e:
                    print(f"❌ Error: {e}")
                
                count += 1

    print("\n-------------------------------------------------")
    print(f"🎉 Dashboard Population Complete.")
    print(f"Total Files Processed: {count}")
    print(f"Successful Uploads: {success_count}")
    print("Go to http://localhost:3000 to view your data!")

if __name__ == "__main__":
    # Force UTF-8 for Windows console if possible, or just log to file
    with open("dashboard_population.log", "w", encoding="utf-8") as f:
        sys.stdout = f
        populate_dashboard()
        sys.stdout = sys.__stdout__
    print("Population run complete. Check dashboard_population.log")
