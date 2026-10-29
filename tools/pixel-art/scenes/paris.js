/* Paris: the Eiffel Tower over Haussmann roofs; it sparkles after dark at the top of the hour. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, townHouse, roundTree } = P;

  function eiffel() {
    const W = 27, H = 44, C = 13, g = new Grid(W, H);
    const halfAt = y => {
      if (y < 5) return 0.5;
      if (y < 21) return 1 + (y - 5) / 16 * 2;
      if (y < 33) return 3.5 + (y - 21) / 12 * 3.5;
      return 7.5 + Math.pow((y - 33) / 10, 1.4) * 5.5;
    };
    for (let y = 0; y < H; y++) {
      const half = halfAt(y);
      const l = Math.round(C - half), r = Math.round(C + half);
      for (let x = l; x <= r; x++) {
        const edge = x === l || x === r;
        const lattice = ((x - C) + y) % 3 === 0 || ((C - x) + y) % 3 === 0;
        if (edge || lattice || half < 2) g.set(x, y, edge && x === r ? 'b' : 'B');
      }
    }
    // Arch between the legs.
    for (let y = 36; y < H; y++) {
      const k = (y - 35) / (H - 35), half = 6.5 * Math.sqrt(k);
      for (let x = Math.ceil(C - half); x <= Math.floor(C + half); x++) g.set(x, y, '.');
    }
    g.hline(C - 5, C + 5, 21, 'B'); g.hline(C - 4, C + 4, 22, 'b');
    g.hline(C - 9, C + 9, 33, 'B'); g.hline(C - 8, C + 8, 34, 'b');
    g.vline(C, 0, 2, 'G'); g.hline(C - 1, C + 1, 3, 'B'); g.hline(C - 1, C + 1, 4, 'b');
    return g;
  }

  function houses() {
    const W = 64, H = 26, g = new Grid(W, H);
    let x = 0, i = 0;
    while (x < W) {
      const w = 9 + hash(x, 1, 51) % 5, floors = 4 + hash(x, 2, 51) % 3;
      const wall = ['C', 'W', 'C', 'S'][i % 4];
      g.place(townHouse(w, floors, wall, 'L', x, { mansard: true }), x, H);
      x += w; i++;
    }
    return g;
  }

  function farRoofs() {
    const W = 96, H = 10, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 5 + hash(x, 1, 61) % 6, h = 4 + hash(x, 2, 61) % 4;
      g.rect(x, H - h, x + w - 1, H - 1, '3');
      g.hline(x + 1, x + w - 2, H - h - 1, '3');
      x += w;
    }
    g.rect(30, 0, 35, H - 1, '3'); g.dome(33, 2, 3, '3');
    return g;
  }

  function avenue() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y < 2 ? 'G' : y % 3 === 1 || (x + (Math.floor(y / 3) % 2) * 4) % 8 === 0 ? 's' : 'S');
    return g;
  }

  sprite('par.eiffel', eiffel());
  sprite('par.houses', houses());
  sprite('par.far', farRoofs());
  sprite('par.avenue', avenue());
  sprite('tree.round', roundTree(9, 10, 4));
  sprite('tree.roundSmall', roundTree(7, 8, 6));
  sprite('lamp', P.lamp(11));

  return {
    horizon: 62, clouds: [10, 22, 34],
    ops: [
      ['spr', 'par.far', 0, 62, 3, 0],
      ['spr', 'par.eiffel', 61, 66, 1, 2],
      ['sparkle', 'par.eiffel', 61, 66],
      ['spr', 'par.houses', 0, 70, 1, 0],
      ['spr', 'tree.round', 56, 70, 0, 0],
      ['spr', 'tree.round', 86, 70, 0, 0],
      ['spr', 'tree.roundSmall', 47, 70, 0, 0],
      ['spr', 'lamp', 80, 71, 0, 0],
      ['birds', 44, 3, 1.6],
      ['spr', 'par.avenue', 0, 86, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
