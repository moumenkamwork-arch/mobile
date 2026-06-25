#!/usr/bin/env python3
"""Generate a privacy-safe analytics event catalog."""
from __future__ import annotations

import argparse
from pathlib import Path

CATALOG = """# Analytics Event Catalog

## Rules

- Do not log PII, secrets, tokens, exact prompts, or private user content.
- Use typed parameters and stable names.
- Review SDK data collection before store submission.

## Events

| Event | Trigger | Parameters | PII risk | Owner | Status |
|---|---|---|---|---|---|
| app_first_opened | First successful app open | app_version, locale | Low | Product | Draft |
| auth_login_succeeded | User logs in | method | Low | Product | Draft |
| onboarding_completed | User completes onboarding | variant | Low | Product | Draft |
| purchase_completed | Purchase succeeds | product_id, currency_bucket | Medium | Growth | Draft |
| unexpected_error_shown | Generic error shown | area, error_code | Low | Engineering | Draft |

## Funnels

### Onboarding

1. onboarding_started
2. onboarding_step_completed
3. onboarding_completed

### Purchase

1. paywall_viewed
2. purchase_started
3. purchase_completed
4. entitlement_activated
"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Create analytics catalog.")
    parser.add_argument("--root", default=".", help="Project root")
    args = parser.parse_args()
    path = Path(args.root).resolve() / "docs" / "ANALYTICS_EVENT_CATALOG.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(CATALOG, encoding="utf-8")
    print(f"Generated {path}")


if __name__ == "__main__":
    main()
