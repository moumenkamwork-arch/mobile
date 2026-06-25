#!/usr/bin/env python3
"""Generate an accessibility audit checklist."""
from __future__ import annotations

import argparse
from pathlib import Path

CHECKLIST = """# Accessibility Audit

## Screen reader

- [ ] Screen title announced.
- [ ] Icon-only buttons have labels.
- [ ] Custom controls expose semantic roles.
- [ ] Dialogs announce purpose and actions.

## Keyboard and focus

- [ ] All controls reachable.
- [ ] Focus order matches visual order.
- [ ] Dialog focus is contained.

## Visual accessibility

- [ ] Text contrast reviewed.
- [ ] Dynamic text scaling reviewed.
- [ ] Tap targets are comfortable.
- [ ] Color is not the only state indicator.

## Locale and RTL

- [ ] Arabic/RTL layout reviewed when supported.
- [ ] Long localized strings do not clip.

## Notes

"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Create accessibility audit doc.")
    parser.add_argument("--root", default=".", help="Project root")
    args = parser.parse_args()
    path = Path(args.root).resolve() / "docs" / "ACCESSIBILITY_AUDIT.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(CHECKLIST, encoding="utf-8")
    print(f"Generated {path}")


if __name__ == "__main__":
    main()
