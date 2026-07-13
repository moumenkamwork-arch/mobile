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
3. **Frontend-only (current state).** As of 2026-07-09 the app has **no network
   layer at all** — `core/network`, Dio, and every `*_remote_data_source.dart`
   were removed. Repositories serve their **fake data source only**; there is
   no `PROMOO_USE_MOCKS` toggle anymore. Integration is re-introduced later,
   feature by feature, using [integration_map.md](integration_map.md) as the
   guide. **Do not re-add network code** (Dio/http/remote sources) except as a
   deliberate, scoped integration step for a specific feature.
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
- **Before writing a private `class _X` inside a screen file, check for an
  existing equivalent** in `lib/shared/widgets/` (app-wide: chips, headers,
  avatars, metric blocks, cards, empty/error/loading states) or the feature's
  own `presentation/widgets/` (feature-specific pieces). A whole-app dedup
  sweep (2026-07-13) found the exact same class of bug repeated 10+ times —
  a screen quietly reimplements something that already exists elsewhere,
  slightly worse (missing a state, an unlocalized string, or a light-mode
  color bug the original component already handles correctly). Shared
  building blocks: `PromooDetailHeader`, `PromooListHeader`,
  `PromooDetailChip`, `PromooMetric`, `PromooAvatarCircle`,
  `PromooInlineNotice`, plus the usual `PromooCard`/`PromooButton`/
  `PromooSectionHeader`/`PromooEmptyState`/`PromooErrorState`/
  `PromooLoadingIndicator`. If a screen only needs a small config difference
  from an existing widget (an extra param, an optional slot), extend the
  shared widget — don't fork it.

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
  - **If you hardcode a background/fill color, hardcode everything drawn on
    top of it too — never mix a fixed background with theme-following
    content color (or vice versa).** This exact mismatch caused two real
    bugs found 2026-07-13: a media tile drew text in the *default* (theme-
    following) color over a fixed dark scrim — invisible in light mode,
    since the default text color is dark ink there; and a social sign-in
    circle had a fixed dark background but a theme-following icon color —
    same failure, inverted. The fix is always: pick one policy for that
    widget (fully fixed, or fully `context.colors.*`) and apply it to both
    the surface and the content together.
- **The header, bottom nav, and Login/Register are theme-aware** (paper in
  light, black in dark) — this is deliberate as of 2026-07-08. The only
  brand-fixed-dark surfaces left are the launch splash and the two
  full-screen media viewers (story viewer, profile media viewer), wrapped
  in `Theme(data: AppTheme.dark)` because they're immersive photo/video
  moments, not settings-driven pages.
  - **Logo colorways, not boxes.** `PromooLogo.full` picks its asset by
    `Theme.of(context).brightness`: `promoo_wordmark.png` (brand yellow) on
    dark, `promoo_wordmark_light.png` (ink black + olive dots) on light.
    Never wrap the logo in a background plate/box — a prior "ink stamp"
    container was tried and reverted per owner feedback. The compact P
    mark (`promoo_mark.png`, bottom-nav center button only) stays the
    brand-yellow-on-black chip in both themes — that's a self-contained
    badge, not chrome needing a colorway swap.
  - **Icon parity with the old app:** before adding/changing an icon,
    check `Projects-Pictures/` — crop+zoom with Pillow if a screenshot
    icon is too small to read (see MEMORY_BANK 2026-07-08 follow-up 2).
    The header's "Chats" icon is two overlapping speech bubbles
    (`PromooChatIcon`, `lib/shared/widgets/promoo_chat_icon.dart`), not
    Material's single `chat_bubble_outline_rounded` — that single-bubble
    glyph is still correct for singular contexts (an input field's
    placeholder icon, a notification row's "you got a message" icon).
  - **Profile welcome card** (`ProfileMenuScreen._WelcomeCard`) shows the
    signed-in user's own avatar (`AuthUser.avatarUrl`, person-icon
    fallback for guests) — never the brand logo — next to "Hi {name} /
    Welcome to Promoo".
- Currency **AED** everywhere. Use `EdgeInsetsDirectional` (RTL-ready).
- Logo images come from `assets/brand/new_logo/` via `PromooLogo`.
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

## 3c. Localization (i18n) — complete (2026-07-13)

- **All user-facing strings come from ARB**, never hardcoded in widgets. Add a
  key to `lib/l10n/app_en.arb` + `app_ar.arb`, run `flutter gen-l10n` (output is
  `lib/l10n/app_localizations.dart`), then use
  `AppLocalizations.of(context).<key>`. Roadmap + phase status:
  [localization_plan.md](localization_plan.md).
- **⚠️ NO RTL — text-only translation, owner decision (2026-07-11).**
  Switching to Arabic translates strings but the **layout direction stays LTR
  in both languages**, no mirroring. `app.dart` forces this via a `builder`
  that wraps `MaterialApp.router` in `Directionality(textDirection:
  TextDirection.ltr)`, overriding Flutter's automatic RTL-from-locale
  behavior. Arabic glyphs still render correctly right-to-left at the text-run
  level (Unicode bidi is independent of widget layout direction) — only
  Row/Column ordering, start/end padding resolution, and alignment stay fixed
  LTR. **Do not remove this override or reintroduce RTL** without asking
  first. Any live-Arabic widget test must add the same `builder` (see any
  `*_l10n_test.dart`) or Flutter will default to RTL from the locale and the
  test will assert the wrong thing.
- **String-concatenation display text needs a grammar check, not just
  translation.** English composes phrases like `'${tierLabel} Seat'`; Arabic
  adjective+noun order is often reversed ("مقعد ذهبي", noun-first). Never
  translate by concatenating a translated word into an English sentence
  template — use ICU `select` (per-language full phrases, see
  `seatsLegendLabel`/`seatsSingularLabel` in `seats_screen.dart`) or ICU
  `plural` for count-based grammar (see `servicesResultsCount`).
- **Locale is a single source of truth:** `localeProvider`
  (`lib/i18n/locale_controller.dart`, mirrors `themeModeProvider`) — default =
  device locale, persists `promoo_locale`. The Settings language toggle drives
  it; the Phase-B network client will read it to set `Accept-Language`.
- Directional widgets (`EdgeInsetsDirectional`, `AlignmentDirectional`, etc.)
  are still used throughout and should stay that way — it's correct practice
  regardless of the no-RTL decision — but no RTL-specific mirroring work
  (flipping icons, swapping start/end) is needed since layout never flips.
- **Backend owns content language, not the app:** reference content (categories,
  subscription plans) is resolved server-side by `Accept-Language` (returns a
  single `name`/`description`); user content (offers/services/bios/chat) stays
  in the language it was authored in — do NOT translate it client-side.
  **Owner decision (2026-07-12):** this is permanent unless the client
  explicitly asks for bilingual user-content input later — that would need a
  backend schema change (new `_ar`/`_en` columns per field) and is v2 by
  definition; see `v2_deferred_scope.md` §9.
- **Test harnesses that render a localized screen** must pass
  `localizationsDelegates: AppLocalizations.localizationsDelegates` +
  `supportedLocales: AppLocalizations.supportedLocales` to their `MaterialApp`.

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
