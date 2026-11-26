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

## Latest task report — 2026-11-26
- **Task:** Redesign the complete repository vision around restaurants and cinemas, and make the repository independently operable from any new chat.
- **Changes:** Rewrote PRODUCT_PLAN.md, BUSINESS_MODEL_RESERVED.md, TECHNICAL_ARCHITECTURE.md, SYSTEM_DESIGN.md, DEVELOPMENT_ROADMAP.md, SQUAD_CONTRACTS.md, API_CONTRACTS.md and DATABASE_SCHEMA.sql. Added README.md, AGENTS.md, COMMANDS.md, DISCOVERY_PLAYBOOK.md and MVP_SCORECARD.md.
- **Verification:** GitHub tree fetched after writes; all 14 expected Markdown/SQL files were present. README.md and CURRENT_STATE.md were fetched back and inspected. No application tests were run because this task changed documentation only.
- **Current state:** Documentation changes are on product/premium-hospitality-platform. PR #45 is the existing draft PR and must be updated to describe the new vision. No production feature, live venue pilot, measured savings, deployment or release is claimed.
- **Next action:** Update PR #45 metadata and inspect the final branch/PR diff and CI state. Do not merge.

## Decisions
- Target industries: restaurants and cinemas only.
- Shared platform; distinct domain models, state machines and workflows.
- Core guest journeys should work in a normal mobile browser without mandatory app installation.
- Measure staff minutes, queue time, throughput, errors, adoption and net operating benefit.
- Complete vertical slices; validate with real venues.
- Pricing, trial, plans, SLAs, providers and support commitments remain undecided.

## In progress
- [x] Rewrite product, architecture, system design, roadmap, squad, API and business model documentation.
- [x] Add chat-portable repository instructions and command protocol.
- [x] Add customer discovery playbook and MVP scorecard.
- [ ] Update and verify PR #45 metadata/diff.
- [ ] Create discovery backlog for both verticals.
- [ ] Select candidate pilot workflows based on evidence.

## Blocked / not approved
- Final MVP feature scope.
- Payment, POS, ticketing, printer, scanner and messaging providers.
- Database schema and production API contracts.
- Final framework/hosting choices.
- Pricing and commercial commitments.
- Production implementation and pilots.

## Historical boundaries
- PR #43 and PR #44 are legacy local-shop Product 1 work; do not merge or depend on them.
- PR #45 previously represented the premium restaurant/café menu direction; its body/title must be aligned to this new two-vertical vision.
- Do not copy legacy code without architecture and security review.

## Next product phase
Complete Phase 1 discovery separately for restaurants and cinemas. Map real workflows, quantify operating costs, validate buyer demand and define candidate MVP slices. Do not begin broad feature coding before PRD and architecture gates.

## Mandatory update after each meaningful task
- Task: requested outcome.
- Changes: exact files, commits and PRs.
- Verification: checks actually performed.
- Current state: completed, in progress, pending or blocked.
- Next action: one concrete next task.

Never claim tests, builds, releases, deployments, savings or venue validation without evidence.
