"""Unauthenticated process health endpoint."""

from datetime import UTC, datetime

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    """Minimal health payload; does not imply database dependency health."""

    status: str
    service: str
    timestamp: datetime


@router.get("/health", response_model=HealthResponse, summary="API process health")
async def health_check() -> HealthResponse:
    """Confirm that the API process is responding to HTTP requests."""
    return HealthResponse(
        status="ok",
        service="qr-digital-menu-api",
        timestamp=datetime.now(UTC),
    )
