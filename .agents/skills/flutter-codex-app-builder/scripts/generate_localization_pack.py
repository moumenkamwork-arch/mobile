#!/usr/bin/env python3
"""Generate Flutter localization and RTL planning templates."""
from __future__ import annotations

import argparse
from pathlib import Path


def write_if_missing(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(content, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Create localization templates for Flutter apps.")
    parser.add_argument("--root", default=".", help="Project root")
    parser.add_argument("--locales", default="en,ar", help="Comma-separated locale codes")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    locales = [x.strip() for x in args.locales.split(",") if x.strip()]

    write_if_missing(root / "l10n.yaml", "arb-dir: lib/l10n\ntemplate-arb-file: app_en.arb\noutput-localization-file: app_localizations.dart\n")
    for locale in locales:
        write_if_missing(root / "lib" / "l10n" / f"app_{locale}.arb", '{\n  "appTitle": "App Title"\n}\n')

    doc = "# Localization Plan\n\n## Locales\n\n" + "\n".join(f"- {loc}" for loc in locales) + "\n\n## RTL checklist\n\n- Use Directionality-aware padding/alignment.\n- Test Arabic screens with long strings.\n- Localize store listing and screenshot captions.\n"
    write_if_missing(root / "docs" / "LOCALIZATION.md", doc)
    print(f"Generated localization pack in {root}")


if __name__ == "__main__":
    main()
