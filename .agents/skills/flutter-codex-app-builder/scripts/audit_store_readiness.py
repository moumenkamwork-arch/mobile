#!/usr/bin/env python3
'''Audit presence of store-readiness artifacts.'''
from __future__ import annotations
import argparse
from pathlib import Path

REQUIRED = [
    "docs/privacy/PRIVACY_MATRIX.md",
    "docs/store/STORE_METADATA.md",
    "docs/store/GOOGLE_PLAY_CHECKLIST.md",
    "docs/store/APP_STORE_CHECKLIST.md",
    "docs/release/RELEASE.md",
]

PLATFORM = [
    "android/app/build.gradle",
    "android/app/build.gradle.kts",
    "ios/Runner.xcodeproj",
]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    print(f"Store readiness audit: {root}\n")
    for rel in REQUIRED:
        print(f"[{'OK' if (root/rel).exists() else 'MISSING'}] {rel}")
    has_android = any((root/p).exists() for p in PLATFORM[:2])
    has_ios = (root/PLATFORM[2]).exists()
    print(f"[{'OK' if has_android else 'CHECK'}] Android project files")
    print(f"[{'OK' if has_ios else 'CHECK'}] iOS project files")
    print("\nManual gates still required: signing, secrets, store console forms, screenshots, privacy policy URL, demo account, and real-device smoke tests.")

if __name__ == "__main__":
    main()
