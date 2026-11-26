# Product Plan — Premium Restaurant & Café Menu Platform

> **ACTIVE PRODUCT SCOPE — PRODUCT 2 ONLY**
>
> This repository is now dedicated to a premium digital menu and guest-experience platform for quality-focused restaurants, cafés, and hospitality businesses with an average spend above **₹200 per person**.
>
> The free, offline-first local-shop product is a separate project. Its requirements, 10,000-shop free-access milestone, offline-first assumptions, and implementation must not be imported into this repository.

## 1. Product vision

Build a polished, reliable, high-quality digital menu platform for restaurants and cafés where presentation, brand identity, guest experience, and operational reliability matter.

The product should help a hospitality business present its menu as an intentional part of its brand—not merely as a list of item names and prices.

The experience must feel premium, load quickly, work beautifully on mobile, and be dependable during real service hours.

## 2. Target customer

Primary customers:
- Quality-focused restaurants.
- Specialty cafés and coffee shops.
- Premium casual dining venues.
- Boutique food and beverage businesses.
- Hospitality venues with an average guest spend above ₹200 per person.

The threshold is an initial market-positioning filter, not a hard-coded pricing rule or a customer eligibility check. Validate the segment through interviews and pilot venues.

## 3. Product principles

1. **Hospitality-grade presentation:** Menu design must respect the restaurant's identity, food photography, typography, spacing, and content hierarchy.
2. **Guest-first experience:** A guest should understand the menu quickly without installing an app or creating an account.
3. **Operational reliability:** The menu must remain dependable during busy service periods.
4. **Performance:** Fast initial load, optimized images, graceful network handling, and clear loading/error states.
5. **Editorial quality:** Support rich but structured item descriptions, dietary/allergen information where verified by the venue, highlights, and well-organized sections.
6. **Brand flexibility:** Support a considered design system and controlled customization rather than an unstructured theme builder.
7. **Security and privacy:** Protect restaurant accounts, unpublished content, guest data, and operational settings.
8. **Measurable quality:** Every major feature has acceptance criteria and repeatable test evidence.

## 4. Core product experience

### A. Restaurant management experience

An authenticated workspace for restaurant owners and authorized staff to:
- Create and maintain restaurant profiles.
- Organize menus, sections, and items.
- Manage item names, descriptions, prices, images, variants or modifiers if approved in discovery, and availability.
- Maintain content quality and translations.
- Preview the guest-facing menu before publishing.
- Publish updates safely.
- Manage QR destinations and downloadable QR assets.
- Review meaningful menu engagement insights.
- Control branding and presentation within the approved design system.

The exact staff roles, multi-location support, and operational workflows require product discovery before implementation.

### B. Guest-facing digital menu

A premium, mobile-first menu opened from a QR code in the guest's normal browser.

Baseline journey:
1. Guest scans the restaurant's QR code.
2. A stable HTTPS URL opens in the phone browser.
3. The menu loads quickly and presents the restaurant's identity.
4. Guest browses clearly structured menu sections and items.
5. Guest sees accurate prices, descriptions, images, availability, and verified dietary information where provided.
6. Guest can use supported language options where the restaurant has supplied translations.

Guests must not be required to install the owner application or create an account merely to view a menu.

## 5. Experience and quality bar

This is not a generic CRUD dashboard with a QR code attached. Design and engineering must be reviewed as one guest experience.

Required design qualities:
- Premium visual hierarchy without sacrificing readability.
- Deliberate typography and spacing.
- High-quality food imagery with optimized delivery.
- Thoughtful motion used sparingly and with reduced-motion support.
- Excellent mobile behavior across common screen sizes.
- Accessible contrast, touch targets, and semantic structure.
- Clear empty, loading, unavailable, offline/network-failure, and not-found states.
- Brand consistency across QR landing, menu, and restaurant workspace.

## 6. Product capabilities to investigate and specify

These are candidate capabilities, not blanket implementation authorization. Each must be validated with target restaurants and captured in an approved requirements document before engineering commitment:
- Multiple menus or dayparts.
- Item variants, add-ons, and modifiers.
- Dietary labels and allergen disclosures.
- Chef recommendations, signatures, and seasonal specials.
- Multi-language guest experience.
- Restaurant-specific brand themes and menu layouts.
- Multi-branch or multi-location management.
- Staff roles and approval workflows.
- Menu analytics and QR campaign attribution.
- Table-specific QR destinations.
- Reservations, ordering, payments, or integrations only if explicitly approved after discovery.

Do not silently add any of these to the release scope. In particular, do not assume ordering, checkout, payments, reservations, or table management are included.

## 7. Commercial direction

This is a premium hospitality product, not the free local-shop product.

Do not copy the other product's free-until-10,000-shops promise or its monetization assumptions. Pricing, packaging, trials, onboarding fees, subscriptions, and service commitments remain undecided until customer research and cost modeling are completed.

Do not implement billing or paywalls before a separate commercial decision is approved.

## 8. Explicit separation from Product 1

Product 1 is an independent free, offline-first app for small local shops.

It has a separate prompt, repository, roadmap, data strategy, and release process.

For this repository:
- Do not optimize for every micro-shop or zero-cost operation.
- Do not make offline-first local data management the defining architecture.
- Do not carry over Product 1's 10,000-shop milestone.
- Do not reuse Product 1's code, database, deployment, or assumptions without a deliberate technical review.
- Do not allow Product 1 work to enter this repository's active branches or pull requests.

## 9. Product discovery and approval gates

Before building the premium product at scale, create:
1. Target-customer interview plan and findings.
2. Personas and hospitality service journeys.
3. Competitive and positioning analysis.
4. Product requirements document with release boundaries.
5. Guest menu information architecture and UX flows.
6. High-fidelity design system and interactive prototype.
7. Technical architecture and threat model.
8. Data model and API contracts.
9. Performance, accessibility, security, and reliability targets.
10. End-to-end QA strategy and pilot acceptance criteria.

## 10. Definition of quality

A feature is not complete because it compiles or looks attractive in a screenshot.

Completion requires:
- Approved requirements and design.
- Correct implementation.
- Unit and integration tests.
- Security and authorization tests where applicable.
- Responsive browser and real-device verification.
- Performance and accessibility checks.
- Regression evidence.
- Product-owner acceptance.

**Final objective:** Deliver a premium, dependable digital menu experience that quality-focused restaurants and cafés are proud to put in front of their guests.