/* Tashkent: the white Minor Mosque by the Ankhor canal, the TV tower, plane trees. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, roundTree } = P;

  function tvTower() {
    const W = 17, H = 44, C = 8, g = new Grid(W, H);
    for (let y = 1; y <= 9; y++) g.set(C, y, Math.floor(y / 2) % 2 ? 'R' : 'W');
    g.set(C, 0, '*');
    g.hline(C - 2, C + 2, 10, 'G'); g.hline(C - 2, C + 2, 11, 'g'); g.hline(C - 1, C + 1, 12, 'g');
    g.vline(C, 13, 17, 'G');
    g.hline(C - 3, C + 3, 18, 'G'); g.hline(C - 4, C + 4, 19, 'G'); g.hline(C - 4, C + 4, 20, 'o'); g.hline(C - 4, C + 4, 21, 'G'); g.hline(C - 3, C + 3, 22, 'g');
    for (let y = 23; y < H; y++) { g.set(C, y, 'G'); g.set(C + 1, y, y % 3 ? 'g' : 'G'); }
    // Tripod: two outer legs curving out to the ground, braces.
    for (let y = 30; y < H; y++) {
      const k = (y - 30) / (H - 31), off = Math.round(1 + k * k * 7);
      g.set(C - off, y, 'G'); g.set(C + 1 + off, y, 'g');
      if (y % 4 === 0) for (let x = C - off + 1; x <= C + off; x++) if (g.get(x, y) === '.') g.set(x, y, 'g');
    }
    return g;
  }

  function minor() {
    const W = 28, H = 34, C = 13.5, g = new Grid(W, H);
    g.rect(4, 22, 23, H - 1, 'W'); g.vline(23, 22, H - 1, 'w');
    for (let x = 5; x <= 21; x += 3) { g.vline(x + 1, 26, H - 2, 'D'); g.set(x + 1, 25, 'w'); }
    g.hline(4, 23, 22, 'w'); g.hline(4, 23, 21, 'W');
    g.rect(9, 15, 18, 21, 'W'); g.vline(18, 15, 21, 'w'); g.hline(9, 18, 15, 'T');
    g.dome(C + 0.5, 15, 5.4, P.domePaint('T', 't', 'V', 5.4)); g.set(13, 8, 'Y'); g.set(14, 8, 'Y'); g.set(13, 7, 'Y');
    for (const x of [1, 26]) {
      for (let y = 6; y < H; y++) { g.set(x - 1, y, 'W'); g.set(x, y, 'W'); g.set(x + 1, y, 'w'); }
      g.hline(x - 2, x + 2, 12, 'W'); g.hline(x - 1, x + 1, 13, 'g');
      g.hline(x - 2, x + 2, 20, 'W'); g.hline(x - 1, x + 1, 21, 'g');
      g.hline(x - 1, x + 1, 5, 'T'); g.hline(x - 1, x + 1, 4, 'T'); g.set(x, 3, 'T'); g.set(x, 2, 'T'); g.set(x, 1, 'Y');
    }
    return g;
  }

  function city() {
    const W = 50, H = 12, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 5 + hash(x, 1, 151) % 6, h = 4 + hash(x, 2, 151) % 7;
      g.rect(x, H - h, x + w - 1, H - 1, '3');
      for (let y = H - h + 1; y < H; y += 2) for (let xx = x + 1; xx < x + w - 1; xx += 2) g.set(xx, y, 'o');
      x += w + 1;
    }
    return g;
  }

  function embankment() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y === 0 ? 'W' : y < 3 ? 'G' : hash(x, y, 153) % 11 === 0 ? 'j' : 'J');
    return g;
  }

  sprite('tsk.tower', tvTower());
  sprite('tsk.mosque', minor());
  sprite('tsk.city', city());
  sprite('tsk.bank', embankment());
  sprite('tree.big', roundTree(13, 14, 7));
  sprite('tree.round', roundTree(9, 10, 4));

  return {
    horizon: 62, clouds: [9, 21, 33],
    ops: [
      ['spr', 'tsk.city', 0, 62, 3, 0],
      ['spr', 'tsk.tower', 80, 68, 2, 2],
      ['spr', 'tsk.mosque', 59, 68, 1, 2],
      ['water', 66, 74],
      ['spr', 'tree.big', 30, 68, 1, 0],
      ['spr', 'tree.round', 44, 68, 1, 0],
      ['birds', 46, 3, 1.6],
      ['spr', 'tsk.bank', 0, 88, 0, 0],
      ['flag', 5, 50, 74, 0],
    ],
  };
};
