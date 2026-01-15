from sqlalchemy import Column, String, Integer, DateTime, text
from sqlalchemy.dialects.postgresql import ARRAY, UUID
from .base import Base
import uuid

class CategoryRule(Base):
    __tablename__ = "category_rules"
    
    rule_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False)
    
    # Matching logic: If description contains ANY of these keywords (case-insensitive)
    keywords = Column(ARRAY(String), nullable=False)
    
    # Action logic
    target_category = Column(String(100), nullable=True) # If set, override category
    target_tags = Column(ARRAY(String), default=[])      # Append these tags
    
    created_at = Column(DateTime(timezone=True), server_default=text('now()'))
