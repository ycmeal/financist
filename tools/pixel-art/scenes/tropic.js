/* Tropics: limestone islands in a turquoise lagoon, a long-tail boat, palms over a white beach. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, palm } = P;

  function karst(w, h, seed) {
    const g = new Grid(w, h);
    const c = (w - 1) / 2;
    for (let y = 0; y < h; y++) {
      const k = y / (h - 1), half = c * (0.55 + 0.45 * Math.pow(k, 0.5)) - (y < 2 ? 1 : 0);
      for (let x = Math.round(c - half); x <= Math.round(c + half); x++) {
        const right = x > c + half * 0.3;
        const green = y < 3 + hash(x, 1, seed) % 3 || (hash(x, y, seed) % 5 === 0 && y < h * 0.7);
        g.set(x, y, green ? (right ? 'f' : 'F') : right ? 'g' : 'G');
      }
    }
    return g;
  }

  const longtail = Grid.from([
    '..............RY',
    '.............YBN',
    'b...........BB..',
    'BBBBBBBBBBBBBB..',
    '.bbbbbbbbbbbb...',
  ]);

  function beach() {
    const W = 96, H = 14, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y === 0 ? 'V' : hash(x, y, 151) % 19 === 0 ? 'S' : 'C');
    return g;
  }

  sprite('trp.k1', karst(12, 22, 1));
  sprite('trp.k2', karst(9, 15, 2));
  sprite('trp.k3', karst(16, 26, 3));
  sprite('trp.k4', karst(7, 10, 4));
  sprite('trp.boat', longtail);
  sprite('trp.beach', beach());
  sprite('palm.big', palm(16, 1, 3, 0));
  sprite('palm.lean', palm(14, -2, 6, 0));
  sprite('palm.small', palm(9, 0, 8, 1));

  return {
    horizon: 58, clouds: [10, 22, 33],
    ops: [
      ['water', 58, 80, 0, 96, 1],
      ['spr', 'trp.k4', 30, 60, 3, 0],
      ['spr', 'trp.k2', 44, 61, 3, 0],
      ['spr', 'trp.k1', 58, 63, 2, 0],
      ['spr', 'trp.k3', 72, 64, 2, 0],
      ['boat', 'trp.boat', 70, 0.9, 20, 1],
      ['birds', 44, 3, 2],
      ['spr', 'trp.beach', 0, 88, 0, 0],
      ['spr', 'palm.lean', 80, 76, 0, 0],
      ['spr', 'palm.big', 88, 76, 0, 0],
      ['spr', 'palm.small', 26, 76, 0, 0],
      ['flag', 5, 50, 76, 0],
    ],
  };
};
