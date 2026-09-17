# Promoo Flutter MVP Codex rules

## Scope

- Work only inside `promoo_app` unless the user explicitly changes scope.
- Do not modify `../promo_backend`.
- `../promo_backend` may be read only for API contract planning.
- Do not build feature screens before the roadmap reaches the relevant vertical slice.
- Do not create the app shell before the design system and app shell phase.
- Do not implement API integration before the architecture and core setup phase.

## Product direction

- Brand black: `#000000`.
- Brand yellow: `#FFE604`.
- Logo font: Varela Round, logo only.
- Recommended app UI font: Tajawal.
- UI must support Arabic and English later.
- UI must support RTL and LTR later.
- Visual style: premium dark marketplace/social app with yellow accents.
- Brand assets live under `assets/brand/` and are registered in `pubspec.yaml`.
- Brand rules live in `docs/design/brand_identity.md`.

## MVP decisions

- Hide reviews and ratings in MVP.
- Hide likes and comments in MVP.
- Remove Facebook login from MVP.
- Services are listing/contact only; no service purchase flow.
- Packages are subscription plans.
- Hide `promo_code`, `terms`, and `best_price` if the API does not return them.
- Cup uses `GET /leaderboard`, not search.
- Development mock fallback is allowed only for local development and tests, not final production data.

## Architecture rules

- Use Vertical Slice MVP: UI + DTO/model + repository + Riverpod provider/controller + API or development mock fallback + loading/error/empty states per feature.
- Do not build all screens first and integrate backend later.
- Prefer feature-first clean architecture.
- Keep widgets free of networking, persistence, DTO parsing, payment SDK calls, analytics SDK calls, and platform SDK calls.
- Domain code must not import Flutter, Dio, storage, Firebase, Supabase, or widget packages.
- Repositories convert API/storage exceptions into typed failures.
- Riverpod providers wire dependencies; avoid global mutable service locators.
- Use centralized routing once `go_router` is added.
- Use centralized API response parsing once Dio is added.
- Keep mock data behind repository/data-source interfaces so it can be removed or disabled for production.

## Security rules

- Do not store API secrets in Flutter.
- Do not store Stripe secret keys, Firebase private keys, or Supabase service role keys in Flutter.
- Do not commit production tokens, signing material, service-account JSON, or private endpoints.
- Use `--dart-define` or generated environment configuration for non-secret base URLs and environment flags.
- Store auth tokens only through a secure token storage abstraction when auth is implemented.
- Redact tokens and personal data from logs, crash reports, and analytics.
- Payment and subscription work must call backend endpoints; Flutter must never call Stripe secret APIs directly.

## Dependency rules

- Do not add packages in planning-only steps.
- When adding a package later, document the purpose, license, data collection, platform impact, alternatives, owner, and review date.
- Planned architecture packages are Riverpod, go_router, Dio, typed DTO/model tooling, localization support, and secure token storage, but versions must be checked against the current Flutter SDK at the time of addition.

## Validation gates

- For planning/docs-only changes: run `flutter analyze`.
- Before feature delivery, run the strongest practical set:
  - `flutter pub get`
  - `dart format .`
  - `flutter analyze`
  - `flutter test`
- For generated DTO/model work, run the project codegen command once it exists.
- Every feature slice must include loading, empty, error, retry, offline, and unauthenticated states where relevant.
- Report skipped validation clearly with the reason.

