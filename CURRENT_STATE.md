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

Reduce avoidable operating costs and guest friction: manual order-taking, repetitive staff work, queues, order/booking errors, slow fulfilment and poor operational visibility. Preserve human support and service quality.

## Latest task report — 2026-11-26
- **Task:** Redesign repository vision for restaurants and cinemas and make it independently operable from any new chat.
- **Changes:** Rewrote PRODUCT_PLAN.md, BUSINESS_MODEL_RESERVED.md, TECHNICAL_ARCHITECTURE.md, SYSTEM_DESIGN.md, DEVELOPMENT_ROADMAP.md, SQUAD_CONTRACTS.md, API_CONTRACTS.md and DATABASE_SCHEMA.sql. Added README.md, AGENTS.md, COMMANDS.md, DISCOVERY_PLAYBOOK.md and MVP_SCORECARD.md. Updated PR #45 title and description.
- **Verification:** GitHub tree fetched after writes; all 14 expected files are present. README.md and CURRENT_STATE.md fetched back and inspected. Compare main...branch reports 24 commits ahead and 0 behind. Combined commit status returned no status entries. PR #45 reports mergeable=false despite no branch-behind commits; exact mergeability cause is not established. Documentation-only task; no application tests run.
- **Current state:** Changes are on product/premium-hospitality-platform at commit 0364211449e2abeb984fbf1db2ac4331292b5698 before this final handoff update. PR #45 is open and draft. No production feature, venue pilot, measured savings, deployment or release is claimed.
- **Next action:** Inspect PR #45 mergeability/checks in GitHub and resolve any reported conflict or policy issue before requesting review. Do not merge without explicit permission.

## Decisions
- Target industries: restaurants and cinemas only.
- Shared platform; distinct domain models, state machines and workflows.
- Core guest journeys should work in a normal mobile browser without mandatory app installation.
- Measure staff minutes, queue time, throughput, errors, adoption and net operating benefit.
- Complete vertical slices; validate with real venues.
- Pricing, trial, plans, SLAs, providers and support commitments remain undecided.

## In progress
- [x] Rewrite product, business model, architecture, system design, roadmap, squad and API guidance.
- [x] Keep database schema comments-only pending domain/security approval.
- [x] Add README, agent instructions, chat command protocol, discovery playbook and MVP scorecard.
- [x] Update PR #45 title and description for the two-vertical vision.
- [ ] Resolve PR #45 mergeable=false state and review checks.
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
- PR #45 previously represented the restaurant/café-only direction; its current title/body now reflect the two-vertical strategy.
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
