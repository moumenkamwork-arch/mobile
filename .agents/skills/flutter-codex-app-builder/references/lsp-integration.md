# LSP-assisted Flutter and Codex workflow

Use this reference when working in unfamiliar code, debugging, refactoring, or making edits that depend on symbol relationships.

## Goal

Bring IDE-like intelligence into AI coding work: jump to definitions, find references, inspect types/docs, list document/workspace symbols, find implementations, inspect call hierarchy, and use diagnostics before changing code.

## Preferred LSP capabilities

When the environment exposes LSP tools, use these operations before grep-heavy edits:

- `goToDefinition`: locate the source of a class, method, provider, route, or generated symbol.
- `findReferences`: understand all usage sites before renaming or changing signatures.
- `hover`: inspect type information, documentation, nullability, and generated API hints.
- `documentSymbol`: outline classes, functions, providers, and widgets in the current file.
- `workspaceSymbol`: search the repo for providers, entities, use cases, route names, and DTOs.
- `goToImplementation`: find concrete repository/data-source implementations behind interfaces.
- `prepareCallHierarchy`: identify a callable item before call graph inspection.
- `incomingCalls`: find what calls a function or constructor.
- `outgoingCalls`: find dependencies called by a function or controller.
- diagnostics: check real-time errors and warnings before and after edits.

## Dart/Flutter focus

For Flutter repos, prioritize the Dart analyzer language server. It works on `.dart` files and is available when Dart/Flutter SDK tooling is installed.

Minimum checks:

```bash
dart --version || flutter --version
flutter pub get
dart analyze
```

Use `dart analyze` as a hard quality gate when possible. If generated files are stale, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Claude Code plugin compatibility notes

Some environments support Claude-style LSP plugins. The useful plugin for Flutter is `dart-analyzer`; optional adjacent plugins include `yaml-language-server` for pubspec/workflows and `vtsls` for web companion code.

Example Claude Code plugin install commands:

```text
/plugin marketplace add boostvolt/claude-code-lsps
/plugin install dart-analyzer@claude-code-lsps
/plugin install yaml-language-server@claude-code-lsps
/plugin install vtsls@claude-code-lsps
```

If these plugins are unavailable in Codex, emulate the workflow with CLI commands, `rg`, `find`, and analysis.

## CLI fallbacks when LSP tools are unavailable

Use targeted search, not broad rewrites:

```bash
rg "class .*Repository|abstract interface class .*Repository" lib
rg "AsyncNotifierProvider|NotifierProvider|FutureProvider|Provider<" lib
rg "GoRoute|ShellRoute|redirect:" lib
rg "fromJson|toJson|freezed|json_serializable" lib pubspec.yaml
rg "TODO|FIXME|throw UnimplementedError" lib test
```

Before a signature change:

```bash
rg "SymbolName" lib test
```

Before a route change:

```bash
rg "RouteNames|GoRoute|context.go|context.push|namedLocation" lib test
```

## `.lsp.json` schema for plugin-style environments

A minimal LSP config maps a language id to a command and file extensions:

```json
{
  "dart": {
    "command": "dart",
    "args": ["language-server", "--protocol=lsp"],
    "extensionToLanguage": { ".dart": "dart" },
    "restartOnCrash": true,
    "maxRestarts": 3
  }
}
```

Optional fields often supported by plugin runners include `transport`, `env`, `initializationOptions`, `settings`, `workspaceFolder`, `startupTimeout`, `shutdownTimeout`, `restartOnCrash`, and `maxRestarts`.

Use `scripts/create_lsp_config.py` to generate a starter `.lsp.json` and `AI_CODING_CONTEXT.md` note for repos that benefit from explicit LSP setup.

## Refactor safety protocol

1. Locate definitions and implementations.
2. Find all references and route/provider usage.
3. Inspect diagnostics and existing tests.
4. Make the smallest safe change.
5. Run format, analyze, build generation, and targeted tests.
6. Re-run reference searches for renamed symbols.
