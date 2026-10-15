# Formal coverage

## Frozen target

Source: [`docs/DERIVATION.md`](../docs/DERIVATION.md), baseline commit `4c3560addaf141fa026a3324fd8e4d839646151b`.
The definitions and theorem hypotheses in `Oroboros.lean` are the acceptance target.
The pinned Lean/Mathlib build and strict axiom audit must pass before treating a
statement as machine-checked. The workflow records the exact tested commit/run.

## Statements covered

Convergence and strict positivity above one of the defining real zeta series; the integer-time Fourier identity; exact constant-multiplier and time-varying exponential recurrences; norm growth; failure of the original nonzero two-cycle; normalized minimal period two, constant norm and nonexistence of an ordinary limit for nonzero initial data.

## Limits and unresolved obligations

This earlier package does not include uniform convergence or strict normalized contraction away from integer times. The separately built and audited root `RequestProject` package proves strict contraction and fractional-class decay; see [the full catalogue](../UNIVERSE.md) and [its verification](../VERIFICATION.md). Uniform convergence is not separately listed as a theorem in either package. No topology, fractality, physical or metaphysical claim follows.

## Evidence discipline

These are established algebra, analysis and finite-dimensional mathematics,
not a novelty claim. Formal proofs establish only their stated hypotheses and
conclusions. Computational regression tests are software checks, not independent
experimental evidence. No theorem uses a claimed physical interpretation as a
premise. No custom axioms, `sorry`, or native-evaluation trust exception is allowed.
No new animal operation is invented or claimed to have been executed.

The first evidence status is **unresolved** until the exact-commit workflow
succeeds; thereafter only the covered formal statements are **demonstrated**.
Scientific applicability remains a **hypothesis/postulate** unless separately tested.
