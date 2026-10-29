const fs = require('fs');
const src = fs.readFileSync(__dirname + '/data.js', 'utf8') + fs.readFileSync(__dirname + '/runtime.js', 'utf8');
const PixelCity = new Function(src + '\nreturn PixelCity;')();
const seed = code => [...(code || 'XX')].reduce((s, ch) => s * 31 + ch.charCodeAt(0), 7);
function fnv(px) { let h = 0x811c9dc5 >>> 0; for (const v of px) { for (const b of [v >>> 16 & 255, v >>> 8 & 255, v & 255]) { h ^= b; h = Math.imul(h, 0x01000193) >>> 0; } } return h >>> 0; }
console.log('hash', PixelCity.hash(0, 0, 0), PixelCity.hash(5, 7, 9413), PixelCity.hash(63, 55, 20261029), PixelCity.hash(2, 3, -77));
const cases = [
  ['istanbul', 'day', 0.5, 'TR', 1234.5, 'TR'],
  ['moscow', 'night', null, 'RU', 40000.25, 'RU'],
  ['dubai', 'dusk', 0.93, 'AE', 63000, 'AE'],
  ['paris', 'night', null, 'EU', 75610, 'EU'],
  ['cappadocia', 'dawn', 0.07, 'TR', 25000, 'TR'],
  ['desert', 'day', 0.3, 'AE', 50000.75, 'AE'],
  ['village', 'dusk', 0.85, 'RU', 66000.5, 'RU'],
  ['tropic', 'day', 0.6, 'TH', 45000, 'TH'],
  ['mountains', 'night', null, 'KZ', 3600, 'KZ'],
  ['samarkand', 'dawn', 0.15, 'UZ', 26000, 'UZ'],
  ['khiva', 'day', 0.45, 'UZ', 43000, 'UZ'],
  ['coast', 'dawn', 0.12, 'EU', 24000, 'EU'],
  ['alps', 'day', 0.7, 'CH', 52000, 'CH'],
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
