# Context, Logs, and Memory Optimization

Use this when logs, generated files, test output, dependency trees, or repository context are too large for effective Codex work.

## Principles

- Summarize before reasoning over long output.
- Keep raw logs on disk and reference paths instead of pasting entire content.
- Extract actionable failures, file paths, line numbers, and commands.
- Preserve uncertainty: do not hide failures behind a clean summary.
- Promote repeated lessons into `docs/project-memory/LESSONS_LEARNED.md` and `AGENTS.md`.

## Build/test log summary template

```markdown
# Log Summary

Command: ...
Exit status: ...

## Primary failures
- file:line - message - suspected cause

## Secondary warnings
- ...

## First fix to try
- ...

## Raw log
- path: ...
```

## Compression rules by output type

### `flutter analyze`

Group by lint/error code, file, and severity. Fix errors before style lints.

### `flutter test`

Group by failing test file and test name. Include first stack frame in app code.

### build logs

Extract signing, Gradle/Xcode, dependency, SDK, asset, codegen, and platform capability errors.

### generated files

Do not paste generated `.g.dart`, `.freezed.dart`, or lockfiles unless the bug is inside generation config.

## Learning loop

When a failure repeats twice, add a lesson:

```markdown
- Date: YYYY-MM-DD
- Symptom: ...
- Root cause: ...
- Prevention rule: ...
- Files/commands affected: ...
```
