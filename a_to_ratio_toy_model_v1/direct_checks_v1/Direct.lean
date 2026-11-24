import Independent
open CheddarIndependent
/-- Direct proofs: these are arithmetic facts about A, closed without the lemma. -/
theorem traceDet_holds : TraceDet := by unfold TraceDet; decide
theorem cube_holds : CubeIsSpectralRadius := by unfold CubeIsSpectralRadius mulZ3; decide
/-- Tighter tie to A (Tater): λ = 26+15√3 satisfies A's characteristic polynomial in ℤ[√3],
and v = (10, λ − 31) = (10, −5+15√3) is an eigenvector: A·v = λ·v, componentwise in ℤ[√3]. -/
def lam : Int × Int := (26, 15)
def EigenOfA : Prop :=
  (mulZ3 lam lam).1 - 52 * lam.1 + 1 = 0 ∧ (mulZ3 lam lam).2 - 52 * lam.2 = 0 ∧
  (31 * 10 + 10 * (-5 : Int), 10 * 15) = mulZ3 lam (10, 0) ∧
  (65 * 10 + 21 * (-5 : Int), 21 * 15) = mulZ3 lam (-5, 15)
theorem eigen_holds : EigenOfA := by unfold EigenOfA lam mulZ3; decide
#print axioms traceDet_holds
#print axioms cube_holds
#print axioms eigen_holds
