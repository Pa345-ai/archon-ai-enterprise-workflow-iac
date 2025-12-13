from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from app.utils.auth_utils import get_jwt_settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    jwt_settings = get_jwt_settings()
    try:
        payload = jwt.decode(token, jwt_settings["SECRET_KEY"], algorithms=[jwt_settings["ALGORITHM"]])
        username: str = payload.get("sub")
        roles: list = payload.get("roles", [])
        if username is None or "admin" not in roles:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    # Simulate fetching user from DB (replace with actual DB query)
    user = {"username": username, "roles": roles}
    return user
