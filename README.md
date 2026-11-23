# QR Digital Menu

A shop-owner Android app and a customer-facing public web menu, backed by a secure API.

## Product boundary

- Owners manage shops and menus in the Android app.
- Customers scan a QR code and open a public HTTPS menu in their browser.
- Customers do not install the app or sign in.
- The QR code stores a stable public URL, never menu data or an app-only deep link.
- Ordering, payments, subscriptions, loyalty, and AI menu descriptions are out of scope for this release.

## Repository layout

```text
apps/
  owner_android/       # Flutter shop-owner application
  public_menu/         # Next.js public customer menu
services/
  api/                 # FastAPI trusted backend
supabase/
  migrations/          # Reviewed PostgreSQL migrations
docs/                  # Engineering notes and fixtures
.github/workflows/     # Continuous integration
```

## Current implementation status

The engineering foundation is being built in milestone branch `milestone-1/engineering-foundation`. The API currently provides a public health endpoint and a versioned OpenAPI surface. Shop data, authentication, and menu endpoints are added only after their security and database contracts are implemented.

## Backend quick start

Requirements: Python 3.12 or newer.

```bash
cd services/api
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux:
# source .venv/bin/activate
python -m pip install -e ".[dev]"
uvicorn app.main:app --reload
```

- Health: http://127.0.0.1:8000/api/v1/health
- OpenAPI: http://127.0.0.1:8000/openapi.json
- Swagger UI: http://127.0.0.1:8000/docs

Run tests from `services/api`:

```bash
pytest
```

## Environment and secrets

Copy `.env.example` to `.env` for local development when environment-backed settings are needed. Never commit `.env`, Supabase service-role keys, JWT signing secrets, or production credentials. Store deployment secrets in the hosting provider's secret manager.

## Authoritative product and engineering documents

- [Product plan](PRODUCT_PLAN.md)
- [Technical architecture](TECHNICAL_ARCHITECTURE.md)
- [System design](SYSTEM_DESIGN.md)
- [Database schema proposal](DATABASE_SCHEMA.sql)
- [API contracts](API_CONTRACTS.md)
- [Squad contracts](SQUAD_CONTRACTS.md)
- [Development roadmap](DEVELOPMENT_ROADMAP.md)

## Important database note

`DATABASE_SCHEMA.sql` is a proposed schema, not an applied migration. Review and validate it in a disposable development Supabase project before promoting it. Do not apply it directly to production.
