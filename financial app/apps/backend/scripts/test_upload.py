import requests
import os

def test_upload():
    url = "http://localhost:8000/api/v1/import/upload"
    
    # Create dummy pdf
    with open("dummy.pdf", "wb") as f:
        f.write(b"%PDF-1.4 dummy content")
        
    files = {'file': ('dummy.pdf', open('dummy.pdf', 'rb'), 'application/pdf')}
    
    try:
        res = requests.post(url, files=files)
        print(f"Status: {res.status_code}")
        print(f"Response: {res.text}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Cleanup
        try:
            os.remove("dummy.pdf")
            # Also remove from data/documents if it got saved
            target = "data/documents/dummy.pdf"
            if os.path.exists(target):
                os.remove(target)
                print("Cleaned up server file.")
        except:
            pass

if __name__ == "__main__":
    test_upload()
