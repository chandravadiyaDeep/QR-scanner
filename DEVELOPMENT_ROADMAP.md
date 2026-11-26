# Development Roadmap

Deliver complete vertical slices, not disconnected screens. Discovery precedes broad implementation.

## Phase 0 — Repository alignment
Establish source-of-truth docs, inspect branches/PRs/CI, isolate legacy work, define chat-portable operating protocol.
**Exit:** verified project state, active branch and risk list.

## Phase 1 — Customer discovery
Separate restaurant and cinema tracks. Interview owners, managers, frontline staff and guests; observe normal and peak periods; map current workflows and exceptions; quantify staff time, queueing, errors, abandonment and existing software costs; review existing systems.
**Exit:** evidence-backed problem statements, personas, workflow maps, baseline metrics and pilot candidates.

## Phase 2 — PRD and MVP
Prioritise by frequency, cost, severity, evidence, feasibility and risk. Select one complete workflow per vertical. Define in/out scope, acceptance criteria, privacy, support and measurable pilot outcomes.
**Exit:** approved PRD and pilot success criteria.

## Phase 3 — UX prototype
Create sitemap, design system and high-fidelity guest/staff/manager prototypes for both verticals. Test accessibility, language, devices and network conditions.
**Exit:** tested prototype and approved interaction contracts.

## Phase 4 — Architecture and risk proof
Domain models, state machines, API contracts, ADRs, threat model, tenant isolation, restaurant idempotent-order proof, cinema concurrent-seat-hold proof, provider integration review, load and recovery tests.
**Exit:** approved architecture and risk register.

## Phase 5 — Shared platform
Identity, tenancy, roles, audit, media, notification/configuration foundations, CI/CD, observability, migrations and backups.
**Exit:** tested platform with tenant-isolation evidence.

## Phase 6 — Restaurant vertical slice
Build only the approved pilot workflow end-to-end, including guest, staff, manager, API, data, notifications, analytics and exception paths.
**Exit:** acceptance-tested restaurant pilot.

## Phase 7 — Cinema vertical slice
Build only the approved pilot workflow end-to-end. Seat inventory and ticket validation require concurrency, replay and abuse testing.
**Exit:** acceptance-tested cinema pilot.

## Phase 8 — Controlled pilots
Onboard selected venues with support plan; measure baseline/post-launch; review incidents, adoption, staff feedback and guest completion.
**Exit:** evidence-backed operational value review.

## Phase 9 — Commercial readiness
Approve pricing, contracts, support and SLAs; harden integrations, exports and incident response; expand only after pilot gates.

## Prioritisation
Score impact, frequency, pain, evidence confidence, strategic fit, feasibility, risk and dependency load. Safety, financial and concurrency blockers cannot be averaged away.

## Release gates
Tests, security review, migration/rollback, monitoring, support runbook, accessibility, load evidence for critical flows, pilot acceptance and truthful release notes.
