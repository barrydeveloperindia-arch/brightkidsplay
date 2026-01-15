from fastapi import APIRouter, UploadFile, File, BackgroundTasks
from app.services.import_service import ImportService
import os
import shutil

router = APIRouter()

@router.post("/trigger")
def trigger_import(background_tasks: BackgroundTasks):
    result = ImportService.run_import()
    return {"status": "Import triggered", "results": result}

@router.post("/upload")
async def upload_statement(file: UploadFile = File(...), background_tasks: BackgroundTasks = None):
    """
    Upload a PDF statement and trigger processing.
    """
    file_location = os.path.join(ImportService.INPUT_DIR, file.filename)
    
    # Ensure directory exists
    os.makedirs(ImportService.INPUT_DIR, exist_ok=True)
    
    with open(file_location, "wb+") as file_object:
        shutil.copyfileobj(file.file, file_object)
        
    # Trigger processing immediately?
    # Yes, for user feedback.
    # Note: run_import is blocking, might want to bg task it if large.
    # For now, let's allow it to block for small files to give instant feedback.
    
    results = ImportService.run_import()
    
    return {
        "status": "File uploaded and processed", 
        "filename": file.filename,
        "results": results
    }
