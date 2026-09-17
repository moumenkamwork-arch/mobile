#!/usr/bin/env python3
'''Generate release checklists for Google Play and App Store.'''
from __future__ import annotations
import argparse
from pathlib import Path

GOOGLE = '''
# Google Play Release Checklist

- [ ] Application ID finalized.
- [ ] Version name and version code incremented.
- [ ] Target API level meets current Google Play requirements.
- [ ] App icon and feature graphic ready.
- [ ] Phone/tablet screenshots ready as applicable.
- [ ] Short and full descriptions ready.
- [ ] Privacy policy URL ready.
- [ ] Data safety form prepared from privacy matrix, including SDKs.
- [ ] App content declarations complete.
- [ ] Permissions reviewed and justified.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] `flutter build appbundle --release` succeeds.
- [ ] Internal testing smoke pass complete.
- [ ] Staged rollout plan defined.
'''

APPLE = '''
# App Store Release Checklist

- [ ] Apple Developer Program access confirmed.
- [ ] Bundle ID registered.
- [ ] App Store Connect record created.
- [ ] Version/build number incremented.
- [ ] Signing/provisioning configured.
- [ ] App icon and launch screen ready.
- [ ] Privacy policy URL ready.
- [ ] App privacy details prepared from privacy matrix, including SDKs.
- [ ] Age rating, category, pricing/availability complete.
- [ ] Review notes and demo account/demo mode ready if login required.
- [ ] In-app purchases/subscriptions reviewable if used.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] `flutter build ipa --release` succeeds on macOS/Xcode environment.
- [ ] TestFlight smoke pass complete.
'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--store", choices=["all", "google-play", "app-store"], default="all")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    out_dir = root / "docs" / "store"
    out_dir.mkdir(parents=True, exist_ok=True)
    targets = []
    if args.store in ("all", "google-play"):
        targets.append((out_dir / "GOOGLE_PLAY_CHECKLIST.md", GOOGLE))
    if args.store in ("all", "app-store"):
        targets.append((out_dir / "APP_STORE_CHECKLIST.md", APPLE))
    for path, content in targets:
        if path.exists() and not args.force:
            print(f"Exists: {path}")
            continue
        path.write_text(content.strip() + "\n", encoding="utf-8")
        print(f"Wrote {path}")

if __name__ == "__main__":
    main()
