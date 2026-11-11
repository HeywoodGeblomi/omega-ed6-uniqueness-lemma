# Uniqueness of the scaled pair

This certificate is a uniqueness lemma. It is not a measurement of the
global Masur–Veech average of $\lambda_1^+,\lambda_2^+$ on $H_1^+$ of
$\Omega E_D(6)$. The average stays open. `promote_ready` stays `false`.

If the positive parts are in ratio $2:1$, and if the Eskin–Kontsevich–Zorich
literature hypothesis `ekzSum` $= 6/7$ is the sum, then the pair is uniquely
$4/7$ and $2/7$. The closed geodesic supplies the ratio. EKZ supplies the
sum. `6/7` is that named hypothesis, not a bare numeral inside the scale factor.

`PeriodicRawSpectrum.lean` proves this as `unique_scaled_pair`: for rationals
$x,y$,

$$
y \neq 0 \land x/y = 2 \land x + y = \mathrm{ekzSum}
\quad\Longleftrightarrow\quad
x = 4/7 \land y = 2/7.
$$

`path_local_scaled_is_unique_pair` instantiates the lemma on the stored
spectrum. `raw_spectrum_shape` says that spectrum is $[\lambda,\mu,-\mu,-\lambda]$
with $\lambda/\mu = 2$, and the stored values are $\lambda = 1$, $\mu = 1/2$.
`unit_sum_normalization` says the positive parts scaled to sum to $1$ are
exactly $2/3$ and $1/3$. `unit_sum_spectrum_eq` extends that to
$[2/3,\,1/3,\,-1/3,\,-2/3]$.

## Typography, not a second identity

`data/kz_along_A.json` prints `normalized_by_log_rho` as
`0.6667, 0.3333, -0.3333, -0.6667` and `scaled_to_6_7` as
`0.5714, 0.2857`. Those are four-decimal spellings.

`typography_signed_errors` records the exact gaps
($1/30000$, $1/35000$, $1/70000$). Each gap is strictly smaller than half a
unit in the fourth decimal place (`halfUlp` $= 1/20000$).
`nearest_four_decimal` says a rational has at most one four-decimal numeral
inside that neighborhood, so `0.6667` is the nearest spelling of $2/3$, and
likewise for $1/3$, $4/7$, and $2/7$.
`typography_is_not_identity` says the numerals are not equal to those
rationals. `normalized_by_log_rho` matches the unit-sum spectrum above. It
is not `raw_lyapunov` divided by `log_rho_A`.

`rawLyapunovDecimals` is the separate list `[1.0, 0.5, -0.5, -1.0]`.
`raw_lyapunov_matches_spectrum` says those dyadic decimals are the stored
spectrum on the nose. `scripts/check_raw_lyapunov_correspondence.py` compares
that list, and the two typography lists, with the JSON file. It does not
rewrite `data/`.

`thin_sampler_not_two_to_one` says $11/21$ and $1/3$ also sum to `ekzSum`,
but their ratio is $11/7$, not $2$. Thin X(2,0) walks are not this pair.

## What this file does not prove

- The Masur–Veech / Lyapunov measure average. Still open.
- That the stored matrix `A` produces this spectrum.
- Yu–Zuo's individual Weierstrass exponents, or the Möller attribution.
  Those stay literature, as in `docs/LITERATURE_BASELINE.md`.
- An interval or QR remainder bound. The error model in
  `certificates/error_model.md` is not met.

No Mathlib and no `sorry`. Core `Rat` only. The public theorems depend on
`propext`, `Classical.choice`, and `Quot.sound`.

## Run

From the repository root, with [elan](https://github.com/leanprover/elan)
so `lean-toolchain` (`leanprover/lean4:v4.35.0`) is installed:

```sh
cd lean && lake build
```

The JSON correspondence check, which does not write under `data/`:

```sh
python3 scripts/check_raw_lyapunov_correspondence.py
```
