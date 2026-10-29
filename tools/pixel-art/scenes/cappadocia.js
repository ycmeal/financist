/* Cappadocia: fairy chimneys with cave windows and hot-air balloons at sunrise. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, balloon, hills } = P;

  /* Fairy chimney: soft cone of tuff under a dark basalt cap, cave rooms. */
  function chimney(w, h, seed) {
    const W = w + 2, g = new Grid(W, h + 2), cx = W / 2;
    for (let y = 2; y < h + 2; y++) {
      const k = (y - 2) / (h - 1), half = w / 2 * (0.32 + 0.68 * Math.pow(k, 0.85));
      const l = Math.round(cx - half), r = Math.round(cx + half) - 1;
      for (let x = l; x <= r; x++) g.set(x, y, x === l ? 'C' : x > cx + half * 0.25 - 0.5 ? 's' : 'S');
    }
    const capHalf = Math.max(1.5, w * 0.32 + 1);
    g.hline(Math.round(cx - capHalf), Math.round(cx + capHalf) - 1, 1, 'b');
    g.hline(Math.round(cx - capHalf) + 1, Math.round(cx + capHalf) - 2, 0, 'X');
    for (let i = 0; i < Math.floor(h / 5); i++) {
      const y = 5 + i * 5 + hash(i, 1, seed) % 2, x = Math.floor(cx) - 1 + hash(i, 2, seed) % 2;
      if (g.get(x - 1, y) !== '.' && g.get(x + 1, y + 1) !== '.') { g.set(x, y, 'D'); g.set(x, y + 1, hash(i, 3, seed) % 2 ? 'o' : 'D'); }
    }
    return g;
  }

  function valley() {
    const W = 96, H = 18, g = new Grid(W, H);
    for (let x = 0; x < W; x++) {
      const top = Math.round(2 + Math.cos(x / 7) * 1.2 + Math.cos(x / 3.1) * 0.5);
      for (let y = top; y < H; y++) g.set(x, y, hash(x, y, 71) % 15 === 0 ? 'a' : 'A');
      if (hash(x, 2, 71) % 4 === 0) { g.set(x, top, 'j'); g.set(x, top - 1, 'J'); }
    }
    return g;
  }

  function mesas() {
    const W = 96, H = 12, g = new Grid(W, H);
    for (const [x0, x1, top] of [[0, 30, 4], [24, 52, 6], [46, 80, 3], [74, 96, 5]]) {
      for (let x = x0; x < x1; x++) {
        const edge = Math.min(x - x0, x1 - 1 - x);
        const t = top + Math.max(0, 3 - edge);
        for (let y = t; y < H; y++) g.set(x, y, '3');
      }
    }
    return g;
  }

  function chimneys() {
    const W = 50, H = 30, g = new Grid(W, H);
    const list = [[0, 7, 17], [7, 9, 24], [17, 6, 13], [23, 9, 27], [33, 7, 19], [40, 9, 23]];
    for (const [x, w, h] of list) g.place(chimney(w, h, x + 7), x, H);
    for (let x = 0; x < W; x++) for (let y = H - 3; y < H; y++) if (g.get(x, y) === '.') g.set(x, y, 'A');
    return g;
  }

  sprite('cap.mesas', mesas());
  sprite('cap.chimneys', chimneys());
  sprite('cap.small', chimney(5, 12, 3));
  sprite('cap.valley', valley());
  sprite('cap.b1', balloon(9, 12, ['R', 'Y', 'R', 'Y', 'R']));
  sprite('cap.b2', balloon(7, 10, ['U', 'W', 'U', 'W']));
  sprite('cap.b3', balloon(7, 9, ['R', 'O', 'Y', 'N', 'U', 'P']));
  sprite('cap.b4', balloon(5, 7, ['N', 'Y', 'N']));
  sprite('cap.b5', balloon(4, 6, ['P', 'W']));

  return {
    horizon: 62, clouds: [12, 30],
    ops: [
      ['spr', 'cap.mesas', 0, 62, 4, 0],
      ['bob', 'cap.b5', 40, 21, 3, 2, 3],
      ['bob', 'cap.b4', 22, 22, 2, 2, 4],
      ['spr', 'cap.chimneys', 46, 70, 1, 2],
      ['spr', 'cap.small', 30, 66, 2, 2],
      ['spr', 'cap.small', 38, 68, 1, 2],
      ['bob', 'cap.b3', 50, 24, 2, 3, 2.5],
      ['bob', 'cap.b2', 86, 40, 1, 2, 3.5],
      ['bob', 'cap.b1', 66, 44, 1, 3, 3],
      ['spr', 'cap.valley', 0, 86, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
