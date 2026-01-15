from sqlalchemy import Column, String, Integer, Float, Boolean, ForeignKey, JSON, DateTime, DECIMAL
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from .connection import Base

def generate_uuid():
    return str(uuid.uuid4())

class Machine(Base):
    __tablename__ = "machines"
    
    machine_id = Column(String, primary_key=True, default=generate_uuid)
    name = Column(String, nullable=False)
    capabilities = Column(JSON, nullable=False) # {"axis": 5, ...}
    current_status = Column(String, default="IDLE")
    telemetry_topic = Column(String)
    location_coords = Column(JSON)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    jobs = relationship("DispatchQueue", back_populates="machine")

class Order(Base):
    __tablename__ = "orders"
    
    order_id = Column(String, primary_key=True, default=generate_uuid)
    customer_id = Column(String, nullable=False)
    priority_level = Column(Integer, default=1)
    cad_file_path = Column(String, nullable=False)
    technical_requirements = Column(JSON, nullable=False)
    status = Column(String, default="PENDING")
    received_at = Column(DateTime, default=datetime.utcnow)
    estimated_delivery = Column(DateTime)
    
    jobs = relationship("DispatchQueue", back_populates="order")
    invoices = relationship("Invoice", back_populates="order")

class DispatchQueue(Base):
    __tablename__ = "dispatch_queue"
    
    job_id = Column(String, primary_key=True, default=generate_uuid)
    order_id = Column(String, ForeignKey("orders.order_id"))
    machine_id = Column(String, ForeignKey("machines.machine_id"))
    
    # Plans
    planned_start_time = Column(DateTime)
    estimated_runtime_seconds = Column(Integer)
    gcode_path = Column(String)
    nesting_coordinates = Column(JSON)
    
    # Execution
    actual_start_time = Column(DateTime)
    actual_end_time = Column(DateTime)
    status = Column(String, default="QUEUED")
    
    # Feedback
    interference_detected = Column(Boolean, default=False)
    successful_run = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    order = relationship("Order", back_populates="jobs")
    machine = relationship("Machine", back_populates="jobs")
    invoice = relationship("Invoice", back_populates="job", uselist=False)

class Invoice(Base):
    __tablename__ = "invoices"
    
    invoice_id = Column(String, primary_key=True, default=generate_uuid)
    job_id = Column(String, ForeignKey("dispatch_queue.job_id"))
    order_id = Column(String, ForeignKey("orders.order_id"))
    
    machine_runtime_cost = Column(DECIMAL(10, 2), nullable=False)
    material_cost = Column(DECIMAL(10, 2), nullable=False)
    labor_cost = Column(DECIMAL(10, 2), default=0.00)
    surcharges = Column(DECIMAL(10, 2), default=0.00)
    
    total_amount = Column(DECIMAL(10, 2), nullable=False)
    currency = Column(String, default="USD")
    
    generated_at = Column(DateTime, default=datetime.utcnow)
    synced_to_erp = Column(Boolean, default=False)
    erp_reference_id = Column(String)
    
    job = relationship("DispatchQueue", back_populates="invoice")
    order = relationship("Order", back_populates="invoices")


class User(Base):
    __tablename__ = 'users'
    
    user_id = Column(String, primary_key=True, default=generate_uuid)
    username = Column(String, unique=True, nullable=False)
    email = Column(String, unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    role = Column(String, default='operator') # admin, operator, accountant
    created_at = Column(DateTime, default=datetime.utcnow)

