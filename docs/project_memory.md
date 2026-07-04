# Promoo project memory

Last updated: 2026-07-02

## Current state

- Flutter app path: `promoo_app`.
- Backend path: `../promo_backend`, read-only from this Flutter repo.
- App has a Promoo root in `lib/main.dart` and `lib/app.dart`.
- Default Flutter counter scaffold has been removed.
- Current tests cover app root smoke, route smoke, shell navigation, logo rendering, shared state widgets, AppConfig defaults, ApiResponse parsing, Result behavior, Home vertical slice, Home Top Offer / For You Detail flow, Services vertical slice, Service Detail + Contact flow, Cup / Leaderboard vertical slice, Seats vertical slice, Profile + Packages vertical slice, Search vertical slice, Auth Lite vertical slice, and Chat + Notifications skeleton slices.
- Brand assets exist under `assets/brand/`.
- Brand assets are registered in `pubspec.yaml`.
- Brand note exists at `docs/design/brand_identity.md`.
- `flutter_svg` is installed for SVG logo rendering.
- Core architecture packages are installed: `flutter_riverpod`, `go_router`, and `dio`.
- Design system and app shell are implemented.
- Home vertical slice is implemented.
- Services vertical slice is implemented.
- Cup / Leaderboard vertical slice is implemented.
- Seats vertical slice is implemented.
- Profile + Packages vertical slice is implemented.
- Search vertical slice is implemented.
- Auth Lite vertical slice is implemented with in-memory session state.
- Chat + Notifications skeleton slices are implemented.
- Prototype Section Alignment Patch is implemented for the visible demo surface.
- `google_fonts` is not installed; the theme uses system fallback while documenting Tajawal as the target UI font.

## Inspected files

- `pubspec.yaml`: Flutter dependencies plus `flutter_svg`, `flutter_riverpod`, `go_router`, and `dio`; brand assets registered.
- `analysis_options.yaml`: default `flutter_lints` include; no custom lint policy yet.
- `lib/main.dart`: initializes `ProviderScope` and runs `PromooApp`.
- `lib/app.dart`: app root using `MaterialApp.router`.
- `lib/core/`: configuration, typed failure, API foundation, and Result primitives.
- `lib/routing/`: splash routes plus shell routes for placeholder tabs.
- `lib/theme/`: brand color, spacing, radius, shadow, typography, and Material theme tokens.
- `lib/shared/widgets/`: reusable Promoo UI components.
- `lib/shell/`: placeholder splash and bottom-navigation shell.
- `lib/features/home/`: Home domain entities, data sources, DTO parser, repository implementation, Riverpod controllers, Home/detail screens, and section/detail widgets.
- `lib/features/services/`: Services domain entities, data sources, DTO parser, repository implementation, Riverpod controllers, services list/detail screens, and list/filter/search/detail widgets.
- `lib/features/leaderboard/`: Cup / Leaderboard domain entity, data sources, DTO parser, repository implementation, Riverpod controller, screen, podium, and ranked-list widgets.
- `lib/features/seats/`: Seats domain entity/value objects, data sources, DTO parser, repository implementation, Riverpod controller, screen, tier cards, status badge, and safe booking widgets.
- `lib/features/profile/`: Profile domain entities, profile packages, data sources, DTO parser, repository implementation, Riverpod controller, screen, profile header, stats, safe action, about, and package widgets.
- `lib/features/search/`: Search domain entities, data sources, DTO parser, repository implementation, Riverpod controller, screen, search input, filter chips, and mixed result widgets.
- `lib/features/auth/`: Auth Lite domain entities, data sources, DTO parser, repository implementation, in-memory session store, Riverpod controller, login/register screens, and auth widgets.
- `lib/features/chat/`: Chat domain entities, data sources, DTO parser, repository implementation, Riverpod controllers, chat list/conversation screens, and chat widgets.
- `lib/features/notifications/`: Notifications domain entities, data sources, DTO parser, repository implementation, Riverpod controller, notifications screen, and notification widgets.
- `test/`: focused core and app root tests.
- `docs/design/brand_identity.md`: brand colors, typography direction, logo usage, SVG compatibility notes.
- `docs/design/design_system.md`: implemented design-system rules and component inventory.
- `docs/client_walkthrough_checklist.md`: mock-mode run commands, client demo flow, walkthrough QA checklist, known limitations, and SVG warning note.
- `docs/client_demo_handoff.md`: final mock-mode client demo handoff, run commands, walkthrough order, positioning, limitations, and QA checklist.
- `docs/demo_data_notes.md`: mock-mode data strategy, fictional consistency map, AED-only rule, and backend replacement plan.
- `docs/prototype_comparison_audit.md`: documentation-only comparison of old prototype screenshots against the current Flutter MVP.
- `docs/prototype_section_contract.md`: visible-section contract for aligning the MVP demo surface with the original prototype structure while keeping the premium PROMOO design.
- `../promo_backend/docs/promoo-api-reference.json`: read-only high-level API contract source.
- `../promo_backend/src/routes/service.routes.ts`, `../promo_backend/src/controllers/service.controller.ts`, and `../promo_backend/src/services/service.service.ts`: read-only Service detail route and response-shape confirmation.
- `../promo_backend/src/routes/offer.routes.ts`, `../promo_backend/src/controllers/offer.controller.ts`, `../promo_backend/src/services/offer.service.ts`, and `../promo_backend/src/validators/offer.validator.ts`: read-only Offer route and detail response confirmation.
- `../promo_backend/src/routes/ad.routes.ts`, `../promo_backend/src/controllers/ad.controller.ts`, `../promo_backend/src/services/ad.service.ts`, and `../promo_backend/src/validators/ad.validator.ts`: read-only Ad route and active-ad response confirmation.
- `../promo_backend/docs/Realtime-Chat-Flutter-Guide.md`: read-only chat realtime guidance.
- `../promo_backend/src/routes/auth.routes.ts`, `../promo_backend/src/controllers/auth.controller.ts`, `../promo_backend/src/services/auth.service.ts`, and `../promo_backend/src/validators/auth.validator.ts`: read-only Auth Lite contract confirmation.
- `../promo_backend/src/middleware/auth.middleware.ts`: read-only bearer-token middleware confirmation.
- `../promo_backend/src/routes/chat.routes.ts`, `../promo_backend/src/controllers/chat.controller.ts`, `../promo_backend/src/services/chat.service.ts`, and `../promo_backend/src/validators/chat.validator.ts`: read-only Chat route and response-shape confirmation.
- `../promo_backend/src/routes/notification.routes.ts`, `../promo_backend/src/controllers/notification.controller.ts`, `../promo_backend/src/services/notification.service.ts`, and `../promo_backend/src/validators/notification.validator.ts`: read-only Notifications route and response-shape confirmation.

## Product summary

Promoo MVP is a premium dark marketplace/social app for discovering home content, categories, services, seats, profiles, packages, search, leaderboard/cup, chat, and notifications.

The MVP must stay close to the prototype: black UI, strong yellow accents, modern dark cards, rounded corners, high contrast, mobile-first layout, Arabic/English support, and RTL/LTR readiness.

## Confirmed brand decisions

- Primary black: `#000000`.
- Primary yellow: `#FFE604`.
- Logo font: Varela Round, logo only.
- UI font recommendation: Tajawal.
- Use system fallback until custom fonts are configured.
- Do not force Varela Round for Arabic UI text.

## MVP product decisions

- Reviews and ratings are hidden in MVP.
- Likes and comments are hidden in MVP.
- Facebook login is removed from MVP.
- Services are listing/contact only, not purchase flow.
- Profile packages shown on profile screens are represented as services connected to that profile. They are display/contact only in this MVP phase.
- Hide `promo_code`, `terms`, and `best_price` when not returned by API.
- Cup must use `GET /leaderboard`, not search.
- Development mocks are allowed only behind repository/data-source boundaries and must not be final production data.

## Architecture direction

- Flutter.
- Clean architecture.
- Feature-first structure.
- Riverpod for state management.
- go_router for routing.
- Dio for REST.
- Typed DTOs/models.
- Centralized API response parsing.
- Typed failures.
- Secure token storage abstraction later.
- Localization-ready structure later.

## MVP phase state

Current phase: `Final Client APK QA after client feedback frontend patch`.

Completed to date:

- Brand identity note exists.
- Brand assets registered.
- `flutter_svg` installed.
- Project audit and backend docs read-only inspection performed.
- Planning docs created.
- Core dependencies added: `flutter_riverpod`, `go_router`, `dio`.
- Minimal app root uses `ProviderScope` and `MaterialApp.router`.
- Core config supports `PROMOO_BASE_URL`, `PROMOO_ENV`, `PROMOO_USE_MOCKS`, and `PROMOO_FALLBACK_CURRENCY`.
- API foundation created with Dio wrapper, endpoint constants, flexible response parsing, and API exceptions.
- Typed failures and Result primitives created.
- Initial black/yellow theme tokens created from brand guidance.
- Design tokens expanded across colors, spacing, radius, typography, shadows, and Material component themes.
- Shared widgets added: scaffold, logo, button, card, text field, loading, empty, error, and section header.
- Placeholder app shell initially added Home, Services, Cup, Seats, and Profile tabs; Prompt 20 later changed only the visible `/seats` tab label to `Influencer`.
- Splash placeholder uses `assets/brand/promoo3.svg`; compact logo usage uses `assets/brand/promoo.svg`.
- Home feature slice added with UI, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/retry states, and focused tests.
- Services feature slice added with categories, service list/search/category filter, detail repository support, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/retry states, and focused tests.
- Cup / Leaderboard feature slice added with ranked profiles, podium highlight, ranked list, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/retry states, and focused tests.
- Seats feature slice added with public seat listing, tier filtering, safe auth-required booking state, booking response parsing, repository/data-source booking method, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/retry states, and focused tests.
- Profile + Packages feature slice added with demo/public profile display, profile packages from services, safe action states, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/retry states, and focused tests.
- Search feature slice added with grouped/mixed results, type filters, influencer filter, profile result navigation, DTO/model mapping, repository, Riverpod controller/provider, remote data source, fake data source, loading/error/empty/idle/retry states, and focused tests.
- Auth Lite feature slice added with email login, email registration, logout, refresh repository support, defensive Supabase-like session parsing, in-memory session store, Riverpod controller/provider, `/login` and `/register` routes, safe login-required CTA navigation from Profile/Seats, fake data source, validation/error/authenticated states, and focused tests.
- Chat skeleton slice added with chat rooms, messages, send message, mark-read repository support, DTO/model mapping, repository, Riverpod room-list and conversation controllers, `/chats` and `/chats/:roomId` routes, fake data source, auth-required real-mode state, loading/error/empty/retry states, and focused tests.
- Notifications skeleton slice added with notification list, mark read, mark all read, delete notification, token-registration repository support, DTO/model mapping, repository, Riverpod controller, `/notifications` route, fake data source, auth-required real-mode state, loading/error/empty/retry states, and focused tests.
- MVP polish + QA pass added route smoke coverage for `/`, `/home`, `/services`, `/cup`, `/seats`, `/profile`, `/profiles/:id`, `/search`, `/login`, `/register`, `/chats`, `/chats/:roomId`, and `/notifications`; refined demo-facing copy; kept public screens public; and confirmed mock mode can render demo content across implemented slices without network calls.
- SVG warning review confirmed the supplied brand SVGs contain CSS `<style>`/`class` usage. `flutter_svg` renders them, but tests print a non-fatal `unhandled element <style/>` warning. This is documented as non-blocking until clean flattened SVG exports are available.
- Mock-mode client walkthrough QA documented exact run commands for Edge, Chrome when available, Android device, Android emulator, and Windows desktop; added a client flow checklist; and removed the disabled Home highlight CTA that looked actionable but had no destination.
- Client demo visual fixes from Android walkthrough added consistent shell scroll bottom clearance, AED-only mock service/package currencies, horizontally padded/auto-revealed Search filters, keyboard-aware Chat room input padding, more flexible Leaderboard card metadata, deeper Profile package scroll clearance, and a slightly higher Splash content alignment.
- Prototype picture comparison audit reviewed `../promo_backend/Projects-Pictures` read-only and documented differences against the Flutter MVP without code changes. No P0 client-demo blockers were identified if the demo is framed as the scoped MVP.
- Service Detail + Contact MVP added `/services/:id`, a lightweight service detail screen, safe contact actions, and detail navigation from Services, Search service results, and Home service previews. Purchase, checkout, orders, reviews, ratings, and real chat-room creation remain excluded.
- Home Top Offer / For You Detail MVP added `/home/items/:type/:id`, a lightweight Home content detail screen for offers/promotions/ads, safe contact and location notices, and detail navigation from Home highlight cards, Home promotion cards, Search offer results, and Search ad results. Offer purchase, checkout, final maps, final share/favorite behavior, and real provider-specific chat creation remain excluded.
- Seats / Influencer visual alignment updated the `/seats` screen with client-facing "Influencer Seats" copy, Gold/Silver/Bronze tier explanation, and a compact visibility grid. Prompt 20 later changed only the visible bottom navigation label to "Influencer"; backend route remains `/seats`.
- Profile Media + Management Preview MVP added a media/posts grid, mock demo media behind `ProfileFakeDataSource`, and a Profile-tab-only tools preview for Manage profile, Create offers, Saved items, Support, and Language. Actions remain safe "coming soon" previews; real edit submission, uploads, settings, add-ad wizard, saved/following, support, language persistence, logout, checkout, and payments remain deferred.
- Final Android Walkthrough + Client Demo Handoff created `docs/client_demo_handoff.md` with exact mock-mode run commands, final demo flow, demo positioning, client-safe limitations, and final QA checklist. No new app features were added.
- Final Section Accuracy QA separated Home's Top Offers and Promoo of the Day into distinct visible sections, moved Profile packages before media/tools/about/details, and confirmed Services, Influencer/Seats, Cup, Login/Register, and Chat/Notifications entry points remain section-aligned.

Next recommended action:

- Run the final client walkthrough in mock mode using `docs/client_demo_handoff.md`, then start the backend integration hardening phase based on client feedback.
- Do not add payments, push, uploads, realtime, full settings, orders, or store-release work until explicitly scoped.

## Dependency notes

- package: `flutter_riverpod` `3.3.2`
- purpose: ProviderScope, dependency wiring, and future feature controllers.
- license: MIT, verified from resolved package license file.
- data collected: none.
- permissions/platform impact: none expected.
- alternatives considered: Provider/BLoC/manual service wiring; Riverpod matches the planned architecture and test override model.
- owner: Promoo Flutter app.
- review date: 2026-06-25.

- package: `go_router` `17.3.0`
- purpose: centralized declarative routing with future auth guards and shell routes.
- license: BSD-style Flutter license, verified from resolved package license file.
- data collected: none.
- permissions/platform impact: none expected.
- alternatives considered: Navigator 1.0/manual routing; go_router better fits deep links and guarded routes.
- owner: Promoo Flutter app.
- review date: 2026-06-25.

- package: `dio` `5.9.2`
- purpose: REST API transport with timeout, error, cancellation, and interceptor support.
- license: MIT, verified from resolved package license file.
- data collected: none by package itself.
- permissions/platform impact: network transport only; no platform permissions added by the package.
- alternatives considered: `http`; Dio better fits interceptors, cancellation, base options, and structured API handling.
- owner: Promoo Flutter app.
- review date: 2026-06-25.

Deferred packages:

- `google_fonts`: evaluated in the design-system step but not retained because the resolved package graph introduced platform plugin dependencies and `flutter pub add google_fonts` failed on this Windows setup without Developer Mode symlink support. Current theme uses system fallback and keeps Tajawal documented as the target UI font.
- `flutter_secure_storage`: still deferred. Auth Lite intentionally uses an in-memory session store only; secure persistence should be added in a later auth hardening step.
- Supabase, Firebase, Stripe, image picker, and notification packages: not added.
- `firebase_messaging` and `flutter_local_notifications`: not added. Push notification permissions, token collection, and background handlers remain deferred.

Typography note:

- Varela Round remains logo-only.
- Tajawal remains the recommended UI font.
- The current implementation does not force an unavailable font family; add bundled font assets or `google_fonts` later only when the local build environment supports the dependency.

## Known constraints

- Do not modify `../promo_backend`.
- Do not invent backend contracts beyond documented endpoints.
- Do not store secrets in Flutter.
- Do not build screens before their vertical-slice phase.
- Do not build all screens first and wire backend later.
- Keep docs and code synchronized after each meaningful decision.

## Home slice notes

- Endpoints: `GET /home`, `GET /offers/:id`, and `GET /ads/active`.
- Backend was inspected read-only at `../promo_backend/src/controllers/home.controller.ts`, `../promo_backend/src/services/home.service.ts`, `../promo_backend/src/routes/offer.routes.ts`, `../promo_backend/src/controllers/offer.controller.ts`, `../promo_backend/src/services/offer.service.ts`, `../promo_backend/src/routes/ad.routes.ts`, `../promo_backend/src/controllers/ad.controller.ts`, and `../promo_backend/src/services/ad.service.ts`.
- Backend wraps Home data with `{ success, data, message }`.
- Confirmed Home data keys: `stories`, `categories`, `featured_profiles`, `promoo_of_the_day`, `latest_offers`, `services`, and `ads`.
- Confirmed `GET /offers/:id` is public with optional auth and validates UUID ids in real backend mode.
- Confirmed there is no public `GET /ads/:id`; public ad detail fallback uses `GET /ads/active` and finds the ad by id.
- DTO parsing is defensive and supports common direct/nested variants.
- Home detail parsing supports wrapped/direct offer objects and active ad list rows with nested `profile` and `category` variants where available.
- Flutter route `/home/items/:type/:id` is display/contact only for offer and ad detail.
- Home highlight cards and promotion cards navigate to detail when an id exists.
- Home detail can show title, description, hero fallback, provider/profile, category/tags, price/currency, location, promo code, valid-until, and terms when present.
- Contact actions are safe for MVP: Contact shows a coming-soon notice, Open chats routes to `/chats`, View provider profile routes to `/profiles/:id` when provider id exists, and Location shows a coming-soon location notice.
- `PROMOO_USE_MOCKS=true` makes the Home repository use `HomeFakeDataSource`; otherwise it uses `HomeRemoteDataSource`.
- Fake data remains behind data-source/repository boundaries and is not embedded in widgets.

## Services slice notes

- Endpoints: `GET /categories`, `GET /services`, `GET /services?category_id={id}`, `GET /services?q={text}`, and `GET /services/:id`.
- Backend was inspected read-only at `../promo_backend/src/controllers/service.controller.ts`, `../promo_backend/src/services/service.service.ts`, `../promo_backend/src/controllers/category.controller.ts`, and `../promo_backend/src/services/category.service.ts`.
- Backend `GET /services` returns a paginated envelope with `data` and `meta`.
- Backend supports both `categoryId` and `category_id`, but Flutter intentionally uses only `category_id`.
- Backend service rows include `profile` and `category` nested objects.
- Backend `GET /services/:id` is confirmed as a public route and validates the path id as a UUID in real backend mode.
- Flutter does not implement service purchase, orders, checkout, or payments.
- Flutter implements a lightweight `/services/:id` detail screen for display/contact only.
- Service detail can show title, description, category, provider, provider profile id, location, price/currency, delivery days, tags, and image fallback when available.
- Service cards, Home service previews, and Search service results can navigate to service detail when an id exists.
- Contact actions are safe for MVP: Contact provider shows a coming-soon notice, Open chats routes to `/chats`, and View provider profile routes to `/profiles/:id` when the provider id is available.
- `PROMOO_FALLBACK_CURRENCY` was added to `AppConfig`; default fallback is `AED`.
- Service cards display API currency when present and fall back to `AppConfig.fallbackCurrency` only when service price is present but currency is missing.
- `PROMOO_USE_MOCKS=true` makes the Services repository use `ServicesFakeDataSource`; otherwise it uses `ServicesRemoteDataSource`.
- Fake data remains behind data-source/repository boundaries and is not embedded in widgets.

## Cup / Leaderboard slice notes

- Endpoint: `GET /leaderboard?page=1&limit=20&type=all`.
- Backend was inspected read-only at `../promo_backend/src/controllers/leaderboard.controller.ts`, `../promo_backend/src/services/leaderboard.service.ts`, and `../promo_backend/src/validators/leaderboard.validator.ts`.
- Backend returns paginated ranked profile rows from active non-user accounts ordered by `followers_count`.
- Confirmed profile fields include `rank`, `id`, `full_name`, `username`, `avatar_url`, `bio`, `account_type`, `followers_count`, `is_verified`, and `is_featured`.
- Flutter uses `/leaderboard` directly; the `/search` sorting fallback is not used.
- DTO parsing is defensive and supports direct lists, paginated envelopes, nested list keys, and nested `profile`/`user`/`account` rows.
- The Cup tab renders a podium highlight for the top 3 and a ranked profile list.
- No profile detail routing, auth, search, subscriptions, payments, likes, comments, or reviews were added.
- `PROMOO_USE_MOCKS=true` makes the Leaderboard repository use `LeaderboardFakeDataSource`; otherwise it uses `LeaderboardRemoteDataSource`.
- Fake leaderboard data remains behind data-source/repository boundaries and is not embedded in widgets.

## Seats slice notes

- Endpoints: `GET /seats`, `GET /seats/me`, and `POST /seats/:id/book`.
- Backend was inspected read-only at `../promo_backend/src/controllers/seat.controller.ts`, `../promo_backend/src/services/seat.service.ts`, `../promo_backend/src/routes/seat.routes.ts`, and `../promo_backend/src/validators/seat.validator.ts`.
- Backend `GET /seats` is public and supports optional `tier=gold|silver|bronze`.
- Backend `GET /seats/me` requires auth.
- Backend `POST /seats/:id/book` requires auth and influencer account type; the seat id is passed in the URL path.
- Backend booking returns `checkoutUrl`, `sessionId`, `paymentId`, and `status` when a checkout session is created.
- Flutter repository/data source supports `getSeats`, `getMySeats`, and `bookSeat`.
- Flutter UI does not perform real booking yet because Auth lite and token storage are not implemented.
- Available-seat CTA shows a safe `Login required` / deferred-auth message and does not open checkout URLs.
- The shell tab is visibly labeled `Influencer` for the client walkthrough while route/backend naming remains `/seats`; the screen header uses `Influencer Seats` for client-facing prototype terminology.
- Seats UI now includes a compact visibility grid and tier explanation for Gold visibility, Silver placement, and Bronze visibility.
- DTO parsing is defensive and supports direct lists, wrapped lists, nested `items`/`seats`, nested `profile`/`holder`, and booking response variants.
- Seat price displays API currency when present and falls back to `AppConfig.fallbackCurrency` (`AED`) when price exists but currency is missing.
- `PROMOO_USE_MOCKS=true` makes the Seats repository use `SeatsFakeDataSource`; otherwise it uses `SeatsRemoteDataSource`.
- Fake seat data remains behind data-source/repository boundaries and is not embedded in widgets.

## Profile + Packages slice notes

- Endpoints: `GET /profiles/:idOrUsername`, `GET /profiles/me`, and `PUT /profiles/me`.
- Backend also exposes `GET /profiles/:id/media`; this prompt confirmed it read-only, but did not add a new media API call.
- Backend was inspected read-only at `../promo_backend/src/controllers/profile.controller.ts`, `../promo_backend/src/services/profile.service.ts`, `../promo_backend/src/routes/profile.routes.ts`, and `../promo_backend/src/validators/profile.validator.ts`.
- Public profile route supports either profile id or username.
- `GET /profiles/me` and `PUT /profiles/me` require auth, so the MVP UI does not require or call them yet.
- Profile tab uses demo profile behavior through `ProfileFakeDataSource` until Auth/current-user support exists.
- Public profile detail route `/profiles/:id` is wired for direct profile display.
- Public profile display remains the stable public profile experience.
- Profile media preview reads `mediaUrls` from the profile model and supports defensive parsing for `media`, `posts`, `media_urls`, direct media URL fields, and object rows with common URL keys.
- Mock demo profile media lives in `ProfileFakeDataSource`; no fake media data is embedded in widgets.
- Profile menu shows lightweight owner-side tools with Manage profile, Create offers, Saved items, Support, and Language entries. Public profile routes do not show owner tools on the profile page.
- Profile menu tools use client-friendly "coming soon" SnackBar feedback only and do not open new routes.
- Profile packages are services connected to the profile, not subscription plans.
- No package purchase, checkout, subscriptions, payments, image upload, real edit submission, settings persistence, add-ad wizard, saved/following implementation, production logout, follow mutation, or chat mutation were added.
- Backend `GET /services` currently supports category and text search, but no confirmed `profileId` or `profile_id` query filter. Remote package loading therefore fetches public services and filters by nested profile id client-side, which may be incomplete beyond the first page.
- DTO parsing is defensive and supports wrapped/direct profile objects, nested profile/account/user variants, stats objects, avatar/cover/media fields, social links, and service rows as packages.
- Package price displays API currency when present and falls back to `AppConfig.fallbackCurrency` (`AED`) when price exists but currency is missing.
- `PROMOO_USE_MOCKS=true` makes public profile/package loads use `ProfileFakeDataSource`; demo profile loading always uses fake data until Auth exists.
- Fake profile/package data remains behind data-source/repository boundaries and is not embedded in widgets.

## Search slice notes

- Endpoint: `GET /search`.
- Backend was inspected read-only at `../promo_backend/src/controllers/search.controller.ts`, `../promo_backend/src/services/search.service.ts`, `../promo_backend/src/routes/search.routes.ts`, and `../promo_backend/src/validators/search.validator.ts`.
- Confirmed query parameters: `q`, `type`, `page`, `limit`, `categoryId`, `minPrice`, `maxPrice`, `location`, and `accountType`.
- Confirmed `type` values: `all`, `profiles`, `offers`, `ads`, and `services`.
- Flutter uses `type=profiles&accountType=influencer` for the Influencers filter; it does not use `account_type`.
- `type=all` returns grouped preview data with `profiles`, `offers`, `ads`, and `services`.
- Specific type searches return paginated list data with `meta`.
- Search is submit/button/filter driven and requires at least 2 characters; it does not search on every keystroke.
- Profile results navigate to `/profiles/:id`; service results navigate to `/services/:id`; offer and ad results navigate to `/home/items/:type/:id`.
- No Auth, Chat, Notifications, Payments, Orders, Subscriptions, Checkout, service purchase, seat booking, edit profile, or uploads were added.
- `PROMOO_USE_MOCKS=true` makes the Search repository use `SearchFakeDataSource`; fake search data remains behind the data-source/repository boundary and is not embedded in widgets.

## Auth Lite slice notes

- Endpoints: `POST /auth/register/email`, `POST /auth/login/email`, `POST /auth/refresh`, and `POST /auth/logout`.
- Backend was inspected read-only at `../promo_backend/src/routes/auth.routes.ts`, `../promo_backend/src/controllers/auth.controller.ts`, `../promo_backend/src/services/auth.service.ts`, `../promo_backend/src/validators/auth.validator.ts`, and `../promo_backend/src/middleware/auth.middleware.ts`.
- Email registration body uses `email`, `password`, `full_name`, and `account_type`.
- Email login body uses `email` and `password`.
- Refresh body uses `refresh_token`.
- Logout sends `Authorization: Bearer <accessToken>` when an access token exists.
- Backend responses are Supabase-like and may include `{ user, session }`; registration can return `session: null` when email verification is required.
- Flutter parses user metadata defensively, including `full_name`, `account_type`, avatar, and nested session/user variants.
- Auth Lite uses in-memory session storage only. Tokens are not persisted across app restarts until secure storage is intentionally added.
- `/login` and `/register` are public routes outside the bottom-navigation shell.
- Existing public Home, Services, Cup, Influencer/Seats, Profile, and Search screens remain public; no complex auth guards were added.
- Profile and Seats login-required CTAs can navigate to `/login`, but real follow, edit, booking, checkout, and profile mutation flows remain deferred.
- Social login, phone login, OTP final flow, account deletion, Firebase/Supabase client SDKs, push notifications, Stripe, and checkout were not added.
- `PROMOO_USE_MOCKS=true` makes the Auth repository use `AuthFakeDataSource`; fake auth data remains behind the data-source/repository boundary and is not embedded in widgets.

## Chat + Notifications skeleton notes

- Chat endpoints: `GET /chats`, `POST /chats`, `GET /chats/:roomId/messages`, `POST /chats/:roomId/messages`, `PATCH /chats/:roomId/read`, and backend-supported `DELETE /chats/:roomId`.
- Notification endpoints: `GET /notifications?page=1&limit=20`, `PATCH /notifications/read-all`, `PATCH /notifications/:id/read`, `DELETE /notifications/:id`, and `POST /notifications/token`.
- Backend was inspected read-only at `../promo_backend/src/routes/chat.routes.ts`, `../promo_backend/src/controllers/chat.controller.ts`, `../promo_backend/src/services/chat.service.ts`, `../promo_backend/src/validators/chat.validator.ts`, `../promo_backend/src/routes/notification.routes.ts`, `../promo_backend/src/controllers/notification.controller.ts`, `../promo_backend/src/services/notification.service.ts`, and `../promo_backend/src/validators/notification.validator.ts`.
- Backend mounts Chat at `/chats`; the older `/chat/rooms` uncertainty is resolved and not used.
- Both Chat and Notifications route groups require backend auth.
- Flutter real-mode repositories read the Auth Lite in-memory session and return an unauthorized failure when no access token exists.
- `PROMOO_USE_MOCKS=true` makes Chat and Notifications use fake data sources and remain demo-ready without a session.
- Chat UI includes `/chats` and `/chats/:roomId`, room cards, message bubbles, text input, loading, empty, error, retry, and login-required states.
- Sending text messages works through the repository in fake mode. In real mode it requires the in-memory bearer token and uses the REST endpoint only.
- Profile Message action opens `/chats`; starting a chat with that exact profile remains deferred.
- Notifications UI includes `/notifications`, notification cards, unread indicators, type labels/icons, mark-all-read, delete, loading, empty, error, retry, and login-required states.
- Message notifications navigate to `/chats/:roomId` only when `room_id` or `roomId` exists in notification data.
- `POST /notifications/token` is represented in the repository/data layer only. No final FCM token collection is implemented.
- Supabase realtime, WebSocket realtime, Firebase FCM setup, `firebase_messaging`, `flutter_local_notifications`, push permissions, background handlers, media upload, voice messages, payment events, full moderation, and complex auth guards remain deferred.

## MVP polish + QA notes

- All requested routes are wired and covered by route smoke tests in mock mode: `/`, `/home`, `/services`, `/cup`, `/seats`, `/profile`, `/profiles/:id`, `/search`, `/login`, `/register`, `/chats`, `/chats/:roomId`, and `/notifications`.
- Public screens remain public. Auth-required behavior is represented by screen states and CTAs rather than complex route guards.
- Demo-facing copy avoids implementation terms such as skeleton, REST-backed, deferred, and backend checkout language in visible UI.
- Fake data remains in fake data sources. Widgets still consume controller state/domain models only.
- SVG `<style/>` warnings are non-fatal and come from the provided brand assets; avoid editing source logos unless clean flattened SVG exports are supplied or explicitly approved.

## Mock-mode client walkthrough QA notes

- Mock mode is enabled with `--dart-define=PROMOO_USE_MOCKS=true`.
- Current device scan found Edge web, Windows desktop, connected Android device `edba8ffc`, and an available `Pixel_8` Android emulator.
- Focused route walkthrough simulation passed for all client demo routes.
- `docs/client_walkthrough_checklist.md` is the client walkthrough runbook for demo order, expected states, known limitations, pending production items, and SVG warning handling.
- The Home highlight disabled `View details` button was removed so the walkthrough does not show a CTA that appears active but cannot navigate.

## Client demo visual fixes notes

- `AppSpacing.shellScrollBottom` is the shared shell-page bottom clearance for long scrollable pages under the bottom navigation.
- Home, Services, Cup / Leaderboard, Seats, Profile, and Search use the shared shell scroll bottom clearance.
- Services fake data now uses AED for every mock service price.
- Profile fake data now uses AED for every mock package price.
- Search filter chips remain horizontally scrollable with end padding and selected-chip reveal.
- Chat room input uses keyboard-aware bottom padding and keeps extra spacing above the keyboard.
- Leaderboard profile cards no longer reserve a trailing follower-count column; metadata can use two lines, giving names more space.
- Splash content is aligned slightly above center for better Android walkthrough balance.

## Prototype comparison audit notes

- Old prototype screenshots were inspected from `../promo_backend/Projects-Pictures` only as reference material.
- Folders reviewed: `home page`, `home page/for you section`, `home page/stories section`, `home page/top offer section`, `services page`, `influencer page`, `cup page`, `profile page`, and `log-in page`.
- The current black/yellow PROMOO design system remains the source of truth; the prototype should not be copied 1:1.
- Main matches: Home discovery sections, Services listing/category structure, Cup ranked profiles, Seats tier concept, Profile packages, email login, and Chat/Notifications skeleton coverage.
- Main gaps after the Profile media/tools preview: richer Home visual carousel parity, exact prototype Influencer seat-grid/payment parity, full profile management/edit/upload/add-ad screens, package checkout/details, sticky location/map actions, header chat/notification badges, social login, and story full-screen viewer.
- The previous service detail/contact P1 gap is partially addressed with `/services/:id`, safe contact copy, Open chats, and View provider profile actions.
- The previous Home top-offer/for-you detail P1 gap is partially addressed with `/home/items/:type/:id`, safe contact copy, safe location copy, Open chats, and View provider profile actions.
- Profile is structurally complete for the MVP public profile plus packages display, but not for the prototype's account-management/profile-owner flows.
- No P0 client-demo blocker was identified from the screenshots if the walkthrough is presented as the scoped MVP.

## Prototype section alignment notes

- Created `docs/prototype_section_contract.md` before code changes to record the keep/rename/hide decisions per page.
- Home now prioritizes the prototype-facing sections: Stories, Top Offers, For You, and Promoo of the Day. Extra Home discovery surfaces such as categories and featured profiles remain in code/data but are hidden from the primary demo surface.
- Final QA confirms Home now shows distinct Stories, Top Offers, For You, and Promoo of the Day sections.
- Home header now has safe Chat and Notifications entry points using existing routes.
- Services now presents a category grid first, then search/listings, matching the prototype's service-category landing structure.
- The visible bottom navigation label for `/seats` changed from `Seats` to `Influencer`; route and backend naming remain `/seats`.
- Profile packages are shown before media/tools/about-details so the walkthrough better matches the prototype's package-first profile flow.
- Login/Register now show Apple, Google, and Facebook visual sign-in buttons with safe coming-soon feedback only. No social SDKs or packages were added.
- The new build preserves the approved premium visual design while aligning visible page sections with the original prototype structure.

## Realistic mock demo data notes

- Mock-mode data was polished for final client review without adding features, routes, packages, backend calls, navigation changes, or design changes.
- Fictional demo content now centers on Saffron Social Studio plus related fictional providers across Home, Services, Search, Profile, Influencer Seats, Cup / Leaderboard, Chat, and Notifications.
- Services categories now use Beauty & Wellness, Restaurants & Cafes, Events & Photography, Fashion & Styling, Health & Fitness, Home & Lifestyle, Digital Marketing, and Influencer Campaigns.
- Mock-mode service, profile package, seat, offer, and search prices are AED-only.
- Profile media uses neutral internal `promoo-media://` references and remains behind `ProfileFakeDataSource`.
- Chat and Notifications use professional campaign, package, profile-view, and offer-interest copy with no private contact data.
- Added `test/demo_data/demo_data_quality_test.dart` to verify AED-only mock pricing, placeholder-free visible fake-source strings, and cross-feature identity consistency.
- `docs/demo_data_notes.md` records the strategy and replacement plan for the backend-integration phase.

## Final pre-client patch Step 1 + Step 2 notes

- Step 1 replaced the static launch welcome with a native Flutter animated PROMOO intro using black background, yellow glow, staged logo reveal, and automatic navigation to `/login`.
- Login/Register visuals were intentionally preserved. Auth Lite remains unchanged; after a successful login/register session, the existing `Continue` action enters Home.
- Auth screen fallback back navigation now returns to the launch intro instead of bypassing auth into Home.
- Step 2 upgraded Home while preserving the section contract: Stories, Top Offers, For You, Promoo of the Day, and Services.
- Stories now open a fullscreen image-based story viewer with progress bars, profile/avatar header, close action, previous/next tap zones, and tasteful black/yellow styling.
- Top Offers, For You, and Services now use swiper-style PageView cards with professional-looking fictional imagery and resilient image fallback behavior.
- Promoo of the Day now uses an image-first hero treatment.
- Visual reference screenshots were inspected only as references and were not bundled into app assets.

## Final pre-client patch Step 3 + Step 4 notes

- Step 3 upgraded Cup / Leaderboard with realistic mock avatars, stronger top-three treatment, and clickable podium/list items that open existing public profile routes.
- Cup fake leaderboard IDs now align with mock profile IDs so `/profiles/:id` resolves during the walkthrough.
- Profile headers now use resilient image rendering for avatar and cover images.
- Profile media now uses a two-column image-led grid and opens a fullscreen story-style viewer with like/comment/share/view affordances. Real upload, persistence, comments, likes, and sharing remain deferred.
- Step 4 upgraded Influencer Seats with a denser profile/open-seat visibility grid while keeping backend naming and route stability as `/seats`.
- Occupied seats open an influencer preview bottom sheet with Follow and View profile actions. Follow remains safe coming-soon feedback; View profile uses the existing public profile route.
- Available seats open a seat detail bottom sheet. `Book Now` opens a demo checkout preview at `/seats/checkout`; no repository booking, payment SDK, checkout URL, WebView, Stripe, or real payment flow is executed.
- Influencer Seats fake data now includes occupied, pending, and available Gold/Silver/Bronze placements with mock holder avatars behind `SeatsFakeDataSource`.
- Visual reference screenshots were inspected only as references and were not bundled into app assets.

## Final pre-client patch Step 5 notes

- Step 5 prepared Android client-review APK readiness without adding backend integration, real payments, real booking, uploads, realtime, push notifications, production social auth, packages, or broad architecture refactors.
- Android app label is now `Promoo` in `android/app/src/main/AndroidManifest.xml`.
- Android launcher icons were manually generated from the approved embedded PROMOO logo artwork in `assets/brand/promoo.svg`; no launcher-icon package was added.
- Android adaptive icon resources were added for API 26+ and legacy mipmap launcher/round icons were replaced for older launchers.
- Main Android manifest includes Internet permission so release APKs can load network-hosted demo imagery while still using mock app data when built with `PROMOO_USE_MOCKS=true`.
- Influencer seat preview bottom sheets now use scroll protection for shorter Android screens.
- Created `docs/client_apk_review_checklist.md` with split/universal APK commands, output paths, app name/icon checks, mock-mode checks, main flow checklist, and client-safe limitations.
- `docs/client_demo_handoff.md` now includes APK build commands and the requirement to build the client APK with `--dart-define=PROMOO_USE_MOCKS=true`.
- Added `test/android/android_client_apk_config_test.dart` to verify Android label, icon references, release Internet permission, and launcher icon files.

## Client feedback frontend patch notes

- Added `Continue as Guest` to Login and Register. It routes to Home in mock/demo review mode without backend calls or auth requirements.
- Cleaned Login/Register and Home logo usage to show the approved PROMOO logo without extra subtitle text under or beside the logo.
- Home header now uses prototype-aligned outline chat/notification actions with small yellow badges and routes to existing Chat/Notifications screens.
- Home stories still close with the X button and now also close with a downward swipe gesture.
- Home Top Offers now has more than three demo slides; Stories, Top Offers, For You, Promoo of the Day, and Services expose safe `See All` actions.
- Home Services preview is more compact so more image-based service cards are visible at common mobile widths.
- Services categories now use image-based cards sourced from Services DTO/fake data. Service listings also use fake-source image URLs instead of icon-only presentation.
- Services default unfiltered listings are hidden from the visible demo surface; search/category results remain available, local/mock-safe, and show a clear no-match state.
- The bottom navigation Cup route is visually represented as a stylized `P` with label `Promoo`; route behavior remains `/cup`.
- The shell bottom navigation uses a native Flutter translucent/glass treatment that reacts to scroll. The Home header now uses a pinned scroll-aware glass surface.
- Influencer Seats uses a smaller stats header, a denser four-column seat grid, and more fictional Gold/Silver/Bronze demo slots while preserving `/seats` and safe preview-only booking behavior.
- Profile icon taps now open a settings-style profile menu with View Profile, Edit Profile, Saved, Language, Theme Mode, Support, and Logout preview actions.
- Theme Mode in the Profile menu is visual-only. Black Mode remains selected and Light Mode shows client-safe next-phase feedback without changing app theme.
- Public Profile stats now show Followers, Likes, Posts, and Views with realistic fictional values from profile fake data; bio is surfaced in the header.
- No backend integration, production auth, real booking, real payment, uploads, realtime, push notifications, packages, or broad architecture refactor was started.

## Final client APK QA notes

- Verified the client feedback frontend patch against the APK QA checklist.
- Added the tiny missing header polish: Home now uses a pinned, scroll-aware glass header while the shell footer keeps its scroll-aware glass treatment.
- Re-ran validation after the header change: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` all passed.
- Built the universal client-review APK with `flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true`.
- Built split APKs with `flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true`.
- Latest verified output to send for most modern Android phones: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`.
- Universal fallback when device architecture is unknown: `build/app/outputs/flutter-apk/app-release.apk`.
- Installed `app-arm64-v8a-release.apk` on connected Android 13 device `M2012K11AG` and verified fresh launch, logo-only intro to Login, and `Continue as Guest` into Home.
- This remains a client-review UI/UX build. Backend integration, production auth, real payments, real booking, uploads, realtime chat, push notifications, and store release remain later phases.

## Final client review fix patch notes

- Welcome/intro is now logo-only with `assets/brand/promoo3.svg`, premium glow/scale motion, and automatic navigation to Login after the animation.
- Login/Register and Home header use the larger `promoo3.svg` presentation; the launcher icon remains based on the compact `assets/brand/promoo.svg` mark.
- Android launcher mipmap PNGs were regenerated with extra safe padding for legacy and adaptive icons so the compact PROMOO mark is not oversized or clipped.
- Home stories now support grouped owner story items. Tapping next or timer completion advances within the same owner before moving to the next owner; previous navigation mirrors that behavior.
- Services search is live and local for the current service list, matching title, category, provider, tags, and description without adding backend calls.
- Profile menu Theme Mode controls are visual-only and do not change the app theme.
- Own Profile no longer shows Follow, Message, or Profile Tools on the profile page. Public profile routes still show Follow and Message.
- Profile Tools are no longer rendered inside the Profile page; profile-owner tools stay in the Profile menu.
- Final validation passed: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, universal mock-mode APK build, and split mock-mode APK build.
- Full test suite passed with 192 tests. Known non-fatal SVG `<style/>` warnings remain.
- Final APK outputs: `app-release.apk` 52.5 MB, `app-arm64-v8a-release.apk` 18.1 MB, `app-armeabi-v7a-release.apk` 15.9 MB, and `app-x86_64-release.apk` 19.5 MB.
- Final local install on connected Android device `M2012K11AG` was blocked by Android with `INSTALL_FAILED_USER_RESTRICTED`; APK builds still completed successfully.

## Validation history

- 2026-06-25: `flutter analyze` passed after brand asset/dependency setup.
- 2026-06-25: `flutter analyze` passed after project audit, memory, architecture, API contract, and MVP roadmap docs were created.
- 2026-06-25: `flutter pub get` passed after architecture/core dependency setup.
- 2026-06-25: `dart format .` passed after architecture/core setup.
- 2026-06-25: `flutter analyze` passed after architecture/core setup.
- 2026-06-25: `flutter test` passed after architecture/core setup.
- 2026-06-25: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after design system and app shell setup.
- 2026-06-25: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Home vertical slice setup.
- 2026-06-25: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Services vertical slice setup.
- 2026-06-25: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Cup / Leaderboard vertical slice setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Seats vertical slice setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Profile + Packages vertical slice setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Search vertical slice setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Auth Lite vertical slice setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Chat + Notifications skeleton setup.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after MVP polish + QA. Full test suite passed with 140 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Mock-mode client walkthrough QA. Full test suite passed with 140 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Client demo visual fixes. Full test suite passed with 144 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: Prototype comparison audit was documentation-only. No Flutter validation commands were run because no Flutter files changed.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Service Detail + Contact MVP. Known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Home Top Offer / For You Detail MVP. Known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Seats / Influencer visual alignment. Full test suite passed with 169 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Profile Media + Management Preview MVP. Full test suite passed with 171 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-26: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Final Android Walkthrough + Client Demo Handoff. Full test suite passed with 171 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Prototype Section Alignment Patch. Full test suite passed with 171 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Final Section Accuracy QA Before Client Review. Full test suite passed with 171 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Realistic Mock Demo Data Polish. Full test suite passed with 174 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Final Pre-Client Patch Step 1 + Step 2. Full test suite passed with 177 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after Final Pre-Client Patch Step 3 + Step 4. Full test suite passed with 181 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-06-27: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true`, and `flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true` passed after Final Pre-Client Patch Step 5. Full test suite passed with 182 tests; known non-fatal SVG `<style/>` warnings remain.
- 2026-07-02: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true`, and `flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true` passed after Final Client APK QA. Full test suite passed with 188 tests; universal and split mock-mode APKs were generated successfully. Known non-fatal SVG `<style/>` warnings remain.
- 2026-07-02: `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, `flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true`, and `flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true` passed after Final Client Review Fix Patch. Full test suite passed with 192 tests; universal and split mock-mode APKs were generated successfully. Local final install on `M2012K11AG` was blocked by Android with `INSTALL_FAILED_USER_RESTRICTED`.
