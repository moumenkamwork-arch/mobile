# Browser E2E Testing for Flutter Web, Admin, and Marketing Surfaces

Use this when the Flutter app includes Flutter Web, an admin portal, a public landing page, checkout hosted in a browser, OAuth flows, or web-based release validation.

## Scope

Browser E2E complements Flutter unit/widget/integration tests. It is not a replacement for mobile integration tests.

Recommended coverage:

- Landing page loads and core CTA works.
- Login/OAuth redirect smoke test with test credentials or mocked auth.
- Admin dashboard navigation and critical forms.
- Checkout/paywall web flow with sandbox products.
- Deep links and universal/app links landing behavior.
- Responsive breakpoints for mobile/tablet/desktop web.
- Accessibility smoke checks for labels, focus order, and keyboard navigation.

## Playwright structure

Suggested files:

```text
e2e/playwright/package.json
e2e/playwright/playwright.config.ts
e2e/playwright/tests/smoke.spec.ts
e2e/playwright/tests/auth.spec.ts
e2e/playwright/tests/responsive.spec.ts
```

## Test data rules

- Use sandbox systems and test users only.
- Never commit real credentials.
- Keep secrets in CI variables.
- Make destructive admin actions use disposable fixtures.

## Validation gates

Before release, run browser E2E when web/admin/checkout exists:

```bash
cd e2e/playwright
npm ci
npx playwright test
```

If Playwright is unavailable, document browser smoke tests manually in `docs/testing/BROWSER_QA.md`.
