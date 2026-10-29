/* Dev-only: pieces shared by several scenes. */
const { Grid, hash, domePaint } = require('./lib');

/* Ottoman minaret: pencil-shaped lead cone, white shaft, ring balconies. */
function minaret(g, cx, top, bottom, balconies) {
  g.set(cx, top, 'Y').set(cx, top + 1, 'y');
  g.vline(cx, top + 2, top + 4, 'L');
  for (let y = top + 5; y <= top + 7; y++) { g.set(cx - 1, y, 'L').set(cx, y, 'L').set(cx + 1, y, 'l'); }
  for (let y = top + 8; y < bottom; y++) { g.set(cx - 1, y, 'W').set(cx, y, 'W').set(cx + 1, y, 'w'); }
  for (const b of balconies) { g.hline(cx - 2, cx + 2, top + b, 'w'); g.set(cx - 2, top + b, 'W'); g.hline(cx - 1, cx + 1, top + b + 1, 'g'); }
}

function cypress(h) {
  const g = new Grid(3, h);
  for (let y = 0; y < h; y++) {
    const wide = y > 1 && y < h - 1;
    if (wide) { g.set(0, y, 'I'); g.set(1, y, 'I'); g.set(2, y, 'i'); } else g.set(1, y, 'I');
  }
  g.set(1, h - 1, 'X');
  return g;
}

function roundTree(w, h, seed) {
  const g = new Grid(w, h);
  g.ellipse(w / 2, (h - 2) / 2 + 0.2, w / 2, (h - 1) / 2, (dx, dy, x, y) =>
    dx + dy < -0.5 ? 'H' : dx + dy > 0.5 || hash(x, y, seed) % 4 === 0 ? 'f' : 'F');
  g.set(Math.floor(w / 2), h - 1, 'X'); g.set(Math.floor(w / 2), h - 2, 'X');
  return g;
}

/* Street lamp: lantern on a post. */
function lamp(h) {
  const g = new Grid(3, h);
  g.hline(0, 2, 0, 'D'); g.hline(0, 2, 1, 'Z'); g.hline(0, 2, 2, 'Z'); g.hline(0, 2, 3, 'D');
  g.vline(1, 4, h - 1, 'D'); g.hline(0, 2, h - 1, 'D');
  return g;
}

/* Stone quay with a railing along the front. */
function quay(w, h) {
  const g = new Grid(w, h);
  g.rect(0, 4, w - 1, h - 1, 'G');
  g.hline(0, w - 1, 4, 'W');
  for (let x = 0; x < w; x++) for (let y = 6; y < h; y++) if ((x + (y % 2) * 3) % 6 === 0 || y === 8) g.set(x, y, 'g');
  g.hline(0, w - 1, 0, 'D');
  for (let x = 0; x < w; x += 3) g.vline(x, 1, 3, 'D');
  return g;
}

module.exports = { minaret, cypress, roundTree, lamp, quay, Grid, hash, domePaint };

/* ---------- More shared pieces ---------- */

/* Coconut palm: hand-drawn crown on a curved trunk. lean > 0 bends right. */
const PALM_CROWNS = [
  [
    '......HH.HH......',
    '....HHFFHFFHH....',
    '..HHFFf.F.fFFHH..',
    '.HFFf..bXb..fFFH.',
    'HFf...FbXbF...fFH',
    'Ff...Ff.X.fF...fF',
    'f...Ff..X..fF...f',
    '...Ff...X...fF...',
    '...f....X....f...',
  ],
  [
    '....H.H....',
    '..HHFHFHH..',
    '.HFf.F.fFH.',
    'HFf.bXb.fFH',
    'Ff.Ff.fF.fF',
    'f.Ff.X.fF.f',
    '..f..X..f..',
  ],
];
function palm(h, lean, seed, crown = 0) {
  const top = PALM_CROWNS[crown], cw = top[0].length, ch = top.length;
  const W = cw + 4, g = new Grid(W, h + ch);
  const base = g.h - 1, cx0 = Math.floor(W / 2);
  const trunkX = y => Math.round(cx0 + lean * Math.pow((base - y) / (base - ch), 1.6) * 2.5);
  for (let y = ch; y <= base; y++) {
    const x = trunkX(y);
    g.set(x, y, y % 3 === 0 ? 'b' : 'X');
    if (y > base - 2) g.set(x + 1, y, 'b');
  }
  const cx = trunkX(ch);
  g.paste(top, cx - Math.floor(cw / 2), 0);
  return g.trim();
}

/* Spruce / pine: stacked tiers. */
function pine(h) {
  const w = Math.max(5, Math.round(h * 0.55) | 1), g = new Grid(w, h);
  const c = (w - 1) / 2;
  for (let y = 0; y < h - 1; y++) {
    const tier = (y % 3) / 3, half = Math.min(c, (y / (h - 1)) * c * 0.75 + tier * 1.6);
    for (let x = Math.ceil(c - half); x <= Math.floor(c + half); x++) g.set(x, y, x > c ? 'i' : 'I');
  }
  g.set(Math.round(c), h - 1, 'X');
  return g;
}

/* Birch: white trunk with dark marks, light round crown. */
function birch(h, seed) {
  const g = new Grid(7, h);
  g.ellipse(3.5, h * 0.33, 3.4, h * 0.33, (dx, dy, x, y) => dx + dy < -0.4 ? 'H' : hash(x, y, seed) % 3 === 0 ? 'F' : (dx > 0.3 ? 'F' : 'H'));
  for (let y = Math.round(h * 0.45); y < h; y++) g.set(3, y, y % 3 === 0 ? 'q' : 'Q');
  g.set(2, Math.round(h * 0.55), 'Q');
  return g;
}

/* Lombardy poplar: tall narrow crown. */
function poplar(h, seed) {
  const g = new Grid(5, h);
  g.ellipse(2.5, (h - 2) / 2, 2.3, (h - 2) / 2, (dx, dy, x, y) => dx > 0.25 ? 'f' : hash(x, y, seed) % 4 === 0 ? 'H' : 'F');
  g.vline(2, h - 2, h - 1, 'X');
  return g;
}

/* Onion dome: bulges and narrows to a tip. colors: [a, b, aShade, bShade]; b — spiral stripes (or null). */
function onion(g, cx, base, w, h, colors, finial = 'Y') {
  const [c1, c2, s1, s2] = colors;
  for (let y = 0; y < h; y++) {
    const u = y / (h - 1);
    const prof = u < 0.15 ? u / 0.15 * 0.25 : u < 0.7 ? 0.25 + (u - 0.15) / 0.55 * 0.75 : 1 - (u - 0.7) / 0.3 * 0.55;
    const half = Math.max(0, prof * w / 2);
    const yy = base - h + y;
    for (let x = Math.ceil(cx - half - 0.01); x <= Math.floor(cx + half); x++) {
      const stripe = c2 && ((x + y) % 4 + 4) % 4 < 2;
      const shaded = x > cx + half * 0.4;
      g.set(x, yy, stripe ? (shaded ? s2 || c2 : c2) : (shaded ? s1 || c1 : c1));
    }
  }
  if (finial) { g.set(Math.round(cx), base - h - 1, finial); g.set(Math.round(cx), base - h - 2, finial); }
}

/* Ribbed dome (Central Asia): turquoise with darker ribs. */
function ribbedDome(g, cx, base, r, mats = ['T', 't', 'V']) {
  g.dome(cx, base, r, (dx, dy, x) => {
    if (dx > r * 0.4) return mats[1];
    if (Math.round(x - cx + 0.5) % 2 === 0) return mats[1];
    if (mats[2] && dx < -r * 0.2 && dy < -r * 0.5) return mats[2];
    return mats[0];
  });
}

/* Mountain range: peaks [cx, top, halfWidth]; lit left flanks, shaded right, snow caps. */
function peaks(W, H, list, { rock = '1', shade = '2', snow = 'V', snowShade = 'w', snowDepth = 5, seed = 1 } = {}) {
  const g = new Grid(W, H);
  for (const [cx, top, half] of list) {
    for (let y = top; y < H; y++) {
      const k = (y - top) / (H - top);
      const j = (hash(y, cx, seed) % 3) - 1;
      const l = Math.round(cx - half * k + (y > top + 1 ? j * 0.6 : 0)), r = Math.round(cx + half * k * 1.05 - (y > top + 1 ? j * 0.6 : 0));
      for (let x = l; x <= r; x++) {
        const right = x > cx + (hash(x, y, seed + 1) % 2) - (y - top) * 0.15;
        let ch = right ? shade : rock;
        const snowLine = top + snowDepth + (hash(x, 0, seed) % 3);
        if (y < snowLine) ch = right ? snowShade : snow;
        g.set(x, y, ch);
      }
    }
  }
  return g;
}

/* Rolling hills: bumps [cx, top, halfWidth] filled with material pairs. */
function hills(W, H, list, mats = ['J', 'j']) {
  const g = new Grid(W, H);
  for (const [cx, top, half] of list) {
    for (let x = Math.floor(cx - half); x <= Math.ceil(cx + half); x++) {
      const d = (x - cx) / half;
      if (Math.abs(d) > 1) continue;
      const y0 = Math.round(top + (H - top) * d * d);
      for (let y = y0; y < H; y++) g.set(x, y, d > 0.35 ? mats[1] : mats[0]);
    }
  }
  return g;
}

/* Sailing yacht. */
function sailboat() {
  return Grid.from([
    '....W.....',
    '....WW....',
    '....WWW...',
    '...wWWWW..',
    '...wWWWWW.',
    '...wWWWWWW',
    '....D.....',
    'RRRRRRRRRR',
    '.WWWWWWWW.',
  ]);
}

module.exports = Object.assign(module.exports, { palm, pine, birch, poplar, onion, ribbedDome, peaks, hills, sailboat });

/* Central Asian minaret: banded brick, lantern gallery, small turquoise cap. */
function uzMinaret(h) {
  const g = new Grid(5, h);
  for (let y = 6; y < h; y++) {
    const band = y % 5 === 0 ? 'T' : y % 5 === 2 && y > 8 ? 'U' : null;
    g.set(1, y, band || 'S'); g.set(2, y, band || 'S'); g.set(3, y, band === 'T' ? 't' : band === 'U' ? 'u' : 's');
  }
  for (let y = h - 3; y < h; y++) { g.set(0, y, 'S'); g.set(4, y, 's'); }
  g.hline(0, 4, 3, 'T'); g.hline(0, 4, 4, 'S'); g.hline(0, 4, 5, 'S'); g.set(1, 4, 'D'); g.set(3, 4, 'D'); g.set(4, 4, 's'); g.set(4, 5, 's');
  g.hline(1, 3, 2, 'T'); g.set(3, 2, 't'); g.set(2, 1, 'T'); g.set(2, 0, 'Y');
  return g;
}

/* Hot-air balloon: striped envelope, basket on ropes. */
function balloon(w, h, colors) {
  const g = new Grid(w, h + 3);
  const cx = w / 2, cy = h * 0.45, rx = w / 2, ry = h * 0.45;
  for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
    const dx = (x + 0.5 - cx) / rx;
    const dy = (y + 0.5 - cy) / ry;
    const inside = y < cy ? dx * dx + dy * dy <= 1 : Math.abs(dx) <= 1 - Math.pow((y + 0.5 - cy) / (h - cy), 1.4) * 0.72;
    if (!inside) continue;
    const stripe = colors[Math.floor((x + 0.5) / w * colors.length * 0.999)];
    g.set(x, y, dx < -0.45 && dy < -0.2 ? 'V' : stripe);
  }
  const bx = Math.floor(cx) - 1;
  g.set(bx, h, 'D'); g.set(bx + 1, h, 'D');
  g.hline(bx, bx + 1, h + 1, 'b'); g.hline(bx, bx + 1, h + 2, 'b');
  return g.trim();
}

/* European town house: facade, window rows, roof. */
function townHouse(w, floors, wall, roof, seed, { mansard = false, chimney = true } = {}) {
  const roofH = mansard ? 3 : 2, h = floors * 3 + 1 + roofH + (chimney ? 1 : 0);
  const g = new Grid(w, h), top = h - floors * 3 - 1;
  g.rect(0, top, w - 1, h - 1, wall);
  for (let f = 0; f < floors; f++) for (let x = 1; x < w - 1; x += 2) {
    const y = top + 1 + f * 3;
    g.set(x, y, 'o'); g.set(x, y + 1, 'o');
    if (mansard && f > 0) g.set(x, y + 2, 'D');
  }
  if (mansard) {
    for (let i = 0; i < roofH; i++) g.hline(i === 0 ? 1 : 0, w - 1 - (i === 0 ? 1 : 0), top - roofH + i, i === roofH - 1 ? 'l' : 'L');
    for (let x = 2; x < w - 2; x += 3) g.set(x, top - 2, 'o');
  } else {
    for (let i = 0; i < roofH; i++) g.hline(roofH - 1 - i, w - 1 - (roofH - 1 - i), top - roofH + i, i === roofH - 1 ? roof.toLowerCase() : roof);
  }
  if (chimney) g.set(w - 3, top - roofH - 1, 'E');
  return g;
}

module.exports = Object.assign(module.exports, { uzMinaret, balloon, townHouse });

/* Camel walking right, two frames. */
const CAMEL = [
  [
    '....bb......',
    '...bBBb.....',
    '..bBBBBb..BB',
    '.bBBBBBBb.Bb',
    'bBBBBBBBBBB.',
    '.BBBBBBBBB..',
    '.B.B....B.B.',
    '.B.B....B.B.',
    '.b.b....b.b.',
  ],
  [
    '....bb......',
    '...bBBb.....',
    '..bBBBBb..BB',
    '.bBBBBBBb.Bb',
    'bBBBBBBBBBB.',
    '.BBBBBBBBB..',
    '..BB...BB...',
    '..B.B..B.B..',
    '..b..b.b..b.',
  ],
];

/* Sand dunes: crests [cx, top, halfWidth]; gentle sunny windward side on the left, steep shaded slip face. */
function dunes(W, H, crests, mats = ['A', 'a'], seed = 1) {
  const g = new Grid(W, H);
  const lowest = Math.max(...crests.map(c => c[1])) + 3;
  for (let x = 0; x < W; x++) for (let y = lowest; y < H; y++) g.set(x, y, mats[0]);
  for (const [cx, top, half] of crests) {
    for (let x = Math.floor(cx - half * 1.6); x <= Math.ceil(cx + half); x++) {
      const left = x <= cx;
      const d = left ? (cx - x) / (half * 1.6) : (x - cx) / half;
      if (d > 1) continue;
      const k = left ? d * d * (3 - 2 * d) : Math.pow(d, 0.75);
      const y0 = Math.round(top + (H - top) * k * 0.7);
      for (let y = y0; y < H; y++) {
        const shaded = !left && x > cx + (y - top) * 0.45;
        g.set(x, y, shaded ? mats[1] : mats[0]);
      }
      if (left && d > 0.15 && hash(x, top, seed) % 4 === 0) g.set(x, y0 + 2 + hash(x, 1, seed) % 3, mats[1]);
    }
  }
  return g;
}

module.exports = Object.assign(module.exports, { CAMEL, dunes });
