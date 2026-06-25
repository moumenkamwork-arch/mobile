#!/usr/bin/env python3
"""Generate a dependency review template."""
from __future__ import annotations

import argparse
from pathlib import Path

TEMPLATE = """# Dependency Review

## Proposed dependency

- Package:
- Version:
- Purpose:
- Requested by:

## Review

- License:
- Maintenance/activity:
- Security/advisory notes:
- App size/build impact:
- Platform permissions:
- Data collection / SDK privacy impact:
- Alternatives considered:
- Removal plan:

## Decision

- [ ] Approved
- [ ] Rejected
- [ ] Needs more review

## Notes

"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Create dependency review template.")
    parser.add_argument("--root", default=".", help="Project root")
    parser.add_argument("--package", default="PACKAGE_NAME", help="Package name")
    args = parser.parse_args()
    safe_name = args.package.replace("/", "_").replace(" ", "_")
    path = Path(args.root).resolve() / "docs" / "dependency-reviews" / f"{safe_name}.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(TEMPLATE.replace("Package:\n", f"Package: {args.package}\n"), encoding="utf-8")
    print(f"Generated {path}")


if __name__ == "__main__":
    main()
