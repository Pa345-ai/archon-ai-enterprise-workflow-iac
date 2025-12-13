import openai
from app.config import settings

openai.api_key = settings.openai_api_key

def detect_anomalies(data: dict) -> dict:
    prompt = f"Analyze this workflow data for anomalies, delays, or risks: {data}"
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": prompt}]
    )
    return {"insights": response.choices[0].message.content, "actions": ["Review high-value task", "Automate reconciliation"]}
