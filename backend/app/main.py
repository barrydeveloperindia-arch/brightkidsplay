from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from .routers import auth, consent, data

from .models import init_db

app = FastAPI(title="Central Finance Command Center")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Allow all for prototype simplicity
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def validation_exception_handler(request, call_next):
    try:
        return await call_next(request)
    except Exception as exc:
        print(f"Server Error: {exc}")
        import traceback
        with open("error_log.txt", "a") as f:
            f.write(f"\n--- ERROR ---\n{str(exc)}\n")
            traceback.print_exc(file=f)
        return HTMLResponse(status_code=500, content="Internal Server Error")

def on_startup():
    init_db()

app.include_router(auth.router)
app.include_router(consent.router)
app.include_router(data.router)

@app.get("/", response_class=HTMLResponse)
async def read_root():
    return """
    <html>
        <head>
            <title>Finance Command Center</title>
            <style>body { font-family: sans-serif; padding: 20px; }</style>
        </head>
        <body>
            <h1>Finance Command Center</h1>
            <p>Status: <strong style="color: green;">Online</strong></p>
            <p>Backend: FastAPI + Setu AA</p>
            <ul>
                <li><a href="/docs">API Documentation</a></li>
                <li><a href="/consent/create?mobile_number=9999999999">Test Consent Creation</a></li>
            </ul>
        </body>
    </html>
    """
