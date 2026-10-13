/* Dimensionless discrete recurrences. No external dependencies. */
(function (root, factory) {
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.OroborosMath = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  'use strict';

  // Euler–Maclaurin summation; floating-point illustration, not interval arithmetic.
  // The supported numerical domain matches the interactive page.
  function zeta(s) {
    if (!Number.isFinite(s) || s < 1.25 || s > 6) {
      throw new RangeError('The numerical implementation supports 1.25 <= s <= 6.');
    }
    const m = 32;
    let total = 0;
    for (let n = 1; n < m; n++) total += Math.pow(n, -s);
    total += Math.pow(m, 1 - s) / (s - 1) + 0.5 * Math.pow(m, -s);
    const coefficients = [1/12, -1/720, 1/30240, -1/1209600, 1/47900160, -691/1307674368000];
    let rising = s;
    for (let j = 0; j < coefficients.length; j++) {
      if (j > 0) rising *= (s + 2*j - 1) * (s + 2*j);
      total += coefficients[j] * rising * Math.pow(m, -s - 2*j - 1);
    }
    return total;
  }

  function predict(s, alpha, k) {
    if (!Number.isFinite(alpha) || alpha < 0 || alpha > 0.30) throw new RangeError('Use 0 <= alpha <= 0.30.');
    if (!Number.isInteger(k) || k < 0 || k > 20) throw new RangeError('Use integer steps 0 <= k <= 20.');
    const z = zeta(s);
    const a = k * Math.log(z);
    const b = alpha * k * (k + 1) / 2;
    return {
      zeta: z,
      sign: k % 2 ? -1 : 1,
      logs: { original: a, cycle: 0, noroboro: a + b, normalizedNoroboro: b }
    };
  }

  return Object.freeze({ zeta, predict });
});
