# Squad Contracts — Premium Restaurant & Café Menu Platform

> Applies only to Product 2 in this repository.
> Product 1 has its own independent project and team plan.

## 1. Operating model

The product owner owns product direction and approves scope. Engineering coordinates architecture, implementation, integration, quality, and release. Squads are workstreams with explicit ownership and contracts.

No squad may silently expand scope or assume unapproved hospitality workflows.

## 2. Squad map

| Squad | Mission | Owns |
|---|---|---|
| Product & Research | Validate target hospitality segment | Interviews, requirements, prioritization, acceptance criteria |
| Experience & Design | Deliver premium guest and operator UX | Research, information architecture, design system, prototypes, accessibility |
| Restaurant Workspace | Build authenticated management experience | Owner/staff flows, menu editing, preview, publishing controls |
| Guest Experience | Build public digital menu | QR landing, mobile menu, visual presentation, performance |
| Platform & Data | Build secure platform services | Domain model, API, database, auth, media, publishing, analytics |
| QA & Reliability | Prove release quality | Automation, security, performance, browser/device tests, pilot validation |

## 3. Contract rules

1. Requirements and designs are approved before implementation.
2. API and domain contracts are agreed before client integration.
3. Guest-facing screens use only public, published data.
4. Protected operations enforce server-side restaurant/location membership.
5. Media and QR flows have explicit acceptance tests.
6. Every pull request includes tests and evidence appropriate to its risk.
7. QA independently verifies critical workflows.
8. No feature is complete solely because the implementing squad reports success.

## 4. Required outputs

- Product & Research: validated PRD, personas, opportunity map, release scope.
- Experience & Design: sitemap, flows, design system, prototype, accessibility rules.
- Restaurant Workspace: integrated management workflows and automated tests.
- Guest Experience: responsive public menu, performance evidence, browser tests.
- Platform & Data: approved schema, API contracts, migrations, security tests.
- QA & Reliability: traceable test plan, defect reports, regression evidence, release recommendation.

## 5. Independence from Product 1

Do not reuse Product 1's free local-shop workflows, offline-first data assumptions, code, or backend without a documented review and explicit approval.