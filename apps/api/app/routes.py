"""HTTP routes for health, current-user context, and shop onboarding."""
from uuid import UUID

import psycopg
from fastapi import APIRouter, Depends, HTTPException, status

from app.auth import get_current_user
from app.config import Settings, get_settings
from app.db import get_connection
from app.schemas import MeResponse, ShopCreate, ShopCreateResponse, ShopCreated, ShopSummary

router = APIRouter()


@router.get("/health")
def health() -> dict[str, str]:
    # Liveness only; never disclose dependency credentials or configuration.
    return {"status": "ok"}


@router.get("/ready")
def ready(connection: psycopg.Connection = Depends(get_connection)) -> dict[str, str]:
    # Readiness checks database connectivity without returning internal details.
    connection.execute("select 1")
    return {"status": "ready"}


@router.get("/me", response_model=MeResponse)
def me(
    user: dict = Depends(get_current_user),
    connection: psycopg.Connection = Depends(get_connection),
):
    # Membership is queried by the verified JWT subject, not a client-supplied ID.
    rows = connection.execute(
        """select s.id as shop_id, s.name as shop_name, sm.role, s.slug,
                  (s.is_published and m.is_published) as is_published
           from public.shop_members sm
           join public.shops s on s.id = sm.shop_id
           join public.menus m on m.shop_id = s.id
           where sm.user_id = %s order by s.created_at""",
        (user["sub"],),
    ).fetchall()
    return MeResponse(user_id=UUID(user["sub"]), shops=[ShopSummary(**row) for row in rows])


@router.post("/shops", response_model=ShopCreateResponse, status_code=status.HTTP_201_CREATED)
def create_shop(
    payload: ShopCreate,
    user: dict = Depends(get_current_user),
    connection: psycopg.Connection = Depends(get_connection),
    settings: Settings = Depends(get_settings),
):
    # Create shop, owner membership, and primary menu in one transaction.
    try:
        with connection.transaction():
            shop = connection.execute(
                """insert into public.shops
                   (name, slug, phone, address, default_language, enabled_languages)
                   values (%s, %s, %s, %s, %s, %s)
                   returning id, name, slug, is_published""",
                (payload.name, payload.slug, payload.phone, payload.address,
                 payload.default_language, payload.enabled_languages),
            ).fetchone()
            connection.execute(
                "insert into public.shop_members (shop_id, user_id, role) values (%s, %s, 'owner')",
                (shop["id"], user["sub"]),
            )
            menu = connection.execute(
                """insert into public.menus (shop_id, default_language)
                   values (%s, %s) returning id, is_published""",
                (shop["id"], payload.default_language),
            ).fetchone()
    except psycopg.errors.UniqueViolation as exc:
        # Slug collisions are a stable conflict response, not a database error leak.
        raise HTTPException(
            status_code=409,
            detail={"code": "SLUG_ALREADY_EXISTS", "message": "That public menu URL is unavailable."},
        ) from exc

    result = ShopCreated(
        shop_id=shop["id"], menu_id=menu["id"], name=shop["name"], slug=shop["slug"],
        public_url=f"{str(settings.public_menu_base_url).rstrip('/')}/m/{shop['slug']}",
        is_published=bool(menu["is_published"]),
    )
    return ShopCreateResponse(data=result)
