import pdfplumber
import os
import sys
import re

def analyze_icici():
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../statements'))
    # Find the first ICICI file
    icici_file = None
    for root, dirs, files in os.walk(base_dir):
        if "ICICI" in root.upper():
            for f in files:
                if f.endswith(".pdf"):
                    icici_file = os.path.join(root, f)
                    break
        if icici_file: break
    
    if not icici_file:
        print("❌ No ICICI file found.")
        return

    print(f"🧐 Analyzing: {icici_file}")

    with pdfplumber.open(icici_file) as pdf:
        page = pdf.pages[0]
        text = page.extract_text()
        print("\n--- RAW TEXT EXTRACT ---")
        print(text[:1000]) # First 1000 chars
        print("\n--- END RAW TEXT ---")

        print("\n--- CHAR ANALYSIS (First 20 chars) ---")
        # Inspect the underlying character objects to see font info
        for i, char in enumerate(page.chars[:20]):
            print(f"Char: '{char.get('text')}' | Font: {char.get('fontname')} | CID: {char.get('cid', 'N/A')} | Encoding: {char.get('encoding')}")

        print("\n--- SEARCHING FOR NUMBERS ---")
        # Check if numbers are also garbled or just text
        # Look for a date-like pattern or amount-like pattern
        text_lines = text.split('\n')
        for line in text_lines[:20]:
            if re.search(r'\d', line):
                print(f"Found Numbers line: {line}")

if __name__ == "__main__":
    analyze_icici()
