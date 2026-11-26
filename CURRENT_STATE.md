# Premium Hospitality Menu Platform — Current State & Handoff

> **ACTIVE PRODUCT: PRODUCT 2 ONLY.**
>
> This repository is dedicated to a premium digital menu and guest-experience platform for quality-focused restaurants, cafés, and hospitality businesses with an initial target average spend above ₹200 per person.
>
> Product 1 — the free, offline-first local-shop menu app — is a separate independent project. Its vision, requirements, offline-first assumptions, free-until-10,000-shops promise, roadmap, code, and release work must not be continued in this repository.

**Last updated:** 2026-11-26  
**Repository:** [chandravadiyaDeep/QR-scanner](https://github.com/chandravadiyaDeep/QR-scanner)  
**Active product branch:** `product/premium-hospitality-platform`  
**Product owner:** User  
**Engineering operating model:** GitHub-first implementation, pull requests, automated CI, documented evidence.

---

## 1. Mandatory project rules

1. Read this file and the active source-of-truth documents before every implementation task.
2. The active scope authority is `PRODUCT_PLAN.md`.
3. The active provisional architecture is `TECHNICAL_ARCHITECTURE.md`; confirm decisions through discovery and architecture review before implementation.
4. This repository serves Product 2 only. Never bring Product 1's free local-shop product logic into this project.
5. Do not assume ordering, payments, reservations, table management, POS integrations, loyalty, or multi-location functionality. These require discovery and explicit approval.
6. The initial target segment is quality-focused restaurants and cafés with average spend above ₹200 per person. This is a market-positioning filter, not a hard-coded eligibility check.
7. Prioritize polished guest experience, performance, accessibility, operational reliability, security, and test evidence.
8. Use GitHub branches, pull requests, and GitHub Actions. Do not require local IDE or terminal work from the product owner for routine development.
9. Never commit secrets or request credentials in chat.
10. Do not claim a feature, build, test, deployment, or release succeeded without exact evidence.
11. Keep PRs draft until their defined tests and acceptance gates pass.
12. After every meaningful task, update this file with the task, changes, verification, current state, and next action.

## 2. Product 2 — approved direction

### Target users
- Quality-focused restaurants.
- Specialty and premium cafés.
- Premium casual dining and boutique hospitality venues.
- Initial average spend target: above ₹200 per person.

### Product promise
A high-quality, brand-conscious digital menu and guest experience that a restaurant is proud to present to its customers.

### Core experiences
- Restaurant owner/staff management workspace.
- Premium mobile-first guest menu opened by scanning a QR code in a normal browser.
- Stable HTTPS menu destination.
- High-quality visual presentation, clear item information, optimized imagery, and reliable publishing.
- Secure restaurant-scoped access and published-only public data.

### Candidate technology direction
The earlier product discussion identified Flutter for the management app, Next.js for the public guest menu, FastAPI for trusted application services, and Supabase for authentication, PostgreSQL, and media storage. This remains a candidate baseline to validate—not an instruction to reuse Product 1 code.

### Decisions still requiring discovery/approval
- Exact MVP and V1 feature list.
- Restaurant versus multi-location domain model.
- Menu, daypart, section, item, variant, modifier, and dietary/allergen requirements.
- Staff roles and approval workflows.
- Language and branding capabilities.
- Analytics scope and privacy policy.
- Table-specific QR requirements.
- Whether reservations, ordering, payments, or integrations belong in scope.
- Commercial packaging, pricing, trial, and support commitments.
- Performance, availability, and recovery targets.

## 3. Product 1 — explicitly separate

Product 1 is the free offline-first local-shop application. It has its own standalone master prompt delivered to the product owner and must be developed in a separate project/repository.

Do not:
- Apply the 10,000-shop free-access milestone here.
- Make offline-first local data management the defining architecture here.
- optimize Product 2 for micro-shop simplicity at the expense of the premium hospitality experience.
- Reuse Product 1's source code, backend, database, schema, CI, or deployment without an explicit technical review and approval.
- Mix Product 1 issues, branches, pull requests, or releases into Product 2.

## 4. Source-of-truth documents

| File | Status |
|---|---|
| `PRODUCT_PLAN.md` | Active Product 2 scope |
| `BUSINESS_MODEL_RESERVED.md` | Product 2 commercial decisions remain undecided |
| `TECHNICAL_ARCHITECTURE.md` | Product 2 provisional architecture and guardrails |
| `SYSTEM_DESIGN.md` | Product 2 high-level system boundary |
| `DEVELOPMENT_ROADMAP.md` | Discovery-first Product 2 roadmap |
| `SQUAD_CONTRACTS.md` | Product 2 workstream ownership |
| `API_CONTRACTS.md` | Legacy Product 1 contract; Product 2 contract not yet approved |
| `DATABASE_SCHEMA.sql` | Legacy Product 1 schema; do not apply to Product 2 |

The Product 2 API and database design must be created from the approved domain model. The old local-shop API and SQL schema are not valid starting contracts.

## 5. Legacy Product 1 implementation — do not merge into Product 2

The following work was started before the product split and belongs to Product 1:

- PR #43: [Backend/database foundation](https://github.com/chandravadiyaDeep/QR-scanner/pull/43).
- PR #44: [Flutter local-shop owner app foundation and APK pipeline](https://github.com/chandravadiyaDeep/QR-scanner/pull/44).
- Branches: `feat/milestone-1-backend-foundation` and `feat/flutter-owner-app-foundation`.

These pull requests are historical Product 1 work. They are not Product 2 foundations and must not be merged into the active Product 2 branch. Keep them separate until the Product 1 project is established and its owner decides how to continue them.

The PR #44 Material import repair commit `a4a0d232003be67e9abae9547d00aadc3fce9c21` belongs to that legacy Product 1 branch; it does not establish Product 2 build readiness.

## 6. Current Product 2 repository status

- A dedicated branch `product/premium-hospitality-platform` has been created from `main`.
- Product 2 scope and commercial strategy documents have been rewritten.
- Product 2 technical architecture and system design are explicitly provisional and discovery-led.
- Product 2 roadmap and squad contracts have been established.
- Old local-shop API contracts and SQL schema have been marked legacy and must not be used.
- No Product 2 application feature is yet claimed as implemented or tested.
- No Product 2 APK, production deployment, or external test session is claimed.

## 7. Immediate next steps

1. Review and approve the Product 2 positioning and target segment.
2. Conduct discovery with target restaurants and cafés.
3. Produce a detailed PRD and prioritize the first release.
4. Design guest journey, menu information architecture, and premium visual system.
5. Validate the candidate Flutter + Next.js + FastAPI + Supabase architecture.
6. Produce Product 2 domain model, ERD, API contracts, threat model, and quality targets.
7. Only then begin implementation in independent vertical slices.

## 8. Required progress report format

After each meaningful task, update this file and report:

- **Task:** What was done and why.
- **Changes:** Files, product decisions, code, or infrastructure changed.
- **Verification:** Exact checks and evidence; never claim unrun tests.
- **Current state:** What is complete and what remains unverified.
- **Next action:** The next dependency-ordered task.

---

## Progress log — 2026-11-26: Product separation and repository reset

- **Task:** Split the former combined local-shop concept into two independent products and dedicate this repository to the premium restaurant/café platform.
- **Changes:** Replaced the product plan, commercial direction, provisional architecture, system design, roadmap, and squad contracts; marked the old API contract and database schema as Product 1 legacy.
- **Verification:** Created branch `product/premium-hospitality-platform` from `main`; committed the Product 2 documentation reset. No application build or feature test is claimed.
- **Current state:** This branch now defines Product 2 only. PR #43 and PR #44 remain legacy Product 1 work and are not approved dependencies.
- **Next action:** Review Product 2 positioning, conduct target-customer discovery, and approve the detailed PRD before coding.
