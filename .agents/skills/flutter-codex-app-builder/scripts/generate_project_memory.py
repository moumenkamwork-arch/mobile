#!/usr/bin/env python3
"""Generate lightweight project memory files for long-running Flutter/Codex work."""
from __future__ import annotations
import argparse
from pathlib import Path

FILES = {
    "CONTEXT.md": """# Project Context\n\n## Product\nTODO: app purpose, users, platforms, and business model.\n\n## Stack\nTODO: Flutter version, state management, routing, backend, analytics, crash reporting.\n\n## Repository conventions\nTODO: folder rules, code generation commands, test commands, naming conventions.\n\n## Constraints\nTODO: privacy, security, store, deadline, team, and device constraints.\n""",
    "STATE.md": """# Project State\n\nCurrent phase: discovery\n\n## Completed\n- TODO\n\n## Active blockers\n- TODO\n\n## Next action\n- TODO\n""",
    "DECISIONS.md": """# Decisions\n\n| Date | Decision | Rationale | Status |\n|---|---|---|---|\n""",
    "PHASES.md": """# Phases\n\n1. Product blueprint\n2. Architecture and design system\n3. Core infrastructure\n4. Feature implementation\n5. QA and hardening\n6. Store preparation\n7. Launch and post-launch monitoring\n""",
    "RELEASE_STATE.md": """# Release State\n\n## Build\n- Android: TODO\n- iOS: TODO\n- Web: TODO\n\n## Store blockers\n- TODO\n\n## Rollout gates\n- Crash-free smoke test: TODO\n- Privacy declarations: TODO\n- Screenshots/metadata: TODO\n""",
    "LESSONS_LEARNED.md": """# Lessons Learned\n\nRecord repeated issues and prevention rules.\n\n| Date | Symptom | Root cause | Prevention rule |\n|---|---|---|---|\n""",
}

AGENTS_APPEND = """
\n## Project memory rules\n\n- Read `docs/project-memory/CONTEXT.md` and `STATE.md` before major edits.\n- Update `STATE.md` after completing a meaningful phase or discovering a blocker.\n- Add durable architecture/product decisions to `DECISIONS.md`.\n- Add repeated failures and prevention rules to `LESSONS_LEARNED.md`.\n"""


def write(path: Path, content: str, force: bool) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Create project memory docs for Codex-assisted Flutter work.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    mem = root / "docs" / "project-memory"
    for name, content in FILES.items():
        write(mem / name, content, args.force)
    agents = root / "AGENTS.md"
    if agents.exists():
        text = agents.read_text(encoding="utf-8", errors="ignore")
        if "## Project memory rules" not in text:
            agents.write_text(text.rstrip() + AGENTS_APPEND + "\n", encoding="utf-8")
    else:
        write(agents, "# Codex Instructions\n" + AGENTS_APPEND, args.force)
    print(f"Generated project memory files in {mem}")

if __name__ == "__main__":
    main()
