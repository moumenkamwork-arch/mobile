# Promoo client walkthrough checklist

Last updated: 2026-06-26

## Goal

Use this checklist to run the Flutter MVP in mock mode for a client walkthrough. Mock mode uses feature fake data sources behind repositories and does not require `../promo_backend`.

Do not present this as production-ready. This is a demo build for product flow, visual direction, and MVP scope alignment.

For APK handoff, also use `docs/client_apk_review_checklist.md`. The client APK must be built with `--dart-define=PROMOO_USE_MOCKS=true`.

## Mock mode run commands

Mock mode is enabled through Dart defines:

```powershell
flutter run --dart-define=PROMOO_USE_MOCKS=true
```

Current device check on this machine showed:

- Android device: `edba8ffc` (`M2101K6G`, Android 13)
- Web: `edge`
- Desktop: `windows`
- Available Android emulator: `Pixel_8`

Run on Microsoft Edge:

```powershell
flutter run -d edge --dart-define=PROMOO_USE_MOCKS=true
```

Run on Chrome if `flutter devices` lists `chrome`:

```powershell
flutter run -d chrome --dart-define=PROMOO_USE_MOCKS=true
```

Run on the connected Android device:

```powershell
flutter run -d edba8ffc --dart-define=PROMOO_USE_MOCKS=true
```

Run on the Pixel 8 emulator:

```powershell
flutter emulators --launch Pixel_8
flutter devices
flutter run -d <emulator-device-id> --dart-define=PROMOO_USE_MOCKS=true
```

Optional desktop smoke run:

```powershell
flutter run -d windows --dart-define=PROMOO_USE_MOCKS=true
```

## Suggested client demo flow

1. Splash: start at `/`, show the logo-only Promoo intro and let it continue to Login automatically.
2. Home: show the premium dark/yellow style, categories, services, promotions, featured profiles, and search entry.
3. Services: open the Services tab, show category chips, service cards, and search.
4. Cup: open the Cup tab, show the top 3 podium and ranking list.
5. Seats: open Seats, present the page as Influencer Seats, show the visibility grid, Gold/Silver/Bronze tiers, and safe login-required booking behavior.
6. Profile: open Profile, show own-profile header, stats, packages, media grid, and the safe Edit Profile preview without Follow/Message self-actions.
7. Search: open Search, try `studio`, `launch`, `cafe`, or `spotlight`, switch filters, and tap a result.
8. Login: open Login. For mock mode use a valid email such as `alya@promoo.app` and `password123`.
9. Register: show account type selection. For mock mode use any valid email and password of at least 8 characters.
10. Chats: open Chats, select `Saffron Social Studio`, and send a short inquiry message.
11. Notifications: open Notifications, show unread states, mark all read, and open a message notification.

## Screen walkthrough checklist

| Screen | Route | Walkthrough check | QA result |
| --- | --- | --- | --- |
| Splash | `/` | Logo-only intro renders and automatically opens Login/Register, not Home. | Automated route smoke passed. |
| Home | `/home` | Dark/yellow style, no dead CTA, demo sections render. | Automated route smoke passed; disabled highlight CTA removed. |
| Services | `/services` | Categories, search field, cards, price/currency, empty/error coverage in tests. | Automated route smoke passed. |
| Cup / Leaderboard | `/cup` | Podium and ranked list render with realistic demo profiles. | Automated route smoke passed. |
| Seats | `/seats` | Influencer Seats header, visibility grid, tier explanation, statuses, AED pricing, login-required booking notice. | Automated route smoke passed. |
| Profile | `/profile` | Own profile renders packages, media grid, stats, and Edit Profile without Follow, Message, or Profile Tools on the page. | Automated route smoke passed. |
| Public profile | `/profiles/saffron.social` | Public profile detail route renders profile content without owner tools. | Automated route smoke passed. |
| Search | `/search` | Idle state is clear; use `studio`, `launch`, `cafe`, or `spotlight` for demo results. | Automated route smoke passed. |
| Login | `/login` | Email/password form, validation, mock sign-in. | Automated route smoke passed. |
| Register | `/register` | Email registration form and account type selector. | Automated route smoke passed. |
| Chats | `/chats` | Demo rooms render in mock mode. | Automated route smoke passed. |
| Chat room | `/chats/chat-room-1` | Conversation renders and fake send works in mock mode. | Automated route smoke passed. |
| Notifications | `/notifications` | Demo notifications render; mark-read/delete actions are available. | Automated route smoke passed. |

## QA focus during live walkthrough

- Watch for text overflow on small Android screens.
- Check bottom navigation labels and icon tap targets.
- Confirm every visible CTA either navigates, mutates mock state, or clearly explains the limitation.
- Check that loading, empty, error, retry, and auth-required states use Promoo shared components.
- Keep an eye on image/avatar fallbacks, because demo data often omits remote image URLs.
- Use only mock/demo accounts and no real client data.

## Android walkthrough fixes applied

- Long shell pages have extra bottom scroll clearance above the bottom navigation.
- Services and Profile package demo prices use AED consistently.
- Search filters are horizontally scrollable and keep the selected filter in view.
- Chat room input adds extra spacing above the keyboard.
- Leaderboard profile cards give profile names more horizontal space.
- Splash content is slightly above center for better visual balance.
- Seats now presents the client-facing Influencer Seats concept with a compact visibility grid and Gold/Silver/Bronze tier explanation while the visible bottom tab is Influencer.
- Profile now includes a media/posts preview grid, and profile-owner tools live in the Profile menu instead of the profile page.

## Known limitations

- Mock mode is demo-only and must not be treated as production data.
- Auth Lite stores sessions in memory only.
- Services and profile packages are display/contact only; no purchase flow exists.
- Seat booking does not open checkout in the app.
- The bottom navigation label is Influencer for the client walkthrough; the route/backend naming remains `/seats`.
- Profile follow/edit actions do not mutate backend state yet.
- Profile media and Profile menu tools are client demo previews. Real edit submission, avatar/cover/media uploads, add-ad wizard, settings, saved/following, support, language persistence, and production logout remain pending.
- Profile-specific chat start is not implemented; the Profile Message action opens the chat inbox.
- Chat is REST/fake-mode ready for demo, but production realtime is not implemented.
- Push notification setup, device token collection, and background handlers are not implemented.
- Arabic localization files, full RTL QA, text-scale matrix QA, and store screenshots remain pending.

## Pending production items

- Secure token storage and auth hardening.
- Production API configuration and mock-disable strategy.
- Device matrix QA across Android, iOS, web, and text scaling.
- Full Arabic/English localization and RTL pass.
- Push notifications, realtime chat decision, uploads, payments, orders, subscriptions, and store readiness.
- Full profile owner tools: edit submission, uploads, add-ad wizard, saved/following/support/language screens, and production logout.
- Privacy/data inventory and release runbook.

## SVG warning note

The supplied brand SVG files contain CSS `<style>` / `class` usage. `flutter_svg` renders them, but tests print a non-fatal warning:

```text
unhandled element <style/>; Picture key: Svg loader
```

This is non-blocking for the walkthrough. Prefer clean flattened SVG exports before native launcher icon, splash tooling, or store screenshot finalization.

## Validation commands

Run these before a walkthrough:

```powershell
flutter pub get
dart format .
flutter analyze
flutter test
```

Focused walkthrough route simulation:

```powershell
flutter test test\routing\app_routes_smoke_test.dart
```
