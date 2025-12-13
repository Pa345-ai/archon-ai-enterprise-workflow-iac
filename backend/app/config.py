from pydantic import BaseSettings

class Settings(BaseSettings):
    db_host: str = "localhost"
    db_user: str = "user"
    db_password: str
    db_name: str = "db"
    secret_key: str
    openai_api_key: str
    sendgrid_api_key: str
    slack_token: str
    # Construct DATABASE_URL from components
    @property
    def database_url(self) -> str:
        return f"postgresql://{self.db_user}:{self.db_password}@{self.db_host}/{self.db_name}"
    # Add more API configs dynamically via env or DB

    class Config:
        env_file = ".env"

settings = Settings()
