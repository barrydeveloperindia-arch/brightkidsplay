import sys
import os
import pdfplumber
import glob
import re

# Add the 'app' directory to the python path so imports work
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from app.services.parser.factory import ParserFactory
from app.services.enrichment.normalizer import MerchantNormalizer
from app.services.parser.exceptions import UnsupportedStatementError

def extract_text_from_pdf(pdf_path, password=None):
    raw_text = ""
    try:
        with pdfplumber.open(pdf_path, password=password or "") as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    raw_text += text + "\n"
    except Exception as e:
        # Handle password error explicitly
        if "Password" in str(e) or "Incorrect password" in str(e):
             return "LOCKED"
        print(f"❌ Error extracting text from {pdf_path}: {repr(e)}")
        return ""

    # OCR FALLBACK (Mirrors endpoint logic)
    needs_ocr = False
    if not raw_text.strip():
        needs_ocr = True
    elif raw_text.count("(cid:") > 10: 
        needs_ocr = True
        print("   ⚠️ Garbage text (Identity-H) detected. Attempting OCR...")
        raw_text = "" 
        
    if needs_ocr:
        try:
            import pytesseract
            from PIL import Image
            import shutil
            
            # Check Tesseract path
            if not shutil.which("tesseract"):
                    paths = [r"C:\Program Files\Tesseract-OCR\tesseract.exe", r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"]
                    for p in paths:
                        if os.path.exists(p):
                            pytesseract.pytesseract.tesseract_cmd = p
                            break
            
            with pdfplumber.open(pdf_path, password=password or "") as pdf:
                print(f"   👁️ OCR Scanning {len(pdf.pages)} pages...")
                for page in pdf.pages:
                    im = page.to_image(resolution=300).original
                    raw_text += pytesseract.image_to_string(im) + "\n"
                    
        except Exception as e:
            print(f"   ❌ OCR Failed: {e}")

    return raw_text

def run_real_verification():
    print("running real data verification...\n")
    
    # Path to statements directory (relative to script location)
    # script is in apps/backend/scripts/
    # statements is in financial app/statements/
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    
    print(f"Scanning directory: {base_dir}")

    # Recursive search for PDFs
    pdf_files = glob.glob(os.path.join(base_dir, '**', '*.pdf'), recursive=True)
    
    if not pdf_files:
        print("No PDF files found!")
        return

    print(f"Found {len(pdf_files)} PDF files.\n")

    # Sort files for consistent order
    pdf_files.sort()

    for pdf_path in pdf_files:
        filename = os.path.basename(pdf_path)
        folder = os.path.basename(os.path.dirname(pdf_path))
        print(f"--- Processing: {folder}/{filename} ---")
        
        # Determine password if needed
        password = None
        if "AXIS" in folder.upper():
            # Strategy: Try 'BHAR' + Last 4 digits of folder name
            # Folder format expected: "AXIS MAGNUS 5629" or "Axis Atlas 5122"
            try:
                # Find last 4 digits in folder name
                digits = re.search(r"\d{4}", folder)
                if digits:
                    last_4 = digits.group(0)
                    # Try uppercase first (Standard for banks)
                    password = f"BHAR{last_4}"
            except Exception:
                pass

        # 1. Extract Text
        raw_text = extract_text_from_pdf(pdf_path, password=password)
        
        # Retry with lowercase/Titlecase if failed and it was Axis
        if raw_text == "LOCKED" and "AXIS" in folder.upper() and password:
             # Try lowercase
             password_lower = password.lower()
             raw_text = extract_text_from_pdf(pdf_path, password=password_lower)
             
             if raw_text == "LOCKED":
                 # Try Title case (Bhar)
                 password_title = password[0].upper() + password[1:].lower()
                 raw_text = extract_text_from_pdf(pdf_path, password=password_title)

        if raw_text == "LOCKED":
             print("🔒 PDF is Password Protected and extraction failed.")
             continue
        
        if not raw_text.strip():
            print("⚠️  Warning: No text extracted (scanned image?). Skipping.\n")
            continue

        try:
            # 2. Parser Factory
            parser = ParserFactory.get_parser(raw_text)
            print(f"✅ Parser Detected: {parser.__class__.__name__}")
            
            # 3. Parse Transactions
            transactions = parser.parse()
            print(f"✅ Parsed {len(transactions)} transactions")
            
            if transactions:
                # Show first 3 as sample
                for i, txn in enumerate(transactions[:3]):
                    original_desc = txn['description']
                    clean_name = MerchantNormalizer.normalize(original_desc)
                    print(f"   [{i+1}] {original_desc} -> {clean_name} | {txn['amount']} | {txn.get('type')}")
                if len(transactions) > 3:
                     print(f"   ... and {len(transactions) - 3} more.")
            else:
                print("⚠️  No transactions found via regex.")

        except UnsupportedStatementError:
            print(f"❌ Unsupported Bank Format (No matching parser).")
        except Exception as e:
            print(f"❌ Error Parsing: {e}")
        
        print("\n")

if __name__ == "__main__":
    # Redirect stdout to a file for analysis
    with open("verification_log.txt", "w", encoding="utf-8") as f:
        sys.stdout = f
        run_real_verification()
        sys.stdout = sys.__stdout__
    print("Verification complete. Logs written to verification_log.txt")
