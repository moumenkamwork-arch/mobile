#!/usr/bin/env python3
'''Create helper LSP configuration notes for AI coding workflows.'''
from __future__ import annotations
import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--languages", default="dart,yaml")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    langs = [x.strip() for x in args.languages.split(',') if x.strip()]
    lsp = root / ".lsp.json"
    note = root / "docs" / "architecture" / "LSP_WORKFLOW.md"
    if not lsp.exists() or args.force:
        lsp.write_text('''{
  "dart": { "server": "dart language-server --protocol=lsp" },
  "yaml": { "server": "yaml-language-server --stdio" }
}
''', encoding="utf-8")
    note.parent.mkdir(parents=True, exist_ok=True)
    if not note.exists() or args.force:
        note.write_text(f'''
# LSP Workflow

Configured languages: {', '.join(langs)}

Use definition, references, symbols, hover/type info, implementations, call hierarchy, and diagnostics before broad refactors. If LSP is unavailable, use grep plus `flutter analyze`.
'''.strip() + "\n", encoding="utf-8")
    print(f"Wrote {lsp} and {note}")

if __name__ == "__main__":
    main()
