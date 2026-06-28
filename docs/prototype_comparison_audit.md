# Prototype comparison audit

Last updated: 2026-06-27

## Scope

This audit compares the old prototype screenshots in `../promo_backend/Projects-Pictures` against the current Flutter MVP. The screenshots are reference material only. The current PROMOO black/yellow premium design system remains the source of truth.

No Flutter code changes were made for the original audit. Post-audit updates: Prompt 15 implemented the P1 lightweight Service Detail + Contact improvement, Prompt 16 implemented the P1 lightweight Home Top Offer / For You Detail improvement, Prompt 17 improved Seats / Influencer visual alignment, Prompt 18 added the Profile media/tools preview, Prompt 20 aligned the visible demo sections to the prototype contract while keeping the premium PROMOO design, Prompt 21 performed final section-accuracy QA, and the final pre-client Step 3/4 patch added Cup-to-profile navigation, Profile media viewing, Influencer seat bottom sheets, and a demo checkout preview.

## Prototype folders reviewed

- `cup page`: 7 screenshots
- `home page`: 6 screenshots
- `home page/for you section`: 3 screenshots
- `home page/stories section`: 2 screenshots
- `home page/top offer section`: 3 screenshots
- `influencer page`: 7 screenshots
- `log-in page`: 1 screenshot
- `profile page`: 9 screenshots
- `services page`: 11 screenshots

## Priority guide

- P0: must fix before client demo.
- P1: should improve soon or before a deeper product walkthrough.
- P2: later/backlog.

## Executive summary

No P0 blocker was found from the prototype comparison if the client demo is positioned as the scoped Flutter MVP and not as a full clone of the older prototype.

The main remaining structural gaps are P1/P2 scope gaps: full profile management/edit/upload/add-ad screens, sticky map/location behavior, package checkout, and real payment/realtime/production hardening. The service detail/contact gap identified by this audit has been partially addressed by Prompt 15, the Home top-offer/for-you detail gap has been partially addressed by Prompt 16, the Seats/Influencer visual-alignment gap has been partially addressed by Prompt 17, the Profile media/management preview gap has been partially addressed by Prompt 18, the visible-section mismatch has been addressed by Prompt 20, and Step 3/4 further improved Cup navigation, Profile media viewing, and Influencer seat/payment-preview parity.

## Screen inventory compared

Current Flutter MVP screens:

- Splash
- Home
- Services
- Cup / Leaderboard
- Seats
- Profile + Packages
- Public profile detail
- Search
- Login
- Register
- Chats
- Chat room
- Notifications

## Splash

Prototype sections found:

- No dedicated splash screenshot was found.
- Login prototype uses the PROMOO logo as the primary brand element.

Current Flutter sections implemented:

- Minimal splash with full PROMOO logo, welcome copy, and "Enter Promoo" CTA.
- Uses current black/yellow design system and `promoo3.svg`.

Missing sections:

- No animated/native splash is implemented.

Differences:

- The Flutter splash is an MVP entry screen, while the prototype begins from login/home-style screens.

Decision:

- Acceptable for MVP and client demo.

Priority:

- P2: native splash and launcher icon can be handled in release-prep work.

## Home

Prototype sections found:

- Header with PROMOO logo and chat/notification icon badges.
- Stories row with circular profile images.
- Services row with image cards such as Instagram Story Promotion, Instagram Post Promotion, and Reels Promotion.
- Top Offers carousel with large image cards and page indicators.
- For You section with image cards and "See All" actions.
- Promo of the Day large card.
- Detail pages for top offer/for-you items with description, service tags, verified/best-price chips, promo code, valid-until, location, terms, and sticky Location/Contact actions.
- Bottom navigation with Home, Influencer, Services, Cup, and Profile.

Current Flutter sections implemented:

- Home header/logo with Chat and Notifications entry points.
- Stories strip.
- Top Offers section.
- For You section.
- Promoo of the Day highlight.
- Lightweight Home detail route for top-offer/promotion/ad content.
- Safe Home detail contact section with Contact, Open chats, View provider profile, and Location notice actions when data exists.
- Loading, empty, error, retry, and refresh states.

Missing sections:

- Full-screen story viewer.
- Rich image-led Top Offers carousel with page dots.
- Dedicated For You full list route.
- Sticky Location/Contact action bar and final map/contact behavior.
- Influencer/seat highlight module on Home.

Differences:

- Current Home now follows the prototype's visible section structure while remaining less image-heavy than the prototype.
- Current Home now has lightweight detail drill-in for top offer and promotion/ad content, but not full prototype carousel/detail parity.
- Current Home keeps fake/demo data behind data sources, while the prototype screenshots appear fully static.

Decision:

- Acceptable for MVP and deeper walkthrough after Prompt 16 if Home is presented as scoped content discovery.
- Should be improved soon if the client expects the exact prototype Home hierarchy, carousel behavior, and sticky contact/location treatment.

Priority:

- P1: richer Home visual hierarchy/carousel parity and chat/notification badge entry points.
- P2: full story player and additional ad/seat highlights.

## Services

Prototype sections found:

- Services category grid with large image cards.
- Category drill-down screens with smaller image cards.
- Service listing screen with search, sort/filter buttons, favorite/share icons, image-led service cards, provider info, ratings, distance/date chips, service tags, verified/best-price chips.
- Service detail screens with hero image, provider card, rating, description, tags, promo code, valid-until, location, terms, sticky Location and Contact actions.

Current Flutter sections implemented:

- Services screen with title/subtitle.
- Category grid first.
- Search field after categories.
- Service listing cards.
- Lightweight `/services/:id` service detail screen.
- Service detail contact section with safe Contact provider, Open chats, and View provider profile actions.
- API-backed repository/data source with mock fallback.
- Loading, empty, error, retry, and refresh states.

Missing sections:

- Sticky Location action or map launch.
- Real contact/chat-room creation tied to the provider.
- Sort/filter controls.
- Favorite/share actions.
- Ratings/reviews, intentionally hidden for MVP.
- Promo code, terms, and best price when unavailable from API.
- Image-heavy category artwork matching the static prototype.

Differences:

- Current Services is listing/contact only and intentionally avoids purchase/order/checkout.
- The prototype has a stronger sticky location/contact treatment and richer service metadata than the current MVP detail screen.

Decision:

- Acceptable for MVP after Prompt 15. The detail/contact flow now exists, while sticky map/location behavior and advanced actions remain future scope.

Priority:

- P1: improve location/contact behavior if the client expects map launch or provider-specific chat-room creation.
- P2: ratings, favorites, share, promo-code detail, and advanced filters unless backend contracts confirm them.

## Seats / Influencer

Prototype sections found:

- Influencer tab with search.
- Gold/Silver/Bronze seat legend.
- Dense seat grid with occupied profile seats and empty "Place Your Seat" cells.
- Tier explanation bottom sheets for Bronze, Silver, and Gold.
- "Book Now" action.
- Checkout screen with cardholder name, card number, expiry, CVV, and Pay Now.

Current Flutter sections implemented:

- Seats screen with client-facing Influencer Seats header.
- Dense visibility grid with occupied profile seats and empty "Place Your Seat" cells.
- Occupied influencer preview bottom sheet.
- Available seat detail bottom sheet.
- Demo checkout preview with cardholder/card/expiry/CVV fields.
- Gold/Silver/Bronze tier explanation.
- Gold/Silver/Bronze tier filtering.
- Seat cards with tier/status/price/currency.
- Safe booking notice and login-required behavior.
- Repository/data source supports `POST /seats/:id/book` and parses checkout/session fields defensively.
- Checkout preview is UI-only and does not process payment.
- Loading, empty, error, retry, refresh, and booking state handling.

Missing sections:

- Exact 1:1 prototype grid artwork and animation.
- Real checkout/payment processing.

Differences:

- Current screen is safer and more backend-aligned for MVP because booking requires auth and payments are deferred.
- Bottom navigation now uses the visible label `Influencer`; backend route naming remains `/seats`.
- Current grid is closer to the old prototype concept, but still uses the approved premium PROMOO design.
- Prototype shows a payment flow; current app shows a safe checkout preview only.

Decision:

- Acceptable for MVP if explained as "Influencer Seats" with booking gated until Auth/payment hardening.
- Prompt 17 addressed the page-level visual expectation, and the final pre-client Step 4 patch added occupied/open seat bottom sheets plus a checkout preview while keeping the route as `/seats`.

Priority:

- P1: validate with the client whether the visible `Influencer` label should remain for release while backend naming stays `/seats`.
- P2: real checkout/payment processing remains deferred until Stripe/payment scope.

## Cup / Leaderboard

Prototype sections found:

- Leaderboard list with rank labels, avatars, account type, short bio, and follower counts.
- Premium rank treatments for top positions.
- Header with logo and chat/notification badges.
- Screens in this folder also include profile media grid, story/video viewer, and chat conversation, which appear to be related flows from ranked profiles rather than the leaderboard list itself.

Current Flutter sections implemented:

- Cup screen using `GET /leaderboard`.
- Top 3 podium/highlight section.
- Ranked profile list.
- Clickable podium and ranked cards that open `/profiles/:id`.
- Profile name, account type, bio/metadata, and follower count handling.
- Loading, empty, error, retry, and refresh states.

Missing sections:

- Header chat/notification badges on Cup.
- Direct chat start from leaderboard cards.

Differences:

- Current Cup uses a podium plus ranked list, while the prototype uses large stacked ranking cards.
- Current implementation is backend-aligned and now supports profile detail tap-through for the client walkthrough.

Decision:

- Acceptable for MVP. The leaderboard purpose is represented clearly.

Priority:

- P2: direct chat entry points from Cup remain deferred.

## Profile + Packages

Prototype sections found:

- Packages screen with Basic, Standard, and Premium package cards, prices in AED, post counts, guarantee copy, and checkout language.
- Edit Profile screen with avatar, follower count, change profile photo, name, bio, location, category, and media/post grid.
- Profile management/settings screen with welcome card, Following, Profile Management, Add New Offer, Saved, MyPackages, Support, language selection, Logout, and footer links.
- Add New AD multi-step flow with progress dots, contact info, posting info, basic ad details, image upload fields, post date, tags, location fields, Back/Next/Create AD actions.
- Media/post grid is visible in the edit/profile area.

Current Flutter sections implemented:

- Profile header with cover/avatar/name/handle/account type/category/location/verified/featured metadata.
- Stats row.
- Follow, Message, and Edit profile safe actions.
- Action notice for login-required or coming-soon behavior.
- About section.
- Media/posts preview grid with fullscreen story-style viewer.
- Profile-tab-only tools preview with Manage profile, Create offers, Saved items, Support, and Language entries.
- Packages section and package cards.
- Public profile route `/profiles/:id`.
- Loading, empty/not-found, error, retry, and refresh states.

Missing sections:

- Full edit profile screen.
- Change profile photo/upload flow.
- Full profile management/settings screen.
- Full Following, Saved, MyPackages, Support, language selection, and Logout menu behavior.
- Add New Offer/Add New AD multi-step flow.
- Package detail/checkout flow.
- Real media engagement persistence and follow/message/contact mutations.

Differences:

- Current Profile is a public profile plus packages display. The prototype also includes account-management and creator/ad-management surfaces.
- Current media/tools areas are a polished preview for client demo, including a story-style media viewer, not production management.
- Current packages are represented as profile services for display/contact only. The prototype treats packages as purchasable cards that lead toward checkout.

Decision:

- Structurally complete for MVP public profile and packages display.
- Partially aligned with the prototype's account-management/profile-owner experience through a preview surface only.
- Edit profile is expected as a separate screen based on the prototype.
- Media/posts are represented as an MVP grid preview with fullscreen viewing; full offers/ad management is not implemented.
- Packages are partially represented: naming, pricing, and card concept align, but package checkout/details are intentionally deferred.
- Follow/message/contact actions are present but safe/deferred, not fully aligned with the prototype's expected interactions.

Priority:

- P1: add package detail/contact behavior if packages are a key demo point.
- P2: full edit profile, uploads, add-ad wizard, settings, saved/following/support/language/logout behavior, and package checkout.

## Login / Register

Prototype sections found:

- Login screen with large PROMOO logo.
- Email and password fields.
- Password visibility icon.
- Forgot password text.
- Apple, Google, and Facebook social buttons.
- Sign Up CTA.

Current Flutter sections implemented:

- Login screen with email/password.
- Register screen with full name, email, password, and account type selector.
- Validation/loading/error/authenticated states.
- In-memory Auth Lite session.
- No Facebook login, matching MVP decision.

Missing sections:

- Apple/Google/Facebook social login buttons.
- Visual layout is not a 1:1 match to the prototype login card.
- Forgot-password flow is not implemented.

Differences:

- Current auth is scoped to email Auth Lite only.
- Facebook login is explicitly removed from MVP.

Decision:

- Acceptable for MVP. Register has no prototype screenshot but is necessary for Auth Lite.

Priority:

- P1: tune login visual layout only if the demo expects close prototype parity.
- P2: forgot password and non-Facebook social providers after auth scope expands.
- Not planned: Facebook login for MVP.

## Search

Prototype sections found:

- Search appears inside Services and Influencer pages.
- No dedicated global search screenshot was found.

Current Flutter sections implemented:

- Dedicated global Search screen.
- Query input.
- Horizontally scrollable filters for all/profiles/services/offers/ads/influencers.
- Mixed result cards.
- Profile result navigation to `/profiles/:id`.
- Loading, idle, empty, error, retry, and refresh states.

Missing sections:

- Dedicated prototype reference for the global Search screen.
- Sort/filter controls like the Services prototype listing.

Differences:

- Current Search is broader than the prototype evidence.

Decision:

- Acceptable. The global Search screen supports MVP discovery and does not conflict with the prototype.

Priority:

- P2: align advanced filters with backend-supported parameters after search UX is finalized.

## Chat

Prototype sections found:

- Chat conversation screenshot with incoming/outgoing bubbles, message input, and yellow send/action styling.
- Chat access is also implied by header badge icons.

Current Flutter sections implemented:

- Chat list screen.
- Chat room screen.
- Message bubbles.
- Message input.
- Mock-mode send behavior.
- Auth-required real-mode state.
- Loading, empty, error, retry, and refresh states.

Missing sections:

- Direct start-chat with a specific profile.
- Header chat badges in shell screens.
- Realtime transport.

Differences:

- Current Chat is a skeleton slice with REST/mock behavior, not full realtime.

Decision:

- Acceptable for MVP skeleton and mock walkthrough.

Priority:

- P1: profile-specific chat start when profile actions are expanded.
- P2: realtime, media messages, and production notification integration.

## Notifications

Prototype sections found:

- Notification bell badges are visible in multiple screenshots.
- No standalone notifications list screenshot was found.

Current Flutter sections implemented:

- Notifications screen.
- Notification cards.
- Unread indicators.
- Mark all read.
- Delete action.
- Message notification navigation to chat room when room id is available.
- Auth-required real-mode state.
- Loading, empty, error, retry, and refresh states.

Missing sections:

- Prototype-specific standalone notification layout.
- Push token/permission flow.

Differences:

- Current Notifications screen is an MVP skeleton built from backend contracts rather than old prototype screenshots.

Decision:

- Acceptable.

Priority:

- P2: push notifications and final notification UX after Firebase/production scope.

## Main matches

- Black/yellow premium visual direction is consistent.
- Bottom navigation covers the same core product areas and now uses `Influencer` for the `/seats` tab.
- Home primary demo surface includes Stories, Top Offers, For You, and Promoo of the Day.
- Services supports category-first discovery, search, and listings.
- Cup supports ranked profiles.
- Seats supports Gold/Silver/Bronze tiers and AED pricing.
- Profile includes identity, stats, actions, about content, and packages.
- Login supports email/password and sign-up navigation.
- Chat and notification surfaces exist for demo skeleton coverage.

## Main gaps

- Full story viewer is not implemented.
- Influencer/Seats grid is now represented in lightweight MVP form, but not as a full prototype clone with avatar-filled cells.
- Profile-owner screens are still preview-only: full edit profile, management/settings, add new ad/offer, saved/following/support/language/logout behavior are not implemented.
- Profile media/posts grid now exists as an MVP preview.
- Package checkout/detail flow is not implemented.
- Header chat/notification entry points are present on Home and existing Chat/Notifications routes remain available.
- Social login provider visuals are present as safe coming-soon actions; approved real provider auth remains later scope.

## Prompt 20 section alignment addendum

- `docs/prototype_section_contract.md` records the current visible-section decisions and Prompt 21 final QA result.
- The new build preserves the approved premium visual design while aligning visible page sections with the original prototype structure.
- Extra Home discovery sections are hidden from the primary demo surface rather than removed from feature code.
- Services now leads with categories, and the `/seats` tab is labeled `Influencer` for the client-facing walkthrough.
- Prompt 21 confirms Home has distinct Stories, Top Offers, For You, and Promoo of the Day sections, and Profile packages appear before media/tools/about-details.

## Recommended changes

P0 before client demo:

- None identified, assuming the demo is framed as the scoped MVP.

P1 soon:

- Improve service detail Location/Contact behavior if a map action or provider-specific chat-room creation becomes part of the demo scope.
- Improve Home visual hierarchy/carousel parity and sticky map/contact behavior if the client expects closer prototype matching.
- Add package detail/contact behavior without checkout unless payments are explicitly scoped.
- Add profile-card navigation from Cup ranked rows if expected in walkthrough.

P2 later/backlog:

- Native splash and launcher icons.
- Story full-screen player.
- Favorites/saved/share actions.
- Full edit profile and upload flows.
- Add New AD / Add New Offer multi-step wizard.
- Package checkout, Stripe/payment flow, and orders.
- Realtime chat, push notifications, and production notification permissions.
- Forgot password and approved social login providers.
- Settings/support/language screens and final localization.

## Validation

- No Flutter build, analyze, test, or format command was run for this audit because the prompt requested documentation-only work and no Flutter files were changed.
- Sticky Location/map action and provider-specific chat-room creation are not implemented.
- Full prototype Home carousel/page-dot visual treatment and sticky map/contact behavior are not implemented.
