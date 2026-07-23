# Promoo Mobile — Requirements / Screen Status

> Screen-by-screen and feature status for `promo_mobile`. Mirrors
> `promo_backend/docs/REQUIREMENTS_STATUS.md`. The detailed, tick-off master
> plan (Phase A checklist + Phase B integration table) is in
> [build_plan.md](build_plan.md) — this file is the quick status view.
>
> Legend: ✅ done · 🔄 partial · ⏸️ deferred to v2 · ⬜ not started

Last updated: 2026-07-23

---

## Screens (frontend, mock data — Phase A)

| Screen / flow | Status | Notes |
| --- | --- | --- |
| Splash / intro | ✅ | Animated "Promoo" reveal (visual: do not touch) → **Home if already signed in, Login otherwise** (fixed 2026-07-21 — used to always force `/login` even for a signed-in user, landing on Login's "Signed in / Continue" panel instead of skipping straight to Home). |
| Login | ✅ | MVP layout, big new logo, Apple+Google (no Facebook), guest access |
| Register | ✅ | Fields = backend `registerEmailSchema` (email/password/full_name/account_type) |
| Home | ✅ | Header, Stories (create/view/delete-own, one ring per person, hold-to-pause), Services (compact), Top Offers (hero swiper ≥5), For You, Promoo of the Day; See All on all |
| Services (categories) | ✅ | Search box + image category grid + "No service found" |
| Service detail | ✅ | Display/contact only; own Scaffold; hidden unsupported fields |
| Influencer / Seats | ✅ | Compact stats + search + legend + 2D-overflow grid (Gold→Silver→Bronze), Book/Influencer sheets (Visible to Companies and Influencers, but only Influencers can book) |
| Seat checkout preview | ✅ | Display-only, no payment |
| Cup / Leaderboard | ✅ | Header + podium + ranked list |
| Profile tab (settings) | ✅ | Profile Management, Add New Offer/Service (role-gated, wired live — **no Add Ad, removed 2026-07-23**), **My Listings (new 2026-07-22 — edit/delete own content)**, Saved, My Packages, Following + Followers + Blocked Users, Support, Language, Theme Mode, Logout, **Delete Account (new 2026-07-22, red row + confirm → `DELETE /profiles/me`)**, legal links. **Fully localized.** |
| Light theme (all screens) | ✅ | 2026-07-08: token system (`context.colors`), AA contrast, black brand chrome, dark-locked auth/splash/media viewers |
| Back navigation (system + in-app) | ✅ | 2026-07-08: step-wise everywhere — details → list → categories → Home → double-press exit; push-based details; Services results layer intercepts back |
| Edit Profile | ✅ | Fields = `updateProfileSchema`; local only. Media grid reuses the same `ProfileMediaSection` component as the public profile (fixed 2026-07-13 — it used to be a separate, poorer copy with no likes/comments/share). Avatar wired live 2026-07-20 (camera/gallery → `POST /upload/image` → `POST /profiles/me/avatar`); cover still not wired (no UI yet). |
| ~~Add New Ad (wizard)~~ | ⛔ | **Removed entirely 2026-07-23** — the original client prototype only ever had Offers + Services; Ads was scope creep from an earlier build pass. All mobile code deleted (screen, route, repository, DTOs); backend `ads` table/routes untouched for a possible v2. `influencer` (Ads' only user) now uses Add Offer instead — backend added `influencer` to `POST /offers`'s allowed roles. Add Offer/Service screens kept their `editing:` param (edit mode via My Listings). |
| My Listings | ✅ | **New 2026-07-22, Ads section removed 2026-07-23.** Lists the signed-in user's own offers/services (all statuses) from `GET /offers\|/services/profile/:myId`; edit reuses the Add screens pre-filled, delete is confirm + optimistic (`DELETE /...`). Backend gap filled: `GET /services/profile/:id` didn't exist and was added (`deleteAd` was also added 2026-07-22 but is now unused mobile-side). |
| MyPackages | ✅ | Display-only (no backend package entity — v2) |
| Saved / Following / Followers | ✅ | **Wired live** — `GET/POST /saved` + `DELETE /saved/:id` (bookmark button on offer/ad/service detail, 2026-07-22), `GET /follows/following|followers/:id` (Followers screen new, 2026-07-22) |
| Support / About / Terms / Privacy | ✅ | Static/safe pages |
| Public profile | ✅ | Back button; Instagram-style stats; **distinct per-id profiles**; **Follow toggle** (`POST/DELETE /follows/:id`), **Message → chat**, header "⋮" menu with **Block/Unblock** (`POST/DELETE /blocks/:id`) and **Report** (`POST /reports`, new 2026-07-22), Edit → edit screen; packages + media |
| Search | ✅ | Own Scaffold; grouped/typed results |
| Chat (list + room) | ✅ | Room keyed by roomId (family); **compose + send works** (in-memory); header chat badge = live unread |
| Notifications | ✅ | In-app list works (mark read/all, delete, tap→room); header badge = live unread. Push/FCM wired live 2026-07-20 (`firebase_core` + `firebase_messaging`, token registered on login). |
| Localization (i18n / RTL) | ✅ | **All phases (L0-Lx) complete.** Full bilingual interface Arabic/English (text-only translation, layout stays LTR in both). Toggle persists. |

## Deferred to v2 (not built in v1)

OTP · phone/social login · forgot-password · ALL Stripe/
payments (subscriptions, seat-booking checkout, package checkout, featured) ·
reviews/ratings · likes/comments/share · Facebook login. (Notifications incl.
FCM/push moved to v1 2026-07-20; **delete-account moved to v1 2026-07-22**
— App Store requirement.) Full list + endpoint mapping:
[v2_deferred_scope.md](v2_deferred_scope.md).

## Backend integration (Phase B — in progress, Phase 12 of 12 done)

15-row decisions table in [build_plan.md](build_plan.md#phase-b--backend-integration-decisions-15-rows):
Packages entity, Seats capacity seeding, Subscriptions (deferred), nav order,
hidden fields, ~~Add Offer/Ad wiring~~ ✅ done (2026-07-22), follow/saved/
profile-mgmt, uploads, categories/services data, auth (email login/register),
token persistence (secure storage + Dio Bearer interceptor), API base URL +
envelope parsing. Full live-wiring status: [integration_map.md](integration_map.md).

## Health

**198 tests passing** · `flutter analyze` clean · `flutter build apk --release`
verified end-to-end (58.5MB) · Tajawal + new logo applied ·
AED everywhere · Light + Black themes done · role-gated Add Offer/Service
(**wired live to the real backend, 2026-07-22; Add Ad removed 2026-07-23 — see below**) ·
**bilingual, fully
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

**Recent (2026-07-23):** Two threads. **(A) Ads removed entirely from
mobile.** The original client-provided prototype only ever had Offers +
Services — Ads was scope creep added in an earlier build pass (discovered
when the owner went looking for "Ads" content on Home and found none, then
traced a mislabeled "Add New Offer" button in the old design mockups that
actually opened the ad flow). Deleted every trace from the Flutter app: the
`lib/features/ads/` slice, `AddAdWizardScreen`, the `profileAddAd` route, the
"Add New Ad" menu row, the Ads section of My Listings, the `ad` branch of
`HomeContentDetailType`/`ReportedType`/`SearchResultType`/`SearchFilterType`
(plus the Home "ads/banners/promotions" highlight fallback and the
`GET /ads/active` detail fetch), and ~50 now-dead `addAd*`/`homeDetailTypeAd`/
`myListingsAdsSection` l10n keys. The backend `ads` table/routes/service were
**not touched** — kept dormant for a possible v2 revival. `influencer`
(previously Ads-only via `canAddAd`) now gets `canAddOffer` instead;
`offer.routes.ts`'s `POST /offers` gained `influencer` to its allowed
`requireAccountType` list. **(B) Live-device bug fixes** from real testing on
two phones: **expired-session lockup** — the refresh interceptor cleared the
token store on a dead refresh token but never told `AuthController`, so the
app stayed on Home believing it was signed in while every request 401'd until
a manual logout; fixed with a new `sessionExpiredSignalProvider` the app root
listens to, bouncing to Login with a "session expired" notice. **Friendlier
auth errors** (401 → "wrong email or password" instead of the raw backend
string). **"Message" button** on offer/service detail now opens a direct chat
with that provider instead of the generic chat list. **Chat opens at the
latest message** (new scrolling `_MessageList`, was opening at the top).
**Story viewer is truly fullscreen** (pushed on `rootNavigator: true`, was
showing the shell's bottom bar underneath) and the bogus `"Story update"`
caption fallback is gone. **Block reliability + polish**: `toggleBlock()` now
reports real success/failure (was always claiming success); restyled the
block confirm dialog and menu items; **blocking now auto-unfollows both
directions** (backend `block.service.ts` clears any `follows` row between the
pair); **block + report added inside the chat room** itself (Instagram-style
"⋮" in the header). **Edit Profile's category field** is a real picker now
(was a "coming soon" stub) — `ProfileUpdateDraft` gained `categoryId`, saved
via `PUT /profiles/me`. **Seat "Book Now"** shows a "coming soon" notice
instead of navigating to a disconnected, differently-styled checkout mock
(real booking is Stripe/v2). Backend `npx tsc --noEmit` clean; mobile
`flutter analyze` clean, 196/196 tests (2 fewer than before — the two ad-only
tests were deleted, not broken). Full detail: `MEMORY_BANK.md` §5.

**Recent (2026-07-22, "finish everything" pass):** Closed the last four v1
gaps beyond block. **(1) Content edit/delete + My Listings:** the three Add
screens now take an `editing:` argument and submit `PUT /offers|/services|
/ads/:id` (same screen, no separate edit form); a new `MyListingsScreen`
lists the user's own offers/services/ads across all statuses with edit
(pre-filled Add screen) and delete. Two backend endpoints that didn't exist
were added — `deleteAd` and `GET /services/profile/:id` (offers/ads already
had their `/profile/:id`; offers/ads/services already had `PUT`+`DELETE`
except ad delete). **(2) Delete Account:** `DELETE /profiles/me` route wired
to the pre-existing `deleteAccount` service; red row at the bottom of the
profile menu + confirm → local logout + back to Login. App Store / Play
requirement. **(3) Reports (`POST /reports`):** existed backend-side for ages
but was never wired mobile-side — now a `lib/features/reports/` slice with a
shared `showReportSheet` (reason chips + optional details) and
`PromooReportMenuButton`, surfaced from the public-profile "⋮" menu,
offer/ad detail, service detail, and the story viewer. Completes Apple
Guideline 1.2 (report + block). Backend `tsc` clean, mobile `flutter analyze`
clean, 198/198 tests (test doubles updated for the new repo methods). Only v1
item still unwired: profile cover (no UI). Full detail: `MEMORY_BANK.md` §5.

**Recent (2026-07-22):** Phase 12 — all three remaining content-publish flows
wired to the real backend: Add Offer (`POST /offers`), Add Service
(`POST /services`), Add Ad (`POST /ads`). Replaced the hardcoded 4-item fake
category enum (no real UUID, didn't exist in the DB) with a real
`serviceCategoriesProvider` backed by `GET /categories`, shared by all three
screens. Added a reusable `PromooImageUploadField` (pick → `POST /upload/image`
→ attach URL) used by all three. Ad wizard's two image boxes collapsed to one
(schema has a single `media_url`, not an array); `ad_type`/`budget` sent as
owner-approved defaults since neither has MVP UI. Verified each flow's wire
contract with a live Supabase insert/delete of the exact payload shape sent by
the Flutter code (Offers, Services, Ads all confirmed). Quick polish also
landed: instant (no-delay) hold-to-pause on stories, corrected Arabic
dark-mode label ("الوضع الأسود" → "الوضع الداكن"), 4 fake `example.com`
category images replaced with real photos.

Same day, closed out the two remaining v1 gaps (cover excluded — no UI):
save-from-detail button (new `PromooSaveButton`, `SavedRepository.addSavedItem`
→ `POST /saved`, on the offer/ad and service detail headers, optimistic
toggle) and a new Followers screen (`FollowersScreen`/`FollowersController`,
`ProfileRepository.getFollowers` → `GET /follows/followers/:id`, reusing the
existing defensive `_parseFollowUsers` parser also used by Following). 198
tests passing, `flutter analyze` clean. Full detail: `MEMORY_BANK.md` §5.

**Recent (2026-07-22, later same day):** Built and wired a **user-to-user
block feature from scratch** — it didn't exist anywhere before this (no table,
no endpoint, no UI; a prior review incorrectly assumed it did). Backend: new
`blocks` table (migration `036_create_blocks.sql`, private RLS unlike the
public `follows` table), `POST/DELETE /blocks/:id`, `GET /blocks/:id/status`,
`GET /blocks`, mirroring the existing `follows` feature's file layout
1:1 (`block.routes/controller/service/validator.ts`). Real enforcement added to
`chat.service.ts`: both `startOrOpenChat` and `sendMessage` now reject with 403
if either party has blocked the other. Mobile: `ProfileRepository` gained
`blockProfile`/`unblockProfile`/`getBlockStatus`/`getBlockedUsers`;
`ProfileController`/`ProfileState` gained an `isBlocked` field fetched
alongside `isFollowing`; a new "⋮" overflow menu on the public profile header
(confirm dialog before blocking, no confirm needed to unblock) plus a new
"Blocked Users" management screen (`BlockedUsersScreen`/
`BlockedUsersController`, mirrors `FollowersScreen`). Driven by Apple
Guideline 1.2, which requires both a report mechanism (`POST /reports`
already existed backend-side but still isn't wired mobile-side — separate,
not-yet-done item) and the ability for a user to block someone themselves.
Scoped out for now: no block shortcut inside the chat room screen itself
(only from the profile page), no automatic filtering of a blocked user's
content from home/search feeds, no dedicated automated tests for the new
flow. `flutter analyze` clean, 198/198 tests still passing (6
`ProfileRepository` test doubles updated for the 4 new interface methods).

**Recent (2026-07-21):** Phase 11 Upload infra + avatar wired (camera + gallery
picker). Live on-device FCM test found and fixed 4 bugs: missing notification
icon, notification tap not deep-linking, chat/detail screens showing stale
data after revisiting (fixed via `.autoDispose` on the room/detail
providers), and a locale-switch bug that froze Home/Services permanently
after the *second* language toggle (a `_disposed` flag never reset across
provider rebuilds). Full root-cause detail: `MEMORY_BANK.md`.

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
