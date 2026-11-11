"""Generic sampler skeleton — long Rauzy / Teichmüller paths.

Owner: Harper.

Goal: approximate the Masur–Veech / EKZ average of λ1+, λ2+ on H1+
for the X(1,1) prototype in ΩE5(6).

Requirements:
- Same residual-0 geometric basis as the periodic sampler.
- QR (or interval) accumulation via certificates.qr_error_model.
- Always report side-by-side with the periodic spectrum.
- Prefer sage-flatsurf if it shortens the path.

promote_ready stays false until error bars are rigorous and the average is pinned.
"""
from __future__ import annotations

from pathlib import Path
from typing import Iterator

import numpy as np

import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from certificates.qr_error_model import LyapEstimate, qr_lyapunov, report_side_by_side


def iter_monodromy_steps(n_steps: int) -> Iterator[np.ndarray]:
    """Yield Sp(4)-valued steps along a generic orbit.

    REPLACE THIS with real Rauzy–Veech / continuous Teichmüller monodromy
    on the pinned X(1,1) surface. Current body is a non-mixing placeholder
    so the pipeline wiring can be tested.
    """
    rng = np.random.default_rng(0)
    for _ in range(n_steps):
        # placeholder: random near-identity symplectic noise (NOT geometry)
        X = 0.01 * rng.standard_normal((4, 4))
        # project to SL(4) crudely — Harper must replace with true Sp(4) steps
        M = np.eye(4) + X
        M /= np.sign(np.linalg.det(M)) * abs(np.linalg.det(M)) ** 0.25
        yield M


def run_generic(n_steps: int = 10_000) -> LyapEstimate:
    products = list(iter_monodromy_steps(n_steps))
    return qr_lyapunov(products)


def main() -> None:
    generic = run_generic(2000)
    # Four-decimal typography for the unit-sum rationals. Not an exact orbit
    # and not an error bar: interval/QR remainder is not met.
    periodic = LyapEstimate(
        values=(0.6667, 0.3333, -0.3333, -0.6667),
        err=(float("nan"), float("nan"), float("nan"), float("nan")),
        steps=1,
        method="typography",
        notes="four-decimal typography only; no interval/QR bar",
    )
    print(report_side_by_side(periodic, generic))
    print("periodic column is four-decimal typography, not an exact orbit and not an error bar.")
    print("NOTE: generic body is a PLACEHOLDER. Replace iter_monodromy_steps with real geometry.")
    print("not a measurement of the global Masur–Veech average")
    print("promote_ready: false")


if __name__ == "__main__":
    main()
