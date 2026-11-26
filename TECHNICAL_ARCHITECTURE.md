# Technical Architecture — Premium Restaurant & Café Menu Platform

> **Status:** Provisional direction for Product 2. Final architecture follows customer discovery, UX design, and non-functional requirements.
>
> **Scope authority:** [PRODUCT_PLAN.md](./PRODUCT_PLAN.md)
>
> Product 1's offline-first local-shop architecture and code are not the source of truth for this repository.

## 1. Architecture goals

- Premium, fast guest-facing menu experience.
- Secure restaurant management workspace.
- Reliable publishing and stable QR destinations.
- Strong tenant and location boundaries.
- High-quality image delivery.
- Observability, testability, and safe deployments.
- Maintainable code with clear ownership boundaries.

## 2. Provisional technology direction

The previous technical exploration identified this candidate stack for Product 2. Confirm it against requirements before locking it:

| Layer | Candidate | Responsibility |
|---|---|---|
| Owner application | Flutter | Restaurant management workspace, preview, QR administration |
| Guest menu | Next.js | Premium responsive browser experience |
| Backend | FastAPI | Authentication, authorization, business rules, publishing, analytics |
| Database | Supabase PostgreSQL | Durable relational data |
| Authentication | Supabase Auth | Restaurant owner/staff identity |
| Media | Supabase Storage or equivalent | Controlled image upload and delivery |
| Hosting | Vercel for web; suitable managed Python host for API | Production deployment |
| CI/CD | GitHub Actions | Automated quality gates and releases |

This is a provisional stack, not permission to blindly reuse Product 1's existing implementation.

## 3. Core architectural boundaries

1. Guest menus are browser experiences opened from stable HTTPS QR destinations.
2. Guests do not need the owner application or an account to view public menus.
3. Owner operations require authenticated identity and server-side restaurant/location authorization.
4. Public responses expose only intentionally published guest-safe data.
5. Draft and unpublished data must never leak through public routes, caches, logs, or metadata.
6. QR destinations should remain stable when menu content changes.
7. Image upload, processing, resizing, caching, and delivery must be designed for visual quality and performance.
8. The guest experience must degrade gracefully on slow or interrupted networks.
9. Never embed privileged credentials in Flutter, browser JavaScript, or public configuration.
10. Tenant isolation must be tested at both API and database layers.

## 4. Areas requiring product discovery

Do not finalize schema or endpoints until these questions are answered:
- One restaurant versus multiple locations.
- Multiple menus, dayparts, or language-specific menus.
- Menu sections, items, variants, add-ons, and availability schedules.
- Dietary and allergen metadata and its verification responsibility.
- Staff roles, approvals, and audit history.
- Table-specific QR codes or one restaurant-wide QR.
- Analytics granularity and privacy constraints.
- Image transformation and content delivery requirements.
- Whether reservations, ordering, payments, or third-party integrations belong in scope.

## 5. Quality attributes

Define measurable targets during architecture discovery:
- Initial and repeat menu load performance.
- Core Web Vitals and mobile responsiveness.
- API latency and availability objectives.
- Image payload budgets and responsive image behavior.
- Accessibility conformance.
- Security controls, rate limiting, and auditability.
- Backup, recovery, and deployment rollback.
- Observability and actionable alerting.

## 6. Security model

- Verify authentication tokens server-side.
- Derive user identity from verified claims only.
- Check restaurant and location membership for every protected operation.
- Enforce least privilege for owner, manager, editor, and any future roles.
- Use dedicated public DTOs rather than serializing database records.
- Keep storage objects private by default until a controlled public delivery policy is approved.
- Add cross-tenant negative tests for every resource family.
- Never log passwords, tokens, secrets, or sensitive guest data.

## 7. Repository and delivery rules

- Use GitHub feature branches and pull requests.
- Keep CI required for lint, type checks, unit tests, integration tests, and builds.
- Use migrations and reviewed schema changes.
- Maintain staging and production environment separation.
- Never deploy unverified changes to production.
- Keep release artifacts versioned and traceable to source commits.
- Record every meaningful change and verification result in CURRENT_STATE.md.

## 8. Legacy implementation warning

PR #43 and PR #44 were started for the former free local-shop product. They are not an approved foundation for Product 2. Do not merge, extend, or depend on them for the premium platform without a fresh architecture and code review.

The old API contracts and database schema must be treated as legacy until redesigned and explicitly approved for this product.