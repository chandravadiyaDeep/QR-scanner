# QR Digital Menu — Current Project State & Handoff

> **MANDATORY SESSION-START RULE:** Before planning, coding, debugging, integrating, reviewing, or changing this repository, read this file completely and then read the linked source-of-truth documents relevant to the requested task.
>
> **MANDATORY REPORTING RULE:** After every completed task, integration, migration, test cycle, deployment, or meaningful project change, update this file and add a concise **4–5-line progress report** describing what was done, why it was done, what changed, what was verified, and what remains next. Do not wait for the user to request a report.
>
> **PURPOSE:** This is the project's continuity and handoff document. A new ChatGPT conversation or contributor must be able to understand the product, decisions, architecture, exact implementation state, current blockers, and next action by reading this file—without relying on previous chat history.

**Last updated:** 2026-11-24  
**Repository:** [chandravadiyaDeep/QR-scanner](https://github.com/chandravadiyaDeep/QR-scanner)  
**Project role model:** Product owner defines product decisions; engineering assistant coordinates and implements technical work.

---

## 0. Non-negotiable rules — protect the project

Every future ChatGPT session, agent, contributor, and squad must follow these rules.

1. **Read before acting.** Read this file first. Then inspect the current repository, branch, working tree, relevant code, issues, pull requests, and CI state. Never assume this document or chat history is more current than the actual repository.
2. **Preserve the approved product scope.** `PRODUCT_PLAN.md` is the product-scope authority. Do not silently add ordering, checkout, payments, loyalty, AI menu descriptions, subscriptions, billing, paywalls, or monetization. These are out of scope for the current release.
3. **Preserve the architecture boundaries.** Follow `TECHNICAL_ARCHITECTURE.md`, `SYSTEM_DESIGN.md`, `API_CONTRACTS.md`, `DATABASE_SCHEMA.sql`, and `SQUAD_CONTRACTS.md`. If a real conflict exists, stop and document it; do not invent a new architecture.
4. **Never break existing working behavior.** Inspect before modifying. Make focused, minimal, reviewable changes. Preserve stable API contracts, database constraints, shop slugs, public QR URLs, and existing working builds. Do not overwrite unrelated files or discard existing user work.
5. **Never guess project state.** Verify branch names, commit SHAs, file contents, workflow results, deployment status, and test evidence from GitHub or the relevant environment before claiming something is complete.
6. **Use branches and pull requests.** Do not push unfinished feature work directly to `main`. Use a focused branch and PR. Keep PRs draft until their defined tests and review gates pass. Do not merge merely because code was written.
7. **Database safety is mandatory.** Review migrations before applying them. Prefer ordered, repeatable migrations and explicit rollback/forward-fix guidance. Never run destructive SQL against a shared or production database without explicit approval and a verified backup/recovery plan.
8. **Tenant isolation is mandatory.** Every owner operation must derive identity from a verified Supabase JWT and check shop membership/role server-side. Never trust a user ID, shop role, or ownership claim supplied by the client. Test API authorization and database RLS independently.
9. **Keep secrets private.** Never ask the user to paste passwords, Supabase access/refresh tokens, service-role keys, database URLs/passwords, signing secrets, or private credentials into chat, GitHub issues, commits, or logs. Use local environment variables and redacted evidence. Never commit real secrets.
10. **Do not claim unverified success.** Distinguish automated unit tests, CI, local integration tests, live Supabase tests, browser/device tests, and production verification. A green CI run does not prove live authentication or tenant isolation.
11. **Respect user ownership.** The user is the Product Owner. The assistant may make routine implementation choices within approved scope, but must ask before material product changes, destructive operations, production releases, or irreversible external actions.
12. **Keep code understandable.** Add useful comments to code, especially around security, tenancy, transactions, validation, and non-obvious behavior. Avoid unnecessary dependencies and unrelated refactors.
13. **Update continuity after each task.** After every new integration or meaningful task, update the status, evidence, current blockers, and next action in this file. Add the required 4–5-line report to the task response.
14. **If uncertain, inspect and pause.** Do not fill missing information with assumptions. State what is known, what is not verified, and the smallest safe next step.

### Required 4–5-line progress report format

After each task, provide a report in this format and update the matching project section above/below:

- **Task:** What task/integration was performed and its purpose.
- **Changes:** Files, endpoints, schema, UI, configuration, or infrastructure changed.
- **Verification:** Exact tests/checks run and their result; include commit/PR reference when available.
- **Current state:** What is now complete and what remains unverified.
- **Next action:** The next dependency-ordered task or blocker.

A task is not complete merely because implementation was attempted. Record evidence and remaining work honestly.

---

## 1. Product identity and approved scope

**Product:** QR Digital Menu — a digital menu platform for local shops.

The product has two separate user experiences:

- **Shop-owner Android app (Flutter):** owners/staff authenticate, create and manage shop profiles and menus, edit categories/items/prices/availability/images, configure branding/themes/languages, preview and publish, and generate/share QR codes.
- **Customer public menu (Next.js):** customers scan a QR code and open a mobile-first HTTPS menu in any phone browser. Customers do not install the owner app and do not need an account.

**Canonical QR destination:** `https://<public-domain>/m/<shop-slug>`

The QR code stores only this stable public HTTPS URL—not JSON, private identifiers, or an app-only deep link. Ordinary menu edits must not change the slug or QR destination.

### Combined first-release scope

The first release combines MVP + V1. It includes:

- Shop onboarding and profile.
- Category and menu-item CRUD, sorting, pricing, images, and availability.
- Menu preview and publish/unpublish.
- Customer-safe public menu.
- Gujarati, Hindi, and English content handling with fallback.
- Branding and multiple menu themes.
- QR generation, download, and sharing.
- WhatsApp/device link sharing.
- Basic privacy-conscious menu analytics.

**Free-access commitment:** shops remain free until the project reaches 10,000 onboarded shops. This is an adoption milestone, not automatic billing activation.

**Out of scope (V2/reserved):** online ordering, cart/checkout, payments, AI descriptions, loyalty, paid plans, subscriptions, billing, paywalls, and monetization.

### Product source of truth

- [PRODUCT_PLAN.md](./PRODUCT_PLAN.md) — authoritative product scope.
- [BUSINESS_MODEL_RESERVED.md](./BUSINESS_MODEL_RESERVED.md) — reserved business-model thinking; not permission to implement monetization.
- [DEVELOPMENT_ROADMAP.md](./DEVELOPMENT_ROADMAP.md) — dependency-ordered delivery plan.

---

## 2. Architecture and technical boundaries

| Layer | Approved technology | Responsibility |
|---|---|---|
| Owner application | Flutter / Android | Authenticated shop management, menu editor, preview, QR creation/share |
| Customer menu | Next.js | Public mobile-first route `/m/[shopSlug]` |
| Trusted API | FastAPI / Python | JWT verification, authorization, validation, business rules, public DTO |
| Database | Supabase PostgreSQL | Relational data, constraints, indexes, RLS |
| Identity | Supabase Auth | Owner/staff identity and access tokens |
| File storage | Supabase Storage | Shop logos and menu item images |
| CI | GitHub Actions | Lint, compile, automated tests, later app/web/database checks |

### Security rules

- Owner endpoints require `Authorization: Bearer <Supabase access token>`.
- FastAPI verifies JWT signature through the Supabase JWKS, plus issuer, audience, expiry, and required claims.
- User identity comes only from verified JWT subject (`sub`).
- Every shop-scoped owner request must verify the authenticated user's membership and role.
- Database RLS is defense in depth; it does not replace API authorization. If the API uses a privileged database connection, RLS may be bypassed, so application-level checks remain mandatory.
- Public API returns only an explicit sanitized published-menu DTO.
- Never expose service-role keys or database credentials to Flutter or public web bundles.

### Architecture documents

- [TECHNICAL_ARCHITECTURE.md](./TECHNICAL_ARCHITECTURE.md)
- [SYSTEM_DESIGN.md](./SYSTEM_DESIGN.md)
- [DATABASE_SCHEMA.sql](./DATABASE_SCHEMA.sql)
- [API_CONTRACTS.md](./API_CONTRACTS.md)
- [SQUAD_CONTRACTS.md](./SQUAD_CONTRACTS.md)

---

## 3. Repository and delivery organization

**GitHub repository:** https://github.com/chandravadiyaDeep/QR-scanner  
**Default branch:** `main`  
**GitHub issues:** https://github.com/chandravadiyaDeep/QR-scanner/issues

Project documents already committed to `main` include:

- `PRODUCT_PLAN.md`
- `BUSINESS_MODEL_RESERVED.md`
- `TECHNICAL_ARCHITECTURE.md`
- `SYSTEM_DESIGN.md`
- `DATABASE_SCHEMA.sql`
- `API_CONTRACTS.md`
- `SQUAD_CONTRACTS.md`
- `DEVELOPMENT_ROADMAP.md`

### GitHub issue backlog

Issues #21–#41 were created to track the planned work:

| Issue | Work item |
|---|---|
| #21 | Monorepo skeleton |
| #22 | CI and environment templates |
| #23 | API schemas / OpenAPI |
| #24 | Apply and verify initial PostgreSQL migration |
| #25 | Supabase JWT verification |
| #26 | Transactional shop onboarding and tenant authorization |
| #27 | Shop profile / language API |
| #28 | Category CRUD |
| #29 | Item CRUD |
| #30 | Image uploads |
| #31 | Preview / publish |
| #32 | Public web route |
| #33 | QR generation / sharing |
| #34 | End-to-end scan |
| #35 | Translations |
| #36 | Branding / themes |
| #37 | Sharing |
| #38 | Analytics |
| #39 | Security / tenant isolation |
| #40 | Performance / accessibility |
| #41 | Production / pilot |

Do not mark an issue complete without implementation and acceptance evidence.

---

## 4. Implemented work — PR #43 (backend/database foundation)

**PR:** [#43 — Milestone 1: FastAPI backend and database foundation](https://github.com/chandravadiyaDeep/QR-scanner/pull/43)  
**Branch:** `feat/milestone-1-backend-foundation`  
**Latest verified head at this update:** `9eb40950ecc59f615f0268a950fe320c67a150b0`  
**PR state:** Open, draft, not merged.

### Implemented in the PR branch

- Initial FastAPI application and lifecycle.
- PostgreSQL connection-pool integration using psycopg.
- Typed environment settings and `.env.example`.
- Supabase JWKS-based JWT verification.
- Protected `GET /api/v1/me` endpoint.
- Protected `POST /api/v1/shops` endpoint.
- Transactional creation of shop, owner membership, and primary menu.
- Typed onboarding request/response schemas.
- Slug validation, reserved-slug protection, and conflict response.
- Enabled-language validation (1–3 supported languages, no duplicates, default must be enabled).
- Typed shop role values (`owner`, `editor`, `viewer`).
- Initial PostgreSQL migration with tenant tables, indexes, constraints, and RLS policies.
- Dockerfile, CI workflow, and setup documentation.
- Automated JWT tests for valid token, missing bearer token, wrong issuer, wrong audience, expired token, and malformed UUID subject.

### Key code paths in the PR branch

- `apps/api/app/main.py`
- `apps/api/app/auth.py`
- `apps/api/app/config.py`
- `apps/api/app/db.py`
- `apps/api/app/routes.py`
- `apps/api/app/schemas.py`
- `apps/api/tests/test_auth.py`
- `apps/api/.env.example`
- `apps/api/pyproject.toml`

Inspect the actual PR branch for the complete current file list before editing.

### CI evidence

At the latest recorded verification (2026-11-24):

- GitHub Actions workflow: **API CI**
- Workflow run: [45424137746](https://github.com/chandravadiyaDeep/QR-scanner/actions/runs/45424137746)
- Run number: 33
- Commit: `9eb40950ecc59f615f0268a950fe320c67a150b0`
- Result: **completed / success**
- Job: `test`
- Steps passed: dependency installation, Ruff lint, Python compilation, and pytest unit tests.

This CI result verifies the PR head at that SHA. If the branch head changes, re-check CI for the new exact SHA.

---

## 5. Supabase environment and live integration status

The product owner previously confirmed:

- A Supabase project has been created.
- The initial database migration was applied through the Supabase SQL editor.
- The expected nine tables and RLS verification were confirmed.
- Two Supabase Auth test users are already created and available for testing.

### Important distinction

The above confirms the migration/table/RLS setup was performed and the test accounts exist. It does **not** yet prove that the FastAPI service successfully authenticates those real users or that cross-tenant access is blocked end to end.

### Live tests still required

1. Configure the local API using the Supabase project URL, issuer, JWKS URL, audience, and a database connection string in a local `.env`. Do not share the secret values in ChatGPT.
2. Obtain a valid access token for test account A locally and call `GET /api/v1/me`.
3. Repeat with test account B.
4. Verify requests with missing, malformed, expired, or invalid tokens return 401.
5. Create a unique shop as account A; verify shop, owner membership, and primary menu are created together.
6. Create a different unique shop as account B; verify the same.
7. Verify each account's `/api/v1/me` response lists only its own memberships.
8. Test attempts by A to read or modify B's shop through every available shop-scoped endpoint. Expected result: denied (normally 403 or a deliberate non-disclosing 404, according to the API contract).
9. Test database RLS separately using the intended authenticated database role/context. Confirm whether the API's database connection bypasses RLS and document that behavior honestly.
10. Verify transaction atomicity by forcing a failure during onboarding in a safe test environment and confirming no partial shop/membership/menu records remain.

**Current status:** live JWT authentication, real-account onboarding, cross-tenant API isolation, and database RLS behavior remain **pending verification**. The API currently has only the initial `/me` and shop-onboarding endpoints; do not claim that unimplemented shop CRUD routes have been tested.

### Credential handling

Never paste access tokens, refresh tokens, passwords, service-role keys, database URLs, or private keys into chat. The assistant should provide safe local commands with placeholders and ask only for redacted status codes and response bodies.

---

## 6. GitHub Pages project portal

A separate `gh-pages` branch was created and contains a root `index.html` for the project portal.

- Commit: `a88701cbb113a432b892b962940520f1cb60ff63`
- The page explains the product vision, owner/customer experiences, features, QR URL, languages, privacy/security, free-access commitment, FAQs, and release/download section.
- The APK button is intentionally disabled and labelled **APK coming soon** because no verified APK release exists yet.
- GitHub Releases link is provided as a secondary route.
- The future expected APK asset name is `QR-Digital-Menu.apk`; only enable the download link after a real APK with that exact asset name is published.

**Product owner has confirmed the website is working properly.**

The portal's expected GitHub Pages URL is:
https://chandravadiyaDeep.github.io/QR-scanner/

Do not claim a new deployment or APK exists unless it is checked live. The portal is not the product's customer menu implementation; it is a project information/download landing page.

---

## 7. Current status dashboard

| Area | Status | Evidence / notes |
|---|---|---|
| Product scope and architecture | **Completed baseline** | Core project documents committed to main |
| GitHub issue backlog | **Created** | Issues #21–#41 |
| Initial database migration | **Applied / owner-confirmed** | Nine expected tables and RLS verification confirmed by product owner |
| FastAPI foundation | **Implemented in PR** | PR #43, not merged |
| Supabase JWT verifier | **Implemented + unit-tested** | Real Supabase accounts still need live verification |
| Shop onboarding transaction | **Implemented in PR** | Live two-account test still pending |
| Tenant isolation | **Pending live verification** | Must test both API authorization and database RLS |
| PR #43 CI | **Passed at recorded head** | Run #45424137746 for SHA `9eb4095...` |
| PR #43 merge | **Not merged; remains draft** | Do not merge until required live checks pass |
| GitHub Pages portal | **Working, owner-confirmed** | `gh-pages` branch |
| Android Flutter app | **Not yet implemented/verified** | Do not imply APK exists |
| Next.js public menu | **Not yet implemented/verified** | Future work |
| Menu CRUD and publishing | **Not yet implemented/verified** | Future work |
| QR generation / end-to-end scan | **Not yet implemented/verified** | Future work |
| Languages / branding / themes / analytics | **Not yet implemented/verified** | Future work |

---

## 8. Immediate next task — finish PR #43 live verification

**The next task is not to start unrelated UI work.** Complete the current milestone gate first.

### Step A — establish local environment

- Ask whether the repository is already cloned on the product owner's Windows PC if that is not known.
- If not cloned, provide simple GitHub clone steps.
- Set up Python environment and install API dependencies from the PR branch.
- Configure local `.env` without exposing secrets.
- Start FastAPI and verify `/health` and `/ready`.

### Step B — test both Supabase Auth accounts

- Use test account A and test account B separately.
- Sign in locally through Supabase Auth; keep returned tokens local.
- Call `/api/v1/me` with each account.
- Create one uniquely slugged test shop per account.
- Confirm each response and owner membership.
- Never use a real shop's production slug for test data.

### Step C — prove tenant isolation and RLS

- Check that account A does not see account B's shop membership.
- Check cross-tenant read/write attempts against available shop-scoped routes.
- Inspect and test RLS policies using the actual database role and request context.
- Confirm rollback/atomicity behavior for shop onboarding.
- Record exact test outcomes, endpoint, account label (A/B only), status code, and redacted result.

### Step D — close the milestone gate

- Fix defects in the PR branch with focused commits.
- Re-run CI and verify the exact latest head SHA is green.
- Update PR description and this file with evidence.
- Only when the required tests pass, mark PR ready for review.
- Merge only after review/acceptance; do not merge automatically.

---

## 9. After PR #43 — planned dependency order

Once the backend/database/auth/tenancy gate is accepted, continue in the roadmap order:

1. Complete API schemas/OpenAPI contract and contract tests.
2. Shop profile and language settings API.
3. Category CRUD.
4. Menu-item CRUD.
5. Secure shop-scoped image uploads.
6. Draft preview and publish/unpublish.
7. Public sanitized menu endpoint.
8. Next.js public route `/m/[shopSlug]`.
9. QR generation using the canonical public URL.
10. Real-device QR scan-to-browser end-to-end tests.
11. Gujarati/Hindi/English content and fallback.
12. Branding and themes.
13. WhatsApp/device sharing.
14. Privacy-conscious analytics.
15. Security, accessibility, performance, production readiness, and pilot.

Follow issue dependencies and acceptance criteria in `DEVELOPMENT_ROADMAP.md`. Do not skip security or integration gates to move faster.

---

## 10. How a new ChatGPT session must start

When the user says **"Read CURRENT_STATE.md and continue"**:

1. Read this file first, then inspect the repository's latest `main`, active feature branch, relevant PR, and CI state.
2. Compare the live repository state with the dates/SHAs/status recorded here. Repository evidence wins when this file is stale.
3. Summarize the exact current state briefly: completed, in progress, pending, and blocked.
4. Identify the next dependency-ordered task and execute it within the approved product scope.
5. Do not ask the user to repeat details already documented here. Ask only for genuinely missing access or decisions.
6. After the task, update this file with the new verified state and provide the required 4–5-line progress report.

**The goal is continuity without project drift:** every new session should know what we are building, why we are building it, what has actually been implemented, what is verified, what is still pending, and the safest next step.


---

## 11. Progress log — 2026-11-24

### Online Android APK testing requirement confirmed by Product Owner

- **Task:** The Product Owner confirmed the repository is cloned locally and made a final delivery requirement: once the Flutter Android app is implemented, produce an APK and make it available through an online environment for interactive testing.
- **Purpose:** Enable testing through a browser-hosted Android device rather than relying only on screenshots, local builds, or CI results.
- **Verified repository state:** The current feature branch contains `apps/api` only. No Flutter owner-app source directory, Android Gradle project, or APK build currently exists. Therefore there is no genuine app binary to upload at this stage.
- **Testing target distinction:** Appetize can run an uploaded APK in a browser-hosted virtual device; BrowserStack App Live supports interactive testing on cloud-hosted real Android devices and accepts APK uploads. These are not equivalent: browser emulator preview is not physical-device verification. Check current plan limits/pricing before selecting a paid service.
- **Delivery approach:** After the owner app exists, add a reproducible GitHub Actions APK build, retain a downloadable build artifact/release, then connect an approved online test service. Do not publish placeholder APKs or claim an upload/test succeeded without a real build and session evidence.
- **User setup dependency:** Any external testing-service account/API token must be configured by the Product Owner as a GitHub Actions secret or entered directly in that service; never send the token in chat.
- **Current state:** Online APK testing is now an explicit delivery acceptance requirement, but app implementation and APK generation remain pending. PR #43 live Supabase authentication and tenant-isolation verification remain the immediate milestone gate.
- **Next action:** Continue the planned PR #43 live verification using the cloned Windows repository and the two existing Supabase test accounts. After that milestone is accepted, implement the Flutter owner app and its APK build/test delivery pipeline in dependency order.


---

## 12. Android owner-app implementation — 2026-11-24

### Product Owner's delivery instruction

The Product Owner explicitly requested that all implementation, build, release, and test preparation be performed through GitHub. Do not require the Product Owner to use VS Code or run local commands for routine development. Continue using GitHub branches, pull requests, and GitHub Actions. The Product Owner also requires the same verified APK to be tested through both Appetize and BrowserStack App Live before delivery.

### Android foundation branch and PR

- **Branch:** `feat/flutter-owner-app-foundation`
- **Base:** `feat/milestone-1-backend-foundation` (keeps the mobile work dependent on the current backend foundation PR #43)
- **PR:** [#44 — Android owner app foundation and automated APK pipeline](https://github.com/chandravadiyaDeep/QR-scanner/pull/44)
- **Current PR state:** Open, draft, not merged.
- **Recorded branch head at this update:** `a2d95ccb77f325a8473868c2deff10069f8e0e91`

### Implemented in the first Android foundation commit set

- Flutter project created at `apps/owner_android`.
- Dark mobile-first owner-app shell.
- Supabase email/password registration and sign-in UI.
- Authenticated shop list loading through `GET /api/v1/me`.
- Shop onboarding through `POST /api/v1/shops`, matching the currently implemented API schema.
- Safe unconfigured state so an APK can still compile without embedding credentials.
- GitHub Actions workflow `.github/workflows/android-apk.yml` to install Flutter, fetch dependencies, analyze, run widget tests, build a release APK, and retain it as a 14-day workflow artifact.

### Current Android CI state

- Workflow: **Android APK**
- Run: [45434864729](https://github.com/chandravadiyaDeep/QR-scanner/actions/runs/45434864729)
- Run #1 for branch head `a2d95ccb77f325a8473868c2deff10069f8e0e91`.
- At the time of this update, GitHub Actions had started the Flutter setup step; dependency installation, analysis, tests, APK build, and artifact upload were not yet confirmed.
- Do not describe an APK as built or tested until the workflow succeeds and the artifact is present.

### Important incomplete work

This is a foundation only, not the complete combined MVP + V1 owner app. The following remain unimplemented:
- Shop profile edit and settings.
- Category create/list/update/delete/reordering.
- Menu item create/list/update/archive, price, availability, and ordering.
- Image upload integration.
- Draft preview and publish/unpublish controls.
- QR generation, PNG export, and device/WhatsApp sharing.
- Translation editor for Gujarati, Hindi, and English.
- Branding and theme selection.
- Analytics dashboard.
- Public customer menu web app and end-to-end QR scan.
- Complete API endpoints and backend integration tests for those flows.
- Full automated/widget/integration tests and real-device regression.

### Appetize and BrowserStack dual-testing requirement

The release target is to upload the same final, verified release APK to both:
1. **Appetize:** browser-hosted Android app preview/test session.
2. **BrowserStack App Live:** interactive testing on cloud-hosted real Android devices.

The current repository workflow does not yet upload to either service. Before automated upload can be enabled, the Product Owner must configure credentials privately in GitHub Actions repository secrets (never in chat):
- Appetize API token, following the current Appetize upload API.
- BrowserStack username and access key, following the current App Live/App Automate app-upload API.

Do not invent test-session URLs. Generate and publish the actual session links only after successful upload and session creation. Verify whether the user's selected service plans support the required upload/session duration and device features.

### Next implementation order

1. Verify and repair Android foundation CI until analyze, widget tests, and APK build all pass.
2. Add API endpoints and Flutter screens for shop settings, categories, and items.
3. Add storage uploads, preview/publish, public menu API and Next.js customer route.
4. Add QR generation/export/share, translations, themes, and analytics.
5. Add comprehensive API, widget, integration, browser, and real-device regression checks.
6. Add dual Appetize + BrowserStack upload/session automation using private GitHub secrets.
7. Publish one versioned release APK and provide both verified test links.
8. Keep PRs draft until acceptance tests pass; do not claim full release readiness prematurely.

### Progress report — 2026-11-24

- **Task:** Started Android owner-app implementation entirely through GitHub, honoring the Product Owner's no-local-IDE instruction and dual online testing requirement.
- **Changes:** Added Flutter project, Supabase sign-in/register, authenticated shop listing/onboarding, widget smoke test, and GitHub Actions APK build workflow; opened draft PR #44.
- **Verification:** Workflow run #45434864729 was started for SHA `a2d95ccb77f325c67a150b0`; at documentation time it was still in progress, so no build/test result or APK artifact is claimed.
- **Current state:** Android foundation exists on a feature branch; full owner-app scope and both cloud testing uploads remain incomplete.
- **Next action:** Inspect Android CI result, fix all failures through GitHub commits, then implement remaining owner workflows and backend contracts before dual-service testing.


### Follow-up CI repair log — 2026-11-24

- **Task:** Fix the first Android CI failure so the new Flutter project can progress to tests and APK generation.
- **Changes:** The first CI run (#45434864729) failed at static analysis because Flutter 3.50.1 and the resolved Supabase SDK reported three deprecation diagnostics. Updated the Flutter Material import, Supabase initialization to `publishableKey`, and the dropdown field to `initialValue` in `apps/owner_android/lib/main.dart`.
- **Verification:** Fix commit `bed1e6bf2863513bd9a426200b917606a28fafb1` pushed to the Android feature branch. A fresh push workflow run #45435084459 was created for that exact SHA; it was still running at the time of this log. No passing result or APK artifact is claimed yet.
- **Current state:** The first CI issue has a targeted code fix; re-analysis, widget tests, and APK build are pending verification.
- **Next action:** Check run #45435084459; fix any further failures via GitHub, then continue implementing the complete owner app and backend features.


### Android build workflow hardening — 2026-11-24

- **Task:** Make the GitHub-only Android build reproducible without requiring the Product Owner to open an IDE or generate native Android files locally.
- **Changes:** Updated `.github/workflows/android-apk.yml` to generate the Android platform scaffold with Flutter in the GitHub Actions runner before dependency installation and build. Latest known PR #44 head is `0aa50d5e1a191dd4af82302081601dd4a8308f00`.
- **Verification:** Flutter setup and dependency installation succeeded on the initial run, but the first static-analysis attempt failed on three deprecation diagnostics. Those diagnostics were corrected in `bed1e6bf2863513bd9a426200b917606a28fafb1`. Workflow runs #45435084459 and #45435096061 were still marked in progress at the last check and did not yet provide a verified APK artifact. The latest workflow commit still needs its own green run.
- **Current state:** No complete APK or Appetize/BrowserStack test link exists yet. Android feature PR #44 remains draft.
- **Next action:** Verify the newest CI run against the latest branch head, resolve any scaffold/build/runtime errors, and then continue the full feature implementation.


### PR #44 CI diagnosis and repair — 2026-11-24

- **Task:** Investigate the red checks shown on draft PR #44 and correct the root cause using GitHub-only changes.
- **Changes:** Latest CI logs showed the Flutter SDK import in `apps/owner_android/lib/main.dart` pointed to the nonexistent package `material_ui`, causing cascading unresolved Flutter widget/type errors (238 analyzer issues). Restored the official Flutter SDK import `package:flutter/material.dart`.
- **Verification:** Fix committed to `feat/flutter-owner-app-foundation` as `a4a0d232003be67e9abae9547d00aadc3fce9c21`. The failed run was #6 for the previous head; a fresh workflow run for this repair must be checked before marking CI green. No APK artifact is claimed.
- **Current state:** Root cause of the visible analyzer failure is fixed in the branch; PR #44 remains open and draft while CI reruns.
- **Next action:** Verify the new exact-head workflow result; resolve any remaining analyzer, widget-test, or APK build failures before proceeding.
