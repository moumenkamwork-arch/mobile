# Google Play Release Pack

Use this before Android release or Play Console submission.

## Core release checklist

- Application ID/package name finalized.
- App name, short description, full description, category, contact details ready.
- Launcher icon and adaptive icon ready.
- Privacy policy URL ready.
- Data safety form prepared from data inventory, including third-party SDK data practices.
- App content declarations completed: ads, target audience, content rating, news/health/financial claims if applicable.
- Permissions reviewed and justified.
- Android target API level meets current Google Play requirements.
- Version name and version code incremented.
- Release notes prepared.
- AAB generated and tested.
- Internal testing completed before production rollout.
- Staged rollout plan defined for risky updates.

## Build commands

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

Preferred Play artifact is an Android App Bundle (`.aab`) for Play distribution.

## Data safety workflow

1. Generate privacy matrix.
2. Review first-party data collection.
3. Review third-party SDK collection/sharing.
4. Compare declared permissions and API usage.
5. Prepare privacy policy URL.
6. Complete Play Console Data safety form.
7. Re-check after adding analytics, ads, payments, AI, crash reporting, auth, or notifications.

## Store listing assets

- App icon.
- Feature graphic.
- Phone screenshots.
- Tablet screenshots if tablet support is claimed.
- Short description.
- Full description.
- Release notes.
- Support email and website.

## Release gates

Do not recommend production rollout until:

- Crash-free smoke tests pass on internal testing.
- No placeholder metadata remains.
- Backend production endpoints are live.
- Account/demo flow is available if login is required.
- Permissions and data declarations match actual behavior.
