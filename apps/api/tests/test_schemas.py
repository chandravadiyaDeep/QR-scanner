"""Unit tests for onboarding payload validation."""
import pytest
from pydantic import ValidationError

from app.schemas import ShopCreate


def test_valid_shop_create_payload():
    # Gujarati default is valid when it is present in the enabled language list.
    payload = ShopCreate(name="Shree Snacks", slug="shree-snacks", default_language="gu",
                         enabled_languages=["gu", "hi", "en"])
    assert payload.default_language == "gu"


def test_default_language_must_be_enabled():
    # Prevent onboarding from creating a shop with no configured default translation.
    with pytest.raises(ValidationError):
        ShopCreate(name="Shree Snacks", slug="shree-snacks", default_language="gu",
                   enabled_languages=["en"])


def test_duplicate_languages_are_rejected():
    # Duplicate codes create ambiguous language settings and must fail validation.
    with pytest.raises(ValidationError):
        ShopCreate(name="Shree Snacks", slug="shree-snacks", enabled_languages=["en", "en"])
