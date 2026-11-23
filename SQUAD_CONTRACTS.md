# Squad Contracts — QR Digital Menu

**Purpose:** define clear ownership, interfaces, deliverables, and completion rules for parallel engineering. Squads are workstreams; one contributor may temporarily cover multiple roles, but ownership boundaries remain explicit.

## 1. Operating model

The assistant is the primary technical implementer and engineering coordinator: code, configuration, migrations, tests, integration, debugging, and documentation are handled as part of the implementation workflow. The product owner makes product decisions and approves meaningful scope changes.

No squad may independently expand scope. The source of truth is [PRODUCT_PLAN.md](./PRODUCT_PLAN.md).

## 2. Squad map

| Squad | Mission | Owns |
|---|---|---|
| A — Android Owner App | Build the shop-owner Android experience | Flutter app, screens, local state, API client, QR export/share |
| B — Public Menu Web | Build customer browser menu | Next.js route, responsive themes, language display, accessibility |
| C — Backend & Data | Build secure application services | FastAPI, PostgreSQL migrations, auth verification, storage, publishing, analytics |
| D — QA, Security & Release | Verify integrated product | Test plans, automation, security checks, device/browser tests, release gates |
| Architecture/Product | Keep system coherent | Scope, architecture, contract approval, cross-squad decisions, release coordination |

## 3. Squad A — Android Owner App

### Scope
- Flutter project and navigation.
- Supabase Auth integration.
- Shop onboarding and profile.
- Dashboard and publication state.
- Category and item editor.
- Prices, availability, sorting, and images.
- Gujarati/Hindi/English content entry.
- Branding and approved theme selection.
- Customer preview.
- QR generation, save, and share.
- WhatsApp/device link sharing.
- Basic analytics display.

### Required outputs
- Installable debug APK for each integrated milestone.
- Typed API client generated or maintained from the agreed OpenAPI schema.
- Widget/unit tests for validation and core flows.
- Loading, empty, error, offline, and expired-session handling.
- Android test notes and screenshots for key screens.

### Non-goals
- Customer menu rendering.
- Direct privileged database access.
- Payment, ordering, loyalty, AI content, subscriptions.

## 4. Squad B — Public Menu Web

### Scope
- Next.js `/m/[shopSlug]` route.
- Mobile-first responsive layout.
- Theme rendering for approved theme keys.
- Language selection and fallback.
- Public menu loading, not-found, unpublished, and error states.
- Share metadata and accessible semantic HTML.
- Fast rendering and safe cache revalidation.

### Required outputs
- Deployed staging URL.
- Browser/device test evidence.
- Responsive screenshots at narrow phone and common phone widths.
- Tests for language fallback, unavailable items, empty categories, and missing images.

### Non-goals
- Owner login/dashboard.
- Menu writes or draft preview for anonymous users.
- Cart, ordering, checkout, payment, customer accounts.

## 5. Squad C — Backend & Data

### Scope
- FastAPI app structure and versioned REST API.
- Supabase JWT validation.
- Shop membership and role authorization.
- PostgreSQL schema and repeatable migrations.
- Shop/menu/category/item/translation CRUD.
- Draft preview and publish/unpublish.
- Public sanitized menu DTO.
- Image upload authorization.
- Privacy-minimized analytics.
- OpenAPI, API tests, structured logs, rate limiting, deployment configuration.

### Required outputs
- Migration SQL and verification evidence.
- OpenAPI document.
- API environment and deployment instructions.
- Unit/integration tests, including tenant isolation.
- Seed data for local/staging development.
- Rollback guidance.

### Non-goals
- Flutter or Next.js visual implementation.
- Monetization and V2 functionality.

## 6. Squad D — QA, Security & Release

### Scope
- Acceptance-test traceability to PRODUCT_PLAN.md.
- API success and error contract tests.
- Cross-shop authorization tests.
- Public data exposure checks.
- QR scan-to-browser end-to-end tests.
- Android physical-device checks.
- iOS/Android browser checks for public menu.
- Accessibility, performance, and slow-network checks.
- Release checklist, defect triage, regression suite.

### Required outputs
- Test plan and repeatable test cases.
- Defect reports with steps, expected/actual result, logs/screenshots.
- Security checklist and evidence.
- Release recommendation based on pass/fail gates.

### Independence
QA does not approve a feature solely because the implementing squad says it works. Acceptance evidence must be reproducible.

## 7. Cross-squad interface contracts

| Producer | Contract artifact | Consumer |
|---|---|---|
| Backend & Data | OpenAPI v1, response fixtures, staging API | Android and Public Web |
| Android | Screens, request behavior, APK, test evidence | QA and Backend |
| Public Web | Public route, responsive states, browser tests | QA and Backend |
| QA | Test results and reproducible defects | All squads |
| Architecture/Product | Scope, decisions, API/schema approval | All squads |

### Integration rules
1. Agree request/response schemas before connecting real clients.
2. Use mock fixtures generated from API contracts while backend work proceeds.
3. Do not invent endpoint paths or JSON fields in client code.
4. Breaking API changes require a contract update and coordinated consumer changes.
5. Every pull request lists affected squad, scope, tests run, screenshots/logs, and known limitations.
6. No hard-coded secrets, local machine paths, or production credentials.
7. Merge only after CI passes and relevant contract tests pass.
8. A UI that calls a mock API is not an end-to-end completed feature.

## 8. Shared definition of done

A work item is complete only when:
- Acceptance criteria are met.
- Code is committed in a focused pull request.
- Automated tests are added/updated and pass.
- Relevant manual/device/browser checks are recorded.
- Error and empty states are handled.
- Authorization and data privacy implications are reviewed.
- Documentation/configuration is updated.
- No unapproved V2 or monetization scope is introduced.

## 9. Dependency and escalation rules

- Backend defines schemas early; client squads may build against approved mocks.
- Backend migration changes must be reviewed before dependent endpoints merge.
- Public Web consumes only the public menu DTO.
- Android consumes authenticated owner endpoints; it never queries privileged tables directly.
- QA receives a staging build and test accounts before release gates.
- If a requirement conflicts with PRODUCT_PLAN.md, pause that work item and request a product decision rather than silently changing scope.

## 10. Product owner decision boundary

The product owner should focus on:
- Approving product behavior and scope changes.
- Reviewing UX direction and real-shop feedback.
- Resolving business/product trade-offs.
- Approving public launch and any irreversible external actions.

Routine implementation details, code, stack configuration, tests, migrations, refactoring, and technical integration are handled by the engineering workflow without asking the product owner to write code.
