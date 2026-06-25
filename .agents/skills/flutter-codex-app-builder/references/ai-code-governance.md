# AI Code Governance and Attestation

Use this when Codex or another AI coding agent creates or modifies production code, release settings, security-sensitive code, payments, auth, privacy declarations, or legal-adjacent docs.

## Goals

- Make AI-assisted changes reviewable.
- Keep humans accountable for production decisions.
- Protect sensitive files and store/legal declarations.
- Maintain a lightweight audit trail without blocking normal development.

## Required artifacts

Create these when the repo is AI-assisted:

```text
docs/governance/AI_CODE_POLICY.md
docs/governance/AI_CHANGE_LOG.md
docs/governance/HUMAN_REVIEW_CHECKLIST.md
```

## Sensitive areas requiring human review

- Auth, authorization, account deletion, payments, subscriptions, ads.
- Data collection, privacy labels, Data safety, permissions, consent.
- Signing, provisioning, CI secrets, release lanes.
- Security controls, crypto, token storage, certificate pinning.
- Backend schema migrations and destructive data operations.
- Generated legal templates, terms, and privacy policy drafts.

## AI change log entry

```markdown
## YYYY-MM-DD - <change title>

- Agent/tool: Codex or other
- Files changed: ...
- Purpose: ...
- Human reviewer: TODO
- Sensitive area: yes/no
- Validation run: ...
- Remaining risks: ...
```

## Pull request checklist

- The PR states whether AI generated or substantially modified code.
- Tests or manual QA cover the changed behavior.
- Store/privacy/security impact is explicitly marked.
- Generated legal/store declarations are reviewed by a qualified human.
- No secrets, credentials, signing files, or private user data are committed.
