# QR Digital Menu

A shop-owner Android app and browser-based public menu opened from a stable QR URL.

## Repository layout

- `apps/api`: FastAPI backend (first implementation milestone).
- `apps/mobile`: planned Flutter owner application.
- `apps/web`: planned Next.js public menu.
- `database/migrations`: ordered PostgreSQL migrations.
- `docs`: product, architecture, API, squad, and delivery contracts.

## Backend quick start

1. Install Python 3.11+.
2. From `apps/api`, create and activate a virtual environment.
3. Install the package: `pip install -e '.[dev]'`.
4. Copy `.env.example` to `.env` and set development Supabase/PostgreSQL values.
5. Run the API: `uvicorn app.main:app --reload`.
6. Open `/docs` for generated OpenAPI documentation.

The API requires a configured Supabase JWKS endpoint and PostgreSQL database. No secrets are committed. Apply migrations only to a disposable/development Supabase project until RLS and tenant-isolation tests pass.

## Product boundary

Customers scan a QR code and browse the published menu in their browser. No customer account, app installation, ordering, payments, subscriptions, loyalty, or AI menu generation are part of this release.
