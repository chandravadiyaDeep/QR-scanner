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

## Latest task report — 2026-11-27
- **Task:** Capture the user's physical-layout and QR-label logic as a separate, detailed brainstorming specification for restaurants and cinemas.
- **Changes:** Added PHYSICAL_ASSET_QR_IDENTITY_SYSTEM.md with domain-specific layout hierarchies, asset/credential separation, QR generation and selection, duplex/single-sided printing, reprint vs rotation rules, recovery scenarios, security, feature backlog, decision log, prototype acceptance criteria and Mermaid mind maps for both verticals plus a shared workflow. Updated README.md to link the new document.
- **Verification:** New file was created on the active branch. README.md update is being recorded. No application code or tests were changed/run.
- **Current state:** Product brainstorming document is separate from the core PRD; its features are candidates, not approved MVP commitments. The key design rule is that reprinting preserves the active QR credential; credential rotation is a separate audited action. Cinema fixed seat QR is explicitly separate from booking-specific ticket QR.
- **Next action:** Review the QR identity prototype with restaurant and cinema operators, resolve open decisions in the document, then update MVP scope before implementation.

## Previous task report — 2026-11-26
- **Task:** Redesign repository vision for restaurants and cinemas and make it independently operable from any new chat.
- **Changes:** Rewrote PRODUCT_PLAN.md, BUSINESS_MODEL_RESERVED.md, TECHNICAL_ARCHITECTURE.md, SYSTEM_DESIGN.md, DEVELOPMENT_ROADMAP.md, SQUAD_CONTRACTS.md, API_CONTRACTS.md and DATABASE_SCHEMA.sql. Added README.md, AGENTS.md, COMMANDS.md, DISCOVERY_PLAYBOOK.md and MVP_SCORECARD.md. Updated PR #45 title and description.
- **Verification:** GitHub tree fetched after writes; all expected files were present. Compare main...branch reported 24 commits ahead and 0 behind at that point. PR #45 is open/draft and GitHub reported mergeable=false; exact cause was not established. Documentation-only task; no application tests run.
- **Current state:** Changes are on product/premium-hospitality-platform. No production feature, venue pilot, measured savings, deployment or release is claimed.
- **Next action:** Inspect PR #45 mergeability/checks and resolve any reported conflict or policy issue before requesting review. Do not merge without explicit permission.

## Decisions
- Target industries: restaurants and cinemas only.
- Shared platform; distinct domain models, state machines and workflows.
- Core guest journeys should work in a normal mobile browser without mandatory app installation.
- Measure staff minutes, queue time, throughput, errors, adoption and net operating benefit.
- Complete vertical slices; validate with real venues.
- Pricing, trial, plans, SLAs, providers and support commitments remain undecided.
- Physical locations/seats have stable internal identities; QR credentials are replaceable and separately managed.
- Reprinting the same active QR does not rotate its credential.
- Cinema fixed seat identity QR is not an admission ticket; ticket QR is booking-specific.

## In progress
- [x] Two-vertical vision and chat-portable repository instructions.
- [x] Separate physical asset and QR identity brainstorming document.
- [x] Link the QR identity document from README.
- [ ] Review the QR workflows with actual restaurant/cinema operators.
- [ ] Resolve MVP feature scope and select pilot workflows.
- [ ] Inspect PR #45 mergeability/checks.

## Blocked / not approved
- Final MVP feature scope.
- Payment, POS, ticketing, printer, scanner and messaging providers.
- Database schema and production API contracts.
- Final framework/hosting choices.
- Pricing and commercial commitments.
- Production implementation and pilots.
- Final QR label size, paper stock, duplex alignment behaviour and printer support.

## Historical boundaries
- PR #43 and PR #44 are legacy local-shop Product 1 work; do not merge or depend on them.
- PR #45 is the two-vertical documentation reset, open/draft at last verification; inspect live state before branch decisions.
- Do not copy legacy code without architecture and security review.

## Next product phase
Complete Phase 1 discovery separately for restaurants and cinemas. Use PHYSICAL_ASSET_QR_IDENTITY_SYSTEM.md as a candidate concept for interview/prototype validation. Do not start broad feature coding before PRD and architecture gates.

## Mandatory update after each meaningful task
- Task: requested outcome.
- Changes: exact files, commits and PRs.
- Verification: checks actually performed.
- Current state: completed, in progress, pending or blocked.
- Next action: one concrete task.

Never claim tests, builds, releases, deployments, savings or venue validation without evidence.
