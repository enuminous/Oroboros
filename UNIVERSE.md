# The Oroboros universe: laws, theorems, and a plain-English description

This file covers the material in `README (2).md`, `DERIVATION.md` and `PROVENANCE.md`.
All the mathematics is formalized and proved in `RequestProject/Oroboros.lean`, which builds
with no `sorry` and uses only Lean's standard axioms. Lean names are given in brackets.

---

## 1. The universe in plain English

The Oroboros universe is a one-number world that moves in **discrete ticks**
\(k = 0, 1, 2, \dots\). At each tick its whole state is one complex number. The size
(modulus) of that number is the world's "amount of existence". Its direction (phase) is the
world's "orientation".

It has three fixed constants:

* **\(s > 1\)**, the *texture exponent*. It weights an infinite tower of harmonics
  \(e^{2\pi i n t}/n^s\). Low harmonics dominate, and high harmonics fade like \(1/n^s\).
* **\(\alpha \ge 0\)**, the *expansion rate*. It is used only by the Noroboro variant.
* **The initial state** \(O_0\) (or \(N_0\)), any complex number.

Each tick does two things:

1. **Inversion.** Multiply by \(e^{i\pi} = -1\). The world flips to its mirror phase
   (the snake turns to face its tail).
2. **Resonance.** Multiply by the sum of all the harmonics, \(F_s(t)\). At a whole-number
   tick every harmonic lines up exactly, because \(e^{2\pi i n k} = 1\). The resonance then
   equals the Riemann zeta value \(\zeta(s) = 1 + 2^{-s} + 3^{-s} + \cdots\), which is
   always greater than 1.

Four versions of this world follow from those rules:

* **The original Ouroboros.** The state flips sign every tick and its size is multiplied by
  \(\zeta(s) > 1\) each time. It never returns to itself, and it spirals outward forever
  with alternating phase. "Eternal return" fails in this version: only the sign pattern
  repeats.
* **The normalized Ouroboros** (divide the resonance by \(\zeta(s)\)). This world is an
  exact **two-beat cycle** \(O_0, -O_0, O_0, -O_0, \dots\). Its size is conserved, it returns
  to itself every two ticks, and it never settles (it has no limit). The texture \(s\) has
  no visible effect: every \(s > 1\) gives the same history. The empty world \(O_0 = 0\) stays
  empty forever.
* **The Noroboro** (adds a growth factor \(e^{\alpha k}\) that increases with time). The
  growth compounds, so \(\log|N_k|\) grows **quadratically**: \(N_k\) contains
  \(e^{\alpha k(k+1)/2}\). For \(\alpha > 0\) it outgrows every exponential \(e^{ck}\),
  with or without the \(\zeta\) normalization. This is an accelerating cosmos that flips
  phase every tick.
* **The plain exponential model** \(G_k = -e^{\alpha}G_{k-1}\). This is a suggested
  alternative with steady exponential growth, \(G_k = (-1)^k e^{\alpha k} G_0\).

Between the ticks, at fractional times, the harmonics no longer line up. The resonance is
then strictly weaker than \(\zeta(s)\). In the normalized world, any "fractional-time
strand" \(r, r+1, r+2, \dots\) with \(r\) not a whole number therefore **fades to
nothing**. The perfect cycle exists only at whole-number ticks.

The sources also list what this universe does **not** contain, and Lean confirms the
relevant part. Flipping the sign of a complex number is a rotation by \(\pi\) (its
determinant is \(+1\)). It preserves orientation, so it does not by itself produce a
Möbius-strip twist. The repository also gives no proof of fractal structure, physical
applicability, or anything about "absolute nonexistence". The mathematical zero state is
just the number 0.

---

## 2. Laws (the defining rules)

| # | Law | Lean definition |
|---|-----|-----------------|
| L1 | Fourier (resonance) factor \(F_s(t)=\sum_{n\ge1} e^{2\pi i n t}/n^s\) | `Oroboros.fourierFactor` |
| L2 | Zeta value \(\zeta(s)=\sum_{n\ge1} n^{-s}\) | `Oroboros.zetaR` |
| L3 | Original Ouroboros: \(O_k = e^{i\pi}\,O_{k-1}\,F_s(k)\) | `Oroboros.ouroboros` |
| L4 | Normalized Ouroboros: \(\widehat O_k = e^{i\pi}\,\widehat O_{k-1}\,F_s(k)/\zeta(s)\) | `Oroboros.normOuroboros` |
| L5 | Original Noroboro: \(N_k = e^{\alpha k}e^{i\pi}\,N_{k-1}\,F_s(k)\) | `Oroboros.noroboro` |
| L6 | Normalized Noroboro: \(\widehat N_k = e^{\alpha k}e^{i\pi}\,\widehat N_{k-1}\,F_s(k)/\zeta(s)\) | `Oroboros.normNoroboro` |
| L7 | Constant-multiplier model: \(G_k=-e^{\alpha}G_{k-1}\) | `Oroboros.expModel` |
| L8 | Fractional-time delay relation on the class \(r+k\) | `Oroboros.fracClass` |

Standing assumptions: integer steps \(k\ge 0\), real \(s>1\), real \(\alpha\) (with
\(\alpha>0\) for growth claims), and complex initial data.

---

## 3. Theorems (all proved in Lean)

**Fourier factor and zeta**

1. \(F_s\) has period 1: \(F_s(t+1)=F_s(t)\). [`fourierFactor_periodic`]
2. For \(s>1\) the series converges absolutely for every real \(t\). [`summable_fourierFactor`]
3. \(F_s(k)=\zeta(s)\) at every integer \(k\). [`fourierFactor_intCast`]
4. The series \(\zeta(s)\) is Mathlib's Riemann zeta function for \(s>1\). [`zetaR_eq_riemannZeta`]
5. \(\zeta(s)>1\) for real \(s>1\). [`one_lt_zetaR`]
6. \(|F_s(t)|\le\zeta(s)\) for all real \(t\). [`norm_fourierFactor_le`]
7. \(|F_s(t)|<\zeta(s)\) whenever \(t\) is not an integer. [`norm_fourierFactor_lt`]

**Proposition 1: the original Ouroboros**

8. Step law: \(O_{k+1}=-\zeta(s)\,O_k\). [`ouroboros_step`]
9. Closed form: \(O_k=(-1)^k\zeta(s)^kO_0\). [`ouroboros_closed_form`]
10. \(|O_k|=\zeta(s)^k|O_0|\). [`norm_ouroboros`]
11. If \(O_0\ne0\), then \(|O_k|\to\infty\). [`ouroboros_tendsto_infinity`]
12. \(O_{k+2}=\zeta(s)^2O_k\). [`ouroboros_two_step`]
13. If \(O_0\ne0\), then \(O_{k+2}\ne O_k\), so there is no closed two-cycle. [`ouroboros_not_two_cycle`]

**Proposition 2: the normalized cycle**

14. Step law: \(\widehat O_{k+1}=-\widehat O_k\). [`normOuroboros_step`]
15. \(\widehat O_k=(-1)^k\widehat O_0\). [`normOuroboros_closed_form`]
16. Constant magnitude: \(|\widehat O_k|=|\widehat O_0|\). [`norm_normOuroboros`]
17. Period two: \(\widehat O_{k+2}=\widehat O_k\). [`normOuroboros_period_two`]
18. If \(\widehat O_0\ne0\), then \(\widehat O_{k+1}\ne\widehat O_k\), so the minimal period is 2. [`normOuroboros_minimal_period`]
19. Zero initial data stay at zero. [`normOuroboros_zero`]
20. The dynamics do not depend on \(s\). [`normOuroboros_indep_s`]

**Away from integer times**

21. For non-integer \(r\), the normalized fractional-time class decays to 0. [`fracClass_tendsto_zero`]

**Proposition 3: the Noroboro**

22. \(N_k=(-1)^k\zeta(s)^k e^{\alpha k(k+1)/2}N_0\). [`noroboro_closed_form`]
23. \(\widehat N_k=(-1)^k e^{\alpha k(k+1)/2}\widehat N_0\). [`normNoroboro_closed_form`]
24. If \(\alpha>0\) and \(N_0\ne0\), then \(|N_k|/e^{ck}\to\infty\) for every real \(c\). [`noroboro_superexponential`]
25. The same holds for the normalized Noroboro. [`normNoroboro_superexponential`]
26. Alternative model: \(G_k=(-1)^ke^{\alpha k}G_0\). [`expModel_closed_form`]

**Iteration and orientation**

27. If \(z\ne0\), the orbit \((-1)^kz\) has no ordinary limit, so the cycle cannot be written as a limit. [`alternating_orbit_no_limit`]
28. \(z\mapsto -z\) on \(\mathbb C\cong\mathbb R^2\) has determinant \(+1\), so it preserves orientation. [`det_neg_id_complex`]

---

## 4. Hypotheses and open claims (not theorems)

The sources label these items as unproved or interpretive. They are recorded here and were
not formalized:

* A **Möbius topology** would need a specified state space and identification. Theorem 28
  shows that sign reversal on \(\mathbb C\) alone does not produce one.
* **Fractality** would need a defined geometric object with proved scaling or dimension
  properties.
* **Physical, cognitive or temporal applicability** would need observables, units and
  predictions that could fail. There are no data in the repository.
* **Metaphysical claims** about absolute nonexistence are not established. The zero state is
  only the number 0.
* The identity \(F_s(t)=\operatorname{Li}_s(e^{2\pi i t})\) (polylogarithm) is the definition
  of the polylogarithm series. It was not formalized separately because Mathlib has no
  polylogarithm.

## 5. Notes on the formalization

* "Integer steps" means sequences indexed by \(k\in\mathbb N\). The recurrences use the
  original factors \(e^{i\pi}\), \(e^{\alpha k}\) and \(F_s(k)\) literally, and the
  simplifications to \(-1\) and \(\zeta(s)\) are proved, not assumed.
* Lean gives the value 0 to a divergent infinite sum. Theorem 3 is therefore stated without
  the hypothesis \(s>1\): when \(s\le1\) both sides are 0 in Lean. Every result where
  \(s>1\) matters mathematically assumes it.
