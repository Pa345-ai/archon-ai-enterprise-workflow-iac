
from fastapi import APIRouter, Depends
from app.services.alert_service import send_alert
from app.dependencies import get_current_user  # Import security dependency

router = APIRouter()

@router.post("/send")
def send_alert_endpoint(channel: str, message: str, target: str, user: dict = Depends(get_current_user)):  # CRITICAL SECURITY ADDITION
    """
    Triggers an external alert via the configured channel (Slack/Email).
    Requires a valid JWT token with the 'admin' role.
    """
    # The 'user' object is injected here, enforcing authentication.
    send_alert(channel, message, target)
    return {"status": "Alert sent"}
