/* Bukhara, Poi Kalon: the Kalyan Minaret, the blue dome of the Kalyan Mosque, Mir-i-Arab's turquoise domes. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, ribbedDome, poplar } = P;

  function kalyan() {
    const W = 12, H = 42, C = 5.5, g = new Grid(W, H);
    for (let y = 12; y < H; y++) {
      const half = 3.4 + (y - 12) / (H - 12) * 1.6;
      const band = (y - 12) % 6 === 0 ? 'S' : null;
      for (let x = Math.round(C - half); x <= Math.round(C + half); x++) {
        const right = x > C + half * 0.35;
        let ch = band || ((x + y) % 4 === 0 ? 'S' : 'A');
        if (right) ch = ch === 'S' ? 's' : 'a';
        g.set(x, y, ch);
      }
    }
    g.hline(2, 9, 12, 'T'); g.hline(2, 9, 13, 't');
    // Rotunda with arches and a stalactite cornice.
    g.hline(0, 11, 11, 'S'); g.hline(1, 10, 10, 's');
    for (let y = 4; y <= 9; y++) for (let x = 1; x <= 10; x++) g.set(x, y, x > 7 ? 'a' : 'A');
    for (let x = 2; x <= 9; x += 2) { g.vline(x, 5, 8, 'D'); g.set(x, 7, 'o'); }
    g.hline(0, 11, 3, 'S'); g.hline(1, 10, 2, 'A');
    g.hline(3, 8, 1, 'A'); g.hline(4, 7, 0, 'a');
    return g;
  }

  function portal(W, H, tile) {
    const g = new Grid(W, H), C = (W - 1) / 2;
    g.rect(0, 0, W - 1, H - 1, 'A'); g.vline(W - 1, 0, H - 1, 'a');
    g.hline(0, W - 1, 0, tile); g.hline(1, W - 2, 2, tile);
    for (let y = 5; y < H; y++) {
      const half = y < 8 ? [0.5, 1.5, 2.5][y - 5] : 3.5;
      for (let x = Math.ceil(C - half); x <= Math.floor(C + half); x++) g.set(x, y, 'U');
    }
    for (let y = 10; y < H - 4; y += 3) g.set(Math.round(C) - 1 + (y % 2), y, 'T');
    g.rect(Math.round(C) - 1, H - 5, Math.round(C) + 1, H - 1, 'D');
    for (const x of [1, W - 2]) for (let y = 4; y < H - 1; y += 3) g.set(x, y, tile);
    return g;
  }

  /* Kalyan Mosque: arcades, the portal and the big blue dome on a drum. */
  function mosque() {
    const W = 28, H = 22, g = new Grid(W, H);
    g.rect(0, 11, W - 1, H - 1, 'A'); g.vline(W - 1, 11, H - 1, 'a');
    for (let x = 1; x < W - 1; x += 3) { g.vline(x, 14, 18, 'D'); g.set(x, 13, 'a'); }
    g.rect(13, 7, 26, 11, 'A'); g.hline(13, 26, 7, 'T'); g.hline(13, 26, 8, 'U');
    g.dome(20, 7, 7, P.domePaint('U', 'u', 'T', 7)); g.set(19, -1, 'Y'); g.set(19, -2, 'Y');
    g.place(portal(11, 19, 'T'), 2, H);
    return g;
  }

  function madrasah() {
    const W = 22, H = 22, g = new Grid(W, H);
    g.rect(0, 10, W - 1, H - 1, 'A');
    for (let x = 1; x < W - 1; x += 3) { g.vline(x, 12, 15, 'U'); g.vline(x, 17, 20, 'U'); }
    for (const cx of [3.5, 18.5]) { g.rect(Math.floor(cx) - 3, 6, Math.floor(cx) + 3, 10, 'A'); g.hline(Math.floor(cx) - 3, Math.floor(cx) + 3, 6, 'U'); ribbedDome(g, cx, 6, 3.6); g.set(Math.floor(cx), 1, 'Y'); }
    g.place(portal(9, 16, 'T'), 6, H);
    return g;
  }

  function square() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y % 3 === 2 || (x + (Math.floor(y / 3) % 2) * 2) % 5 === 0 ? 'a' : 'A');
    return g;
  }

  sprite('bkh.minaret', kalyan());
  sprite('bkh.mosque', mosque());
  sprite('bkh.madrasah', madrasah());
  sprite('bkh.square', square());
  sprite('uz.poplar', poplar(16, 3));

  return {
    horizon: 62, clouds: [10, 22],
    ops: [
      ['spr', 'bkh.mosque', 38, 68, 2, 2],
      ['spr', 'bkh.madrasah', 77, 68, 1, 2],
      ['spr', 'bkh.minaret', 64, 68, 1, 2],
      ['spr', 'uz.poplar', 28, 68, 1, 0],
      ['spr', 'uz.poplar', 34, 68, 1, 0],
      ['birds', 46, 3, 1.4],
      ['spr', 'bkh.square', 0, 84, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
