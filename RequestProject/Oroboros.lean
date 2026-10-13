module

public import Mathlib

/-!
# Oroboros: the Ouroboros and Noroboro equations, formalized

This file formalizes the laws and theorems of the Oroboros repository
(`DERIVATION.md`, Matthew Chenoweth Wright, revision of October 13, 2026).

The original equations are
  `O(t) = e^{iπ} O(t-1) ∑_{n≥1} e^{2πint} / n^s`
  `N(t) = e^{αt} e^{iπ} N(t-1) ∑_{n≥1} e^{2πint} / n^s`
studied at integer steps `t = k ≥ 0`, with `s > 1` real, `α` real, and complex initial data.
-/

open Complex Filter Topology Real

@[expose] public noncomputable section

namespace Oroboros

/-- The real Riemann zeta value `ζ(s) = ∑_{n ≥ 1} 1 / n^s` (as a real series). -/
def zetaR (s : ℝ) : ℝ := ∑' n : ℕ, 1 / ((n : ℝ) + 1) ^ s

/-- The Fourier factor `F_s(t) = ∑_{n ≥ 1} e^{2π i n t} / n^s`. -/
def fourierFactor (s t : ℝ) : ℂ :=
  ∑' n : ℕ, cexp (2 * π * I * ((n : ℂ) + 1) * t) / ((n : ℂ) + 1) ^ (s : ℂ)

/-- The original Ouroboros recurrence `O_k = e^{iπ} O_{k-1} F_s(k)`. -/
def ouroboros (s : ℝ) (O₀ : ℂ) : ℕ → ℂ
  | 0 => O₀
  | k + 1 => cexp (π * I) * ouroboros s O₀ k * fourierFactor s (k + 1)

/-- The normalized Ouroboros recurrence `Ô_k = e^{iπ} Ô_{k-1} F_s(k)/ζ(s)`. -/
def normOuroboros (s : ℝ) (O₀ : ℂ) : ℕ → ℂ
  | 0 => O₀
  | k + 1 => cexp (π * I) * normOuroboros s O₀ k * (fourierFactor s (k + 1) / zetaR s)

/-- The original Noroboro recurrence `N_k = e^{αk} e^{iπ} N_{k-1} F_s(k)`. -/
def noroboro (s α : ℝ) (N₀ : ℂ) : ℕ → ℂ
  | 0 => N₀
  | k + 1 => cexp (α * (k + 1)) * cexp (π * I) * noroboro s α N₀ k * fourierFactor s (k + 1)

/-- The normalized Noroboro recurrence `N̂_k = e^{αk} e^{iπ} N̂_{k-1} F_s(k)/ζ(s)`. -/
def normNoroboro (s α : ℝ) (N₀ : ℂ) : ℕ → ℂ
  | 0 => N₀
  | k + 1 => cexp (α * (k + 1)) * cexp (π * I) * normNoroboro s α N₀ k *
      (fourierFactor s (k + 1) / zetaR s)

/-- The alternative constant-multiplier model `G_k = -e^α G_{k-1}`. -/
def expModel (α : ℝ) (G₀ : ℂ) : ℕ → ℂ
  | 0 => G₀
  | k + 1 => -cexp α * expModel α G₀ k

/-! ## The Fourier factor and the zeta function -/

private lemma cpow_cast (s : ℝ) (n : ℕ) :
    ((n : ℂ) + 1) ^ (s : ℂ) = ((((n : ℝ) + 1) ^ s : ℝ) : ℂ) := by
  rw [Complex.ofReal_cpow (by positivity)]; push_cast; rfl

private lemma term_norm (s t : ℝ) (n : ℕ) :
    ‖cexp (2 * π * I * ((n : ℂ) + 1) * t) / ((n : ℂ) + 1) ^ (s : ℂ)‖ = 1 / ((n : ℝ) + 1) ^ s := by
  rw [norm_div, cpow_cast]
  have : 2 * π * I * ((n : ℂ) + 1) * t = ((2 * π * ((n : ℝ) + 1) * t : ℝ) : ℂ) * I := by
    push_cast; ring
  rw [this, Complex.norm_exp_ofReal_mul_I, Complex.norm_real, Real.norm_of_nonneg (by positivity)]

private lemma exp_shift_int (t : ℝ) (n : ℕ) (k : ℤ) :
    cexp (2 * π * I * ((n : ℂ) + 1) * (t + k)) = cexp (2 * π * I * ((n : ℂ) + 1) * t) := by
  have : 2 * π * I * ((n : ℂ) + 1) * (t + k) =
      2 * π * I * ((n : ℂ) + 1) * t + ((n + 1 : ℕ) * k : ℤ) * (2 * π * I) := by
    push_cast; ring
  rw [this, Complex.exp_add, Complex.exp_int_mul_two_pi_mul_I, mul_one]

private lemma summable_zeta_terms {s : ℝ} (hs : 1 < s) :
    Summable fun n : ℕ => 1 / ((n : ℝ) + 1) ^ s := by
  refine ((Real.summable_one_div_nat_add_rpow 1 s).2 hs).congr fun n => ?_
  rw [abs_of_nonneg (by positivity)]

private lemma strict_triangle_key (θ c : ℝ) (hc : 0 < c)
    (h : ‖cexp (θ * I) + cexp (2 * θ * I) / c‖ = ‖cexp (θ * I)‖ + ‖cexp (2 * θ * I) / c‖) :
    cexp (θ * I) = 1 := by
  rw [← sameRay_iff_norm_add] at h
  obtain ⟨r, hr, hxy⟩ := h.exists_pos_left (Complex.exp_ne_zero _)
    (div_ne_zero (Complex.exp_ne_zero _) (by exact_mod_cast hc.ne'))
  have e2 : cexp (2 * θ * I) = cexp (θ * I) * cexp (θ * I) := by
    rw [← Complex.exp_add]; ring_nf
  rw [e2, Complex.real_smul] at hxy
  have hne := Complex.exp_ne_zero (θ * I)
  have h1 : cexp (θ * I) = (r * c : ℝ) := by
    have : cexp (θ * I) * (cexp (θ * I) / c) = cexp (θ * I) * r := by
      rw [mul_div_assoc'] at *; rw [← hxy]; ring
    have := mul_left_cancel₀ hne this
    have hc' : (c : ℂ) ≠ 0 := by exact_mod_cast hc.ne'
    push_cast; rw [← this]; field_simp
  have hn : ‖cexp (θ * I)‖ = 1 := Complex.norm_exp_ofReal_mul_I θ
  rw [h1, Complex.norm_real, Real.norm_of_nonneg (by positivity)] at hn
  rw [h1, hn]; simp

/-- `F_s` is one-periodic in `t`. -/
theorem fourierFactor_periodic (s t : ℝ) : fourierFactor s (t + 1) = fourierFactor s t := by
  unfold fourierFactor
  congr 1; funext n
  have := exp_shift_int t n 1
  push_cast at this ⊢
  rw [this]

/-- For `s > 1` the Fourier series converges (absolutely) for every real `t`. -/
theorem summable_fourierFactor {s : ℝ} (hs : 1 < s) (t : ℝ) :
    Summable fun n : ℕ => cexp (2 * π * I * ((n : ℂ) + 1) * t) / ((n : ℂ) + 1) ^ (s : ℂ) := by
  refine Summable.of_norm ?_
  simp_rw [term_norm]
  exact summable_zeta_terms hs

/-- The real series `zetaR s` is Mathlib's Riemann zeta function for `s > 1`. -/
theorem zetaR_eq_riemannZeta {s : ℝ} (hs : 1 < s) : (zetaR s : ℂ) = riemannZeta s := by
  rw [zeta_eq_tsum_one_div_nat_add_one_cpow (by simpa using hs), zetaR, Complex.ofReal_tsum]
  congr 1; funext n
  rw [cpow_cast]; push_cast; rfl

/-- At every integer `k`, the Fourier factor equals `ζ(s)`.
(For `s ≤ 1` both series diverge; Lean assigns both the value `0`, so no hypothesis
on `s` is needed for this identity of `tsum`s.) -/
theorem fourierFactor_intCast (s : ℝ) (k : ℤ) :
    fourierFactor s k = zetaR s := by
  unfold fourierFactor zetaR
  rw [Complex.ofReal_tsum]
  congr 1; funext n
  have := exp_shift_int 0 n k
  simp only [Complex.ofReal_zero, zero_add, mul_zero, Complex.exp_zero] at this
  push_cast
  rw [this, cpow_cast]

/-- `ζ(s) > 1` for real `s > 1`. -/
theorem one_lt_zetaR {s : ℝ} (hs : 1 < s) : 1 < zetaR s := by
  have hsum := summable_zeta_terms hs
  unfold zetaR
  rw [← hsum.sum_add_tsum_nat_add 2]
  have h3 : 0 ≤ ∑' b : ℕ, 1 / (((b + 2 : ℕ) : ℝ) + 1) ^ s := tsum_nonneg fun _ => by positivity
  have h2 : 0 < 1 / ((1 : ℝ) + 1) ^ s := by positivity
  simp only [Finset.sum_range_succ, Finset.sum_range_zero] at *
  norm_num at *
  have := inv_pos.2 h2
  linarith

private lemma zetaR_pos {s : ℝ} (hs : 1 < s) : 0 < zetaR s := lt_trans one_pos (one_lt_zetaR hs)

/-- Triangle inequality: `‖F_s(t)‖ ≤ ζ(s)` for all real `t`. -/
theorem norm_fourierFactor_le {s : ℝ} (hs : 1 < s) (t : ℝ) :
    ‖fourierFactor s t‖ ≤ zetaR s := by
  unfold fourierFactor zetaR
  refine (norm_tsum_le_tsum_norm ?_).trans_eq ?_
  · simp_rw [term_norm]; exact summable_zeta_terms hs
  · simp_rw [term_norm]

/-- Strict inequality `‖F_s(t)‖ < ζ(s)` at every non-integer real `t`. -/
theorem norm_fourierFactor_lt {s : ℝ} (hs : 1 < s) {t : ℝ} (ht : ∀ k : ℤ, t ≠ k) :
    ‖fourierFactor s t‖ < zetaR s := by
  set f : ℕ → ℂ := fun n => cexp (2 * π * I * ((n : ℂ) + 1) * t) / ((n : ℂ) + 1) ^ (s : ℂ)
    with hf
  have hsf : Summable f := summable_fourierFactor hs t
  have hnf : Summable fun n => ‖f n‖ := by
    simp_rw [hf, term_norm]; exact summable_zeta_terms hs
  have hF : fourierFactor s t = (f 0 + f 1) + ∑' n, f (n + 2) := by
    rw [fourierFactor, ← hsf.sum_add_tsum_nat_add 2]; simp [Finset.sum_range_succ, hf]
  have hZ : zetaR s = (‖f 0‖ + ‖f 1‖) + ∑' n, ‖f (n + 2)‖ := by
    have : zetaR s = ∑' n, ‖f n‖ := by simp_rw [hf, term_norm]; rfl
    rw [this, ← hnf.sum_add_tsum_nat_add 2]; simp [Finset.sum_range_succ]
  have htail : ‖∑' n, f (n + 2)‖ ≤ ∑' n, ‖f (n + 2)‖ :=
    norm_tsum_le_tsum_norm ((summable_nat_add_iff 2).2 hnf)
  have hstrict : ‖f 0 + f 1‖ < ‖f 0‖ + ‖f 1‖ := by
    refine lt_of_le_of_ne (norm_add_le _ _) fun heq => ?_
    have e0 : f 0 = cexp ((2 * π * t : ℝ) * I) := by
      simp only [hf]; push_cast; simp; ring_nf
    have e1 : f 1 = cexp ((2 * (2 * π * t) : ℝ) * I) / ((2 : ℝ) ^ s : ℝ) := by
      simp only [hf]; rw [cpow_cast]; push_cast; norm_num; ring_nf
    rw [e0, e1] at heq
    have h1 := strict_triangle_key (2 * π * t) (2 ^ s) (by positivity) (by push_cast at heq ⊢; exact heq)
    obtain ⟨m, hm⟩ := Complex.exp_eq_one_iff.1 h1
    apply ht m
    have : ((2 * π * t : ℝ) : ℂ) = ((2 * π * m : ℝ) : ℂ) := by
      push_cast at hm ⊢; linear_combination (-I) * hm + (2 * (π : ℂ) * t - 2 * π * m) * Complex.I_sq
    have := Complex.ofReal_injective this
    have hpi := Real.pi_pos
    nlinarith [this]
  rw [hF, hZ]
  exact (norm_add_le _ _).trans_lt (by linarith)

/-! ## Proposition 1: the original Ouroboros recurrence -/

private lemma fourierFactor_succ (s : ℝ) (k : ℕ) :
    fourierFactor s ((k : ℝ) + 1) = zetaR s := by
  have : ((k : ℝ) + 1) = ((k + 1 : ℤ) : ℝ) := by push_cast; ring
  rw [this, fourierFactor_intCast]

/-- The Ouroboros update at integer steps is multiplication by `-ζ(s)`. -/
theorem ouroboros_step (s : ℝ) (O₀ : ℂ) (k : ℕ) :
    ouroboros s O₀ (k + 1) = -(zetaR s) * ouroboros s O₀ k := by
  simp only [ouroboros, fourierFactor_succ, Complex.exp_pi_mul_I]; ring

/-- **Proposition 1.** `O_k = (-1)^k ζ(s)^k O_0`. -/
theorem ouroboros_closed_form (s : ℝ) (O₀ : ℂ) (k : ℕ) :
    ouroboros s O₀ k = (-1) ^ k * (zetaR s : ℂ) ^ k * O₀ := by
  induction k with
  | zero => simp [ouroboros]
  | succ k ih => rw [ouroboros_step, ih]; ring

theorem norm_ouroboros {s : ℝ} (hs : 1 < s) (O₀ : ℂ) (k : ℕ) :
    ‖ouroboros s O₀ k‖ = zetaR s ^ k * ‖O₀‖ := by
  rw [ouroboros_closed_form]
  simp [norm_pow, Complex.norm_real, abs_of_pos (zetaR_pos hs)]

/-- For nonzero initial data, the magnitude of the original Ouroboros grows without bound. -/
theorem ouroboros_tendsto_infinity {s : ℝ} (hs : 1 < s) {O₀ : ℂ} (h : O₀ ≠ 0) :
    Tendsto (fun k => ‖ouroboros s O₀ k‖) atTop atTop := by
  simp_rw [norm_ouroboros hs]
  exact (tendsto_pow_atTop_atTop_of_one_lt (one_lt_zetaR hs)).atTop_mul_const (norm_pos_iff.2 h)

theorem ouroboros_two_step (s : ℝ) (O₀ : ℂ) (k : ℕ) :
    ouroboros s O₀ (k + 2) = (zetaR s : ℂ) ^ 2 * ouroboros s O₀ k := by
  rw [ouroboros_step, ouroboros_step]; ring

/-- The original Ouroboros is **not** a closed two-cycle for nonzero initial data. -/
theorem ouroboros_not_two_cycle {s : ℝ} (hs : 1 < s) {O₀ : ℂ} (h : O₀ ≠ 0) (k : ℕ) :
    ouroboros s O₀ (k + 2) ≠ ouroboros s O₀ k := by
  intro heq
  have h1 := congrArg norm heq
  rw [norm_ouroboros hs, norm_ouroboros hs, pow_add] at h1
  have hz := one_lt_zetaR hs
  have hp : 0 < zetaR s ^ k * ‖O₀‖ := by positivity
  have : zetaR s ^ k * ‖O₀‖ * (zetaR s ^ 2 - 1) = 0 := by linarith
  rcases mul_eq_zero.1 this with h2 | h2
  · linarith
  · nlinarith

/-! ## Proposition 2: the normalized Ouroboros cycle -/

theorem normOuroboros_step {s : ℝ} (hs : 1 < s) (O₀ : ℂ) (k : ℕ) :
    normOuroboros s O₀ (k + 1) = -normOuroboros s O₀ k := by
  have hz : (zetaR s : ℂ) ≠ 0 := by exact_mod_cast (zetaR_pos hs).ne'
  simp only [normOuroboros, fourierFactor_succ, Complex.exp_pi_mul_I, div_self hz]; ring

/-- **Proposition 2.** `Ô_k = (-1)^k Ô_0`. -/
theorem normOuroboros_closed_form {s : ℝ} (hs : 1 < s) (O₀ : ℂ) (k : ℕ) :
    normOuroboros s O₀ k = (-1) ^ k * O₀ := by
  induction k with
  | zero => simp [normOuroboros]
  | succ k ih => rw [normOuroboros_step hs, ih]; ring

/-- Constant magnitude: `|Ô_k| = |Ô_0|`. -/
theorem norm_normOuroboros {s : ℝ} (hs : 1 < s) (O₀ : ℂ) (k : ℕ) :
    ‖normOuroboros s O₀ k‖ = ‖O₀‖ := by
  simp [normOuroboros_closed_form hs]

/-- Two-step closure: `Ô_{k+2} = Ô_k`. -/
theorem normOuroboros_period_two {s : ℝ} (hs : 1 < s) (O₀ : ℂ) (k : ℕ) :
    normOuroboros s O₀ (k + 2) = normOuroboros s O₀ k := by
  rw [normOuroboros_step hs, normOuroboros_step hs, neg_neg]

/-- Nonzero initial data have minimal period two (no fixed point). -/
theorem normOuroboros_minimal_period {s : ℝ} (hs : 1 < s) {O₀ : ℂ} (h : O₀ ≠ 0) (k : ℕ) :
    normOuroboros s O₀ (k + 1) ≠ normOuroboros s O₀ k := by
  rw [normOuroboros_step hs]
  intro heq
  have : normOuroboros s O₀ k = 0 := by linear_combination -heq / 2
  rw [normOuroboros_closed_form hs] at this
  simp [h] at this

/-- The zero state is a fixed point. -/
theorem normOuroboros_zero {s : ℝ} (hs : 1 < s) (k : ℕ) : normOuroboros s 0 k = 0 := by
  simp [normOuroboros_closed_form hs]

/-- The normalized integer-step dynamics do not depend on `s`. -/
theorem normOuroboros_indep_s {s s' : ℝ} (hs : 1 < s) (hs' : 1 < s') (O₀ : ℂ) :
    normOuroboros s O₀ = normOuroboros s' O₀ := by
  funext k; rw [normOuroboros_closed_form hs, normOuroboros_closed_form hs']

/-! ## Away from integer times: the delay relation on a fractional class -/

/-- The delay relation on the fractional-time class `r + k`. -/
def fracClass (s r : ℝ) (x₀ : ℂ) : ℕ → ℂ
  | 0 => x₀
  | k + 1 => cexp (π * I) * fracClass s r x₀ k * (fourierFactor s (r + (k + 1)) / zetaR s)

private lemma fourierFactor_add_nat (s r : ℝ) (k : ℕ) :
    fourierFactor s (r + k) = fourierFactor s r := by
  induction k with
  | zero => simp
  | succ k ih => rw [Nat.cast_succ, ← add_assoc, fourierFactor_periodic, ih]

/-- On a non-integer fractional-time class the normalized multiplier has modulus `< 1`,
so the state decays to `0` under forward unit steps. -/
theorem fracClass_tendsto_zero {s r : ℝ} (hs : 1 < s) (hr : ∀ k : ℤ, r ≠ k) (x₀ : ℂ) :
    Tendsto (fracClass s r x₀) atTop (𝓝 0) := by
  set q := ‖fourierFactor s r‖ / zetaR s with hq
  have hz := zetaR_pos hs
  have hq1 : q < 1 := (div_lt_one hz).2 (norm_fourierFactor_lt hs hr)
  have hq0 : 0 ≤ q := by positivity
  have hform : ∀ k, ‖fracClass s r x₀ k‖ = q ^ k * ‖x₀‖ := by
    intro k
    induction k with
    | zero => simp [fracClass]
    | succ k ih =>
      have : r + ((k : ℝ) + 1) = r + ((k + 1 : ℕ) : ℝ) := by push_cast; ring
      rw [fracClass, this, fourierFactor_add_nat, norm_mul, norm_mul, ih, norm_div,
        Complex.norm_real, Real.norm_of_nonneg hz.le, Complex.exp_pi_mul_I]
      simp [hq]; ring
  rw [tendsto_zero_iff_norm_tendsto_zero]
  simp_rw [hform]
  simpa using (tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq1).mul_const ‖x₀‖

/-! ## Proposition 3: the Noroboro recurrence -/

private lemma exp_tri (α : ℝ) (k : ℕ) :
    cexp (α * (((k + 1 : ℕ) : ℝ) * (((k + 1 : ℕ) : ℝ) + 1) / 2 : ℝ)) =
      cexp (α * ((k : ℝ) + 1)) * cexp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2 : ℝ)) := by
  rw [← Complex.exp_add]; congr 1; push_cast; ring

/-- **Proposition 3.** `N_k = (-1)^k ζ(s)^k exp(α k(k+1)/2) N_0`. -/
theorem noroboro_closed_form (s α : ℝ) (N₀ : ℂ) (k : ℕ) :
    noroboro s α N₀ k =
      (-1) ^ k * (zetaR s : ℂ) ^ k * cexp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2 : ℝ)) * N₀ := by
  induction k with
  | zero => simp [noroboro]
  | succ k ih =>
    rw [noroboro, ih, fourierFactor_succ, Complex.exp_pi_mul_I]
    have := exp_tri α k
    push_cast at this ⊢
    rw [this]; ring

/-- Normalized Noroboro: `N̂_k = (-1)^k exp(α k(k+1)/2) N̂_0`. -/
theorem normNoroboro_closed_form {s : ℝ} (hs : 1 < s) (α : ℝ) (N₀ : ℂ) (k : ℕ) :
    normNoroboro s α N₀ k = (-1) ^ k * cexp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2 : ℝ)) * N₀ := by
  have hz : (zetaR s : ℂ) ≠ 0 := by exact_mod_cast (zetaR_pos hs).ne'
  induction k with
  | zero => simp [normNoroboro]
  | succ k ih =>
    rw [normNoroboro, ih, fourierFactor_succ, Complex.exp_pi_mul_I, div_self hz]
    have := exp_tri α k
    push_cast at this ⊢
    rw [this]; ring

private lemma superexp_aux {α : ℝ} (hα : 0 < α) (A B c : ℝ) (hA : 0 < A) (hB : 1 ≤ B) :
    Tendsto (fun k : ℕ => B ^ k * Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A /
      Real.exp (c * k)) atTop atTop := by
  have key : ∀ k : ℕ, Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k) ≤
      B ^ k * Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k) := by
    intro k
    have : (1 : ℝ) ≤ B ^ k := one_le_pow₀ hB
    have h0 : 0 ≤ Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k) := by
      positivity
    calc _ = 1 * (Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k)) := by ring
      _ ≤ B ^ k * (Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k)) :=
          mul_le_mul_of_nonneg_right this h0
      _ = _ := by ring
  refine tendsto_atTop_mono key ?_
  have h1 : ∀ k : ℕ, Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * A / Real.exp (c * k) =
      A * Real.exp (α / 2 * (k : ℝ) ^ 2 + (α / 2 - c) * k) := by
    intro k
    rw [mul_comm _ A, mul_div_assoc, ← Real.exp_sub]; congr 2; ring
  simp_rw [h1]
  refine Tendsto.const_mul_atTop hA (Real.tendsto_exp_atTop.comp ?_)
  have hpoly : Tendsto (fun x : ℝ => α / 2 * x ^ 2 + (α / 2 - c) * x) atTop atTop := by
    have : Tendsto (fun x : ℝ => x * (α / 2 * x + (α / 2 - c))) atTop atTop :=
      Tendsto.atTop_mul_atTop₀ tendsto_id
        (tendsto_atTop_add_const_right _ _ (tendsto_id.const_mul_atTop (by positivity)))
    exact this.congr fun x => by ring
  exact hpoly.comp tendsto_natCast_atTop_atTop

/-- For `α > 0` and nonzero initial data, `|N_k|` grows faster than `e^{ck}` for every
real `c`. -/
theorem noroboro_superexponential {s α : ℝ} (hs : 1 < s) (hα : 0 < α) {N₀ : ℂ} (h : N₀ ≠ 0)
    (c : ℝ) : Tendsto (fun k : ℕ => ‖noroboro s α N₀ k‖ / Real.exp (c * k)) atTop atTop := by
  have : ∀ k : ℕ, ‖noroboro s α N₀ k‖ =
      zetaR s ^ k * Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * ‖N₀‖ := by
    intro k
    rw [noroboro_closed_form, norm_mul, norm_mul, norm_mul, norm_pow, norm_pow,
      ← Complex.ofReal_mul, Complex.norm_exp_ofReal, Complex.norm_real,
      Real.norm_of_nonneg (zetaR_pos hs).le]
    simp
  simp_rw [this]
  exact superexp_aux hα _ _ c (norm_pos_iff.2 h) (one_lt_zetaR hs).le

/-- The normalized Noroboro also grows faster than any exponential. -/
theorem normNoroboro_superexponential {s α : ℝ} (hs : 1 < s) (hα : 0 < α) {N₀ : ℂ}
    (h : N₀ ≠ 0) (c : ℝ) :
    Tendsto (fun k : ℕ => ‖normNoroboro s α N₀ k‖ / Real.exp (c * k)) atTop atTop := by
  have : ∀ k : ℕ, ‖normNoroboro s α N₀ k‖ =
      1 ^ k * Real.exp (α * ((k : ℝ) * ((k : ℝ) + 1) / 2)) * ‖N₀‖ := by
    intro k
    rw [normNoroboro_closed_form hs, norm_mul, norm_mul, norm_pow,
      ← Complex.ofReal_mul, Complex.norm_exp_ofReal]
    simp
  simp_rw [this]
  exact superexp_aux hα _ _ c (norm_pos_iff.2 h) le_rfl

/-- The alternative constant-multiplier model: `G_k = (-1)^k e^{αk} G_0`. -/
theorem expModel_closed_form (α : ℝ) (G₀ : ℂ) (k : ℕ) :
    expModel α G₀ k = (-1) ^ k * cexp (α * k) * G₀ := by
  induction k with
  | zero => simp [expModel]
  | succ k ih =>
    rw [expModel, ih]
    push_cast
    rw [mul_add, mul_one, Complex.exp_add]; ring

/-! ## Iteration is not a limit; multiplication by `-1` preserves orientation -/

/-- The orbit `(-1)^k z` of the two-cycle, `z ≠ 0`, has no ordinary limit. -/
theorem alternating_orbit_no_limit {z : ℂ} (hz : z ≠ 0) :
    ¬ ∃ L : ℂ, Tendsto (fun k : ℕ => (-1 : ℂ) ^ k * z) atTop (𝓝 L) := by
  rintro ⟨L, hL⟩
  have hmul : Tendsto (fun k : ℕ => 2 * k) atTop atTop :=
    tendsto_atTop_atTop.2 fun b => ⟨b, fun a ha => by omega⟩
  have hodd : Tendsto (fun k : ℕ => 2 * k + 1) atTop atTop :=
    tendsto_atTop_atTop.2 fun b => ⟨b, fun a ha => by omega⟩
  have he : Tendsto (fun _ : ℕ => z) atTop (𝓝 L) :=
    (hL.comp hmul).congr fun k => by simp [Function.comp, pow_mul]
  have ho : Tendsto (fun _ : ℕ => -z) atTop (𝓝 L) :=
    (hL.comp hodd).congr fun k => by simp [Function.comp, pow_succ, pow_mul]
  have h1 := tendsto_nhds_unique tendsto_const_nhds he
  have h2 := tendsto_nhds_unique tendsto_const_nhds ho
  apply hz
  linear_combination (h1 - h2) / 2

/-- Multiplication by `-1` on `ℂ ≅ ℝ²` has determinant `1`: it is a rotation by `π`, hence
orientation-preserving (it does not by itself produce a Möbius-type twist). -/
theorem det_neg_id_complex : LinearMap.det (-LinearMap.id : ℂ →ₗ[ℝ] ℂ) = 1 := by
  rw [show (-LinearMap.id : ℂ →ₗ[ℝ] ℂ) = (-1 : ℝ) • LinearMap.id by simp, LinearMap.det_smul,
    LinearMap.det_id, Complex.finrank_real_complex]
  norm_num

end Oroboros

end
