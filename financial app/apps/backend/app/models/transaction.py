from sqlalchemy import Column, String, DateTime, text, Float, ForeignKey, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from .base import Base
import uuid

class Transaction(Base):
    __tablename__ = "transactions"
    
    transaction_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    account_id = Column(UUID(as_uuid=True), ForeignKey("accounts.account_id", ondelete="CASCADE"))
    merchant_id = Column(UUID(as_uuid=True), nullable=True) # Future link
    
    transaction_date = Column(DateTime(timezone=True), nullable=False)
    amount = Column(Float, nullable=False)
    currency = Column(String(3), default='INR')
    description = Column(Text)
    
    category = Column(String(100))
    type = Column(String(20)) # CREDIT / DEBIT
    status = Column(String(20), default='POSTED')
    
    narration = Column(Text)
    reference_number = Column(String(100))
    
    # Store tags as array of strings
    # Note: Requires Postgres. For SQLite fallback, use JSON type.
    from sqlalchemy.dialects.postgresql import ARRAY
    tags = Column(ARRAY(String), default=[])
    
    created_at = Column(DateTime(timezone=True), server_default=text('now()'))
    
    # Relations
    account = relationship("Account")
