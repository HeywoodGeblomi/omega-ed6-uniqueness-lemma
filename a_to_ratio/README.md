# A to ratio (toy two-torus model)

This folder checks, in core Lean 4.35.0 with no Mathlib and no `sorry`, where the 2:1 ratio in the stored data comes from. It uses the matrices `A` and `M_plus` in [`../data/kz_along_A.json`](../data/kz_along_A.json), not the stored `raw_lyapunov` numbers.

Write u = 2 + √3. Lean proves, with explicit eigenvectors over Z[√3]:

- `A = [[31,10],[65,21]]` has eigenvalue u³.
- `M_plus` splits into two 2×2 blocks with eigenvalues −u² and −u.
- So along this one closed geodesic the plus-part exponents are 2/3 and 1/3 of log ρ(A), and the ratio is exactly 2.
- `M_plus` satisfies (M² + 14M + I)(M² + 4M + I) = 0, so it has no other eigenvalues. `A` satisfies A² − 52A + I = 0.

## The caveat that matters

`M_plus` comes from a simplified two-torus model, not from a real Prym surface in ΩE_D(6). With the other sign choice for the twists, the blocks have traces 18 and 8 and the ratio is about 1.40 instead of 2. So the exact 2:1 is a fact about this toy model's sign choice. It is not yet a fact about the real exponents, and it says nothing about the Masur–Veech average, the 6/7 sum, or the 4/7 and 2/7 pair.

`A` is not a block of `M_plus`. `A` acts on the tautological plane, which sits in the minus part, while `M_plus` is the plus part. The only tie Lean shows is that all three growth rates are powers of the same unit u.

## Run

```sh
python3 check_inputs.py                          # pins the JSON hash and checks the Lean literals against it
lean +leanprover/lean4:v4.35.0 AToRatio.lean     # builds and prints the axioms
```

[`AXIOMS.txt`](AXIOMS.txt) is the saved axiom output: only `propext`, `Classical.choice` and `Quot.sound`.

Assumptions Lean does not check are listed at the top of [`AToRatio.lean`](AToRatio.lean) as S1 to S4.
