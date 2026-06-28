# Prototype Section Contract

This contract aligns the visible Flutter MVP demo surface with the original prototype section structure while keeping the approved PROMOO premium black/yellow design system. It is not a 1:1 visual copy of the prototype.

## Home

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Header | PROMOO logo, chat icon, notification icon | Logo and notification icon | Add lightweight chat entry and keep notification entry | Both actions route to existing safe Chat/Notifications screens. |
| Primary content | Stories, Top Offers, For You, Promoo Of The Day, Services row | Stories, Top Offers, For You, Promoo of the Day, Services swiper | Keep/rename/reorder | Prioritize prototype sections in the main demo flow with image-first cards. |
| Extra discovery | Not a primary prototype focus | Categories and featured profiles | Hide from primary Home demo surface | Implementations stay available in data/domain, but are not shown on Home by default. |
| Detail flow | Offer/for-you detail with contact/location actions | Home detail route exists | Keep | No purchase, checkout, maps, or backend changes. |

## Services

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Landing | Category grid first | Search field, horizontal category chips, listings | Rename and reshape | Show category grid first, keep search as a secondary discovery control. |
| Drill-down/listing | Category-specific listings and service cards | Filtered list and detail route | Keep | `/services/:id` remains for the lightweight contact detail. |
| Purchase flow | Not part of MVP | Not implemented | Keep hidden | Services remain display/contact only. |

## Influencer / Seats

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Navigation label | Influencer | Seats | Rename visible tab to Influencer | Backend naming and route stay `/seats`. |
| Page purpose | Gold/Silver/Bronze visibility slots | Influencer Seats header, explainer, grid, seat cards | Keep | Current implementation already matches the prototype concept. |
| Booking | Place seat/book now leading to payment in prototype | Safe login-required/next-phase copy | Keep safe | No checkout, payment, or real booking from UI. |

## Cup / Leaderboard

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Ranking content | Ranked profile cards, top users/profiles | Cup title, podium, ranked list | Keep | No unrelated sections are visible. |
| Header icons | Chat and notifications visible in prototype header | Screen-specific header is minimal | Defer broader header standardization | Cup structure is aligned; no feature expansion in this patch. |

## Profile

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Public profile | Header, avatar, name, stats, actions | Header, stats, actions, about | Keep | Public profile display stays stable; about/details are de-emphasized after primary sections. |
| Packages/services | Packages are a major visible flow | Packages section appears directly after profile actions | Move earlier | Packages should be prominent before media/tools and about/details. |
| Media/posts | Media/post grid | Media section exists | Keep | Mock-only media preview remains behind the profile data source. |
| Management | Profile Management, Add New Offer, Saved, MyPackages, Support, Language, Logout | Profile tools preview | Keep safe preview | No edit submission, uploads, logout persistence, settings, or add-ad wizard. |

## Login / Register

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Email auth | Email/password and submit | Email/password Auth Lite | Keep | Auth Lite remains the safe MVP flow. |
| Social buttons | Apple, Google, Facebook visual buttons | Missing | Add visual safe buttons | No social SDKs, packages, or real provider login. |
| Forgot password | Present in prototype | Coming soon copy | Keep client-friendly | No password reset implementation. |

## Chat / Notifications

| Area | Prototype sections | Current app sections | Decision | Notes |
| --- | --- | --- | --- | --- |
| Entry points | Header chat/notification icons | Routes exist; Home has notification icon | Add Home header entry consistency | Existing skeleton routes stay safe and demoable. |
| Bottom navigation | Not dedicated prototype tabs | Not bottom tabs | Keep hidden | Do not add new bottom nav items. |

## Final Rule

The new build preserves the approved premium visual design while aligning visible page sections with the original prototype structure.

## Prompt 21 Final Section QA

- Home now shows distinct Stories, Top Offers, For You, and Promoo of the Day sections.
- Final pre-client patch upgraded Home to show a fullscreen story viewer plus Top Offers, For You, and Services swiper-style sections while preserving the approved black/yellow design.
- Services remains category-first, followed by search/listings.
- Influencer remains the visible tab label for the `/seats` route and communicates Gold/Silver/Bronze visibility seats.
- Cup remains ranking/leaderboard only.
- Profile primary order is header/stats/actions, Packages, Media, Profile tools, then About/details.
- Login/Register show email auth and safe visual Apple/Google/Facebook sign-in options without real social auth.
