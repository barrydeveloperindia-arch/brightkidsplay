import sys
import os
import pdfplumber

# Add app to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.services.parser.factory import ParserFactory

def debug_crash():
    # Target file: Amex
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    target_file = os.path.join(base_dir, "AMERICAN EXPRESS PLATINUM 41009/2025-10-05.pdf")
    
    print(f"Testing local parse of: {target_file}")
    
    try:
        raw_text = ""
        with pdfplumber.open(target_file) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    raw_text += text + "\n"
                    
        print(f"Extracted {len(raw_text)} chars.")
        
        # 1. Factory Detection
        print("Detecting parser...")
        parser = ParserFactory.get_parser(raw_text)
        print(f"Parser detected: {parser.__class__.__name__}")
        
        # 2. Parse
        print("Parsing transactions...")
        txns = parser.parse()
        print(f"Parsed {len(txns)} transactions.")
        for t in txns[:3]:
            print(t)
            
    except Exception as e:
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    debug_crash()
