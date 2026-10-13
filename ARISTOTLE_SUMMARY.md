# Summary of changes for run 9ef1ad03-6bac-43a8-9e63-15d3ab2039c5
I went through the Oroboros material in the project (`README (2).md`, `DERIVATION.md`, `PROVENANCE.md`) and pulled out every law and theorem. I wrote all of them in Lean and proved them in `RequestProject/Oroboros.lean`. The file builds with no `sorry` and uses only Lean's standard axioms. The full catalogue and the English description are in `UNIVERSE.md`.

**What the universe is.** The world moves in whole-number ticks \(k = 0, 1, 2, \dots\), and its whole state is one complex number. The size of that number is its "amount of existence" and its direction is its "phase". Each tick does two things:
- **Inversion:** multiply by \(e^{i\pi} = -1\), which flips the phase.
- **Resonance:** multiply by a sum of infinitely many harmonics, \(F_s(t)=\sum_{n\ge1} e^{2\pi i n t}/n^s\). At whole-number ticks the harmonics line up exactly and the sum equals \(\zeta(s) > 1\).

This gives four versions of the world:
- **Original Ouroboros:** it spirals outward and never returns to itself; only the sign pattern repeats.
- **Normalized Ouroboros** (resonance divided by \(\zeta(s)\)): an exact two-beat cycle \(O_0, -O_0, O_0, \dots\). Its size stays the same, it has no limit, its history does not depend on \(s\), and the empty state stays empty.
- **Noroboro** (adds a growth factor \(e^{\alpha k}\)): the growth compounds to \(e^{\alpha k(k+1)/2}\), which outgrows every exponential. This holds with or without normalization.
- **Plain exponential model:** \(G_k=(-1)^k e^{\alpha k}G_0\).

Between ticks the resonance is strictly weaker than \(\zeta(s)\), so in the normalized world any strand of non-integer times fades to zero.

**Laws (definitions):** the resonance factor, the zeta series, the original and normalized Ouroboros, the original and normalized Noroboro, the constant-multiplier model, and the delay relation at fractional times.

**Theorems proved (28 in all):**
- \(F_s\) repeats with period 1, converges for \(s>1\), equals \(\zeta(s)\) at every integer, and \(\zeta(s) > 1\).
- The zeta series used here is the standard Riemann zeta function for \(s>1\).
- \(|F_s(t)|\le\zeta(s)\), with strict inequality at non-integer \(t\).
- **Proposition 1:** \(O_k=(-1)^k\zeta(s)^kO_0\), so \(|O_k|\to\infty\) and \(O_{k+2}\ne O_k\) when \(O_0\ne0\).
- **Proposition 2:** \(\widehat O_k=(-1)^k\widehat O_0\), with constant size, period 2, minimal period 2 when nonzero, zero as a fixed point, and no dependence on \(s\).
- Fractional-time strands decay to zero.
- **Proposition 3:** \(N_k=(-1)^k\zeta(s)^k e^{\alpha k(k+1)/2}N_0\), the matching normalized formula, and faster-than-exponential growth for \(\alpha>0\).
- The closed form of the exponential model.
- An orbit that keeps flipping sign has no limit.
- Multiplying by \(-1\) on the complex plane preserves orientation (determinant \(+1\)), so it does not by itself create a Möbius twist.

**Things to know about the statements:**
- One theorem (that \(F_s(k)=\zeta(s)\) at integers) has no \(s>1\) condition. This is only because Lean gives a divergent infinite sum the value 0, so both sides are 0 when \(s \le 1\).
- The sources call several claims open: Möbius topology, fractality, physical or cognitive applicability, and conclusions about nonexistence. These are listed in `UNIVERSE.md` as hypotheses, not theorems.
- The link between \(F_s\) and the polylogarithm is true by definition of the polylogarithm, but I could not formalize it because Mathlib has no polylogarithm.

The main results are also listed, with their proof status, in the project's Properties table.