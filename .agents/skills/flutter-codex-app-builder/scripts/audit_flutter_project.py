#!/usr/bin/env python3
'''Static project audit for Flutter production readiness.'''
from __future__ import annotations
import argparse
from pathlib import Path

CHECKS = [
    ("pubspec.yaml", "Flutter/Dart package manifest"),
    ("lib", "Application source folder"),
    ("test", "Test folder"),
    ("analysis_options.yaml", "Analyzer/lint configuration"),
    ("docs/architecture/ARCHITECTURE.md", "Architecture documentation"),
    ("docs/privacy/PRIVACY_MATRIX.md", "Privacy matrix"),
    ("docs/store", "Store release documentation"),
    ("AGENTS.md", "Codex instructions"),
    ("docs/project-memory/STATE.md", "Project memory state"),
    ("docs/governance/AI_CODE_POLICY.md", "AI coding governance policy"),
]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    missing = []
    print(f"Auditing {root}\n")
    for rel, label in CHECKS:
        path = root / rel
        status = "OK" if path.exists() else "MISSING"
        print(f"[{status}] {rel} - {label}")
        if not path.exists():
            missing.append(rel)
    pubspec = root / "pubspec.yaml"
    if pubspec.exists():
        text = pubspec.read_text(encoding="utf-8", errors="ignore")
        for pkg in ["flutter_riverpod", "go_router", "dio", "freezed_annotation", "json_annotation"]:
            print(f"[{'OK' if pkg in text else 'CHECK'}] dependency {pkg}")
    print("\nResult:", "production docs/checks need attention" if missing else "baseline structure present")

if __name__ == "__main__":
    main()
