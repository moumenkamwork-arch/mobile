# Analytics Event Catalog

Use this guide to design privacy-safe telemetry and release health monitoring.

## Principles

- Track product decisions, not private user data.
- Do not log PII, secrets, tokens, exact user content, or sensitive prompts.
- Define events before implementation.
- Use stable names and typed parameters.
- Review SDK data collection for store privacy declarations.

## Event naming

```text
area_action_result
auth_login_succeeded
checkout_purchase_failed
search_query_submitted
ai_response_stream_failed
```

## Core event groups

- App lifecycle: install, first_open, app_update, crash_marker.
- Auth: signup_started, signup_completed, login_failed, logout_completed.
- Onboarding: step_viewed, step_completed, onboarding_completed.
- Navigation: screen_viewed, deep_link_opened.
- Commerce: paywall_viewed, purchase_started, purchase_completed, restore_purchases_completed.
- Search: search_submitted, search_result_opened.
- AI: prompt_submitted, response_completed, moderation_blocked, rate_limit_hit.
- Errors: network_error_shown, permission_denied_shown, unexpected_error_shown.

## Implementation rules

- Create a typed analytics interface in core/infrastructure.
- Inject analytics into controllers/use cases, not widgets directly when business context matters.
- Keep screen tracking centralized when possible.
- Redact or bucket values before logging.
