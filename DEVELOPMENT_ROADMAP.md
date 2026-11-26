# Development Roadmap — Premium Restaurant & Café Menu Platform

> Active roadmap for Product 2 only.
> Scope authority: [PRODUCT_PLAN.md](./PRODUCT_PLAN.md).
> Architecture direction: [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md).

## Delivery philosophy

This product is intentionally quality-led. Do not rush into CRUD implementation before validating the target customer, guest experience, domain model, and non-functional requirements.

The roadmap is gated. Each phase must have evidence before the next phase expands scope.

## Phase 0 — Product separation and repository reset

- Establish this repository as Product 2 only.
- Keep Product 1 in its own independent project.
- Mark Product 1's old PRs, code, schema, and assumptions as legacy.
- Establish the new product brief and decision log.

Exit gate: no ambiguity about which product this repository serves.

## Phase 1 — Customer and market discovery

- Interview restaurant owners, café owners, managers, and guests.
- Validate the ₹200+ average-spend target segment.
- Understand current menu, QR, and service workflows.
- Identify high-value pain points and purchase drivers.
- Review competitor experiences and alternatives.
- Prioritize capabilities by guest value and operational value.

Deliverables: research summary, personas, jobs-to-be-done, opportunity map, prioritized requirements.

Exit gate: product owner approves the target users and initial release scope.

## Phase 2 — Guest experience and design system

- Define guest menu information architecture.
- Map QR-to-menu guest journey.
- Create high-fidelity mobile-first screens.
- Define typography, color, spacing, image, motion, and accessibility rules.
- Prototype restaurant workspace flows.
- Test prototypes with target users.

Deliverables: sitemap, user flows, design system, interactive prototype, usability findings.

Exit gate: design quality and usability approved before large-scale implementation.

## Phase 3 — Domain and architecture design

- Define restaurant/location/menu domain boundaries.
- Decide menu, section, item, translation, media, and publication models.
- Decide staff roles and authorization.
- Define public and authenticated API contracts.
- Design data isolation, caching, media delivery, and observability.
- Define performance, accessibility, security, backup, and recovery targets.

Deliverables: architecture decision records, ERD, API contract, threat model, test strategy.

Exit gate: technical design reviewed and approved.

## Phase 4 — Engineering foundation

- Set up application structure and environments.
- Configure CI and code quality gates.
- Establish database migration workflow.
- Add authentication and tenant authorization.
- Add observability and error reporting.
- Build design-system primitives.

Exit gate: secure foundation with automated tests and reproducible deployment.

## Phase 5 — Vertical product slices

Implement in end-to-end slices, not disconnected mock screens:
1. Restaurant onboarding and workspace access.
2. Menu structure and content management.
3. Media upload and optimized guest delivery.
4. Preview and safe publishing.
5. Public guest menu and stable QR destination.
6. Approved language, branding, and discovery-prioritized capabilities.
7. Approved analytics and integrations, if included.

Each slice requires API, UI, tests, documentation, and acceptance evidence.

## Phase 6 — Quality engineering

- Unit, contract, integration, and end-to-end tests.
- Cross-tenant security testing.
- Browser and device matrix.
- Accessibility audit.
- Performance and load testing.
- Image and cache regression testing.
- Failure-mode and recovery testing.
- Real restaurant pilot testing.

Exit gate: all release-blocking defects closed and acceptance metrics met.

## Phase 7 — Controlled pilot and release

- Onboard a small group of target restaurants.
- Observe actual service-hour usage.
- Collect owner and guest feedback.
- Measure menu load and reliability.
- Fix defects and refine onboarding.
- Prepare versioned production release and rollback plan.

Do not declare launch readiness from CI alone.

## Operating rules

- Use GitHub issues, feature branches, pull requests, and GitHub Actions.
- Keep work in small reviewable vertical slices.
- Do not merge Product 1 code or PRs into this product.
- Update CURRENT_STATE.md after every meaningful task.
- Do not invent requirements when discovery is incomplete.
- Product owner approves material scope and commercial decisions.