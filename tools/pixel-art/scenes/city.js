/* A cozy old town: a clock tower, colourful houses, a stone bridge over the river. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, townHouse, roundTree, hills } = P;

  function clockTower() {
    const W = 11, H = 42, C = 5, g = new Grid(W, H);
    g.rect(C - 4, 16, C + 4, H - 1, 'S'); g.vline(C + 4, 16, H - 1, 's');
    for (let y = 22; y < H - 4; y += 5) { g.set(C - 2, y, 'o'); g.set(C + 2, y, 'o'); g.set(C - 2, y + 1, 'o'); g.set(C + 2, y + 1, 'o'); }
    g.rect(C - 1, H - 4, C + 1, H - 1, 'D');
    g.paste(['.YYY.', 'YWKWY', 'YWKKY', 'YWWWY', '.YYY.'], C - 2, 17);
    g.hline(C - 5, C + 5, 16, 's'); g.rect(C - 4, 11, C + 4, 15, 'S'); g.vline(C + 4, 11, 15, 's');
    for (const x of [C - 2, C, C + 2]) g.vline(x, 12, 14, 'D');
    g.hline(C - 5, C + 5, 10, 's');
    for (let i = 0; i < 9; i++) { const half = Math.round(4 - i * 4 / 9), y = 9 - i; for (let x = C - half; x <= C + half; x++) g.set(x, y, x > C ? 'n' : 'N'); }
    g.set(C, 0, 'Y');
    return g;
  }

  function town() {
    const W = 56, H = 20, g = new Grid(W, H);
    let x = 0, i = 0;
    while (x < W) {
      const w = 6 + hash(x, 1, 161) % 4, floors = 3 + hash(x, 2, 161) % 3;
      const wall = ['C', 'P', 'S', 'W', 'O', 'T'][(i * 5 + 1) % 6];
      g.place(townHouse(w, floors, wall, 'E', x), x, H);
      x += w; i++;
    }
    return g;
  }

  function bridge() {
    const W = 60, H = 8, g = new Grid(W, H);
    g.rect(0, 0, W - 1, 3, 'G'); g.hline(0, W - 1, 0, 'W'); g.hline(0, W - 1, 3, 'g');
    for (let x = 0; x < W; x += 2) g.set(x, 1, 'g');
    for (const cx of [9, 29, 49]) {
      g.rect(cx + 6, 3, cx + 9, H - 1, 'G'); g.vline(cx + 9, 3, H - 1, 'g');
    }
    for (const cx of [9, 29, 49]) for (let y = 2; y < H; y++) {
      const half = Math.sqrt(Math.max(0, 1 - Math.pow((H - 1 - y) / 5.5, 2))) * 7;
      if (y > 3) for (let x = Math.round(cx - half); x <= Math.round(cx + half); x++) if (x >= 0 && x < W) g.set(x, y, '.');
    }
    return g;
  }

  sprite('cty.hills', hills(96, 12, [[14, 2, 30], [56, 0, 34], [96, 3, 26]], ['3', '3']));
  sprite('cty.tower', clockTower());
  sprite('cty.town', town());
  sprite('cty.bridge', bridge());
  sprite('tree.round', roundTree(9, 10, 4));
  sprite('tree.roundSmall', roundTree(7, 8, 6));
  sprite('quay', P.quay(96, 12));

  return {
    horizon: 62, clouds: [9, 21, 33],
    ops: [
      ['spr', 'cty.hills', 0, 62, 4, 0],
      ['spr', 'cty.town', 40, 64, 2, 0],
      ['spr', 'cty.tower', 66, 64, 1, 2],
      ['water', 64, 78],
      ['spr', 'cty.bridge', 20, 72, 1, 0],
      ['spr', 'tree.round', 86, 66, 1, 0],
      ['spr', 'tree.roundSmall', 34, 65, 1, 0],
      ['birds', 46, 3, 1.8],
      ['spr', 'quay', 0, 88, 0, 0],
      ['flag', 5, 50, 77, 0],
    ],
  };
};
