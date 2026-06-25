# Post-Launch Operations Pack

Use this after release or when preparing rollout, monitoring, support, and hotfix workflow.

## Observability baseline

- Crash reporting: Crashlytics or Sentry with PII redaction.
- Analytics: event taxonomy focused on activation, retention, conversion, and errors.
- Logging: levels, redaction, sampling, and correlation IDs when backend exists.
- Remote config: feature flags and kill switches for risky features.
- Release health dashboard: crash-free users, ANR/freezes, startup time, purchase failures, API error rates.

## Rollout gates

Before wider rollout:

- Internal testing smoke passes.
- Crash-free threshold acceptable.
- No severe backend or purchase errors.
- Store listing and privacy declarations verified.
- Support channel ready.

## Hotfix protocol

1. Triage severity and affected versions.
2. Create hotfix branch.
3. Add regression test if feasible.
4. Build and smoke test.
5. Submit expedited review only when platform criteria are met.
6. Merge fix back to main and update postmortem.

## Feedback loop

- Review store reviews and support tickets weekly after launch.
- Convert repeated complaints into backlog items.
- Track feature requests separately from bugs.
- Keep release notes user-facing and honest.
