# Promoo MVP roadmap

Last updated: 2026-06-25

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

Endpoint:

- `GET /home`

Planned work:

- Home DTOs/entities/repository/provider.
- Development fake fallback behind data source.
- Home UI with loading, empty, error, retry, and offline states.
- Hide unavailable/deferred social metrics.

### 4. Services vertical slice

Endpoints:

- `GET /categories`
- `GET /services`
- `GET /services?categoryId={id}`
- `GET /services?category_id={id}`
- `GET /services/:id`

Planned work:

- Verify category filter parameter against backend behavior.
- Services list and detail.
- Listing/contact only; no purchase flow.
- Hide reviews, ratings, likes, comments, `promo_code`, `terms`, and `best_price` when not returned.

### 5. Cup / Leaderboard vertical slice

Endpoint:

- `GET /leaderboard?page=1&limit=20&type=all`

Planned work:

- Use `/leaderboard`, not `/search`.
- Support filters: `all`, `company`, `influencer`, `service_provider`.
- Add pagination-ready provider state.

### 6. Seats vertical slice

Endpoints:

- `GET /seats`
- `GET /seats/me`
- `POST /seats/:id/book`

Planned work:

- Public seat listing.
- Auth-required "my seats" and booking states.
- Booking mutation with optimistic or confirmed-only UX decision.

### 7. Profile + Packages

Endpoints:

- `GET /profiles/:idOrUsername`
- `GET /profiles/me`
- `GET /subscriptions/plans`
- `POST /subscriptions`

Planned work:

- Public profile view.
- My profile read after auth lite exists or with graceful unauthenticated state.
- Packages as subscription plans.
- Subscription creation through backend only.
- No Stripe secret keys in Flutter.

### 8. Search

Endpoints:

- `GET /search?q={text}&type=all`
- `GET /search?type=profiles&accountType=influencer`

Planned work:

- Debounced query controller.
- Stale request protection/cancellation when Dio is available.
- Empty, no results, error, retry states.

### 9. Auth lite

Endpoint candidates from backend reference:

- `POST /auth/login/email`
- `POST /auth/login/phone`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /profiles/me`

Planned work:

- Minimal auth required for protected MVP flows.
- Token storage abstraction implementation.
- Auth guards.
- Session expiry handling.
- No Facebook login.

### 10. Chat + Notifications skeleton

Endpoints:

- `GET /chats`
- `POST /chats`
- `GET /chats/:roomId/messages`
- `POST /chats/:roomId/messages`
- `PATCH /chats/:roomId/read`
- `GET /notifications`
- `PATCH /notifications/:id/read`
- `PATCH /notifications/read-all`
- `POST /notifications/token`

Planned work:

- Skeleton list/detail/read/send flows as scoped by MVP.
- Use REST for sending messages.
- Realtime can be kept behind an interface and deferred if not required for MVP.
- Push token registration waits until notification package/setup is explicitly approved.

### 11. MVP polish + QA

Planned work:

- Polish dark UI, contrast, spacing, and motion.
- Arabic/English review and RTL/LTR layout QA.
- Offline/slow network/error QA.
- Device smoke testing.
- Privacy/data inventory and store readiness prep.
- Remove production mock fallback or hard-disable it in production configuration.

## Deferred MVP items

- Reviews and ratings.
- Likes and comments.
- Facebook login.
- Service purchase/checkout.
- Full realtime chat if skeleton is enough.
- Push notification implementation details until notification setup phase.
- Launcher icon generation.
- Native splash generation.
- Full localization copy if not needed before feature validation.
- Store metadata and release submissions.

## Risks and assumptions

- The backend endpoint reference is not OpenAPI; response schemas may need confirmation per slice.
- `GET /services` category filter query is ambiguous across user-provided contract and backend reference.
- Current app has a placeholder shell; feature screens and feature data flows are intentionally not started.
- Auth-required features depend on secure token storage and session handling.
- Subscriptions depend on backend payment flow shape.
- Chat realtime guide mentions Supabase; do not add Supabase packages until the chat phase confirms need.
- SVG brand files contain embedded PNG payloads; compatible with current vector compiler but less portable for launcher/splash tooling.

## Quality gates by phase

- Every slice defines acceptance criteria before code.
- Every API slice has DTO fixtures and mapper tests.
- Every provider/controller has success and failure state tests where practical.
- Every screen has loading, empty, error, retry, and unauthenticated states where relevant.
- Run `flutter analyze` before reporting planning or code changes complete.
- Run `flutter test` for code-bearing phases.
