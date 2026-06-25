#!/usr/bin/env python3
"""Generate a Figma-to-Flutter mapping document."""
from __future__ import annotations
import argparse
from pathlib import Path

TEMPLATE = """# Figma to Flutter Mapping

Design source: {source}
Target surface: {surface}

## Frames and routes
| Figma frame | Flutter route/screen | Notes |
|---|---|---|

## Token mapping
| Figma style | Semantic token | Flutter target |
|---|---|---|

## Components
| Figma component | Flutter widget | States/variants |
|---|---|---|

## Assets and licensing
- TODO

## Accessibility risks
- TODO

## Implementation plan
1. Add/update tokens.
2. Add/update shared components.
3. Implement screens using tokens/components.
4. Add widget/golden tests where supported.
5. Compare against design and document deviations.
"""

def main() -> None:
    parser = argparse.ArgumentParser(description="Create a Figma-to-Flutter mapping doc.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--source", default="TODO: Figma URL or export path")
    parser.add_argument("--surface", default="mobile")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    out = Path(args.root).resolve() / "docs" / "design" / "FIGMA_MAPPING.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists() and not args.force:
        print(f"Skipped existing {out}")
        return
    out.write_text(TEMPLATE.format(source=args.source, surface=args.surface).strip() + "\n", encoding="utf-8")
    print(f"Generated Figma mapping at {out}")

if __name__ == "__main__":
    main()
