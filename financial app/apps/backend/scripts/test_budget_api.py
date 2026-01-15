import requests
import json

def test_budget():
    url = "http://localhost:8000/api/v1/budgets/set"
    payload = {
        "category": "TestAPI",
        "month": "2024-01",
        "limit": 1000.0
    }
    try:
        res = requests.post(url, json=payload)
        print(f"Status: {res.status_code}")
        print(f"Response: {res.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_budget()
