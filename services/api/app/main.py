"""FastAPI application entry point."""

from fastapi import FastAPI

from app.api.health import router as health_router
from app.core.config import get_settings

settings = get_settings()

app = FastAPI(
    title=settings.app_name,
    version="0.1.0",
    description=(
        "Trusted API for shop-owner operations and sanitized public digital menus. "
        "Customer menu access is browser-based and does not require authentication."
    ),
    docs_url="/docs" if settings.app_env != "production" else None,
    redoc_url="/redoc" if settings.app_env != "production" else None,
)

app.include_router(health_router, prefix=settings.api_v1_prefix)


@app.get("/", include_in_schema=False)
async def root() -> dict[str, str]:
    """Provide a small service-discovery response for local developers."""
    return {"service": "qr-digital-menu-api", "docs": "/docs"}
