#!/usr/bin/env python3
"""Create a safe external repository research plan without copying code."""
from __future__ import annotations
import argparse
from pathlib import Path

TEMPLATE = """# External Repo Research

Source: {source}
License: TODO
Purpose of research: {purpose}

## Relevant patterns
- TODO

## Integration ideas for this Flutter app
- TODO

## Risks / do not copy
- TODO

## License and attribution checks
- TODO

## Follow-up checks
- TODO
"""

def main() -> None:
    parser = argparse.ArgumentParser(description="Create external repo research notes.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--source", required=True)
    parser.add_argument("--purpose", default="Extract architecture and implementation patterns safely")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    out = Path(args.root).resolve() / "docs" / "research" / "EXTERNAL_REPO_RESEARCH.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists() and not args.force:
        print(f"Skipped existing {out}")
        return
    out.write_text(TEMPLATE.format(source=args.source, purpose=args.purpose).strip() + "\n", encoding="utf-8")
    print(f"Generated research plan at {out}")

if __name__ == "__main__":
    main()
