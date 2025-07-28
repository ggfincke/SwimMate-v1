#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
EXCLUDE_DIRS="Pods,Carthage,.build,DerivedData"

# Ensure SwiftFormat is available
if ! command -v swiftformat >/dev/null 2>&1; then
  echo "swiftformat not found."
  if command -v brew >/dev/null 2>&1; then
    echo "Installing via Homebrew..."
    brew install swiftformat
  else
    echo "Install it from https://github.com/nicklockwood/SwiftFormat and re-run."
    exit 1
  fi
fi

# Optional: fail fast if you have uncommitted changes
if command -v git >/dev/null 2>&1 && [ -n "$(git status --porcelain)" ]; then
  echo "You have uncommitted changes. Consider committing/stashing first."
fi

# Run SwiftFormat with Allman braces
swiftformat "$ROOT" \
  --allman true \
  --exclude "$EXCLUDE_DIRS"

echo "Done."
