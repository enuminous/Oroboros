# Oroboros

**Exact recurrences, a normalized two-cycle, and a Lean 4 theorem catalogue.**

Oroboros develops Matthew Chenoweth Wright's Ouroboros and Noroboro equations from the February 5, 2025 article. The October 13, 2026 mathematical revision specifies their assumptions and exact solutions; Aristotle's completed formalization supplies the [28-theorem catalogue](UNIVERSE.md) and [Lean source](RequestProject/Oroboros.lean).

[Interactive website](https://enuminous.github.io/Oroboros/) · [Theorem catalogue](UNIVERSE.md) · [Derivation](DERIVATION.md) · [Lean source](RequestProject/Oroboros.lean) · [Verification workflow](https://github.com/enuminous/Oroboros/actions/workflows/lean.yml) · [Provenance](PROVENANCE.md)

<!-- ENUMINOUS-NETWORK:START -->
**eNuminous network:** [All repositories](https://enuminous.github.io/EFMW/repositories.html) · [EFMW](https://enuminous.github.io/EFMW/) · [102 equations](https://github.com/enuminous/Monolithic_102_EFMW) · [165 triplets](https://enuminous.github.io/FieldSpace/) · [Zoo](https://enuminous.github.io/Tortoise/) · [Lean](https://enuminous.github.io/Aristotle-102-Monolithic-Lean/) · [Engine](https://enuminous.github.io/Archimedes-Engine/) · [Papers](https://enuminous.github.io/medium/papers-essays-index.html) · [Audit](https://github.com/enuminous/EFMW_Post156_Zoo_Audit/blob/main/portfolio/INTERLOCK_AUDIT.md)

[Repository](https://github.com/enuminous/Oroboros) · [Published page](https://enuminous.github.io/Oroboros/)

<details>
<summary>Recent repositories (9)</summary>

- [Oroboros](https://github.com/enuminous/Oroboros) · [README](https://github.com/enuminous/Oroboros/blob/main/README.md) · [Page](https://enuminous.github.io/Oroboros/)
- [P-NP](https://github.com/enuminous/P-NP) · [README](https://github.com/enuminous/P-NP/blob/main/README.md) · [Page](https://enuminous.github.io/P-NP/)
- [Research-Program](https://github.com/enuminous/Research-Program) · [README](https://github.com/enuminous/Research-Program/blob/main/README.md) · [Page](https://enuminous.github.io/Research-Program/)
- [I-Have-Guts](https://github.com/enuminous/I-Have-Guts) · [README](https://github.com/enuminous/I-Have-Guts/blob/main/README.md) · [Page](https://enuminous.github.io/I-Have-Guts/)
- [Wrights-Law](https://github.com/enuminous/Wrights-Law) · [README](https://github.com/enuminous/Wrights-Law/blob/main/README.md) · [Page](https://enuminous.github.io/Wrights-Law/)
- [Aristotle-eNuminous](https://github.com/enuminous/Aristotle-eNuminous) · [README](https://github.com/enuminous/Aristotle-eNuminous/blob/main/README.md) · [Page](https://enuminous.github.io/Aristotle-eNuminous/)
- [Multiverse-Simulator](https://github.com/enuminous/Multiverse-Simulator) · [README](https://github.com/enuminous/Multiverse-Simulator/blob/main/README.md) · [Page](https://enuminous.github.io/Multiverse-Simulator/)
- [accelerando-8192](https://github.com/enuminous/accelerando-8192) · [README](https://github.com/enuminous/accelerando-8192/blob/main/README.md) · [Page source](https://github.com/enuminous/accelerando-8192/blob/main/docs/index.html)
- [Codex-888](https://github.com/enuminous/Codex-888) · [README](https://github.com/enuminous/Codex-888/blob/main/README.md) · [Page](https://enuminous.github.io/Codex-888/)

</details>

<details>
<summary>Repository indexes (1)</summary>

- [index.html](https://github.com/enuminous/Oroboros/blob/main/index.html) · [Open page](https://enuminous.github.io/Oroboros/index.html)

</details>
<!-- ENUMINOUS-NETWORK:END -->

## The equations

Work with integer steps $k\geq0$ (updates for $k\geq1$), real $s>1$, complex initial data, and real $\alpha\geq0$. Here $s$ is the original article's exponent $x$. The step index and parameters are dimensionless.

For real $t$, define the absolutely convergent Fourier factor

$$F_s(t)=\sum_{n=1}^{\infty}\frac{e^{2\pi i n t}}{n^s}.$$

At integer steps, $F_s(k)=\zeta(s)>1$ and $e^{i\pi}=-1$. The original equations therefore become

$$O_k=e^{i\pi}O_{k-1}F_s(k)=-\zeta(s)O_{k-1},$$

$$N_k=e^{\alpha k}e^{i\pi}N_{k-1}F_s(k)=-\zeta(s)e^{\alpha k}N_{k-1}.$$

The normalized models replace $F_s(t)$ with $\widehat F_s(t)=F_s(t)/\zeta(s)$. This is an **explicit modification** of the original equations. For Ouroboros it gives

$$\widehat O_k=e^{i\pi}\widehat O_{k-1}\frac{F_s(k)}{\zeta(s)}
=-\widehat O_{k-1}=(-1)^k\widehat O_0.$$

The resulting exact solutions are:

| Model | Closed form at integer steps | Behavior for nonzero initial data |
|---|---|---|
| Original Ouroboros | $O_k=(-1)^k\zeta(s)^kO_0$ | Alternating exponential growth; no closed two-cycle |
| Normalized Ouroboros | $\widehat O_k=(-1)^k\widehat O_0$ | Constant magnitude; minimal period two |
| Original Noroboro | $N_k=(-1)^k\zeta(s)^k e^{\alpha k(k+1)/2}N_0$ | Faster than every fixed exponential when $\alpha>0$ |
| Normalized Noroboro | $\widehat N_k=(-1)^k e^{\alpha k(k+1)/2}\widehat N_0$ | Same faster-than-exponential growth when $\alpha>0$, without the zeta factor |

Zero initial data remain zero. The normalized Ouroboros cycle is independent of $s$ and has no ordinary limit for nonzero initial data. Its exact two-cycle is an **integer-step** result: normalized noninteger fractional-time classes decay to zero under forward unit steps. See the [derivation](DERIVATION.md) for the real-time initial-history requirement and the constant-multiplier exponential alternative.

## Read and explore

| Resource | What it contains |
|---|---|
| [UNIVERSE.md](UNIVERSE.md) | Plain-English model description, eight defining rules, all 28 named theorems, and open claims |
| [DERIVATION.md](DERIVATION.md) | Assumptions, exact recurrence solutions, normalization, proofs, and interpretation limits |
| [RequestProject/Oroboros.lean](RequestProject/Oroboros.lean) | Aristotle's full 28-theorem formalization, including fractional-time decay and orientation |
| [ARISTOTLE_SUMMARY.md](ARISTOTLE_SUMMARY.md) | Completion report and formalization notes |
| [Interactive website](https://enuminous.github.io/Oroboros/) | Comparison of the four models, with log-magnitude plots and a step table |
| [Consistency review](docs/CONSISTENCY_REVIEW.md) | Acceptance criteria, negative results, and remaining scientific obligations |
| [PROVENANCE.md](PROVENANCE.md) | Original-source metadata and hashes; the [archived article](archive/2025-02-05-original.html) preserves the source text |

## Verification and reproduction

There are two existing Lean packages with different scopes:

| Package | Scope and verification record |
|---|---|
| Root [RequestProject](lakefile.toml) | The 28 theorems catalogued in `UNIVERSE.md`. The `catalogue` CI job builds the complete source, checks its 28-name correspondence, and audits all project declarations. See [full-catalogue verification](VERIFICATION.md) and [Aristotle's report](ARISTOTLE_SUMMARY.md). |
| [formal/](formal/Oroboros.lean) | The core recurrence and series results covered by the existing [GitHub Actions workflow](.github/workflows/lean.yml), with a strict axiom audit and rejection controls. See its [coverage](formal/COVERAGE.md) and [reproduction instructions](formal/VERIFICATION.md). |

The [successful October 13, 2026 verification run](https://github.com/enuminous/Oroboros/actions/runs/38487224539) checks `formal/`, its axiom audit, and the computational regression checks. The workflow now also has a separate `catalogue` job for the complete root `RequestProject` package; check both job results for verification of both scopes. [View current workflow runs](https://github.com/enuminous/Oroboros/actions/workflows/lean.yml).

To build Aristotle's catalogue from the repository root, use the committed [Lean 4.28.0 toolchain](lean-toolchain) and [dependency manifest](lake-manifest.json):

```sh
lake exe cache get
lake build
python3 scripts/verify_catalogue.py
lake env lean -DwarningAsError=true Audit.lean
python3 scripts/test_axiom_audit.py
```

Run the existing numerical consistency checks from the repository root:

```sh
node scripts/verify.cjs
```

These floating-point checks compare direct iteration, closed forms, boundary cases, and known zeta values; [recorded results](verification/results.json) are available. They supplement formal proofs and do not constitute experimental evidence.

To explore locally, open `index.html` or run `python3 -m http.server 8000` from the repository root and visit `http://localhost:8000`.

## What is proved, and what remains open

The catalogue establishes mathematical properties under explicit hypotheses: convergence, exact recurrence solutions, growth, the normalized two-cycle, fractional-time decay, and orientation preservation. The normalized discrete cycle and zeta/polylogarithm relationships are established mathematics; this project makes no novelty claim for those facts.

Physical or cognitive applicability, Möbius topology, fractality, and metaphysical conclusions remain **open hypotheses or interpretations**. Multiplication by $-1$ on $\mathbb C$ has determinant $+1$ and does not by itself construct a Möbius strip. A mathematical zero state does not establish anything about absolute nonexistence. There are no experimental data or empirical replications in this repository. The polylogarithm identification is discussed in the derivation but was not separately formalized in the 28-theorem source.

The website's [conceptual artwork](docs/ARTWORK.md) is an artistic interpretation, not a computed trajectory.

## Provenance and attribution

Original concept and article: **Matthew Chenoweth Wright**, February 5, 2025. Mathematical revision: October 13, 2026, prepared with AI assistance at the author's request. See the [source provenance](PROVENANCE.md) and [preserved original](archive/2025-02-05-original.html). The provenance file records the earlier revision stage; the later formalization is documented in [Aristotle's completion report](ARISTOTLE_SUMMARY.md).

This project was edited by [Aristotle](https://aristotle.harmonic.fun).

To cite Aristotle:

- Tag @Aristotle-Harmonic on GitHub PRs/issues
- Add as co-author to commits:
```
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```
