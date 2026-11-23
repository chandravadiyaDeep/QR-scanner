# Development Roadmap — QR Digital Menu

**Release target:** combined MVP + V1 from [PRODUCT_PLAN.md](./PRODUCT_PLAN.md).  
**Architecture:** [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md) and [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md).  
**API contract:** [API_CONTRACTS.md](./API_CONTRACTS.md).  
**Squad ownership:** [SQUAD_CONTRACTS.md](./SQUAD_CONTRACTS.md).

This roadmap sequences implementation dependencies. It does not reduce the approved feature scope. The tasks below are written as GitHub-issue-ready work items. Create/track them as issues and link pull requests to them; do not mark them complete until acceptance evidence exists.

## 1. Delivery strategy

Backend/database foundation is built and verified first. Flutter and Next.js can proceed in parallel against the approved OpenAPI contract and mock fixtures. Integration begins as soon as stable endpoints are available.

### Workstreams
- **Foundation:** repository, CI, environment configuration, contracts.
- **Backend/Data:** schema, auth, tenancy, menu API, public API, analytics.
- **Android:** owner workflows.
- **Public Web:** customer menu.
- **QA/Release:** tests, security, device/browser verification.

## 2. Phase gates

| Phase | Goal | Exit gate |
|---|---|---|
| 0 | Repo and engineering foundation | CI, environment templates, OpenAPI skeleton |
| 1 | Database/auth/tenancy | Shop onboarding and tenant isolation verified |
| 2 | Menu CRUD and publishing | Draft and publish flows work through API |
| 3 | Public menu and QR | Real QR scan opens browser menu without app |
| 4 | Combined V1 capabilities | Languages, branding, themes, sharing, analytics pass |
| 5 | Hardening and pilot | Security, performance, accessibility, real-shop tests pass |

## 3. GitHub issue backlog

Use the titles below as issue titles. Suggested labels are descriptive; create labels in GitHub if desired. Dependencies are explicit.

### EPIC 0 — Engineering foundation

#### Issue 0.1 — Establish monorepo and project skeleton
**Squad:** Architecture + Backend + Android + Web  
**Priority:** P0  
**Depends on:** none

Tasks:
- Create `apps/owner_android`, `apps/public_menu`, `services/api`, `supabase/migrations`, `docs`, and `.github/workflows`.
- Initialize Flutter, Next.js, and FastAPI projects.
- Add root README and development commands.
- Add placeholder health routes and basic smoke tests.

Acceptance:
- All three applications start locally from documented commands.
- No production secrets are committed.
- Project layout matches documented architecture.

#### Issue 0.2 — Add CI and environment templates
**Squad:** Architecture + QA  
**Priority:** P0  
**Depends on:** 0.1

Tasks:
- Add Flutter analyze/test workflow.
- Add Next.js lint/typecheck/test/build workflow.
- Add Python lint/typecheck/test workflow.
- Add SQL migration validation workflow where practical.
- Add `.env.example` files with names and placeholders only.

Acceptance:
- Pull requests run relevant CI checks.
- Missing secrets fail safely with actionable messages.
- No credentials appear in logs.

#### Issue 0.3 — Freeze API v1 and generate typed fixtures
**Squad:** Backend + Android + Web  
**Priority:** P0  
**Depends on:** 0.1

Tasks:
- Implement Pydantic request/response models from API_CONTRACTS.md.
- Publish OpenAPI JSON.
- Generate or define typed client models for Flutter and TypeScript.
- Add representative success/error fixtures.

Acceptance:
- OpenAPI validates.
- Flutter and Web can consume mock fixtures without guessing fields.
- Contract changes are reviewable.

### EPIC 1 — Database and secure backend foundation

#### Issue 1.1 — Apply and verify initial PostgreSQL migration
**Squad:** Backend & Data  
**Priority:** P0  
**Depends on:** 0.1

Tasks:
- Apply DATABASE_SCHEMA.sql to a disposable Supabase project.
- Resolve any SQL errors and verify indexes, constraints, triggers.
- Add migration file under `supabase/migrations`.
- Add development seed data.

Acceptance:
- Migration applies cleanly from an empty database.
- Re-running the migration process is reproducible using the migration tool.
- Constraints reject invalid language, slug, price, and duplicate primary menu records.

#### Issue 1.2 — Implement Supabase JWT verification
**Squad:** Backend & Data  
**Priority:** P0  
**Depends on:** 0.3

Tasks:
- Configure issuer/JWKS/audience validation.
- Add authenticated dependency for FastAPI.
- Add `GET /api/v1/me`.
- Test expired, malformed, wrong-issuer, and valid tokens.

Acceptance:
- Invalid tokens return 401.
- User ID is derived only from verified token claims.
- No token or secret is logged.

#### Issue 1.3 — Implement shop onboarding and tenant authorization
**Squad:** Backend & Data  
**Priority:** P0  
**Depends on:** 1.1, 1.2

Tasks:
- Implement transactional shop + owner membership + primary menu creation.
- Implement slug validation and uniqueness handling.
- Implement membership/role authorization dependency.
- Add cross-shop access tests.

Acceptance:
- Authenticated user can create a shop.
- Shop creation is atomic.
- User A cannot read or mutate User B's shop.
- Client cannot self-assign owner role.

#### Issue 1.4 — Implement shop profile and language settings
**Squad:** Backend + Android  
**Priority:** P1  
**Depends on:** 1.3

Tasks:
- Implement shop read/update endpoints.
- Validate brand color, default language, enabled language set.
- Implement Flutter shop onboarding/profile screens.

Acceptance:
- Shop profile persists and reloads correctly.
- Default language is always in enabled languages.
- Public/private contact fields are handled explicitly.

### EPIC 2 — Menu data and publishing

#### Issue 2.1 — Implement category CRUD and ordering
**Squad:** Backend + Android  
**Priority:** P0  
**Depends on:** 1.3

Tasks:
- Create/list/update/archive categories.
- Add category translations.
- Validate category ownership through shop/menu.
- Build Flutter category editor and reorder UI.

Acceptance:
- Categories are scoped to the authenticated shop.
- Sort order persists.
- Translations support gu/hi/en.
- Empty and validation states work.

#### Issue 2.2 — Implement menu item CRUD
**Squad:** Backend + Android  
**Priority:** P0  
**Depends on:** 2.1

Tasks:
- Create/update/archive items.
- Store decimal prices and INR currency.
- Manage availability and display order.
- Add item translations.
- Build Flutter item editor.

Acceptance:
- Prices never use floating-point persistence.
- Invalid price/category ownership is rejected.
- Availability change is reflected in draft menu.
- Missing translations fall back to default language.

#### Issue 2.3 — Implement secure image upload
**Squad:** Backend + Android  
**Priority:** P1  
**Depends on:** 1.3

Tasks:
- Define storage bucket and file limits.
- Implement upload authorization and completion verification.
- Add Flutter image picker/upload progress/error handling.
- Add image optimization/fallback behavior for public display.

Acceptance:
- Unsupported types and oversized files are rejected.
- A shop cannot attach another shop's asset.
- Failed upload does not corrupt menu records.

#### Issue 2.4 — Implement draft preview and publish/unpublish
**Squad:** Backend + Web  
**Priority:** P0  
**Depends on:** 2.1, 2.2

Tasks:
- Implement owner draft preview.
- Implement publish validation and transaction.
- Implement unpublish.
- Implement sanitized public menu DTO and cache invalidation/revalidation.
- Build web preview/public data adapter.

Acceptance:
- Anonymous endpoint never returns drafts.
- Publishing exposes only valid current content.
- Unpublishing removes public access.
- Public URL remains stable after edits.

### EPIC 3 — Public menu and QR

#### Issue 3.1 — Build mobile-first public menu route
**Squad:** Public Menu Web  
**Priority:** P0  
**Depends on:** 0.3, 2.4

Tasks:
- Implement `/m/[shopSlug]`.
- Render shop header, categories, item cards, prices, availability and images.
- Add loading, not-found, unpublished, and error states.
- Implement responsive and accessible layout.

Acceptance:
- Works in mobile browser without sign-in or app installation.
- Only public DTO is consumed.
- Missing images do not break layout.

#### Issue 3.2 — Build QR generation and share flow
**Squad:** Android  
**Priority:** P0  
**Depends on:** 1.3, 2.4

Tasks:
- Fetch canonical public URL.
- Generate QR locally in Flutter.
- Preview, save/export, and share QR image.
- Share public URL through native share sheet/WhatsApp.

Acceptance:
- QR encodes HTTPS public URL, not an app-only deep link.
- QR remains unchanged when menu content changes.
- Scanning with owner app absent opens the browser menu.

#### Issue 3.3 — End-to-end QR scan test
**Squad:** QA + Android + Web  
**Priority:** P0  
**Depends on:** 3.1, 3.2

Tasks:
- Test real printed/displayed QR with Android camera.
- Test iOS camera/browser where available.
- Edit price and verify same URL reflects update.
- Test unpublished and deleted/invalid slug states.

Acceptance:
- No customer app install or account required.
- Stable QR URL passes all tested device/browser flows.

### EPIC 4 — Combined V1 capabilities

#### Issue 4.1 — Complete multilingual content experience
**Squad:** Backend + Android + Web  
**Priority:** P1  
**Depends on:** 2.1, 2.2, 3.1

Tasks:
- Complete Gujarati/Hindi/English editing in owner app.
- Implement customer language selector.
- Implement missing-translation fallback.
- Verify Unicode fonts and layout for all languages.

Acceptance:
- Language selection changes all available menu content.
- Missing translation falls back to default language.
- No broken glyphs or overflow on target devices.

#### Issue 4.2 — Branding and multiple menu themes
**Squad:** Android + Public Web + Backend  
**Priority:** P1  
**Depends on:** 1.4, 3.1

Tasks:
- Implement logo and brand color controls.
- Implement approved theme selection: classic, modern, minimal.
- Build theme previews in owner app.
- Render theme consistently in public web menu.

Acceptance:
- Branding and theme coexist.
- Unknown theme keys are rejected.
- Contrast and readability remain acceptable.

#### Issue 4.3 — WhatsApp and device sharing
**Squad:** Android + QA  
**Priority:** P1  
**Depends on:** 3.2

Tasks:
- Share canonical menu URL with meaningful preview text.
- Use native share sheet; do not require WhatsApp Business API.
- Test with WhatsApp installed and without it.

Acceptance:
- Share sheet opens correctly.
- Shared link opens same public menu.

#### Issue 4.4 — Privacy-conscious menu analytics
**Squad:** Backend + Android + QA  
**Priority:** P1  
**Depends on:** 3.1

Tasks:
- Implement rate-limited public view event endpoint.
- Implement deduplication and daily aggregate upsert.
- Implement owner analytics summary endpoint and screen.
- Document retention and privacy behavior.

Acceptance:
- Owner sees total and daily views.
- Repeated refreshes do not trivially inflate counts.
- No raw IP/customer identity is retained.

### EPIC 5 — Hardening and pilot

#### Issue 5.1 — Security and tenant-isolation review
**Squad:** QA + Backend  
**Priority:** P0  
**Depends on:** 1.3, 2.4

Acceptance:
- Cross-shop read/write tests pass.
- Public DTO has no private fields.
- Upload ownership and file validation pass.
- Rate limits and safe error responses are verified.

#### Issue 5.2 — Performance, accessibility, and browser compatibility
**Squad:** QA + Web + Android  
**Priority:** P1  
**Depends on:** 3.1, 4.1, 4.2

Acceptance:
- Public menu remains usable on slower mobile network.
- Responsive layouts pass narrow-phone checks.
- Keyboard, screen reader labels, contrast and text scaling reviewed.
- Android and iOS browser scan flows pass.

#### Issue 5.3 — Production readiness and pilot release
**Squad:** QA + all squads  
**Priority:** P0  
**Depends on:** all previous release-critical issues

Tasks:
- Configure production environment and domains.
- Verify backups and restore procedure.
- Configure monitoring, logs, alerting, deploy and rollback.
- Onboard a small pilot group of real shops.
- Record usability issues and fix critical defects.

Acceptance:
- No unresolved critical security/data-loss defects.
- Release checklist signed off.
- Real shop owner can independently create, publish, and update a menu.
- Customer can scan and view the menu without installing the app.

## 4. Suggested issue labels

Create labels if they do not already exist:
- `epic`
- `squad:android`
- `squad:web`
- `squad:backend`
- `squad:qa`
- `priority:P0`
- `priority:P1`
- `blocked`
- `good-first-task`

## 5. Milestone and status policy

Suggested GitHub milestones:
1. Foundation
2. Secure Backend & Menu Core
3. Public Menu & QR
4. Combined V1
5. Pilot Release

A roadmap item is not complete because code was generated. Completion requires:
- Merged implementation.
- Passing automated tests.
- Relevant integration/device/browser evidence.
- Updated docs and environment configuration.
- QA acceptance.

## 6. Execution order

Start with EPIC 0 and EPIC 1. Android and Web may build skeletons and mock-driven UI in parallel, but real integration waits for the relevant API contract and staging endpoint. Then proceed through menu publishing, public QR flow, V1 capabilities, and hardening.

No V2 or business-model work is authorized by this roadmap.
