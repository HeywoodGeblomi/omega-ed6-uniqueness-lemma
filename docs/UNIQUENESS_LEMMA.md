# Uniqueness lemma

This is not a measurement of the global Masur–Veech average on $H_1^+$ of
$\Omega E_D(6)$. The average stays open. The candidate $4/7 + 2/7$ stays a
conjecture. `promote_ready` stays `false`.

The certified claim is a uniqueness lemma. The closed geodesic supplies a
positive ratio $2:1$. Eskin–Kontsevich–Zorich supply the sum $6/7$, taken
here as a named literature hypothesis `ekzSum`, not as a numeral buried in
a scale factor. Those two inputs determine a unique pair:

$$\lambda_1^+ = \frac{4}{7}, \qquad \lambda_2^+ = \frac{2}{7}.$$

Lean states this as `unique_scaled_pair` in
[`lean/PeriodicRawSpectrum.lean`](../lean/PeriodicRawSpectrum.lean): for
rationals $x,y$,

$$
y \neq 0,\quad x/y = 2,\quad x+y = 6/7
\quad\Longleftrightarrow\quad
x = 4/7,\quad y = 2/7.
$$

`path_local_scaled_is_unique_pair` plugs in the stored spectrum
`[1, 1/2, -1/2, -1]` from `data/kz_along_A.json` (`raw_lyapunov`).
`raw_spectrum_shape` records the shape $[\lambda, \mu, -\mu, -\lambda]$ with
$\lambda/\mu = 2$. `unit_sum_normalization` says the positive parts scaled
to sum to $1$ are exactly $2/3$ and $1/3$.

## Typography check

`normalized_by_log_rho` prints `0.6667, 0.3333, -0.3333, -0.6667`.
`scaled_to_6_7` prints `0.5714, 0.2857`. Those four-decimal numerals are
typography for $2/3$, $1/3$, $-1/3$, $-2/3$ and for $4/7$, $2/7$.

`typography_signed_errors` gives the exact gaps. Each is strictly less than
half a unit in the fourth place, and `nearest_four_decimal` says that
neighborhood contains only one four-decimal numeral.
`typography_is_not_identity` says the numerals are not the rationals.
This check does not prove a second identity. In particular
`normalized_by_log_rho` is the unit-sum normalization above, not
`raw_lyapunov / log_rho_A`. A print such as `2.000300` from the truncated
fields is typography, not a defect in the exact ratio $2$.

`scripts/check_raw_lyapunov_correspondence.py` compares the Lean lists with
the JSON file and does not change stored values. `raw_lyapunov` itself is
the dyadic list `1.0, 0.5, -0.5, -1.0`, which matches $[1, 1/2, -1/2, -1]$
exactly.

## What stays unproved

The lemma does not say that the global average equals this pair, that
matrix $A$ produces the spectrum, or that Yu–Zuo's Weierstrass exponents
on the even component of $\Omega\mathcal{M}_4(6)$ are a theorem of this
repository. Thin X(2,0) walks are a different splitting:
`thin_sampler_not_two_to_one` shows $11/21$ and $1/3$ also sum to $6/7$,
with ratio $11/7$ rather than $2$. The interval/QR remainder model is not
met.
