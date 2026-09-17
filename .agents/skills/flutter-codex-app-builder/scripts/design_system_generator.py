#!/usr/bin/env python3
'''Generate a concise Flutter-oriented design system document.'''
from __future__ import annotations
import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("product_description")
    parser.add_argument("--project", default="Flutter App")
    parser.add_argument("--page", action="append", default=[])
    parser.add_argument("--root", default=".")
    parser.add_argument("--persist", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    content = f'''
# Design System: {args.project}

## Product context
{args.product_description}

## Tokens
- Colors: primary, secondary, tertiary, surface, background, error, success, warning, info.
- Typography: display, headline, title, body, label.
- Spacing: 0, 2, 4, 8, 12, 16, 24, 32, 48, 64.
- Radius: none, sm, md, lg, xl, pill.
- Motion: fast 150ms, normal 250ms, slow 400ms.

## Components
Buttons, inputs, cards, lists, dialogs, sheets, tabs, stat cards, empty/loading/error/offline states.

## Accessibility
Support text scaling, contrast, semantic labels, focus order, and reduced motion where practical.

## Store screenshots
Plan screenshots around user value, core workflow, trust/privacy, results/dashboard, and premium differentiator.
'''.strip()
    if args.persist:
        out = root / "docs" / "design" / "DESIGN_SYSTEM.md"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(content + "\n", encoding="utf-8")
        for page in args.page:
            p = root / "docs" / "design" / "pages" / f"{page.lower().replace(' ', '_')}.md"
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(f"# Page Override: {page}\n\n- Goal: TODO\n- Layout: TODO\n- States: loading, empty, error, offline, success.\n", encoding="utf-8")
        print(f"Wrote {out}")
    else:
        print(content)

if __name__ == "__main__":
    main()
