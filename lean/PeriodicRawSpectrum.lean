import Init.Data.Rat.Lemmas

/-!
# Uniqueness of the scaled pair

Lead claim of this file. It is not a measurement of the global Masur–Veech
average of `λ₁⁺`, `λ₂⁺` on `H₁⁺` of `ΩE_D(6)`.

`unique_scaled_pair`: if the positive parts are in ratio `2 : 1` and their
sum is the Eskin–Kontsevich–Zorich literature hypothesis `ekzSum = 6/7`,
then the pair is uniquely `4/7` and `2/7`. The closed geodesic supplies the
ratio. EKZ supplies the sum. The average stays open, and `promote_ready`
stays `false`.

`path_local_scaled_is_unique_pair` instantiates that lemma on the stored
spectrum `[λ, μ, -μ, -λ] = [1, 1/2, -1/2, -1]`
(`data/kz_along_A.json`, field `raw_lyapunov`). The positive parts in
unit-sum normalization are exactly `2/3` and `1/3`.

The JSON fields `normalized_by_log_rho` and `scaled_to_6_7` are four-decimal
typography for those rationals and for `4/7`, `2/7`. `nearest_four_decimal`
says a spelling within half a unit in the fourth place is unique.
`typography_is_not_identity` says the printed numerals are not the rationals.
`normalized_by_log_rho` is not `raw_lyapunov / log_rho_A`.

No Mathlib and no `sorry`. Core `Rat` only.
-/

namespace PeriodicRawSpectrum

/-! ### EKZ sum, as a hypothesis -/

/-- Literature hypothesis, not a theorem of this file.
Eskin–Kontsevich–Zorich supply `λ₁⁺ + λ₂⁺ = 6/7` on `H₁⁺` of `ΩE_D(6)`.
This file does not split that sum by the Masur–Veech measure. -/
def ekzSum : Rat := 6 / 7

/-! ### Uniqueness lemma -/

private theorem div_eq_mul {x y : Rat} (hy : y ≠ 0) (hr : x / y = 2) : x = 2 * y := by
  have := congrArg (· * y) hr
  simpa [Rat.div_mul_cancel hy] using this

/-- If `y ≠ 0`, `x / y = 2`, and `x + y = ekzSum`, then `(x, y) = (4/7, 2/7)`,
and conversely. The EKZ sum is an input. The ratio is an input. -/
theorem unique_scaled_pair (x y : Rat) :
    (y ≠ 0 ∧ x / y = 2 ∧ x + y = ekzSum) ↔ x = 4 / 7 ∧ y = 2 / 7 := by
  constructor
  · intro ⟨hy, hr, hs⟩
    have hx : x = 2 * y := div_eq_mul hy hr
    have hy3 : (3 : Rat) * y = ekzSum := by
      rw [hx] at hs
      have : (2 : Rat) * y + y = 3 * y := by grind
      rwa [this] at hs
    have hy' : y = ekzSum / 3 := by
      have h3 : (3 : Rat) ≠ 0 := by decide
      calc
        y = (3 * y) / 3 := by grind
        _ = ekzSum / 3 := by rw [hy3]
    have hyv : y = 2 / 7 := by
      rw [hy', ekzSum]
      grind
    have hxv : x = 4 / 7 := by
      rw [hx, hyv]
      grind
    exact ⟨hxv, hyv⟩
  · rintro ⟨rfl, rfl⟩
    refine ⟨?_, ?_, ?_⟩
    · grind
    · grind
    · unfold ekzSum
      grind

/-! ### Stored path-local spectrum -/

/-- Positive part `λ` of the stored raw spectrum. -/
def lambdaRaw : Rat := 1

/-- Positive part `μ` of the stored raw spectrum. -/
def muRaw : Rat := 1 / 2

/-- Stored periodic raw spectrum, in the shape `[λ, μ, -μ, -λ]`. -/
def rawSpectrum : List Rat := [lambdaRaw, muRaw, -muRaw, -lambdaRaw]

/-- The stored spectrum has shape `[λ, μ, -μ, -λ]` with `λ / μ = 2`. -/
theorem raw_spectrum_shape :
    rawSpectrum = [lambdaRaw, muRaw, -muRaw, -lambdaRaw] ∧
      lambdaRaw = 1 ∧ muRaw = 1 / 2 ∧ muRaw ≠ 0 ∧ lambdaRaw / muRaw = 2 := by
  refine ⟨rfl, rfl, rfl, ?_⟩
  unfold lambdaRaw muRaw
  grind

/-- Both positive entries are positive, and both negative entries are negative. -/
theorem raw_signs :
    0 < lambdaRaw ∧ 0 < muRaw ∧ -muRaw < 0 ∧ -lambdaRaw < 0 := by
  unfold lambdaRaw muRaw
  grind

/-- Positive parts scaled to sum to `1` are exactly `2/3` and `1/3`. -/
theorem unit_sum_normalization :
    lambdaRaw / (lambdaRaw + muRaw) = 2 / 3 ∧
      muRaw / (lambdaRaw + muRaw) = 1 / 3 ∧
        lambdaRaw / (lambdaRaw + muRaw) + muRaw / (lambdaRaw + muRaw) = 1 := by
  unfold lambdaRaw muRaw
  grind

/-- Unit-sum normalization of the whole antisymmetric spectrum. -/
def unitSumSpectrum : List Rat :=
  [lambdaRaw / (lambdaRaw + muRaw), muRaw / (lambdaRaw + muRaw),
    -muRaw / (lambdaRaw + muRaw), -lambdaRaw / (lambdaRaw + muRaw)]

theorem unit_sum_spectrum_eq :
    unitSumSpectrum = [(2 : Rat) / 3, 1 / 3, -(1 / 3), -(2 / 3)] := by
  have hLam : lambdaRaw / (lambdaRaw + muRaw) = 2 / 3 := by
    unfold lambdaRaw muRaw
    grind
  have hMu : muRaw / (lambdaRaw + muRaw) = 1 / 3 := by
    unfold lambdaRaw muRaw
    grind
  have hMuNeg : -muRaw / (lambdaRaw + muRaw) = -(1 / 3) := by
    unfold lambdaRaw muRaw
    grind
  have hLamNeg : -lambdaRaw / (lambdaRaw + muRaw) = -(2 / 3) := by
    unfold lambdaRaw muRaw
    grind
  unfold unitSumSpectrum
  rw [hLam, hMu, hMuNeg, hLamNeg]

/-- Multiplier sending `λ + μ` to the EKZ hypothesis. The `6/7` sits in
`ekzSum`, not as a bare numeral here. -/
def scaleFactor : Rat := ekzSum / (lambdaRaw + muRaw)

theorem scale_factor_hits_ekz_sum :
    (lambdaRaw + muRaw) * scaleFactor = ekzSum := by
  have hne : lambdaRaw + muRaw ≠ 0 := by
    unfold lambdaRaw muRaw
    grind
  unfold scaleFactor
  rw [Rat.mul_comm]
  exact Rat.div_mul_cancel hne

/-- The stored ratio, scaled onto `ekzSum`, is the unique pair `4/7`, `2/7`. -/
theorem path_local_scaled_is_unique_pair :
    muRaw * scaleFactor ≠ 0 ∧
      (lambdaRaw * scaleFactor) / (muRaw * scaleFactor) = 2 ∧
        lambdaRaw * scaleFactor + muRaw * scaleFactor = ekzSum ∧
          lambdaRaw * scaleFactor = 4 / 7 ∧
            muRaw * scaleFactor = 2 / 7 := by
  have hy : muRaw * scaleFactor ≠ 0 := by
    unfold scaleFactor ekzSum lambdaRaw muRaw
    grind
  have hr : (lambdaRaw * scaleFactor) / (muRaw * scaleFactor) = 2 := by
    unfold scaleFactor ekzSum lambdaRaw muRaw
    grind
  have hs : lambdaRaw * scaleFactor + muRaw * scaleFactor = ekzSum := by
    unfold scaleFactor ekzSum lambdaRaw muRaw
    grind
  have hpair :=
    (unique_scaled_pair (lambdaRaw * scaleFactor) (muRaw * scaleFactor)).mp ⟨hy, hr, hs⟩
  exact ⟨hy, hr, hs, hpair.1, hpair.2⟩

/-! ### Correspondence with `raw_lyapunov`

`scripts/check_raw_lyapunov_correspondence.py` compares
`rawLyapunovDecimals` with `data/kz_along_A.json`. These four decimals are
dyadic and equal the stored spectrum. They are not four-decimal truncations.
-/

/-- Decimal spellings of `raw_lyapunov`, in stored order. -/
def rawLyapunovDecimals : List Rat := [1.0, 0.5, -0.5, -1.0]

private theorem decimal_1_0 : (1.0 : Rat) = 1 := by
  have h : (1.0 : Rat) = (10 : Rat) / 10 := by
    show OfScientific.ofScientific (10 : Nat) true (1 : Nat) = _
    rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
    have : (10 : Nat) ^ 1 = 10 := by decide
    rw [this, Rat.mkRat_eq_div]
    rfl
  rw [h]
  grind

private theorem decimal_0_5 : (0.5 : Rat) = 1 / 2 := by
  have h : (0.5 : Rat) = (5 : Rat) / 10 := by
    show OfScientific.ofScientific (5 : Nat) true (1 : Nat) = _
    rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
    have : (10 : Nat) ^ 1 = 10 := by decide
    rw [this, Rat.mkRat_eq_div]
    rfl
  rw [h]
  grind

theorem raw_lyapunov_matches_spectrum : rawLyapunovDecimals = rawSpectrum := by
  unfold rawLyapunovDecimals rawSpectrum lambdaRaw muRaw
  rw [decimal_1_0, decimal_0_5]

/-! ### Four-decimal typography

`normalized_by_log_rho` and `scaled_to_6_7` print four digits. Each printed
numeral is the unique four-decimal rational within half a unit in the fourth
place of an exact rational proved above. The numeral is not that rational.
-/

/-- The rational denoted by a four-decimal numeral `n`, that is `n / 10000`. -/
def fourDecimal (n : Int) : Rat := (n : Rat) / 10000

/-- Half a unit in the fourth decimal place. -/
def halfUlp : Rat := 1 / 20000

/-- Spellings in `normalized_by_log_rho`. Typography, not a second identity. -/
def normalizedByLogRhoTypography : List Rat := [0.6667, 0.3333, -0.3333, -0.6667]

/-- Spellings in `scaled_to_6_7`. Typography, not a second identity. -/
def scaledToSixSeventhsTypography : List Rat := [0.5714, 0.2857]

private theorem decimal_6667 : (0.6667 : Rat) = (6667 : Rat) / 10000 := by
  show OfScientific.ofScientific (6667 : Nat) true (4 : Nat) = _
  rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
  have : (10 : Nat) ^ 4 = 10000 := by decide
  rw [this, Rat.mkRat_eq_div]
  rfl

private theorem decimal_3333 : (0.3333 : Rat) = (3333 : Rat) / 10000 := by
  show OfScientific.ofScientific (3333 : Nat) true (4 : Nat) = _
  rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
  have : (10 : Nat) ^ 4 = 10000 := by decide
  rw [this, Rat.mkRat_eq_div]
  rfl

private theorem decimal_5714 : (0.5714 : Rat) = (5714 : Rat) / 10000 := by
  show OfScientific.ofScientific (5714 : Nat) true (4 : Nat) = _
  rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
  have : (10 : Nat) ^ 4 = 10000 := by decide
  rw [this, Rat.mkRat_eq_div]
  rfl

private theorem decimal_2857 : (0.2857 : Rat) = (2857 : Rat) / 10000 := by
  show OfScientific.ofScientific (2857 : Nat) true (4 : Nat) = _
  rw [← Rat.ofScientific_ofNat_ofNat, Rat.ofScientific_true_def]
  have : (10 : Nat) ^ 4 = 10000 := by decide
  rw [this, Rat.mkRat_eq_div]
  rfl

/-- Signed distance from each exact rational to its printed four-decimal numeral. -/
theorem typography_signed_errors :
    (2 : Rat) / 3 - (0.6667 : Rat) = -((1 : Rat) / 30000) ∧
      (1 : Rat) / 3 - (0.3333 : Rat) = 1 / 30000 ∧
        (4 : Rat) / 7 - (0.5714 : Rat) = 1 / 35000 ∧
          (2 : Rat) / 7 - (0.2857 : Rat) = 1 / 70000 := by
  rw [decimal_6667, decimal_3333, decimal_5714, decimal_2857]
  refine ⟨?_, ?_, ?_, ?_⟩
  · grind
  · grind
  · grind
  · grind

/-- The printed numerals are not the exact rationals. -/
theorem typography_is_not_identity :
    (2 : Rat) / 3 ≠ (0.6667 : Rat) ∧
      (1 : Rat) / 3 ≠ (0.3333 : Rat) ∧
        (4 : Rat) / 7 ≠ (0.5714 : Rat) ∧
          (2 : Rat) / 7 ≠ (0.2857 : Rat) := by
  rw [decimal_6667, decimal_3333, decimal_5714, decimal_2857]
  grind

private theorem abs_neg_of_eq {a b c : Rat} (h : a - b = -c) (hc : 0 ≤ c) :
    (a - b).abs = c := by
  have hle : -c ≤ 0 := by simpa [Rat.neg_zero] using Rat.neg_le_neg hc
  rw [h, Rat.abs_of_nonpos hle, Rat.neg_neg]

private theorem abs_nonneg_of_eq {a b c : Rat} (h : a - b = c) (hc : 0 ≤ c) :
    (a - b).abs = c := by
  rw [h, Rat.abs_of_nonneg hc]

private theorem neg_diff_abs {a b : Rat} :
    ((-a) - (-b)).abs = (a - b).abs := by
  have h : (-a) - (-b) = -(a - b) := by
    rw [Rat.sub_eq_add_neg, Rat.neg_neg, Rat.sub_eq_add_neg, Rat.neg_add, Rat.neg_neg]
  rw [h, Rat.abs_neg]

private theorem abs_add_le_nonneg {a b : Rat} (ha : 0 ≤ a) (hb : 0 ≤ b) :
    (a + b).abs ≤ a.abs + b.abs := by
  have h₁ : 0 + b ≤ a + b := (Rat.add_le_add_right).mpr ha
  have h₂ : 0 + 0 ≤ 0 + b := (Rat.add_le_add_left).mpr hb
  have hab : 0 ≤ a + b := by
    simp only [Rat.zero_add, Rat.add_zero] at h₁ h₂
    exact Rat.le_trans h₂ h₁
  rw [Rat.abs_of_nonneg ha, Rat.abs_of_nonneg hb, Rat.abs_of_nonneg hab]
  exact Rat.le_refl

private theorem abs_add_le_mixed {a b : Rat} (ha : 0 ≤ a) (hb : b ≤ 0) :
    (a + b).abs ≤ a.abs + b.abs := by
  have hb' : 0 ≤ -b := by simpa [Rat.neg_zero] using Rat.neg_le_neg hb
  have hbb : b ≤ -b := Rat.le_trans hb hb'
  have hsum : a + b ≤ a + -b := (Rat.add_le_add_left).mpr hbb
  have hrhs : a + -b = a.abs + b.abs := by
    rw [Rat.abs_of_nonneg ha, Rat.abs_of_nonpos hb]
  cases (Rat.le_total : (0 : Rat) ≤ a + b ∨ a + b ≤ 0) with
  | inl hab =>
    rw [Rat.abs_of_nonneg hab, ← hrhs]
    exact hsum
  | inr hab =>
    rw [Rat.abs_of_nonpos hab, Rat.neg_add, ← hrhs]
    have hna : -a ≤ a := by
      have : -a ≤ 0 := by simpa [Rat.neg_zero] using Rat.neg_le_neg ha
      exact Rat.le_trans this ha
    exact (Rat.add_le_add_right).mpr hna

private theorem abs_add_le (a b : Rat) : (a + b).abs ≤ a.abs + b.abs := by
  cases (Rat.le_total : (0 : Rat) ≤ a ∨ a ≤ 0) with
  | inl ha =>
    cases (Rat.le_total : (0 : Rat) ≤ b ∨ b ≤ 0) with
    | inl hb => exact abs_add_le_nonneg ha hb
    | inr hb => exact abs_add_le_mixed ha hb
  | inr ha =>
    cases (Rat.le_total : (0 : Rat) ≤ b ∨ b ≤ 0) with
    | inl hb =>
      simpa [Rat.add_comm] using abs_add_le_mixed hb ha
    | inr hb =>
      have ha' : 0 ≤ -a := by simpa [Rat.neg_zero] using Rat.neg_le_neg ha
      have hb' : 0 ≤ -b := by simpa [Rat.neg_zero] using Rat.neg_le_neg hb
      have hneg := abs_add_le_nonneg ha' hb'
      have hneg' : (-(a + b)).abs ≤ (-a).abs + (-b).abs := by
        simpa [Rat.neg_add] using hneg
      simpa [Rat.abs_neg] using hneg'

private theorem abs_intCast (n : Int) : (n : Rat).abs = (n.natAbs : Rat) := by
  cases Int.natAbs_eq n with
  | inl h =>
    have hcast : (n : Rat) = (n.natAbs : Rat) :=
      (congrArg (fun z : Int => (z : Rat)) h).trans (Rat.intCast_natCast _)
    have hn : 0 ≤ (n : Rat) := by
      rw [hcast]
      exact Rat.natCast_nonneg
    rw [Rat.abs_of_nonneg hn, hcast]
  | inr h =>
    have hcast : (n : Rat) = -(n.natAbs : Rat) := by
      refine (congrArg (fun z : Int => (z : Rat)) h).trans ?_
      rw [Rat.intCast_neg, Rat.intCast_natCast]
    have hn : (n : Rat) ≤ 0 := by
      rw [hcast]
      simpa [Rat.neg_zero] using Rat.neg_le_neg (Rat.natCast_nonneg (a := n.natAbs))
    rw [Rat.abs_of_nonpos hn, hcast, Rat.neg_neg]

private theorem one_le_abs_of_ne_zero {n : Int} (h : n ≠ 0) : (1 : Rat) ≤ (n : Rat).abs := by
  rw [abs_intCast]
  exact Rat.natCast_le_natCast.mpr (Nat.succ_le_of_lt (Int.natAbs_pos.mpr h))

private theorem fourDecimal_sub (n m : Int) :
    fourDecimal n - fourDecimal m = ((n - m : Int) : Rat) / 10000 := by
  unfold fourDecimal
  grind

private theorem zero_div (c : Rat) : (0 : Rat) / c = 0 := by
  rw [Rat.div_def, Rat.zero_mul]

private theorem neg_div (a c : Rat) : -(a / c) = -a / c := by
  rw [Rat.div_def, Rat.div_def, Rat.neg_mul]

private theorem div_le_div_of_pos {a b c : Rat} (h : a ≤ b) (hc : 0 < c) :
    a / c ≤ b / c := by
  rw [Rat.div_def, Rat.div_def]
  exact Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt (Rat.inv_pos.mpr hc))

private theorem abs_div_pos {a c : Rat} (hc : 0 < c) :
    (a / c).abs = a.abs / c := by
  cases (Rat.le_total : (0 : Rat) ≤ a ∨ a ≤ 0) with
  | inl ha =>
    have hdiv : 0 ≤ a / c := by
      have hle : (0 : Rat) / c ≤ a / c := div_le_div_of_pos ha hc
      simpa [zero_div] using hle
    rw [Rat.abs_of_nonneg ha, Rat.abs_of_nonneg hdiv]
  | inr ha =>
    have hdiv : a / c ≤ 0 := by
      have hle : a / c ≤ (0 : Rat) / c := div_le_div_of_pos ha hc
      simpa [zero_div] using hle
    rw [Rat.abs_of_nonpos ha, Rat.abs_of_nonpos hdiv, neg_div]

private theorem four_decimal_sep (n m : Int) (hne : n ≠ m) :
    (1 : Rat) / 10000 ≤ (fourDecimal n - fourDecimal m).abs := by
  rw [fourDecimal_sub]
  have hk : (n - m : Int) ≠ 0 := by
    intro h
    apply hne
    omega
  have h1 : (1 : Rat) ≤ ((n - m : Int) : Rat).abs := one_le_abs_of_ne_zero hk
  have hd : (0 : Rat) < 10000 := Rat.natCast_pos.mpr (by decide)
  rw [abs_div_pos hd]
  exact div_le_div_of_pos h1 hd

private theorem lt_of_le_of_lt {a b c : Rat} (h₁ : a ≤ b) (h₂ : b < c) : a < c := by
  grind

/-- A rational has at most one four-decimal numeral within `halfUlp`.
Strict inequality rules out a tie. -/
theorem nearest_four_decimal (q : Rat) (n m : Int)
    (hn : (q - fourDecimal n).abs < halfUlp)
    (hm : (q - fourDecimal m).abs < halfUlp) : n = m := by
  by_cases hne : n = m
  · exact hne
  · have hsep := four_decimal_sep n m hne
    have hdiff : fourDecimal n - fourDecimal m =
        (q - fourDecimal m) + -(q - fourDecimal n) := by
      grind
    have hle : (fourDecimal n - fourDecimal m).abs ≤
        (q - fourDecimal m).abs + (q - fourDecimal n).abs := by
      rw [hdiff]
      simpa [Rat.abs_neg] using
        abs_add_le (q - fourDecimal m) (-(q - fourDecimal n))
    have hhalf : halfUlp + halfUlp = (1 : Rat) / 10000 := by
      unfold halfUlp
      grind
    have hsum : (q - fourDecimal m).abs + (q - fourDecimal n).abs < halfUlp + halfUlp := by
      grind
    have hstrict : (fourDecimal n - fourDecimal m).abs < (1 : Rat) / 10000 :=
      lt_of_le_of_lt hle (by rwa [hhalf] at hsum)
    exact absurd hstrict (Rat.not_lt.mpr hsep)

private theorem two_thirds_within :
    ((2 : Rat) / 3 - fourDecimal 6667).abs < halfUlp := by
  have herr : (2 : Rat) / 3 - (0.6667 : Rat) = -((1 : Rat) / 30000) :=
    typography_signed_errors.1
  have hc : (0 : Rat) ≤ 1 / 30000 := by grind
  have habs := abs_neg_of_eq herr hc
  have hdec : fourDecimal 6667 = (0.6667 : Rat) := by
    unfold fourDecimal
    exact decimal_6667.symm
  rw [hdec, habs]
  unfold halfUlp
  grind

private theorem one_third_within :
    ((1 : Rat) / 3 - fourDecimal 3333).abs < halfUlp := by
  have herr : (1 : Rat) / 3 - (0.3333 : Rat) = 1 / 30000 :=
    typography_signed_errors.2.1
  have hc : (0 : Rat) ≤ 1 / 30000 := by grind
  have habs := abs_nonneg_of_eq herr hc
  have hdec : fourDecimal 3333 = (0.3333 : Rat) := by
    unfold fourDecimal
    exact decimal_3333.symm
  rw [hdec, habs]
  unfold halfUlp
  grind

private theorem four_sevenths_within :
    ((4 : Rat) / 7 - fourDecimal 5714).abs < halfUlp := by
  have herr : (4 : Rat) / 7 - (0.5714 : Rat) = 1 / 35000 :=
    typography_signed_errors.2.2.1
  have hc : (0 : Rat) ≤ 1 / 35000 := by grind
  have habs := abs_nonneg_of_eq herr hc
  have hdec : fourDecimal 5714 = (0.5714 : Rat) := by
    unfold fourDecimal
    exact decimal_5714.symm
  rw [hdec, habs]
  unfold halfUlp
  grind

private theorem two_sevenths_within :
    ((2 : Rat) / 7 - fourDecimal 2857).abs < halfUlp := by
  have herr : (2 : Rat) / 7 - (0.2857 : Rat) = 1 / 70000 :=
    typography_signed_errors.2.2.2
  have hc : (0 : Rat) ≤ 1 / 70000 := by grind
  have habs := abs_nonneg_of_eq herr hc
  have hdec : fourDecimal 2857 = (0.2857 : Rat) := by
    unfold fourDecimal
    exact decimal_2857.symm
  rw [hdec, habs]
  unfold halfUlp
  grind

/-- `normalized_by_log_rho` is four-decimal typography for the unit-sum
spectrum `[2/3, 1/3, -1/3, -2/3]`. Each distance is strictly less than half
a unit in the fourth place, so `nearest_four_decimal` makes the spelling
unique. This is not an identity, and it is not division by `log_rho_A`. -/
theorem normalized_by_log_rho_typography :
    normalizedByLogRhoTypography = [(0.6667 : Rat), 0.3333, -0.3333, -0.6667] ∧
      ((2 : Rat) / 3 - (0.6667 : Rat)).abs < halfUlp ∧
        ((1 : Rat) / 3 - (0.3333 : Rat)).abs < halfUlp ∧
          (-((1 : Rat) / 3) - (-0.3333)).abs < halfUlp ∧
            (-((2 : Rat) / 3) - (-0.6667)).abs < halfUlp := by
  refine ⟨rfl, ?_, ?_, ?_, ?_⟩
  · have hdec : fourDecimal 6667 = (0.6667 : Rat) := by
      unfold fourDecimal
      exact decimal_6667.symm
    rw [← hdec]
    exact two_thirds_within
  · have hdec : fourDecimal 3333 = (0.3333 : Rat) := by
      unfold fourDecimal
      exact decimal_3333.symm
    rw [← hdec]
    exact one_third_within
  · have hdec : (-0.3333 : Rat) = -fourDecimal 3333 := by
      unfold fourDecimal
      rw [Rat.intCast_ofNat, ← decimal_3333]
    have hsame :
        (-((1 : Rat) / 3) - -fourDecimal 3333).abs =
          ((1 : Rat) / 3 - fourDecimal 3333).abs :=
      neg_diff_abs (a := (1 : Rat) / 3) (b := fourDecimal 3333)
    rw [hdec, hsame]
    exact one_third_within
  · have hdec : (-0.6667 : Rat) = -fourDecimal 6667 := by
      unfold fourDecimal
      rw [Rat.intCast_ofNat, ← decimal_6667]
    have hsame :
        (-((2 : Rat) / 3) - -fourDecimal 6667).abs =
          ((2 : Rat) / 3 - fourDecimal 6667).abs :=
      neg_diff_abs (a := (2 : Rat) / 3) (b := fourDecimal 6667)
    rw [hdec, hsame]
    exact two_thirds_within

/-- `scaled_to_6_7` is four-decimal typography for the unique pair
`4/7`, `2/7`. Same reading as `normalized_by_log_rho_typography`. -/
theorem scaled_to_6_7_typography :
    scaledToSixSeventhsTypography = [(0.5714 : Rat), 0.2857] ∧
      ((4 : Rat) / 7 - (0.5714 : Rat)).abs < halfUlp ∧
        ((2 : Rat) / 7 - (0.2857 : Rat)).abs < halfUlp := by
  refine ⟨rfl, ?_, ?_⟩
  · have hdec : fourDecimal 5714 = (0.5714 : Rat) := by
      unfold fourDecimal
      exact decimal_5714.symm
    rw [← hdec]
    exact four_sevenths_within
  · have hdec : fourDecimal 2857 = (0.2857 : Rat) := by
      unfold fourDecimal
      exact decimal_2857.symm
    rw [← hdec]
    exact two_sevenths_within

theorem nearest_normalized_two_thirds (n : Int)
    (h : ((2 : Rat) / 3 - fourDecimal n).abs < halfUlp) : n = 6667 :=
  (nearest_four_decimal (2 / 3) 6667 n two_thirds_within h).symm

theorem nearest_normalized_one_third (n : Int)
    (h : ((1 : Rat) / 3 - fourDecimal n).abs < halfUlp) : n = 3333 :=
  (nearest_four_decimal (1 / 3) 3333 n one_third_within h).symm

theorem nearest_scaled_four_sevenths (n : Int)
    (h : ((4 : Rat) / 7 - fourDecimal n).abs < halfUlp) : n = 5714 :=
  (nearest_four_decimal (4 / 7) 5714 n four_sevenths_within h).symm

theorem nearest_scaled_two_sevenths (n : Int)
    (h : ((2 : Rat) / 7 - fourDecimal n).abs < halfUlp) : n = 2857 :=
  (nearest_four_decimal (2 / 7) 2857 n two_sevenths_within h).symm

/-! ### Not the thin-sampler splitting -/

/-- `11/21` and `1/3` also sum to `ekzSum`, but the ratio is `11/7`, not `2`.
Thin X(2,0) walks are not the unique `2 : 1` pair. They are not promoted. -/
theorem thin_sampler_not_two_to_one :
    (11 : Rat) / 21 + (1 : Rat) / 3 = ekzSum ∧
      ((11 : Rat) / 21) / ((1 : Rat) / 3) = 11 / 7 ∧
        (11 : Rat) / 7 ≠ 2 := by
  unfold ekzSum
  grind

end PeriodicRawSpectrum
