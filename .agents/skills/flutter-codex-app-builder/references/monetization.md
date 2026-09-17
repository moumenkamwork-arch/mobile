# Monetization Pack

Use this for subscriptions, in-app purchases, ads, freemium limits, trials, paywalls, or marketplace fees.

## Models

- Free: optimize retention and trust.
- Freemium: define clear free limits and upgrade triggers.
- Subscription: define entitlement model, trial, cancellation/renewal states, restore purchases.
- One-time purchase: define owned entitlement and restore behavior.
- Consumables: define balance, fulfillment, refund/retry behavior.
- Ads: define placements, consent, age restrictions, and fallback when ad load fails.
- Marketplace fees: define seller/buyer flows and payout/compliance implications.

## Paywall UX checklist

- Explain value before price.
- Show price, billing period, trial terms, renewal behavior, and cancellation path.
- Include restore purchases.
- Handle pending/cancelled/failed purchase states.
- Keep premium gates consistent with entitlement checks.
- Do not block required legal/privacy/account controls behind payment.

## Entitlement architecture

Keep entitlements behind a service/repository, not scattered through widgets. Cache entitlement state carefully and refresh after purchases, restores, login, and app resume.
