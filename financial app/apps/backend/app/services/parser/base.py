from abc import ABC, abstractmethod
from typing import List, Dict, Any
from datetime import datetime
import re

class StatementParserService(ABC):
    """
    Abstract Base Class for Bank Statement Parsers.
    Follows the Strategy Pattern.
    """

    def __init__(self, raw_content: str):
        self.raw_content = raw_content

    @abstractmethod
    def parse(self) -> List[Dict[str, Any]]:
        """
        Parses the raw content and returns a list of normalized transaction dictionaries.
        """
        pass

    @classmethod
    @abstractmethod
    def supports(cls, raw_content: str) -> bool:
        """
        Determines if this parser supports the given raw content.
        """
        pass


    def clean_merchant_name(self, raw_name: str) -> str:
        """
        Helper to clean merchant names.
        This would connect to the EnrichmentService in a real implementation.
        """
        # Simple placeholder logic
        name = raw_name.strip()
        name = re.sub(r'\s+', ' ', name)
        return name
