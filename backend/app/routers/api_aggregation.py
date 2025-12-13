from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.dependencies import get_db, get_current_user  # Added get_current_user
from app.services.api_service import fetch_and_normalize_data
from app.schemas import APIConfig

router = APIRouter()

@router.post("/pull-data")
def pull_data(config: APIConfig, user: dict = Depends(get_current_user), db: Session = Depends(get_db)):  # Added user dependency
    try:
        normalized_data = fetch_and_normalize_data(config.endpoint, config.api_key)
        # Save to DB
        return {"status": "Data pulled and normalized", "data": normalized_data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
