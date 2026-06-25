#!/usr/bin/env python3
'''Create a Flutter feature-first Clean Architecture skeleton.'''
from __future__ import annotations
import argparse
import re
from pathlib import Path


def snake(value: str) -> str:
    value = re.sub(r"[^a-zA-Z0-9]+", "_", value).strip("_")
    value = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", value)
    return value.lower()


def pascal(value: str) -> str:
    return "".join(part.capitalize() for part in snake(value).split("_") if part)


def write_if_missing(path: Path, content: str, force: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Scaffold a production-oriented Flutter feature.")
    parser.add_argument("feature_name")
    parser.add_argument("--root", default=".")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    feature = snake(args.feature_name)
    cls = pascal(feature)
    base = root / "lib" / "features" / feature
    test_base = root / "test" / "features" / feature

    folders = [
        base / "presentation" / "screens",
        base / "presentation" / "widgets",
        base / "presentation" / "controllers",
        base / "application" / "use_cases",
        base / "domain" / "entities",
        base / "domain" / "repositories",
        base / "domain" / "failures",
        base / "data" / "dto",
        base / "data" / "data_sources",
        base / "data" / "repositories",
        base / "data" / "mappers",
        test_base / "domain",
        test_base / "data",
        test_base / "presentation",
    ]
    for folder in folders:
        folder.mkdir(parents=True, exist_ok=True)

    write_if_missing(base / f"{feature}_providers.dart", f'''
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Wire concrete data sources and repositories for {feature}.
final {feature}RepositoryProvider = Provider<Object>((ref) {{
  throw UnimplementedError('Provide a {cls}Repository implementation');
}});
''', args.force)

    write_if_missing(base / "domain" / "entities" / f"{feature}.dart", f'''
import 'package:freezed_annotation/freezed_annotation.dart';

part '{feature}.freezed.dart';

@freezed
class {cls} with _${cls} {{
  const factory {cls}({{
    required String id,
    required String title,
  }}) = _{cls};
}}
''', args.force)

    write_if_missing(base / "domain" / "failures" / f"{feature}_failure.dart", f'''
sealed class {cls}Failure {{
  const {cls}Failure();
}}

final class {cls}NetworkFailure extends {cls}Failure {{
  const {cls}NetworkFailure();
}}

final class {cls}UnknownFailure extends {cls}Failure {{
  const {cls}UnknownFailure();
}}
''', args.force)

    write_if_missing(base / "domain" / "repositories" / f"{feature}_repository.dart", f'''
import '../entities/{feature}.dart';

abstract interface class {cls}Repository {{
  Future<List<{cls}>> list{cls}s();
}}
''', args.force)

    write_if_missing(base / "presentation" / "screens" / f"{feature}_screen.dart", f'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class {cls}Screen extends ConsumerWidget {{
  const {cls}Screen({{super.key}});

  @override
  Widget build(BuildContext context, WidgetRef ref) {{
    return Scaffold(
      appBar: AppBar(title: const Text('{cls}')),
      body: const Center(
        child: Text('TODO: Build {cls} experience with loading, empty, error, offline, and success states.'),
      ),
    );
  }}
}}
''', args.force)

    write_if_missing(test_base / "domain" / f"{feature}_repository_test.dart", f'''
import 'package:flutter_test/flutter_test.dart';

void main() {{
  group('{cls} repository', () {{
    test('TODO: maps successful data into domain entities', () {{
      expect(true, isTrue);
    }});
  }});
}}
''', args.force)

    print(f"Created/verified feature skeleton: {base}")
    print("Next: wire providers, routing, data sources, tests, and privacy impacts.")

if __name__ == "__main__":
    main()
