# Promoo client demo handoff

Last updated: 2026-07-02

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

Latest verified client-review build on 2026-07-02:

- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` - recommended for most modern Android phones.
- `build/app/outputs/flutter-apk/app-release.apk` - universal fallback when the device architecture is unknown.
- Both builds were generated with `--dart-define=PROMOO_USE_MOCKS=true`.
- Previous ARM64 APK device sanity checks covered launch and guest access on Android 13 device `M2012K11AG`.
- The final patch APKs were generated successfully; local final install on `M2012K11AG` was blocked by Android with `INSTALL_FAILED_USER_RESTRICTED`.

See `docs/client_apk_review_checklist.md` before sending the APK.

## Recommended client demo flow

| Step | Screen | What to show |
| --- | --- | --- |
| 1 | Launch intro | Show the animated logo-only PROMOO reveal and warm yellow glow, then let it continue to Login automatically. |
| 2 | Login/Register | Show the clean PROMOO logo, email auth, safe social visuals, and `Continue as Guest` for walkthrough browsing. |
| 3 | Home | Show Stories, Top Offers swiper with See All, For You, Promoo of the Day, compact Services swiper, and the header Chat/Notifications entry points. |
| 4 | Story viewer | Tap a story and show multiple story items for the same owner before the viewer advances to the next owner. |
| 5 | Home offer/ad detail | Open a top offer or promotion and show the lightweight detail/contact flow. |
| 6 | Services | Show image-led service categories first, then search by service/category/provider and the clear no-match message. |
| 7 | Service detail/contact | Open a service detail and show Contact provider, Open chats, and View provider profile. |
| 8 | Search | Optionally search for `studio`, `launch`, `cafe`, or `spotlight`, switch filters, and open a result. |
| 9 | Profile | Show own-profile identity, Followers/Likes/Posts/Views, Edit Profile, Packages, and media without Follow/Message self-actions. |
| 10 | Profile menu/media | Show the Profile menu for View Profile, Saved, Language, Theme Mode preview, Support, and Logout preview, then open a media post if useful. |
| 11 | Influencer Seats | Open the Influencer tab, tap an occupied creator seat for the influencer preview, then tap an open seat to show the booking preview and checkout preview. |
| 12 | Promoo / Leaderboard | Tap the footer `P` / `Promoo` tab, show top 3 profiles, tap a ranked profile, and show that it opens the public profile page. |
| 13 | Chat | Open Chats, enter a conversation, and send a short inquiry message. |
| 14 | Notifications | Show unread notifications, mark-all-read, delete, and message notification navigation. |

## Known limitations

- Real payments are not enabled in the app demo.
- Influencer seat checkout is a preview only; real seat booking requires the Auth/payment phase.
- Uploads and edit profile are preview-only in this handoff.
- Profile media engagement actions are visual preview affordances only.
- Profile menu actions and Light Mode are session-only client-review previews.
- Black/Light mode controls are visual-only in this handoff and keep the approved dark PROMOO theme.
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
- [ ] Logo-only launch intro automatically opens Login/Register, not Home directly.
- [ ] Mock mode is enabled with `PROMOO_USE_MOCKS=true`.
- [ ] All main tabs open: Home, Services, Promoo, Influencer, and Profile.
- [ ] Profile footer icon opens the Profile menu and View Profile remains available.
- [ ] Home story viewer opens and closes cleanly with X and swipe-down.
- [ ] Top Offers, For You, Promoo of the Day, and Services use image-first presentation.
- [ ] Home See All actions do not crash and use client-safe copy.
- [ ] Home detail opens from an offer or promotion.
- [ ] Services categories use images and search shows results/no-match copy.
- [ ] Service detail opens and contact actions are client-friendly.
- [ ] Search works with demo queries such as `studio`, `launch`, `cafe`, or `spotlight`.
- [ ] Own Profile displays media/packages without Follow, Message, or Profile Tools on the page.
- [ ] Profile menu displays the client-review tools and Theme Mode preview.
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
