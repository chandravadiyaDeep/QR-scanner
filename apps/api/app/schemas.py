"""Request and response models for the first onboarding milestone."""
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

Language = Literal["gu", "hi", "en"]
RESERVED_SLUGS = {
    "api", "admin", "auth", "login", "signup", "register", "settings",
    "dashboard", "m", "menu", "menus", "public", "static", "assets",
    "health", "ready", "docs", "openapi.json",
}


class ShopCreate(BaseModel):
    # The authenticated identity is derived from the JWT, never accepted in this body.
    model_config = ConfigDict(str_strip_whitespace=True)

    name: str = Field(min_length=1, max_length=120)
    slug: str = Field(min_length=3, max_length=70, pattern=r"^[a-z0-9]+(-[a-z0-9]+)*$")
    default_language: Language = "en"
    enabled_languages: list[Language] = Field(default_factory=lambda: ["en"])
    phone: str | None = Field(default=None, max_length=30)
    address: str | None = Field(default=None, max_length=300)

    @field_validator("slug")
    @classmethod
    def reject_reserved_slug(cls, value: str) -> str:
        # Protect application routes and infrastructure endpoints from slug collisions.
        if value in RESERVED_SLUGS:
            raise ValueError("This slug is reserved")
        return value

    @field_validator("enabled_languages")
    @classmethod
    def unique_languages(cls, value: list[str]) -> list[str]:
        # Preserve the user's chosen order while rejecting duplicates.
        if len(value) != len(set(value)):
            raise ValueError("enabled_languages must not contain duplicates")
        return value

    @model_validator(mode="after")
    def default_must_be_enabled(self):
        # A shop must always be able to display its default language.
        if self.default_language not in self.enabled_languages:
            raise ValueError("enabled_languages must include default_language")
        return self


class ShopCreated(BaseModel):
    shop_id: UUID
    menu_id: UUID
    name: str
    slug: str
    public_url: str
    is_published: bool = False


class ShopCreateResponse(BaseModel):
    # Keep the API envelope typed so OpenAPI documents the exact onboarding response.
    data: ShopCreated


class ShopSummary(BaseModel):
    shop_id: UUID
    shop_name: str
    role: str
    slug: str
    is_published: bool


class MeResponse(BaseModel):
    user_id: UUID
    shops: list[ShopSummary]
