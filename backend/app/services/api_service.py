import requests
from app.utils.data_normalizer import normalize_data

def fetch_and_normalize_data(endpoint: str, api_key: str):
    headers = {"Authorization": f"Bearer {api_key}"}
    response = requests.get(endpoint, headers=headers)
    raw_data = response.json()
    return normalize_data(raw_data)  # Normalize to common schema
