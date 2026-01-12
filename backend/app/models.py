from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, create_engine
from sqlalchemy.orm import declarative_base, relationship, sessionmaker
from datetime import datetime

Base = declarative_base()
engine = create_engine("sqlite:///./finance.db", connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class Consent(Base):
    __tablename__ = "consents"

    id = Column(Integer, primary_key=True, index=True)
    mobile_number = Column(String, index=True)
    consent_handle = Column(String, unique=True, index=True)
    status = Column(String, default="PENDING") # PENDING, ACTIVE, REJECTED
    created_at = Column(DateTime, default=datetime.utcnow)
    
    accounts = relationship("FinancialAccount", back_populates="consent")

class FinancialAccount(Base):
    __tablename__ = "financial_accounts"

    id = Column(Integer, primary_key=True, index=True)
    consent_id = Column(Integer, ForeignKey("consents.id"))
    account_type = Column(String) # SAVINGS, CREDIT_CARD
    bank_name = Column(String)
    masked_account_number = Column(String)
    current_balance = Column(String) # Storing as string to handle currency symbols easily for prototype
    
    consent = relationship("Consent", back_populates="accounts")
    transactions = relationship("Transaction", back_populates="account")

class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(Integer, primary_key=True, index=True)
    account_id = Column(Integer, ForeignKey("financial_accounts.id"))
    txn_type = Column(String) # DEBIT, CREDIT
    amount = Column(String)
    date = Column(DateTime)
    description = Column(String)
    
    account = relationship("FinancialAccount", back_populates="transactions")

def init_db():
    Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
