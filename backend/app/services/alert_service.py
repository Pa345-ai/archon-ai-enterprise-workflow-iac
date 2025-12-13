import sendgrid
from slack_sdk import WebClient
from app.config import settings

sg = sendgrid.SendGridAPIClient(api_key=settings.sendgrid_api_key)
slack_client = WebClient(token=settings.slack_token)

def send_alert(channel: str, message: str, target: str):
    if channel == "email":
        # Send email via SendGrid
        pass  # Implement SendGrid email sending
    elif channel == "slack":
        slack_client.chat_postMessage(channel=target, text=message)
