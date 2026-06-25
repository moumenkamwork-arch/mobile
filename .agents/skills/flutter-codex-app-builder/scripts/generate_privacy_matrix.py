#!/usr/bin/env python3
'''Create privacy, permissions, and SDK inventory templates.'''
from __future__ import annotations
import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--features", default="auth,analytics,crash-reporting")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    out = root / "docs" / "privacy" / "PRIVACY_MATRIX.md"
    if out.exists() and not args.force:
        print(f"Exists: {out}")
        return
    out.parent.mkdir(parents=True, exist_ok=True)
    features = [f.strip() for f in args.features.split(',') if f.strip()]
    rows = "\n".join(f"| {f} | TODO | TODO | TODO | TODO | TODO | TODO | TODO |" for f in features)
    out.write_text(f'''
# Privacy Matrix

## Data inventory

| Feature | Data collected | Purpose | Required? | Stored where | Shared with | Retention | Store declaration |
|---|---|---|---|---|---|---|---|
{rows}

## Permissions

| Permission | Platform | Feature | Rationale | Required? | Fallback if denied |
|---|---|---|---|---|---|

## Third-party SDKs

| SDK | Purpose | Data collected/shared | Opt-out? | Store declaration impact |
|---|---|---|---|---|

## User controls

- Account deletion: TODO
- Data export: TODO
- Consent/opt-out: TODO
- Support contact: TODO
'''.strip() + "\n", encoding="utf-8")
    print(f"Wrote {out}")

if __name__ == "__main__":
    main()
