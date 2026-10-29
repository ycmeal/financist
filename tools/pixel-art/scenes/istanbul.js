/* Istanbul: the Blue Mosque over the Bosphorus, Maiden's Tower, the bridge, a ferry. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, domePaint, minaret, cypress } = P;

  function blueMosque() {
    const W = 35, H = 38, C = 17;
    const g = new Grid(W, H);
    const cx = C + 0.5;
    for (const s of [-1, 1]) {
      for (let x = C + s * 13; x !== C + s * 15; x += s) g.vline(x, 30, H - 1, 'W');
      g.hline(Math.min(C + s * 13, C + s * 14), Math.max(C + s * 13, C + s * 14), 30, 'w');
      g.vline(C + s * 13, 33, 35, 'D');
    }
    g.rect(C - 10, 25, C + 10, H - 1, 'W');
    g.rect(C + 9, 25, C + 10, H - 1, 'w');
    g.hline(C - 10, C + 10, 25, 'w');
    for (const y of [28, 32]) for (let x = C - 8; x <= C + 8; x += 2) if (x !== C) { g.set(x, y, 'o'); g.set(x, y + 1, 'o'); }
    g.rect(C - 1, 34, C + 1, H - 1, 'D'); g.set(C, 33, 'D');
    g.hline(C - 6, C + 6, 20, 'W'); g.hline(C - 6, C + 6, 21, 'w');
    for (let x = C - 5; x <= C + 5; x += 2) g.set(x, 20, 'o');
    g.dome(cx, 20, 7.2, domePaint('L', 'l', 'V', 7.2));
    g.set(C, 10, 'Y').set(C, 11, 'Y').set(C, 12, 'y');
    for (const s of [-1, 1]) {
      g.vline(C + s * 8, 17, 24, s < 0 ? 'W' : 'w');
      g.set(C + s * 8, 16, 'L').set(C + s * 8, 15, 'Y');
      g.dome(cx + s * 5.5, 25, 4.2, domePaint('L', 'l', 'V', 4.2));
      g.dome(cx + s * 9, 25, 2, domePaint('L', 'l', null, 2));
    }
    for (const s of [-1, 1]) {
      minaret(g, C + s * 11, 0, H, [9, 16, 23]);
      minaret(g, C + s * 16, 6, H, [11, 19]);
    }
    return g;
  }

  const maidenTower = Grid.from([
    '....Y....',
    '....L....',
    '...LLl...',
    '...LLl...',
    '..WWWWw..',
    '..WoWWw..',
    '..WWWWw..',
    '.wWWWWWw.',
    '.WWoWoWw.',
    '.WWWWWWw.',
    'GGGGGGGgg',
    '.gGGGGgg.',
  ]);

  const ferry = Grid.from([
    '..........KK......',
    '..........WW......',
    '....WWWWWWWWWWW...',
    '...WoWoWoWoWoWoW..',
    '..WWWWWWWWWWWWWWW.',
    '.WWoWoWoWoWoWoWoWW',
    'KKKKKKKKKKKKKKKKKK',
    '.DDDDDDDDDDDDDDDD.',
  ]);

  /* Far hills of the Asian side, then the nearer shore with houses lighting up at night. */
  function farHills() {
    const W = 96, H = 9, g = new Grid(W, H);
    for (let x = 0; x < W; x++) {
      const top = 3 + Math.round(2 * Math.cos(x / 11) + Math.cos(x / 5.3) * 0.9);
      for (let y = top; y < H; y++) g.set(x, y, '3');
    }
    return g;
  }
  function asianShore() {
    const W = 60, H = 6, g = new Grid(W, H);
    for (let x = 0; x < W; x++) {
      const top = 2 + Math.round(Math.cos(x / 6) * 0.8);
      for (let y = top; y < H; y++) g.set(x, y, '1');
      if (hash(x, 1, 77) % 3 === 0) g.set(x, top + 1 + hash(x, 2, 77) % 2, 'o');
      if (hash(x, 3, 77) % 4 === 0) { g.set(x, top - 1, '1'); g.set(x, top, 'o'); }
    }
    g.dome(30.5, 2, 1.8, '1'); g.vline(27, 0, 2, '1'); g.vline(34, 0, 2, '1');
    return g;
  }

  /* The Bosphorus Bridge in the haze. */
  function bridge() {
    const W = 50, H = 12, g = new Grid(W, H);
    const t1 = 9, t2 = 40, deck = 8;
    for (const t of [t1, t2]) { g.vline(t - 1, 0, H - 1, 'G'); g.vline(t + 1, 0, H - 1, 'G'); g.set(t, 1, 'G'); g.set(t, 5, 'G'); }
    g.hline(0, W - 1, deck, 'G'); g.hline(0, W - 1, deck + 1, 'g');
    const cable = x => {
      if (x < t1) return Math.round((t1 - x) / t1 * deck * 0.9);
      if (x > t2) return Math.round((x - t2) / (W - 1 - t2) * deck * 0.9);
      const u = (x - t1) / (t2 - t1);
      return Math.round(4 * u * (1 - u) * (deck - 1.5));
    };
    for (let x = 0; x < W; x++) {
      const y = cable(x);
      if (x !== t1 && x !== t2) g.set(x, y, 'G');
      if (x % 3 === 0) for (let yy = y + 1; yy < deck; yy++) if (g.get(x, yy) === '.') g.set(x, yy, 'w');
    }
    return g;
  }

  /* Old town under the mosque: a hill with houses and cypresses, stone shore. */
  function hill() {
    const W = 56, H = 12, g = new Grid(W, H);
    const top = x => Math.max(1, Math.round(1 + (16 - x) * 0.55));
    for (let x = 0; x < W; x++) for (let y = top(x); y < H; y++) g.set(x, y, hash(x, y, 5) % 5 === 0 ? 'j' : 'J');
    g.hline(0, W - 1, H - 2, 'G'); g.hline(0, W - 1, H - 1, 'g');
    let x = 3;
    while (x < W - 4) {
      const w = 3 + hash(x, 9, 3) % 3, h = 2 + hash(x, 8, 3) % 2;
      const y0 = Math.max(top(x), top(x + w)) + 3 + hash(x, 7, 3) % 2;
      const wall = 'WCSPW'[hash(x, 6, 3) % 5];
      g.rect(x, y0, x + w - 1, Math.min(y0 + h, H - 3), wall);
      g.hline(x, x + w - 1, y0 - 1, 'E'); g.set(x + w - 1, y0 - 1, 'e');
      g.set(x + 1, y0 + 1, 'o');
      x += w + 1 + hash(x, 5, 3) % 3;
    }
    for (const [cx, h] of [[5, 7], [20, 6], [36, 7], [49, 6]]) g.place(cypress(h), cx, Math.max(top(cx), top(cx + 2)) + 5);
    return g;
  }

  sprite('ist.mosque', blueMosque().trim());
  sprite('ist.maiden', maidenTower);
  sprite('ist.ferry', ferry);
  sprite('ist.farHills', farHills());
  sprite('ist.shore', asianShore());
  sprite('ist.bridge', bridge());
  sprite('ist.hill', hill());
  sprite('quay', P.quay(96, 12));
  sprite('lamp', P.lamp(11));

  return {
    horizon: 56, clouds: [9, 22, 34],
    ops: [
      ['spr', 'ist.farHills', 0, 56, 4, 0],
      ['spr', 'ist.bridge', 8, 57, 3, 0],
      ['spr', 'ist.shore', 0, 57, 3, 0],
      ['water', 56, 76],
      ['spr', 'ist.maiden', 34, 63, 2, 2],
      ['spr', 'ist.hill', 40, 72, 1, 0],
      ['spr', 'ist.mosque', 59, 65, 1, 2],
      ['birds', 46, 4, 2.2],
      ['boat', 'ist.ferry', 75, -1.1, 30, 1],
      ['spr', 'quay', 0, 86, 0, 0],
      ['spr', 'lamp', 30, 75, 0, 0],
      ['spr', 'lamp', 86, 75, 0, 0],
      ['flag', 5, 50, 75, 0],
    ],
  };
};
