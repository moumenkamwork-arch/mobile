# Promoo Mobile — Requirements / Screen Status

> Screen-by-screen and feature status for `promo_mobile`. Mirrors
> `promo_backend/docs/REQUIREMENTS_STATUS.md`. The detailed, tick-off master
> plan (Phase A checklist + Phase B integration table) is in
> [build_plan.md](build_plan.md) — this file is the quick status view.
>
> Legend: ✅ done · 🔄 partial · ⏸️ deferred to v2 · ⬜ not started

Last updated: 2026-07-20

---

## Screens (frontend, mock data — Phase A)

| Screen / flow | Status | Notes |
| --- | --- | --- |
| Splash / intro | ✅ | Animated "Promoo" reveal + corner glow → Login. Do not touch. |
| Login | ✅ | MVP layout, big new logo, Apple+Google (no Facebook), guest access |
| Register | ✅ | Fields = backend `registerEmailSchema` (email/password/full_name/account_type) |
| Home | ✅ | Header, Stories, Services (compact), Top Offers (hero swiper ≥5), For You, Promoo of the Day; See All on all; story viewer (tap + swipe) |
| Services (categories) | ✅ | Search box + image category grid + "No service found" |
| Service detail | ✅ | Display/contact only; own Scaffold; hidden unsupported fields |
| Influencer / Seats | ✅ | Compact stats + search + legend + 2D-overflow grid (Gold→Silver→Bronze), Book/Influencer sheets (Visible to Companies and Influencers, but only Influencers can book) |
| Seat checkout preview | ✅ | Display-only, no payment |
| Cup / Leaderboard | ✅ | Header + podium + ranked list |
| Profile tab (settings) | ✅ | Profile Management, Add New Offer/Ad/Service (role-gated), Saved, My Packages, Following (above Support), Support, Language (functional toggle → ar/en), Theme Mode (Black/Light, persisted), Logout, legal links. **Fully localized.** |
| Light theme (all screens) | ✅ | 2026-07-08: token system (`context.colors`), AA contrast, black brand chrome, dark-locked auth/splash/media viewers |
| Back navigation (system + in-app) | ✅ | 2026-07-08: step-wise everywhere — details → list → categories → Home → double-press exit; push-based details; Services results layer intercepts back |
| Edit Profile | ✅ | Fields = `updateProfileSchema`; local only. Media grid reuses the same `ProfileMediaSection` component as the public profile (fixed 2026-07-13 — it used to be a separate, poorer copy with no likes/comments/share). |
| Add New Ad (wizard) | ✅ | 4 steps; fields map to `POST /ads` (`createAdSchema`); local only |
| MyPackages | ✅ | Display-only (no backend package entity — v2) |
| Saved / Following | ✅ | Mock lists (map to `/saved`, `/follows`) |
| Support / About / Terms / Privacy | ✅ | Static/safe pages |
| Public profile | ✅ | Back button; Instagram-style stats; **distinct per-id profiles** (fake synthesizes any id); **Follow toggle** (local), **Message → chat**, Edit → edit screen; packages + media |
| Search | ✅ | Own Scaffold; grouped/typed results |
| Chat (list + room) | ✅ | Room keyed by roomId (family); **compose + send works** (in-memory); header chat badge = live unread |
| Notifications | ✅ | In-app list works (mark read/all, delete, tap→room); header badge = live unread. Push/FCM wired live 2026-07-20 (`firebase_core` + `firebase_messaging`, token registered on login). |
| Localization (i18n / RTL) | ✅ | **All phases (L0-Lx) complete.** Full bilingual interface Arabic/English (text-only translation, layout stays LTR in both). Toggle persists. |

## Deferred to v2 (not built in v1)

OTP · phone/social login · forgot-password · delete-account · ALL Stripe/
payments (subscriptions, seat-booking checkout, package checkout, featured) ·
reviews/ratings · likes/comments/share · Facebook login. (Notifications incl.
FCM/push moved to v1, 2026-07-20 — see below.) Full list + endpoint mapping:
[v2_deferred_scope.md](v2_deferred_scope.md).

## Backend integration (Phase B — NOT started)

15-row decisions table in [build_plan.md](build_plan.md#phase-b--backend-integration-decisions-15-rows):
Packages entity, Seats capacity seeding, Subscriptions (deferred), nav order,
hidden fields, Add Offer/Ad wiring, follow/saved/profile-mgmt, uploads,
categories/services data, auth (email login/register), token persistence
(secure storage + Dio Bearer interceptor), API base URL + envelope parsing.

## Health

**198 tests passing** · `flutter analyze` clean · `flutter build apk --release`
verified end-to-end (58.5MB) · Tajawal + new logo applied ·
AED everywhere · Light + Black themes done · role-gated Add Offer/Ad/Service ·
**frontend-only (no network layer — reset 2026-07-09)** · **bilingual, fully
localized, LTR-locked layout proven by test** · **zero known duplicated UI
components** (whole-app dedup sweep 2026-07-13).
The re-wiring plan is [integration_map.md](integration_map.md); the localization
plan is [localization_plan.md](localization_plan.md); see
[MEMORY_BANK.md](MEMORY_BANK.md) for the full change timeline.

**Recent (2026-07-13):** localization plan finished end-to-end (Profile, Chat,
Notifications, Lx closed) · owner decision: user content stays single-language
forever unless the client asks for bilingual input (v2) · whole-app
component-deduplication sweep — 6 new shared widgets, several real bugs fixed
along the way (light-mode-invisible text on Edit Profile's media grid, Apple
sign-in button icon invisible in light mode, a washed-out notice-card border,
a date picker stuck in placeholder styling, an un-translated "Back" tooltip) ·
7 fully orphaned dead files deleted from the Seats feature (confirmed zero
references anywhere + checked against the backend before deleting) · `README.md`
rewritten for GitHub.

**Recent (2026-07-20):** FCM push notifications wired live (`firebase_core` +
`firebase_messaging`, Android Firebase project `com.MO2MIN.promoo_app`); follow
notifications now name the real follower instead of "Someone"; profile-menu
welcome-card avatar fixed to read the owner profile instead of the
no-avatar login session; Services demo entries given content-matched images.
Separately: a second AI tool's build-error pass had introduced a real
regression (Dart SDK constraint + several package versions silently
downgraded, 3 Riverpod `.family` controllers rewritten to a Riverpod-2.x-only
pattern, a hardcoded Supabase URL/key safety-net removed) alongside genuinely
correct fixes (Flutter's `CardTheme`→`CardThemeData` API rename, the Firebase
Android Gradle/AGP bump); the regression was root-caused via `git diff` and
reverted while keeping the genuine fixes and the new FCM feature — confirmed
by a from-scratch `flutter clean && flutter build apk --release` succeeding
(58.5MB) plus zero `flutter analyze` issues and all 198 tests passing.

**Recent (2026-07-15):** Phase 1-5 Final Verifications. Successfully tested and audited roles logic (Admin Dashboard + Mobile UI). Fixed a critical UX bug in Mobile Bottom Navigation: Influencers and Companies now get a dynamic 6-tab layout (showing both Offers and Seats) instead of 5, without breaking the custom floating "P" cup design. Backend permissions tested via seeding test accounts.

**Recent (2026-07-10→11):** client-edit fixes (footer P→Cup, See-All, glass
header) · UX-audit fixes (live header badges, distinct per-id profiles, profile
Follow/Message/Edit working, chat send fixed via family provider, profile back
button, Following reorder + unfollow toggle) · localization L0. Genuinely
backend-only (not faked): OAuth, password reset, payments, media upload.
