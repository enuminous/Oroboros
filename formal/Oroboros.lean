import Mathlib

/-! Integer-step recurrences from docs/DERIVATION.md, with the multiplier explicit.
The Fourier/zeta identification is a separate analytic obligation. -/

namespace Oroboros

noncomputable def orbit (q : ℝ) (z : ℂ) : ℕ → ℂ
  | 0 => z
  | n + 1 => -(q : ℂ) * orbit q z n

theorem orbit_closed (q : ℝ) (z : ℂ) (n : ℕ) :
    orbit q z n = (-(q : ℂ)) ^ n * z := by
  induction n with
  | zero => simp [orbit]
  | succ n ih => rw [orbit, ih, pow_succ]; ring

theorem orbit_norm (q : ℝ) (hq : 0 ≤ q) (z : ℂ) (n : ℕ) :
    ‖orbit q z n‖ = q ^ n * ‖z‖ := by
  simp [orbit_closed, norm_mul, norm_pow, Complex.norm_real, abs_of_nonneg hq]

theorem orbit_nonzero (q : ℝ) (hq : q ≠ 0) (z : ℂ) (hz : z ≠ 0) (n : ℕ) :
    orbit q z n ≠ 0 := by
  rw [orbit_closed]
  exact mul_ne_zero (pow_ne_zero n (neg_ne_zero.mpr (Complex.ofReal_ne_zero.mpr hq))) hz

theorem growth (q : ℝ) (hq : 1 < q) (z : ℂ) (hz : z ≠ 0) (n : ℕ) :
    ‖orbit q z n‖ < ‖orbit q z (n + 1)‖ := by
  rw [orbit, norm_mul, norm_neg, Complex.norm_real, abs_of_pos (by linarith : 0 < q)]
  have hp := norm_pos_iff.mpr (orbit_nonzero q (by linarith) z hz n)
  nlinarith

theorem original_not_two_periodic (q : ℝ) (hq : 1 < q) (z : ℂ) (hz : z ≠ 0)
    (n : ℕ) : orbit q z (n + 2) ≠ orbit q z n := by
  intro h
  have h1 := growth q hq z hz n
  have h2 := growth q hq z hz (n + 1)
  rw [show n + 1 + 1 = n + 2 by omega, h] at h2
  linarith

theorem normalized_two_periodic (z : ℂ) (n : ℕ) :
    orbit 1 z (n + 2) = orbit 1 z n := by simp [orbit]

theorem normalized_norm (z : ℂ) (n : ℕ) : ‖orbit 1 z n‖ = ‖z‖ := by
  simpa using orbit_norm 1 (by norm_num) z n

theorem normalized_not_fixed (z : ℂ) (hz : z ≠ 0) (n : ℕ) :
    orbit 1 z (n + 1) ≠ orbit 1 z n := by
  intro h
  have hn := orbit_nonzero 1 (by norm_num) z hz n
  have hneg : -orbit 1 z n = orbit 1 z n := by simpa [orbit] using h
  have hzero : orbit 1 z n = 0 := by linear_combination hneg
  exact hn hzero

theorem zero_orbit (q : ℝ) (n : ℕ) : orbit q 0 n = 0 := by simp [orbit_closed]

noncomputable def noroboro (q α : ℝ) (z : ℂ) : ℕ → ℂ
  | 0 => z
  | n + 1 => -(q : ℂ) * (Real.exp (α * (n + 1)) : ℂ) * noroboro q α z n

theorem noroboro_closed (q α : ℝ) (z : ℂ) (n : ℕ) :
    noroboro q α z n = (-(q : ℂ)) ^ n *
      (Real.exp (α * n * (n + 1) / 2) : ℂ) * z := by
  induction n with
  | zero => simp [noroboro]
  | succ n ih =>
    rw [noroboro, ih, pow_succ]
    push_cast
    have he : α * (n + 1) * (n + 1 + 1) / 2 =
        α * (n + 1) + α * n * (n + 1) / 2 := by ring
    rw [he, Real.exp_add]
    push_cast
    ring

end Oroboros
