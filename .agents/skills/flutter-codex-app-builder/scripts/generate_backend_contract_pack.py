#!/usr/bin/env python3
"""Generate backend API contract and contract testing templates."""
from __future__ import annotations

import argparse
from pathlib import Path

API_CONTRACT = """# API Contracts

## Endpoint table

| Method | Path | Auth | Request | Success response | Error responses | Notes |
|---|---|---|---|---|---|---|

## DTO examples

### Success

```json
{}
```

### Error

```json
{
  "code": "example_error",
  "message": "Human readable message"
}
```

## Compatibility checklist

- [ ] Missing optional fields.
- [ ] Unknown enum values.
- [ ] Expired auth token.
- [ ] Rate limit response.
- [ ] Pagination edge cases.
- [ ] Offline transition during request.
"""

MOCKS = """# Mock Backend Plan

## Fakes required

| Repository/service | Fake behavior | Tests using it |
|---|---|---|

## Contract test scenarios

- [ ] Success response maps to domain model.
- [ ] Error response maps to typed failure.
- [ ] Auth refresh behavior.
- [ ] Pagination behavior.
- [ ] Retry/backoff behavior.
"""


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(content, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Create backend contract templates.")
    parser.add_argument("--root", default=".", help="Project root")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    write(root / "docs" / "API_CONTRACTS.md", API_CONTRACT)
    write(root / "docs" / "MOCK_BACKEND_PLAN.md", MOCKS)
    print(f"Generated backend contract pack in {root / 'docs'}")


if __name__ == "__main__":
    main()
