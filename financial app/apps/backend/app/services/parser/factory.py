from typing import List, Type
from .base import StatementParserService
from .hdfc_strategy import HdfcStatementParser
from .sbi_strategy import SbiStatementParser
from .icici_strategy import IciciStatementParser
from .amex_strategy import AmexStatementParser
from .hsbc_strategy import HsbcStatementParser
from .exceptions import UnsupportedStatementError

class ParserFactory:
    """
    Factory to detect and return the correct parser strategy.
    """
    
    _PARSERS = [
        AmexStatementParser,
        HsbcStatementParser,
        HdfcStatementParser,
        SbiStatementParser,
        IciciStatementParser
    ]

    @classmethod
    def get_parser(cls, raw_content: str) -> StatementParserService:
        """
        Iterates through registered parsers and returns the first matching one.
        Raises UnsupportedStatementError if no match is found.
        """
        for parser_cls in cls._PARSERS:
            if parser_cls.supports(raw_content):
                return parser_cls(raw_content)
        
        raise UnsupportedStatementError("Unable to identify bank statement format. Please ensure it is a supported bank.")
