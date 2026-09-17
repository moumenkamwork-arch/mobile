#!/usr/bin/env python3
"""Generate lightweight AI coding governance and attestation docs."""
from __future__ import annotations
import argparse
from pathlib import Path

POLICY = """# AI Code Policy

AI coding agents may assist implementation, refactoring, tests, docs, and release checklists. Humans remain responsible for production behavior, store declarations, legal/privacy statements, and sensitive changes.

## Sensitive changes requiring human review

- Auth, authorization, payments, subscriptions, ads, account deletion.
- Privacy declarations, Data safety, permissions, consent, SDK data collection.
- Signing, provisioning, CI secrets, release automation.
- Security controls, crypto, token storage, certificate pinning.
- Destructive migrations and backend data operations.
"""
CHANGE_LOG = """# AI Change Log

## Template

- Date: YYYY-MM-DD
- Agent/tool: Codex
- Change title: TODO
- Files changed: TODO
- Sensitive area: yes/no
- Human reviewer: TODO
- Validation: TODO
- Remaining risks: TODO
"""
REVIEW = """# Human Review Checklist

- [ ] The change purpose is clear.
- [ ] Tests or manual QA cover changed behavior.
- [ ] Security/privacy/store impact is marked.
- [ ] No secrets, signing files, service accounts, or private user data are committed.
- [ ] Generated legal/store declarations have qualified human review.
"""

def write(path: Path, content: str, force: bool) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")

def main() -> None:
    parser = argparse.ArgumentParser(description="Create AI governance docs.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    base = Path(args.root).resolve() / "docs" / "governance"
    write(base / "AI_CODE_POLICY.md", POLICY, args.force)
    write(base / "AI_CHANGE_LOG.md", CHANGE_LOG, args.force)
    write(base / "HUMAN_REVIEW_CHECKLIST.md", REVIEW, args.force)
    print(f"Generated AI governance docs in {base}")

if __name__ == "__main__":
    main()
