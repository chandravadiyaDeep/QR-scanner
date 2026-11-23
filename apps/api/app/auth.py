"""Supabase access-token verification using the project's JWKS endpoint."""
from functools import lru_cache
from typing import Any

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jwt import PyJWKClient

from app.config import Settings, get_settings

bearer_scheme = HTTPBearer(auto_error=False)


@lru_cache(maxsize=8)
def _jwks_client(url: str) -> PyJWKClient:
    # PyJWKClient caches signing keys and refreshes when an unknown key appears.
    return PyJWKClient(url, cache_jwk_set=True, lifespan=300)


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    settings: Settings = Depends(get_settings),
) -> dict[str, Any]:
    # Missing credentials and invalid tokens share a safe 401 response.
    unauthorized = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail={"code": "UNAUTHENTICATED", "message": "A valid access token is required."},
        headers={"WWW-Authenticate": "Bearer"},
    )
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise unauthorized

    try:
        signing_key = _jwks_client(str(settings.supabase_jwks_url)).get_signing_key_from_jwt(
            credentials.credentials
        )
        claims = jwt.decode(
            credentials.credentials,
            signing_key.key,
            algorithms=["ES256", "RS256"],
            audience=settings.supabase_jwt_audience,
            issuer=str(settings.supabase_jwt_issuer).rstrip("/"),
            options={"require": ["exp", "iat", "sub", "iss", "aud"]},
        )
        # Supabase user IDs are UUIDs; reject malformed subjects before database access.
        from uuid import UUID

        claims["sub"] = str(UUID(claims["sub"]))
        return claims
    except (jwt.PyJWTError, ValueError, TypeError, Exception) as exc:
        # Do not expose key-fetch details, JWT contents, or cryptographic errors.
        raise unauthorized from exc
