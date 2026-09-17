# Codex workflow for Flutter repositories

## 1. Inspect before editing

Run lightweight discovery first:

```bash
pwd
ls
find . -maxdepth 2 -type f | sort | sed -n '1,120p'
sed -n '1,220p' pubspec.yaml 2>/dev/null || true
sed -n '1,220p' analysis_options.yaml 2>/dev/null || true
find lib test -maxdepth 3 -type f 2>/dev/null | sort | sed -n '1,200p'
```

Look for existing choices before introducing defaults:

- state management: Riverpod, Bloc, Provider, GetX, setState-only, or custom.
- routing: go_router, auto_route, Navigator 1.0/2.0, custom.
- networking: dio, http, retrofit, chopper, Firebase/Supabase SDKs.
- models: freezed/json_serializable, built_value, manual models.
- architecture: feature-first, layer-first, simple app, generated app.
- tests: existing framework, mocks, golden tooling, CI commands.

## 2. Plan for Codex

For multi-file work, give a small plan before editing:

```markdown
Plan
- inspect current routing/state conventions
- add feature folders and domain/data/presentation layers
- wire route and provider
- add widget/provider tests
- run format, analyze, and tests
```

The plan should name likely files but stay flexible until the repo is inspected. Do not invent files that are not present.

## 3. Patch discipline

- Prefer minimal, coherent patches.
- Keep generated code out of hand-written patches unless the generator cannot run and the project already commits generated files.
- Do not rename broad folder structures unless necessary.
- Do not change package versions without a reason.
- Do not add dependencies for trivial functionality.
- Keep `pubspec.yaml` sorted and consistent with existing style.
- Avoid unrelated formatting churn outside touched files unless running project-wide format is expected.

## 4. Validation order

Use the strongest commands available in the repo:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
dart analyze
flutter test
```

Adapt when the repo provides scripts, for example `melos bootstrap`, `very_good test`, `make test`, or CI scripts.

If Flutter is unavailable, still validate what can be checked with file inspection and explain the limitation.

## 5. Final response

Final responses should be concise and evidence-based:

```markdown
Implemented:
- added <feature> domain/data/presentation layers
- wired <route> through go_router
- added tests for <behavior>

Validation:
- `dart format .` passed
- `dart analyze` failed: <specific issue>
- `flutter test` not run: flutter sdk unavailable

Notes:
- <remaining follow-up or risk>
```

Never claim commands passed unless they were actually run and passed.
