/-
A-to-ratio chain v1 (Tater), core Lean 4.35.0, no Mathlib.
Inputs copied verbatim from omega-ed6-h1plus-measure data/kz_along_A.json @ b7c4a7a
(file sha256 06e6a20f0bdd14dc6c31fc1a174aa09c1286abd1fa0f2bee2dd6ed19e740a50e): fields A, M_plus.
Word and toy two-torus model copied from Lucas's /workspace/prym_direction_check/square_tiled/toy_model.py.
SCOPE: this proves the stored data is internally consistent with the toy model and that the 2:1 is exact
for these stored matrices. It does NOT prove any real Prym surface produces this word or these matrices.
-/
namespace TaterAToRatio

abbrev Mat := List (List Int)
def get (m : Mat) (i j : Nat) : Int := (m.getD i []).getD j 0
def matMul (n : Nat) (a b : Mat) : Mat :=
  (List.range n).map fun i => (List.range n).map fun j =>
    (List.range n).foldl (fun s k => s + get a i k * get b k j) 0
def idM (n : Nat) : Mat := (List.range n).map fun i => (List.range n).map fun j => if i = j then 1 else 0

/-- Stored data, verbatim from kz_along_A.json. -/
def A_stored : Mat := [[31, 10], [65, 21]]
def Mplus_stored : Mat := [[-15, 0, -2, 0], [0, 1, 0, -3], [8, 0, 1, 0], [0, 2, 0, -5]]

/-- Lucas's toy model: form Om with Om(c0,c2)=Om(c1,c3)=-1; letter (i,k) acts on H1+ as the k-fold
transvection x ↦ x + k·Om(c_i,x)·c_i and on the plane by Ah(k)=[[1,0],[k,1]] (i<2) or Av(k)=[[1,k],[0,1]]. -/
def Om : Mat := [[0, 0, -1, 0], [0, 0, 0, -1], [1, 0, 0, 0], [0, 1, 0, 0]]
def transv (i : Nat) (k : Int) : Mat :=
  (List.range 4).map fun r => (List.range 4).map fun c =>
    (if r = c then 1 else 0) + (if r = i then k * get Om i c else 0)
def deriv (i : Nat) (k : Int) : Mat := if i < 2 then [[1, 0], [k, 1]] else [[1, k], [0, 1]]
def word : List (Nat × Int) := [(1, 3), (2, 4), (2, 4), (3, 2), (0, 2)]
def wordM : Mat := word.foldl (fun M p => matMul 4 (transv p.1 p.2) M) (idM 4)
def wordD : Mat := word.foldl (fun D p => matMul 2 (deriv p.1 p.2) D) (idM 2)

/-- Link 1: one word produces BOTH stored matrices. -/
theorem word_gives_A : wordD = A_stored := by decide
theorem word_gives_Mplus : wordM = Mplus_stored := by decide

/-- ℤ[√3] as pairs (a, b) = a + b√3. -/
abbrev Z3 := Int × Int
def mulZ3 (p q : Z3) : Z3 := (p.1 * q.1 + 3 * p.2 * q.2, p.1 * q.2 + p.2 * q.1)
def matVec (a b c d : Int) (v : Z3 × Z3) : Z3 × Z3 :=
  ((a * v.1.1 + b * v.2.1, a * v.1.2 + b * v.2.2), (c * v.1.1 + d * v.2.1, c * v.1.2 + d * v.2.2))
def IsEigen (a b c d : Int) (lam : Z3) (v : Z3 × Z3) : Prop :=
  matVec a b c d v = (mulZ3 lam v.1, mulZ3 lam v.2) ∧ v ≠ ((0, 0), (0, 0))

def u : Z3 := (2, 1)                       -- 2 + √3, a unit > 1
def neg (p : Z3) : Z3 := (-p.1, -p.2)

/-- Link 2: M_plus is block diagonal on (c0,c2) and (c1,c3); every cross entry is 0. -/
def BlockDiag : Prop :=
  get Mplus_stored 0 1 = 0 ∧ get Mplus_stored 0 3 = 0 ∧ get Mplus_stored 1 0 = 0 ∧ get Mplus_stored 1 2 = 0 ∧
  get Mplus_stored 2 1 = 0 ∧ get Mplus_stored 2 3 = 0 ∧ get Mplus_stored 3 0 = 0 ∧ get Mplus_stored 3 2 = 0
theorem blockDiag_holds : BlockDiag := by unfold BlockDiag; decide

/-- Link 3: exact eigenvalues, read straight off the stored entries.
  ρ(A) = u³, block (c0,c2) has eigenvalue −u², block (c1,c3) has eigenvalue −u. Each block has det 1, so the
  other eigenvalue is the reciprocal (|·| < 1). Hence log growth rates are exactly 3 : 2 : 1 in units of log u,
  i.e. normalized by log ρ(A) they are exactly 2/3 and 1/3, ratio exactly 2:1. -/
def Chain : Prop :=
  IsEigen (get A_stored 0 0) (get A_stored 0 1) (get A_stored 1 0) (get A_stored 1 1)
    (mulZ3 u (mulZ3 u u)) ((10, 0), (-5, 15)) ∧
  IsEigen (get Mplus_stored 0 0) (get Mplus_stored 0 2) (get Mplus_stored 2 0) (get Mplus_stored 2 2)
    (neg (mulZ3 u u)) ((-2, 0), (8, -4)) ∧
  IsEigen (get Mplus_stored 1 1) (get Mplus_stored 1 3) (get Mplus_stored 3 1) (get Mplus_stored 3 3)
    (neg u) ((-3, 0), (-3, -1)) ∧
  -- determinants are 1 (so the second eigenvalue of each is the reciprocal)
  get A_stored 0 0 * get A_stored 1 1 - get A_stored 0 1 * get A_stored 1 0 = 1 ∧
  get Mplus_stored 0 0 * get Mplus_stored 2 2 - get Mplus_stored 0 2 * get Mplus_stored 2 0 = 1 ∧
  get Mplus_stored 1 1 * get Mplus_stored 3 3 - get Mplus_stored 1 3 * get Mplus_stored 3 1 = 1 ∧
  -- u > 1 and the conjugates 2−√3, 7−4√3, 26−15√3 are positive (a² > 3b²), so they are the small ones
  (2 * 2 > 3 * 1 * 1 : Prop) ∧ (7 * 7 > 3 * 4 * 4 : Prop) ∧ (26 * 26 > 3 * 15 * 15 : Prop)
theorem chain_holds : Chain := by unfold Chain IsEigen matVec mulZ3 neg u; decide

#print axioms word_gives_A
#print axioms word_gives_Mplus
#print axioms blockDiag_holds
#print axioms chain_holds
end TaterAToRatio
