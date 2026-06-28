# Promoo client demo handoff

Last updated: 2026-06-27

## Demo positioning

This is a mock-mode MVP demo for the client walkthrough. It is focused on UI/UX, product flow, visual direction, and the scoped marketplace/social app experience.

The new build preserves the approved premium visual design while aligning visible page sections with the original prototype structure.

Mock-mode content is fictional, UAE/GCC-friendly, AED-only, and replaceable by backend data in the next integration phase.

This is not a production backend, payment, realtime, push notification, upload, settings, orders, subscriptions, or store-release build yet.

## Run mock mode

Find available devices:

```powershell
flutter devices
```

Run on Microsoft Edge:

```powershell
flutter run -d edge --dart-define=PROMOO_USE_MOCKS=true
```

Run on Android:

```powershell
flutter run -d <device_id> --dart-define=PROMOO_USE_MOCKS=true
```

## Build client review APK

Build split APKs for client review:

```powershell
flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true
```

Optional universal APK:

```powershell
flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true
```

Use the universal APK when the client device architecture is unknown. For most modern Android phones, `app-arm64-v8a-release.apk` is the expected split APK.

The client APK installs as `Promoo` and uses a temporary black/yellow PROMOO launcher icon prepared from the supplied brand logo. The icon can be replaced later by final production brand exports.

See `docs/client_apk_review_checklist.md` before sending the APK.

## Recommended client demo flow

| Step | Screen | What to show |
| --- | --- | --- |
| 1 | Launch intro | Show the animated PROMOO logo reveal, warm yellow glow, welcome copy, and `Enter Promoo` CTA. |
| 2 | Login/Register | Show that the intro enters the existing email auth flow; Login/Register visuals are intentionally preserved. |
| 3 | Home | Show Stories, Top Offers swiper, For You swiper, Promoo of the Day hero, Services swiper, and the header Chat/Notifications entry points. |
| 4 | Story viewer | Tap a story and show the fullscreen story viewer with progress bars, profile header, image content, and close action. |
| 5 | Home offer/ad detail | Open a top offer or promotion and show the lightweight detail/contact flow. |
| 6 | Services | Show the service category grid first, then listings, search, prices, and provider context. |
| 7 | Service detail/contact | Open a service detail and show Contact provider, Open chats, and View provider profile. |
| 8 | Search | Optionally search for `studio`, `launch`, `cafe`, or `spotlight`, switch filters, and open a result. |
| 9 | Profile | Show profile identity, stats, safe actions, and Packages as the first major content section. |
| 10 | Profile media/tools preview | Show media posts, tap one post to open the fullscreen story-style viewer, then show Profile tools: Manage profile, Create offers, Saved items, Support, and Language. |
| 11 | Influencer Seats | Open the Influencer tab, tap an occupied creator seat for the influencer preview, then tap an open seat to show the booking preview and checkout preview. |
| 12 | Cup / Leaderboard | Show top 3 profiles, tap a ranked profile, and show that it opens the public profile page. |
| 13 | Chat | Open Chats, enter a conversation, and send a short inquiry message. |
| 14 | Notifications | Show unread notifications, mark-all-read, delete, and message notification navigation. |

## Known limitations

- Real payments are not enabled in the app demo.
- Influencer seat checkout is a preview only; real seat booking requires the Auth/payment phase.
- Uploads and edit profile are preview-only in this handoff.
- Profile media engagement actions are visual preview affordances only.
- Mock-mode content is fictional and intended for walkthrough review only.
- Realtime chat is pending.
- Push notifications are pending.
- Secure token persistence is pending.
- Store release work is pending.
- Backend integration hardening is the next phase.

## Final QA checklist

- [ ] App launches successfully.
- [ ] Client APK was built with `PROMOO_USE_MOCKS=true`.
- [ ] App installs as `Promoo`.
- [ ] Launcher icon appears as a black/yellow PROMOO icon.
- [ ] Animated launch intro appears before Login/Register.
- [ ] `Enter Promoo` opens Login/Register, not Home directly.
- [ ] Mock mode is enabled with `PROMOO_USE_MOCKS=true`.
- [ ] All main tabs open: Home, Services, Cup, Influencer, and Profile.
- [ ] Home story viewer opens and closes cleanly.
- [ ] Top Offers, For You, Promoo of the Day, and Services use image-first presentation.
- [ ] Home detail opens from an offer or promotion.
- [ ] Service detail opens and contact actions are client-friendly.
- [ ] Search works with demo queries such as `studio`, `launch`, `cafe`, or `spotlight`.
- [ ] Profile displays media and Profile tools preview.
- [ ] Profile media viewer opens and closes cleanly.
- [ ] Influencer shows the Influencer Seats presentation.
- [ ] Occupied Influencer seat opens an influencer preview bottom sheet.
- [ ] Available Influencer seat opens the checkout preview without processing payment.
- [ ] Cup ranking cards open public profile pages.
- [ ] Chat and Notifications open.
- [ ] No obvious overflow or clipped text appears on the demo device.
- [ ] `flutter test` passes before the walkthrough.

## Validation commands

Run these before handoff:

```powershell
flutter pub get
dart format .
flutter analyze
flutter test
```
