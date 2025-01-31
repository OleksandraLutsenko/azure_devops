import os

class Config:
    """Flask Configuration from Environment Variables"""
    
    DEBUG = os.getenv("DEBUG_MODE", "False").lower() == "true"
    API_KEY = os.getenv("API_KEY", "default-key")
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///default.db")
    PORT = int(os.getenv("PORT", 5000))  # Default to 5000 if not set
    