# A-to-ratio toy model, v1

Checked Lean files for one stored pair of matrices from a toy model. **`promote_ready` stays false.**

## Caveats

- **(a)** This is a toy model. It is not shown that any real Prym surface produces this word or these matrices.
- **(b)** If the twist blocks use the sign convention consistent with how a twist acts on each torus, as computed in `toy_model/toy_model.py`, the block traces become 18 and 8, and the ratio is about 1.399, not 2. The exact 2:1 depends on the toy model's sign choice.
- **(c)** It doesn't prove these are the only eigenvalues; that needs Mathlib.
- **(d)** It covers one closed geodesic, not the measure average. Rescaling to the 6/7 EKZ sum, which gives 4/7 and 2/7, is not addressed here.

## `a_to_ratio_v1/AToRatio.lean`

This file uses core Lean 4.35.0 with no Mathlib.

Its inputs are A and M_plus, copied verbatim from HeywoodGeblomi/omega-ed6-h1plus-measure `data/kz_along_A.json` at commit `b7c4a7a` (file sha256 `06e6a20f0bdd14dc6c31fc1a174aa09c1286abd1fa0f2bee2dd6ed19e740a50e`). A copy of that file is included as `a_to_ratio_v1/kz_along_A.json`.

It proves four things:

1. One 5-letter word in a toy two-torus model, from `toy_model/toy_model.py`, produces both A (the action on the plane) and M_plus (the action on H1+).
2. M_plus is block-diagonal.
3. Exact eigenvectors in ℤ[√3]: A has eigenvalue (2+√3)³, and the two blocks have −(2+√3)² and −(2+√3). Each has determinant 1.
4. So the top growth rates are exactly 3:2:1 in units of log(2+√3). That is, the M_plus rates are exactly 2/3 and 1/3 of log ρ(A), a ratio of exactly 2:1.

Saved axiom output: `propext` only.

## `direct_checks_v1/`

`Independent.lean` is an independent restatement written by a separate reviewer (Cheddar-Panama), unchanged.

`Direct.lean` proves its TraceDet and CubeIsSpectralRadius facts directly, plus an eigenvector check for A. These use no axioms at all.

## `axioms_logs_v1/`

This directory holds the saved `#print axioms` outputs.
