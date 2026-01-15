import re
from typing import Dict

class MerchantNormalizer:
    """
    Normalizes raw merchant strings into clean, human-readable names.
    """

    # Dictionary of Regex Pattern -> Clean Name
    # In a real app, this might be loaded from a DB or config file.
    PATTERNS: Dict[str, str] = {
        r"IND[\* ]*AMAZON": "Amazon",
        r"AMAZON\.IN": "Amazon",
        r"RAZ[\* ]*FCAP": "Cred", # FCAP Technologies is often Cred
        r"RAZ[\* ]*IRCTC": "IRCTC",
        r"SWIGGY": "Swiggy",
        r"ZOMATO": "Zomato",
        r"UBER": "Uber",
        r"OLA": "Ola",
        r"NETFLIX": "Netflix",
        r"SPOTIFY": "Spotify",
        r"APPLE\.COM": "Apple Services",
    }

    @classmethod
    def normalize(cls, raw_description: str) -> str:
        """
        Applies regex patterns to normalize the merchant name.
        If no pattern matches, returns the original string title-cased.
        """
        for pattern, clean_name in cls.PATTERNS.items():
            if re.search(pattern, raw_description, re.IGNORECASE):
                return clean_name
        
        # Fallback: Basic cleanup
        # Remove common prefixes like "UPI-", "POS-", "NEFT-"
        cleaned = re.sub(r"^(UPI|POS|NEFT|IMPS)[-\s]*", "", raw_description, flags=re.IGNORECASE)
        # Remove special chars
        cleaned = re.sub(r"[^\w\s]", " ", cleaned)
        # Collapse whitespace
        cleaned = re.sub(r"\s+", " ", cleaned).strip()
        
        return cleaned.title()
