from sqlalchemy import Column, String, DateTime, text, Float, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from .base import Base
import uuid

class Account(Base):
    __tablename__ = "accounts"
    
    account_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.user_id", ondelete="CASCADE"))
    institution_id = Column(String(50), nullable=False)
    institution_name = Column(String(100), nullable=False)
    account_type = Column(String(50), nullable=False)
    masked_account_number = Column(String(50), nullable=False)
    current_balance = Column(Float)
    status = Column(String(50), default='ACTIVE')
    last_synced_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=text('now()'))

    # Relations
    user = relationship("User")
