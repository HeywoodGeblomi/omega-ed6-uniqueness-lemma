"""Periodic sampler smoke: stored spectrum along the example closed geodesic A.

Path-local ratio only. Not a measurement of the Masur–Veech average.

`normalized_by_log_rho` and `scaled_to_6_7` are four-decimal typography.
This script does not treat those truncated floats as exact and does not
report an error bar of 0. The interval/QR remainder model is not met.
`promote_ready` stays false.
"""
from __future__ import annotations

import json
from decimal import Decimal
from fractions import Fraction
from pathlib import Path

import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from certificates.qr_error_model import LyapEstimate, report_side_by_side

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "data" / "kz_along_A.json"


def main() -> None:
    rec = json.loads(DATA.read_text(), parse_float=Decimal)
    raw = [Fraction(value) for value in rec["raw_lyapunov"]]
    positives = [value for value in raw if value > 0]
    ratio = positives[0] / positives[1]
    print("path-local raw_lyapunov:", ", ".join(str(value) for value in raw))
    print("positive ratio from raw_lyapunov:", ratio)
    print(
        "normalized_by_log_rho is four-decimal typography for the unit-sum "
        "rationals, not an identity and not raw/log_rho_A:",
        ", ".join(str(value) for value in rec["normalized_by_log_rho"]),
    )
    print(
        "scaled_to_6_7 is four-decimal typography for 4/7 and 2/7, not an identity:",
        ", ".join(str(value) for value in rec["scaled_to_6_7"]),
    )
    print("Lean unique_scaled_pair: a 2:1 ratio and the EKZ sum 6/7 determine 4/7 and 2/7")
    print("no error bar: interval/QR remainder is not met")
    print("not a measurement of the global Masur–Veech average")
    print("promote_ready: false")
    # Stored raw list only. nan marks the absence of an error bar.
    # The dyadic values 1, 1/2, -1/2, -1 are exact in binary floating point;
    # that is still not an interval/QR certificate.
    periodic = LyapEstimate(
        values=tuple(float(value) for value in raw),
        err=tuple(float("nan") for _ in raw),
        steps=1,
        method="stored_list",
        notes="path-local raw_lyapunov; no interval/QR bar",
    )
    # Placeholder generic until Harper lands the long-path sampler
    generic = LyapEstimate(
        values=(0.43, 0.43, -0.43, -0.43),
        err=(0.05, 0.05, 0.05, 0.05),
        steps=0,
        method="qr_float",
        notes="PLACEHOLDER — isotropic random-walk contrast from prior note",
    )
    print()
    print(report_side_by_side(periodic, generic))
    print("periodic column is the stored raw list, not a certified enclosure")


if __name__ == "__main__":
    main()
