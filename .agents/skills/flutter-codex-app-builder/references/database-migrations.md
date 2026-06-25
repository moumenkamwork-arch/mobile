# Database, Offline, and Migration Strategy

Use this guide when the app stores local data, supports offline mode, syncs with a backend, or changes schema.

## Storage decision rules

- Use secure storage only for secrets/tokens/sensitive small values.
- Use simple key-value storage for preferences only.
- Use a local database for queryable relational or offline data.
- Avoid duplicating backend state locally unless offline performance or UX requires it.

## Migration policy

- Every schema change needs a version number and migration note.
- Migrations must be forward-compatible with existing installed apps.
- Destructive migrations require explicit product approval and backup/restore consideration.
- Test migration from at least the last production schema.

## Offline/sync checklist

- Define source of truth.
- Define conflict resolution: server wins, client wins, merge, or manual review.
- Queue writes when offline only if product semantics allow it.
- Show sync status to users when data freshness matters.
- Retry with backoff and avoid duplicate writes.
- Keep timestamps and IDs stable across retries.

## Test cases

- Fresh install.
- Upgrade from previous schema.
- Failed migration.
- Offline create/update/delete.
- Conflict after reconnect.
- Cache clear and re-login.
