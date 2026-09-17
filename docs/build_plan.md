# Promoo Mobile — Master Build Plan

Last updated: 2026-07-08 · Owner: Promoo Flutter app

> **2026-07-08 — Light theme + navigation/UX overhaul (done, tested).**
> Light mode rebuilt on a token system (`AppThemeColors` ThemeExtension,
> `context.colors`, new `accent` yellow-as-ink token, AA contrast on paper);
> shell chrome stays brand-black in both modes; splash/auth/media viewers
> dark-locked. Back navigation is step-wise everywhere (push-based details,
> Services results layer intercepts back via
> `lib/routing/back_interceptors.dart`, non-Home tab → Home → double-press
> exit, register pops to login). Theme choice persisted
> (`flutter_secure_storage`). Details in MEMORY_BANK timeline + design/nav
> rules in project_rules §3/§3b. 192/192 tests, analyze clean, both themes
> verified live.

> **Strategy (agreed).**
> 1. **Phase A — Frontend first.** Finish the ENTIRE frontend to match the old MVP design (`promo_backend/Projects-Pictures/`) pixel-faithfully — all screens + flows, on **mock/local data**, with **no backend wiring**.
> 2. **Phase B — Integration.** Then wire the finished frontend to the backend (single source of truth), row by row.
>
> **Rules that never bend:** backend is the source of truth; do not modify `promo_backend`; hide anything with no backend support; defer everything in [v2_deferred_scope.md](v2_deferred_scope.md); AED currency; premium black (`#000000`) / yellow (`#FFE604`) design; Arabic/RTL-ready.
>
> **Status legend:** ⬜ not started · 🟡 in progress · ✅ done · ⏸️ deferred (v2) · ➖ n/a
>
> **How we use this file:** we tick items ✅ together as each is finished. Each Phase A screen lists the MVP reference folder, the current file(s), and the concrete work to reach pixel-faithful parity.

---

## Design invariants (apply to every Phase A screen)

- [ ] ⬜ **Header** (in-shell pages): `PROMOO` logo left; chat icon (badge) + notification bell (badge) right. Match Home header treatment everywhere it appears (Home, Services, Influencer, Profile).
- [x] ✅ **Bottom nav**: `Home · Influencer · Services`(center, elevated yellow "P")`· Cup · Profile`. **Order matches MVP in `lib/shell/promoo_shell.dart`**; Cup tab label corrected to `Cup` (was `Promoo`) to match the MVP, test aligned. Remaining: confirm center elevated-P badge styling parity.
- [ ] ⬜ **Cards**: rounded corners, yellow-accent borders/gradients, image-first, high contrast on black.
- [ ] ⬜ **Currency**: AED everywhere.
- [x] ✅ **Typography**: **Tajawal** applied globally (2026-07-06). Bundled 7 weights (200/300/400/500/700/800/900) directly as `.ttf` under `assets/fonts/tajawal/` (sourced from the Google Fonts OFL repo, license copied alongside), registered in `pubspec.yaml`, wired via `fontFamily: AppTypography.recommendedUiFontFamily` on both `AppTheme.light`/`AppTheme.dark`. Removed the unused `google_fonts` dependency (never resolved on this Windows setup, no longer needed). Logo stays Varela Round (untouched).
- [ ] ⬜ **RTL**: keep `EdgeInsetsDirectional` / directional widgets so Arabic works later.

---

## Phase A — Frontend completion checklist (mock data, no wiring)

### A0. Splash / Intro  ✅ (rebuilt 2026-07-06 to match the client's entry video)
- Ref: client entry video `VID_20260706_105832.mp4` (frames reviewed) · Files: `lib/shell/splash_placeholder_screen.dart`, shared `promoo_glow_background.dart`
- [x] ✅ "Promoo" reveals **letter by letter** (dim gold → brand yellow, letter gap collapsing wide → tight), Varela Round logo font, on a growing **bottom-left diagonal yellow glow** (matches the video), then auto-navigates to Login. Per owner: recreating the wordmark with the logo font instead of the SVG is acceptable as long as the result matches.

### A1. Login  ✅ (done 2026-07-06)
- Ref: `log-in page/photo_2026-06-25_00-29-03.jpg` · Files: `lib/features/auth/presentation/screens/login_screen.dart`, `widgets/auth_*`
- [x] ✅ Centered PROMOO logo (back button hidden on Login via `AuthScreenFrame.showBackButton`); dark rounded card: **Email** label+field, **Password** label+field with eye toggle.
- [x] ✅ Full-width yellow **Login** button (no icon, matches MVP).
- [x] ✅ `forget password?` centered link → safe "coming soon" (deferred, v2).
- [x] ✅ Social row: Apple · Google **circular brand** icons → safe placeholders. Caption "Log in with account" below icons. *(Facebook icon deliberately dropped 2026-07-06 per owner decision — see v2_deferred_scope §5.)*
- [x] ✅ Full-width yellow **Sign Up** button → Register.
- [x] ✅ Kept `Continue as Guest` path into Home for demo (subtle, at card bottom).
- [x] ✅ Wired nothing: email login/register stay on existing in-memory/mock Auth Lite until Phase B.
- [x] ✅ Polish round 2 (2026-07-06, after client video review): **bigger bold PROMOO header wordmark** (`promoo_wordmark.dart` — real P-mark artwork + Varela Round "ROMOO"), **bottom-left yellow glow** behind the whole screen (`promoo_glow_background.dart`, shared with splash), **real multi-color Google G** (official SVG, grey circle matching the client's), Facebook removed.

### A2. Register  ✅ (done 2026-07-06)
- Ref: mirror Login card style (no dedicated MVP shot — confirmed: `log-in page/` has only the one login screenshot) · Files: `register_screen.dart`, `auth_account_type_selector.dart`, new shared `auth_form_field.dart`
- [x] ✅ Matched Login's labeled-field visual language exactly: **Full name**, **Email**, **Password** (shared eye-toggle) labels+fields, extracted into reusable `AuthFieldLabel`/`AuthPasswordField` widgets (used by both Login and Register — no duplication).
- [x] ✅ Kept account-type selector (company/influencer/service_provider/user) — **exactly** the 4 types the backend's `registerEmailSchema` accepts (`email`, `password`, `full_name`, `account_type`); no invented fields (no confirm-password, no phone, no username at register — backend doesn't take them here).
- [x] ✅ Same social row (Apple + Google only, no icons on buttons) + guest path; no verification/OTP (deferred).
- [x] ✅ Cleaned up dead `title`/`subtitle` params on `AuthScreenFrame` (were never rendered, on both screens, even before this session).

### A3. Home
- Ref: `home page/` (+ `stories section/`, `top offer section/`, `for you section/`, `services section/`) · Files: `lib/features/home/presentation/screens/home_screen.dart`, `widgets/home_*`
- [ ] ⬜ Header: logo + chat badge + notification badge (scroll-aware glass header already present — confirm).
- [ ] ⬜ **Section order to match MVP:** Stories → Services (row) → Top Offers → For You → Promoo Of The Day. *(Current contract orders Stories/Top Offers/For You/Promoo/Services — re-order Services up to match MVP.)*
- [ ] ⬜ **Stories**: circular yellow-ringed avatars + names; horizontal scroll.
- [ ] ⬜ **Services** row: yellow-bordered image cards + titles.
- [ ] ⬜ **Top Offers**: large hero **swiper** with page-dot indicator (first dot elongated yellow).
- [ ] ⬜ **For You**: yellow-bordered cards with bottom title overlay; `See All`.
- [ ] ⬜ **Promoo Of The Day**: image-first hero.
- [ ] ⬜ `See All` actions safe/local.

### A4. Home → Story viewer (fullscreen)
- Ref: `stories section/photo_2026-06-25_00-42-41.jpg` · Files: `widgets/home_story_viewer.dart`
- [ ] ✅ Progress bars, avatar+name header, X close, swipe-down close, tap prev/next, grouped-by-owner. *(Implemented; confirm parity.)*

### A5. Home → Offer / Ad detail
- Ref: `top offer section/`, `for you section/` · Files: `home_content_detail_screen.dart`
- [ ] ⬜ Display/contact only. **Hide** promo_code, terms, best_price, map action (see v2 §6). Keep title/description/hero/provider/category/price.

### A6. Services — category grid (landing)
- Ref: `services page/photo_2026-06-25_01-20-59.jpg` · Files: `lib/features/services/presentation/screens/services_screen.dart`, `widgets/services_category_list.dart`
- [ ] ⬜ 2-column grid of category **image cards** with colored gradient label band (Influencer Marketing, Paid Advertising, Content Creation, Design & Branding, Business Growth…).
- [ ] ⬜ Tapping a category opens the category listing (A7).

### A7. Services — category listing (drill-down)  ⟶ *may need a new screen*
- Ref: `services page/photo_2026-06-25_01-21-14.jpg` · Files: new `category_services_screen.dart` (or extend services screen)
- [ ] ⬜ Back header with category name; horizontal/grid of service cards (Instagram Story Promotion, Instagram Post Promotion, Reels Promotion…) with rounded image cards.
- [ ] ⬜ Card tap → Service detail (A8).

### A8. Service detail
- Ref: `services page/` · Files: `service_detail_screen.dart`
- [ ] ✅ Lightweight detail: title, category/provider chips, price/AED, description, tags, contact. Display/contact only — no purchase. *(Implemented; confirm parity + hide unsupported fields.)*

### A9. Influencer / Seats — the big grid  ✅ (rebuilt from scratch 2026-07-06)
- Ref: ALL 7 `influencer page/` shots reviewed · Files: `seats_screen.dart` (full rewrite), `seats_fake_data_source.dart` (144-seat generator)
- [x] ✅ Header: logo + chat/notif badges (shared `PromooPageHeader`).
- [x] ✅ **Search bar** (pill, yellow search icon) — live local filter that dims non-matching seats.
- [x] ✅ Legend row: **Gold Seats** (yellow) · **Silver Seats** (grey) · **Bronze Seats** (bronze).
- [x] ✅ **2D-overflow grid** (scrolls down AND right): 12×12 cells in 4-cell bands, tier = max(rowBand, colBand) → Gold top-left block, Silver band, Bronze outer band — **both** scroll directions go Gold → Silver → Bronze exactly as requested.
- [x] ✅ Cells: occupied = avatar + tier dot + name; available = chair icon + `Place Your Seat` + `499/299/149 AED`.
- [x] ✅ Mock data: 144 seats (16/48/80) with 24 fictional occupied holders using the MVP names (Sara Fashion, Hadi Coding, Rana Books…). Backend seeding stays Phase B row 2.
- [x] ✅ Occupied tap → influencer preview sheet (Follow = coming-soon, View profile → `/profiles/:id`).
- [x] ✅ Available tap → tier sheet with the MVP's **exact** Gold/Silver/Bronze descriptions + `Book Now` → `/seats/checkout` preview (no payment). Fixed the MVP's "499 AED AED" duplication.

### A10. Seat checkout preview
- Ref: n/a (safe local) · Files: `seat_checkout_preview_screen.dart`
- [ ] ✅ Display-only preview; no Stripe/WebView. *(Implemented; confirm copy is client-safe.)*

### A11. Cup / Leaderboard
- Ref: `cup page/photo_2026-06-25_01-55-46.jpg` · Files: `lib/features/leaderboard/presentation/screens/leaderboard_screen.dart`, `widgets/leaderboard_*`
- [ ] ⬜ Ranked cards: purple **`#N`** rank tag (top-left corner), circular avatar, **name** (bold white), **account type** (yellow: Influencer/Company/…), bio line (grey), **`X followers`**.
- [ ] ⬜ Top-3 medal / stronger treatment (podium).
- [ ] ⬜ Card tap → public profile.

### A12. Profile tab — settings/menu screen  ✅ (rebuilt 2026-07-06, modal REMOVED)
- Ref: `profile page/photo_2026-06-25_01-59-36.jpg` · Files: new `profile_menu_screen.dart`; shell modal deleted from `promoo_shell.dart`.
- [x] ✅ Profile tab now navigates to a full **page** (`/profile` → `ProfileMenuScreen`) — no bottom sheet anywhere.
- [x] ✅ "Hi / Welcome To Promoo" card with small logo chip (new logo).
- [x] ✅ **Following** row (star) → `/profile/following` (mock list, local unfollow).
- [x] ✅ Menu group with dividers: **Profile Management** → `/profile/edit` · **Add New Offer** → the Add New AD wizard (the MVP's single creation flow; fields map to `POST /ads`) · **Saved** → `/profile/saved` · **MyPackages** → `/profile/packages` · **Support** → `/profile/support`.
- [x] ✅ **Language** card: English/Arabic radios (Arabic = localization-phase notice).
- [x] ✅ **Logout** row → confirm dialog → Auth Lite logout → `/login`.
- [x] ✅ Footer links: About · TermsAndCondition · PrivacyPolicy → static info pages (`/profile/info/:topic`).
- [x] ✅ Dropped the old modal's off-MVP extras (View Profile, Theme Mode) per "nothing extra".

### A13. Profile Management / Edit Profile  ✅ (built 2026-07-06)
- Ref: `profile page/photo_2026-06-25_01-59-33.jpg` + `01-59-08.jpg` · Files: new `edit_profile_screen.dart`
- [x] ✅ "Edit Profile" back header; avatar (yellow ring + "+" badge); followers count; "Change profile photo" (upload-phase notice).
- [x] ✅ Fields: **Name**, **Subtitle/Bio**, **Location**, **Category** (icon-labeled cards) — prefilled from the demo profile via the repository (no fake data in widgets). Fields = exactly `updateProfileSchema` (full_name/bio/location/category_id).
- [x] ✅ **Media** section (2-col Post N grid with view counts).
- [x] ✅ Local form only + Save notice — no `PUT /profiles/me`, no upload (Phase B rows 10–11).

### A14. Public Profile (viewing someone)
- Ref: `profile page/` header shots + packages · Files: `lib/features/profile/presentation/screens/profile_screen.dart`, `widgets/profile_*`
- [ ] ⬜ Header: cover/avatar (resilient image), name, verification badge, bio.
- [ ] ⬜ Stats row: Followers / Posts / Views (**no** Likes — see v2 §4; drop the Likes stat).
- [ ] ⬜ Actions: **Follow** + **Message** (own profile hides them) — safe/coming-soon until Phase B.
- [ ] ⬜ **Packages** section (A17) prominent, then Media grid.
- [ ] ⬜ Media grid → fullscreen viewer **without** like/comment/share (removed per v2 §4).

### A15. Add New Offer  ✅ (folded into the Add New AD wizard, 2026-07-06)
- Decision: the MVP has ONE creation flow — the menu row is labeled "Add New Offer" but opens the "Add New AD" wizard (matching the original app exactly). A separate offer form would be extra vs. the MVP; `POST /offers` wiring decision stays in Phase B row 6.

### A16. Saved items  ✅ (built 2026-07-06)
- Files: new `saved_items_screen.dart`
- [x] ✅ Demo saved list (offers/services, fictional set) with local bookmark-remove + empty state. Swaps to `GET /saved` in Phase B row 9.

### A17. Packages (content) + MyPackages  ✅ (built 2026-07-06)
- Ref: `profile page/photo_2026-06-25_01-58-52/58.jpg` · Files: new `my_packages_screen.dart`
- [x] ✅ Exact MVP cards: Basic **99.0 AED** "Includes 3 posts" / Standard **149.0 AED** "6 posts" / Premium **249.0 AED** "12 posts", the 3 bullets, the Guarantee block, and "Tap to view details and proceed to secure checkout."
- [x] ✅ **Display-only** — tap shows a safe notice (no backend entity; v2 §2, Phase B row 1).

### A18. Add New Ad wizard  ✅ (built 2026-07-06 — all 4 steps confirmed from screenshots)
- Ref: `profile page/photo_2026-06-25_01-59-03/05/26/29.jpg` · Files: new `add_ad_wizard_screen.dart`
- [x] ✅ 4-step progress indicator (yellow check dots + dashed connectors).
- [x] ✅ **Step 1 – Basic Ad Details:** Ad Title, Description, Main Image, Additional Image, Post Date (date picker), Tags.
- [x] ✅ **Step 2 – Location Information:** City dropdown, Area dropdown (per city), Full Address, Upload Location Map.
- [x] ✅ **Step 3 – Contact Information:** Phone, Whatsapp, Email, Instagram Link.
- [x] ✅ **Step 4 – Pricing Information:** Price, Currency (AED), Service/Product, Payment Method → **Create AD**.
- [x] ✅ Back(red outline)/Cancel + Next/Create AD (yellow). Local only — every field maps 1:1 to `createAdSchema`; `ad_type`/`budget` (backend-required, not in MVP UI) get defaults in Phase B row 7.

### A19. Support / About / Terms / Privacy  ✅ (built 2026-07-06)
- Files: new `support_screen.dart`, `static_info_screen.dart`
- [x] ✅ Support: 24/7 card, contact rows, message form (safe notices). About/Terms/Privacy: static content pages at `/profile/info/:topic`.

### A20. Search
- Ref: search pill on Influencer/Home · Files: `lib/features/search/presentation/screens/search_screen.dart`
- [ ] ✅ Grouped/typed results, filters, navigation to profile/service/offer/ad. *(Implemented; confirm parity.)*

### A21. Chat (list + room)
- Ref: `cup page/photo_2026-06-25_01-55-40.jpg` (chat room) · Files: `lib/features/chat/...`
- [ ] ⬜ Room list; conversation with **yellow sent** bubbles, **grey/white received** bubbles, timestamps, "Type your message" input + send.
- [ ] ⬜ Keep as v1 feature (NOT deferred) on mock data; real wiring in Phase B.

### A22. Notifications  ⏸️ (whole feature deferred — keep demoable only)
- Ref: header bell · Files: `lib/features/notifications/...`
- [ ] ⏸️ Keep the existing mock skeleton reachable from the bell for demo; **do not** invest in pixel-perfection or wiring (v2 §3).

---

## Phase A exit criteria
- [ ] ⬜ Every in-scope screen matches its MVP reference on mock data.
- [ ] ⬜ Nothing deferred/hidden per [v2_deferred_scope.md](v2_deferred_scope.md) is visible or functional.
- [ ] ⬜ `flutter pub get` · `dart format .` · `flutter analyze` · `flutter test` all pass.
- [ ] ⬜ Tajawal font applied; AED everywhere; RTL-safe.

---

## Phase B — Backend integration decisions (15 rows)

> Wire the finished frontend to the backend. Backend base: `http://localhost:3000/api/v1` (dev), Supabase ref `mqklargyjispbcyxzdjo`, envelope `{ success, data, message, meta? }`, currency AED. Truth docs: `promo_backend/docs/Apis-Resaults/`, `promoo_full_api.postman_collection.json`.

| # | Item | MVP shows | Backend reality | v1 decision | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | **Content Packages** | Basic/Standard/Premium 99/149/249 AED, "Includes X posts", secure checkout | **No such entity**; `subscription_plans` = Basic 10 / Premium 29 AED (99/149/249 deleted in migration 032) | **Display-only** in v1; **no checkout**. Final entity (new `packages` table vs. map to subscriptions vs. drop) **decision deferred** — confirm with backend owner. | ⬜ |
| 2 | **Seats capacity** | Large grid of many purchasable seats per tier (Gold 499 / Silver 299 / Bronze 149) | Only **3 seats total** (one per tier); `GET /seats` public, `POST /seats/:id/book` → Stripe checkout | **Build the grid UI now (mock).** Integration: backend must **seed more seats** per tier; then wire `GET /seats`. Booking/checkout stays **deferred** (v2 §2). | ⬜ |
| 3 | **Subscriptions / Stripe** | (implied paid plans) | `GET/POST /subscriptions*` exist; `POST /subscriptions` has **open 500 bug #29** | **Deferred (v2).** Not wired. Revisit only after backend fixes `client_secret`. | ⏸️ |
| 4 | **Nav order** | Home · Influencer · Services(center) · Cup · Profile | — | **Already correct** in `promoo_shell.dart`. Action: **verify styling only**, no reorder. | ⬜ |
| 5 | **Hidden fields/features** | reviews/ratings, likes/comments/share, promo_code, terms, best_price, offer location/map | No backend support for any | **Hide all** (v2 §4, §6). Verify none leak into UI after integration. | ⬜ |
| 6 | **Add New Offer** | "Add New Offer" form | `POST /api/v1/offers` (supported, not wired) | Build form in Phase A; **wire `POST /offers`** in integration (auth required). | ⬜ |
| 7 | **Add New Ad wizard** | 4-step wizard | `POST /api/v1/ads` — fields map **exactly**: phone/whatsapp/contact_email/instagram_link/city/area/full_address/location_map_url/media/tags | Build wizard in Phase A; **wire `POST /ads`** in integration. | ⬜ |
| 8 | **Follow / Unfollow** | Follow button on profiles/seats | `POST/DELETE /api/v1/follows/:profileId`, `GET /follows/:profileId/status`, followers/following lists | Build button UI now; **wire `/follows`** in integration (updates `followers_count` → Cup). | ⬜ |
| 9 | **Saved items** | "Saved" | `/api/v1/saved` (supported, not wired) | Build list now; **wire `/saved`** in integration. | ⬜ |
| 10 | **Profile edit & management** | Edit Profile (name/bio/location/category/avatar) | `PUT /api/v1/profiles/me`, `POST /profiles/me/avatar`, `POST /profiles/me/cover`, `GET /profiles/me` | Build form now; **wire `PUT /profiles/me` + avatar/cover** in integration (auth required). | ⬜ |
| 11 | **Uploads** | image pickers (Main/Additional image, change photo) | `POST /api/v1/upload/image` (+ video/file); buckets: avatars, covers, offers, ads, services, stories, general… (≤5MB image) | Placeholder pickers now; **wire `/upload/*`** in integration; store returned `file_url`. | ⬜ |
| 12 | **Categories & Services data** | category grid, service cards | `GET /api/v1/categories`, `GET /api/v1/services` (paginated, `category_id`, `q`), `GET /services/:id` | Mock now; **swap to real** `GET /categories` + `GET /services` in integration. | ⬜ |
| 13 | **Auth — email login/register (kept)** | Login/Register | `POST /auth/login/email`, `POST /auth/register/email`, `POST /auth/refresh`, `POST /auth/logout`; Supabase-like `{ user, session }` | **The one auth flow we keep.** Wire real endpoints; parse Supabase session defensively; everything else deferred (v2 §1). | ⬜ |
| 14 | **Session & token persistence** | (stay logged in) | Bearer token in `Authorization` header on protected routes | Add **Dio auth interceptor** (auto-inject Bearer) + **`flutter_secure_storage`** (dependency present but **unused**) to persist tokens across restarts + refresh-on-401. | ⬜ |
| 15 | **API base URL / device networking + envelope** | — | `http://localhost:3000/api/v1` won't reach a real device; envelope `{ success, data, message, meta? }` | Make base URL configurable via `--dart-define PROMOO_BASE_URL` (LAN IP / hosted); confirm centralized envelope parsing (`api_response.dart`) matches all endpoints; keep `PROMOO_USE_MOCKS` switch. | ⬜ |

### Phase B exit criteria
- [ ] ⬜ Mocks off (`PROMOO_USE_MOCKS=false`) against a reachable backend; all wired rows return real data.
- [ ] ⬜ Auth persists across restart; protected calls carry Bearer automatically; 401 → refresh/redirect.
- [ ] ⬜ No deferred/hidden feature is reachable; envelope + AED consistent.
- [ ] ⬜ `flutter analyze` + `flutter test` green.

---

## Change log
- 2026-07-06 (4) — **Client feedback round: shell chrome + polish.** Rebuilt the **footer** full-width (edge-to-edge, top border only, glass-on-scroll) with the Services **P mark overflowing** above the bar (bar height from the other tabs), via `extendBody` so content shows through. Rebuilt the **header** as a shared full-width bar (`PromooPageHeader`: bottom border only, plain MVP-style chat/bell icons + yellow badges, glass-on-scroll, new logo, no subtitle) used by Home/Services/Influencer/Cup/Profile. **Login** now uses the big new-logo wordmark (P visible). **Services**: decluttered to search-box + image category grid + "No service found." **Influencer**: compact stats strip (Influencers / Available seats), smaller chairs, kept legend. **Profile**: functional **Black/Light Theme Mode** toggle (new `themeModeProvider` wired into `MaterialApp`) under Language. Home service cards smaller/denser. Verified: **192/192 tests**, analyze clean, formatted, + live web-preview screenshots (home/seats/login/profile). ⚠️ Open: feedback #4 (Cup tab → "P/Promoo") conflicts with the MVP center-P=Services layout — left as MVP, flagged for the owner.
- 2026-07-06 (3) — **NEW LOGO + Influencer grid + Profile pages (major parity pass).** (1) **New logo everywhere except entry/login** (owner rule): processed `new logo/` PNGs with ffmpeg (black-bg → transparent, auto-cropped) into `assets/brand/new_logo/{promoo_mark,promoo_wordmark}.png`; `PromooLogo` widget now renders them (Home header picks it up automatically — zero Home-file edits); shell center Services button = new P mark on black circle w/ yellow ring; splash + Login untouched. PNG kept as-is (Flutter-native; no SVG conversion needed — the old "SVGs" were PNG-embedded anyway). (2) **Influencer page rebuilt from scratch** (A9 above). (3) **Profile tab rebuilt as a real page** with ALL MVP sections + 8 new sub-screens (A12–A19); the shell modal is gone. New shared widgets: `PromooPageHeader`, `PromooSubpageScaffold`. Backend-first verified: ad wizard = `createAdSchema`, edit profile = `updateProfileSchema`, saved = `GET /saved`. Verified: **192/192 tests**, analyze clean, formatted, plus live web-preview checks (a11y tree confirms grid band layout Gold→Silver→Bronze in both axes; screenshot confirms the Profile page + new logo).
- 2026-07-06 — Plan created. Confirmed full backend + mobile context; captured MVP screenshots as the pixel reference; noted nav order already matches MVP; noted `flutter_secure_storage` present-but-unused and no Dio auth interceptor yet.
- 2026-07-06 — **Phase A started: A1 Login done.** Rebuilt Login to MVP (labeled fields, password eye toggle, circular Apple/Google/Facebook social row + "Log in with account", "forget password?", yellow "Sign Up", hidden back button, subtle guest). Also fixed **2 pre-existing** failing tests found in the working tree (unrelated to this work, left over from a prior session): Cup tab label `Promoo`→`Cup` (MVP-correct; shell test aligned) and Home section `Promoo Stories`→`Stories` (MVP-correct). Full suite green: **192 passed**, `flutter analyze` clean, formatted.
- 2026-07-06 — **Client entry-video parity pass (A0 + A1 polish).** Extracted frames from the client's real entry video (`VID_20260706_105832.mp4`) and rebuilt to match: (1) **Splash** = letter-by-letter "Promoo" reveal in Varela Round (dim gold → yellow, gap collapse) over a growing bottom-left glow, auto-nav to Login. (2) **Login** = large bold PROMOO wordmark (new `promoo_wordmark.dart`: real P-mark PNG extracted from the brand SVG + Varela Round "ROMOO"), shared bottom-left glow background (`promoo_glow_background.dart`), official multi-color Google "G" SVG on a grey circle (matches client). Bundled Varela Round font (logo-only rule kept) + official Google G asset — both fetched from canonical sources with licenses. Visual check done via web preview screenshot. Suite green: **192 passed**, analyze clean.
- 2026-07-06 — **Owner decisions applied + A2 Register done + Tajawal applied globally.** (1) Dropped the Facebook icon entirely (was placeholder-only; backend never supported it) — updated `auth_social_login_preview.dart`, tests, and v2_deferred_scope §5. (2) Bundled Tajawal (7 weights) as `.ttf` assets from the Google Fonts OFL repo and wired it globally via `AppTheme` — applies everywhere through the theme, **without editing any `lib/features/home/` file** (explicit instruction: do not touch Home). Removed the now-unused `google_fonts` pubspec dependency. (3) Rebuilt Register to mirror Login's new style, reusing extracted `AuthFieldLabel`/`AuthPasswordField` widgets; kept fields to **exactly** what the backend's register endpoint accepts (email/password/full_name/account_type) — no invented fields. Cleaned up dead `title`/`subtitle` params on `AuthScreenFrame`. Full suite green: **192 passed**, `flutter analyze` clean, formatted, `flutter pub get` clean. `lib/features/home/` diff-confirmed untouched.
