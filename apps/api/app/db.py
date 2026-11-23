"""PostgreSQL connection-pool lifecycle and request dependency."""
from collections.abc import Iterator

import psycopg
from fastapi import Request
from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool


def open_pool(database_url: str, min_size: int, max_size: int) -> ConnectionPool:
    # Dict rows keep SQL results explicit and easy to serialize into API DTOs.
    return ConnectionPool(
        conninfo=database_url,
        min_size=min_size,
        max_size=max_size,
        kwargs={"row_factory": dict_row},
        open=True,
    )


def get_connection(request: Request) -> Iterator[psycopg.Connection]:
    # The pool is created once at startup and closed by the application lifespan.
    pool: ConnectionPool = request.app.state.db_pool
    with pool.connection() as connection:
        yield connection
