# Backend Integration Pack

Use this for APIs, authentication, offline data, files, notifications, deep links, Firebase, Supabase, REST, GraphQL, or custom backends.

## Integration decision matrix

| Need | Preferred default | Notes |
|---|---|---|
| Simple REST | Dio + typed DTOs | Add interceptors and typed errors. |
| Auth/session | Repository + secure storage | Never expose tokens to widgets/logs. |
| Realtime | Firebase/Supabase/WebSocket wrapper | Keep platform SDKs behind data sources. |
| Complex local queries | Drift | Good for relational data and migrations. |
| Simple cache | Hive/Isar/shared prefs depending data | Do not store secrets in plain prefs. |
| File upload | Upload service + progress state | Include retry/cancel/error states. |
| Push notifications | Messaging service + permission flow | Separate token registration from UI. |
| Deep links | go_router redirect + link parser | Test cold start and warm app paths. |

## API contract template

```markdown
# API Contract: [Feature]

## Endpoint
`METHOD /path`

## Auth
required | optional | none

## Request
[params/body]

## Response
[json]

## Errors
| Status/code | Meaning | User message | Retry? |
|---|---|---|---|

## Privacy
| Data | Purpose | Stored? | Shared? | Retention |
|---|---|---|---|---|
```

## Auth rules

- Use secure storage for refresh/access tokens where tokens must persist.
- Add refresh flow with single-flight protection to avoid multiple refresh calls.
- On logout, clear tokens, user cache, analytics identity, notification tokens if needed, and sensitive local data.
- Provide session-expired UI and safe redirect.

## Offline/cache rules

- Define cache key, TTL, invalidation triggers, and stale-data indicator.
- For offline mutations, define sync queue, retry/backoff, conflict resolution, and audit log.
- Do not cache highly sensitive data unless necessary and protected.

## SDK isolation

Wrap Firebase, Supabase, payment SDKs, analytics, crash reporting, ads, and AI services behind interfaces. This keeps tests fast and prevents vendor lock-in from leaking through widgets.
