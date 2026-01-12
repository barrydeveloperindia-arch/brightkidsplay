from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    SETU_CLIENT_ID: str = "your_client_id"
    SETU_CLIENT_SECRET: str = "your_client_secret"
    SETU_BASE_URL: str = "https://fiu-sandbox.setu.co"

    class Config:
        env_file = ".env"

settings = Settings()
