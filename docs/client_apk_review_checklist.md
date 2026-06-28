# Promoo client APK review checklist

Last updated: 2026-06-27

## Purpose

This checklist is for the client-review Android APK. The build is for UI/UX and flow approval, using fictional demo content that can be replaced by backend data in the production integration phase.

This is not a store release or production backend/payment build.

## APK build commands

Build split APKs for each Android ABI:

```powershell
flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true
```

Optional universal APK:

```powershell
flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true
```

Do not build or send the client review APK without:

```powershell
--dart-define=PROMOO_USE_MOCKS=true
```

## Which APK to send

Split-per-ABI creates smaller APKs:

- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

For most modern Android phones, send:

- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

If the client device architecture is unknown, send the universal APK instead:

- `build/app/outputs/flutter-apk/app-release.apk`

The universal APK is larger but safer when the target device is unknown.

## How to find output files

After a successful build, open:

```powershell
build/app/outputs/flutter-apk/
```

## App name verification

- [ ] App installs with the name `Promoo`.
- [ ] App does not appear as `promoo_app`.
- [ ] App does not appear as `Flutter app`.
- [ ] App does not show a technical/internal label.

## Launcher icon verification

- [ ] Launcher icon appears as a PROMOO black/yellow icon.
- [ ] Icon is not the generic Flutter icon.
- [ ] Icon is readable at small launcher size.
- [ ] Icon is not blank, broken, or badly cropped.
- [ ] Temporary client-review icon is acceptable for this review build and can be replaced later by final brand exports.

## Mock mode verification

- [ ] APK was built with `PROMOO_USE_MOCKS=true`.
- [ ] App opens to the premium intro.
- [ ] `Enter Promoo` opens Login/Register.
- [ ] Login/Register does not show a network error by default.
- [ ] A valid email/password login works in the review APK.
- [ ] Home, Profile, Cup, Influencer, Search, Chat, and Notifications use demo data safely.

Suggested review login:

- Email: `demo@promoo.app`
- Password: `promoo123`

Any valid-looking email and non-empty password should work for login in the mock-mode review build.

## Main flow check

- [ ] Home loads rich demo content.
- [ ] Stories open and close.
- [ ] Top Offers swiper works.
- [ ] For You swiper works.
- [ ] Promoo of the Day appears with image/fallback.
- [ ] Home Services swiper works.
- [ ] Cup top 3 and ranking cards render.
- [ ] Cup profile cards open public Profile.
- [ ] Profile media grid renders.
- [ ] Profile media viewer opens and the engagement overlay is readable.
- [ ] Influencer grid cards fit on the target Android device.
- [ ] Occupied influencer bottom sheet opens.
- [ ] Available seat bottom sheet opens.
- [ ] Checkout preview opens.
- [ ] Chat and Notifications entry points open if shown during the walkthrough.
- [ ] Bottom navigation does not cover important content.

## Visual/copy check

- [ ] No obvious overflow or clipped text.
- [ ] No broken image states are obvious; fallbacks look polished.
- [ ] No empty black image states in normal walkthrough.
- [ ] No duplicate currency text such as `AED AED`.
- [ ] AED display is consistent.
- [ ] No placeholder/test/mock wording is visible in the app UI.
- [ ] No technical backend wording is visible in the app UI.
- [ ] No active-looking dead buttons are shown.

## Known limitations

- This is a review build for UI/UX and product-flow approval.
- Real payment activation is a later production phase.
- Real booking activation is a later production phase.
- Real backend data replacement is a later production phase.
- Real uploads and edit profile are later production work.
- Realtime chat and push notifications are later production work.
- Store release signing, metadata, and policy checks are later release work.

## Validation before sending

Run:

```powershell
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --release --split-per-abi --dart-define=PROMOO_USE_MOCKS=true
```

Optional:

```powershell
flutter build apk --release --dart-define=PROMOO_USE_MOCKS=true
```
