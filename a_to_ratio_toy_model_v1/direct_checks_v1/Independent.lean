/-
Independent restatement of the ED6 uniqueness claim, v1 (Cheddar-Panama), core Lean 4.35.0, no Mathlib.
SOURCE AND EXPOSURE: written from the claim as stated in prose in this room and in Lucas's Nov 11 brief
("ratio 2:1, sum 6/7, so exactly 4/7 and 2/7"; "A = [[31,10],[65,21]], rho(A) = 26+15*sqrt 3 = (2+sqrt 3)^3").
I did not open `unique_scaled_pair` or its file for this, but I have read Lucas's write-ups and summaries of
it, so this is NOT blind to his statement. Treat it as exposed, the way Anthropic's README treats theirs.
Deliberate differences from how the room has described his lemma: ratio is stated as x = 2*y (no division,
no y ≠ 0 hypothesis), and existence is stated separately so the uniqueness claim can't be vacuous.
NOT RESTATED: the M₊ block split into 2/3 and 1/3 (I have no source for M₊ beyond the summary line).
-/
namespace CheddarIndependent

/-- Two weights in ratio 2:1 that sum to 6/7 are exactly 4/7 and 2/7. -/
def SplitUnique : Prop := ∀ x y : Rat, x = 2 * y → x + y = 6 / 7 → x = 4 / 7 ∧ y = 2 / 7

/-- And that pair really exists, so SplitUnique is not true for an empty reason. -/
def SplitExists : Prop := (4 / 7 : Rat) = 2 * (2 / 7) ∧ (4 / 7 : Rat) + 2 / 7 = 6 / 7

/-- A = [[31,10],[65,21]] has trace 52 and determinant 1, so its characteristic polynomial is t² − 52t + 1. -/
def TraceDet : Prop := (31 + 21 : Int) = 52 ∧ (31 * 21 - 10 * 65 : Int) = 1

/-- Numbers a + b√3 encoded as integer pairs (a, b); this encoding is my assumption and a reader must accept it. -/
def mulZ3 (p q : Int × Int) : Int × Int := (p.1 * q.1 + 3 * p.2 * q.2, p.1 * q.2 + p.2 * q.1)

/-- (2+√3)³ = 26 + 15√3, and 26 ± 15√3 have sum 52 and product 26² − 3·15² = 1, matching trace and determinant,
so they are A's two eigenvalues and the larger, 26 + 15√3, is ρ(A). -/
def CubeIsSpectralRadius : Prop :=
  mulZ3 (2, 1) (mulZ3 (2, 1) (2, 1)) = (26, 15) ∧ (2 * 26 : Int) = 52 ∧ (26 * 26 - 3 * 15 * 15 : Int) = 1

end CheddarIndependent
