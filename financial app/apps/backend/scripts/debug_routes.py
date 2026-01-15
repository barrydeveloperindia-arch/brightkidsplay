import sys
import os
# Add backend dir to path
sys.path.append(os.path.join(os.getcwd(), "apps", "backend"))

from app.main import app

print("REGISTERED ROUTES:")
for route in app.routes:
    print(f"{route.path} [{route.name}]")
