# Superpowers-Inspired Delivery Workflow

Use this workflow for complex Flutter features, refactors, release work, security-sensitive changes, and anything that touches more than a few files.

## Core principle

Do not jump straight into code. Move through small, auditable phases:

```text
idea -> spec -> plan -> isolated worktree/branch -> failing test -> implementation -> review -> verify -> ship
```

## Phase 1: clarify and specify

Create or update a short spec before implementation. Include:

- User goal and non-goals.
- Affected screens, routes, providers, services, storage, backend contracts, permissions, analytics, and store/privacy impact.
- Acceptance criteria written as verifiable checks.
- Test strategy before coding.
- Rollback and migration considerations when persistence, auth, payments, or release settings are involved.

## Phase 2: plan in small slices

Break work into slices that can be reviewed independently:

1. Data/domain contract.
2. Repository/API/storage implementation.
3. State management/providers.
4. UI and states.
5. Tests.
6. Docs/release/privacy updates.

Each slice should list exact files to create or edit. If the repo structure is unknown, inspect it before naming files.

## Phase 3: isolate risky work

Prefer a branch or git worktree for broad changes. Never mix unrelated refactors with feature implementation. Keep generated code, formatting-only changes, and behavior changes separable when practical.

Suggested worktree pattern:

```bash
git worktree add ../app-feature-<slug> -b feature/<slug>
```

Use only when the environment supports git and the user wants a durable branch/worktree.

## Phase 4: TDD where practical

For non-trivial logic, write the failing test first:

- Domain/use-case tests for business rules.
- Repository tests for mapping, errors, retry, and cache behavior.
- Widget tests for loading/error/empty/success states.
- Integration tests for critical flows.
- Golden tests only when visual stability is important and the project has a golden workflow.

If TDD is not practical, explain why and create test cases immediately after implementation.

## Phase 5: implementation rules

- Keep patches small and reversible.
- Avoid hidden global state and widget-level business logic.
- Keep DTOs and domain entities separate for complex apps.
- Add telemetry, logs, and error boundaries only at defined boundaries.
- Update generated files with the repo's codegen command, not manual edits.

## Phase 6: review gates

Perform two reviews before final delivery:

### Plan adherence review

Check that every acceptance criterion and file target was addressed. Mark unmet criteria explicitly.

### Engineering quality review

Check architecture boundaries, state management, error handling, tests, accessibility, security/privacy, performance, and release impact.

Critical issues stop delivery until fixed or explicitly accepted by the user.

## Final report

Use this structure:

```markdown
Summary
- ...

Spec/Plan Status
- acceptance criterion: done/not done

Validation
- command: passed/failed/skipped - reason

Risks and Release Impact
- ...
```
