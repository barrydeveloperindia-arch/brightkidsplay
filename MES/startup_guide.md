# Englabs MES - Startup Guide

## Prerequisites
- Python 3.9+
- Node.js 16+ (for Frontend)
- PostgreSQL (Optional, defaults to SQLite for demo)

## 1. Backend Setup

### Install Dependencies
```bash
pip install fastapi uvicorn sqlalchemy pydantic requests
```

### Initialize Database
```bash
python -m src.database.init_db
```

### Run API Server
Start the FastAPI server on port 8000:
```bash
uvicorn src.main:app --reload --port 8000
```
API Documentation will be available at: http://localhost:8000/docs

## 2. Frontend Setup

The frontend components are located in `src/frontend`. To run them, you need a standard React+Vite setup.

### Create Vite Config (if not present)
Ensure `vite.config.js` and `package.json` are at the root or configured to point to `src/frontend`.

### Install & Run
```bash
npm install
npm run dev
```

## 3. Running Simulation
You can run the individual module test scripts to simulate activity while the server is running:

| Module | Command | Description |
|--------|---------|-------------|
| **Dispatch** | `python -m tests.test_module_a` | Simulates AI ordering. |
| **IoT** | `python -m tests.test_module_b` | Simulates machine telemetry. |
| **Billing** | `python -m tests.test_module_c` | Simulates invoice generation. |
| **Internal ERP** | `python -m tests.test_module_d` | Verifies General Ledger Double-Entry logic. |


## 4. Deployment via Docker (Recommended)

To run the entire stack (Database + API + Frontend) in isolated containers:

`ash
docker-compose up --build
`
- **Backend API**: http://localhost:8000
- **Frontend UI**: http://localhost:5173
- **Database**: Port 5432

