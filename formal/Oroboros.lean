import Mathlib

/-! Integer-step recurrences and their defining convergent series, from docs/DERIVATION.md. -/

namespace Oroboros

open Filter
open scoped Topology

/-- The n=0 term is zero when s>1; this is the positive-index zeta series. -/
noncomputable def zetaSeries (s : ℝ) : ℝ := ∑' n : ℕ, 1 / (n : ℝ)^s

theorem zeta_summable (s : ℝ) (hs : 1 < s) :
    Summable (fun n : ℕ => 1 / (n : ℝ)^s) := Real.summable_one_div_nat_rpow.mpr hs

theorem zeta_gt_one (s : ℝ) (hs : 1 < s) : 1 < zetaSeries s := by
  let f : ℕ → ℝ := fun n => if n = 1 then 1 else 0
  have h0 (n : ℕ) : 0 ≤ f n := by dsimp [f]; split <;> norm_num
  have hfg (n : ℕ) : f n ≤ 1 / (n : ℝ)^s := by
    by_cases hn : n = 1
    · subst n; simp [f]
    · simp only [f, if_neg hn]
      positivity
  have hi : f 2 < 1 / (2 : ℝ)^s := by
    norm_num [f]
    positivity
  have h := Summable.tsum_lt_tsum_of_nonneg h0 hfg hi (zeta_summable s hs)
  simpa [f, zetaSeries] using h

noncomputable def fourier (s t : ℝ) : ℂ :=
  ∑' n : ℕ, (1 / (n : ℝ)^s : ℝ) *
    Complex.exp ((n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) * (t : ℂ))

theorem integer_fourier (s : ℝ) (k : ℤ) : fourier s k = (zetaSeries s : ℂ) := by
  have hp (n : ℕ) : Complex.exp ((n : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) * (k : ℂ)) = 1 := by
    convert Complex.exp_int_mul_two_pi_mul_I ((n : ℤ)*k) using 1 <;> push_cast <;> ring
  simp only [fourier, Complex.ofReal_intCast, hp, mul_one]
  exact (Complex.ofReal_tsum _).symm

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
  rw [orbit, norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by linarith : 0 < q)]
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
  have hzero : orbit 1 z n = 0 := by linear_combination -(1/2 : ℂ) * hneg
  exact hn hzero

theorem zero_orbit (q : ℝ) (n : ℕ) : orbit q 0 n = 0 := by simp [orbit_closed]

theorem original_zeta_not_two_periodic (s : ℝ) (hs : 1 < s)
    (z : ℂ) (hz : z ≠ 0) (n : ℕ) : orbit (zetaSeries s) z (n+2) ≠ orbit (zetaSeries s) z n :=
  original_not_two_periodic _ (zeta_gt_one s hs) z hz n

theorem normalized_has_no_limit (z : ℂ) (hz : z ≠ 0) :
    ¬ ∃ w : ℂ, Tendsto (orbit 1 z) atTop (𝓝 w) := by
  rintro ⟨w,hw⟩
  have hshift : Tendsto (fun n => orbit 1 z (n+1)) atTop (𝓝 w) :=
    (tendsto_add_atTop_iff_nat 1).mpr hw
  have hneg : Tendsto (fun n => orbit 1 z (n+1)) atTop (𝓝 (-w)) := by
    simpa [orbit] using hw.neg
  have he : w = -w := tendsto_nhds_unique hshift hneg
  have hw0 : w = 0 := by linear_combination (1/2 : ℂ) * he
  have hconstant : Tendsto (fun n => ‖orbit 1 z n‖) atTop (𝓝 ‖z‖) := by
    simpa only [normalized_norm] using (tendsto_const_nhds : Tendsto (fun _ : ℕ => ‖z‖) atTop (𝓝 ‖z‖))
  have hn : ‖w‖ = ‖z‖ := tendsto_nhds_unique hw.norm hconstant
  rw [hw0, norm_zero] at hn
  exact hz (norm_eq_zero.mp hn.symm)

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
    simp only [Nat.cast_add, Nat.cast_one]
    have he : α * (n + 1) * (n + 1 + 1) / 2 =
        α * (n + 1) + α * n * (n + 1) / 2 := by ring
    rw [he, Real.exp_add]
    push_cast
    ring

end Oroboros
