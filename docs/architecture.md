# Promoo Flutter architecture plan

Last updated: 2026-06-26

## Current project state

- The default Flutter counter scaffold has been removed.
- `lib/main.dart` initializes Riverpod `ProviderScope`.
- `lib/app.dart` defines the Promoo app root with `MaterialApp.router`.
- `lib/routing/` contains splash routes and shell routes for placeholder tabs.
- `lib/core/` contains app configuration, API foundation, typed failures, and Result primitives.
- `lib/theme/` contains brand color, spacing, radius, shadow, typography, and Material theme tokens.
- `lib/shared/widgets/` contains reusable Promoo UI primitives and state components.
- `lib/shell/` contains the placeholder splash and bottom-navigation app shell.
- `lib/features/home/` contains the first complete vertical slice.
- `lib/features/services/` contains the second complete vertical slice.
- `lib/features/leaderboard/` contains the Cup / Leaderboard vertical slice.
- `lib/features/seats/` contains the Seats vertical slice.
- `lib/features/profile/` contains the Profile + Packages vertical slice.
- `lib/features/search/` contains the Search vertical slice.
- `lib/features/auth/` contains the Auth Lite vertical slice.
- `lib/features/chat/` contains the Chat skeleton vertical slice.
- `lib/features/notifications/` contains the Notifications skeleton vertical slice.
- No full auth guards, DTO codegen, localization setup, production realtime, push SDK setup, or other real feature integrations exist yet.
- `flutter_svg` is installed because brand assets are SVG files.
- Riverpod, go_router, and Dio are installed for the architecture foundation.
- No code generation, secure storage, Google Fonts, Supabase, Firebase, Stripe, image picker, or notification packages are installed yet.

## Architecture goal

Use a Vertical Slice MVP model. Each feature is implemented end to end through:

1. API contract or development fake contract.
2. DTO/model.
3. Repository interface and implementation.
4. Riverpod provider/controller.
5. UI for the feature.
6. Loading, empty, error, retry, offline, and unauthenticated states where relevant.
7. Focused tests.

Do not build all screens first and integrate backend later.

## Planned stack

- Flutter for mobile-first app UI.
- Riverpod for dependency wiring and feature state.
- go_router for centralized routes and guarded navigation.
- Dio for REST API transport.
- Typed DTOs/models, likely with code generation after package review.
- Centralized response parsing and typed failures.
- Secure token storage abstraction when auth persistence is intentionally added.
- Flutter `gen_l10n` and ARB files when localization setup starts.
- Mock/fake repositories for development and tests only.

Core setup implemented packages:

- `flutter_riverpod`
- `go_router`
- `dio`

Deferred packages:

- `google_fonts`; Tajawal remains recommended, but the current implementation uses system fallback because adding `google_fonts` failed on this Windows setup without Developer Mode symlink support.
- secure storage until Auth Lite is hardened with real token persistence.
- generated DTO/model tooling until the first API vertical slice needs it.

## Proposed folder structure

```text
lib/
  main.dart
  app.dart
  core/
    config/
      app_config.dart
      app_environment.dart
    errors/
      app_failure.dart
    network/
      api_client.dart
      api_endpoints.dart
      api_response.dart
      api_exception.dart
    utils/
      result.dart
  routing/
    app_router.dart
    route_names.dart
  shell/
    placeholder_tab_screen.dart
    promoo_shell.dart
    splash_placeholder_screen.dart
  shared/
    widgets/
      promoo_button.dart
      promoo_card.dart
      promoo_empty_state.dart
      promoo_error_state.dart
      promoo_loading_indicator.dart
      promoo_logo.dart
      promoo_scaffold.dart
      promoo_section_header.dart
      promoo_text_field.dart
      promoo_widgets.dart
  theme/
    app_colors.dart
    app_spacing.dart
    app_radius.dart
    app_shadows.dart
    app_typography.dart
    app_theme.dart
  features/
    home/
      data/
        datasources/
          home_data_source.dart
          home_fake_data_source.dart
          home_remote_data_source.dart
        dto/
          home_content_dto.dart
        repositories/
          home_repository_impl.dart
      domain/
        entities/
          home_content.dart
        repositories/
          home_repository.dart
      presentation/
        controllers/
          home_controller.dart
        screens/
          home_screen.dart
        widgets/
    services/
      data/
        datasources/
          services_data_source.dart
          services_fake_data_source.dart
          services_remote_data_source.dart
        dto/
          services_dto.dart
        repositories/
          services_repository_impl.dart
      domain/
        entities/
          promoo_service.dart
        repositories/
          services_repository.dart
      presentation/
        controllers/
          services_controller.dart
        screens/
          services_screen.dart
        widgets/
    leaderboard/
      data/
        datasources/
          leaderboard_data_source.dart
          leaderboard_fake_data_source.dart
          leaderboard_remote_data_source.dart
        dto/
          leaderboard_dto.dart
        repositories/
          leaderboard_repository_impl.dart
      domain/
        entities/
          leaderboard_profile.dart
        repositories/
          leaderboard_repository.dart
      presentation/
        controllers/
          leaderboard_controller.dart
        screens/
          leaderboard_screen.dart
        widgets/
    seats/
      data/
        datasources/
          seats_data_source.dart
          seats_fake_data_source.dart
          seats_remote_data_source.dart
        dto/
          seats_dto.dart
        repositories/
          seats_repository_impl.dart
      domain/
        entities/
          seat.dart
        repositories/
          seats_repository.dart
      presentation/
        controllers/
          seats_controller.dart
        screens/
          seats_screen.dart
        widgets/
    profile/
      data/
        datasources/
          profile_data_source.dart
          profile_fake_data_source.dart
          profile_remote_data_source.dart
        dto/
          profile_dto.dart
        repositories/
          profile_repository_impl.dart
      domain/
        entities/
          promoo_profile.dart
        repositories/
          profile_repository.dart
      presentation/
        controllers/
          profile_controller.dart
        screens/
          profile_screen.dart
        widgets/
    subscriptions/
      data/
      domain/
      presentation/
    search/
      data/
        datasources/
          search_data_source.dart
          search_fake_data_source.dart
          search_remote_data_source.dart
        dto/
          search_dto.dart
        repositories/
          search_repository_impl.dart
      domain/
        entities/
          search_result.dart
        repositories/
          search_repository.dart
      presentation/
        controllers/
          search_controller.dart
        screens/
          search_screen.dart
        widgets/
    auth/
      data/
        datasources/
          auth_data_source.dart
          auth_fake_data_source.dart
          auth_remote_data_source.dart
        dto/
          auth_dto.dart
        repositories/
          auth_repository_impl.dart
        session/
          auth_session_store.dart
      domain/
        entities/
          auth_session.dart
        repositories/
          auth_repository.dart
      presentation/
        controllers/
          auth_controller.dart
        screens/
          login_screen.dart
          register_screen.dart
        widgets/
    chat/
      data/
        datasources/
          chat_data_source.dart
          chat_fake_data_source.dart
          chat_remote_data_source.dart
        dto/
          chat_dto.dart
        repositories/
          chat_repository_impl.dart
      domain/
        entities/
          chat.dart
        repositories/
          chat_repository.dart
      presentation/
        controllers/
          chat_controller.dart
          chat_room_controller.dart
        screens/
          chat_list_screen.dart
          chat_room_screen.dart
        widgets/
    notifications/
      data/
        datasources/
          notifications_data_source.dart
          notifications_fake_data_source.dart
          notifications_remote_data_source.dart
        dto/
          notifications_dto.dart
        repositories/
          notifications_repository_impl.dart
      domain/
        entities/
          app_notification.dart
        repositories/
          notifications_repository.dart
      presentation/
        controllers/
          notifications_controller.dart
        screens/
          notifications_screen.dart
        widgets/
test/
  core/
  features/
```

The folder structure should be introduced incrementally. Do not create every feature folder before it is needed unless doing so is part of a small core setup scaffold.

## Layer rules

### Presentation

- Widgets, screens, reusable UI components, and Riverpod controllers/providers.
- Widgets consume domain entities and view state, not raw DTOs.
- No direct Dio calls, JSON parsing, secure storage calls, or payment SDK calls in widgets.

### Domain

- Entities, repository interfaces, use cases, typed failures, value objects.
- Pure Dart where practical.
- No Flutter, Dio, Supabase, Firebase, storage, or widget imports.

### Data

- Remote data sources, DTOs, mappers, repository implementations.
- Convert remote exceptions, parsing errors, timeout, offline, and auth failures into typed failures.
- Keep API field drift isolated in DTO/mappers.

### Core

- API client, response parser, error mapper, environment config, token storage abstraction, shared result/failure types.
- Auth refresh and retry behavior belong in network/infrastructure, not widgets.

## API and environment rules

- Base URL usually includes `/api/v1`.
- Use `--dart-define` or generated non-secret environment configuration for base URL and development mock flag.
- Implemented keys:
  - `PROMOO_ENV`
  - `PROMOO_BASE_URL`
  - `PROMOO_USE_MOCKS`
  - `PROMOO_FALLBACK_CURRENCY`
- Default development base URL is `http://localhost:3000/api/v1`.
- Default fallback currency is `AED`; it is used only when a service price has no API currency.
- Never store API secrets, Stripe secret keys, Firebase private keys, or Supabase service role keys in Flutter.
- Auth Lite stores session state in memory only. Access and refresh tokens are not persisted until a secure storage package is explicitly added.
- Use backend endpoints for subscriptions and payments.
- Use backend REST endpoints for chat send/read operations; realtime can be planned later behind an interface.

## State management rules

- Use Riverpod providers to wire repositories, data sources, API clients, and controllers.
- Use `AsyncNotifier` or equivalent for async feature controllers.
- Controllers expose view state and commands such as refresh, retry, submit, and mark read.
- Use `ProviderScope` overrides for tests.

## Routing rules

- go_router is added.
- Route paths and names are centralized in `lib/routing/route_names.dart`.
- Current shell routes:
  - `/`
  - `/splash`
  - `/home`
  - `/services`
  - `/cup`
  - `/seats`
  - `/profile`
  - `/search`
  - `/login`
  - `/register`
  - `/chats`
  - `/chats/:roomId`
  - `/notifications`
- `/home` is implemented by the Home vertical slice.
- `/services` is implemented by the Services vertical slice.
- `/cup` is implemented by the Cup / Leaderboard vertical slice.
- `/seats` is implemented by the Seats vertical slice.
- `/profile` is implemented by the Profile + Packages vertical slice as demo current-profile behavior.
- `/profiles/:id` is implemented by the Profile + Packages vertical slice for public profile detail.
- `/search` is implemented by the Search vertical slice and is reachable from the Home search teaser.
- `/login` and `/register` are public routes implemented by Auth Lite and live outside the bottom-navigation shell.
- `/chats` and `/chats/:roomId` are public routes at the router layer but conceptually auth-required; their repositories show login-required state in real mode without an in-memory access token.
- `/notifications` is public at the router layer but conceptually auth-required; its repository shows login-required state in real mode without an in-memory access token.
- A `ShellRoute` provides the placeholder bottom navigation for Home, Services, Cup, Seats, and Profile.
- The shell is structural; Home, Services, Cup, Seats, Profile, and Search have real feature content.
- Auth Lite does not add complex route guards yet; authenticated route guards belong to the later auth hardening/protected-flow step.
- Validate route parameters at boundaries.

## Design-system integration

- Keep brand tokens from `docs/design/brand_identity.md` as the source for theme implementation.
- Use black surfaces and yellow accents.
- Use directional padding/alignment to support RTL later.
- Do not force Varela Round for Arabic UI text.
- Tajawal remains the target UI font; current theme uses system fallback.
- Add Tajawal through bundled font assets or `google_fonts` only when the local build environment supports the dependency.
- Reusable state components exist for loading, empty, error, and retry-ready UI.

## Implemented vertical slices

### Home

- Endpoint: `GET /home`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<HomeContent>`.
- Domain layer: `HomeContent` plus highlight, category, service preview, offer preview, profile preview, and story entities.
- Presentation layer: Riverpod controller with loading, success, empty, error, retry, and refresh behavior; Home screen with dark premium sections.
- Widgets consume domain entities and do not call APIs directly.

### Services

- Endpoints: `GET /categories`, `GET /services`, `GET /services?category_id={id}`, `GET /services?q={text}`, and repository support for `GET /services/:id`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<T>`.
- Domain layer: `ServiceCategory`, `PromooService`, `ServiceProvider`, and `ServicePrice`.
- Presentation layer: Riverpod controller with categories, selected category, search query, loading, success, empty, error, retry, and refresh behavior.
- UI renders services as listing/contact oriented cards only; no purchase, order, checkout, or payment flow exists.

### Cup / Leaderboard

- Endpoint: `GET /leaderboard?page=1&limit=20&type=all`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<List<LeaderboardProfile>>`.
- Domain layer: `LeaderboardProfile`, `LeaderboardRank`, and `LeaderboardType`.
- Presentation layer: Riverpod controller with loading, success, empty, error, retry, and refresh behavior.
- UI renders a top 3 podium/highlight section plus a ranked list; no profile detail routing or search fallback exists.

### Seats

- Endpoints: `GET /seats`, `GET /seats/me`, and `POST /seats/:id/book`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<T>`.
- Domain layer: `Seat`, `SeatTier`, `SeatStatus`, `SeatPrice`, `SeatHolder`, and `SeatBookingResult`.
- Presentation layer: Riverpod controller with loading, success, empty, error, retry, refresh, selected tier, booking pending, booking auth-required, booking unavailable, booking success, and booking error behavior.
- UI renders public seat listing, Gold/Silver/Bronze tier filters, status badges, and safe booking CTA.
- Real booking is not triggered from UI until Auth lite/token storage exists; repository/data-source booking support is ready for that later phase.

### Profile + Packages

- Endpoints: `GET /profiles/:idOrUsername`, `GET /profiles/me`, and `PUT /profiles/me`.
- Package source: profile packages are represented by services connected to the profile, fetched from `GET /services` and filtered client-side until the backend exposes a profile service filter.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<T>`.
- Domain layer: `PromooProfile`, `ProfileAccountType`, `ProfileStats`, `ProfilePackage`, `ProfilePackagePrice`, and `ProfileUpdateDraft`.
- Presentation layer: Riverpod controller with loading, success, empty/not found, error, retry, refresh, and safe action states.
- UI renders the demo Profile tab, public profile detail route, header, avatar/name/account type, verification badge, stats, about section, action buttons, and packages.
- Follow, message, and edit actions do not mutate backend state until Auth, Chat, upload, and edit flows exist.

### Search

- Endpoint: `GET /search`.
- Confirmed query parameters: `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, and `accountType`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, repository implementation returning `Result<SearchResultsPage>`.
- Domain layer: `SearchResultsPage`, `SearchResultType`, `SearchFilterType`, `SearchProfileResult`, `SearchServiceResult`, `SearchOfferResult`, `SearchAdResult`, provider and price value objects.
- Presentation layer: Riverpod controller with idle, loading, success, empty, error, retry, refresh, selected filter, and stale-result protection.
- UI renders submit-based search, filter chips, mixed profile/service/offer/ad result cards, and profile result navigation to `/profiles/:id`.
- Service, offer, and ad results remain display-only until their detail/contact flows are scoped.

### Auth Lite

- Endpoints: `POST /auth/register/email`, `POST /auth/login/email`, `POST /auth/refresh`, and `POST /auth/logout`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, in-memory session store, and repository implementation returning `Result<T>`.
- Domain layer: `AuthSession`, `AuthUser`, `AuthTokens`, `AuthAccountType`, and `AuthRepository`.
- Presentation layer: Riverpod controller with unauthenticated, authenticating, authenticated, validation-error, error, and logging-out states.
- UI renders public login/register screens and authenticated-session panels only; it does not add social login, phone/OTP, account deletion, profile edit, uploads, payments, push, or checkout behavior.
- Existing public feature screens remain public. Profile and Seats login-required actions can route to `/login`, but protected backend mutations remain deferred.

### Chat

- Endpoints: `GET /chats`, `POST /chats`, `GET /chats/:roomId/messages`, `POST /chats/:roomId/messages`, and `PATCH /chats/:roomId/read`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, and repository implementation returning `Result<T>`.
- Domain layer: `ChatRoom`, `ChatMessage`, `ChatParticipant`, `ChatMessageStatus`, and `ChatRepository`.
- Presentation layer: Riverpod room-list controller plus route-scoped conversation controller with loading, success, empty, error, refreshing, sending, and send-error states.
- UI renders a REST-backed skeleton inbox and conversation screen. Fake mode supports demo message sending; real mode requires the Auth Lite in-memory access token.
- Production realtime, Supabase realtime, WebSockets, media upload, voice messages, moderation, and complex auth guards remain deferred.

### Notifications

- Endpoints: `GET /notifications`, `PATCH /notifications/:id/read`, `PATCH /notifications/read-all`, `DELETE /notifications/:id`, and `POST /notifications/token`.
- Data layer: remote data source using `ApiClient`, fake data source selected by `PROMOO_USE_MOCKS`, defensive DTO parser, and repository implementation returning `Result<T>`.
- Domain layer: `AppNotification`, `NotificationType`, and `NotificationsRepository`.
- Presentation layer: Riverpod controller with loading, success, empty, error, refreshing, mark-read, mark-all-read, delete, and action-failure states.
- UI renders notification cards, unread indicators, type labels/icons, mark-all-read, delete, and safe navigation to `/chats/:roomId` only when a notification carries a room id.
- `POST /notifications/token` exists only in the repository/data layer for now. Firebase FCM setup, push permissions, local notifications, and background handlers remain deferred.

## Testing plan by slice

Each non-trivial vertical slice should include:

- DTO parsing and mapper tests.
- Repository tests with fake API/data source.
- Provider/controller state tests for loading, success, empty, error, retry, and auth cases.
- Widget tests for core UI states when screens are implemented.
- Route tests when navigation or guards are introduced.

## Quality gates

- Planning/docs-only: `flutter analyze`.
- Core setup: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`.
- Feature slice: add relevant tests before or with implementation, then run format/analyze/tests.
- Before release: device QA, Arabic/English, RTL/LTR, text scaling, offline, slow network, auth expiry, privacy review, store readiness.
