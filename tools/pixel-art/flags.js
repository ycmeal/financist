/* Dev-only: flags, 15×10, drawn by hand. */
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
flag('KZ', { b: 0x00AFCA, y: 0xFEC50C }, [
  'bybbbbbbybbbbbb',
  'bbbbbybbbbbybbb',
  'bybbbbbyyybbbbb',
  'bbbbbbyyyyybbbb',
  'bybbbbbyyybbbbb',
  'bbbbbybbbbbybbb',
  'bybbyybbybbyybb',
  'bbbbbyyyyyyybbb',
  'bybbbbbbybbbbbb',
  'bbbbbbbbbbbbbbb',
]);
flag('KG', { r: 0xE8112D, y: 0xFFEF00 }, [
  'rrrrrrrrrrrrrrr',
  'rrrrryrryrryrrr',
  'rrrrrryyyyyrrrr',
  'rrrryyrrrrryyrr',
  'rrrrryryryrrrrr',
  'rrrryyrrrrryyrr',
  'rrrrrryyyyyrrrr',
  'rrrrryrryrryrrr',
  'rrrrrrrrrrrrrrr',
  'rrrrrrrrrrrrrrr',
]);
flag('TJ', { r: 0xCC0000, w: 0xFFFFFF, g: 0x006600, y: 0xF8C300 }, [
  'rrrrrrrrrrrrrrr',
  'rrrrrrrrrrrrrrr',
  'rrrrrrrrrrrrrrr',
  'wwwwwywywywwwww',
  'wwwwywwwwwywwww',
  'wwwwwywywywwwww',
  'wwwwwyyyyywwwww',
  'ggggggggggggggg',
  'ggggggggggggggg',
  'ggggggggggggggg',
]);
flag('TM', { g: 0x00843D, r: 0xD22630, w: 0xFFFFFF, y: 0xFFC72C }, [
  'gryrgwgwgwggggg',
  'grwrggwgggggggg',
  'gryrgwgwggggggg',
  'grwrggggggggggg',
  'gryrggggggggggg',
  'grwrggggggggggg',
  'gryrggggggggggg',
  'grwrggggggggggg',
  'gryrggggggggggg',
  'grwrggggggggggg',
]);
flag('AZ', { b: 0x00B5E2, r: 0xEF3340, g: 0x509E2F, w: 0xFFFFFF }, [
  'bbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb', 'bbbbbbbbbbbbbbb',
  'rrrrrrwwrrrrrrr',
  'rrrrrwrrrwrrrrr',
  'rrrrrwrrwwwrrrr',
  'rrrrrrwwrwrrrrr',
  'ggggggggggggggg', 'ggggggggggggggg', 'ggggggggggggggg',
]);
flag('GE', { w: 0xFFFFFF, r: 0xFF0000 }, [
  'wwwwwwrrrwwwwww',
  'wwrwwwrrrwwwrww',
  'wrrrwwrrrwwrrrw',
  'wwrwwwrrrwwwrww',
  'rrrrrrrrrrrrrrr',
  'rrrrrrrrrrrrrrr',
  'wwrwwwrrrwwwrww',
  'wrrrwwrrrwwrrrw',
  'wwrwwwrrrwwwrww',
  'wwwwwwrrrwwwwww',
]);
F('AM', { r: 0xD90012, b: 0x0033A0, o: 0xF2A800 }, a => a.hs([['r', 3], ['b', 4], ['o', 3]]));
flag('BY', { r: 0xC8313E, g: 0x4AA657, w: 0xFFFFFF }, [
  'wrwrrrrrrrrrrrr',
  'rwrrrrrrrrrrrrr',
  'wrwrrrrrrrrrrrr',
  'rwrrrrrrrrrrrrr',
  'wrwrrrrrrrrrrrr',
  'rwrrrrrrrrrrrrr',
  'wrwrrrrrrrrrrrr',
  'rwrgggggggggggg',
  'wrwgggggggggggg',
  'rwrgggggggggggg',
]);
F('UA', { b: 0x0057B7, y: 0xFFD700 }, a => a.hs([['b', 5], ['y', 5]]));
F('MD', { b: 0x0046AE, y: 0xFFD200, r: 0xCC092F, e: 0xA05A2C }, a => {
  a.vs([['b', 5], ['y', 5], ['r', 5]]);
  a.at(5, 3, ['e.e.e', 'eeeee', '.eye.', '..e..']);
});
F('DE', { k: 0x000000, r: 0xDD0000, y: 0xFFCE00 }, a => a.hs(tri('k', 'r').map(([c, n], i) => [['k', 'r', 'y'][i], n])));
F('FR', { b: 0x0055A4, w: 0xFFFFFF, r: 0xEF4135 }, a => a.vs([['b', 5], ['w', 5], ['r', 5]]));
F('IT', { g: 0x009246, w: 0xFFFFFF, r: 0xCE2B37 }, a => a.vs([['g', 5], ['w', 5], ['r', 5]]));
F('ES', { r: 0xAA151B, y: 0xF1BF00, e: 0xC8102E, o: 0xAD1519 }, a => {
  a.hs([['r', 2], ['y', 6], ['r', 2]]);
  a.at(3, 3, ['oyo', 'eye', 'ooo', '.o.']);
});
F('PT', { g: 0x006600, r: 0xFF0000, y: 0xFFE000, w: 0xFFFFFF, b: 0x003399 }, a => {
  a.vs([['g', 6], ['r', 9]]);
  a.at(4, 2, ['.yyy.', 'yrwry', 'ywbwy', 'yrwry', '.yyy.']);
});
F('GR', { b: 0x0D5EAF, w: 0xFFFFFF }, a => {
  for (let y = 0; y < H; y++) a.g.hline(0, W - 1, y, y % 2 ? 'w' : 'b');
  a.g.rect(0, 0, 4, 4, 'b'); a.g.vline(2, 0, 4, 'w'); a.g.hline(0, 4, 2, 'w');
});
F('CY', { w: 0xFFFFFF, o: 0xD57800, g: 0x4E5B31 }, a => {
  a.fill('w');
  a.at(4, 2, ['....oooo', '.oooooooo', 'oooooooo.', '..ooo....'].map(r => r.padEnd(9, '.')));
  a.at(5, 6, ['g.....g', '.ggggg.']);
});
F('AT', { r: 0xED2939, w: 0xFFFFFF }, a => a.hs(tri('r', 'w')));
F('NL', { r: 0xAE1C28, w: 0xFFFFFF, b: 0x21468B }, a => a.hs([['r', 3], ['w', 4], ['b', 3]]));
F('BE', { k: 0x000000, y: 0xFAE042, r: 0xED2939 }, a => a.vs([['k', 5], ['y', 5], ['r', 5]]));
F('IE', { g: 0x169B62, w: 0xFFFFFF, o: 0xFF883E }, a => a.vs([['g', 5], ['w', 5], ['o', 5]]));
const nordic = (bg, cross, inner) => a => {
  a.fill(bg);
  if (inner) { a.g.rect(4, 0, 7, H - 1, cross); a.g.rect(0, 3, W - 1, 6, cross); a.g.rect(5, 0, 6, H - 1, inner); a.g.rect(0, 4, W - 1, 5, inner); }
  else { a.g.rect(4, 0, 5, H - 1, cross); a.g.rect(0, 4, W - 1, 5, cross); }
};
F('FI', { w: 0xFFFFFF, b: 0x003580 }, nordic('w', 'b'));
F('SE', { b: 0x006AA7, y: 0xFECC00 }, nordic('b', 'y'));
F('DK', { r: 0xC8102E, w: 0xFFFFFF }, nordic('r', 'w'));
F('NO', { r: 0xBA0C2F, w: 0xFFFFFF, b: 0x00205B }, nordic('r', 'w', 'b'));
F('EE', { b: 0x0072CE, k: 0x000000, w: 0xFFFFFF }, a => a.hs([['b', 3], ['k', 4], ['w', 3]]));
F('LV', { r: 0x9E3039, w: 0xFFFFFF }, a => a.hs([['r', 4], ['w', 2], ['r', 4]]));
F('LT', { y: 0xFDB913, g: 0x006A44, r: 0xC1272D }, a => a.hs([['y', 3], ['g', 4], ['r', 3]]));
F('SK', { w: 0xFFFFFF, b: 0x0B4EA2, r: 0xEE1C25 }, a => {
  a.hs([['w', 3], ['b', 4], ['r', 3]]);
  a.at(2, 1, ['wwwww', 'wrwrw', 'wwwww', 'wrwrw', 'wbbbw', 'wbbbw', '.www.']);
});
F('SI', { w: 0xFFFFFF, b: 0x005DA4, r: 0xED1C24, y: 0xFFDD00 }, a => {
  a.hs([['w', 3], ['b', 4], ['r', 3]]);
  a.at(2, 1, ['ryyr', 'rbbr', 'rwbr', 'wwwr', '.rr.']);
});
F('HR', { r: 0xFF0000, w: 0xFFFFFF, b: 0x171796 }, a => {
  a.hs([['r', 3], ['w', 4], ['b', 3]]);
  a.at(5, 2, ['bbbbb', 'rwrwr', 'wrwrw', 'rwrwr', 'wrwrw', '.rwr.']);
});
F('ME', { r: 0xC40308, y: 0xD4AF37 }, a => {
  a.fill('r'); a.g.rect(0, 0, W - 1, 0, 'y'); a.g.rect(0, H - 1, W - 1, H - 1, 'y'); a.g.vline(0, 0, H - 1, 'y'); a.g.vline(W - 1, 0, H - 1, 'y');
  a.at(5, 2, ['y.y.y', 'yyyyy', '.yyy.', 'yyyyy', '.y.y.']);
});
F('MT', { w: 0xFFFFFF, r: 0xCF142B, g: 0x9EA2A2 }, a => { a.vs([['w', 7], ['r', 8]]); a.at(1, 1, ['.g.', 'ggg', '.g.']); });
F('GB', { b: 0x012169, w: 0xFFFFFF, r: 0xC8102E }, a => {
  a.fill('b');
  for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
    const t1 = y - x * (H - 1) / (W - 1), t2 = y - (W - 1 - x) * (H - 1) / (W - 1);
    const left = x < W / 2, top = y < H / 2;
    if (Math.abs(t1) < 1.05) a.g.set(x, y, Math.abs(t1) < 0.5 && (left === top) && ((left && t1 > -0.05) || (!left && t1 < 0.05)) ? 'r' : 'w');
    if (Math.abs(t2) < 1.05) a.g.set(x, y, Math.abs(t2) < 0.5 && (left !== top) && ((!left && t2 > -0.05) || (left && t2 < 0.05)) ? 'r' : 'w');
  }
  a.g.rect(6, 0, 8, H - 1, 'w'); a.g.rect(0, 3, W - 1, 6, 'w');
  a.g.vline(7, 0, H - 1, 'r'); a.g.rect(0, 4, W - 1, 5, 'r');
});
F('CH', { r: 0xDA291C, w: 0xFFFFFF }, a => { a.fill('r'); a.g.rect(6, 2, 8, 7, 'w'); a.g.rect(4, 4, 10, 5, 'w'); });
F('CZ', { w: 0xFFFFFF, r: 0xD7141A, b: 0x11457E }, a => {
  a.hs([['w', 5], ['r', 5]]);
  for (let y = 0; y < H; y++) { const len = Math.round(7 * (1 - Math.abs(y - 4.5) / 5)); a.g.hline(0, len, y, 'b'); }
});
F('PL', { w: 0xFFFFFF, r: 0xDC143C }, a => a.hs([['w', 5], ['r', 5]]));
F('HU', { r: 0xCE2939, w: 0xFFFFFF, g: 0x477050 }, a => a.hs([['r', 3], ['w', 4], ['g', 3]]));
F('RS', { r: 0xC6363C, b: 0x0C4076, w: 0xFFFFFF, y: 0xEDB92E }, a => {
  a.hs([['r', 3], ['b', 4], ['w', 3]]);
  a.at(3, 1, ['.yyy.', 'ryyyr', 'rwrwr', 'rwwwr', 'rrwrr', '.rrr.']);
});
F('BG', { w: 0xFFFFFF, g: 0x00966E, r: 0xD62612 }, a => a.hs([['w', 3], ['g', 4], ['r', 3]]));
F('RO', { b: 0x002B7F, y: 0xFCD116, r: 0xCE1126 }, a => a.vs([['b', 5], ['y', 5], ['r', 5]]));
F('IL', { w: 0xFFFFFF, b: 0x0038B8 }, a => {
  a.fill('w'); a.g.hline(0, W - 1, 1, 'b'); a.g.hline(0, W - 1, 8, 'b');
  a.at(5, 3, ['..b..', 'bbbbb', '.b.b.', 'bbbbb', '..b..'].map(r => r));
});
F('EG', { r: 0xCE1126, w: 0xFFFFFF, k: 0x000000, y: 0xC09300 }, a => { a.hs([['r', 3], ['w', 4], ['k', 3]]); a.at(6, 4, ['y.y', 'yyy']); });
F('JO', { k: 0x000000, w: 0xFFFFFF, g: 0x007A3D, r: 0xCE1126 }, a => {
  a.hs([['k', 3], ['w', 4], ['g', 3]]);
  for (let y = 0; y < H; y++) { const len = Math.round(6 * (1 - Math.abs(y - 4.5) / 5)); a.g.hline(0, len, y, 'r'); }
  a.at(1, 4, ['w', 'w']);
});
F('QA', { w: 0xFFFFFF, m: 0x8A1538 }, a => { a.vs([['w', 4], ['m', 11]]); for (let y = 0; y < H; y++) a.g.set(4, y, y % 2 ? 'm' : 'w'); });
F('SA', { g: 0x006C35, w: 0xFFFFFF }, a => {
  a.fill('g');
  a.at(3, 2, ['w.ww.w.www', 'wwwwwwwww.', '..........', '..........', 'wwwwwwwww.', '.w........'].map(r => r.replace(/\./g, 'g')));
});
F('OM', { r: 0xDB161B, w: 0xFFFFFF, g: 0x008000 }, a => {
  a.hs([['w', 3], ['r', 4], ['g', 3]]); a.g.rect(0, 0, 3, H - 1, 'r'); a.at(1, 1, ['w.w', '.w.']);
});
F('BH', { w: 0xFFFFFF, r: 0xCE1126 }, a => { a.vs([['w', 4], ['r', 11]]); for (let y = 0; y < H; y++) a.g.set(4, y, y % 2 ? 'r' : 'w'); });
F('KW', { g: 0x007A3D, w: 0xFFFFFF, r: 0xCE1126, k: 0x000000 }, a => {
  a.hs([['g', 3], ['w', 4], ['r', 3]]);
  for (let y = 0; y < H; y++) a.g.hline(0, y < 3 ? 1 + y : y > 6 ? 1 + (H - 1 - y) : 4, y, 'k');
});
F('IN', { o: 0xFF9933, w: 0xFFFFFF, g: 0x138808, n: 0x000080 }, a => { a.hs([['o', 3], ['w', 4], ['g', 3]]); a.at(6, 3, ['nnn', 'nwn', 'nnn']); });
F('LK', { y: 0xFFBE29, g: 0x00534E, o: 0xEB7400, m: 0x8D153A }, a => {
  a.fill('y'); a.g.rect(1, 1, 2, 8, 'g'); a.g.rect(3, 1, 4, 8, 'o'); a.g.rect(6, 1, 13, 8, 'm');
  a.at(8, 3, ['yy.y', 'yyyy', '.yy.', 'y..y']);
});
F('MV', { r: 0xD21034, g: 0x007E3A, w: 0xFFFFFF }, a => { a.fill('r'); a.g.rect(3, 2, 11, 7, 'g'); a.at(6, 3, ['.ww', 'w..', 'w..', '.ww']); });
F('TH', { r: 0xA51931, w: 0xF4F5F8, b: 0x2D2A4A }, a => a.hs([['r', 2], ['w', 1], ['b', 4], ['w', 1], ['r', 2]]));
F('VN', { r: 0xDA251D, y: 0xFFFF00 }, a => { a.fill('r'); a.at(5, 3, ['..y..', 'yyyyy', '.yyy.', '.y.y.']); });
F('ID', { r: 0xFF0000, w: 0xFFFFFF }, a => a.hs([['r', 5], ['w', 5]]));
F('MY', { r: 0xCC0001, w: 0xFFFFFF, n: 0x010066, y: 0xFFCC00 }, a => {
  for (let y = 0; y < H; y++) a.g.hline(0, W - 1, y, y % 2 ? 'w' : 'r');
  a.g.rect(0, 0, 6, 5, 'n'); a.at(1, 1, ['.yy..', 'y...y', 'y..yy', '.yy..']);
});
F('SG', { r: 0xEF3340, w: 0xFFFFFF }, a => { a.hs([['r', 5], ['w', 5]]); a.at(1, 1, ['.ww.w.', 'w...ww', '.ww.w.']); });
F('CN', { r: 0xEE1C25, y: 0xFFFF00 }, a => { a.fill('r'); a.at(1, 1, ['.y..y', 'yyy..', '.y..y', 'y.y.y']); });
F('JP', { w: 0xFFFFFF, r: 0xBC002D }, a => { a.fill('w'); a.at(5, 2, ['.rrr.', 'rrrrr', 'rrrrr', 'rrrrr', '.rrr.'].map(r => r.replace(/\./g, 'w')).concat([]).slice(0, 5)); a.g.set(5, 2, 'w'); });
F('KR', { w: 0xFFFFFF, r: 0xCD2E3A, b: 0x0047A0, k: 0x000000 }, a => {
  a.fill('w'); a.at(5, 3, ['.rrr.', 'rrrrb', 'rbbbb', '.bbb.'].map(r => r.replace(/\./g, 'w')));
  a.at(1, 1, ['kk', 'k.', '.k'].map(r => r.replace(/\./g, 'w'))); a.at(12, 1, ['kk', '.k', 'k.'].map(r => r.replace(/\./g, 'w')));
  a.at(1, 6, ['.k', 'k.', 'kk'].map(r => r.replace(/\./g, 'w'))); a.at(12, 6, ['k.', '.k', 'kk'].map(r => r.replace(/\./g, 'w')));
});
F('MN', { r: 0xC4272F, b: 0x015197, y: 0xF9CF02 }, a => { a.vs([['r', 5], ['b', 5], ['r', 5]]); a.at(2, 1, ['y', 'y', 'y', 'y', 'y', 'y', 'y', 'y']); a.at(1, 3, ['y.y', '...', 'y.y']); });
F('CA', { r: 0xFF0000, w: 0xFFFFFF }, a => {
  a.vs([['r', 4], ['w', 7], ['r', 4]]);
  a.at(5, 2, ['..r..', 'r.r.r', 'rrrrr', '.rrr.', 'rrrrr', '..r..'].map(r => r.replace(/\./g, 'w')));
});
F('MX', { g: 0x006847, w: 0xFFFFFF, r: 0xCE1126, b: 0x8C5A2B }, a => { a.vs([['g', 5], ['w', 5], ['r', 5]]); a.at(6, 3, ['.b.', 'bbb', 'gbg', '.g.']); a.g.set(6, 3, 'w'); a.g.set(8, 3, 'w'); a.g.set(6, 6, 'w'); a.g.set(8, 6, 'w'); });
F('MA', { r: 0xC1272D, g: 0x006233 }, a => { a.fill('r'); a.at(5, 2, ['..g..', 'ggggg', '.g.g.', '.ggg.', 'g...g']); for (const [x, y] of [[5, 2], [6, 2], [8, 2], [9, 2], [5, 4], [7, 4], [9, 4], [5, 5], [9, 5], [6, 6], [7, 6], [8, 6]]) if (a.g.get(x, y) !== 'g') a.g.set(x, y, 'r'); });
F('TN', { r: 0xE70013, w: 0xFFFFFF }, a => { a.fill('r'); a.at(5, 2, ['.www.', 'wwrrw', 'wrwwr', 'wwrrw', '.www.'].map(r => r.replace(/\./g, 'r'))); });

module.exports = { FLAGS, flag };
