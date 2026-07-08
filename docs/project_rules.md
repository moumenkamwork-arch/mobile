# Promoo Mobile — Project Rules & Conventions

> Rules every contributor and AI assistant must follow for `promo_mobile`.
> Mirrors `promo_backend/docs/project_rules.md`. The authoritative long-form
> rules also live in [`../AGENTS.md`](../AGENTS.md); read both.

---

## 1. Golden rules

1. **Backend is the single source of truth.** Never invent frontend
   features/fields that don't exist in the backend unless strictly necessary.
   Check `promo_backend` validators/routes before adding any form field.
2. **Do not modify** `promo_backend` or `promo_dashboard` from here. They may be
   read for contract planning only.
3. **Frontend-first (Phase A):** build UI on mock data; do NOT wire the backend
   yet. Mock/real is toggled by `PROMOO_USE_MOCKS`.
4. **Match the MVP** in `promo_backend/Projects-Pictures/` pixel-faithfully — no
   less, no more. Nothing missing, nothing extra.
5. **Respect the deferred list** in [v2_deferred_scope.md](v2_deferred_scope.md).

## 2. Architecture rules

- Feature-first clean architecture; vertical slices under
  `lib/features/<f>/{data,domain,presentation}`.
- Domain code must not import Flutter/Dio/storage/Supabase/Firebase.
- Widgets contain no networking, persistence, DTO parsing, or SDK calls.
- Repositories convert exceptions into typed `AppFailure`; return `Result<T>`.
- Riverpod providers wire dependencies; centralized routing via `go_router`.
- Keep mock data behind data-source/repository interfaces (never in widgets).
- **Every top-level (non-shell) route screen must provide its own `Scaffold`**
  (search + all detail pages are top-level now — they need Material).

## 3. Design system

- Brand black `#000000`, brand yellow `#FFE604`. Premium dark look (dark =
  reference); light = "ink on paper with a highlighter".
- UI font **Tajawal** (global, via theme). Logo font **Varela Round** (logo
  only). Use `AppSpacing`, `AppRadius`, `AppTypography` — no magic numbers.
- **Colors are theme tokens:** use `context.colors.<token>`
  (`AppThemeColors` extension) in widgets — NEVER the static dark fallbacks
  on `AppColors` (those exist only for brand-fixed spots and legacy).
  - Yellow as a **fill** (buttons, badges, rings, selected pills): keep
    `colors.primaryYellow` / `AppColors.brandYellow` with BLACK content.
  - Yellow as **ink** (icons, links, prices, selected labels, focus):
    use `colors.accent` (yellow in dark, deep gold `#7A6900` in light).
  - Photo scrims + text over photos: constant dark scrim
    (`AppColors.brandBlack` alphas) + `AppColors.dark.textPrimary` text.
  - Avatar wells: `AppColors.brandBlack` + brand-yellow ring in both modes.
- **Brand-fixed surfaces:** shell chrome (header/footer/P), splash,
  login/register, story viewer, profile media viewer are ALWAYS the dark
  treatment (wrap in `Theme(data: AppTheme.dark)` where needed).
- Currency **AED** everywhere. Use `EdgeInsetsDirectional` (RTL-ready).
- Logo images come from `assets/brand/new_logo/` via `PromooLogo` (splash keeps
  its own treatment).
- Shared chrome: `PromooPageHeader` (full-width, bottom border, glass,
  `applyTopSafeArea: true` on tab screens — it paints under the status bar)
  and the shell footer (full-width, top border, overflowing P). Reuse them.

## 3b. Navigation rules

- **Back must unwind one step at a time.** Detail routes are pushed
  (`context.push`), never `context.go` (go wipes the stack). `context.go`
  is only for: tab switches, auth-flow resets (login/logout), and
  deep-link fallbacks behind `context.canPop()`.
- Screen-internal layers that look like navigation (e.g. Services results
  over the category grid) must register a `BackInterceptor`
  (`lib/routing/back_interceptors.dart`) so system back unwinds them
  first, AND show an in-app back affordance.
- Shell back order: interceptors → non-Home tab → Home → double-press exit.

## 4. Security

- No secrets in the app. `flutter_secure_storage` for tokens when auth is wired.
- Payments must go through the backend; never call Stripe secret APIs from
  Flutter (and payments are v2 anyway).

## 5. Validation gates (before saying "done")

Run with the SDK at `C:\flutter_sdk\flutter\bin` (not on PATH):
```
flutter pub get ; dart format . ; flutter analyze ; flutter test
```
All must pass. Keep the docs in [MEMORY_BANK.md](MEMORY_BANK.md) /
[build_plan.md](build_plan.md) updated after meaningful changes.
