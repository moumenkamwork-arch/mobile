#!/usr/bin/env python3
'''Create a conservative GitHub Actions CI template for Flutter.'''
from __future__ import annotations
import argparse
from pathlib import Path

WORKFLOW = '''
name: Flutter CI

on:
  pull_request:
  push:
    branches: [ main ]

jobs:
  analyze-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - name: Install dependencies
        run: flutter pub get
      - name: Check formatting
        run: dart format --set-exit-if-changed .
      - name: Analyze
        run: flutter analyze
      - name: Test
        run: flutter test
'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--provider", choices=["github"], default="github")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    path = root / ".github" / "workflows" / "flutter_ci.yml"
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not args.force:
        print(f"Exists: {path}")
        return
    path.write_text(WORKFLOW.strip() + "\n", encoding="utf-8")
    print(f"Wrote {path}")

if __name__ == "__main__":
    main()
