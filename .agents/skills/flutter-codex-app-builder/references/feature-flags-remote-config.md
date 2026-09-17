# Feature Flags and Remote Config

Use feature flags for staged rollout, experiments, kill switches, and high-risk features.

## Rules

- Every flag must have an owner, purpose, default value, rollout plan, and removal date.
- Safe defaults must live in code so the app works without remote config.
- Do not hide broken architecture behind flags; use flags for release control, not code quality.
- High-risk flags need a kill switch path.
- Do not expose sensitive entitlements only through client-side flags.

## Naming

```text
area_feature_behavior
checkout_new_paywall_enabled
ai_streaming_responses_enabled
onboarding_v2_enabled
```

## Rollout steps

1. Default off in production.
2. Enable for internal users.
3. Enable for small external cohort.
4. Monitor crashes, errors, latency, conversion, and support tickets.
5. Expand gradually.
6. Remove stale flags after rollout completes.

## Flutter implementation

- Isolate remote config behind an interface.
- Cache last known config safely.
- Provide typed accessors.
- Write tests for defaults and overrides.
