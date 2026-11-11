# Run report

The lead claim is a uniqueness lemma, not a measurement.

If the positive parts are in ratio \(2:1\) and their sum is the Eskin–Kontsevich–Zorich hypothesis `ekzSum = 6/7`, the pair is uniquely \(4/7\) and \(2/7\). The closed geodesic supplies the ratio. EKZ supplies the sum. The global average on \(H_1^+\) of \(\Omega E_D(6)\) stays open.

## Proved in `lean/PeriodicRawSpectrum.lean`

Core `Rat`, no Mathlib, no `sorry`.

- `unique_scaled_pair` — for rationals \(x, y\), the conditions \(y \neq 0\), \(x/y = 2\), and \(x + y =\) `ekzSum` are equivalent to \(x = 4/7\) and \(y = 2/7\).
- `path_local_scaled_is_unique_pair` — the stored spectrum \([1, 1/2, -1/2, -1]\) has that ratio, and scaling it onto `ekzSum` is that unique pair.
- `raw_spectrum_shape` and `raw_signs` — the spectrum is \([\lambda, \mu, -\mu, -\lambda]\) with \(\lambda/\mu = 2\), \(\lambda = 1\), \(\mu = 1/2\).
- `unit_sum_normalization` and `unit_sum_spectrum_eq` — positive parts scaled to sum to \(1\) are exactly \(2/3\) and \(1/3\), and the full list is \([2/3, 1/3, -1/3, -2/3]\).
- `typography_signed_errors`, `normalized_by_log_rho_typography`, `scaled_to_6_7_typography`, and `nearest_four_decimal` — the JSON spellings \(0.6667\), \(0.3333\), \(-0.3333\), \(-0.6667\), \(0.5714\), and \(0.2857\) are the unique four-decimal numerals within half a unit in the fourth place (exact gaps \(1/30000\), \(1/35000\), and \(1/70000\)). `typography_is_not_identity` says those numerals are not the rationals. This is typography for the unit-sum spectrum and the unique pair, not a second identity, and not `raw_lyapunov / log_rho_A`.
- `raw_lyapunov_matches_spectrum` — the dyadic spellings \(1.0\), \(0.5\), \(-0.5\), \(-1.0\) equal the stored spectrum. `scripts/check_raw_lyapunov_correspondence.py` compares those Lean lists with `data/kz_along_A.json` and does not rewrite it.
- `thin_sampler_not_two_to_one` — \(11/21\) and \(1/3\) also sum to \(6/7\), but the ratio is \(11/7\), not \(2\).

## Not proved

- The Masur–Veech average
- That matrix \(A\) produces this spectrum
- Yu–Zuo’s individual Weierstrass exponents
- An interval or QR remainder bound

`promote_ready` stays false. Files under `data/` are unchanged from the source snapshot.
