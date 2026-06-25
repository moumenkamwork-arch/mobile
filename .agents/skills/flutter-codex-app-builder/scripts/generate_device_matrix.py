#!/usr/bin/env python3
"""Generate a device and platform QA matrix."""
from __future__ import annotations

import argparse
from pathlib import Path

MATRIX = """# Device Matrix

| Platform | Device/browser | Priority | Flows to test | Status | Notes |
|---|---|---:|---|---|---|
| Android | Low-end device/emulator | P0 | install, auth, primary flow, offline | Not run | |
| Android | Current API emulator | P0 | install, auth, primary flow | Not run | |
| iOS | Small iPhone | P0 | install, auth, primary flow | Not run | |
| iOS | Large iPhone | P0 | install, auth, primary flow | Not run | |
| iPad | iPad | P1 | responsive layout | Not run | |
| Android tablet | Tablet | P1 | responsive layout | Not run | |
| Web | Desktop Chrome | P1 | landing/admin/checkout if supported | Not run | |
| Web | Mobile browser | P2 | responsive smoke if supported | Not run | |

## Required release smoke flows

- Fresh install.
- Upgrade from previous build.
- Onboarding/auth.
- Primary user journey.
- Offline/slow network.
- Permissions.
- Payments/subscriptions if applicable.
- Push/deep links if applicable.
- AR/EN and RTL if applicable.
"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Create device matrix doc.")
    parser.add_argument("--root", default=".", help="Project root")
    args = parser.parse_args()
    path = Path(args.root).resolve() / "docs" / "DEVICE_MATRIX.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(MATRIX, encoding="utf-8")
    print(f"Generated {path}")


if __name__ == "__main__":
    main()
