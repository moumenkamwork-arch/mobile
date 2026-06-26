# Promoo MVP roadmap

Last updated: 2026-06-26

## Workflow rule

Promoo MVP must be implemented as vertical slices. Do not build all screens first and integrate the backend later.

Each slice includes:

- API contract or development fake contract.
- DTO/model and mapper.
- Repository interface and implementation.
- Riverpod provider/controller.
- UI for that slice.
- Loading, empty, error, retry, offline, and unauthenticated states where relevant.
- Focused tests.

Do not start vertical slices until the architecture/core and design-system/app-shell phases are complete.

## Exact implementation order

### 0. Project audit + memory

Status: completed.

Outputs:

- `AGENTS.md`
- `docs/project_memory.md`
- `docs/architecture.md`
- `docs/api_contracts.md`
- `docs/mvp_roadmap.md`

Validation:

- `flutter analyze`

### 1. Architecture + core setup

Status: completed pending ongoing refinement in later slices.

Goal: create the app foundation without feature screens.

Completed work:

- Added reviewed architecture dependencies: Riverpod, go_router, and Dio.
- Created `core/`, `routing/`, and `theme/` foundation files.
- Added environment config for base URL, environment name, and mock mode.
- Added API client abstraction, response parser, API exception, typed failures, and Result type.
- Replaced counter scaffold with minimal Promoo app root.
- Added placeholder-only `/`, `/splash`, and `/home` routes.
- Added focused tests for AppConfig, ApiResponse, Result, and app root build.

Deferred from this phase:

- Secure token storage implementation, because auth/token persistence is not implemented yet.
- Google Fonts/Tajawal configuration, because full design-system typography is next.
- DTO/model code generation, because no vertical slice has started yet.
- Auth guards and bottom navigation shell, because those belong to later phases.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 2. Design system + app shell

Status: completed pending ongoing refinement in later slices.

Goal: turn brand rules into reusable Flutter tokens and create the shell only after architecture exists.

Completed work:

- Expanded colors, typography direction, spacing, radius, shadow, button, input, card, and navigation styles from `docs/design/brand_identity.md`.
- Added shared widgets for scaffold, logo, buttons, cards, text fields, loading, empty, error, and section headers.
- Created a placeholder-only app shell with bottom navigation tabs: Home, Services, Cup, Seats, and Profile.
- Added splash placeholder using the full yellow logo asset.
- Kept localization-ready directional layout patterns without adding ARB localization files yet.
- Evaluated `google_fonts`; did not retain it because this Windows setup lacks Developer Mode symlink support needed by the resolved plugin dependency graph.

Deferred from this phase:

- Real feature UI and API-backed state.
- Auth guards.
- Localization ARB files and generated localization setup.
- Final native splash and launcher icon generation.
- Tajawal font configuration until bundled assets or supported `google_fonts` setup is chosen.

Validation:

- `flutter pub get`
- Theme/widget tests for tokens/components where practical.
- `dart format .`
- `flutter analyze`
- `flutter test`

### 3. Home vertical slice

Status: completed with the Prompt 15 detail/contact improvement; still pending backend-field refinement in later QA.

Endpoint:

- `GET /home`

Completed work:

- Home DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Development fake fallback behind data-source/repository boundaries, controlled by `PROMOO_USE_MOCKS`.
- Home UI with header/logo, search teaser, featured/promoted area, categories, services preview, offers preview, featured profiles, stories/highlights, loading, empty, error, retry, and refresh behavior.
- Defensive parsing for confirmed backend fields and common nested variants.
- Hidden/deferred social metrics remain excluded from Home MVP models and UI.

Validation:

- DTO parsing tests for success and missing optional sections.
- Repository fake fallback and failure mapping tests.
- Controller loading/success/error tests.
- Home screen loading/success/empty/error widget tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 4. Services vertical slice

Status: completed with the Prompt 15 detail/contact improvement; still pending backend-field refinement in later QA.

Endpoints:

- `GET /categories`
- `GET /services`
- `GET /services?category_id={id}`
- `GET /services?q={text}`
- `GET /services/:id`

Completed work:

- Verified backend supports both `categoryId` and `category_id`; Flutter uses `category_id` only.
- Added Services DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Added categories, selected category, search query, services list, loading, empty, error, retry, and refresh states.
- Replaced Services placeholder tab with real `ServicesScreen`.
- Added repository/data source support for `GET /services/:id`.
- Added `/services/:id` detail/contact route in Prompt 15.
- Listing/contact only; no purchase, order, checkout, payment, or service purchase flow.
- Hidden/deferred social metrics and unavailable fields remain excluded from Services MVP UI.

Validation:

- DTO parsing tests for categories, services list, missing currency fallback, and service detail object.
- Repository fake/remote source selection and failure mapping tests.
- Controller loading/success/error/filter/search tests.
- Services screen loading/success/error widget tests.
- Service detail DTO, repository, controller, screen, and navigation tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 5. Cup / Leaderboard vertical slice

Status: completed pending backend-field refinement in later QA.

Endpoint:

- `GET /leaderboard?page=1&limit=20&type=all`

Completed work:

- Use `/leaderboard`, not `/search`.
- Verified backend Leaderboard route/controller/service/validator read-only.
- Added Leaderboard DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Added loading, empty, error, retry, refresh, ranked profile, and first-page list states.
- Replaced Cup placeholder tab with real Cup / Leaderboard screen.
- Added top 3 podium/highlight section and ranked profile list.
- No profile detail route, auth, search fallback, subscriptions, payments, likes, comments, or reviews were added.

Validation:

- DTO parsing tests for paginated and nested profile variants.
- Repository fake/remote source selection and failure mapping tests.
- Controller loading/success/empty/error tests.
- Cup / Leaderboard screen loading/success/error widget tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 6. Seats vertical slice

Status: completed pending auth-enabled booking refinement in the Auth lite phase.

Endpoints:

- `GET /seats`
- `GET /seats/me`
- `POST /seats/:id/book`

Completed work:

- Public seat listing.
- Verified backend Seats route/controller/service/validator read-only.
- Added Seats DTOs, domain entities/value objects, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Added tier filtering for Gold, Silver, and Bronze.
- Added loading, empty, error, retry, refresh, booking pending, booking auth-required, booking unavailable, booking success, and booking error states.
- Replaced Seats placeholder tab with real `SeatsScreen`.
- Added premium header, tier cards, seat cards, status badges, price/currency display, and safe login-required booking CTA.
- Repository/data layer supports `GET /seats/me` and `POST /seats/:id/book`, but UI does not perform real auth-required booking yet.
- No checkout routes, WebView, URL launcher, PaymentSheet, Auth, Chat, Notifications, Orders, Subscriptions, Profile, or Global Search work was added.

Validation:

- DTO parsing tests for wrapped/direct seat list variants and booking response.
- Repository fake/remote source selection, booking response mapping, and failure mapping tests.
- Controller loading/success/empty/error/filter/auth-required booking tests.
- Seats screen loading/success/error and auth-required UI widget tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 7. Profile + Packages

Status: completed pending auth-enabled current profile/edit/follow/chat refinement in later phases.

Endpoints:

- `GET /profiles/:idOrUsername`
- `GET /profiles/me`
- `PUT /profiles/me`
- `GET /services` for profile packages, with client-side profile filtering because no backend profile service filter is confirmed yet

Completed work:

- Public profile view.
- Profile tab demo profile behavior until Auth/current-user support exists.
- Public profile detail route `/profiles/:id`.
- Profile packages represented as services connected to the profile, not subscription plans.
- Added Profile DTOs, domain entities/value objects, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Added loading, empty/not found, error, retry, refresh, profile, packages, and safe action states.
- Replaced Profile placeholder tab with real `ProfileScreen`.
- Added profile header, avatar/name/account type/verification badge, stats row, about section, safe action buttons, action notice, packages section, and package cards.
- Follow, message, and edit actions show login-required or coming-soon UI only.
- No Auth, real edit submission, image upload, follow/unfollow mutation, chat, notifications, payments, orders, subscriptions, checkout, service purchase, full settings, or global search work was added.

Validation:

- DTO parsing tests for profile details, nested variants, and profile package service rows.
- Repository fake/demo/remote behavior, package parsing, failure mapping, and edit auth-required tests.
- Controller loading/success/empty/error/action-state tests.
- Profile screen loading/success/error and safe-action widget tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 8. Search

Status: completed pending backend-field refinement in later QA.

Endpoints:

- `GET /search?q={text}&type=all`
- `GET /search?type=profiles&accountType=influencer`

Completed work:

- Verified backend Search route/controller/service/validator read-only.
- Confirmed query parameters: `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, and `accountType`.
- Confirmed `type` values: `all`, `profiles`, `offers`, `ads`, and `services`.
- Added Search DTOs, domain entities/value objects, repository interface, repository implementation, remote data source, fake data source, and Riverpod controller.
- Added idle, loading, success, empty, error, retry, refresh, selected filter, and stale-result protection states.
- Added `/search` route without adding a new bottom navigation tab.
- Home search teaser now navigates to Search.
- Added submit/button/filter driven search with a minimum 2-character query guard.
- Added mixed result cards for profiles, services, offers, and ads.
- Profile results navigate to `/profiles/:id`; service results navigate to `/services/:id`; offer and ad results navigate to `/home/items/:type/:id`.
- No Auth, Chat, Notifications, Payments, Orders, Subscriptions, Checkout, service purchase flow, seat booking flow, edit profile, or uploads were added.

Validation:

- DTO parsing tests for grouped all results and paginated specific type results.
- Repository fake/remote source selection and failure mapping tests.
- Controller idle/loading/success/empty/error/filter tests.
- Search screen idle/loading/success and profile navigation widget tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 9. Auth lite

Status: completed pending secure persistence and protected-flow hardening.

Endpoints:

- `POST /auth/register/email`
- `POST /auth/login/email`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /profiles/me`

Completed work:

- Verified backend Auth route/controller/service/validator/middleware read-only.
- Confirmed email registration body: `email`, `password`, `full_name`, and `account_type`.
- Confirmed email login body: `email` and `password`.
- Confirmed refresh body: `refresh_token`.
- Confirmed logout uses optional bearer auth through `Authorization: Bearer <token>`.
- Added Auth DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, in-memory session store, and Riverpod controller.
- Added defensive Supabase-like session parsing for `{ user, session }`, nested session/user variants, token key variants, and `session: null` verification-required registration.
- Added `/login` and `/register` public routes outside the bottom-navigation shell.
- Added login and registration screens with validation, loading/error/authenticated states, account type selection, and logout panel.
- Profile and Seats login-required CTAs can navigate to `/login`.
- Existing public Home, Services, Cup, Seats, Profile, and Search routes remain public; no complex guards were added.
- No Facebook, Google, Apple, phone, OTP final flow, Supabase client SDK, Firebase, secure persistence, account deletion, profile edit final flow, uploads, payments, checkout, push, chat, or notifications work was added.

Validation:

- DTO parsing tests for login, registration verification-required response, and refresh response variants.
- Repository fake/remote source selection, failure mapping, storage, and logout tests.
- Controller unauthenticated, validation, authenticating, authenticated, error, and logout tests.
- Login/register screen smoke tests and profile login-required navigation test.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 10. Chat + Notifications skeleton

Status: completed pending production realtime, push setup, secure persistence, and guarded auth hardening.

Endpoints:

- `GET /chats`
- `POST /chats`
- `GET /chats/:roomId/messages`
- `POST /chats/:roomId/messages`
- `PATCH /chats/:roomId/read`
- `DELETE /chats/:roomId`
- `GET /notifications`
- `PATCH /notifications/:id/read`
- `PATCH /notifications/read-all`
- `DELETE /notifications/:id`
- `POST /notifications/token`

Completed work:

- Verified backend Chat route/controller/service/validator read-only.
- Confirmed Chat is mounted at `/chats`; `/chat/rooms` is not used.
- Confirmed Chat routes require auth and support list, start/open chat, get messages, send messages, mark read, and delete chat.
- Added Chat DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, room-list controller, and conversation controller.
- Added `/chats` and `/chats/:roomId` routes outside the bottom navigation shell.
- Added chat inbox UI, room cards, conversation UI, message bubbles, message input, loading, empty, error, retry, refresh, sending, send-error, and login-required states.
- Fake mode supports demo room loading and text message sending.
- Real mode requires the Auth Lite in-memory access token and returns typed unauthorized failures when missing.
- Profile Message action now opens `/chats`; starting a chat with the exact profile is deferred.
- Verified backend Notifications route/controller/service/validator read-only.
- Confirmed Notifications routes require auth and support list, mark single read, mark all read, delete, and token registration.
- Added Notifications DTOs, domain entities, repository interface, repository implementation, remote data source, fake data source, and controller.
- Added `/notifications` route outside the bottom navigation shell.
- Added notifications UI, notification cards, unread indicators, type icons/labels, mark-all-read, delete, loading, empty, error, retry, refresh, action-error, and login-required states.
- Notification message cards navigate to `/chats/:roomId` only when `room_id` exists in notification data.
- `POST /notifications/token` is represented in repository/data layer only.
- No Firebase FCM setup, `firebase_messaging`, `flutter_local_notifications`, push permission prompts, background handlers, Supabase realtime, WebSockets, media upload, voice messages, payment events, full moderation, complex auth guards, or production chat realtime work was added.

Validation:

- Chat DTO parsing tests for chat list and messages.
- Chat repository fake fallback, auth-required real mode, and bearer-token behavior tests.
- Chat controller success/error/send tests.
- Chat screen and route smoke tests.
- Notifications DTO parsing tests for list and room-id variants.
- Notifications repository fake fallback, auth-required real mode, and bearer-token mutation tests.
- Notifications controller success/mark-all-read/auth-required tests.
- Notifications screen and message-to-chat route smoke tests.
- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 11. MVP polish + QA

Status: completed pending device/client walkthrough QA.

Completed work:

- Verified the route table with automated smoke coverage for `/`, `/home`, `/services`, `/cup`, `/seats`, `/profile`, `/profiles/:id`, `/search`, `/login`, `/register`, `/chats`, `/chats/:roomId`, and `/notifications`.
- Kept public screens public and avoided complex auth guards.
- Polished visible demo copy to remove development-only wording from splash, auth, home preview, seats, profile actions, chat, and fake notifications.
- Confirmed mock mode renders realistic demo data across the implemented MVP slices without putting fake data in widgets.
- Reviewed SVG warnings. The provided brand SVG files contain CSS `<style>`/`class` usage, which triggers non-fatal `flutter_svg` test warnings but does not block rendering.

Deferred from this phase:

- Physical device/emulator QA.
- Full Arabic copy, RTL/LTR localization QA, and text-scale matrix.
- Offline/slow-network manual QA.
- Privacy/data inventory and store readiness prep.
- Production mock hard-disable strategy.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 12. Mock-mode client walkthrough QA

Status: completed pending live client/device walkthrough.

Completed work:

- Confirmed mock mode is controlled by `PROMOO_USE_MOCKS` in `AppConfig` and must be passed with `--dart-define=PROMOO_USE_MOCKS=true`.
- Documented run commands for Edge, Chrome when available, Android device, Android emulator, and Windows desktop.
- Ran focused route walkthrough simulation for Splash, Home, Services, Cup, Seats, Profile, Public Profile, Search, Login, Register, Chats, Chat Room, and Notifications.
- Created `docs/client_walkthrough_checklist.md`.
- Removed the disabled Home highlight CTA so the demo does not show an action that appears clickable but has no destination.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 13. Client demo visual fixes

Status: completed pending another Android client-demo smoke run.

Completed work:

- Added a shared shell scroll bottom clearance and applied it to Home, Services, Cup / Leaderboard, Seats, Profile, and Search.
- Converted Services fake prices and Profile package fake prices to AED only.
- Improved Search filter chips with horizontal scroll padding and selected-chip reveal.
- Added keyboard-aware bottom padding to the Chat room input.
- Reworked Leaderboard profile card metadata so names have more room and secondary text can use two lines.
- Increased Profile package scroll clearance through the shared shell bottom inset.
- Moved Splash content slightly upward for better vertical balance.
- Added focused regression tests for mock AED currencies, Search filter scrollability, Profile shell bottom padding, Chat keyboard padding, and Leaderboard overflow safety.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 14. Prototype pictures comparison audit

Status: completed as documentation-only audit.

Completed work:

- Reviewed old prototype screenshots in `../promo_backend/Projects-Pictures` without modifying the backend.
- Compared prototype expectations against current Flutter MVP screens: Splash, Home, Services, Cup / Leaderboard, Seats / Influencer, Profile + Packages, Search, Login, Register, Chat, and Notifications.
- Created `docs/prototype_comparison_audit.md`.
- Confirmed no P0 blocker before client demo if the demo is framed as the scoped MVP.
- Identified P1/P2 gaps for future planning: richer Home visual carousel parity, prototype-style Influencer seat grid, profile media/management/add-ad screens, package detail/checkout, story viewer, sticky location/map actions, header chat/notification badges, and production auth/payment/realtime items. The service detail/contact P1 gap was addressed in Prompt 15, the Home top-offer/for-you detail P1 gap was addressed in Prompt 16, the Seats/Influencer visual-alignment P1 gap was addressed in Prompt 17, and the Profile media/management preview P1 gap was addressed in Prompt 18.

Validation:

- No Flutter build, analyze, test, or format command was run because this was documentation-only and no Flutter files changed.

### 15. Service Detail + Contact MVP

Status: completed pending client walkthrough confirmation.

Endpoints:

- `GET /services/:id`

Completed work:

- Confirmed backend `GET /services/:id` exists as a public route in `../promo_backend` read-only.
- Reused the Services repository/data-source contract and added a family Riverpod detail controller.
- Added `ServiceDetailScreen` with service title, category/provider/location chips, price/currency, description, delivery/tags, provider summary, and contact section.
- Added safe CTA behavior only: Contact provider shows a coming-soon contact notice, Open chats routes to `/chats`, and View provider profile routes to `/profiles/:id` when a provider id is available.
- Added `/services/:id` routing and kept the Services tab selected for service detail paths.
- Wired Services cards, Home service previews, and Search service results to service detail when safe.
- Updated mock service/provider ids so demo detail and provider profile navigation resolve in mock mode.

Deferred from this phase:

- Purchase, order, checkout, Stripe, booking, reviews/ratings, real chat-room creation, provider profile management, uploads, and backend changes.
- Sticky map/location action from the old prototype.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 16. Home Top Offer / For You Detail MVP

Status: completed pending client walkthrough confirmation.

Endpoints:

- `GET /home`
- `GET /offers/:id`
- `GET /ads/active`

Completed work:

- Confirmed backend `GET /offers/:id` exists as a public optional-auth route in `../promo_backend` read-only.
- Confirmed backend has no public `GET /ads/:id`; public ad detail uses `GET /ads/active` lookup by id.
- Extended the Home repository/data-source contract with detail loading while keeping fake content behind `HomeFakeDataSource`.
- Added Home detail domain objects, defensive detail DTO parsing, a family Riverpod detail controller, and `HomeContentDetailScreen`.
- Added `/home/items/:type/:id` routing and kept Home selected in the shell for Home detail paths.
- Wired Home highlight cards, Home promotion cards, Search offer results, and Search ad results to Home detail.
- Added safe CTA behavior only: Contact shows a coming-soon notice, Open chats routes to `/chats`, View provider profile routes to `/profiles/:id` when available, and Location shows a coming-soon location notice.

Deferred from this phase:

- Offer purchase, orders, checkout, Stripe, booking, uploads, reviews/ratings, final favorites/share behavior, map launching, and provider-specific chat-room creation.
- Full prototype carousel/page-dot visual parity and story player.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 17. Seats / Influencer Visual Alignment

Status: completed pending client walkthrough confirmation.

Route:

- `/seats`

Completed work:

- Kept backend naming and route stability as Seats.
- Kept the bottom navigation label as `Seats` to avoid route/navigation churn.
- Updated the Seats screen header to client-facing `Influencer Seats` terminology.
- Added Gold/Silver/Bronze tier explanation copy for visibility placement.
- Added a compact visibility grid using existing seat/status data so the screen feels closer to the prototype Influencer seat concept.
- Kept the existing list/card data model, tier filtering, pricing, status badges, loading/error/empty states, and safe login-required booking behavior.
- Did not add booking, checkout, payments, WebView, Stripe, PaymentSheet, backend changes, or new packages.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 18. Profile Media + Management Preview MVP

Status: completed pending client walkthrough confirmation.

Routes:

- `/profile`
- `/profiles/:id`

Completed work:

- Added a Profile media/posts grid that reads from the existing profile model.
- Added mock demo profile media in `ProfileFakeDataSource`; widgets do not contain fake media data.
- Made Profile DTO media parsing more defensive for direct URL fields, `media`, `posts`, `media_urls`, and object rows with common URL keys.
- Added a Profile-tab-only `Profile tools` preview for Manage profile, Create offers, Saved items, Support, and Language.
- Kept public profile detail routes focused on stable public profile display; public profiles do not show the owner tools preview.
- Added safe coming-soon feedback for tools and kept Edit profile as a preview action.
- Kept existing Profile packages display/contact behavior unchanged.
- Did not add new routes, packages, upload flows, edit submission, settings persistence, saved/following implementation, production logout, add-ad wizard, checkout, orders, payments, or backend changes.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

### 19. Final Android Walkthrough + Client Demo Handoff

Status: completed pending live client walkthrough.

Output:

- `docs/client_demo_handoff.md`

Completed work:

- Documented exact mock-mode commands for Edge and Android.
- Documented `flutter devices` as the device-id discovery command.
- Recorded the final client demo order: Splash, Home, Home detail, Services, Service detail/contact, Search, Profile, Profile media/tools preview, Influencer Seats, Cup / Leaderboard, Login/Register, Chat, and Notifications.
- Documented demo positioning as a mock-mode MVP walkthrough for UI/UX and product flow.
- Recorded client-safe limitations for payments, booking, uploads/edit profile, realtime chat, push notifications, secure token persistence, store release, and backend integration hardening.
- Added a final QA checklist for launch, mock mode, tabs, detail routes, Search, Profile preview, Seats, Chat/Notifications, overflow, and tests.
- Scanned app code for obvious visible technical wording such as skeleton, deferred, mock, backend, and not implemented; no client-facing app copy change was required.
- Did not add app features, packages, routes, backend changes, architecture refactors, payments, uploads, realtime, push notifications, settings, orders, subscriptions, or store release work.

Validation:

- `flutter pub get`
- `dart format .`
- `flutter analyze`
- `flutter test`

## Deferred MVP items

- Reviews and ratings.
- Likes and comments.
- Facebook login.
- Service purchase/checkout.
- Offer purchase/checkout.
- Real service contact/chat-room creation and sticky map/location actions.
- Final Home offer/ad map launch, final favorite/share behavior, and provider-specific chat-room creation.
- Real profile edit submission, avatar/cover/media uploads, settings persistence, add-ad wizard, saved/following/support/language screens, and production logout.
- Full realtime chat if skeleton is enough.
- Push notification implementation details until notification setup phase.
- Firebase FCM setup, `firebase_messaging`, `flutter_local_notifications`, push permission prompts, token collection, and background handlers.
- Secure auth token persistence and automatic refresh hardening.
- Google/Apple login, phone login, OTP final flow, and account deletion.
- Chat media upload, voice messages, chat deletion UI, profile-specific chat start, full moderation, report/block flows, and production realtime.
- Launcher icon generation.
- Native splash generation.
- Full localization copy if not needed before feature validation.
- Store metadata and release submissions.
- Physical device/emulator QA and client walkthrough build.

## Risks and assumptions

- The backend endpoint reference is not OpenAPI; response schemas may need confirmation per slice.
- Current app has a shell; Home with offer/promotion detail, Services with detail/contact, Cup / Leaderboard, Seats, Profile + Packages plus media/tools preview, Search, Auth Lite, and Chat + Notifications skeleton are implemented and other feature screens/data flows are intentionally not started.
- Auth Lite currently uses in-memory session state only; auth-required production features depend on secure token storage, automatic refresh, and route/presenter guard hardening.
- Subscriptions depend on backend payment flow shape.
- Chat realtime guide mentions Supabase; no Supabase client package was added. Production realtime remains a post-skeleton decision.
- SVG brand files contain embedded PNG payloads and CSS `<style>`/`class` usage; compatible with current rendering, but tests print a non-fatal `unhandled element <style/>` warning and launcher/splash tooling may need clean flattened exports.

## Quality gates by phase

- Every slice defines acceptance criteria before code.
- Every API slice has DTO fixtures and mapper tests.
- Every provider/controller has success and failure state tests where practical.
- Every screen has loading, empty, error, retry, and unauthenticated states where relevant.
- Run `flutter analyze` before reporting planning or code changes complete.
- Run `flutter test` for code-bearing phases.
