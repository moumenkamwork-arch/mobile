# Promoo API contract planning

Last updated: 2026-06-25

## Sources

- User-provided MVP endpoint list in current task.
- Read-only backend docs:
  - `../promo_backend/docs/promoo-api-reference.json`
  - `../promo_backend/docs/Realtime-Chat-Flutter-Guide.md`

The backend was inspected read-only. No backend files were modified.

## Base URL

- Base URL usually includes `/api/v1`.
- Backend API reference examples use `http://localhost:3000/api/v1`.
- Flutter should use environment configuration for base URL.
- Base URL is not a secret. API secrets and service-role keys must never be stored in Flutter.

## Contract approach

- Define each feature contract before UI implementation.
- Use typed DTOs for remote JSON.
- Map DTOs into domain entities.
- Centralize API response parsing and error mapping.
- Use typed failures for timeout, offline, unauthorized, forbidden, not found, validation, rate limit, server error, and parsing failure.
- Treat missing optional fields as normal where the MVP says to hide fields.
- Keep development mock fallback behind repositories/data sources; production must use real backend data.

## Mobile MVP endpoints

| Feature | Endpoint | Auth | Planning notes |
| --- | --- | --- | --- |
| Home | `GET /home` | none in backend reference | First content slice after app shell. Response shape must be confirmed during slice. |
| Categories | `GET /categories` | none | Backend reference places this in `Search & Categories`. |
| Services | `GET /services` | none | Listing/contact only. Backend reference does not show category filter query on this endpoint; user-provided contract says `categoryId` and `category_id` variants may exist. Confirm during slice. |
| Services | `GET /services/:id` | none | Service detail should hide purchase flow, reviews, ratings, likes, and comments in MVP. |
| Seats | `GET /seats` | none | Backend reference shows optional `tier` query. |
| Seats | `GET /seats/me` | required | Requires auth token storage abstraction. |
| Seats | `POST /seats/:id/book` | required | Mutation must include loading, success, failure, and unauthenticated states. |
| Cup / Leaderboard | `GET /leaderboard?page=1&limit=20&type=all` | none | Use this endpoint, not search. `type`: `all`, `company`, `influencer`, `service_provider`. |
| Profiles | `GET /profiles/:idOrUsername` | none | Public profile detail. Hide reviews/ratings/likes/comments in MVP. |
| Profiles | `GET /profiles/me` | required | Used after auth lite. |
| Search | `GET /search?q={text}&type=all` | none | Backend reference supports `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, `accountType`. |
| Search | `GET /search?type=profiles&accountType=influencer` | none | Influencer profile discovery path. |
| Subscriptions | `GET /subscriptions/plans` | none | Packages are subscription plans. |
| Subscriptions | `POST /subscriptions` | required | Must call backend only; no Stripe secret keys in Flutter. |
| Chat | `GET /chats` | required | Skeleton phase only in MVP roadmap. |
| Chat | `POST /chats` | required | Start chat with `participant_id`. |
| Chat | `GET /chats/:roomId/messages` | required | Backend reference supports `page` and `limit`. |
| Chat | `POST /chats/:roomId/messages` | required | Send through REST API, not direct Supabase insert. |
| Chat | `PATCH /chats/:roomId/read` | required | Mark room messages read. |
| Notifications | `GET /notifications` | required | Backend reference supports `page` and `limit`. |
| Notifications | `PATCH /notifications/:id/read` | required | Mark single notification read. |
| Notifications | `PATCH /notifications/read-all` | required | Mark all read. |
| Notifications | `POST /notifications/token` | required | Requires push token setup later; do not add push package in planning step. |

## Backend reference observations

- `promoo-api-reference.json` contains 108 `flatEndpoints` across 20 modules.
- Mobile-relevant modules include `Home`, `Search & Categories`, `Services`, `Seats`, `Leaderboard`, `Profiles`, `Subscriptions`, `Chats`, and `Notifications`.
- `Search & Categories` includes `GET /categories`, `GET /categories/:id/content`, and `GET /search`.
- `GET /search` uses `categoryId`, not `category_id`, in the backend reference.
- `GET /services` is documented without query params in the backend reference, but the task says both `categoryId` and `category_id` filters may exist. The Services slice must verify the real backend behavior before finalizing DTOs/repository methods.
- Backend chat guide mentions Supabase Realtime for message inserts, but REST API remains the source for sending messages and triggering backend logic.

## MVP field handling

- Hide reviews and ratings even if returned.
- Hide likes and comments even if returned.
- Hide `promo_code`, `terms`, and `best_price` if absent.
- Services do not expose a purchase flow in MVP.
- Packages are represented by subscription plans.

## Auth and token planning

- Public endpoints can work before auth lite.
- Auth-required endpoints need a token storage abstraction.
- Token refresh and session expiry should live in network/core, not screens.
- On logout later, clear tokens, current user cache, notification token registration if relevant, and sensitive local state.
- Facebook login is excluded from MVP. If OAuth is used, prefer Google/Apple per backend reference, but auth lite should be scoped separately.

## Contract testing plan

For each slice:

- Add success response DTO fixture.
- Add missing optional field fixture.
- Add error response fixture.
- Test DTO parsing and mapper behavior.
- Test repository failure mapping for timeout, offline, unauthorized, server error, and parsing error.
- Test provider/controller loading, success, empty, error, and retry transitions.

## Open questions for implementation phases

- Exact response envelope for each endpoint: direct object/list vs `{ data, meta, error }`.
- Pagination metadata shape for leaderboard, chats, notifications, search, and category content.
- Service category filter parameter accepted by backend: `categoryId`, `category_id`, or both.
- Whether `/services?categoryId={id}` and `/services?category_id={id}` are aliases or one is deprecated.
- Whether subscription creation returns a checkout URL, payment intent, or another backend-defined object.
- Whether chat realtime is required for MVP skeleton or can remain REST-only until after MVP.

