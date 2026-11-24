"""Unit tests for Supabase JWT verification and rejection behavior."""
import time
from types import SimpleNamespace
from uuid import UUID

import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa
from fastapi import HTTPException
from fastapi.security import HTTPAuthorizationCredentials

from app import auth
from app.config import Settings


@pytest.fixture
def signing_keys():
    # Use an ephemeral RSA key so tests never depend on a real Supabase project.
    private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    return private_key, private_key.public_key()


@pytest.fixture
def settings():
    # Keep issuer and audience explicit to verify both JWT trust boundaries.
    return Settings(
        public_menu_base_url="https://menu.example.com",
        supabase_url="https://project.example.supabase.co",
        supabase_jwt_issuer="https://project.example.supabase.co/auth/v1",
        supabase_jwks_url="https://project.example.supabase.co/auth/v1/.well-known/jwks.json",
        supabase_jwt_audience="authenticated",
        database_url="postgresql://test:test@localhost:5432/test",
    )


def make_token(private_key, **overrides):
    # Create short-lived test access tokens with the claims required by the verifier.
    now = int(time.time())
    claims = {
        "sub": str(UUID("6f0f2e3a-8e7a-4f9e-8b7c-2c1a6f4e9d10")),
        "iss": "https://project.example.supabase.co/auth/v1",
        "aud": "authenticated",
        "iat": now,
        "exp": now + 300,
    }
    claims.update(overrides)
    return jwt.encode(claims, private_key, algorithm="RS256")


def install_test_jwks(monkeypatch, public_key):
    # Replace the network JWKS lookup with the matching in-memory public key.
    fake_client = SimpleNamespace(
        get_signing_key_from_jwt=lambda _token: SimpleNamespace(key=public_key)
    )
    monkeypatch.setattr(auth, "_jwks_client", lambda _url: fake_client)


def credentials(token):
    # Exercise the same bearer-credential shape supplied by FastAPI's HTTPBearer.
    return HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)


def test_valid_supabase_access_token_returns_uuid_subject(monkeypatch, signing_keys, settings):
    # A correctly signed token from the configured issuer and audience is accepted.
    private_key, public_key = signing_keys
    install_test_jwks(monkeypatch, public_key)
    user = auth.get_current_user(credentials(make_token(private_key)), settings)
    assert user["sub"] == "6f0f2e3a-8e7a-4f9e-8b7c-2c1a6f4e9d10"


def test_missing_bearer_token_is_rejected(settings):
    # Protected endpoints must reject requests without an Authorization header.
    with pytest.raises(HTTPException) as error:
        auth.get_current_user(None, settings)
    assert error.value.status_code == 401


@pytest.mark.parametrize(
    "claims",
    [
        {"iss": "https://attacker.example.com"},
        {"aud": "anonymous"},
        {"exp": int(time.time()) - 60, "iat": int(time.time()) - 120},
        {"sub": "not-a-uuid"},
    ],
)
def test_invalid_access_token_claims_are_rejected(
    monkeypatch, signing_keys, settings, claims
):
    # Wrong issuer/audience, expired tokens, and malformed user IDs must fail closed.
    private_key, public_key = signing_keys
    install_test_jwks(monkeypatch, public_key)
    token = make_token(private_key, **claims)
    with pytest.raises(HTTPException) as error:
        auth.get_current_user(credentials(token), settings)
    assert error.value.status_code == 401
