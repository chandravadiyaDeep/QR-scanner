# API Contracts

**Status:** No production API contract is approved. This document sets standards only.

## Standards
- Version public APIs (proposed prefix /api/v1).
- Maintain OpenAPI contracts.
- Validate inputs server-side and return consistent structured errors.
- Enforce tenant and role permissions on every protected operation.
- Use idempotency keys for order creation, booking confirmation and payment callbacks.
- Use cursor pagination, correlation IDs and audit metadata.
- Persist authoritative state before publishing realtime updates.
- Define rate limits and public endpoint abuse controls.

## Proposed namespaces
- Identity: authentication, memberships, invitations and roles.
- Restaurant: branches, tables, menus, availability, waitlists, orders, kitchen tickets and fulfilment.
- Cinema: venues, auditoriums, seats, films, showtimes, seat holds, bookings, tickets, admissions and concessions.
- Platform: media, notifications, audit, reporting and integrations.

Exact endpoints and payloads require approved PRD and state machines.

## Transaction requirements
Restaurant order submission is idempotent; validate availability and snapshot accepted prices; separate order, payment and fulfilment states.

Cinema seat holds are atomic and expire deterministically; confirmation cannot double-book; ticket credentials are unguessable/scoped/replay-resistant; admission validation is atomic.

Realtime messages notify clients of persisted state; clients refetch after reconnect. Webhooks require signature verification, idempotency and replay protection. Browser callbacks are not proof of payment.

Legacy local-shop API drafts are not approved contracts for this platform.
