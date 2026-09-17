# Visual Regression and Design QA

Use this guide when the UI must remain stable across releases, themes, devices, or locales.

## Golden testing policy

- Add golden tests for reusable design system components.
- Add screen-level goldens for high-value flows: onboarding, auth, home, checkout, subscription, settings, error states.
- Include light and dark mode when supported.
- Include English and Arabic/RTL when supported.
- Include small and large text scale for accessibility-sensitive screens.
- Do not update golden baselines without reviewing the visual diff.

## Naming convention

```text
test/goldens/<feature>/<screen>_<theme>_<locale>_<size>.png
```

## Design QA checklist

- Tokens used instead of one-off colors/sizes.
- Text hierarchy matches design system.
- Empty/loading/error states exist.
- Components align to spacing grid.
- Touch targets are usable.
- Responsive breakpoints are checked.
- Dark mode is not a simple inversion unless intentionally designed.

## Browser visual QA

For Flutter Web, admin panels, or landing pages, combine Flutter tests with Playwright screenshots for browser-specific layout regressions.
