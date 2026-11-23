"""FastAPI application factory and resource lifecycle."""
from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.config import get_settings
from app.db import open_pool
from app.routes import router, system_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create one bounded PostgreSQL pool for the process and close it cleanly.
    settings = get_settings()
    pool = open_pool(
        settings.database_url,
        settings.database_pool_min_size,
        settings.database_pool_max_size,
    )
    app.state.db_pool = pool
    try:
        yield
    finally:
        pool.close()


def create_app() -> FastAPI:
    # Keep operational health routes unversioned; business APIs remain under /api/v1.
    settings = get_settings()
    application = FastAPI(
        title="QR Digital Menu API",
        version="0.1.0",
        description="Trusted API for shop-owner management and public menu delivery.",
        lifespan=lifespan,
    )
    application.include_router(system_router)
    application.include_router(router, prefix=settings.api_prefix)
    return application


app = create_app()
