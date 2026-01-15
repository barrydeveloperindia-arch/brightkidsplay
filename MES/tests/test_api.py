from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)

def test_api_workflow():
    print("=== Testing MES API Integation ===")
    
    # 1. Health Check
    response = client.get("/")
    assert response.status_code == 200
    print(f"Health Check: {response.json()}")
    
    # 2. Create Order (Module A Trigger)
    payload = {
        "customer_id": "Tesla-inc",
        "cad_file_path": "/vault/model_s/bracket.stl",
        "technical_requirements": {"material": "Inconel", "tolerance": 0.005},
        "priority": 10
    }
    resp_order = client.post("/orders", json=payload)
    print(f"Order Creation: {resp_order.status_code} - {resp_order.json()}")
    
    if resp_order.status_code == 201:
        job_id = resp_order.json().get("job_id")
        
        # 3. Check Shop Floor (Module B)
        resp_floor = client.get("/shop-floor")
        print(f"Shop Floor Status: {len(resp_floor.json())} active machines")
        
        # 4. Global Job Completion & Billing (Module C)
        # Assuming job_id exists
        if job_id and job_id != "DISPATCH_FAILED_COLLISION":
            print(f"Completing Job {job_id}...")
            resp_inv = client.post(f"/jobs/{job_id}/complete")
            print(f"Invoice Generation: {resp_inv.json()}")

    print("=== API Test Complete ===")

if __name__ == "__main__":
    test_api_workflow()
