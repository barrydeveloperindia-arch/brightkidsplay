import sys
import os
import re
import pdfplumber

# Add app to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.services.parser.amex_strategy import AmexStatementParser

def debug_amex():
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    target_file = os.path.join(base_dir, "AMERICAN EXPRESS PLATINUM 41009/2025-10-05.pdf")
    
    print(f"📄 Testing Amex Parser on: {target_file}")
    
    with pdfplumber.open(target_file) as pdf:
        raw_text = ""
        for page in pdf.pages:
            raw_text += page.extract_text() + "\n"
            
    print(f"\n--- RAW TEXT SNAPSHOT (First 1000 chars) ---\n{raw_text[:1000]}\n--- END RAW TEXT ---\n")
    
    parser = AmexStatementParser(raw_text)
    print(f"Parser Supports? {parser.supports(raw_text)}")
    
    # Manual Regex Check
    print("\n--- LINE ANALYSIS ---")
    lines = raw_text.split('\n')
    for i, line in enumerate(lines[:50]): # Check first 50 lines
        line = line.strip()
        match = AmexStatementParser.TXN_PATTERN.search(line)
        if match:
            print(f"✅ Line {i}: MATCH -> {match.groups()}")
        elif "September" in line:
             print(f"❌ Line {i}: NO MATCH -> '{line}'")
             
    # Full Parse
    print("\n--- FULL PARSE RESULT ---")
    txns = parser.parse()
    print(f"Total Transactions: {len(txns)}")
    for t in txns:
        print(t)

if __name__ == "__main__":
    with open("amex_debug.log", "w", encoding="utf-8") as f:
        sys.stdout = f
        debug_amex()
        sys.stdout = sys.__stdout__
    print("Debug run complete. Check amex_debug.log")
