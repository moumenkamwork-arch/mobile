#!/bin/sh
# ExFAT (Lexar) creates AppleDouble ._* files that break Xcode/SPM builds.
# Keep Flutter's build/ on the internal APFS disk via symlink.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${PROMOO_BUILD_DIR:-$HOME/Library/Caches/promoo_app_build}"
mkdir -p "$TARGET"
cd "$ROOT"
# flutter clean removes the symlink and recreates a real build/ on ExFAT —
# re-link whenever build is missing or is a real directory.
if [ -L build ]; then
  :
elif [ -d build ]; then
  echo "Moving ExFAT build/ -> $TARGET"
  rm -rf "$TARGET"
  mv build "$TARGET"
  ln -s "$TARGET" build
else
  ln -s "$TARGET" build
fi
# Clean AppleDouble junk from the project tree (not the APFS build cache).
find "$ROOT" -name '._*' -not -path "$ROOT/build/*" -not -path "$ROOT/.git/*" -delete 2>/dev/null || true
echo "build/ -> $(readlink "$ROOT/build")"
