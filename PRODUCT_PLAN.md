# Product Plan — QR Digital Menu App

> **Current release scope: Combined MVP + V1.**
>
> The MVP and V1 feature sets are merged into one initial product release. The combined scope is free for shops until the project reaches the 10,000-shop adoption milestone. This is a product plan, not a business-model document.

## 1. Product vision

Build an affordable, easy-to-use **Android app for local shops** that lets owners create and maintain a digital menu. Customers must be able to open and browse that menu instantly from a QR code using their phone browser — **customers must not need to install our app**.

The product reduces dependence on printed menus and makes it easier for shops to update items, prices, availability, branding, and menu presentation.

## 2. Two distinct experiences

### A. Shop-owner Android app

The Android app is the management tool used by shop owners or authorized staff. It should let them:

- Register and sign in to their shop account.
- Create and manage a shop profile.
- Build and edit a menu.
- Add, edit, reorder, and remove menu items.
- Organize items into multiple categories.
- Update names, descriptions, prices, images, and availability.
- Customize shop identity and menu branding.
- Select and preview menu themes.
- Manage menu languages: Gujarati, Hindi, and English.
- View basic menu analytics.
- Share the public menu link through WhatsApp and other share targets.
- Generate, preview, download, and share the shop's QR code.

### B. Customer public menu (no app installation)

Customers are **not required to install the Android app** and do not need an account to view a public menu.

Customer journey:

1. Customer opens the phone camera or any QR scanner.
2. Customer scans the shop's QR code.
3. The QR code opens a normal HTTPS public menu URL in the phone's browser.
4. The page loads the shop's current published menu.
5. Customer browses categories, items, descriptions, prices, images, and availability.
6. Customer can switch between the supported languages when the shop has provided those translations.
7. Customer can share the menu link if desired.

This separation is a foundational architecture requirement: **the Android app manages the menu; the public web page displays the menu.** The customer-facing page is a lightweight, mobile-responsive web experience, not a customer app and not a full shop-owner website.

Do not make QR codes point to an app-only deep link or an app-store listing. The QR destination must remain a stable web URL that works on Android browsers, iPhone browsers, and devices with no app installed.

## 3. Combined MVP + V1 scope

Every feature below is included in the first combined release.

| Feature | Required behavior | Release |
|---|---|---|
| QR menu generation | Generate a QR code that opens the shop's public HTTPS menu URL | Combined MVP + V1 |
| Menu editor | Create, update, reorder, and remove menu items; edit prices and details | Combined MVP + V1 |
| Multiple categories | Create and manage categories and organize menu items | Combined MVP + V1 |
| Custom branding | Shop name, logo or image, brand colors, and basic identity settings | Combined MVP + V1 |
| Mobile-responsive customer menu | Fast, readable public menu across common phone screen sizes | Combined MVP + V1 |
| Gujarati, Hindi, and English | Support these menu display languages, with shop-provided translations and sensible language selection | Combined MVP + V1 |
| Menu analytics | Provide basic, privacy-conscious menu visit/view metrics | Combined MVP + V1 |
| WhatsApp sharing | Share the public menu URL through WhatsApp and the device share sheet | Combined MVP + V1 |
| Multiple menu themes | Offer multiple customer-menu presentation themes that preserve readability and accessibility | Combined MVP + V1 |

### Scope clarifications

- **Languages:** The interface and menu content must not be assumed to translate automatically. Shop owners need a clear way to provide language-specific names/descriptions. Missing translations should fall back gracefully to the default menu language.
- **Analytics:** Start with basic metrics such as menu views and aggregated activity over time. Do not collect unnecessary customer personal data.
- **Sharing:** WhatsApp sharing is a share action for the public URL; it does not require a WhatsApp Business integration.
- **Themes:** Themes change presentation, not the underlying menu data. Shop branding and theme selection must coexist.
- **Availability:** A shop owner should be able to mark an item unavailable so customers do not see it as currently available.

## 4. Explicitly out of scope for this release

These are later-phase ideas and must not expand the combined MVP + V1 build unless the product plan is deliberately revised.

| Feature | Current status |
|---|---|
| Online ordering | V2 — out of scope |
| Payment integration | V2 — out of scope |
| AI menu descriptions | V2 — out of scope |
| Customer loyalty | V2 — out of scope |
| Paid plans, subscriptions, billing, monetization | Reserved until 10,000-shop milestone review |

The first release is a digital menu and menu-management product. Do not quietly introduce ordering, checkout, payments, loyalty, or AI content generation into the MVP + V1 implementation.

## 5. Free-access commitment and adoption milestone

The combined MVP + V1 feature set is to remain free for shops until the project reaches **10,000 onboarded shops**.

This is an adoption milestone, not a launch date or a promise to start charging automatically. The separate business-model document, [BUSINESS_MODEL_RESERVED.md](./BUSINESS_MODEL_RESERVED.md), is intentionally inactive until the target is verified and a separate decision is made.

The project must not implement subscription enforcement, paywalls, paid feature gating, or billing in this release.

For milestone reporting, the team should define and consistently track an onboarded shop. A proposed counting rule is: a distinct shop account with a completed shop profile and at least one published, customer-accessible menu. Exclude test, duplicate, abandoned, and internal demo shops from the verified count.

## 6. Product principles

1. **Customer access without installation:** scanning a QR code must open the menu in a browser.
2. **Owner-first simplicity:** a non-technical shop owner should be able to maintain a menu without help after onboarding.
3. **Mobile-first:** both the owner app and public menu must work well on phones.
4. **Low-cost operation:** avoid unnecessary infrastructure and third-party dependencies.
5. **Fast updates:** published menu changes should become visible to customers promptly.
6. **Stable QR destination:** menu edits, theme changes, and language updates should not require reprinting the QR code.
7. **Privacy-conscious analytics:** collect only what is needed for aggregate menu usage insights.
8. **Reliable fallback:** public menus should remain readable on common mobile browsers and slower networks.

## 7. High-level architecture boundaries

The implementation may choose its exact stack after technical evaluation, but it must preserve these boundaries:

- **Android owner application:** authenticated shop management and publishing controls.
- **Backend/API:** authorization, shop/menu data operations, publishing state, and analytics aggregation.
- **Database:** shops, members/roles, categories, menu items, translations, branding/theme preferences, published-menu state, and aggregate analytics.
- **Image storage:** shop logos and menu-item images with safe file constraints.
- **Public menu web route:** read-only customer-facing pages resolved by a stable shop slug or public identifier.
- **QR destination:** the stable public HTTPS URL, never an app-only route.

The public menu must not expose owner-management endpoints or require customer authentication. Owner write operations must be authorized server-side.

## 8. Core data concepts

The detailed schema is a later technical-design artifact. At minimum, the domain should represent:

- Shop: identity, public slug, contact details, branding, default language, publication status.
- Shop member: authenticated owner/staff identity and role.
- Menu: shop association, publication state, selected theme, default language.
- Category: menu association, localized title, display order, visibility.
- Menu item: category association, localized content, price, image, availability, display order.
- Translation: language-specific names and descriptions for categories and items.
- Theme/branding settings: selected theme and shop presentation tokens.
- QR identity: association with the stable public menu URL.
- Analytics event/aggregate: privacy-minimized menu views and timestamps or reporting buckets.

Use stable identifiers and preserve referential integrity. A change to a price or theme must not change the public menu URL.

## 9. Quality and acceptance criteria

The combined release is not complete until the following are verified:

### Owner app
- A shop owner can create a shop and publish a menu.
- The owner can create multiple categories and manage items.
- The owner can edit prices and item availability.
- The owner can configure branding, language content, and menu theme.
- The owner can preview the customer menu before publishing.
- The owner can retrieve and share the QR code and public URL.
- Unauthorized users cannot edit another shop's data.

### Customer menu
- Scanning the QR code opens a browser page without installing the app.
- The menu works on Android and iOS mobile browsers.
- Customers do not need to sign in.
- The page is responsive, readable, and usable on small screens.
- Category navigation, item details, prices, images, and availability are accurate.
- Supported languages and missing-translation fallbacks work correctly.
- Published edits appear without generating a new QR code.
- Shared WhatsApp links open the same public menu.

### Analytics and reliability
- Basic menu views are counted and visible to the owner.
- Analytics avoid collecting unnecessary personal information.
- Empty, slow, or failed image loads do not make the menu unusable.
- Public pages expose no private shop or owner information.

## 10. Delivery sequence

Build the combined scope in dependency order rather than treating MVP and V1 as separate releases:

1. Product and UX specification for the owner app and public menu.
2. Domain model, authentication, shop tenancy, and authorization.
3. Shop profile, categories, item CRUD, and publishing.
4. Public mobile menu and stable public URL.
5. QR generation and end-to-end scan testing.
6. Branding and multiple themes.
7. Gujarati, Hindi, and English content handling.
8. WhatsApp/device sharing.
9. Basic analytics.
10. Security, accessibility, performance, and real-shop usability testing.

The delivery sequence is a planning order, not permission to omit any combined MVP + V1 feature from the release definition.

## 11. Change control

- This document is the source of truth for the current combined MVP + V1 product scope.
- New feature requests must be evaluated against the vision, customer no-install requirement, and the 10,000-shop free-access commitment.
- V2 ideas remain out of scope until separately approved.
- Do not introduce business-model implementation into this product plan.
- Record material scope changes here with a reason and date.

## 12. Current project status

**Planning baseline established.** No implementation status is implied by this document. Feature completion must be tracked separately through issues, pull requests, tests, and release notes.
