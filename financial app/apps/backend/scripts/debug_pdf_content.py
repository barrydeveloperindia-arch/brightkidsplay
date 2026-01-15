import sys
import os
import pdfplumber
import glob

def extract_start_text(pdf_path, chars=2000):
    text = ""
    try:
        with pdfplumber.open(pdf_path) as pdf:
            # Check first 2 pages
            for page in pdf.pages[:2]:
                text += page.extract_text() + "\n"
    except Exception as e:
        return f"Error: {e}"
    return text[:chars]

def run_debug():
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    
    # Target folders
    targets = {
        "HDFC": "HDFC TATA NEU",
        "SBI": "SBI AURAM",
        "ICICI": "ICICI AMAZONE PAY"
    }
    
    for bank, folder in targets.items():
        print(f"--- Debugging {bank} ---")
        folder_path = os.path.join(base_dir, folder)
        pdfs = glob.glob(os.path.join(folder_path, "*.pdf"))
        
        if pdfs:
            # Pick first file
            target_file = pdfs[0]
            print(f"File: {os.path.basename(target_file)}")
            raw_text = extract_start_text(target_file)
            print("--- RAW TEXT START ---")
            print(raw_text)
            print("--- RAW TEXT END ---")
            print("\n" + "="*50 + "\n")
        else:
            print(f"No PDF found for {bank}")

if __name__ == "__main__":
    with open("pdf_debug_log.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        run_debug()
        sys.stdout = sys.__stdout__
    print("Debug complete. Logs written to pdf_debug_log.txt")
