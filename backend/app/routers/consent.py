from fastapi import APIRouter, Depends
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..services.setu_client import setu_client
from ..models import get_db, Consent

router = APIRouter(prefix="/consent", tags=["consent"])

@router.post("/create")
async def create_consent(mobile_number: str, db: Session = Depends(get_db)):
    # Create request to Setu
    response = await setu_client.create_consent(mobile_number)
    
    # Store in DB
    if "id" in response:
        consent = Consent(
            mobile_number=mobile_number,
            consent_handle=response["id"], # Using ID as handle for mock simplicity
            status=response.get("status", "PENDING")
        )
        db.add(consent)
        db.commit()
        db.refresh(consent)
        
    return response

@router.get("/status/{consent_id}")
async def get_consent_status(consent_id: str, db: Session = Depends(get_db)):
    # Check DB first
    consent = db.query(Consent).filter(Consent.consent_handle == consent_id).first()
    if consent:
        return {"status": consent.status, "id": consent_id, "source": "DB"}
        
    # Fallback to Setu (or valid if we just want to proxy)
    return await setu_client.get_consent_status(consent_id)
