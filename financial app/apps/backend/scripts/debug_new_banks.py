import pdfplumber
import os
import sys
import glob

def debug_banks():
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    
    # Banks to look for
    targets = ["HSBC", "EXPRESS"] 
    
    for target in targets:
        print(f"\n🌐 SEARCHING FOR: {target}...")
        if target == "HSBC":
             files = glob.glob(os.path.join(base_dir, "HSBC CREDIT CARD", "**", "*.pdf"), recursive=True)
        else:
             files = glob.glob(os.path.join(base_dir, f"*{target}*", "*.pdf"))
        
        if not files:
            print(f"❌ No files found for {target}")
            continue
            
        sample_file = files[0]
        print(f"📄 Analyzing: {os.path.basename(sample_file)}")
        
        try:
            with pdfplumber.open(sample_file) as pdf:
                page = pdf.pages[0]
                text = page.extract_text()
                
                if not text:
                    print("⚠️ No text extracted. Attempting OCR...")
                    import pytesseract
                    from PIL import Image
                    
                     # Check for Tesseract availability (Simple check)
                    import shutil
                    if not shutil.which("tesseract"):
                        paths = [r"C:\Program Files\Tesseract-OCR\tesseract.exe", r"C:\Program Files (x86)\Tesseract-OCR\tesseract.exe"]
                        for p in paths:
                            if os.path.exists(p):
                                pytesseract.pytesseract.tesseract_cmd = p
                                break
                    
                    im = page.to_image(resolution=300).original
                    text = pytesseract.image_to_string(im)
                    
                    print("--- START OCR TEXT ---")
                    print(text[:1500])
                    print("--- END OCR TEXT ---")
                else:
                    print("--- START TEXT ---")
                    print(text[:1500])
                    print("--- END TEXT ---")
                    
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    with open("debug_banks_internal.log", "w", encoding="utf-8") as f:
        sys.stdout = f
        debug_banks()
        sys.stdout = sys.__stdout__
    print("Debug complete. Check debug_banks_internal.log")
