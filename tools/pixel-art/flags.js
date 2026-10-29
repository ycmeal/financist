/* Dev-only: flags, 15×10, drawn by hand — only the countries whose currencies the app has. */
const { Grid } = require('./lib');
const FLAGS = {};
const W = 15, H = 10;

function flag(code, colors, rows) {
  if (rows.length !== H || rows.some(r => r.length !== W)) throw new Error(`flag ${code}: ${rows.map(r => r.length)}`);
  for (const r of rows) for (const ch of r) if (colors[ch] === undefined) throw new Error(`flag ${code}: no color for ${ch}`);
  FLAGS[code] = { colors, rows };
}
/* Build with a grid: hs/vs — stripes [[char, size], …]; then emblems on top. */
function F(code, colors, build) {
  const g = new Grid(W, H, '?');
  const api = {
    g,
    hs: list => { let y = 0; for (const [c, n] of list) { g.rect(0, y, W - 1, y + n - 1, c); y += n; } },
    vs: list => { let x = 0; for (const [c, n] of list) { g.rect(x, 0, x + n - 1, H - 1, c); x += n; } },
    at: (x, y, rows) => g.paste(rows, x, y),
    fill: c => g.rect(0, 0, W - 1, H - 1, c),
  };
  build(api);
  flag(code, colors, g.rows());
}
const tri = (h, v) => [[h, 3], [v, 4], [h, 3]];

flag('TR', { r: 0xE30A17, w: 0xFFFFFF }, [
  'rrrrrrrrrrrrrrr',
  'rrrrwwwrrrrrrrr',
  'rrrwwrrrrrrrrrr',
  'rrwwrrrrrrwrrrr',
  'rrwwrrrrrwwwrrr',
  'rrwwrrrrrwrwrrr',
  'rrrwwrrrrrrrrrr',
  'rrrrwwwrrrrrrrr',
  'rrrrrrrrrrrrrrr',
  'rrrrrrrrrrrrrrr',
]);
F('RU', { w: 0xFFFFFF, b: 0x0039A6, r: 0xD52B1E }, a => a.hs([['w', 3], ['b', 4], ['r', 3]]));
flag('UZ', { b: 0x0099B5, w: 0xFFFFFF, g: 0x1EB53A, r: 0xCE1126 }, [
  'bwwbbbbwbwbbbbb',
  'wbbbbbwbwbwbbbb',
  'bwwbbwbwbwbbbbb',
  'rrrrrrrrrrrrrrr',
  'wwwwwwwwwwwwwww',
  'wwwwwwwwwwwwwww',
  'rrrrrrrrrrrrrrr',
  'ggggggggggggggg',
  'ggggggggggggggg',
  'ggggggggggggggg',
]);
F('AE', { r: 0xEF3340, g: 0x009739, w: 0xFFFFFF, k: 0x000000 }, a => { a.hs([['g', 3], ['w', 4], ['k', 3]]); a.g.rect(0, 0, 3, 9, 'r'); });
flag('EU', { b: 0x003399, y: 0xFFCC00 }, [
  'bbbbbbbbbbbbbbb',
  'bbbbbybybybbbbb',
  'bbbybbbbbbbybbb',
  'bbbbbbbbbbbbbbb',
  'bbybbbbbbbbbybb',
  'bbbbbbbbbbbbbbb',
  'bbbybbbbbbbybbb',
  'bbbbbybybybbbbb',
  'bbbbbbbbbbbbbbb',
  'bbbbbbbbbbbbbbb',
]);
F('US', { r: 0xB22234, w: 0xFFFFFF, n: 0x3C3B6E }, a => {
  for (let y = 0; y < H; y++) a.g.hline(0, W - 1, y, y % 2 ? 'w' : 'r');
  a.g.rect(0, 0, 5, 4, 'n');
  for (let y = 0; y < 5; y++) for (let x = (y % 2 ? 2 : 1); x < 6; x += 2) a.g.set(x, y, 'w');
});

module.exports = { FLAGS, flag };
