# Product-to-App Blueprint

Use this before coding a new app, major feature, rebuild, or launch plan.

## Required discovery

Capture or infer these fields. If data is missing, use explicit assumptions and mark them as placeholders:

- App name, one-sentence promise, primary user, secondary users.
- Problem, current alternatives, user motivation, success metric.
- MVP scope, v1 scope, later scope.
- Platforms: Android, iOS, web, tablet, desktop.
- Business model: free, freemium, subscription, one-time purchase, ads, marketplace fees.
- Data sensitivity: public, account data, personal data, health, finance, children, UGC, AI-generated content.
- Backend choice: Firebase, Supabase, REST, GraphQL, custom, local-only.
- Store category, geography, age rating expectations, and compliance risks.

## Deliverables

Produce these files for new apps:

- `docs/product/PRD.md`
- `docs/product/USER_STORIES.md`
- `docs/product/MVP_SCOPE.md`
- `docs/product/NAVIGATION_MAP.md`
- `docs/product/DATA_MODEL.md`
- `docs/product/STORE_POSITIONING.md`
- `docs/product/RISKS_AND_ASSUMPTIONS.md`

## PRD template

```markdown
# Product Requirements Document

## Summary
[What the app does and for whom]

## Goals and non-goals
- Goal:
- Non-goal:

## Users and roles
| Role | Capabilities | Restrictions |
|---|---|---|

## Core journeys
1. [Journey]

## MVP features
| Feature | User value | Acceptance criteria | Dependencies |
|---|---|---|---|

## Data and privacy
| Data type | Source | Purpose | Storage | Shared with | Store declaration needed |
|---|---|---|---|---|---|

## Metrics
- Activation:
- Retention:
- Revenue:
- Quality:

## Launch criteria
- QA:
- Performance:
- Security/privacy:
- Store readiness:
```

## Feature slicing rules

- Slice by user outcome, not by technical layer.
- Define acceptance criteria before implementation.
- Include loading, empty, error, offline, permission, unauthenticated, and success states.
- Put risky integrations behind interfaces so they can be mocked and replaced.
- Treat store metadata and screenshots as product requirements, not afterthoughts.
