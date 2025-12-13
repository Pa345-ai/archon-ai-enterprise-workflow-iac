import os

def get_jwt_settings() -> dict:
    # CRITICAL FIX: Look for JWT_SECRET name defined in the ECS Task Definition
    secret_key = os.getenv("JWT_SECRET") 
    
    # CRITICAL FIX: Must FAIL and raise an error if the secret is not found (no placeholders)
    if not secret_key:
        raise ValueError("JWT_SECRET environment variable not set. Application cannot run securely.")

    return {
        # Changed key name here to JWT_SECRET to match environment variable
        "SECRET_KEY": secret_key, 
        "ALGORITHM": "HS256",
        "ACCESS_TOKEN_EXPIRE_MINUTES": 30,
    }
