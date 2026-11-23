# FastAPI service

This service is the trusted backend for owner operations. Protected routes must validate Supabase access tokens and enforce shop membership on every request. Never trust a client-supplied user ID, shop role, or ownership claim.

## Local development

Run commands from the repository root:

```bash
python -m pip install -e ".[dev]"
uvicorn app.main:app --app-dir services/api --reload
pytest
```

## Current route

- `GET /api/v1/health` — public process health check. This is not a database-readiness check.

## Security rules for upcoming endpoints

- Verify JWT signature, issuer, audience, and expiry against Supabase JWKS.
- Derive actor identity only from verified token claims.
- Check shop membership and role in the backend for every shop-scoped operation.
- Keep service-role credentials server-side only.
- Return a dedicated sanitized DTO from public menu routes; never serialize database rows directly.
- Avoid logging access tokens, secrets, personal customer data, or raw request bodies containing credentials.
