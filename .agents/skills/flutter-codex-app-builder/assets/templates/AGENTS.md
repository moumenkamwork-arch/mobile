# AGENTS.md

This project uses Codex with the Flutter Codex Production App Builder workflow.

## Operating rules

1. Inspect the repo before editing.
2. Make a concise plan for multi-file work.
3. Preserve existing conventions unless they are clearly harmful.
4. Keep changes small and reviewable.
5. Do not commit secrets, signing keys, tokens, production endpoints, or store credentials.
6. Do not add dependencies without a dependency review note.
7. Do not place networking, persistence, analytics, payments, or SDK calls directly inside widgets.
8. Add or update tests for new behavior whenever practical.
9. Run validation commands and report skipped checks with reasons.
10. Update project memory for multi-session work.

## Preferred Flutter stack

- Riverpod for state management.
- go_router for navigation.
- Dio for HTTP.
- freezed/json_serializable for DTOs and unions.
- Feature-first clean architecture for complex features.

## Validation order

```bash
dart format .
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter build apk --debug
```

Use platform-specific release builds only when the environment supports them.
