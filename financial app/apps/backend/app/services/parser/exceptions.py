class UnsupportedStatementError(Exception):
    """Raised when no parser strategy matches the provided bank statement."""
    def __init__(self, message="No supported parser found for this statement."):
        self.message = message
        super().__init__(self.message)
