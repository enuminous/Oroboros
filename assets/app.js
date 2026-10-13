'use strict';
(function () {
  const math = window.OroborosMath;
  const exponent = document.getElementById('exponent');
  const alpha = document.getElementById('alpha');
  const content = document.getElementById('chart-content');
  const ns = 'http://www.w3.org/2000/svg';
  const series = [
    { key: 'noroboro', color: '#ff9b84', dash: '', label: 'Original Noroboro' },
    { key: 'original', color: '#8cc3ff', dash: '', label: 'Original Ouroboros' },
    { key: 'normalizedNoroboro', color: '#85d6c5', dash: '9 5', label: 'Normalized Noroboro' },
    { key: 'cycle', color: '#ead19a', dash: '5 5', label: 'Normalized Ouroboros' }
  ];
  function element(tag, attributes, text) {
    const el = document.createElementNS(ns, tag);
    Object.entries(attributes || {}).forEach(([key, value]) => el.setAttribute(key, value));
    if (text !== undefined) el.textContent = text;
    content.appendChild(el);
    return el;
  }
  function format(value) {
    return Math.abs(value) >= 100000 ? value.toExponential(3) : value.toLocaleString('en-US', { maximumFractionDigits: 4 });
  }
  function render() {
    const s = Number(exponent.value), a = Number(alpha.value);
    const points = Array.from({ length: 21 }, (_, k) => math.predict(s, a, k));
    document.getElementById('exponent-value').textContent = s.toFixed(2);
    document.getElementById('alpha-value').textContent = a.toFixed(2);
    document.getElementById('zeta-value').textContent = points[0].zeta.toFixed(6);
    const max = Math.max(1, points[20].logs.noroboro * 1.08);
    const left = 66, right = 937, top = 30, bottom = 340;
    const x = k => left + k * (right-left) / 20;
    const y = value => bottom - value * (bottom-top) / max;
    content.replaceChildren();
    for (let j = 0; j <= 4; j++) {
      const value = max * j / 4;
      element('line', { x1: left, x2: right, y1: y(value), y2: y(value), stroke: '#354346', 'stroke-width': 1 });
      element('text', { x: left-12, y: y(value)+4, 'text-anchor': 'end' }, value.toFixed(1));
    }
    for (let k = 0; k <= 20; k += 5) element('text', { x: x(k), y: bottom+25, 'text-anchor': 'middle' }, String(k));
    element('text', { x: left, y: 16, class: 'axis-label' }, 'ln(relative magnitude)');
    element('text', { x: (left+right)/2, y: 390, 'text-anchor': 'middle', class: 'axis-label' }, 'Integer step k');
    for (const line of series) {
      element('polyline', { points: points.map((p,k) => `${x(k)},${y(p.logs[line.key])}`).join(' '), fill: 'none', stroke: line.color, 'stroke-width': 2.7, 'stroke-dasharray': line.dash, 'stroke-linejoin': 'round' });
      for (let k = 0; k <= 20; k++) element('circle', { cx: x(k), cy: y(points[k].logs[line.key]), r: k%5 === 0 ? 3.3 : 1.8, fill: line.color });
    }
    const final = points[20];
    document.getElementById('chart-summary').textContent = `At step 20: original Ouroboros log magnitude ${final.logs.original.toFixed(2)}; normalized cycle 0.00; original Noroboro ${final.logs.noroboro.toFixed(2)}; normalized Noroboro ${final.logs.normalizedNoroboro.toFixed(2)}. At α = 0, each Noroboro curve coincides with its corresponding Ouroboros curve.`;
    document.getElementById('chart-description').textContent = `For s=${s.toFixed(2)} and alpha=${a.toFixed(2)}, log magnitudes across steps zero to twenty. Original Ouroboros ends at ${final.logs.original.toFixed(2)}, normalized Ouroboros remains at zero, original Noroboro ends at ${final.logs.noroboro.toFixed(2)}, normalized Noroboro ends at ${final.logs.normalizedNoroboro.toFixed(2)}.`;
    const body = document.getElementById('step-table');
    body.replaceChildren();
    for (let k=0; k<=5; k++) {
      const p = points[k];
      const row = document.createElement('tr');
      for (const value of [k, ...['original','cycle','noroboro','normalizedNoroboro'].map(key => p.sign * Math.exp(p.logs[key]))]) {
        const cell = document.createElement('td'); cell.textContent = format(value); row.appendChild(cell);
      }
      body.appendChild(row);
    }
  }
  exponent.addEventListener('input', render);
  alpha.addEventListener('input', render);
  render();
})();
