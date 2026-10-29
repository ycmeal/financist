/* Pamukkale: white travertine terraces with turquoise pools, Hierapolis columns on top. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, roundTree } = P;

  /* Travertine: overlapping scalloped pools like fish scales, white drips under each rim. */
  function terraces() {
    const W = 96, H = 34, g = new Grid(W, H);
    const top = x => x < 16 ? H : x < 60 ? Math.round(H - 2 - (x - 16) * 0.66) : 3 + (hash(x, 1, 5) % 2);
    for (let x = 0; x < W; x++) for (let y = top(x); y < H; y++) g.set(x, y, hash(x, y, 3) % 11 === 0 ? 'w' : 'W');
    const SW = 9;
    for (let tier = 0; tier < 7; tier++) {
      const y0 = 5 + tier * 4, shift = tier % 2 ? Math.floor(SW / 2) : 0;
      for (let x0 = -SW + shift; x0 < W; x0 += SW) {
        const w = SW - (hash(x0, tier, 7) % 2);
        for (let dx = 0; dx < w; dx++) {
          const x = x0 + dx;
          if (x < 0 || x >= W || top(x) > y0) continue;
          const u = (dx + 0.5) / w * 2 - 1, depth = Math.round((1 - u * u) * 2);   // 0 at the ends, 2 in the middle
          for (let k = 0; k <= depth; k++) g.set(x, y0 + k, k === 0 && Math.abs(u) > 0.75 ? 'V' : k === depth && depth > 0 ? '5' : '4');
          g.set(x, y0 + depth + 1, 'V');
          const drip = hash(x, tier, 9) % 3;
          for (let k = 0; k < drip; k++) g.set(x, y0 + depth + 2 + k, k % 2 ? 'W' : 'w');
        }
      }
    }
    return g;
  }

  function ground() {
    const W = 96, H = 14, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, hash(x, y, 13) % 9 === 0 ? 'j' : 'J');
    for (let x = 30; x < W; x++) { g.set(x, 2 + ((x >> 3) % 2), 'S'); g.set(x, 3 + ((x >> 3) % 2), 'S'); }
    return g;
  }

  /* Hierapolis: a few columns and an arch. */
  function ruins() {
    const W = 26, H = 12, g = new Grid(W, H);
    for (const [x, h] of [[1, 9], [5, 11], [9, 11], [13, 11], [20, 7], [24, 8]]) {
      g.vline(x, H - h, H - 1, 'S'); g.set(x - 1, H - h, 'S'); g.set(x + 1, H - h, 's'); g.set(x + 1, H - 1, 's');
    }
    g.hline(4, 14, 1, 'S'); g.hline(4, 14, 2, 's');
    g.rect(17, 6, 22, H - 1, 'S'); g.rect(19, 8, 20, H - 1, '.'); g.set(19, 7, '.'); g.set(20, 7, '.');
    return g;
  }

  sprite('pam.hills', peaks(96, 12, [[14, 5, 22], [44, 3, 24], [74, 6, 22], [100, 2, 20]], { rock: '1', shade: '2', snowDepth: 0, seed: 21 }));
  sprite('pam.terraces', terraces());
  sprite('pam.ground', ground());
  sprite('pam.ruins', ruins());
  sprite('tree.round', roundTree(9, 10, 4));
  sprite('tree.roundSmall', roundTree(7, 8, 6));

  return {
    horizon: 62, clouds: [10, 22, 34],
    ops: [
      ['spr', 'pam.hills', 0, 62, 4, 0],
      ['spr', 'pam.ruins', 66, 42, 2, 2],
      ['spr', 'pam.terraces', 0, 74, 1, 0],
      ['spr', 'pam.ground', 0, 86, 0, 0],
      ['water', 70, 76, 0, 24, 1],
      ['spr', 'tree.round', 26, 74, 0, 0],
      ['spr', 'tree.roundSmall', 34, 74, 0, 0],
      ['birds', 44, 3, 1.6],
      ['flag', 5, 50, 74, 0],
    ],
  };
};
