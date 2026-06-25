# Promoo project memory

Last updated: 2026-06-25

## Current state

- Flutter app path: `promoo_app`.
- Backend path: `../promo_backend`, read-only from this Flutter repo.
- App has a Promoo root in `lib/main.dart` and `lib/app.dart`.
- Default Flutter counter scaffold has been removed.
- Current tests cover app root smoke, shell navigation, logo rendering, shared state widgets, AppConfig defaults, ApiResponse parsing, and Result behavior.
- Brand assets exist under `assets/brand/`.
- Brand assets are registered in `pubspec.yaml`.
- Brand note exists at `docs/design/brand_identity.md`.
- `flutter_svg` is installed for SVG logo rendering.
- Core architecture packages are installed: `flutter_riverpod`, `go_router`, and `dio`.
- Design system and placeholder app shell are implemented.
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
- `test/`: focused core and app root tests.
- `docs/design/brand_identity.md`: brand colors, typography direction, logo usage, SVG compatibility notes.
- `docs/design/design_system.md`: implemented design-system rules and component inventory.
- `../promo_backend/docs/promoo-api-reference.json`: read-only high-level API contract source.
- `../promo_backend/docs/Realtime-Chat-Flutter-Guide.md`: read-only chat realtime guidance.

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
- Packages are subscription plans.
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

Current phase: `2. Design system + app shell`.

Completed to date:

- Brand identity note exists.
- Brand assets registered.
- `flutter_svg` installed.
- Project audit and backend docs read-only inspection performed.
- Planning docs created.
- Core dependencies added: `flutter_riverpod`, `go_router`, `dio`.
- Minimal app root uses `ProviderScope` and `MaterialApp.router`.
- Core config supports `PROMOO_BASE_URL`, `PROMOO_ENV`, and `PROMOO_USE_MOCKS`.
- API foundation created with Dio wrapper, endpoint constants, flexible response parsing, and API exceptions.
- Typed failures and Result primitives created.
- Initial black/yellow theme tokens created from brand guidance.
- Design tokens expanded across colors, spacing, radius, typography, shadows, and Material component themes.
- Shared widgets added: scaffold, logo, button, card, text field, loading, empty, error, and section header.
- Placeholder app shell added with bottom navigation tabs for Home, Services, Cup, Seats, and Profile.
- Splash placeholder uses `assets/brand/promoo3.svg`; compact logo usage uses `assets/brand/promoo.svg`.

Next recommended action:

- Start `3. Home vertical slice`.
- Do not implement other vertical slices before their roadmap phase.

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
- `flutter_secure_storage`: deferred until auth lite or real token persistence is implemented; no token storage implementation exists yet.
- Supabase, Firebase, Stripe, image picker, and notification packages: not added.

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

## Validation history

- 2026-06-25: `flutter analyze` passed after brand asset/dependency setup.
- 2026-06-25: `flutter analyze` passed after project audit, memory, architecture, API contract, and MVP roadmap docs were created.
- 2026-06-25: `flutter pub get` passed after architecture/core dependency setup.
- 2026-06-25: `dart format .` passed after architecture/core setup.
- 2026-06-25: `flutter analyze` passed after architecture/core setup.
- 2026-06-25: `flutter test` passed after architecture/core setup.
- 2026-06-25: `flutter pub get`, `dart format .`, `flutter analyze`, and `flutter test` passed after design system and app shell setup.
