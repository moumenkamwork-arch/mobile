#!/usr/bin/env python3
'''Create flavor documentation and a placeholder Dart app environment config.'''
from __future__ import annotations
import argparse
from pathlib import Path


def write_if_missing(path: Path, content: str, force: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--flavors", default="dev,staging,prod")
    parser.add_argument("--bundle-id", default="com.example.app")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    flavors = [f.strip() for f in args.flavors.split(',') if f.strip()]

    write_if_missing(root / "lib" / "core" / "config" / "app_environment.dart", f'''
enum AppEnvironment {{ {', '.join(flavors)} }}

class EnvironmentConfig {{
  const EnvironmentConfig({{required this.environment, required this.apiBaseUrl}});

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isProduction => environment == AppEnvironment.prod;
}}
''', args.force)

    rows = "\n".join(f"| {f} | {args.bundle_id}.{f if f != 'prod' else ''} | TODO |" for f in flavors)
    write_if_missing(root / "docs" / "release" / "FLAVORS.md", f'''
# Flavors

| Flavor | Suggested app id | Backend |
|---|---|---|
{rows}

## Notes
- Configure Android productFlavors and iOS schemes manually or with your team's preferred tooling.
- Keep secrets in CI/local secret stores, not in repo.
''', args.force)
    print(f"Created flavor docs/config for: {', '.join(flavors)}")

if __name__ == "__main__":
    main()
