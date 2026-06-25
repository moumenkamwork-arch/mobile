#!/usr/bin/env python3
'''Draft store metadata and screenshot shot list.'''
from __future__ import annotations
import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--app-name", required=True)
    parser.add_argument("--category", default="productivity")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    out = root / "docs" / "store" / "STORE_METADATA.md"
    if out.exists() and not args.force:
        print(f"Exists: {out}")
        return
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(f'''
# Store Metadata: {args.app_name}

## Category
{args.category}

## Short description
TODO: One clear sentence focused on user value.

## Full description
TODO: Describe who it helps, key benefits, privacy/trust, and differentiators.

## Keywords
TODO: keyword 1, keyword 2, keyword 3

## Screenshot shot list
1. Hero value proposition.
2. Core workflow.
3. Result/dashboard/output.
4. Trust/privacy/collaboration.
5. Premium/AI/offline differentiator if applicable.

## Review notes
TODO: Include demo credentials, review path, non-obvious features, and backend/test data.
'''.strip() + "\n", encoding="utf-8")
    print(f"Wrote {out}")

if __name__ == "__main__":
    main()
