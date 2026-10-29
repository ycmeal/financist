/* Tashkent, Chorsu: the great blue dome of the bazaar, stalls with melons, watermelons and bread. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, poplar } = P;

  function dome() {
    const W = 52, H = 26, C = 25.5, g = new Grid(W, H);
    g.rect(2, 19, 49, H - 1, 'S'); g.vline(49, 19, H - 1, 's'); g.hline(2, 49, 19, 'T');
    for (let x = 4; x <= 47; x += 4) { g.vline(x, 21, 24, 'D'); g.set(x, 22, 'o'); }
    for (let y = 4; y <= 18; y++) {
      const k = (18 - y) / 14, half = 24 * Math.sqrt(Math.max(0, 1 - k * k));
      for (let x = Math.round(C - half); x <= Math.round(C + half) - 1; x++) {
        const lattice = (x + y * 2) % 7 === 0 || (x - y * 2 + 70) % 7 === 0;
        const right = x > C + half * 0.45;
        g.set(x, y, lattice ? (right ? 'u' : 'U') : right ? 't' : (x < C - half * 0.55 && y < 9 && (x + y) % 2 === 0 ? 'V' : 'T'));
      }
    }
    g.rect(23, 1, 28, 4, 'T'); g.hline(23, 28, 1, 'S'); g.dome(C + 0.5, 1, 2, 'T'); g.set(25, -2, 'Y');
    return g;
  }

  /* Stalls: striped awnings on poles, piles of fruit and round bread on the counters. */
  function stalls() {
    const W = 76, H = 16, g = new Grid(W, H);
    const awnings = [['R', 'W'], ['U', 'W'], ['N', 'W'], ['O', 'Y']];
    for (let i = 0; i < 4; i++) {
      const x0 = i * 19, [a, b] = awnings[i];
      for (let x = x0; x < x0 + 17; x++) { g.set(x, 0, (x >> 1) % 2 ? a : b); g.set(x, 1, (x >> 1) % 2 ? a : b); g.set(x, 2, x % 2 ? a.toLowerCase() : '.'); }
      g.vline(x0, 3, H - 1, 'b'); g.vline(x0 + 16, 3, H - 1, 'b');
      g.rect(x0 + 1, 10, x0 + 15, H - 1, 'B'); g.hline(x0 + 1, x0 + 15, 10, 'b');
    }
    // Melons, watermelons, pomegranates, bread.
    const pile = (x0, mats) => { for (let k = 0; k < 4; k++) { const x = x0 + k * 3; g.set(x, 8, mats[0]); g.set(x + 1, 8, mats[1]); g.set(x, 9, mats[1]); g.set(x + 1, 9, mats[1]); } g.set(x0 + 2, 7, mats[0]); g.set(x0 + 6, 7, mats[0]); };
    pile(3, ['Y', 'y']); pile(22, ['N', 'n']); pile(41, ['R', 'r']);
    for (let k = 0; k < 4; k++) { const x = 61 + k * 3; g.set(x, 9, 'B'); g.set(x + 1, 9, 'B'); g.set(x, 8, 'S'); g.set(x + 1, 8, 'B'); }
    return g;
  }

  function ground() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, hash(x, y, 171) % 9 === 0 ? 's' : 'S');
    return g;
  }

  function melons() {
    return Grid.from(['...Yy...', '..YyYy..', '.YyYyYy.', 'YyYyYyYy']);
  }

  sprite('bzr.dome', dome());
  sprite('bzr.stalls', stalls());
  sprite('bzr.ground', ground());
  sprite('bzr.melons', melons());
  sprite('uz.poplar', poplar(16, 3));

  return {
    horizon: 62, clouds: [10, 22],
    ops: [
      ['spr', 'bzr.dome', 46, 64, 2, 2],
      ['spr', 'uz.poplar', 30, 66, 2, 0],
      ['spr', 'uz.poplar', 38, 66, 2, 0],
      ['spr', 'bzr.ground', 0, 86, 0, 0],
      ['spr', 'bzr.stalls', 22, 74, 1, 0],
      ['spr', 'bzr.melons', 10, 74, 0, 0],
      ['birds', 46, 4, 1.8],
      ['flag', 5, 50, 74, 0],
    ],
  };
};
