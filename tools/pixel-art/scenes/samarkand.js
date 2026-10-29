/* Samarkand: the Registan — a tiled portal, Central Asian minarets, ribbed turquoise domes. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, ribbedDome, poplar, peaks, uzMinaret } = P;

  function pishtaq(W, H) {
    const g = new Grid(W, H), C = (W - 1) / 2;
    g.rect(0, 0, W - 1, H - 1, 'S'); g.vline(W - 1, 0, H - 1, 's');
    g.hline(1, W - 2, 1, 'T'); g.vline(1, 1, H - 1, 'T'); g.vline(W - 2, 1, H - 1, 't');
    g.hline(2, W - 3, 3, 'U'); for (let x = 3; x < W - 3; x += 2) g.set(x, 3, 'W');
    const nx0 = 4, nx1 = W - 5, top = 6, halfMax = (nx1 - nx0) / 2;
    for (let y = top; y < H; y++) {
      const k = y - top, half = k < 4 ? [0.5, 1.6, 3, 4.3][k] : halfMax;
      for (let x = Math.ceil(C - half); x <= Math.floor(C + half); x++) g.set(x, y, 'U');
    }
    for (let y = top + 6; y < H - 1; y += 3) for (let x = nx0 + 1; x <= nx1 - 1; x += 2) g.set(x + (y % 2), y, 'T');
    for (let y = top + 3; y < H; y++) { g.set(nx0, y, 'u'); g.set(nx1, y, 'u'); }
    g.rect(C - 2, H - 8, C + 2, H - 1, 'D'); g.hline(C - 1, C + 1, H - 9, 'D');
    g.set(C - 1, H - 13, 'o'); g.set(C + 1, H - 13, 'o'); g.set(C, H - 14, 'o');
    for (const x of [2, W - 3]) for (let y = 6; y < H - 2; y += 4) g.set(x, y, 'U');
    return g;
  }

  function wing(W, H, seed) {
    const g = new Grid(W, H);
    g.rect(0, 0, W - 1, H - 1, 'S'); g.hline(0, W - 1, 0, 'T'); g.hline(0, W - 1, 1, 'S');
    for (let x = 1; x + 2 < W; x += 4) {
      for (const [y0, y1] of [[3, 7], [10, H - 1]]) {
        g.set(x + 1, y0, 'U'); g.rect(x, y0 + 1, x + 2, y1, 'U');
        g.set(x + 1, y1 - 1, hash(x, y0, seed) % 2 ? 'o' : 'u');
      }
    }
    return g;
  }

  function domeOnDrum(r, drumH, mats) {
    const W = Math.ceil(r * 2) + 2, g = new Grid(W, Math.ceil(r) + drumH + 2), cx = W / 2;
    const base = g.h - drumH;
    g.rect(1, base, W - 2, g.h - 1, 'S'); g.vline(W - 2, base, g.h - 1, 's');
    g.hline(1, W - 2, base, 'U'); for (let x = 2; x < W - 2; x += 2) g.set(x, base, 'W');
    g.hline(1, W - 2, base + 1, 'T');
    for (let x = 2; x < W - 2; x += 3) g.vline(x, base + 3, g.h - 2, 'U');
    ribbedDome(g, cx, base, r, mats);
    g.set(Math.floor(cx), base - Math.ceil(r) - 1, 'Y');
    return g;
  }

  function registan() {
    const W = 50, H = 40, g = new Grid(W, H);
    g.place(domeOnDrum(6.5, 9, ['T', 't', 'V']), 0, H - 6);
    g.place(wing(14, 16, 3), 3, H);
    g.place(uzMinaret(40), 14, H);
    g.place(pishtaq(21, 34), 18, H);
    g.place(uzMinaret(40), 38, H);
    g.place(domeOnDrum(4.2, 4, ['T', 't', 'V']), 40, H - 14);
    g.place(wing(10, 16, 7), 42, H);
    return g;
  }

  /* Bibi-Khanym in the haze: a big dome and portal. */
  function farMosque() {
    const W = 40, H = 14, g = new Grid(W, H);
    for (let x = 0; x < W; x++) {
      const h = 2 + hash(x, 1, 21) % 3;
      for (let y = H - h; y < H; y++) g.set(x, y, '3');
    }
    g.rect(14, 6, 21, H - 1, '3'); g.rect(16, 8, 19, H - 1, '1');
    g.dome(28, 8, 5, '1'); g.rect(23, 8, 33, H - 1, '1'); g.set(27, 2, '1');
    g.vline(12, 2, H - 1, '1'); g.vline(23 + 12, 4, H - 1, '1');
    return g;
  }

  function plaza() {
    const W = 96, H = 18, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y % 3 === 2 || (x + (Math.floor(y / 3) % 2) * 3) % 6 === 0 ? 's' : 'S');
    return g;
  }

  sprite('uz.registan', registan());
  sprite('uz.farMosque', farMosque());
  sprite('uz.mountains', peaks(96, 12, [[12, 3, 18], [40, 5, 16], [70, 2, 20], [92, 4, 14]], { snowDepth: 2, seed: 4 }));
  sprite('uz.plaza', plaza());
  sprite('uz.poplar', poplar(16, 3));

  return {
    horizon: 62, clouds: [10, 21, 33],
    ops: [
      ['spr', 'uz.mountains', 0, 62, 4, 0],
      ['spr', 'uz.farMosque', 4, 63, 3, 0],
      ['spr', 'uz.registan', 50, 68, 1, 2],
      ['spr', 'uz.poplar', 26, 68, 1, 0],
      ['spr', 'uz.poplar', 34, 68, 1, 0],
      ['spr', 'uz.poplar', 42, 68, 1, 0],
      ['birds', 45, 3, 1.6],
      ['spr', 'uz.plaza', 0, 86, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
