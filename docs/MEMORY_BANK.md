# Promoo Mobile — Memory Bank

> Dynamic project memory for the **Flutter app** (`promo_mobile`). This is the
> single entry point an AI/engineer should read first. Mirrors the backend's
> `promo_backend/docs/MEMORY_BANK.md`. Update it after every meaningful change.
>
> Last updated: 2026-07-11

---

## 1. What this project is

Promoo is a premium **dark marketplace / social app** (black `#000000` + yellow
`#FFE604`) for companies, influencers, service providers, and users to discover
offers, book influencer "seats", promote via ads, and rank on a Cup leaderboard.
Currency is **AED**. Arabic/RTL-ready.

This repo is the **Flutter mobile app**. It is one of three sibling repos under
`E:\Personal Work Projects\`:

| Repo | What | Status |
| --- | --- | --- |
| `promo_backend` | Node/Express + Supabase REST API (108+ endpoints, `http://localhost:3000/api/v1`) | **DONE & locked** — single source of truth |
| `promo_dashboard` | React admin panel | DONE |
| `promo_mobile` | **This Flutter app** | In active development (frontend-first) |

**Golden rule:** the backend is the single source of truth. Do **not** design
frontend features/fields that don't exist in the backend unless strictly
necessary. Do **not** modify `promo_backend` or `promo_dashboard` from here.

---

## 2. Strategy (agreed with owner)

**Phase A — Frontend first (current):** build the ENTIRE frontend to match the
original MVP design (`promo_backend/Projects-Pictures/`) pixel-faithfully, on
**mock/local data**, with **NO backend wiring**.

**Phase B — Integration (later):** wire the finished frontend to the backend
(auth, follows, saved, offers/ads, uploads, categories…). Not started.

Deferred to v2 (never build in v1): OTP, phone/social login, forgot-password,
delete-account, ALL Stripe/payments, the whole Notifications feature (FCM/push),
reviews/ratings, likes/comments/share, Facebook login. See
[v2_deferred_scope.md](v2_deferred_scope.md).

---

## 3. Architecture

- **Flutter**, clean architecture, **feature-first vertical slices**
  (`lib/features/<feature>/{data,domain,presentation}`), ~165+ files.
- **Riverpod** (state) · **go_router** (routing) · typed DTOs · typed failures
  (`Result`/`AppFailure`). **No network layer** — the app is frontend-only
  (Dio + `core/network` were removed 2026-07-09; re-added feature-by-feature
  during integration per [integration_map.md](integration_map.md)).
- Every feature: UI + DTO/model + repository + controller + **fake data source
  only**. DTOs are kept (they define the wire shape for future integration).
- Shared design system in `lib/theme/` (colors, spacing, radius, typography) and
  `lib/shared/widgets/`. App shell + bottom nav in `lib/shell/`.
- **Fonts:** UI font **Tajawal** (bundled `.ttf`, applied globally via theme);
  logo font **Varela Round** (logo-only). Both under `assets/fonts/`.
- **Logo:** the NEW logo lives in `assets/brand/new_logo/` (`promoo_mark.png` =
  the "P", `promoo_wordmark.png` = "Promoo"), used everywhere via `PromooLogo`
  **except** the splash/intro which keeps its own animated treatment.

### Run / validate (Flutter SDK is at `C:\flutter_sdk\flutter\bin`, NOT on PATH)
```
$env:Path = "C:\flutter_sdk\flutter\bin;" + $env:Path   # PowerShell
flutter pub get ; dart format . ; flutter analyze ; flutter test
# Offline demo APK (mock data): flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true
```
Current health: **192 tests passing**, `flutter analyze` clean.

---

## 4. Screen / feature state (summary — details in build_plan.md)

Bottom nav order (matches MVP): **Home · Influencer · Services**(center P, elevated/overflowing)**· Cup · Profile**.

| Area | State |
| --- | --- |
| Splash/intro | ✅ animated letter-by-letter "Promoo" + corner glow → Login |
| Login / Register | ✅ MVP layout, big new logo, Apple+Google only (no Facebook), guest access |
| Home | ✅ header + Stories, Services (small cards), Top Offers (hero swiper), For You, Promoo of the Day; all with See All; story viewer with tap + vertical/horizontal swipe |
| Services | ✅ search box + image category grid + "No service found" |
| Influencer (Seats) | ✅ compact stats strip + search + Gold/Silver/Bronze legend + 2D-overflow seat grid (small cells), tap → book/influencer sheets |
| Cup (Leaderboard) | ✅ header + podium + ranked list |
| Profile (tab) | ✅ full settings page: Following, Profile Management, Add New Offer, Saved, MyPackages, Support, Language, **Theme Mode (Black/Light, functional)**, Logout, legal links |
| Profile sub-pages | ✅ Edit Profile, Add New Ad wizard (4 steps, maps `POST /ads`), Saved, MyPackages (display-only), Following, Support, About/Terms/Privacy |
| Public profile | ✅ header + Instagram-style stats (Followers/Likes/Posts/Views) + actions + packages + media |
| Chat / Notifications | ✅ skeletons (Chat is v1; Notifications deferred but demoable) |

### Shell chrome (important, recently reworked)
- **Header:** shared `PromooPageHeader` — full-width bar, **bottom border only**,
  logo + plain chat/bell icons with yellow badges, glass-on-scroll. On every
  in-shell page.
- **Footer:** full-width, edge-to-edge, **top border only**, glass-on-scroll,
  with the Services **P mark overflowing** above the bar (`extendBody: true`).
- Detail/search routes (`/search`, `/services/:id`, `/profiles/:id`,
  `/home/items/...`, `/seats/checkout`) are **top-level** (no bottom nav) and
  each provides its **own Scaffold**.

---

## 5. Change timeline (most recent first)

- **2026-07-13 — Fixed story viewer horizontal swipe gestures.** Inverted the swipe handler logic inside [HomeStoryViewer](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/home/presentation/widgets/home_story_viewer.dart) (`onHorizontalDragEnd`) to match the fixed LTR layout (swiping left transitions to the next group, and swiping right returns to the previous group). Added an automated widget test and ran full test verification (176 tests passing).
- **2026-07-11 — Localization phase STARTED (L0 done).** Roadmap:
  [localization_plan.md](localization_plan.md). **Backend is bilingual** via
  separate columns (`name_ar`/`name_en` on categories + subscription plans),
  resolved server-side by the `Accept-Language` header
  (`promo_backend/src/utils/helpers.ts`: `getLanguage` + `pickLocalized` →
  returns a single `name`/`description`); user content (offers/services/
  profiles/chat) is single-language as authored. So localization splits:
  **static UI + RTL = frontend, do now before wiring** (~90%); **content
  language = one `Accept-Language` header during wiring** (~10%). App was
  already RTL-ready (`intl`+`flutter_localizations` present, **zero**
  non-directional insets, Tajawal bundled). **L0 shipped:** `l10n.yaml`
  (gen-l10n → `lib/l10n/app_localizations.dart`), `pubspec flutter:
  generate: true`, `app_en.arb`+`app_ar.arb`, `lib/i18n/locale_controller.dart`
  (`localeProvider`, mirrors `themeModeProvider`, default = device locale,
  persists `promoo_locale`), wired `app.dart`, and **fully localized the
  Settings screen** + its language toggle. `test/i18n/localization_test.dart`
  proves ar→RTL. Test harnesses rendering localized screens now need
  `AppLocalizations.localizationsDelegates` + `supportedLocales`. Decisions:
  default = device locale (fallback en) · Western numerals · Arabic drafted by
  the assistant. **163 tests pass.** Next: L1 (shared widgets + header/footer —
  the shell `tabs` are `static const`, so labels must be resolved at build-time).
- **2026-07-10→11 — Client-edit + UX-audit fixes (frontend-only).** Client edits:
  footer center-P → Cup (labelled "Promoo"), Services became a normal tab;
  Promoo-of-the-Day "See All" navigates; header + tab-page headers frost on
  scroll via a shared `shellScrolledProvider` + `PromooPinnedHeaderDelegate`
  (content scrolls under a pinned header like Home; Seats keeps its fixed
  toolbar). UX audit then fixed: **header badges** now show live unread
  (chat `totalUnread` + notifications `unreadCount`, hidden at zero) instead of
  hard-coded "2"/"6"; **profile-shows-same-demo-everywhere** fixed
  (ProfileScreen overrides the controller in its ProviderScope so the scoped
  `profileTargetProvider` is read, + the profile fake **synthesizes** a
  deterministic profile for any unknown id); **profile actions** no longer
  dead-end (removed `ProfileActionStatus`/`ProfileActionNotice`; Follow = local
  toggle, Message → chat room, Edit → edit screen); **chat send was broken** and
  is fixed by making `chatRoomControllerProvider` a **family** keyed by roomId
  (a nested-ProviderScope override never reached the root controller → roomId
  was empty → messages never loaded & send silently bailed); public-profile
  **back button** added; Following reorder (above Support) + Instagram-style
  unfollow toggle + row→profile nav. Genuinely backend-only, NOT faked: OAuth,
  password reset, payments, media upload. See `docs/client_requirements_checklist.md`.
- **2026-07-09 (reset) — Wiped ALL backend wiring → pure frontend-only app.**
  Owner decision after the integration analysis: to start integration later on
  a clean base, feature by feature, **all API wiring was removed with no
  trace.** Deleted: `lib/core/network/*` (ApiClient, Dio, ApiResponse,
  ApiException, ApiEndpoints), all 9 `*_remote_data_source.dart`,
  `lib/core/config/app_environment.dart`, `dio` from pubspec, and the
  `useMocks`/`baseUrl`/`environment` fields from `AppConfig` (only
  `fallbackCurrency` remains). Every `*_repository_impl.dart` now serves its
  **fake data source only** (no remote/mock branching); the fakes throw
  `AppFailure` directly instead of the deleted `ApiException`. Deleted the 9
  `*_repository_impl_test.dart` + `api_response_test` + `app_config_test`
  (tested the removed plumbing); fixed 5 screen/routing tests that overrode
  `AppConfig(useMocks:…)`. **160 tests pass**, analyze + format clean. The
  app boots and runs entirely on local data — there is no network code left.
  The re-wiring guide lives in [integration_map.md](integration_map.md) (its
  endpoint inventory + field analysis stay valid; the "current wiring status"
  columns are now the *target* state, not the current one). Kept as local
  device storage (not API): `flutter_secure_storage` (theme persistence),
  `AuthSessionStore` (in-memory mock session).
- **2026-07-09 — Integration map + Add-Offer/Ad conflict fix + optional screens.**
  (a) Produced [integration_map.md](integration_map.md) — the authoritative
  Phase-B map (111 endpoints, section→API, ~89% field compatibility, backend
  gaps, wiring order), verified via sub-agents against the live backend
  contract + `Apis-Resaults` + the mobile DTO layer. Key finding: the app's
  RemoteDataSources are already written & wired (`PROMOO_USE_MOCKS` defaults
  false); real gaps are auth plumbing (no Dio Bearer interceptor, in-memory
  token store), the profile-owner flow (`updateMyProfile` stub), and a few
  unwired buttons — NOT "build the data layer". (b) **Fixed the Add Offer/Ad
  role conflict:** the single "Add New Offer" row that opened the Ad wizard is
  replaced by three separate, role-gated rows — Add New Offer
  (`add_offer_screen.dart`), Add New Ad (existing wizard), Add New Service
  (`add_service_screen.dart`) — driven by `accountCapabilitiesProvider`
  (mirrors backend `requireAccountType`: Offer=company/service_provider,
  Ad=company/influencer, Service=company/service_provider; guest/user=none).
  (c) Built **See-All** screen (`home_see_all_screen.dart`) + wired Home's
  Stories/Top-Offers/For-You "See All" to it (were "coming soon"). All
  frontend-only (no API calls — integration is a later, deliberate phase).
  **200 tests pass** (5 new role-gating tests), analyze clean, 3 new screens
  verified rendering live. Seats-144 issue deferred to v2 per owner.
- **2026-07-08 (follow-up 2) — Icon parity with the old app + logo/welcome fixes.**
  Pixel-audited every screenshot in `Projects-Pictures/` (Python/Pillow crops
  at 6x zoom) against current icon choices. Findings: the header's message
  icon in the old app is TWO overlapping speech bubbles (a "Chats" glyph),
  not a single bubble; the bell already matched well. Built
  `PromooChatIcon` (`lib/shared/widgets/promoo_chat_icon.dart`) — composes
  two of Flutter's own `chat_bubble_outline_rounded` glyphs (front bubble
  full, back bubble notched via `Path.combine(difference, ...)` where the
  front one overlaps) and wired it into `PromooPageHeader`'s Chats icon.
  **Removed `PromooLogoStamp` entirely** (the black rounded plate around
  the logo) per owner feedback — it read as a design mistake, not a fix.
  `PromooLogo.full` now just picks the right transparent-PNG colorway per
  theme brightness: `promoo_wordmark.png` (brand yellow) on dark,
  **new `promoo_wordmark_light.png`** (ink black + olive accent dots,
  cropped from the owner-supplied `Desktop/Promo's Logo/promoo4.v.png`) on
  light — no background box in either mode. **Added a light/dark toggle
  icon** (sun/moon) to `PromooPageHeader` (so Home + every in-shell page has
  it) and to `AuthScreenFrame` (Login/Register), wired to
  `themeModeProvider`. **Added a welcome card** to `ProfileMenuScreen`
  (`_WelcomeCard`): the signed-in user's own avatar (`AuthUser.avatarUrl`,
  falls back to a person icon for guests) in an accent-ringed circle, with
  "Hi {displayName} / Welcome to Promoo" — replaces the old app's version
  of this card, which used the brand logo instead of the user's photo (ref:
  `Projects-Pictures/profile page/photo_2026-06-25_01-59-36.jpg`).
  195/195 tests (4 new: logo asset-per-theme + fullCropped flag), analyze
  clean, verified live on web (both themes, Login/Register/Home/Profile).
- **2026-07-08 (follow-up) — Header/bottom nav/auth now genuinely theme-aware.**
  Owner feedback: the header, bottom nav, and Login/Register were still
  hard-locked dark (see (b)/(c) below) — that's now fixed, they follow the
  selected theme like every other screen. New widget
  `PromooLogoStamp` (`lib/shared/widgets/promoo_logo_stamp.dart`) solves the
  yellow-on-transparent logo's contrast problem: it wraps the logo in a
  black rounded "ink stamp" plate with a hairline yellow edge, but is a
  no-op on the dark theme (returns the logo directly, zero pixel change).
  Used in `PromooPageHeader` (small chip) and `AuthScreenFrame` (big plate
  around the hero logo on Login/Register). Added `AppThemeColors.light`
  values for `navBackground` (white, was hardcoded black in both themes)
  and made bottom-nav tab colors use `accent`/`textMuted` instead of raw
  `AppColors.brandYellow`/`AppColors.dark.textMuted`. Status bar icon
  brightness (`SystemUiOverlayStyle`) now follows `Theme.of(context).
  brightness` instead of being forced light everywhere. Removed the
  `Theme(data: AppTheme.dark)` wraps around the Login/Register routes in
  `app_router.dart`. Still deliberately dark-locked (immersive
  photo/video moments, not settings pages): the launch splash, the home
  story viewer, and the profile media viewer. Verified live on web:
  header/nav/Login/Register all switch cleanly both directions
  (Light↔Black) with no layout shift; 192/192 tests, analyze clean.
- **2026-07-08 — LIGHT THEME rebuilt + back-navigation overhaul + UX pass.**
  (a) **Theme tokens:** `AppColors` split into fixed brand constants
  (`brandBlack`/`brandYellow` + static dark fallbacks) and a
  `AppThemeColors` `ThemeExtension` with `.dark` (reference, unchanged) and
  `.light` palettes, accessed via `context.colors`. Light = **"ink on paper
  with a highlighter"**: warm paper `#F7F6F1`, white cards, ink `#141414`,
  and a new **`accent` token** (yellow-as-ink → brand yellow in dark, deep
  gold `#7A6900` AA-contrast in light). Yellow FILLS (buttons, badges,
  story rings, pills) stay brand yellow with black content in both modes.
  ~460 hardcoded dark color refs swept across ~70 files. Both `ThemeData`s
  now built from one `_build()` (full parity: cards, chips, inputs, sheets,
  dialogs, snackbars, progress).
  (b) **Chrome stays brand-black in BOTH modes** (header + bottom bar +
  center P): the yellow logo needs a dark field. Headers now paint under
  the status bar (`applyTopSafeArea`), shell forces light status icons.
  (c) **Dark-locked immersive surfaces:** splash, login/register (wrapped
  in `Theme(AppTheme.dark)` at the router), story viewer, profile media
  viewer. Photo-card scrims are constant dark with white text everywhere.
  (d) **Back navigation:** Services results layer (category/search) is now
  a real back step — `BackInterceptorRegistry`
  (`lib/routing/back_interceptors.dart`) consulted by the shell's PopScope
  before tab handling, plus a visible "← {category} / N services" results
  bar; details → list → categories → (non-Home tab → Home) → double-press
  exit. Stack-wiping `context.go` → `push` in service/home detail (chats,
  provider profile), chat list (notifications), login→register (register
  "Already have an account" pops). Auth frame back-fallback now exits the
  app instead of replaying the splash (loop fix).
  (e) **UX:** theme choice persisted via `flutter_secure_storage`
  (best-effort), themed exit toast, RefreshIndicators/accents/focus
  borders/disabled states tokenized, seat-tier ink colors readable on
  paper (gold→accent, bronze→bronze ink in light).
  Verified: `flutter analyze` clean, **192/192 tests**, live web run of
  both themes on all tabs + services flow + details + edit profile + chat.
- **2026-07-08 — Antigravity fixes + regression repair.** Owner made edits on the
  Antigravity IDE (merged/committed): (a) fixed a **back-gesture ANR / infinite
  loop** — `PopScope` in `promoo_shell.dart` now uses dynamic `context.canPop()`
  + `Future.microtask(SystemNavigator.pop)` + a centered "Press back again to
  exit" toast; `android:enableOnBackInvokedCallback="false"` in the manifest.
  (b) **Adaptive launcher icon** fixed (20% inset, black background). (c)
  **Instagram-style horizontal swipe** between story groups (RTL-aware) in
  `home_story_viewer.dart`. (d) Renamed the available-seat label to **"Book
  Seat"** and shrank cells. (e) Streamlined the Profile menu (removed the
  welcome card; "Following" is the first row). (f) **Router refactor:** moved
  `/search` + all detail routes OUT of the ShellRoute to top-level.
  → This refactor removed the shared Scaffold from search/profile/home-detail/
  service-detail; I fixed it by giving each its **own Scaffold** (Material was
  missing → TextField/buttons would crash). All tests green again.
- **2026-07-06 — Client feedback: shell chrome + polish.** Full-width header +
  footer with overflowing P; login big new logo; services declutter; influencer
  compact stats + smaller chairs; profile Black/Light theme toggle.
- **2026-07-06 — NEW LOGO everywhere + Influencer grid rebuilt + Profile pages.**
- **2026-07-06 — Tajawal applied globally; Facebook dropped; Register done.**
- **2026-07-06 — Phase A started: Login rebuilt to MVP.**
- **Earlier — planning docs created** ([build_plan.md](build_plan.md),
  [v2_deferred_scope.md](v2_deferred_scope.md)); prior sessions built the mock
  demo (all feature slices, 182+ tests).

---

## 6. Where everything is (doc map)

| File | Purpose |
| --- | --- |
| `MEMORY_BANK.md` (this) | Entry point: overview, state, timeline |
| [project_rules.md](project_rules.md) | Coding rules & conventions (also `../AGENTS.md`) |
| [REQUIREMENTS_STATUS.md](REQUIREMENTS_STATUS.md) | Screen-by-screen status (points to build_plan) |
| [build_plan.md](build_plan.md) | Master Phase A checklist + Phase B 15-row integration table |
| [v2_deferred_scope.md](v2_deferred_scope.md) | Everything deferred/hidden for v1 |
| [integration_map.md](integration_map.md) | **Phase B authoritative map**: 111 endpoints, section→API, field-level compatibility (~89%), backend gaps, wiring order. Verified vs live code + Apis-Resaults. Now the *re-wiring* guide (app was reset to frontend-only). |
| [localization_plan.md](localization_plan.md) | **Localization roadmap** (Arabic/English + RTL, before wiring): phased checklist, backend bilingual model, RTL readiness. L0 done. |
| [client_requirements_checklist.md](client_requirements_checklist.md) | Client-requested frontend edits, item-by-item with ✔ + locations. |
| [work_summary.md](work_summary.md) | Full chronological summary of this session's work (light-mode → theme/chrome → icons/logo → integration analysis → role-gating + screens → frontend-only reset). |
| [project_memory.md](project_memory.md) | Older detailed slice-by-slice notes |
| `mvp_roadmap.md`, `api_contracts.md`, `architecture.md` | Original planning/reference |
| `promo_backend/Projects-Pictures/` | **The pixel reference** (original MVP screenshots) |
| `promo_backend/docs/` | Backend truth: `MEMORY_BANK.md`, `REQUIREMENTS_STATUS.md`, `Apis-Resaults/`, Postman collection |

---

## 7. Known follow-ups / open items

- **Feedback #4 (RESOLVED 2026-07-10):** owner confirmed the center P mark
  should lead to Cup and be labelled "Promoo"; Services was moved to a normal
  tab. Footer order is now Home · Influencer · [P] Promoo→Cup · Services ·
  Profile (`promoo_shell.dart` + `_selectedIndexForPath`).
- **Light mode is DONE** (2026-07-08): full token system (`context.colors`),
  AA contrast, chrome stays brand-black, auth/splash/media viewers stay dark.
  New color rule: yellow is a FILL (black content on it); yellow-as-ink uses
  the `accent` token. Never hardcode `AppColors.<darkFallback>` in widgets.
- **Phase B not started:** no real backend calls yet; `flutter_secure_storage`
  present but unused; no Dio auth interceptor; base URL is `localhost` (won't
  reach a real device — configurable via `--dart-define PROMOO_BASE_URL` later).
- iOS App Store release needs a Mac + developer account (code is ready).
