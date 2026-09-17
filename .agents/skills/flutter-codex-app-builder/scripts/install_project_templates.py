#!/usr/bin/env python3
"""Copy production Flutter project templates into a target repo."""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path


def copy_tree(src: Path, dst: Path) -> None:
    for item in src.rglob("*"):
        rel = item.relative_to(src)
        target = dst / rel
        if item.is_dir():
            target.mkdir(parents=True, exist_ok=True)
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            if not target.exists():
                shutil.copy2(item, target)


def main() -> None:
    parser = argparse.ArgumentParser(description="Install Flutter production templates into a repo.")
    parser.add_argument("--root", default=".", help="Target project root")
    parser.add_argument("--overwrite", action="store_true", help="Overwrite existing files")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    skill_root = Path(__file__).resolve().parents[1]
    templates = skill_root / "assets" / "templates"

    if not templates.exists():
        raise SystemExit(f"Template directory not found: {templates}")

    mappings = {
        templates / "AGENTS.md": root / "AGENTS.md",
        templates / "docs": root / "docs",
        templates / "github": root / ".github",
        templates / "store": root / "docs" / "store",
    }

    created = []
    skipped = []
    for src, dst in mappings.items():
        if src.is_file():
            dst.parent.mkdir(parents=True, exist_ok=True)
            if dst.exists() and not args.overwrite:
                skipped.append(str(dst))
                continue
            shutil.copy2(src, dst)
            created.append(str(dst))
        elif src.is_dir():
            before = set(p for p in root.rglob("*") if p.is_file())
            if args.overwrite and dst.exists():
                shutil.rmtree(dst)
            copy_tree(src, dst)
            after = set(p for p in root.rglob("*") if p.is_file())
            created.extend(str(p) for p in sorted(after - before))

    print("Installed templates:")
    for path in created:
        print(f"  + {path}")
    if skipped:
        print("Skipped existing files:")
        for path in skipped:
            print(f"  - {path}")


if __name__ == "__main__":
    main()
