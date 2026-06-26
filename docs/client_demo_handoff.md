# Promoo client demo handoff

Last updated: 2026-06-26

## Demo positioning

This is a mock-mode MVP demo for the client walkthrough. It is focused on UI/UX, product flow, visual direction, and the scoped marketplace/social app experience.

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

## Recommended client demo flow

| Step | Screen | What to show |
| --- | --- | --- |
| 1 | Splash | Show the PROMOO logo, premium dark/yellow direction, and enter the app. |
| 2 | Home | Show discovery sections: stories, categories, services, offers, and featured profiles. |
| 3 | Home offer/ad detail | Open a top offer or promotion and show the lightweight detail/contact flow. |
| 4 | Services | Show service search, categories, listing cards, prices, and provider context. |
| 5 | Service detail/contact | Open a service detail and show Contact provider, Open chats, and View provider profile. |
| 6 | Search | Search for `studio` or `content`, switch filters, and open a result. |
| 7 | Profile | Show profile identity, stats, about, packages, and safe profile actions. |
| 8 | Profile media/tools preview | Show media posts and Profile tools: Manage profile, Create offers, Saved items, Support, and Language. |
| 9 | Influencer Seats | Open Seats, present it as Influencer Seats, and show visibility grid plus Gold/Silver/Bronze placement. |
| 10 | Cup / Leaderboard | Show top 3 profiles and the ranked list. |
| 11 | Login/Register | Show email login and account-type registration flow. |
| 12 | Chat | Open Chats, enter a conversation, and send a demo message. |
| 13 | Notifications | Show unread notifications, mark-all-read, delete, and message notification navigation. |

## Known limitations

- Real payments are not enabled in the app demo.
- Real seat booking requires the Auth/payment phase.
- Uploads and edit profile are preview-only in this handoff.
- Realtime chat is pending.
- Push notifications are pending.
- Secure token persistence is pending.
- Store release work is pending.
- Backend integration hardening is the next phase.

## Final QA checklist

- [ ] App launches successfully.
- [ ] Mock mode is enabled with `PROMOO_USE_MOCKS=true`.
- [ ] All main tabs open: Home, Services, Cup, Seats, and Profile.
- [ ] Home detail opens from an offer or promotion.
- [ ] Service detail opens and contact actions are client-friendly.
- [ ] Search works with demo queries such as `studio` or `content`.
- [ ] Profile displays media and Profile tools preview.
- [ ] Seats shows the Influencer Seats presentation.
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
