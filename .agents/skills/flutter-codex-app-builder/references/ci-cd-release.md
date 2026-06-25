# CI/CD and Release Engineering Pack

Use this for release automation, flavors, signing, versioning, build gates, and team workflow.

## Environment strategy

Use three default environments unless the repo has stronger conventions:

- `dev`: local development, mock/test services allowed.
- `staging`: production-like backend, internal QA/TestFlight/internal testing.
- `prod`: production backend and store releases.

## Versioning

- Use semantic app version where practical: `MAJOR.MINOR.PATCH`.
- Increment Android `versionCode` and iOS build number for every upload.
- Keep changelog entries tied to user-visible changes.
- Tag releases consistently: `android-v1.2.3+45`, `ios-v1.2.3+45`, or unified tags.

## CI gates

Minimum gates:

```bash
flutter pub get
dart format --set-exit-if-changed .
dart run build_runner build --delete-conflicting-outputs # when codegen is used
flutter analyze
flutter test
```

Release gates:

- Android app bundle build.
- iOS build/archive on macOS runner if available.
- Store-readiness checklist generated and reviewed.
- Privacy matrix updated.
- Crash-free smoke test on real devices or store test tracks.

## Secrets and signing

- Never commit keystores, certificates, provisioning profiles, service account JSON, or passwords.
- Use CI secret stores and documented local setup.
- Provide `.env.example`, never `.env` with production values.
- Include manual signing instructions when automation is not configured.

## Branching

Prefer small PRs. Use hotfix branches for emergency releases and merge fixes back to main/develop.
