const fs = require('fs');
const src = fs.readFileSync(__dirname + '/data.js', 'utf8') + fs.readFileSync(__dirname + '/runtime.js', 'utf8');
const PixelCity = new Function(src + '\nreturn PixelCity;')();
const seed = code => [...(code || 'XX')].reduce((s, ch) => s * 31 + ch.charCodeAt(0), 7);
function fnv(px) { let h = 0x811c9dc5 >>> 0; for (const v of px) { for (const b of [v >>> 16 & 255, v >>> 8 & 255, v & 255]) { h ^= b; h = Math.imul(h, 0x01000193) >>> 0; } } return h >>> 0; }
console.log('hash', PixelCity.hash(0, 0, 0), PixelCity.hash(5, 7, 9413), PixelCity.hash(63, 55, 20261029), PixelCity.hash(2, 3, -77));
const cases = [
  ['istanbul', 'day', 0.5, 'TR', 1234.5, 'TR'],
  ['cappadocia', 'dawn', 0.07, 'TR', 25000, 'TR'],
  ['galata', 'night', null, 'TR', 2000.75, 'TR'],
  ['pamukkale', 'dusk', 0.86, 'TR', 65000, 'TR'],
  ['oludeniz', 'day', 0.55, 'TR', 47000.5, 'TR'],
  ['ephesus', 'day', 0.4, 'TR', 41000, 'TR'],
  ['uzungol', 'night', null, 'TR', 82000, 'TR'],
  ['samarkand', 'dawn', 0.15, 'UZ', 26000, 'UZ'],
  ['khiva', 'day', 0.45, 'UZ', 43000, 'UZ'],
  ['bukhara', 'dawn', 0.1, 'UZ', 24500, 'UZ'],
  ['guremir', 'day', 0.65, 'UZ', 51000.25, 'UZ'],
  ['tashkent', 'night', null, 'UZ', 79000, 'UZ'],
  ['chimgan', 'day', 0.3, 'UZ', 37000, 'UZ'],
  ['bazaar', 'dusk', 0.9, 'UZ', 67000, 'UZ'],
  ['dubai', 'dusk', 0.93, 'AE', 63000, 'AE'],
  ['desert', 'day', 0.3, 'AE', 50000.75, 'AE'],
  ['moscow', 'night', null, 'RU', 40000.25, 'RU'],
  ['village', 'dusk', 0.85, 'RU', 66000.5, 'RU'],
  ['paris', 'night', null, 'EU', 75610, 'EU'],
  ['coast', 'dawn', 0.12, 'EU', 24000, 'EU'],
  ['newyork', 'night', null, 'US', 80000, 'US'],
  ['city', 'day', 0.5, null, 40000, null],
];
for (const [scene, part, sun, flag, t, s] of cases) {
  const px = PixelCity.render(scene, part, sun, flag ? PixelCity.flagPixels(flag) : null, t, seed(s));
  console.log(`(${JSON.stringify(scene)}, .${part}, ${sun === null ? 'nil' : sun}, ${flag ? JSON.stringify(flag) : 'nil'}, ${t}, ${s ? JSON.stringify(s) : 'nil'}, ${fnv(px)}),`);
}
// Spot pixels for a readable failure.
const px = PixelCity.render('istanbul', 'day', 0.5, PixelCity.flagPixels('TR'), 1234.5, seed('TR'));
console.log('spot', [[0, 0], [72, 30], [6, 52], [70, 50], [20, 70]].map(([x, y]) => `(${x}, ${y}): 0x${px[y * 96 + x].toString(16).toUpperCase().padStart(6, '0')}`).join(', '));
