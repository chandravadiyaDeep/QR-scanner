# Technical Architecture

**Status:** Proposed architecture only. Validate through discovery and technical proofs before locking.

## Goals
Two distinct operational domains on a secure shared foundation. Priorities: transaction correctness, tenant isolation, peak-load reliability, fast guest flows, observability and maintainability.

## Logical components
- Guest web experiences: mobile-first restaurant and cinema flows in normal browsers.
- Business workspace: owner/manager configuration, live operations and reporting.
- Staff interface: order/kitchen/waitlist tools and ticket scanning/exception handling.
- Backend API: FastAPI is a candidate; modular domains and versioned contracts.
- Data: PostgreSQL/Supabase is a candidate; verify transaction, backup, recovery and scale needs.
- Realtime/event delivery: notifications of persisted state; database remains authoritative.
- Object storage for media; provider adapters for notifications, payments, printers, POS, ticketing and scanners.

## Domain boundaries
- Restaurant: branches, tables, menus, availability, waitlists, orders, kitchen tickets and fulfilment.
- Cinema: locations, auditoriums, seats, films, showtimes, seat inventory, holds, bookings, tickets, admissions and concessions.
- Identity: tenants, users, memberships, roles and invitations.
- Platform: audit, media, notifications, reporting, feature flags and integrations.

Do not force restaurant and cinema into one generic order/booking model where invariants differ.

## Critical invariants
**Restaurant:** order submission idempotent; accepted prices and item details snapshotted; kitchen ticket linked to source order; validated/audited state transitions; concurrency-safe table/waitlist operations; payment and fulfilment states separate.

**Cinema:** at most one active confirmed booking per seat/showtime; atomic temporary holds with expiry; safe payment/booking reconciliation; secure ticket token and replay-resistant admission; explicit cancellation/refund states; schedule changes reconcile affected inventory and notify under approved policy.

## Security
Server-side tenant and role enforcement; public endpoints expose published data only; secrets never in source/client bundles; rate limits and abuse controls; secure QR/ticket credentials; audit trails; retention/deletion rules; minimal guest data; provider-hosted/tokenised payments only; threat model seat races, duplicate orders, QR tampering, ticket replay, account compromise and tenant escape.

## Reliability
Idempotent writes and retries; database constraints for invariants; transactions for multi-row workflows; durable outbox where required; degraded-mode behaviour; monitoring for queue depth, failed events, booking conflicts, payment reconciliation and notification delays; backups and restore drills; migration rollback; load tests for meal rushes and showtime peaks.

## Candidate stack
Previous discussions proposed Next.js guest web, Flutter owner app, FastAPI and Supabase. This is provisional, not locked. Validate staff devices/offline needs, realtime guarantees, seat concurrency, payment flows, integration requirements and load behaviour first.

## Delivery
Separate test/staging/production; managed secrets; CI for formatting, lint, types, unit/integration/security/build; reviewed migrations; feature flags; controlled pilots; rollback, monitoring and support runbooks.

Create ADRs for framework, realtime, database, payments, ticket QR security, printer/POS, offline behaviour and hosting. Include alternatives, evidence, risks and approval.
