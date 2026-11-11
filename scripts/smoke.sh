#!/usr/bin/env bash
# Install Python dependencies and run the existing short checks.
# Does not write under data/. Does not start the optional longer runners.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEPS="$ROOT/.smoke-deps"
mkdir -p "$DEPS"

python3 -m pip install --disable-pip-version-check --upgrade --target "$DEPS" -r "$ROOT/requirements.txt"

export PYTHONPATH="$DEPS${PYTHONPATH:+:$PYTHONPATH}"
python3 "$ROOT/scripts/smoke_checks.py"

git -C "$ROOT" diff --exit-code -- data
if [[ -n "$(git -C "$ROOT" status --porcelain -- data)" ]]; then
  echo "files under data/ changed" >&2
  git -C "$ROOT" status --porcelain -- data >&2
  exit 1
fi
