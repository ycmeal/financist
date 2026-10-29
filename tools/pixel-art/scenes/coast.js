/* Mediterranean coast: white houses with blue domes on a cliff, windmills, a yacht. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, sailboat } = P;

  function cliffTown() {
    const W = 48, H = 34, g = new Grid(W, H);
    const top = x => Math.round(Math.max(4, 30 - x * 0.75) + Math.cos(x / 3) * 0.6);
    for (let x = 0; x < W; x++) for (let y = top(x); y < H; y++) {
      const shade = (x + y * 0.5) % 9 > 6 || hash(x, y, 111) % 7 === 0;
      g.set(x, y, shade ? 'b' : 'a');
    }
    // White houses on terraces down the slope, blue doors and shutters.
    for (let row = 0; row < 6; row++) {
      for (let x0 = 4 + row * 2 + (row % 2) * 3; x0 < W - 3; x0 += 7 + (row % 3)) {
        const y1 = top(x0) + 2 + row * 4;
        if (y1 > H - 4 || y1 - 4 < top(x0 + 5) - 1) continue;
        const w = 5 + hash(x0, row, 113) % 2, h = 3 + hash(x0, row, 114) % 2;
        g.rect(x0, y1 - h, x0 + w - 1, y1, 'W'); g.vline(x0 + w - 1, y1 - h, y1, 'w');
        g.set(x0 + 1, y1 - h + 1, 'o'); g.set(x0 + 3, y1 - 1, 'U'); g.set(x0 + 3, y1, 'U');
        if (hash(x0, row, 115) % 3 === 0) g.set(x0 + w - 2, y1 - h - 1, 'P');
      }
    }
    // Blue domes and a bell tower.
    for (const [cx, base, r] of [[24.5, 17, 3.4], [37.5, 10, 3], [13.5, 26, 2.6]]) {
      g.rect(Math.floor(cx) - 3, base, Math.floor(cx) + 3, base + 4, 'W'); g.vline(Math.floor(cx) + 3, base, base + 4, 'w');
      g.dome(cx, base, r, P.domePaint('U', 'u', 'V', r));
      g.set(Math.floor(cx), base - Math.ceil(r) - 1, 'Y');
    }
    g.rect(43, 2, 46, 10, 'W'); g.vline(46, 2, 10, 'w'); g.set(44, 4, 'D'); g.set(44, 5, 'D'); g.dome(45, 2, 2, P.domePaint('U', 'u', null, 2));
    return g;
  }

  function windmill() {
    return Grid.from([
      '..w.....w..',
      '...w...w...',
      '....wAw....',
      '....AAa....',
      '...WAAaW...',
      '..w.WWw.w..',
      '.w..WWw..w.',
      '....WDw....',
      '....WWw....',
      '...WWWww...',
    ]);
  }

  function islands() {
    const W = 96, H = 5, g = new Grid(W, H);
    for (const [x0, x1, h] of [[2, 26, 3], [30, 40, 2], [60, 92, 4]]) for (let x = x0; x < x1; x++) {
      const e = Math.min(x - x0, x1 - 1 - x), t = H - Math.min(h, 1 + e);
      for (let y = t; y < H; y++) g.set(x, y, '3');
    }
    return g;
  }

  function rocks() {
    const W = 20, H = 8, g = new Grid(W, H);
    for (let x = 0; x < W; x++) { const t = Math.round(2 + Math.abs(x - 8) * 0.4 + hash(x, 1, 117) % 2); for (let y = t; y < H; y++) g.set(x, y, x > 9 ? 'b' : 'a'); }
    return g;
  }

  sprite('cst.town', cliffTown());
  sprite('cst.mill', windmill());
  sprite('cst.islands', islands());
  sprite('cst.rocks', rocks());
  sprite('yacht', sailboat());

  return {
    horizon: 58, clouds: [10, 24, 35],
    ops: [
      ['spr', 'cst.islands', 0, 58, 4, 0],
      ['water', 58, 80],
      ['boat', 'yacht', 70, 0.6, 30, 1],
      ['spr', 'cst.town', 48, 74, 1, 2],
      ['spr', 'cst.mill', 76, 45, 1, 0],
      ['spr', 'cst.mill', 86, 42, 1, 0],
      ['birds', 44, 3, 2],
      ['spr', 'cst.rocks', 0, 78, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
