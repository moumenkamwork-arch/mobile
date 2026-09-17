#!/usr/bin/env python3
'''Bootstrap production-oriented docs and folders for a Flutter app repo.'''
from __future__ import annotations
import argparse
import re
from pathlib import Path


def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", value.lower()).strip("_") or "app"


def write_if_missing(path: Path, content: str, force: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Create production-ready Flutter project structure and docs.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--app-name", required=True)
    parser.add_argument("--org", default="com.example")
    parser.add_argument("--platforms", default="mobile")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    app_id = f"{args.org}.{slug(args.app_name)}"
    folders = [
        "lib/app", "lib/core/config", "lib/core/errors", "lib/core/logging", "lib/core/network",
        "lib/core/permissions", "lib/core/security", "lib/core/storage", "lib/design_system/tokens",
        "lib/design_system/components", "lib/design_system/patterns", "lib/features", "lib/l10n",
        "lib/shared", "test", "integration_test", "tool", "scripts", "assets/images", "assets/icons",
        "docs/product", "docs/architecture/adr", "docs/design/pages", "docs/release", "docs/privacy",
        "docs/security", "docs/testing", "docs/store", "docs/project-memory", "docs/governance", "docs/research", "e2e/playwright", ".github/workflows",
    ]
    for folder in folders:
        (root / folder).mkdir(parents=True, exist_ok=True)

    write_if_missing(root / "AGENTS.md", f'''
# Codex Instructions for {args.app_name}

- Inspect repo structure before edits.
- Keep feature code under `lib/features/<feature>` and shared infrastructure under `lib/core`.
- Use Riverpod, go_router, Dio, freezed/json_serializable, typed failures, and tests unless the repo has stronger conventions.
- Do not commit secrets, signing files, production tokens, or service account JSON.
- Run format/analyze/tests after edits when practical.
- Update docs for architecture, privacy, release, and store impact.
''', args.force)

    write_if_missing(root / ".env.example", '''
APP_ENV=dev
API_BASE_URL=https://api.example.com
SENTRY_DSN=
FIREBASE_PROJECT_ID=
''', args.force)

    write_if_missing(root / "analysis_options.yaml", '''
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    prefer_const_constructors: true
    avoid_print: true
''', args.force)

    write_if_missing(root / "docs" / "product" / "PRD.md", f'''
# Product Requirements Document: {args.app_name}

## Summary
TODO: Describe the app promise and primary user.

## Default app id
`{app_id}`

## Platforms
{args.platforms}

## MVP
- TODO

## Launch criteria
- Product, design, architecture, tests, privacy, security, release, and store readiness complete.
''', args.force)

    write_if_missing(root / "docs" / "architecture" / "ARCHITECTURE.md", '''
# Architecture

Use feature-first Clean Architecture with presentation, application, domain, and data boundaries.

## Dependency direction
UI -> application/domain -> repository interfaces <- data implementations.
''', args.force)

    write_if_missing(root / "docs" / "privacy" / "DATA_INVENTORY.md", '''
# Data Inventory

| Data type | Source | Purpose | Stored where | Shared with | Retention | User control | Store declaration |
|---|---|---|---|---|---|---|---|
''', args.force)


    write_if_missing(root / "docs" / "project-memory" / "STATE.md", '''
# Project State

Current phase: discovery

## Completed
- Initial production scaffold created.

## Active blockers
- TODO

## Next action
- Complete product blueprint and architecture decisions.
''', args.force)

    write_if_missing(root / "docs" / "governance" / "AI_CODE_POLICY.md", '''
# AI Code Policy

AI coding agents may assist implementation, tests, and docs. Human review is required for auth, payments, privacy declarations, signing, CI secrets, destructive migrations, security controls, and release submissions.
''', args.force)

    write_if_missing(root / "docs" / "release" / "RELEASE.md", '''
# Release Process

1. Update version/build numbers.
2. Run format, analyze, tests, and release builds.
3. Review privacy and store checklists.
4. Upload to internal testing/TestFlight.
5. Monitor crash-free sessions before production rollout.
''', args.force)

    write_if_missing(root / "README.md", f'''
# {args.app_name}

Production Flutter app scaffolded for Codex-assisted development.

## Validation
```bash
flutter pub get
dart format .
flutter analyze
flutter test
```
''', args.force)

    print(f"Bootstrapped production folders/docs at {root}")
    print(f"Suggested application id: {app_id}")

if __name__ == "__main__":
    main()
