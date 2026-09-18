"""Database portability helpers."""

from __future__ import annotations

from django.db import connection


def for_update(queryset):
    """`SELECT ... FOR UPDATE`, or a plain query on backends without row locks.

    SQLite serialises writers anyway, so skipping the lock is safe there — it
    just means local dev doesn't need Postgres running.
    """
    if connection.features.has_select_for_update:
        return queryset.select_for_update()
    return queryset
