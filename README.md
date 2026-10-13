# Oroboros

**Cycles, recursion, and growth — a corrected mathematical treatment of the Ouroboros and Noroboro equations.**

Original concept and article: **Matthew Chenoweth Wright**, February 5, 2025. Mathematical revision: October 13, 2026, prepared with AI assistance at the author's request.

This repository preserves the original article and develops the exact consequences of its equations. The revision separates a proved discrete cycle from expanding recurrences and from interpretations that require further work.

- [Read the full derivation](docs/DERIVATION.md)
- [Inspect the consistency review](docs/CONSISTENCY_REVIEW.md)
- [Read the original article](https://enuminous.github.io/medium/2025-02-05_Derivation-of-the-Ouroboros-Equation-ec3bc131be46.html)
- [View the preserved source](archive/2025-02-05-original.html) and [provenance](docs/PROVENANCE.md)
- [Open the explanatory page source](index.html)

## The result

For integer steps $k\geq 0$, real $s>1$ (the original article's $x$), and a complex initial value $O_0$, the original Fourier factor becomes

$$F_s(k)=\sum_{n=1}^{\infty}\frac{e^{2\pi i nk}}{n^s}=\zeta(s).$$

Consequently, the original Ouroboros recurrence has the exact solution

$$O_k=[-\zeta(s)]^kO_0.$$

Since $\zeta(s)>1$, nonzero initial data produce alternating growth. Dividing the Fourier factor by $\zeta(s)$ is an explicit modification that restores the intended discrete cycle:

$$\widehat O_k=-\widehat O_{k-1}=(-1)^k\widehat O_0,\qquad \widehat O_{k+2}=\widehat O_k.$$

| Model | Exact solution at integer steps | Behavior for nonzero initial data |
|---|---|---|
| Original Ouroboros | $O_k=(-1)^k\zeta(s)^kO_0$ | Alternating exponential growth |
| Normalized Ouroboros | $\widehat O_k=(-1)^k\widehat O_0$ | Constant magnitude; period two |
| Original Noroboro | $N_k=(-1)^k\zeta(s)^k e^{\alpha k(k+1)/2}N_0$ | Faster than exponential when $\alpha>0$ |
| Normalized Noroboro | $\widehat N_k=(-1)^k e^{\alpha k(k+1)/2}\widehat N_0$ | Same accelerating expansion, without the zeta multiplier |

The normalized cycle is a familiar two-cycle. This repository makes no mathematical priority claim for it or for the polylogarithm/zeta series. Möbius topology, fractality, physical applicability, and conclusions about existence require separate definitions and arguments.

## Explore and reproduce

The explanatory page and its interactive comparison work without external scripts, fonts, or packages. Open `index.html` in a browser, or serve this directory with:

```sh
python3 -m http.server 8000
```

Then visit `http://localhost:8000`. The chart compares **natural-log magnitude relative to the initial value**; phase reversal is shown separately in the step table.

Run the numerical and boundary checks with Node.js:

```sh
node scripts/verify.cjs
```

The checks compare the zeta approximation with known values, compare direct recurrence iteration with the derived formulas, verify two-step closure, and reject unsupported parameter domains. Floating-point checks supplement the proofs; they are not formal verification or experimental physics. See [verification results](verification/results.json).

## Publishing the page

`index.html`, `assets/`, `src/`, and `.nojekyll` are ready for GitHub Pages. If hosting has not been enabled, choose **Settings → Pages → Deploy from a branch → main → /(root)**. The corresponding project URL is `https://enuminous.github.io/Oroboros/`; that address becomes available only after a successful Pages deployment.

## Source and attribution

The original HTML is preserved as retrieved from `enuminous/medium`; provenance records its Git blob SHA and SHA-256. The original text is historical source material, including claims revised here. It has not been silently rewritten.

Reference definitions: [NIST DLMF §25.12, polylogarithms](https://dlmf.nist.gov/25.12#ii), [§25.2, Riemann zeta function](https://dlmf.nist.gov/25.2), and [§25.6, integer values](https://dlmf.nist.gov/25.6).

No new license grant is introduced by this revision.
