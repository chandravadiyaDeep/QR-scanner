# Current Project State — Mandatory Handoff

**Read this file first in every new chat or agent session.** Then read AGENTS.md and COMMANDS.md.

## Repository
https://github.com/chandravadiyaDeep/QR-scanner

Active working branch: product/premium-hospitality-platform  
Default branch: main  
Execution preference: GitHub-first. Use connected GitHub tools where possible; do not ask the owner to use a local terminal unless hardware or unavailable credentials make it necessary.

## Approved vision
Exactly two target verticals:
1. Restaurant OS.
2. Cinema OS.

Reduce avoidable operational costs and guest friction: manual order-taking, repetitive staff work, queues, order/booking errors, slow fulfilment and poor operational visibility. Preserve human support and service quality.

## State at 2026-11-26
- Two-vertical vision and operating documentation reset are being applied on the active branch.
- Previous premium restaurant/café menu-only direction is superseded.
- No production-ready Restaurant OS or Cinema OS implementation is verified.
- No live venue pilot, measured savings, production deployment or release is claimed.
- DATABASE_SCHEMA.sql is comments-only; do not apply.
- API_CONTRACTS.md contains standards only; no production endpoints are approved.
- Next.js, Flutter, FastAPI and Supabase are provisional candidates, not locked.

## Historical boundaries
- PR #43 and PR #44 are legacy local-shop Product 1 work; do not merge or depend on them.
- PR #45 was the previous premium restaurant/café documentation reset and is superseded by this two-vertical direction. Inspect live GitHub state; do not assume it is merged.
- Do not copy legacy code without architecture and security review.

## Decisions
- Target industries: restaurants and cinemas only.
- Shared platform; distinct domain models, state machines and workflows.
- Core guest journeys should work in a normal mobile browser without mandatory app installation.
- Measure staff minutes, queue time, throughput, errors, adoption and net operating benefit.
- Complete vertical slices; validate with real venues.
- Pricing, trial, plans, SLAs, providers and support commitments remain undecided.

## In progress
- [ ] Verify documentation reset commit and PR.
- [ ] Inspect complete source tree, branch and open PR state.
- [ ] Create discovery backlog for both verticals.
- [ ] Select candidate pilot workflows based on evidence.

## Blocked / not approved
- Final MVP feature scope.
- Payment, POS, ticketing, printer, scanner and messaging providers.
- Database schema and production API contracts.
- Final framework/hosting choices.
- Pricing and commercial commitments.
- Production implementation and pilots.

## Next action
Complete Phase 1 discovery separately for restaurants and cinemas. Map real workflows, quantify operating costs, validate buyer demand and define candidate MVP slices. Do not begin broad feature coding before PRD and architecture gates.

## Mandatory update after each meaningful task
- Task: requested outcome.
- Changes: exact files, commits and PRs.
- Verification: checks actually performed.
- Current state: completed, in progress, pending or blocked.
- Next action: one concrete next task.

Never claim tests, builds, releases, deployments, savings or venue validation without evidence.
