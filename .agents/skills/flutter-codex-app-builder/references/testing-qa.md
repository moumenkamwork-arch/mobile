# Testing and QA Automation Pack

Use this for test planning, CI gates, release hardening, and regression prevention.

## Test pyramid

- Unit tests: domain rules, value objects, mappers, use cases, failure mapping.
- Repository tests: remote/local data source behavior with fakes.
- Controller/provider tests: state transitions and error handling.
- Widget tests: screens, forms, navigation, empty/loading/error states.
- Golden tests: stable visual components and screenshot-critical pages.
- Integration tests: core user journeys, auth, purchase, deep links, offline flows.
- Manual QA: device matrix, store review scenarios, accessibility, performance smoke.

## Required feature test cases

For each feature:

- Happy path.
- Loading state.
- Empty state.
- Recoverable error with retry.
- Offline/network unavailable state.
- Permission denied or unauthenticated state when relevant.
- Validation failure.
- Analytics/event capture if used.
- Accessibility labels for important controls.

## Release QA matrix

| Area | Checks |
|---|---|
| Smoke | App starts, login/demo mode works, core journey completes. |
| Devices | Small phone, large phone, tablet if supported, dark/light mode. |
| Network | Offline, slow network, timeout, retry, refresh token. |
| Localization | Supported locales, fallback locale, long text, RTL if Arabic/Hebrew. |
| Accessibility | Text scaling, screen reader labels, contrast, focus order. |
| Store review | Demo account, review notes, backend live, no placeholders. |

## Coverage policy

Do not chase coverage blindly. Require tests around business logic, risky integrations, and store-critical flows before release.
