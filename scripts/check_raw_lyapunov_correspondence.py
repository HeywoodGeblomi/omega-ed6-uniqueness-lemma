"""Bind Lean spectrum constants to data/kz_along_A.json.

Reads both files. Does not write under data/.

`raw_lyapunov` must match `rawLyapunovDecimals` in
`lean/PeriodicRawSpectrum.lean`. The four-decimal fields
`normalized_by_log_rho` and `scaled_to_6_7` must match the Lean typography
lists. Those lists are spellings of exact rationals; this script does not
treat them as a second identity, and it does not treat
`normalized_by_log_rho` as `raw_lyapunov / log_rho_A`.

`promote_ready` must stay false.
"""
from __future__ import annotations

import json
import re
import sys
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "data" / "kz_along_A.json"
LEAN_PATH = ROOT / "lean" / "PeriodicRawSpectrum.lean"

REQUIRED_THEOREMS = (
    "theorem unique_scaled_pair",
    "theorem path_local_scaled_is_unique_pair",
    "theorem raw_spectrum_shape",
    "theorem unit_sum_normalization",
    "theorem raw_lyapunov_matches_spectrum",
    "theorem normalized_by_log_rho_typography",
    "theorem scaled_to_6_7_typography",
    "theorem typography_is_not_identity",
    "theorem typography_signed_errors",
    "theorem nearest_four_decimal",
    "theorem thin_sampler_not_two_to_one",
)


def lean_rat_list(src: str, name: str) -> list[Decimal]:
    match = re.search(rf"^def {name} : List Rat := \[([^\]]+)\]\s*$", src, re.M)
    if match is None:
        raise SystemExit(f"missing Lean definition {name}")
    return [Decimal(part.strip()) for part in match.group(1).split(",")]


def as_decimals(values: object, label: str) -> list[Decimal]:
    if not isinstance(values, list) or not values:
        raise SystemExit(f"{label} is not a nonempty list")
    return [Decimal(value) for value in values]


def main() -> int:
    src = LEAN_PATH.read_text()
    payload = json.loads(JSON_PATH.read_text(), parse_float=Decimal)
    if payload.get("promote_ready") is not False:
        raise SystemExit(f"promote_ready is {payload.get('promote_ready')!r}")
    if "def ekzSum : Rat := 6 / 7" not in src:
        raise SystemExit("ekzSum hypothesis is missing from the Lean source")
    for name in REQUIRED_THEOREMS:
        if name not in src:
            raise SystemExit(f"missing {name}")

    pairs = (
        ("raw_lyapunov", "rawLyapunovDecimals"),
        ("normalized_by_log_rho", "normalizedByLogRhoTypography"),
        ("scaled_to_6_7", "scaledToSixSeventhsTypography"),
    )
    for field, definition in pairs:
        stored = as_decimals(payload[field], field)
        declared = lean_rat_list(src, definition)
        if stored != declared:
            raise SystemExit(f"{field} {stored} != Lean {definition} {declared}")

    print("raw_lyapunov matches Lean rawLyapunovDecimals")
    print("normalized_by_log_rho matches Lean typography, not a second identity")
    print("scaled_to_6_7 matches Lean typography, not a second identity")
    print("promote_ready is false")
    return 0


if __name__ == "__main__":
    sys.exit(main())
