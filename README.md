# Uniqueness of the scaled pair

This public repository certifies a **uniqueness lemma**, not a measurement of the global Masur–Veech average of \(\lambda_1^+\), \(\lambda_2^+\) on \(H_1^+\) of \(\Omega E_D(6)\). The average stays open. `promote_ready` stays `false`.

If the positive parts are in ratio \(2:1\), and if the Eskin–Kontsevich–Zorich literature hypothesis `ekzSum` \(= 6/7\) is their sum, then the pair is uniquely \(4/7\) and \(2/7\). The closed geodesic supplies the ratio. EKZ supplies the sum.

The lead theorem is `unique_scaled_pair` in [`lean/PeriodicRawSpectrum.lean`](lean/PeriodicRawSpectrum.lean). The four-decimal JSON spellings `0.6667`, `0.3333`, `0.5714`, and `0.2857` are typography for \(2/3\), \(1/3\), \(4/7\), and \(2/7\); they are not those rationals. See [`docs/UNIQUENESS_LEMMA.md`](docs/UNIQUENESS_LEMMA.md) and [`lean/README.md`](lean/README.md).

Cursor cloud-agent run data for this formalization is in [`cursor/`](cursor/).

Where the 2:1 comes from: [`a_to_ratio/`](a_to_ratio/) derives it in Lean from the stored matrices `A` and `M_plus`, not from the stored exponent numbers. That holds only in a simplified two-torus model. With the other sign choice for the twists, the ratio there is about 1.40.

## Run

With [elan](https://github.com/leanprover/elan) so the pinned toolchain `leanprover/lean4:v4.35.0` is installed:

```sh
cd lean && lake build
```

JSON correspondence check (does not write under `data/`):

```sh
python3 scripts/check_raw_lyapunov_correspondence.py
```

No Mathlib and no `sorry`. Core `Rat` only.

## What this does not prove

- The Masur–Veech / Lyapunov measure average. Still open. The \(4/7+2/7\) candidate stays a conjecture.
- That the stored matrix \(A\) produces this spectrum on a real surface. [`a_to_ratio/`](a_to_ratio/) checks it only in the toy model.
- Yu–Zuo’s individual Weierstrass exponents, or the Möller attribution.
- An interval or QR remainder bound.

This is a public snapshot of the uniqueness-lemma work at commit `7b7447be237146a6be1dfac4ccca08a364a1d0a0`. The original measure-average project remains private.
