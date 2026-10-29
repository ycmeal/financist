/* Ölüdeniz: paragliders off Babadağ over the blue lagoon, a gulet at sea. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, pine } = P;

  function mountain() {
    const g = peaks(96, 34, [[80, 0, 36], [110, 6, 24], [52, 16, 24]], { rock: 'I', shade: 'i', snow: '1', snowShade: '2', snowDepth: 7, seed: 31 });
    for (let y = 0; y < g.h; y++) for (let x = 0; x < g.w; x++) {
      const c = g.get(x, y);
      if ((c === 'I' || c === 'i') && hash(x, y, 33) % 5 === 0) g.set(x, y, c === 'I' ? 'F' : 'f');
    }
    return g;
  }

  /* The lagoon: an oval of turquoise water ringed by sand, open to the sea on the right; pines on the spit. */
  function lagoon() {
    const W = 64, H = 16, g = new Grid(W, H);
    const cx = 30, cy = 8.5, rx = 30, ry = 6.2;
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
      const dx = (x + 0.5 - cx) / rx, dy = (y + 0.5 - cy) / ry, d = dx * dx + dy * dy;
      const mouth = x > 50 && y < 6;
      if (d > 1 && !mouth && (y > 2 || x < 50)) g.set(x, y, d < 1.25 ? 'c' : 'C');
    }
    for (let x = 3; x < 48; x += 7) { const y = Math.max(0, Math.round(cy - ry * Math.sqrt(Math.max(0, 1 - Math.pow((x + 0.5 - cx) / rx, 2)))) - 2); g.set(x, y, 'I'); g.set(x, y + 1, 'I'); g.set(x + 1, y + 1, 'i'); }
    for (let y = H - 3; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y === H - 3 ? 'c' : 'C');
    return g;
  }

  const glider = (a, b) => Grid.from([
    '..ABABABA..',
    '.ABABABABA.',
    'AB.......BA',
    'D.........D',
    '.D.......D.',
    '..D.....D..',
    '...D...D...',
    '....DKD....',
    '.....K.....',
  ]).replace({ A: a, B: b });

  const gulet = Grid.from([
    '.....D.....D......',
    '.....D.....D......',
    '.....DW....DW.....',
    '.....DW....DWW....',
    '.....D.....D......',
    'b..BBBBBBBBBBBBB..',
    'BBBBWWWWWWWWWWWBBB',
    '.BBBBBBBBBBBBBBBB.',
    '..bbbbbbbbbbbbbb..',
  ]);

  sprite('olu.mountain', mountain());
  sprite('olu.lagoon', lagoon());
  sprite('olu.g1', glider('R', 'Y'));
  sprite('olu.g2', glider('U', 'W'));
  sprite('olu.g3', glider('O', 'Y'));
  sprite('olu.g4', glider('P', 'W'));
  sprite('olu.gulet', gulet);
  sprite('olu.pine', pine(14));
  sprite('olu.pineSmall', pine(10));

  return {
    horizon: 58, clouds: [10, 24],
    ops: [
      ['spr', 'olu.mountain', 0, 60, 3, 0],
      ['water', 58, 80],
      ['water', 62, 78, 0, 64, 1],
      ['spr', 'olu.lagoon', 0, 78, 1, 0],
      ['boat', 'olu.gulet', 66, 0.5, 60, 2],
      ['bob', 'olu.g3', 60, 36, 2, 2, 2.5],
      ['bob', 'olu.g1', 74, 44, 1, 2, 3],
      ['bob', 'olu.g2', 85, 36, 1, 3, 2],
      ['bob', 'olu.g4', 64, 56, 1, 2, 3.5],
      ['spr', 'olu.pine', 84, 80, 0, 0],
      ['spr', 'olu.pineSmall', 92, 80, 0, 0],
      ['flag', 5, 50, 78, 0],
    ],
  };
};
