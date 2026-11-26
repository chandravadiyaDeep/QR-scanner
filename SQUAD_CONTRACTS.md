# Squad Contracts

Squads are responsibility boundaries; one person may hold multiple roles.

## Product Research & Strategy
Owns interviews, workflow observation, economics, personas, competitor review, PRD, prioritisation and metrics. Must distinguish observed, reported, estimated and hypothetical evidence.

## Restaurant Domain
Owns restaurant menus, tables, waitlists, orders, kitchen/fulfilment, staff workflows and analytics. Must define state machines, role matrix, exceptions and acceptance evidence. Does not own cinema semantics.

## Cinema Domain
Owns films, showtimes, auditoriums, seat inventory, holds, bookings, tickets, admission, concessions and cinema analytics. Must define concurrency invariants, ticket security, schedule rules and exception handling.

## Experience & Design
Owns guest, staff and manager UX, design system, accessibility, responsive behaviour and content. Must deliver tested prototypes and explicit loading/error/offline states.

## Platform & Integrations
Owns identity, tenancy, roles, API standards, data platform, audit, notifications, payment/provider adapters, CI/CD and observability. Must deliver ADRs, contracts, threat model, migrations and integration tests.

## QA, Security & Reliability
Owns test strategy, threat testing, concurrency, performance, accessibility, failure injection, release gates and incident readiness. Must provide reproducible evidence and release recommendation.

## Cross-squad contract
Every task states problem, business outcome, domain owner, dependencies, acceptance criteria, test evidence, risks and docs to update. Cross-domain changes require both domain owners and Platform review. No squad may weaken a domain invariant for implementation convenience.
