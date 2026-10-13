'use strict';
// Run from any working directory: node scripts/verify.cjs
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { zeta, predict } = require('../src/math.js');
const results = [];
function check(name, run) { run(); results.push({ name, status: 'passed' }); }
function close(actual, expected, tolerance = 2e-12) {
  assert.ok(Math.abs(actual - expected) <= tolerance * Math.max(1, Math.abs(expected)), `${actual} != ${expected}`);
}

check('Zeta agrees with pi^2/6 and pi^4/90', () => {
  close(zeta(2), Math.PI**2 / 6, 3e-14);
  close(zeta(4), Math.PI**4 / 90, 3e-14);
});

check('Zeta lies inside direct positive-series integral bounds across the UI domain', () => {
  const n = 4096;
  for (let s = 1.25; s <= 6; s += 0.25) {
    let sum = 0;
    for (let j = 1; j <= n; j++) sum += j**(-s);
    const lower = sum + (n+1)**(1-s)/(s-1);
    const upper = sum + n**(1-s)/(s-1);
    assert.ok(zeta(s) >= lower - 2e-13 && zeta(s) <= upper + 2e-13);
    assert.ok(zeta(s) > 1);
  }
});

check('Direct iteration matches all four closed forms, including k=0 and alpha=0', () => {
  for (const s of [1.25, 1.5, 2, 3, 4, 6]) {
    for (const alpha of [0, 0.08, 0.30]) {
      let values = { original: 1, cycle: 1, noroboro: 1, normalizedNoroboro: 1 };
      for (let k = 0; k <= 20; k++) {
        if (k) {
          values.original *= -zeta(s);
          values.cycle *= -1;
          values.noroboro *= -zeta(s)*Math.exp(alpha*k);
          values.normalizedNoroboro *= -Math.exp(alpha*k);
        }
        const p = predict(s, alpha, k);
        for (const key of Object.keys(values)) close(values[key], p.sign*Math.exp(p.logs[key]));
      }
    }
  }
});

check('Corrected cycle preserves both components of a complex state and closes after two steps', () => {
  for (const initial of [[2, -3], [-0.25, 4], [0, 0]]) {
    let [re, im] = initial;
    for (let k = 0; k < 20; k++) {
      const before = [re, im];
      re = -re; im = -im;
      close(Math.hypot(re, im), Math.hypot(...initial));
      re = -re; im = -im;
      close(re, before[0]); close(im, before[1]);
    }
  }
});

check('Original model fails two-step closure for nonzero data', () => {
  for (const s of [1.25, 2, 4, 6]) assert.ok(zeta(s)**2 > 1);
});

check('Zero remains zero in every model', () => {
  for (const k of [0, 1, 20]) {
    for (const value of Object.values(predict(2, 0.08, k).logs)) close(0*Math.exp(value), 0);
  }
});

check('Unsupported numerical domains are rejected', () => {
  for (const s of [1, 1.24, 6.01, NaN, Infinity]) assert.throws(() => zeta(s), RangeError);
  for (const k of [-1, 0.5, 21]) assert.throws(() => predict(2, 0.08, k), RangeError);
  for (const alpha of [-0.1, 0.31, NaN]) assert.throws(() => predict(2, alpha, 1), RangeError);
});

const report = {
  scope: 'Floating-point checks of discrete mathematical sequences; no physical validation or formal proof claimed.',
  numerical_domain: { s: [1.25, 6], alpha: [0, 0.30], integer_k: [0, 20] },
  source: 'scripts/verify.cjs',
  passed: results.length,
  failed: 0,
  checks: results
};
const output = path.resolve(__dirname, '../verification/results.json');
fs.mkdirSync(path.dirname(output), { recursive: true });
fs.writeFileSync(output, JSON.stringify(report, null, 2) + '\n');
process.stdout.write(`${results.length} verification groups passed. Results: verification/results.json\n`);
