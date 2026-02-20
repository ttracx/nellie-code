#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN="$ROOT/packages/opencode/dist/nellie-code-linux-x64/bin/nellie-code"
if [ ! -x "$BIN" ]; then
  echo "Missing binary: $BIN"
  exit 1
fi
"$ROOT/install" --binary "$BIN" --no-modify-path
"$HOME/.nellie-code/bin/nellie-code" --version
