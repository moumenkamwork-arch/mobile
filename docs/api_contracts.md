# Promoo API contract planning

Last updated: 2026-06-26

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
| Home | `GET /home` | none in backend reference | Implemented in Home slice. Backend service returns `{ success, data, message }`; data includes `stories`, `categories`, `featured_profiles`, `promoo_of_the_day`, `latest_offers`, `services`, and `ads`. |
| Home / Offers | `GET /offers/:id` | optional auth | Implemented for lightweight Home offer/detail display. Backend route is public optional-auth and validates UUID ids; mock mode uses stable demo ids. No purchase/order/checkout in MVP. |
| Home / Ads | `GET /ads/active` | none | Used for public ad detail fallback by finding an active ad by id. Backend has no public `GET /ads/:id`. No click/impression recording is triggered by the MVP detail screen. |
| Categories | `GET /categories` | none | Backend reference places this in `Search & Categories`. |
| Services | `GET /services` | none | Implemented in Services slice. Backend returns paginated `{ success, data, message, meta }`; supports `q` search. |
| Services | `GET /services?category_id={id}` | none | Flutter intentionally uses `category_id`. Backend also accepts `categoryId`, but the app does not use it. |
| Services | `GET /services/:id` | none | Implemented for lightweight service detail/contact display. Real backend route is public and validates UUID ids; mock mode uses stable demo ids. No purchase flow, reviews, ratings, likes, or comments in MVP. |
| Seats | `GET /seats` | none | Implemented in Seats slice. Backend supports optional `tier=gold|silver|bronze`. |
| Seats | `GET /seats/me` | required | Repository/data source support exists, but UI does not call it until Auth lite/token storage exists. |
| Seats | `POST /seats/:id/book` | required | Repository/data source support exists. UI does not call it until Auth lite exists; seat id must stay in URL path. |
| Cup / Leaderboard | `GET /leaderboard?page=1&limit=20&type=all` | none | Use this endpoint, not search. `type`: `all`, `company`, `influencer`, `service_provider`. |
| Profiles | `GET /profiles/:idOrUsername` | none | Implemented in Profile + Packages slice. Public profile detail by id or username. |
| Profiles | `GET /profiles/me` | required | Repository support exists indirectly through `ProfileRepository`; UI does not require it until Auth lite. |
| Profiles | `PUT /profiles/me` | required | Represented as auth-required repository placeholder only. No real edit submission in UI yet. |
| Search | `GET /search?q={text}&type=all` | none | Implemented in Search slice. Backend returns grouped preview keys `profiles`, `offers`, `ads`, and `services`. |
| Search | `GET /search?type=profiles&accountType=influencer&q={text}` | none | Implemented as the Influencers filter. Use `accountType`, not `account_type`. |
| Search | `GET /search?type=services&q={text}` | none | Implemented as the Services search filter. |
| Search | `GET /search?type=offers&q={text}` | none | Implemented as the Offers search filter. Results can navigate to `/home/items/offer/:id`. |
| Search | `GET /search?type=ads&q={text}` | none | Implemented as the Ads search filter. Results can navigate to `/home/items/ad/:id`. |
| Auth | `POST /auth/register/email` | none | Implemented in Auth Lite. Body uses `email`, `password`, `full_name`, and `account_type`; response may include `session: null` when verification is required. |
| Auth | `POST /auth/login/email` | none | Implemented in Auth Lite. Body uses `email` and `password`; response is parsed as Supabase-like `{ user, session }`. |
| Auth | `POST /auth/refresh` | refresh token | Repository/data-source support exists. Body uses `refresh_token`; secure automatic refresh is deferred until token persistence/hardening. |
| Auth | `POST /auth/logout` | optional bearer token | Implemented in Auth Lite. Sends `Authorization: Bearer <accessToken>` when a token exists and clears in-memory session state. |
| Subscriptions | `GET /subscriptions/plans` | none | Packages are subscription plans. |
| Subscriptions | `POST /subscriptions` | required | Must call backend only; no Stripe secret keys in Flutter. |
| Chat | `GET /chats` | required | Implemented in Chat skeleton. Backend supports `page` and `limit`; real mode needs bearer token from Auth Lite in-memory session. |
| Chat | `POST /chats` | required | Repository support exists for start/open chat with `participant_id`; UI does not start profile-specific chats yet. |
| Chat | `GET /chats/:roomId/messages` | required | Implemented in Chat conversation skeleton. Backend supports `page` and `limit`. |
| Chat | `POST /chats/:roomId/messages` | required | Implemented through repository/controller for text messages. Fake mode is demo-ready; real mode requires bearer token. |
| Chat | `PATCH /chats/:roomId/read` | required | Implemented through repository/data layer and called after message load. |
| Chat | `DELETE /chats/:roomId` | required | Confirmed in backend but not exposed in Flutter UI/repository yet. |
| Notifications | `GET /notifications?page=1&limit=20` | required | Implemented in Notifications skeleton. Real mode needs bearer token from Auth Lite in-memory session. |
| Notifications | `PATCH /notifications/:id/read` | required | Implemented through repository/controller. |
| Notifications | `PATCH /notifications/read-all` | required | Implemented through repository/controller. |
| Notifications | `DELETE /notifications/:id` | required | Implemented through repository/controller and UI delete action. |
| Notifications | `POST /notifications/token` | required | Represented in repository/data layer only. Final FCM token collection and push setup are deferred. |

## Backend reference observations

- `promoo-api-reference.json` contains 108 `flatEndpoints` across 20 modules.
- Mobile-relevant modules include `Home`, `Search & Categories`, `Services`, `Seats`, `Leaderboard`, `Profiles`, `Subscriptions`, `Chats`, and `Notifications`.
- Home controller uses `apiResponse.success(res, data, 'Home feed retrieved successfully')`.
- Home service currently returns `stories`, `categories`, `featured_profiles`, `promoo_of_the_day`, `latest_offers`, `services`, and `ads`.
- Offer routes confirm public optional-auth `GET /offers`, `GET /offers/:id`, and `GET /offers/profile/:profileId`.
- `GET /offers/:id` returns an offer with nested `profile:profiles(id, full_name, username, avatar_url, location)` and `category:categories(id, name_ar, name_en, slug)`.
- Offer route validation expects UUID ids in real backend mode.
- Ad routes confirm public `GET /ads/active`, `POST /ads/:id/impression`, and `POST /ads/:id/click`.
- There is no public `GET /ads/:id`; protected ad detail-like routes are owner/admin scoped.
- `GET /ads/active` returns active rows with `id`, `profile_id`, `title`, `description`, `media_url`, `ad_type`, and `target_url`.
- `Search & Categories` includes `GET /categories`, `GET /categories/:id/content`, and `GET /search`.
- `GET /search` uses `categoryId`, not `category_id`, in the backend reference.
- `GET /search` backend validator confirms `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, and `accountType`.
- `GET /search` backend supports type values `profiles`, `offers`, `ads`, `services`, and `all`.
- `GET /search?type=all` returns grouped preview data with `profiles`, `offers`, `ads`, and `services`; specific type searches return paginated list data with `meta`.
- `GET /services` backend controller accepts both `categoryId` and `category_id`, then passes a `categoryId` service parameter internally. Flutter uses `category_id` only.
- `GET /services` backend controller accepts `q` and returns `apiResponse.paginated(...)`.
- `GET /services/:id` is a supported public route. Backend route validation expects a UUID id in real mode.
- `GET /categories` backend returns `apiResponse.success(...)` with category rows ordered by `sort_order`.
- Backend chat guide mentions Supabase Realtime for message inserts, but REST API remains the source for sending messages and triggering backend logic.
- `GET /seats` backend returns `apiResponse.success(...)` with seat rows ordered by `position`.
- Seat rows include `tier`, `price`, `status`, `position`, `influencer_id`, `expires_at`, timestamps, and optional nested `profile`.
- `POST /seats/:id/book` backend returns checkout metadata including `checkoutUrl`, `sessionId`, `paymentId`, and `status`.
- Auth routes confirm email register/login, refresh, and logout endpoints.
- Email registration accepts `email`, `password`, `full_name`, and `account_type`.
- Email login accepts `email` and `password`.
- Token refresh accepts `refresh_token`.
- Auth middleware reads bearer tokens from the `Authorization` header.
- Auth responses are Supabase-like with `user` and `session`; registration can return `session: null` when email verification is needed.
- Backend routes confirm Chat is mounted at `/chats`; `/chat/rooms` is not used.
- Chat routes require auth and include list, start/open chat, messages, send message, mark read, and delete chat.
- Chat list response rows are built as `{ room, otherParticipant, lastMessage, unreadCount }`.
- Chat message rows include `id`, `room_id`, `sender_id`, `content`, `type`, `media_url`, `created_at`, `is_read`, and optional nested `sender`.
- Notifications routes are mounted at `/notifications`, require auth, and include list, mark single read, mark all read, delete, and token registration.
- Notification rows include `id`, `title`, `body`, `type`, `data`, `is_read`, and `created_at`.
- Notification token registration accepts `token` and optional `device_type` values `ios`, `android`, or `web`.

## MVP field handling

- Hide reviews and ratings even if returned.
- Hide likes and comments even if returned.
- Hide `promo_code`, `terms`, and `best_price` if absent.
- Services do not expose a purchase flow in MVP.
- Profile packages shown on profile screens are represented by services connected to the profile. They are display/contact only in this MVP phase.

## Auth and token planning

- Auth Lite implements email registration, email login, logout, refresh repository support, and in-memory session state.
- Existing public endpoints still work without auth and remain unguarded.
- Auth-required endpoint execution still needs secure token persistence before production use.
- Token refresh and session expiry should live in network/core, not screens, when automatic refresh is introduced.
- Logout clears in-memory session state now; later it should also clear secure token storage, current user cache, notification token registration if relevant, and sensitive local state.
- Facebook login is excluded from MVP. Google/Apple, phone login, and OTP final flows remain deferred and should not add client SDKs until explicitly scoped.
- Do not store Supabase service role keys, Firebase private keys, Stripe secret keys, or any API secrets in Flutter.

## Contract testing plan

For each slice:

- Add success response DTO fixture.
- Add missing optional field fixture.
- Add error response fixture.
- Test DTO parsing and mapper behavior.
- Test repository failure mapping for timeout, offline, unauthorized, server error, and parsing error.
- Test provider/controller loading, success, empty, error, and retry transitions.

## Home slice contract notes

- Flutter parser accepts the confirmed backend envelope and direct object data.
- Flutter parser also accepts common nested variants such as `home`, `feed`, or `sections` to reduce backend drift risk.
- Optional sections can be absent or empty.
- The Home UI renders only sections that are present after mapping.
- Home detail route `/home/items/:type/:id` supports `offer` and `ad`.
- Offer detail uses confirmed `GET /offers/:id`.
- Ad detail uses confirmed `GET /ads/active` and finds the active ad by id because public `GET /ads/:id` is not available.
- Home detail parser accepts wrapped/direct offer objects, active ad list rows, nested `offer`/`ad`/`item` variants, nested profile/category objects, media URL arrays, tags, promo code, valid until, terms, price, currency, and location when present.
- Home detail UI is display/contact only: Contact shows a coming-soon notice, Open chats routes to `/chats`, View provider profile routes to `/profiles/:id` when available, and Location shows a coming-soon notice.
- Home detail does not trigger ad click/impression endpoints.
- Reviews, ratings, likes, and comments are not parsed into Home MVP entities.
- `ads` can be used as a promoted highlight fallback only when `promoo_of_the_day` is absent.
- `PROMOO_USE_MOCKS=true` uses fake Home content behind the repository/data-source boundary.

## Services slice contract notes

- Flutter parser accepts paginated envelopes and direct list/object data.
- Category rows may expose `name`, `name_ar`, `name_en`, and `slug`.
- Service rows may expose nested `profile` and `category` objects.
- Service detail supports wrapped `{ success, data }`, direct object, and common nested object variants.
- Service detail UI can display title, description, category, provider, provider/profile id, location, price/currency, delivery days, tags, and image fallback when present.
- Service price displays API `currency` when present.
- If price exists but `currency` is missing, Flutter uses `AppConfig.fallbackCurrency`.
- `PROMOO_FALLBACK_CURRENCY` defaults to `AED`.
- `/services/:id` is wired for display/contact only. Contact provider shows a safe coming-soon notice, Open chats routes to `/chats`, and View provider profile routes to `/profiles/:id` when a provider id is available.
- Reviews, ratings, likes, comments, purchase, order, checkout, and payment fields are not part of Services MVP UI.
- `PROMOO_USE_MOCKS=true` uses fake Services content behind the repository/data-source boundary.

## Seats slice contract notes

- Backend code and generated docs confirm `GET /seats`, `GET /seats/me`, and `POST /seats/:id/book`.
- `GET /seats` is public and accepts optional `tier=gold|silver|bronze`.
- `GET /seats/me` is auth-required.
- `POST /seats/:id/book` is auth-required and influencer-only; do not use `POST /seats/book`.
- Booking seat id is passed in the URL path.
- Booking creates a Stripe Checkout session on the backend, but Flutter does not open checkout URLs in this slice.
- Confirmed booking response fields: `checkoutUrl`, `sessionId`, `paymentId`, and `status`.
- Confirmed seat row fields include `id`, `tier`, `price`, `influencer_id`, `status`, `expires_at`, `position`, `created_at`, `updated_at`, and optional nested `profile`.
- Backend statuses include `available`, `booked`, and `pending`; Flutter also accepts `expired` and maps unknown values to `SeatStatus.unknown`.
- Flutter displays API `currency` when present. If price exists but `currency` is missing, Flutter uses `AppConfig.fallbackCurrency` (`AED`).
- Flutter UI intentionally returns an auth-required/deferred booking state until Auth lite and token storage exist.
- `PROMOO_USE_MOCKS=true` uses fake Seats content behind the repository/data-source boundary.

## Profile + Packages slice contract notes

- Backend code and generated docs confirm `GET /profiles/:idOrUsername`, `GET /profiles/me`, and `PUT /profiles/me`.
- Public profile route accepts profile id or username.
- `GET /profiles/me` and `PUT /profiles/me` are auth-required; the current Profile UI does not call them.
- Confirmed profile fields include `id`, `full_name`, `username`, `bio`, `location`, `website`, `avatar_url`, `cover_url`, `account_type`, `is_verified`, `is_featured`, `followers_count`, and nested `categories`.
- Profile packages in this MVP are services connected to the profile, not subscription plans.
- Backend `GET /services` currently supports `categoryId`, `category_id`, and `q`; no confirmed `profileId` or `profile_id` query filter exists.
- Remote package loading currently fetches the public first page of `GET /services` and filters by nested `profile.id` client-side. This is a documented limitation until the backend exposes a profile service query.
- Package cards are display/contact only. No package purchase, subscription, payment, checkout, or service order flow exists in this slice.
- Package price displays API currency when present. If price exists but `currency` is missing, Flutter uses `AppConfig.fallbackCurrency` (`AED`).
- Follow, message, and edit actions return safe login-required or coming-soon UI states only.
- `PROMOO_USE_MOCKS=true` uses fake public profile/package content behind the repository/data-source boundary. The Profile tab demo also uses the fake data source until Auth/current-user behavior exists.

## Cup / Leaderboard slice contract notes

- Backend code and generated docs confirm `GET /leaderboard?page=1&limit=20&type=all`.
- Supported type values are `all`, `company`, `influencer`, and `service_provider`.
- `all` excludes regular `user` accounts in the backend.
- Backend response is paginated through `apiResponse.paginated(...)` and returns ranked profile rows in `data`.
- Confirmed row fields: `rank`, `id`, `full_name`, `username`, `avatar_url`, `bio`, `account_type`, `followers_count`, `is_verified`, and `is_featured`.
- Flutter uses `/leaderboard` directly. The fallback `GET /search?type=profiles&sort=followers&order=desc` is not used.
- Flutter currently requests the first page with `page=1`, `limit=20`, and `type=all`.
- DTO parsing also accepts direct lists, nested `items`/`profiles`/`leaderboard` variants, and nested `profile`/`user`/`account` objects to reduce backend drift risk.
- `PROMOO_USE_MOCKS=true` uses fake leaderboard profiles behind the repository/data-source boundary.

## Search slice contract notes

- Backend code and generated docs confirm `GET /search`.
- Confirmed query parameters: `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, and `accountType`.
- Confirmed type values: `all`, `profiles`, `offers`, `ads`, and `services`.
- Flutter uses `accountType=influencer` for the Influencers filter; do not use `account_type`.
- Flutter currently exposes the MVP filters: All, Profiles, Influencers, Services, Offers, and Ads.
- Flutter sends `q`, `type`, `page`, and `limit`; advanced filters such as category, price, and location are not exposed in this slice.
- `type=all` returns grouped preview data: `profiles`, `offers`, `ads`, and `services`.
- Specific type searches return paginated list data with `meta`.
- DTO parsing also accepts direct lists, wrapped envelopes, nested `results`/`items`/`records`, and service/offer/ad/profile nested profile variants.
- Search requires at least 2 characters and runs on submit/button/filter change, not every keystroke.
- Profile results navigate to `/profiles/:id`.
- Service results navigate to `/services/:id` when an id exists.
- Offer and ad results navigate to `/home/items/:type/:id` when an id exists.
- No offer purchase, checkout, payment, order flow, ad click/impression recording, or final favorite/share behavior is added.
- `PROMOO_USE_MOCKS=true` uses fake mixed search content behind the repository/data-source boundary.

## Auth Lite slice contract notes

- Backend code confirms `POST /auth/register/email`, `POST /auth/login/email`, `POST /auth/refresh`, and `POST /auth/logout`.
- `POST /auth/register/email` requires `email`, `password`, and `full_name`; `account_type` defaults to `user` on the backend when omitted, but Flutter sends the selected account type explicitly.
- Backend validator requires password length of at least 8 characters and full name length of at least 2 characters.
- Supported account type values include `user`, `company`, `influencer`, and `service_provider`.
- `POST /auth/login/email` requires `email` and `password`.
- `POST /auth/refresh` requires `refresh_token`.
- `POST /auth/logout` accepts an optional bearer token; Flutter sends it when the in-memory session has an access token.
- DTO parsing accepts wrapped `{ success, data }`, direct `{ user, session }`, nested session user variants, and token key variants such as `access_token`, `refresh_token`, `accessToken`, and `refreshToken`.
- Registration can succeed without an authenticated session; Flutter treats that as a verification-required success message rather than an authenticated state.
- Auth Lite uses in-memory session storage only. Secure persistence, automatic refresh, deep auth guards, OAuth SDKs, phone/OTP final flow, delete account, and current-user profile mutation are deferred.
- `PROMOO_USE_MOCKS=true` uses fake Auth responses behind the repository/data-source boundary.

## Chat + Notifications skeleton contract notes

- Backend code confirms Chat routes are mounted at `/chats`; the previous `/chat/rooms` uncertainty is resolved.
- All backend Chat routes require bearer auth.
- `GET /chats` returns paginated rows containing `room`, `otherParticipant`, `lastMessage`, and `unreadCount`.
- `POST /chats` accepts body `participant_id`.
- `GET /chats/:roomId/messages` accepts `page` and `limit`.
- `POST /chats/:roomId/messages` accepts `content`, `type`, and optional `media_url`; Flutter sends text-only messages in this skeleton.
- Backend supports message types `text`, `image`, `video`, and `file`, but Flutter does not implement media upload in this phase.
- `PATCH /chats/:roomId/read` marks room messages read.
- Backend also supports `DELETE /chats/:roomId`, but the Flutter skeleton does not expose chat deletion yet.
- Backend code confirms Notifications routes are mounted at `/notifications`; all require bearer auth.
- `GET /notifications` accepts `page` and `limit`.
- `PATCH /notifications/:id/read`, `PATCH /notifications/read-all`, and `DELETE /notifications/:id` are implemented in Flutter.
- `POST /notifications/token` accepts `token` and optional `device_type`; Flutter represents it in repository/data layer only because Firebase mobile config and push-token collection are not available yet.
- Flutter real-mode Chat and Notifications repositories read the Auth Lite in-memory access token and return typed unauthorized failures when missing.
- `PROMOO_USE_MOCKS=true` uses fake Chat and Notifications content behind the data-source/repository boundary and remains demo-ready without a session.
- Supabase realtime, WebSocket realtime, Firebase FCM setup, `firebase_messaging`, `flutter_local_notifications`, push permissions, background handlers, media upload, voice messages, payment events, full moderation, and complex auth guards are deferred.

## Open questions for implementation phases

- Exact response envelope for endpoints beyond Home, Services, Cup / Leaderboard, Seats, Profile + Packages, Search, Auth Lite, Chat, and Notifications: direct object/list vs `{ data, meta, error }`.
- Backend profile-specific services/packages query parameter is not available yet.
- Pagination metadata shape for category content.
- Whether subscription creation returns a checkout URL, payment intent, or another backend-defined object.
- Whether chat realtime is required after the MVP skeleton or can remain REST-only until after MVP.
- Which secure token persistence package should be approved for production auth hardening.
