# Promoo Mobile — Requirements / Screen Status

> Screen-by-screen and feature status for `promo_mobile`. Mirrors
> `promo_backend/docs/REQUIREMENTS_STATUS.md`. The detailed, tick-off master
> plan (Phase A checklist + Phase B integration table) is in
> [build_plan.md](build_plan.md) — this file is the quick status view.
>
> Legend: ✅ done · 🔄 partial · ⏸️ deferred to v2 · ⬜ not started

Last updated: 2026-07-08

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
| Influencer / Seats | ✅ | Compact stats + search + legend + 2D-overflow grid (Gold→Silver→Bronze), Book/Influencer sheets |
| Seat checkout preview | ✅ | Display-only, no payment |
| Cup / Leaderboard | ✅ | Header + podium + ranked list |
| Profile tab (settings) | ✅ | Following, Profile Management, Add New Offer, Saved, MyPackages, Support, Language, Theme Mode (Black/Light, functional + persisted), Logout, legal links |
| Light theme (all screens) | ✅ | 2026-07-08: token system (`context.colors`), AA contrast, black brand chrome, dark-locked auth/splash/media viewers |
| Back navigation (system + in-app) | ✅ | 2026-07-08: step-wise everywhere — details → list → categories → Home → double-press exit; push-based details; Services results layer intercepts back |
| Edit Profile | ✅ | Fields = `updateProfileSchema`; local only |
| Add New Ad (wizard) | ✅ | 4 steps; fields map to `POST /ads` (`createAdSchema`); local only |
| MyPackages | ✅ | Display-only (no backend package entity — v2) |
| Saved / Following | ✅ | Mock lists (map to `/saved`, `/follows`) |
| Support / About / Terms / Privacy | ✅ | Static/safe pages |
| Public profile | ✅ | Header + Instagram-style stats + actions + packages + media |
| Search | ✅ | Own Scaffold; grouped/typed results |
| Chat (list + room) | ✅ | Skeleton on mock; v1 feature |
| Notifications | ⏸️ | Whole feature deferred (v2); demoable skeleton kept |

## Deferred to v2 (not built in v1)

OTP · phone/social login · forgot-password · delete-account · ALL Stripe/
payments (subscriptions, seat-booking checkout, package checkout, featured) ·
Notifications feature incl. FCM/push · reviews/ratings · likes/comments/share ·
Facebook login. Full list + endpoint mapping: [v2_deferred_scope.md](v2_deferred_scope.md).

## Backend integration (Phase B — NOT started)

15-row decisions table in [build_plan.md](build_plan.md#phase-b--backend-integration-decisions-15-rows):
Packages entity, Seats capacity seeding, Subscriptions (deferred), nav order,
hidden fields, Add Offer/Ad wiring, follow/saved/profile-mgmt, uploads,
categories/services data, auth (email login/register), token persistence
(secure storage + Dio Bearer interceptor), API base URL + envelope parsing.

## Health

192 tests passing · `flutter analyze` clean · Tajawal + new logo applied · AED
everywhere · RTL-ready · Light + Black themes verified live on web (all tabs,
services flow, details, edit profile, chat). See
[MEMORY_BANK.md](MEMORY_BANK.md) for the change timeline and open items.
