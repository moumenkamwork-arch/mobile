# Project Memory and Phase Control

Use this for long-lived apps, large refactors, multi-session Codex work, or any project where context loss would cause mistakes.

## Required memory artifacts

Create or update these files under `docs/project-memory/` when starting a substantial app or feature program:

- `CONTEXT.md`: product purpose, users, platforms, current stack, repository conventions, known constraints.
- `STATE.md`: current phase, completed work, active blockers, next recommended action.
- `DECISIONS.md`: architectural/product decisions with dates and rationale.
- `PHASES.md`: roadmap from discovery to launch.
- `RELEASE_STATE.md`: release readiness, store blockers, build status, test status, rollout gates.
- `LESSONS_LEARNED.md`: repeated mistakes, fixes, repo-specific gotchas, and instructions that should become future rules.

## Discuss -> Plan -> Execute -> Verify -> Ship loop

### Discuss

Extract the user's goal, target platforms, backend assumptions, monetization, privacy-sensitive features, and launch target. Avoid unnecessary questions when reasonable defaults are available.

### Plan

Write a small plan tied to files and validation commands. Update `STATE.md` with the active phase and next action.

### Execute

Implement only the current slice. Keep docs and code synchronized.

### Verify

Run practical checks and summarize failures. If commands cannot run, explain the environment blocker and perform static review.

### Ship

Update `RELEASE_STATE.md`, store/privacy notes, and user-facing summary.

## Memory hygiene rules

- Do not use memory files as a dumping ground for raw logs.
- Prefer short bullets with links or file paths.
- Move old completed phase details to an archive section.
- Update memory when a meaningful decision changes; do not update for every tiny edit.
- Treat `AGENTS.md` as the distilled operating contract for future Codex sessions.
