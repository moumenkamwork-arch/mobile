# Release Runbook

Use this runbook for every production or store-facing release.

## 1. Pre-release freeze

- Confirm scope and release owner.
- Confirm no critical bugs remain open.
- Confirm dependencies and SDK privacy impact are reviewed.
- Confirm feature flags and remote config defaults.
- Confirm localization, accessibility, and device matrix coverage.
- Confirm release notes and store metadata draft.

## 2. Build preparation

- Bump version and build number.
- Run code generation.
- Run format/analyze/tests.
- Run platform builds for target stores.
- Confirm signing is handled by approved local/CI secrets, not committed files.
- Confirm app icons, launch screens, package IDs, and bundle IDs.

## 3. QA gates

- Smoke test primary flows.
- Test fresh install and upgrade.
- Test offline/slow network.
- Test auth/session expiry.
- Test payments/subscriptions if relevant.
- Test push/deep links if relevant.
- Test AR/EN and RTL if supported.
- Test accessibility basics.

## 4. Store submission

- Refresh official Apple/Google/Flutter requirements.
- Complete privacy labels/Data Safety based on actual SDK/data inventory.
- Add review notes and demo credentials when needed.
- Upload screenshots and metadata.
- Submit to TestFlight/internal/closed testing before production.

## 5. Production rollout

- Prefer staged rollout for non-trivial apps.
- Monitor crash-free sessions, ANRs, startup failures, purchase failures, login errors, and support tickets.
- Expand rollout only if release health is acceptable.

## 6. Hotfix/rollback

- Identify severity and affected versions.
- Disable via feature flag if possible.
- Prepare hotfix branch.
- Run focused regression tests.
- Submit expedited review only when justified.
- Write post-incident note and update `LESSONS_LEARNED.md`.
