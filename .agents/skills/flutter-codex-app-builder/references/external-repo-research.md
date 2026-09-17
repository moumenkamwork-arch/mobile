# External Repository Research and Pattern Extraction

Use this when the user wants to learn from another repository, template, SDK, design system, backend repo, or example app.

## Rules

- Extract patterns, architecture decisions, and integration lessons; do not copy code blindly.
- Check license compatibility before reusing code or assets.
- Keep external research separate from implementation notes.
- Prefer public docs and APIs over private implementation details when available.
- Document uncertainty and stale assumptions.

## Research artifact

Create `docs/research/EXTERNAL_REPO_RESEARCH.md`:

```markdown
# External Repo Research

Source: ...
License: ...
Purpose of research: ...

## Relevant patterns
- ...

## Integration ideas for this Flutter app
- ...

## Risks / do not copy
- ...

## Follow-up checks
- ...
```

## What to inspect

- Folder structure and module boundaries.
- State management and dependency injection.
- API contracts and generated clients.
- Error handling and retry behavior.
- Testing strategy.
- CI/CD and release process.
- Design system/token structure.
- Security/privacy docs.

## Safe adaptation process

1. Summarize the pattern in original words.
2. Map the pattern to this app's architecture.
3. Implement from the app's requirements, not line-by-line copying.
4. Add attribution when license or policy requires it.
5. Add tests proving the adapted behavior.
