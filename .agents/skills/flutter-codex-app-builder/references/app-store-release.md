# App Store and TestFlight Release Pack

Use this before iOS release, TestFlight distribution, or App Store submission.

## Core release checklist

- Apple Developer Program access confirmed.
- Bundle ID registered.
- App Store Connect app record created.
- Display name, SKU, category, age rating, pricing/availability ready.
- Icons and launch screen complete.
- Version and build number incremented.
- Signing/provisioning configured.
- Privacy policy URL ready.
- App privacy details prepared from data inventory, including third-party SDKs.
- Review notes prepared, including demo account or full demo mode when login is required.
- In-app purchases/subscriptions created and reviewable if used.
- TestFlight smoke test completed.
- App Review Guidelines risk checklist reviewed.

## Build commands

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build ipa --release
```

Building and uploading iOS releases requires macOS/Xcode tooling.

## App Review notes template

```markdown
Demo account:
- Username:
- Password:

Review path:
1. Open app.
2. Sign in or use demo mode.
3. Navigate to [core feature].
4. Test [purchase/AI/UGC/location/etc. if applicable].

Non-obvious behavior:
- [Explanation]

Backend/test data:
- [Required data or QR/sample links]
```

## Rejection prevention

- Remove placeholder content, broken links, test labels, debug menus, and incomplete purchase products.
- Ensure backend services are live during review.
- Provide moderation/report/block flows for UGC.
- Use official review prompt APIs; do not force ratings.
- Ensure app provides real native value, not just a thin WebView.
