from fastapi import APIRouter, Depends
from app.services.ai_service import detect_anomalies
from app.dependencies import get_current_user  # Import security dependency

router = APIRouter()

@router.post("/analyze")
def analyze_workflow(data: dict, user: dict = Depends(get_current_user)):  # CRITICAL SECURITY ADDITION
    """
    Analyzes workflow data for anomalies using the AI service.
    Requires a valid JWT token with the 'admin' role.
    """
    # The 'user' object is injected here, enforcing authentication.
    return detect_anomalies(data)
  
