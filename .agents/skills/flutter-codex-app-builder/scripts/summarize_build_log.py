#!/usr/bin/env python3
"""Summarize Flutter/Dart/Gradle/Xcode logs into actionable failure groups."""
from __future__ import annotations
import argparse
import re
from pathlib import Path

PATTERNS = [
    ("dart_analyze", re.compile(r"^(error|warning|info) - (.+)$", re.I)),
    ("flutter_test_failure", re.compile(r"^(\d{2}:\d{2} \+\d+.*failed|\s*Expected:|\s*Actual:|\s*package:flutter_test)", re.I)),
    ("gradle", re.compile(r"(FAILURE: Build failed|Execution failed for task|Could not resolve|Android resource linking failed)", re.I)),
    ("xcode", re.compile(r"(xcodebuild: error|Code Signing Error|Provisioning profile|No profiles for|Swift Compiler Error)", re.I)),
    ("flutter_build", re.compile(r"(Target kernel_snapshot failed|Gradle task assemble.* failed|Failed to build iOS app|Error:)", re.I)),
]

def classify(line: str) -> str | None:
    for label, pattern in PATTERNS:
        if pattern.search(line):
            return label
    return None

def main() -> None:
    parser = argparse.ArgumentParser(description="Summarize build/test/analyze logs.")
    parser.add_argument("logfile")
    parser.add_argument("--out", default="")
    parser.add_argument("--max-lines", type=int, default=80)
    args = parser.parse_args()
    log_path = Path(args.logfile).resolve()
    text = log_path.read_text(encoding="utf-8", errors="ignore")
    groups: dict[str, list[str]] = {}
    for raw in text.splitlines():
        line = raw.rstrip()
        label = classify(line)
        if label:
            groups.setdefault(label, []).append(line[:500])
    lines = ["# Log Summary", "", f"Raw log: `{log_path}`", ""]
    if not groups:
        lines += ["No known Flutter/Dart/Gradle/Xcode failure pattern was detected.", "Review the raw log manually."]
    else:
        for label, items in groups.items():
            lines += [f"## {label}"]
            for item in items[: args.max_lines]:
                lines.append(f"- {item}")
            omitted = len(items) - args.max_lines
            if omitted > 0:
                lines.append(f"- ... {omitted} more")
            lines.append("")
    output = "\n".join(lines).rstrip() + "\n"
    if args.out:
        out = Path(args.out).resolve()
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(output, encoding="utf-8")
        print(f"Wrote summary to {out}")
    else:
        print(output)

if __name__ == "__main__":
    main()
