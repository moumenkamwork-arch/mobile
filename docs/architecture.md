# Promoo Flutter architecture plan

Last updated: 2026-06-25

## Current project state

- The default Flutter counter scaffold has been removed.
- `lib/main.dart` initializes Riverpod `ProviderScope`.
- `lib/app.dart` defines the Promoo app root with `MaterialApp.router`.
- `lib/routing/` contains splash routes and shell routes for placeholder tabs.
- `lib/core/` contains app configuration, API foundation, typed failures, and Result primitives.
- `lib/theme/` contains brand color, spacing, radius, shadow, typography, and Material theme tokens.
- `lib/shared/widgets/` contains reusable Promoo UI primitives and state components.
- `lib/shell/` contains the placeholder splash and bottom-navigation app shell.
- No feature screens, feature folders, auth guard, DTO codegen, localization setup, or real API integration exists yet.
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
- Secure token storage abstraction when auth starts.
- Flutter `gen_l10n` and ARB files when localization setup starts.
- Mock/fake repositories for development and tests only.

Core setup implemented packages:

- `flutter_riverpod`
- `go_router`
- `dio`

Deferred packages:

- `google_fonts`; Tajawal remains recommended, but the current implementation uses system fallback because adding `google_fonts` failed on this Windows setup without Developer Mode symlink support.
- secure storage until auth lite implements real token persistence.
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
        dto/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        controllers/
        screens/
        widgets/
    services/
      data/
      domain/
      presentation/
    leaderboard/
      data/
      domain/
      presentation/
    seats/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
    subscriptions/
      data/
      domain/
      presentation/
    search/
      data/
      domain/
      presentation/
    auth/
      data/
      domain/
      presentation/
    chat/
      data/
      domain/
      presentation/
    notifications/
      data/
      domain/
      presentation/
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
- Default development base URL is `http://localhost:3000/api/v1`.
- Never store API secrets, Stripe secret keys, Firebase private keys, or Supabase service role keys in Flutter.
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
- Current placeholder routes only:
  - `/`
  - `/splash`
  - `/home`
  - `/services`
  - `/cup`
  - `/seats`
  - `/profile`
- A `ShellRoute` provides the placeholder bottom navigation for Home, Services, Cup, Seats, and Profile.
- The shell is structural only; feature vertical slices are not implemented.
- Guard authenticated routes after auth lite exists.
- Validate route parameters at boundaries.

## Design-system integration

- Keep brand tokens from `docs/design/brand_identity.md` as the source for theme implementation.
- Use black surfaces and yellow accents.
- Use directional padding/alignment to support RTL later.
- Do not force Varela Round for Arabic UI text.
- Tajawal remains the target UI font; current theme uses system fallback.
- Add Tajawal through bundled font assets or `google_fonts` only when the local build environment supports the dependency.
- Reusable state components exist for loading, empty, error, and retry-ready UI.

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
