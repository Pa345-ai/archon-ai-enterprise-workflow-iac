from pydantic import BaseSettings

class Settings(BaseSettings):
    database_url: str
    jwt_secret: str
    openai_api_key: str
    sendgrid_api_key: str
    slack_token: str

    class Config:
        pass

settings = Settings()
