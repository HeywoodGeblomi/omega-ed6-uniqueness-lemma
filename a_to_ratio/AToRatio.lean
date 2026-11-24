/-
A to ratio (Heywood Geblomi). Core Lean 4.35.0, no Mathlib, no sorry.
Data file pinned: ../data/kz_along_A.json, sha256 06e6a20f0bdd14dc6c31fc1a174aa09c1286abd1fa0f2bee2dd6ed19e740a50e.
check_inputs.py confirms the Lean literals A and Mplus below equal its "A" and "M_plus".
The exponent values are stated from the same k's that appear in the eigenvector equations, and
"toy model" and "this geodesic" are in the theorem names on purpose.
Numbers a + b√3 are integer pairs (a, b); u = 2 + √3.
ASSUMED, NOT CHECKED BY LEAN:
  (S1) textbook step: if M v = λ v with v ≠ 0 and p(M) = 0 then p(λ) = 0;
  (S2) definition of exponent along a closed geodesic as log|λ| / log ρ(A), and log(u^k) = k·log u;
  (S3) that M_plus is the real H¹⁺ action of a real Prym surface. It comes from a simplified two-torus
       model. With the other sign choice for the twists, the blocks have traces 18 and 8 and the
       ratio is about 1.40, not 2;
  (S4) anything about the Masur–Veech average, the 6/7 sum, or the rescaling to 4/7 and 2/7.
-/
namespace AToRatio

abbrev Z3 := Int × Int
def mul (p q : Z3) : Z3 := (p.1 * q.1 + 3 * p.2 * q.2, p.1 * q.2 + p.2 * q.1)
def add (p q : Z3) : Z3 := (p.1 + q.1, p.2 + q.2)
def ofInt (k : Int) : Z3 := (k, 0)
def u : Z3 := (2, 1)
def upow : Nat → Z3
  | 0 => (1, 0)
  | n + 1 => mul u (upow n)
/-- s · u^k -/
def spow (s : Int) (k : Nat) : Z3 := mul (ofInt s) (upow k)

def dot : List Int → List Z3 → Z3
  | a :: as, v :: vs => add (mul (ofInt a) v) (dot as vs)
  | _, _ => (0, 0)
def matvec (M : List (List Int)) (v : List Z3) : List Z3 := M.map (fun r => dot r v)
def scale (lam : Z3) (v : List Z3) : List Z3 := v.map (mul lam)

/-- Verbatim from kz_along_A.json (06e6a20f…). -/
def A : List (List Int) := [[31, 10], [65, 21]]
def Mplus : List (List Int) := [[-15, 0, -2, 0], [0, 1, 0, -3], [8, 0, 1, 0], [0, 2, 0, -5]]

def kA : Nat := 3
def k1 : Nat := 2
def k2 : Nat := 1
def vA : List Z3 := [(10, 0), (-5, 15)]
def v1 : List Z3 := [(-2, 0), (0, 0), (8, -4), (0, 0)]
def v2 : List Z3 := [(0, 0), (-3, 0), (0, 0), (-3, -1)]

/-- The headline, in one statement: A has eigenvalue u^kA, M_plus has −u^k1 and −u^k2 with explicit
eigenvectors, and the normalized exponents k1/kA, k2/kA are 2/3 and 1/3 with ratio exactly 2.
(Reading k/kA as log|λ|/log ρ(A) is step S2.) -/
theorem toy_model_this_geodesic_exponents_two_to_one :
    matvec A vA = scale (spow 1 kA) vA ∧
    matvec Mplus v1 = scale (spow (-1) k1) v1 ∧
    matvec Mplus v2 = scale (spow (-1) k2) v2 ∧
    ((k1 : Rat) / kA = 2 / 3) ∧ ((k2 : Rat) / kA = 1 / 3) ∧ ((k1 : Rat) / kA = 2 * ((k2 : Rat) / kA)) := by
  refine ⟨by decide, by decide, by decide, ?_, ?_, ?_⟩ <;> simp only [k1, k2, kA] <;> grind

/-- Conjugate partners: ū³ on A, −ū², −ū on M_plus, each of norm 1, so each partner is the inverse and has
modulus below 1 (26² > 3·15², 7² > 3·4², 2² > 3·1²). -/
theorem toy_model_this_geodesic_partners :
    matvec A [(10, 0), (-5, -15)] = scale (26, -15) [(10, 0), (-5, -15)] ∧
    matvec Mplus [(-2, 0), (0, 0), (8, 4), (0, 0)] = scale (-7, 4) [(-2, 0), (0, 0), (8, 4), (0, 0)] ∧
    matvec Mplus [(0, 0), (-3, 0), (0, 0), (-3, 1)] = scale (-2, 1) [(0, 0), (-3, 0), (0, 0), (-3, 1)] ∧
    mul (26, 15) (26, -15) = (1, 0) ∧ mul (-7, -4) (-7, 4) = (1, 0) ∧ mul (-2, -1) (-2, 1) = (1, 0) ∧
    (26 * 26 : Int) > 3 * 15 * 15 ∧ (7 * 7 : Int) > 3 * 4 * 4 ∧ (2 * 2 : Int) > 3 * 1 * 1 := by decide

/-- Top growth rate of M_plus is the square of the second: (−u)² = −(−u²) = u². -/
theorem toy_model_top_is_square_of_second :
    mul (spow (-1) k2) (spow (-1) k2) = mul (ofInt (-1)) (spow (-1) k1) := by decide

-- Integer matrices for the annihilating-polynomial check.
def Mat := Nat → Nat → Int
def ofList (M : List (List Int)) : Mat := fun i j => (M.getD i []).getD j 0
def mmul (n : Nat) (P Q : Mat) : Mat := fun i j => (List.range n).foldl (fun acc k => acc + P i k * Q k j) 0
def madd (P Q : Mat) : Mat := fun i j => P i j + Q i j
def msmul (c : Int) (P : Mat) : Mat := fun i j => c * P i j
def idm : Mat := fun i j => if i = j then 1 else 0
def isZero (n : Nat) (P : Mat) : Bool := (List.range n).all fun i => (List.range n).all fun j => P i j == 0

/-- (M² + 14M + I)(M² + 4M + I) = 0 for M = M_plus, and A² − 52A + I = 0.
With S1, every eigenvalue of M_plus is a root of (t²+14t+1)(t²+4t+1), i.e. one of −u², −ū², −u, −ū,
all found above; so no other eigenvalue is as big as −u². Likewise A's eigenvalues are only u³ and ū³. -/
theorem toy_model_no_other_eigenvalues_poly :
    isZero 4 (mmul 4 (madd (madd (mmul 4 (ofList Mplus) (ofList Mplus)) (msmul 14 (ofList Mplus))) idm)
                     (madd (madd (mmul 4 (ofList Mplus) (ofList Mplus)) (msmul 4 (ofList Mplus))) idm)) = true ∧
    isZero 2 (madd (madd (mmul 2 (ofList A) (ofList A)) (msmul (-52) (ofList A))) idm) = true := by decide

end AToRatio

#print axioms AToRatio.toy_model_this_geodesic_exponents_two_to_one
#print axioms AToRatio.toy_model_this_geodesic_partners
#print axioms AToRatio.toy_model_top_is_square_of_second
#print axioms AToRatio.toy_model_no_other_eigenvalues_poly
