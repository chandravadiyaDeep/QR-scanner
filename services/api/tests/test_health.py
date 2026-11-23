"""Smoke tests for the API foundation."""

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_endpoint_returns_healthy_status() -> None:
    """Health route is public and returns a timestamped status response."""
    response = client.get("/api/v1/health")

    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "ok"
    assert payload["service"] == "qr-digital-menu-api"
    assert payload["timestamp"]


def test_openapi_document_is_available() -> None:
    """The generated OpenAPI document is available for client contract work."""
    response = client.get("/openapi.json")

    assert response.status_code == 200
    schema = response.json()
    assert schema["info"]["version"] == "0.1.0"
    assert "/api/v1/health" in schema["paths"]
