import httpx
import uuid
from ..config import settings

class SetuClient:
    def __init__(self):
        self.base_url = settings.SETU_BASE_URL
        self.client_id = settings.SETU_CLIENT_ID
        self.client_secret = settings.SETU_CLIENT_SECRET
        self.headers = {
            "x-client-id": self.client_id,
            "x-client-secret": self.client_secret,
            "Content-Type": "application/json"
        }

    async def create_consent(self, mobile_number: str, mode: str = "LIVE"):
        """
        Creates a consent request in the Setu Sandbox.
        """
        url = f"{self.base_url}/consent"
        # Minimum required payload for Sandbox
        payload = {
            "mobileNumber": mobile_number,
            "vua": f"{mobile_number}@setu-aa" # Sandbox convention
        }
        
        async with httpx.AsyncClient() as client:
            # Force Mock if requested or if keys are missing
            if mode == "MOCK" or self.client_id == "your_client_id":
                # Returns a mock response for initial testing without valid credentials
                # Generate unique ID to prevent DB unique constraint violation
                mock_id = f"mock_{uuid.uuid4().hex[:8]}"
                return {
                    "id": mock_id,
                    "url": f"https://fiu-sandbox.setu.co/consent/{mock_id}",
                    "status": "PENDING"
                }

            response = await client.post(url, json=payload, headers=self.headers)
            try:
                response.raise_for_status()
            except httpx.HTTPStatusError as exc:
                print(f"Setu API Error: {exc.response.text}")
                raise exc
            return response.json()

    async def get_consent_status(self, consent_id: str, mode: str = "LIVE"):
        url = f"{self.base_url}/consent/{consent_id}"
        
        if mode == "MOCK" or self.client_id == "your_client_id":
             return {"status": "ACTIVE"}

        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=self.headers)
            response.raise_for_status()
            return response.json()

    async def create_data_session(self, consent_id: str):
        """
        Creates a Data Session to request FI data.
        """
        url = f"{self.base_url}/fi/request"
        
        # Default to last 90 days for now
        from datetime import datetime, timedelta
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=90)
        
        payload = {
            "consentId": consent_id,
            "dataFormat": "json",
            "dateRange": {
                "from": start_date.strftime("%Y-%m-%d"),
                "to": end_date.strftime("%Y-%m-%d")
            }
        }
        
        async with httpx.AsyncClient() as client:
            # We don't really mock this explicitly inside here because current flow 
            # only calls this from fetch_data which handles the high level mock branch.
            # But strictly speaking we should. 
            # For now, let's leave as is since fetch_data handles the branch.
            response = await client.post(url, json=payload, headers=self.headers)
            response.raise_for_status()
            return response.json()

    async def fetch_data(self, consent_id: str, mode: str = "LIVE"):
        if mode == "MOCK" or self.client_id == "your_client_id":
             # Mock FI Data Response with varied formats
             return {
                 "accounts": [
                     {
                         "maskedAccNumber": "XXXX-1234",
                         "fiType": "DEPOSIT",
                         "currentBalance": "50000.00",
                         "currency": "INR",
                         "bank": "HDFC",
                         "transactions": [
                            {"amount": "5000.00", "type": "CREDIT", "date": "2023-10-01T10:00:00Z", "narration": "Salary Credit"},
                            {"amount": "200.00", "type": "DEBIT", "date": "2023-10-02T14:30:00Z", "narration": "UPI Payment"}
                         ]
                     },
                     {
                         "maskedAccNumber": "XXXX-9988",
                         "fiType": "CREDIT_CARD",
                         "currentBalance": "-15000.00",
                         "currency": "INR",
                         "bank": "SBI Cards",
                         "transactions": [
                            {"amount": "1500.00", "type": "DEBIT", "date": "2023-10-05T18:00:00Z", "narration": "Amazon Purchase"}
                         ]
                     },
                     {
                         "maskedAccNumber": "XXXX-7777",
                         "fiType": "DEPOSIT",
                         "currentBalance": "1234.56",
                         "currency": "INR",
                         "bank": "ICICI",
                         "transactions": []
                     }
                 ],
                 "consentStatus": "ACTIVE"
             }

        # Real Flow
        try:
            # 1. Create Data Session
            session_resp = await self.create_data_session(consent_id)
            session_id = session_resp["sessionId"]
            
            # 2. Fetch Data using Session ID
            url = f"{self.base_url}/fi/fetch/{session_id}"
            
            async with httpx.AsyncClient() as client:
                response = await client.get(url, headers=self.headers)
                response.raise_for_status()
                # Note: In production, this data is JWE encrypted. 
                # We would need to decrypt it here using private key.
                # returning raw json for now assuming Sandbox might return unencrypted or we handle it later
                return response.json()
        except Exception as e:
            print(f"Error in real fetch flow: {e}")
            raise e
            response = await client.get(url, headers=self.headers)
            response.raise_for_status()
            return response.json()

setu_client = SetuClient()
