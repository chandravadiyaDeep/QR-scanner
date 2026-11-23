# API Contracts — QR Digital Menu

**Version:** v1  
**Base URL:** configured per environment; path prefix `/api/v1`  
**Authority:** FastAPI OpenAPI document generated from implementation. This Markdown is the human-readable contract.

## 1. Conventions

- HTTPS only outside local development.
- JSON request/response bodies, UTF-8.
- Owner endpoints: `Authorization: Bearer <Supabase access token>`.
- Public menu endpoints: no authorization required.
- IDs: UUID strings.
- Timestamps: ISO 8601 UTC.
- Prices: decimal strings, e.g. `"85.00"`; currency `"INR"`.
- Languages: `gu`, `hi`, `en`.
- Pagination: `limit` and `cursor` for collection endpoints when needed.
- Client must not send a trusted owner ID or role; identity comes from verified JWT.

## 2. Standard response and error shapes

Success example:

```json
{
  "data": {
    "id": "00000000-0000-4000-8000-000000000001"
  },
  "meta": {}
}
```

Error example:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "One or more fields are invalid.",
    "details": [
      { "field": "name", "issue": "This field is required." }
    ],
    "request_id": "req_..."
  }
}
```

| HTTP | Meaning |
|---|---|
| 400 | Malformed request or invalid state transition |
| 401 | Missing, invalid, or expired token |
| 403 | Authenticated but not allowed for this shop/action |
| 404 | Resource not found or not visible to caller |
| 409 | Duplicate slug or conflicting state |
| 413 | Upload too large |
| 415 | Unsupported media type |
| 422 | Field validation failed |
| 429 | Rate limit exceeded |
| 500 | Unexpected server failure; safe message plus request ID |

Do not expose stack traces, SQL errors, storage credentials, JWT contents, or internal paths.

## 3. Authentication and identity

Supabase Auth SDK handles sign-up, sign-in, refresh, and sign-out in Flutter. FastAPI validates the access token on each protected request.

### GET /api/v1/me

**Auth:** required.

Response:

```json
{
  "data": {
    "user_id": "uuid",
    "shops": [
      {
        "shop_id": "uuid",
        "shop_name": "Shree Snacks",
        "role": "owner",
        "slug": "shree-snacks-anand",
        "is_published": false
      }
    ]
  }
}
```

## 4. Shops

### POST /api/v1/shops

**Auth:** required. Creates shop, owner membership, and primary menu in one transaction.

Request:

```json
{
  "name": "Shree Snacks",
  "slug": "shree-snacks-anand",
  "default_language": "gu",
  "enabled_languages": ["gu", "hi", "en"],
  "phone": null,
  "address": null
}
```

Response: `201 Created`.

```json
{
  "data": {
    "shop_id": "uuid",
    "menu_id": "uuid",
    "name": "Shree Snacks",
    "slug": "shree-snacks-anand",
    "public_url": "https://<public-domain>/m/shree-snacks-anand",
    "is_published": false
  }
}
```

Validation:
- Slug is lowercase alphanumeric segments separated by single hyphens.
- Slug is unique and reserved words are rejected.
- Enabled languages must include default language and contain only supported codes.
- User identity is taken from JWT, not request body.

### GET /api/v1/shops/{shop_id}

**Auth:** shop member. Returns editable shop profile.

### PATCH /api/v1/shops/{shop_id}

**Auth:** owner. Updates name, description, optional public phone/address, logo reference, brand color, and language configuration. Slug changes are not supported by ordinary profile updates.

Request example:

```json
{
  "name": "Shree Snacks & Cafe",
  "description": "Fresh snacks",
  "phone": null,
  "address": null,
  "brand_color": "#173B6C",
  "default_language": "gu",
  "enabled_languages": ["gu", "hi", "en"]
}
```

## 5. Menu read and edit

### GET /api/v1/shops/{shop_id}/menu

**Auth:** shop member. Returns full editable menu, including drafts and translations.

### POST /api/v1/shops/{shop_id}/categories

**Auth:** owner/editor.

Request:

```json
{
  "sort_order": 1,
  "is_visible": true,
  "translations": {
    "gu": { "name": "નાસ્તો", "description": null },
    "hi": { "name": "नाश्ता", "description": null },
    "en": { "name": "Snacks", "description": null }
  }
}
```

Response: `201 Created` with category resource.

### PATCH /api/v1/shops/{shop_id}/categories/{category_id}

**Auth:** owner/editor. Partial update of visibility, order, and translations.

### DELETE /api/v1/shops/{shop_id}/categories/{category_id}

**Auth:** owner. Must explicitly resolve child items. API must not silently orphan menu items. Preferred behavior: return `409 CATEGORY_NOT_EMPTY` unless caller requests an explicitly supported archive operation.

### POST /api/v1/shops/{shop_id}/items

**Auth:** owner/editor.

Request:

```json
{
  "category_id": "uuid",
  "price": "85.00",
  "currency": "INR",
  "image_path": null,
  "is_available": true,
  "sort_order": 1,
  "translations": {
    "gu": { "name": "ઢોસા", "description": "ગરમ અને તાજો ઢોસા" },
    "hi": { "name": "डोसा", "description": "गरम और ताज़ा डोसा" },
    "en": { "name": "Dosa", "description": "Fresh dosa served hot" }
  }
}
```

Response: `201 Created`.

Validation:
- Category must belong to the requested shop's menu.
- Price must be a non-negative decimal with at most two fractional digits.
- Currency is INR for initial release.
- Translation names are required in at least the default language.
- Image path must belong to this shop's approved storage namespace.

### PATCH /api/v1/shops/{shop_id}/items/{item_id}

**Auth:** owner/editor. Supports partial updates to price, availability, category, order, image, and translations.

### DELETE /api/v1/shops/{shop_id}/items/{item_id}

**Auth:** owner. Archives the item; public projection excludes archived items.

## 6. Languages, branding, themes

### PUT /api/v1/shops/{shop_id}/settings/languages

Request:

```json
{
  "default_language": "gu",
  "enabled_languages": ["gu", "hi", "en"]
}
```

### PUT /api/v1/shops/{shop_id}/branding

Request:

```json
{
  "brand_color": "#173B6C",
  "logo_path": "shops/<shop-id>/logo/<asset-id>.webp"
}
```

### PUT /api/v1/shops/{shop_id}/theme

Request:

```json
{
  "theme_key": "modern"
}
```

Allowed initial theme keys: `classic`, `modern`, `minimal`. API rejects arbitrary CSS, HTML, or unknown theme keys.

## 7. Image upload

### POST /api/v1/shops/{shop_id}/uploads/presign

**Auth:** owner/editor.

Request:

```json
{
  "purpose": "menu_item",
  "file_name": "dosa.webp",
  "content_type": "image/webp",
  "size_bytes": 245000
}
```

Response:

```json
{
  "data": {
    "upload_id": "uuid",
    "upload_url": "https://signed-upload-url",
    "storage_path": "shops/<shop-id>/items/<asset-id>.webp",
    "expires_at": "2026-11-23T12:00:00Z",
    "required_headers": {}
  }
}
```

### POST /api/v1/shops/{shop_id}/uploads/complete

Request:

```json
{
  "upload_id": "uuid",
  "storage_path": "shops/<shop-id>/items/<asset-id>.webp"
}
```

API verifies the upload exists, matches the expected path, type, and size, then returns a safe asset reference. Initial implementation may use a backend-proxied upload if signed direct uploads complicate validation; the public contract should remain stable.

## 8. Preview and publication

### GET /api/v1/shops/{shop_id}/menu/preview

**Auth:** shop member. Returns a customer-shaped draft preview; must never be exposed to anonymous clients.

### POST /api/v1/shops/{shop_id}/menu/publish

**Auth:** owner.

Request:

```json
{
  "confirm": true
}
```

Response:

```json
{
  "data": {
    "is_published": true,
    "published_at": "2026-11-23T10:00:00Z",
    "public_url": "https://<public-domain>/m/shree-snacks-anand"
  }
}
```

Publishing validates shop name, default language, menu presence, category/item content, and public slug. It does not require every optional translation to exist.

### POST /api/v1/shops/{shop_id}/menu/unpublish

**Auth:** owner. Makes public route unavailable while preserving draft data.

### GET /api/v1/shops/{shop_id}/public-link

**Auth:** shop member. Returns canonical URL and publication status.

## 9. Public menu

### GET /api/v1/public/menus/{shop_slug}

**Auth:** none. Returns published customer-safe DTO only.

Response:

```json
{
  "data": {
    "shop": {
      "name": "Shree Snacks",
      "slug": "shree-snacks-anand",
      "logo_url": null,
      "brand_color": "#173B6C",
      "default_language": "gu",
      "enabled_languages": ["gu", "hi", "en"]
    },
    "menu": {
      "theme_key": "modern",
      "published_at": "2026-11-23T10:00:00Z",
      "categories": [
        {
          "id": "uuid",
          "sort_order": 1,
          "translations": {
            "gu": { "name": "નાસ્તો" },
            "hi": { "name": "नाश्ता" },
            "en": { "name": "Snacks" }
          },
          "items": [
            {
              "id": "uuid",
              "price": "85.00",
              "currency": "INR",
              "is_available": true,
              "image_url": null,
              "translations": {
                "gu": { "name": "ઢોસા", "description": "ગરમ અને તાજો ઢોસા" },
                "hi": { "name": "डोसा", "description": "गरम और ताज़ा डोसा" },
                "en": { "name": "Dosa", "description": "Fresh dosa served hot" }
              }
            }
          ]
        }
      ]
    }
  }
}
```

Rules:
- No login required.
- Unpublished/missing shop returns a generic `404 MENU_NOT_FOUND`.
- Hidden categories and archived items are omitted.
- Unavailable items are included with `is_available: false`.
- Never include owner email, auth ID, member records, private settings, or draft data.
- Translation fallback is performed using `default_language`.
- Public endpoint has rate limiting and cache policy.

## 10. Analytics

### POST /api/v1/public/menus/{shop_slug}/views

**Auth:** none. Rate-limited. Body:

```json
{
  "source": "qr"
}
```

Response: `202 Accepted`:

```json
{
  "data": { "accepted": true }
}
```

No IP address or user identity is retained. Server uses coarse short-lived deduplication material only if necessary; store only a hash with a short retention period.

### GET /api/v1/shops/{shop_id}/analytics/summary?from=2026-11-01&to=2026-11-23

**Auth:** shop member.

Response:

```json
{
  "data": {
    "total_views": 1250,
    "daily": [
      { "date": "2026-11-22", "views": 74 },
      { "date": "2026-11-23", "views": 91 }
    ]
  }
}
```

Dates are inclusive and bounded (maximum query window to be enforced by API). Metrics are aggregate only.

## 11. Health and readiness

| Method/path | Auth | Purpose |
|---|---|---|
| GET /health | None | Process liveness |
| GET /ready | None/internal | Database and dependency readiness |

Do not expose database URLs, keys, or internal configuration in health responses.

## 12. Contract testing

- FastAPI OpenAPI output is the executable source of truth.
- Validate every request/response against Pydantic schemas.
- Add contract fixtures consumed by Flutter and Next.js.
- Test 401/403/404/409/422 paths, not only success.
- Add explicit cross-shop access tests.
- Public DTO tests must assert absence of private fields.
- Changes to this contract require coordinated API, Flutter, and web updates.
