# Promoo Mobile — v2 Deferred Scope

Last updated: 2026-07-21 (§10: video stories and cross-device instant refresh deferred; delete-own-story was deferred earlier the same day, then shipped later that day — struck through in §10, not actually hidden anymore). Previously: 2026-07-15 (§1 Auth — confirmed final for v1: forgot/reset password and email confirmation are fully disabled, not just "coming soon"; see note below §1). Before that: 2026-07-13 (Phase-0 wiring: `views_count` deferred; the seat-grid seed took migration `035`, so the RLS pass is now `036`)

> **Purpose.** This is the single, authoritative list of everything we are **deferring to v2** and everything we are **hiding in v1**. Rule of the project: **the backend is the single source of truth; the app must match it 100%.** For each item below we record: (a) the backend endpoint / entity it will map to when we build it later, and (b) the exact **v1 behaviour** in the app right now.
>
> **v1 behaviour legend**
> - **Hidden** — not shown in the UI at all (no button, no field, no screen).
> - **Display-only** — the UI is built to match the MVP visually, but performs **no** network mutation, checkout, or write. Taps show a safe "coming soon / next phase" notice or open a local mock.
> - **Safe placeholder** — a visible control that intentionally does nothing yet (e.g. a social icon, a bell badge) kept only for pixel-faithful parity with the MVP.
>
> **What stays in v1 (NOT deferred):** email **login** + email **register** only, token refresh + logout (wired in the integration phase), and all read/discovery surfaces (Home, Services, Seats grid UI, Cup/Leaderboard, Search, public Profiles, Chat). Follow/Unfollow, Saved, Add Offer, Add Ad, Profile edit, and Uploads are **backend-supported but wired later** — they are tracked in [build_plan.md](build_plan.md) Phase B, **not** here.
>
> **Companion doc — interim admin curation:** some of the paid/Stripe items below (featured offers = **Promoo of the Day** + **Top Offers**, featured profiles) are **operated manually from the dashboard in v1** as a stand-in until Stripe turns on. That mirror-image list lives in [`v1_interim_admin_curation.md`](v1_interim_admin_curation.md) — "what we run by hand" vs this doc's "what we hide."

---

## 1. Auth (defer everything except email login + email register)

> **2026-07-15 — confirmed final for v1 (not just "coming soon").** Live testing this
> day proved Supabase's built-in auth-email sender is unreliable/rate-limited on this
> project (confirmation emails silently didn't arrive, even via the official `resend()`
> API — see `MEMORY_BANK.md`). Rather than chase a broken mailer, the owner decided v1
> auth is **register + login only** — no email confirmation gate, no forgot/reset
> password, full stop. Concretely: the **"forget password?" link is now removed
> entirely** from the Login screen (not a "coming soon" placeholder anymore); a
> short-lived attempt to detect "registered but unconfirmed" at login (with a resend
> button) was built, tested, and then **fully reverted** once this decision was made,
> to avoid leaving half-wired dead code. Backend routes for
> `forgot-password`/`reset-password`/`resend-confirmation` are commented out (not
> deleted) in `auth.routes.ts` so v2 can re-enable them once Custom SMTP is set up.
> v2 will need: (1) Custom SMTP configured in Supabase, (2) "Confirm email" turned back
> on, (3) these routes uncommented, (4) the Login "forget password" UI rebuilt.

| Item | Backend endpoint (for later) | v1 behaviour |
| --- | --- | --- |
| Forgot / reset password | `POST /api/v1/auth/forgot-password`, `POST /api/v1/auth/reset-password` (routes commented out in `auth.routes.ts`) | **Hidden** — no "forget password?" link on Login at all. No reset flow. |
| Email confirmation / verify | Supabase email verify; registration may return `session: null` when verification is required | **Hidden** — "Confirm email" is to be turned OFF in Supabase for v1 (owner action), so register always returns a session immediately. No verification gate, no resend screen. |
| OTP send / verify | `POST /api/v1/auth/otp/send`, `POST /api/v1/auth/otp/verify` | **Hidden** — no OTP screens. |
| Phone login / phone register | `POST /api/v1/auth/login/phone`, `POST /api/v1/auth/register/phone` | **Hidden** — email-only auth in v1. |
| Google login | `POST /api/v1/auth/login/oauth` + `POST /api/v1/auth/verify` (Google configured in Supabase) | **Safe placeholder** — Google icon shown on Login/Register for MVP parity; tap = "coming soon". No SDK. |
| Apple login | `POST /api/v1/auth/login/oauth` + `POST /api/v1/auth/verify` (Apple configured in Supabase) | **Safe placeholder** — Apple icon shown; tap = "coming soon". No SDK. |
| Delete account | `DELETE /api/v1/profiles/me` | **Hidden** — no delete-account control in v1. |

**Kept in v1:** `POST /auth/login/email`, `POST /auth/register/email`, `POST /auth/refresh`, `POST /auth/logout` (endpoints already scaffolded in the app; real wiring + secure token persistence happen in the integration phase — see build_plan Phase B rows 13–14).

---

## 2. Payments / Stripe (defer ALL)

| Item | Backend endpoint (for later) | v1 behaviour |
| --- | --- | --- |
| Subscription plans list | `GET /api/v1/subscriptions/plans` (public; real plans = Basic 10 AED, Premium 29 AED) | **Deferred** — not surfaced as a paid flow in v1. If a plans screen is shown at all it is display-only. |
| Subscribe / checkout | `POST /api/v1/subscriptions` (⚠️ backend open bug #29: 500 `client_secret`) | **Hidden** — no subscribe button, no PaymentSheet. |
| My subscription | `GET /api/v1/subscriptions/me` | **Hidden**. |
| Manage / cancel / upgrade | `POST /api/v1/subscriptions/manage` (Stripe Customer Portal) | **Hidden**. |
| Seat booking checkout | `POST /api/v1/seats/:id/book` → returns `checkoutUrl`, `sessionId`, `paymentId`, `status` | **Display-only** — the seat **grid UI is built** (see build_plan Phase A / Phase B row 2), and `Book Now` opens a local `/seats/checkout` preview only. No `checkoutUrl` launch, no WebView, no Stripe. |
| Content package checkout | **No backend entity** (the 99/149/249 "content packages" were never a backend concept; migration 032 deleted placeholder plans) | **Display-only** — packages render (Basic/Standard/Premium, "Includes X posts", "secure checkout" copy) to match MVP, but "proceed to secure checkout" shows a safe notice. Entity decision deferred — see build_plan Phase B row 1. |
| Featured / paid visibility | `POST /api/v1/featured`, `GET /api/v1/featured` | **Hidden**. |
| Payment history | `GET /api/v1/payments/history` | **Hidden**. |

> Security rule kept intact: Flutter must **never** call Stripe secret APIs. All paid flows, when built, go through the backend.

---

## 3. Notifications — ✅ Moved to v1 (Implemented 2026-07-20)

> **2026-07-20 Update:** The owner decided to pull FCM Push Notifications back into v1 since the backend was already fully capable and sending was free/easy. The entire Notifications feature (List, Mark Read, Delete, and FCM Push) is now **fully wired and live** in the v1 app.

| Item | Backend endpoint | v1 behaviour |
| --- | --- | --- |
| Notifications list | `GET /api/v1/notifications?page&limit` | **Live wired** — fully functional. |
| Mark one read | `PATCH /api/v1/notifications/:id/read` | **Live wired** — fully functional. |
| Mark all read | `PATCH /api/v1/notifications/read-all` | **Live wired** — fully functional. |
| Delete notification | `DELETE /api/v1/notifications/:id` | **Live wired** — fully functional. |
| FCM token registration | `POST /api/v1/notifications/token` | **Live wired** — `firebase_messaging` added, token retrieved and pushed to backend on login. |
| Home header bell (badge "6") | — | **Live wired** — shows real unread count and routes to notifications screen. |

---

## 4. Social engagement (defer / hide — no backend entity)

| Item | Backend endpoint (for later) | v1 behaviour |
| --- | --- | --- |
| Reviews / Ratings ("4.7 · 1240 reviews", stars) | **None** — no table/endpoint exists | **Hidden** — no stars, no rating counts anywhere. |
| Likes on posts/media | **None** | **Hidden** — no like button/count on profile media or offers. |
| Comments on posts/media | **None** | **Hidden** — no comment button/count. |
| Share on posts/media | **None** (client-side share is out of v1 scope) | **Hidden** — no share affordance on media/offers. |

> Note: the MVP profile **media viewer** shows like/comment/share affordances (12.4K / 420 / Share). In v1 these are **removed**, not just disabled — there is no backend to back them.

---

## 5. Facebook login (backend never supported it)

| Item | Backend support | v1 behaviour |
| --- | --- | --- |
| Facebook sign-in | **Never supported** — backend OAuth is Google/Apple only | **Removed (2026-07-06).** The Facebook icon was in the MVP screenshot for pixel parity only; per owner decision it has been dropped entirely from the social row (`auth_social_login_preview.dart` now shows Apple + Google only). It will never be wired. |

---

## 6. Hidden fields / attributes (no backend support — hide when absent)

These are not "features" but stray MVP fields with no backing data. Hide them wherever they would otherwise appear:

| Field | Reason | v1 behaviour |
| --- | --- | --- |
| `promo_code` | Not returned by API | **Hidden**. |
| `terms` (offer terms text) | Not returned by API | **Hidden**. |
| `best_price` badge | Not returned by API | **Hidden**. |
| Location/map on offers (sticky map action, "open in maps") | No maps flow in v1 | **Hidden** — show plain text location if present; no map launch. |
| Reviews/ratings/likes/comments/share | See §4 | **Hidden**. |
| `views_count` (profile stat) | No source table on `profiles` — offers/services/media/ads track views, `profiles` doesn't | **Hidden** — owner decision 2026-07-13. During profile wiring (Phase 3) the stats row shows Followers + Posts (+ Following once counted); Views is dropped until a source exists in v2. |

## 7. Dynamic Seats Expansion & Management (Dashboard)

| Item | Backend support | v1 behaviour |
| --- | --- | --- |
| Dynamic Expandable Seat Grid | Needs API adjustment to return grid dimensions (`columns`, `rows`) or implement Infinite Scrolling sections / Interactive Canvas. | **Display-only** — v1 uses a fixed `12x12` math grid mapped to concentric visual bands for exactly 144 seats. |
| Dashboard Seat Management | Needs new CRUD endpoints / UI in `promo_dashboard`. | **Hidden** — currently the dashboard only handles seat reports. In v2, admins should be able to expand seat capacity, modify tier prices, and release/cancel bookings without hardcoded DB limits. |

---

## 8. Database hardening & tuning (deferred to Phase B / owner)

> Added 2026-07-12 after a live DB advisor audit + a **security** hardening pass that
> was already applied (migration `034` in the backend repo). The items below are the
> ones intentionally **left for later**. Full analysis + what got fixed:
> `promo_backend/docs/DB_AUDIT_AND_HARDENING_2026-07-12.md`.

| Item | Type | Why deferred | When to do it |
| --- | --- | --- | --- |
| Enable **Leaked Password Protection** | Security (Auth) | **Confirmed 2026-07-13: requires a Supabase Pro-plan-or-above subscription** — the dashboard toggle is disabled/grayed out on the current Free plan (not just a click-to-enable setting as first assumed). Not achievable via SQL/MCP either way. | Owner — a plan-upgrade + cost decision, revisit before real public launch (not urgent now: real user registration isn't wired until Phase 2/3 of integration_map, so there's no live signup surface yet). |
| **RLS performance pass** — 47 `auth_rls_initplan` (`auth.uid()` → `(select auth.uid())`) + 165 `multiple_permissive_policies` + 4 unindexed FKs + 8 unused indexes | Performance | All WARN-level; a non-issue at current row counts, matters at scale. Best as its own reviewed migration (`036` — `035` is now the seat-grid seed). | Phase B, before real traffic. |
| `is_admin()` / `is_room_participant()` stay anon/authenticated-executable | Security (**accepted, permanent**) | They are RLS **helper** functions evaluated inside policies; revoking EXECUTE breaks legitimate RLS reads, and they leak nothing (return `false` for non-admins/non-participants). Not a TODO — a documented exception. | — |

> **Scope note:** these are DB/infra items, not app features. In v1 the app is
> frontend-only and never touches Supabase directly, so none of this is live surface
> yet — it becomes security-relevant only once **Phase B** wires the app to Supabase
> (Realtime / OAuth). Backend-side tracking: `promo_backend/docs/REQUIREMENTS_STATUS.md`
> (Phase 21) + `MEMORY_BANK.md` (decisions #34–#36).

---

## 9. Dual-language input/display for user-generated content (defer — needs backend schema)

| Item | Backend support | v1 behaviour |
| --- | --- | --- |
| Bilingual user content (offer/service titles & descriptions, profile bio, chat messages) | **None** — user-content tables have a single text column per field; only *reference* content (categories, subscription plans) has `_ar`/`_en` column pairs resolved via `Accept-Language` (see `docs/localization_plan.md` §0) | **Single-language, as authored** — user content always displays in whichever language its author wrote it in, regardless of the app's UI language. No dual-language entry form, no per-field language toggle, no auto-translation. Matches how Instagram/Etsy/Airbnb handle user content. |

> Owner decision (2026-07-12): keep this behaviour permanently unless the client explicitly asks for bilingual user content later. If requested, it needs new `_ar`/`_en` columns per user-content field (mirroring the existing reference-content pattern) — a backend schema change, so it's v2 by definition. Recorded in `docs/localization_plan.md` §"القرارات (مُعتمدة)" item 4.

---

## 10. Stories — v1 scope decided 2026-07-21 (owner: everyone can post, no role gate)

> Story creation went live 2026-07-21 (`HomeStoryStrip`'s "Your story" tile, `POST /stories`,
> reusing the Phase 11 Upload infra). Owner decision that session: **any signed-in account type
> can post a story, no restriction** — unlike Offers/Ads/Services, which are role-gated by
> `account_type`. The items below were discussed the same session and explicitly deferred.

| Item | Backend support | v1 behaviour |
| --- | --- | --- |
| Video stories | `POST /upload/video` exists and works (Phase 11 infra), just never called for stories | **Hidden** — "Your story" only offers camera/gallery **image** capture. Owner explicitly said not now (2026-07-21) when asked. |
| ~~Delete own story~~ | `DELETE /stories/:id` | ✅ **Live (2026-07-21, later same day)** — a "⋮" button in the story viewer header, shown only when the story's author matches the signed-in user, opens a sheet → confirm dialog → deletes → closes the viewer and refreshes Home. No longer deferred; kept in this table only as a strikethrough so the earlier "hidden" entry isn't mistaken for still-current. |
| Cross-device "instant" story refresh | N/A — client behaviour, not backend | **Deferred.** Discussed 2026-07-21: true real-time (Supabase Realtime `INSERT` subscription on `stories`, same pattern as chat) was considered and explicitly **not** chosen. Owner picked the cheap option instead: refresh on cold start (already true — `HomeController` fetches on first build) + manual pull-to-refresh (already true — `RefreshIndicator` on Home). **Missing piece, deferred:** refreshing automatically when the app resumes from the background (`AppLifecycleState.resumed`) — currently the only genuinely-missing trigger; nothing in the app listens for app-resume today. Matches how Instagram actually behaves in practice (no live push of new stories to everyone watching) rather than the idealized "instant" mental model. |

---

## 11. Content Moderation & Statuses (v2 enhancements)

| Item | Backend support | v1 behaviour |
| --- | --- | --- |
| Services `rejected` status | Supabase `services` table check constraint currently enforces `active`, `paused`, `deleted`. | **Deferred to v2.** In v1, services in the Dashboard & API use `active` (live) and `paused` (hidden/suspended), plus deletion. Adding a formal `rejected` status to `services` requires a DB constraint migration in v2. |

---

## Cross-reference

- Everything **kept and wired later** (follow, saved, add offer/ad, profile edit, uploads, categories, auth wiring, token persistence, base URL) lives in [build_plan.md](build_plan.md) **Phase B**.
- Backend truths behind these decisions: `promo_backend/docs/MEMORY_BANK.md`, `promo_backend/docs/REQUIREMENTS_STATUS.md`, `promo_backend/docs/Apis-Resaults/`, `promo_backend/docs/promoo_full_api.postman_collection.json`.
