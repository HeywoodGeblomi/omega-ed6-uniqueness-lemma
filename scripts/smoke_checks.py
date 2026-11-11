"""Run the existing short Python checks.

Reads code and stored data only. Does not write under data/.
Does not start the optional longer runners.
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
DEPS = ROOT / ".smoke-deps"

# Existing entry points that do not write under data/.
SHORT = (
    ROOT / "samplers" / "periodic" / "run_example.py",
    ROOT / "samplers" / "generic" / "skeleton.py",
    ROOT / "scripts" / "check_raw_lyapunov_correspondence.py",
)


def snapshot() -> dict[str, str]:
    found: dict[str, str] = {}
    for path in sorted(DATA.rglob("*")):
        if path.is_file():
            found[str(path.relative_to(ROOT))] = hashlib.sha256(path.read_bytes()).hexdigest()
    return found


def require_installed_numpy() -> None:
    import numpy as np

    location = Path(np.__file__).resolve()
    print(f"numpy {np.__version__} from {location}")
    if DEPS.resolve() not in location.parents:
        raise SystemExit("numpy import did not come from .smoke-deps")


def promote_ready_still_false() -> None:
    for path in sorted(DATA.glob("*.json")):
        payload = json.loads(path.read_text())
        if isinstance(payload, dict) and "promote_ready" in payload:
            if payload["promote_ready"] is not False:
                raise SystemExit(
                    f"{path.relative_to(ROOT)} promote_ready is {payload['promote_ready']!r}"
                )


def main() -> int:
    require_installed_numpy()
    before = snapshot()
    for script in SHORT:
        relative = script.relative_to(ROOT)
        print(f"=== {relative} ===", flush=True)
        completed = subprocess.run([sys.executable, str(script)], cwd=ROOT, check=False)
        print(f"exit {completed.returncode} {relative}", flush=True)
        if completed.returncode != 0:
            return completed.returncode
    after = snapshot()
    if before != after:
        added = sorted(set(after) - set(before))
        removed = sorted(set(before) - set(after))
        changed = sorted(key for key in before.keys() & after.keys() if before[key] != after[key])
        print("data/ changed", file=sys.stderr)
        if added:
            print(f"added: {added}", file=sys.stderr)
        if removed:
            print(f"removed: {removed}", file=sys.stderr)
        if changed:
            print(f"changed: {changed}", file=sys.stderr)
        return 1
    promote_ready_still_false()
    print("data/ unchanged")
    print("promote_ready still false")
    print("not started: samplers/generic/multi_twist_walk.py")
    print("not started: samplers/generic/continuous_monodromy.py")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
