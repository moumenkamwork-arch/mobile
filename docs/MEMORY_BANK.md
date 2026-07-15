# Promoo Mobile — Memory Bank

> Dynamic project memory for the **Flutter app** (`promo_mobile`). This is the
> single entry point an AI/engineer should read first. Mirrors the backend's
> `promo_backend/docs/MEMORY_BANK.md`. Update it after every meaningful change.
>
> Last updated: 2026-07-15 (Auth v1 finalized: email confirmation + forgot/reset password fully disabled — register + login only, see §5 entry)

---

## 1. What this project is

Promoo is a premium **dark marketplace / social app** (black `#000000` + yellow
`#FFE604`) for companies, influencers, service providers, and users to discover
offers, book influencer "seats", promote via ads, and rank on a Cup leaderboard.
Currency is **AED**. **Bilingual Arabic/English — layout always stays LTR**, text
translates only (see §5 2026-07-11 correction and `docs/localization_plan.md`).

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
Current health: **176 tests passing**, `flutter analyze` clean.

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

- **2026-07-15 — Auth v1 finalized as register+login only; email confirmation and
  forgot/reset password fully disabled (not "coming soon" — removed).** While trying
  to create an influencer test account (to test the role-gated Seats tab from
  Phase 6), discovered Supabase's built-in auth-email sender is unreliable on this
  project: confirmation emails never arrived, even after calling Supabase's official
  `resend()` API (added as `POST /auth/resend-confirmation`, verified 200 OK but no
  email ever landed in the inbox — checked directly). Root-caused a **second, separate**
  bug along the way: registering with an email that already has an unconfirmed
  Supabase Auth user (from earlier Phase 2 testing weeks prior) silently no-ops
  (`identities: []` in the response — Supabase's anti-enumeration behavior) instead of
  erroring or resending, which is why repeated registration attempts on the same stuck
  email never worked. Deleted that stuck auth user via a one-off script
  (`promo_backend/scripts/delete-test-auth-user.ts`, looks up by email via
  `admin.auth.admin.listUsers` + `deleteUser` — kept in `scripts/` as a reusable dev
  tool) to unblock testing, but the underlying "email delivery isn't reliable in dev"
  problem remained. Owner's decision: **for v1, drop the whole email-confirmation
  dependency** rather than depend on infrastructure (Custom SMTP) that isn't set up —
  v1 auth is register + login, full stop.
  **What was built then fully reverted same day:** a `PATCH`-style detection in
  `loginWithEmail` for "right password, unconfirmed account" (backend `ErrorCode.
  EMAIL_NOT_CONFIRMED` + `ApiError.emailNotConfirmed`), a `resendConfirmationEmail`
  path through the whole stack (repository → data source → controller → a "Resend
  confirmation email" button on Login), and `AuthState.unconfirmedEmail`. All removed
  once the decision was made — kept half-wired dead code would have been worse than
  either finishing it or reverting it, and the decision made finishing it pointless.
  **What's actually disabled now:**
  - Backend: `/auth/forgot-password`, `/auth/reset-password`, `/auth/resend-
    confirmation` routes commented out in `auth.routes.ts` (methods/controllers/
    validators kept, dormant — same treatment as other v2-deferred backend code, see
    `v1_interim_admin_curation.md` philosophy). `loginWithEmail` back to plain
    unauthorized-on-error, no special-casing.
  - Mobile: the "forget password?" link is **removed** from `login_screen.dart`
    entirely (was previously a "coming soon" placeholder — now gone, along with the
    now-unused `_showComingSoon` helper and `authForgetPassword` l10n key). No resend
    button, no unconfirmed-email banner logic.
  - **Still relies on the owner to flip "Confirm email" OFF in Supabase's dashboard**
    (Authentication → Providers → Email) — that's the actual mechanism that makes
    `register` always return a session immediately; not something touchable via code
    (security/account setting, outside what Claude will change directly).
  Updated `v2_deferred_scope.md` §1 with a note marking this "confirmed final for v1,"
  not just deferred, plus what v2 needs to bring it back (Custom SMTP + re-enable
  routes + re-enable Confirm Email + rebuild the forgot-password UI).
- **2026-07-15 — Seats/Influencer tab visibility fix for Companies.** The `Seats` tab is now visible to both `influencer` and `company` accounts in the bottom navigation shell (`promoo_shell.dart`). However, when a Company taps an available seat, they are prevented from booking it (they see a snackbar: "This seat is available for influencers to book") since companies buy ads, not seats. This aligns the frontend logic with the backend's commercial design. Also synced all documentation files across both repos per owner's process request.
- **2026-07-14 — v1 interim curation fully live-verified end-to-end (both toggles); real
  bug found + fixed in the featured-profile path.** Seeded 2 demo offers directly in
  Supabase (owner pre-authorized) attached to the owner's own profile. Via the dashboard
  preview (`localhost:5174`, owner's own authenticated session) and the mobile web preview
  (`localhost:8765`): (1) clicked **Content → Offers → Feature** on "Launch Week Web Design
  Special" → `PATCH /admin/content/offers/:id/feature` → reloaded mobile Home → offer
  appeared as both the Top Offers hero card AND Promoo of the Day, confirming the Option-A
  single-flag design works live. (2) Clicked **Users → Feature on home** on the owner's own
  profile → dashboard badge never appeared and `GET /admin/users` kept returning
  `is_featured: false` despite a 200 response. **Root cause:** `setProfileFeaturedHome` relied
  entirely on the `on_featured_account_change` DB trigger
  (`009_create_payments_and_featured.sql`), which only flips `profiles.is_featured` when
  `now() between start_date and end_date` at write time — this silently no-opped in practice.
  **Fix:** `admin/user.service.ts:setProfileFeaturedHome` now sets `profiles.is_featured`
  directly in the same call (admin overrides don't need to wait on a payment window); the
  `featured_accounts` insert/deactivate is kept for record-keeping, and the DB trigger is left
  untouched for the real v2 Stripe webhook path. Re-verified after the fix: dashboard showed
  the gold "Featured" badge, and `GET /home`'s `featured_profiles` array contained the
  profile. Backend `type-check` clean. Full detail + rationale in
  `v1_interim_admin_curation.md`.
- **2026-07-14 — Seats/Influencer tab is now influencer-only; non-influencers get an
  Offers tab (role-gated bottom nav).** Client request: the Influencer/Seats screen must not
  show to anyone except influencers. Implemented as a **role-dependent bottom-nav slot 1**
  (`promoo_shell.dart` `tabsFor({isInfluencer})`, driven by
  `authControllerProvider.session?.user.accountType == influencer`): influencers see
  Influencer/Seats (route `/seats`), everyone else (companies, providers, users, guests) see
  a new **Offers** tab (route `/offers`, `offers_screen.dart`) in that same slot — same index
  (1), so `_selectedIndexForPath` maps both `/seats` and `/offers` → 1. New `OffersScreen` is
  a full-screen browsable offers list sourced from the same `homeControllerProvider` feed that
  powers Home's Top Offers/For You (owner chose "Offers" over "Saved" for the replacement).
  Added `tabOffers` l10n key. Fixed 2 shell tests (`promoo_shell_test`/`_l10n_test` expected
  the "Influencer" tab; a guest now sees "Offers") + added an `/offers` smoke case.
  **Live-verified:** as a guest the bottom nav shows Home·Offers·Promoo·Services·Profile, the
  Offers tab opens and shows the correct empty state (DB has 0 offers). 182 tests pass,
  analyze clean.
- **2026-07-14 — v1 interim curation: featured-profiles toggle added (2nd stand-in).**
  Backend `PATCH /admin/users/:id/feature-home` `{is_featured}`
  (`admin/user.service.ts:setProfileFeaturedHome`) inserts/deactivates a `featured_accounts`
  row (placement=home, ~100-year window, `amount_paid=0`) — the same row Stripe's `POST
  /featured` webhook creates in v2; a DB trigger keeps `profiles.is_featured` in sync. Drives
  the mobile Home "Featured profiles" row (zero mobile change). Dashboard `Users.tsx` got a
  "Feature on home / Remove" dropdown item + a "Featured" status badge + i18n. Backend
  `type-check` + dashboard `tsc` both clean; backend boots clean. Documented as §1 of
  `v1_interim_admin_curation.md`. (Later live-verified — see the entry above this one; the
  trigger-reliance described here was found to be buggy and replaced with a direct set.)
- **2026-07-14 — v1 interim admin curation started: manual "feature offer" toggle
  (Promoo of the Day + Top Offers).** Owner decision: the Stripe-gated "paid visibility"
  features (which are deferred to v2) get a **manual dashboard stand-in** in v1 — the admin
  flips the same flag Stripe would flip. New doc `docs/v1_interim_admin_curation.md` (the
  mirror-image companion of `v2_deferred_scope.md`: "what we run by hand" vs "what we hide").
  **Implemented (offer featuring):** backend `PATCH /admin/content/offers/:id/feature`
  `{is_featured}` (`admin/content.service.ts:setOfferFeatured` + controller + validator +
  route) sets `offers.is_featured` directly (admin, no Stripe/ownership). Dashboard
  `Content.tsx` Offers tab got a "Feature / Remove from featured" dropdown item (star icon) +
  a star indicator on featured rows + i18n keys. **Owner chose "Option A — coupled":** one
  `is_featured` flag drives BOTH surfaces (offers sorted `is_featured DESC` → featured floats
  into Top Offers; newest featured = Promoo of the Day), zero schema change. Independent
  curation would be a 1-column migration (`is_top_offer`) — deliberately not done. **Mobile
  side: zero changes** — `HomeContentDto` already reads these flags (proven in Phase 4 when
  the ad appeared as Promoo of the Day via the same path). Verified: backend `type-check`
  clean + boots clean with route registered; dashboard `tsc --noEmit` clean. (Live-verified
  end-to-end in a later pass the same day — see the top entry in this timeline. All three
  "still open" items noted here at the time — featured-profiles toggle, Seats role-gating —
  are also done; see later entries.)
- **2026-07-14 — Phase 5 (Services + Categories + Search + Leaderboard) done —
  live-verified against the real backend.** Four new remote data sources
  (`services_remote_data_source.dart`, `search_remote_data_source.dart`,
  `leaderboard_remote_data_source.dart`, plus `GET /categories` via the services one),
  each matching the pre-strip pattern restored from git history exactly. Fixed 4 tests
  that started hitting the real backend by default (`home_screen_test.dart`'s service-card
  navigation, `leaderboard_screen_test.dart`'s own screen load, and two
  `app_routes_smoke_test.dart` cases) — same override pattern as every prior phase.
  **Live-verified:** `GET /categories` and `GET /services` both returned real (empty)
  data from the DB; `GET /leaderboard` returned real ranked profiles — rank 3 was the
  owner's own account with the exact bio saved during Phase 3's live test
  ("Building Promoo integrations, one phase at a time."), which incidentally also
  reconfirmed Phase 3's save is genuinely durable across sessions. Search compiles
  clean and follows the identical proven pattern as the other three, but a live
  network trace wasn't captured this round — the in-app browser's semantics/screenshot
  layer got flaky partway through this session (unrelated to the app; a hash-only
  route change without a full reload silently failed to remount a tab once, and
  screenshots intermittently timed out afterward — full page reloads recovered every
  time). 181 tests pass, analyze clean. Next: Phase 6 (Seats — GET /seats live check)
  or Phase 7+ depending on priority.
- **2026-07-14 — Seats grid now pans in both directions** — owner reported the influencer
  seat grid only scrolled one axis per drag (nested `SingleChildScrollView`s, vertical
  outer + horizontal inner: Flutter's gesture arbitration locks a drag to one scrollable's
  axis, so diagonal panning never worked smoothly). Replaced both with a single
  `InteractiveViewer` (`constrained: false`, `scaleEnabled: false` — pan only, no
  pinch-zoom, since that's what was asked). One gesture recognizer now, so a single
  diagonal drag moves the grid on both axes at once — verified live via a diagonal
  drag screenshot A/B. Tap-to-open-sheet still works (no regression). 181 tests pass.
- **2026-07-14 — Phase 4 (Home) done — live-verified against the real backend.**
  `home_remote_data_source.dart` (new) wires `GET /home` for the feed and
  `GET /offers/:id` / `GET /ads/active` (filtered client-side) for detail — same
  pattern as the pre-strip version restored from git history. `home_repository_impl.dart`
  now defaults to it. Fixed 3 tests that started hitting the real backend by default
  (`promoo_shell_l10n_test.dart` had zero overrides at all; `app_routes_smoke_test.dart`
  and `auth_screen_test.dart`'s guest-to-Home case were each missing a
  `homeRepositoryProvider` override) — same fake-repository-override pattern as the
  Phase 1/3 fixes. **Live-verified with real (sparse) DB data:** categories resolved in
  English via the Phase-0 `pickLocalized` fix (cross-validates two separate fixes
  working together), `latest_offers`/`services` correctly rendered as empty (nothing in
  the DB right now, not a bug), `promoo_of_the_day` was `null` so the feed correctly fell
  back to the first ad ("Updated Banner Ad", badge "Promoted") for the highlight card,
  and tapping into its detail screen correctly hit `GET /ads/active` and rendered real
  data. 181 tests pass, analyze clean. Next: Phase 5 (Services + Categories).
- **2026-07-13 — Phases 2 (Auth) + 3 (Profile me/edit) done — live-verified against the
  real backend + real Supabase, analyze + 181 tests green.** Owner registered/logged in
  with their real account through the live app; used that real session to verify both
  phases end-to-end (not just analyze/test).
  **Phase 2 — Auth:** `api_endpoints.dart` restored (endpoint constants; auth paths
  spot-checked against `promo_backend/src/routes/auth.routes.ts`).
  `auth_remote_data_source.dart` (new) implements login/register/refresh/logout via the
  Phase-1 `ApiClient`; `auth_repository_impl.dart` now defaults to it instead of the fake.
  Live-verified: a real register call reached the real backend (network log + backend log
  both confirmed), CORS worked, and a deliberately-invalid test email came back as a
  correctly-shaped `{success:false,...VALIDATION_ERROR}` that rendered as the UI's error
  banner — proving the whole chain (client → interceptor → envelope parse → AppFailure →
  UI) end-to-end. Real success case left for the owner to finish with a real email
  (entering credentials is something I don't do myself, even given/authorized).
  **Phase 3 — Profile (me + edit):** added `ApiClient.put`; `ProfileDataSource` gained
  `updateMyProfile`; new `profile_remote_data_source.dart` (`fetchProfilePackages`
  honestly returns empty — no real backend concept, see `v2_deferred_scope.md` §2).
  `profile_repository_impl.dart`'s `dataSource` field is now the interface type (was
  hard-typed to the fake); `getDemoProfile()` — kept as a name for interface/test
  stability (6 test files override it) — now just means "the signed-in user's own
  profile," same as `getMyProfile()`; `updateMyProfile()`'s hard stub (always failed, no
  request) now really calls through. **Edit Profile's Save button had never been wired at
  all** — it only showed a "coming soon" snackbar; wired it for real (Name/Bio/Location →
  `PUT /profiles/me`, success/failure snackbar, refetches on save). Small backend
  consistency fix: `updateProfile()` now also returns `withCounts()` (the PUT response was
  missing `following_count`/`posts_count` that GET already had). Live-verified with the
  owner's real account: Edit Profile loaded their real name/0 followers/empty fields (not
  the old Saffron Social demo fixture), a real bio+location save round-tripped
  (`PUT /profiles/me` → 200, counters included), and a fresh page load afterwards showed
  the saved values — confirms real persistence, not just optimistic UI. Fixed 3 widget
  tests that now hit the real profile repository by default (`app_routes_smoke_test.dart`,
  `promoo_shell_test.dart`, `leaderboard_screen_test.dart`) with a fake-repository
  override, same pattern as Phase 1's session-store fix. Also: added `run_backend.bat` +
  a `promoo-backend` entry in the root `.claude/launch.json` (one-command local backend
  boot alongside the existing `promoo-web`), added the Flutter web dev port to the
  backend's `CORS_ORIGINS`, and dropped the now-inert `PROMOO_USE_MOCKS` define from
  `run_web.bat`. Next: Phase 4 (Home).
- **2026-07-13 — Phase 1 (mobile network plumbing) done — analyze + 181 tests green.**
  Rebuilt `lib/core/network/` from scratch (git history of the pre-strip version was read
  first to stay consistent with the original design): `api_response.dart` (envelope parse,
  restored verbatim) + `api_client.dart` (Dio wrapper). Two deliberate upgrades over the old
  pre-strip architecture, not a 1:1 restore: (1) the network layer now throws `AppFailure`
  directly instead of a separate `ApiException` type — collapses a redundant dual-type/mapper
  split, and means every existing repository's `on AppFailure catch` clause already works
  unchanged once a feature's remote data source lands, no repo edits needed per phase; (2) a
  new `QueuedInterceptorsWrapper` injects `Authorization: Bearer` (from `AuthSessionStore`) +
  `Accept-Language` (from `localeProvider`) on every request, and auto-refreshes on 401 via a
  bare second-`Dio` call to `/auth/refresh` (queued so concurrent 401s don't each fire their
  own refresh). Re-added `dio: ^5.9.2` (pubspec) and `baseUrl`/`normalizedBaseUrl` to
  `AppConfig` (`PROMOO_BASE_URL`, default `http://localhost:3000/api/v1`) — deliberately
  dropped the old `environment`/`useMocks` fields since wiring now happens feature-by-feature,
  not behind one global mock flag. Implemented `SecureAuthSessionStore` in
  `auth_session_store.dart` (JSON round-trip via `flutter_secure_storage`, best-effort
  try/catch mirroring `LocaleController`). **Regression found + fixed:** `SecureAuthSessionStore`
  as the default `authSessionStoreProvider` broke 4 widget tests (chat/notifications routes +
  one auth-screen test) — its real platform-channel `read()` never resolves inside
  `testWidgets` (no device backing it), and unlike `LocaleController` (which fires its read
  with `unawaited` and never blocks on it), the chat/notifications repositories correctly
  `await` the session read before every call, so those specific screens hung on
  `pumpAndSettle`. Fix: kept `InMemoryAuthSessionStore` as an explicit, documented test double
  (was about to delete it as dead code — it isn't, it just needed a new job) and overrode
  `authSessionStoreProvider` with it in the two affected test files, the standard Riverpod
  pattern for this exact class of plugin. Next: Phase 2 (Auth wiring — first real
  `*_remote_data_source.dart`, first live exercise of the refresh flow against the real
  backend).
- **2026-07-13 — Phase B STARTED: Phase 0 (compatibility hardening) done + verified
  against the live DB.** Approved wiring plan: reach 100% front↔back↔DB compat for the
  v1 slice, then wire feature-by-feature (~12 phases). Owner **authorized backend edits**
  for this work (golden rule overridden) and chose to close gaps at the source. Done:
  **F0.1** (mobile) — `HomeOfferPreviewDto` now falls back to `media_urls[0]` (was rendering
  the placeholder even when the backend sent an image); analyze + 176 tests green.
  **Backend (`promo_backend`, all `tsc --noEmit` clean):** **B0.1** migration
  `035_seed_seat_grid.sql` seeds the full 144-seat grid (16 gold / 48 silver / 80 bronze —
  matching the app's fixed 12×12 client-required grid; the "correct" dynamic seat logic stays
  v2), + kept `seed.sql` in sync; **B0.2** `saved.service.ts` now groups saved rows by type and
  returns enriched item details (no more id-only); **B0.3** `profile.service.ts` computes
  `following_count`+`posts_count` (COUNT on follows/media) — `views_count` **deferred to v2**
  (no source table); **B0.4** wired `pickLocalized` (it was defined but **never called** — so
  reference content always returned English regardless of `Accept-Language`) into
  `category.service` + `home.service`, resolving a single `name` per language. **Verified live
  against the remote Supabase** (owner-authorized write): seats = 16/48/80, categories resolve
  ar↔en, profile response carries the new counters. B0.2 gets its full live test with an
  authenticated user in Phase 11. **Owner still to do:** enable Leaked Password Protection
  (Supabase dashboard toggle). Note: the seat-grid seed took migration `035`, so the deferred
  RLS-perf pass is now `036`. Backend targets a **remote cloud Supabase** (no local setup) — a
  gotcha for anyone verifying: there's no `supabase start`; apply migrations via `db push` or
  the SQL editor. Next: Phase 1 (mobile plumbing — rebuild the network layer + Bearer/
  Accept-Language interceptor + secure token store).
- **2026-07-13 — Regenerated the Phase-B integration map against current state.**
  Owner is about to start backend wiring and wanted the plan re-verified since the
  frontend + DB changed. Re-read the current mobile data layer directly (DTOs,
  `app_config`, `auth_session_store`, `locale_controller`, `profile` repo/datasource,
  pubspec) and cross-checked the backend (migrations stop at `034`, no `035` — DB
  state = the 2026-07-12 note). Findings folded into
  [integration_map.md](integration_map.md): (1) **field-compatibility %s are
  unchanged (~89%)** — the DTOs were never touched by the localization/dedup work,
  only presentation/domain layers were; (2) added the **`Accept-Language`
  integration axis** (new since the map — `localeProvider` is the single source, the
  Phase-B interceptor must inject it alongside the Bearer token; reference content
  resolves server-side, user content stays single-language, bilingual input = v2);
  (3) reframed every "wiring status" as target-after-wiring since the remote layer
  is fully deleted (app is cleanly frontend-only; the old §0 "app is secretly wired"
  discovery is now historical); (4) recorded the deltas — Follow is now a working
  local toggle (not a dead-end), `flutter_secure_storage` is now used (theme+locale,
  so token storage is lower-risk), `dio`/`PROMOO_USE_MOCKS`/base-URL removed,
  `updateMyProfile` confirmed still a hard stub. No code changed — docs only.
- **2026-07-13 — Localization plan COMPLETE + full component-deduplication sweep
  (Profile, Chat, Notifications, Lx, then whole-app consistency pass).**
  (a) **Finished the localization roadmap:** Profile (all sub-pages: Edit,
  Following, My Packages, Saved, Support, Static Info, plus the Add
  Offer/Ad/Service wizards done together since they share fields), Chat, and
  Notifications — each with its own `*_l10n_test.dart` proving Arabic renders
  with layout still forced LTR. Fixed a real grammar bug while at it: the
  notifications unread count was always "N unread notifications" even for
  N=1 (now real ICU plural). Closed the **Lx** phase as "nothing to do"
  rather than busywork: numbers/currency were already decided to stay
  Western/AED, and the only timestamp in the app (chat's `HH:mm`) has no
  month/day names so it's language-invariant — wiring `intl.DateFormat`
  there would be pure churn with zero visible difference.
  [localization_plan.md](localization_plan.md) is now fully ✅.
  **Owner decision recorded:** user-generated content (offer/service titles,
  bios, chat) stays single-language as authored, no dual-language input —
  matches Instagram/Etsy/Airbnb; if the client later wants bilingual user
  content, that's v2 (needs backend schema changes to add `_ar`/`_en`
  columns per field, mirroring the reference-content pattern — see
  `v2_deferred_scope.md` §9).
  (b) **Owner-reported bug: Edit Profile's own media grid didn't match the
  public profile's media grid** (no likes/comments/share, no tap-to-view) —
  root cause was `edit_profile_screen.dart` defining its own separate,
  poorer `_MediaTile` instead of reusing `ProfileMediaSection`. Fixed by
  deleting the duplicate and reusing the shared component directly — this
  **also fixed a light-mode bug for free**: the old tile drew its "Post N"
  text with the theme's default (unstyled) color over a `Colors.black87`
  photo scrim, which is readable in dark mode (default text is light) but
  went invisible in light mode (default text is dark ink on a dark scrim).
  `ProfileMediaSection`'s tile already forces light text over the scrim
  correctly in both themes.
  (c) **Whole-app deduplication sweep** (owner asked for a full pass, not
  just the one bug): ran systematic Explore-agent audits across the entire
  `lib/` tree — one for hardcoded/theme-invariant colors, one (then a
  second, broader pass covering `presentation/widgets/*.dart` too) for
  duplicated UI components — then fixed every actionable finding. New
  shared widgets in `lib/shared/widgets/`: `PromooDetailHeader` (back+title
  row, replacing 4 copy-pasted versions across `profile_screen.dart`,
  `home_content_detail_screen.dart`, `service_detail_screen.dart`,
  `chat_room_screen.dart`), `PromooDetailChip` (pill label with an optional
  `highlighted` fill state — fixed a real inconsistency where Services'
  copy of this chip was missing the highlighted variant Home's had),
  `PromooMetric` (icon+label+value block), `PromooAvatarCircle` (circular
  avatar w/ fallback, now optionally bordered, replacing hand-rolled
  versions in home/service provider rows, `following_screen.dart`, and the
  Profile-tab welcome card), `PromooInlineNotice` (dismissible info card —
  also fixed a light-mode contrast bug: one copy used `primaryYellow`
  (always-bright-yellow) for its border instead of `accent`, washing out on
  a white card in light mode), `PromooListHeader` (back+title/subtitle+
  trailing-slot row, replacing separate `_ChatHeader`/`_NotificationsHeader`
  copies). Feature-local: `lib/features/profile/presentation/widgets/
  add_form_widgets.dart` (`AddFormSectionCard`/`FieldLabel`/`FieldGap`/
  `UploadBox`/`PickerField`/`Adornment`) unifies 6 classes that were
  copy-pasted across all three Add Offer/Ad/Service screens — while merging
  it, fixed a latent bug where the Ad wizard's date-picker field never
  switched out of placeholder-gray text after a date was actually picked
  (its copy of the field was missing the `isPlaceholder` parameter the
  other two screens' copies had). Also fixed a stray un-translated `'Back'`
  tooltip in `PromooSubpageScaffold` (missed during the localization pass).
  **Deliberately left separate** after inspection (real behavioral/visual
  differences, not true duplicates): Seats' `_StatChip` vs `PromooMetric`
  (bordered horizontal pill vs bare card-embedded block, one caller each),
  `following_screen.dart`'s row vs `LeaderboardProfileCard` (rank badge +
  verified + chevron-nav vs plain follow-toggle — only their avatar circle
  was unified), `AuthMessageBanner` vs `PromooInlineNotice` (genuine
  dual error/success color semantics), Services' `_ResultsContextBar` vs
  the shared headers (denser in-page step-context bar, not a page header).
  (d) **Found and deleted 7 fully orphaned dead files**
  (`lib/features/seats/presentation/widgets/{seat_booking_notice,seat_card,
  seat_status_badge,seat_tier_cards,seat_tier_explainer,seat_visibility_grid,
  seats_premium_header}.dart`) — zero references anywhere in `lib/` or
  `test/`, confirmed via grep both before asking and via a dedicated
  research pass against `promo_backend` (real Stripe seat-booking checkout
  exists server-side but is intentionally v1-deferred per
  `v2_deferred_scope.md`, and no doc references these filenames or a
  reuse plan) before deleting — these were pre-rewrite leftovers from an
  earlier Seats screen design, fully superseded by `seats_screen.dart`'s
  own inline widgets. **This session's delete command was correctly
  auto-blocked once** by the safety classifier for being an irreversible
  action on pre-existing files with no explicit user sign-off yet; asked
  the owner directly, got explicit approval, then deleted.
  (e) Rewrote `README.md` for GitHub: brand header with light/dark logo
  switching, feature tour, tech stack, architecture tree, the LTR-locked
  localization story, setup/testing instructions — all numbers in it
  (176 tests, 400+ ARB keys) verified against the repo before writing.
  **176 tests pass throughout, `flutter analyze` clean at every step.**
- **2026-07-13 — Fixed story swipe, carousel dots, services categories, and profile headers.** Inverted the swipe handler logic inside [HomeStoryViewer](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/home/presentation/widgets/home_story_viewer.dart) to match the fixed LTR layout. Restricted [_CarouselSection](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/home/presentation/widgets/home_preview_sections.dart) indicators to only show when `viewportFraction == 1.0`. Removed the redundant "All Categories" card from [ServicesCategoryList](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/services/presentation/widgets/services_category_list.dart). Replaced the floating back button overlay on [ProfileScreen](file:///e:/Personal%20Work%20Projects/promo_mobile/lib/features/profile/presentation/screens/profile_screen.dart) with a clean, scrollable navigation header matching the ServiceDetailScreen style. Added corresponding widget tests (176 tests passing).
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
| [integration_map.md](integration_map.md) | **Phase B authoritative map** (fully regenerated 2026-07-13 against current frontend + DB): 111 endpoints, section→API, field-level compatibility (~89%, unchanged — DTOs untouched), backend gaps, wiring order. Now folds in the **`Accept-Language` axis** (localization), the frontend-only reality (remote layer deleted), and the deltas since 2026-07-09 (Follow=local toggle, secure-storage now used, dio removed). The re-wiring guide. |
| [localization_plan.md](localization_plan.md) | **Localization roadmap** (Arabic/English, text-only — no RTL). **Complete (2026-07-13):** all phases L0-Lx done, every screen bilingual, backend bilingual-content model documented. |
| [client_requirements_checklist.md](client_requirements_checklist.md) | Client-requested frontend edits, item-by-item with ✔ + locations. |
| [work_summary.md](work_summary.md) | Full chronological summary of this session's work (light-mode → theme/chrome → icons/logo → integration analysis → role-gating + screens → frontend-only reset). |
| [project_memory.md](project_memory.md) | Older detailed slice-by-slice notes |
| `mvp_roadmap.md`, `api_contracts.md`, `architecture.md` | Original planning/reference |
| `promo_backend/Projects-Pictures/` | **The pixel reference** (original MVP screenshots) |
| `promo_backend/docs/` | Backend truth: `MEMORY_BANK.md`, `REQUIREMENTS_STATUS.md`, `Apis-Resaults/`, Postman collection |

---

## 7. Known follow-ups / open items

- **Localization (RESOLVED 2026-07-13):** all phases complete, see §5 above and
  [localization_plan.md](localization_plan.md). Owner decision on file: user
  content stays single-language forever unless the client explicitly asks for
  bilingual input (that would be v2, needs backend schema changes).
- **Component duplication (RESOLVED 2026-07-13):** whole-app sweep done, see §5
  above. When adding a new screen, check `lib/shared/widgets/` (and the
  feature's own `presentation/widgets/`) for an existing component before
  writing a new private `class _X` inside a screen file — this exact pattern
  (a screen quietly reimplementing something that already exists elsewhere,
  slightly worse) was the root cause of every finding in this sweep.
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
