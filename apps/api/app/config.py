"""Typed environment configuration for the API."""
from functools import lru_cache

from pydantic import AnyHttpUrl, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # Load local .env values while allowing deployment secrets to override them.
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    environment: str = "development"
    api_prefix: str = "/api/v1"
    public_menu_base_url: AnyHttpUrl
    supabase_url: AnyHttpUrl
    supabase_jwt_issuer: AnyHttpUrl
    supabase_jwks_url: AnyHttpUrl
    supabase_jwt_audience: str = "authenticated"
    database_url: str = Field(repr=False)
    database_pool_min_size: int = Field(default=1, ge=1)
    database_pool_max_size: int = Field(default=5, ge=1)


@lru_cache
def get_settings() -> Settings:
    # Cache settings so all request handlers share one validated configuration.
    return Settings()
