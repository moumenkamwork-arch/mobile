# Flutter delivery checklist

Use this before final delivery of app-building, feature, refactor, or review work.

## Architecture

- Feature boundaries are clear and consistent with the repo.
- Domain code does not import Flutter, Dio, Firebase, storage, or widget packages.
- Data layer maps DTOs/exceptions to domain entities/failures.
- Providers are specific, testable, and not global mutable singletons.
- Routing is centralized and deep-link friendly where relevant.

## UI/UX

- Loading, empty, error, success, retry, and offline states are handled.
- Layout responds to small phones, tablets, web widths, landscape, and text scaling as relevant.
- Widgets have semantic labels for important controls and images.
- Theme tokens are used instead of hardcoded styling where possible.

## Reliability and performance

- Async work is cancellable or stale-safe where needed.
- Large lists use builders, pagination, or virtualization.
- Expensive computation is not performed in `build`.
- Network calls have timeouts and useful failure mapping.
- Secrets and PII are not logged or committed.

## Tests

- Unit tests cover domain rules and repository mapping.
- Provider/controller tests cover success and failure.
- Widget tests cover key states.
- Navigation/auth tests exist for guarded flows.
- Existing tests still pass or failures are reported truthfully.

## Validation commands

Prefer running these, adapting to the repo's scripts:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
dart analyze
flutter test
```

In the final response, include exact commands run and whether each passed, failed, or was skipped.
