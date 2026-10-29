/* New York: Manhattan skyline with the Empire State and Chrysler, Statue of Liberty, an orange ferry. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash } = P;

  function skyline() {
    const W = 50, H = 48, g = new Grid(W, H);
    const block = (x0, w, h, wall, seed, tank) => {
      const y0 = H - h;
      g.rect(x0, y0, x0 + w - 1, H - 1, wall); g.vline(x0 + w - 1, y0, H - 1, wall.toLowerCase() === wall ? wall : wall.toLowerCase());
      for (let y = y0 + 2; y < H - 1; y += 2) for (let x = x0 + 1; x < x0 + w - 1; x += 2) if (hash(x, y, seed) % 4) g.set(x, y, 'o');
      if (tank) { g.rect(x0 + 1, y0 - 3, x0 + 2, y0 - 2, 'b'); g.set(x0 + 1, y0 - 1, 'D'); g.set(x0 + 2, y0 - 1, 'D'); g.set(x0 + 1, y0 - 4, 'b'); }
    };
    block(0, 6, 22, 'S', 1, true);
    block(5, 7, 30, 'G', 2, false);
    block(26, 6, 26, 'C', 3, true);
    block(31, 5, 18, 'R', 4, true);
    block(44, 6, 24, 'S', 5, false);
    // One World Trade Center: tapered glass.
    for (let y = 10; y < H; y++) {
      const half = 2 + Math.round((y - 10) / (H - 10) * 2.5);
      for (let x = 14 - half; x <= 14 + half; x++) g.set(x, y, x > 14 ? 'm' : (x + y) % 4 === 0 ? 'o' : 'M');
    }
    g.vline(14, 3, 9, 'G');
    // Empire State Building: art deco setbacks and a mast.
    const E = 22, steps = [[5, 12], [4, 14], [3, 5], [2, 3], [1, 3]];
    let y = H;
    for (const [half, h] of steps) {
      for (let yy = y - h; yy < y; yy++) for (let x = E - half; x <= E + half; x++) {
        g.set(x, yy, x > E + half / 2 ? 'g' : (x - E) % 2 === 0 && half > 1 ? 'o' : 'G');
      }
      y -= h;
    }
    g.vline(E, y - 4, y - 1, 'G'); g.set(E, y - 5, '*');
    // Chrysler Building: stepped silver crown and a spire.
    const R = 39;
    g.rect(R - 3, 22, R + 3, H - 1, 'G'); g.vline(R + 3, 22, H - 1, 'g');
    for (let yy = 24; yy < H; yy += 2) for (let x = R - 2; x <= R + 2; x += 2) g.set(x, yy, 'o');
    const crown = [[3, 2], [2, 3], [2, 2], [1, 3], [1, 2]];
    let cy = 22;
    for (const [half, h] of crown) {
      for (let yy = cy - h; yy < cy; yy++) for (let x = R - half; x <= R + half; x++) g.set(x, yy, yy === cy - h && x !== R ? 'o' : x > R ? 'w' : 'V');
      cy -= h;
    }
    g.vline(R, cy - 4, cy - 1, 'V');
    return g;
  }

  function liberty() {
    return Grid.from([
      '+......',
      'N......',
      'N.N.N..',
      'NNNNN..',
      '.NNNn..',
      '.NNNn..',
      '.NNNnn.',
      '..NNn..',
      '.NNNnn.',
      '.NNNnn.',
      '.NNNnn.',
      '.SSSss.',
      '.SoSss.',
      '.SSSss.',
      'SSSSsss',
      'SSSSsss',
      'GGGGGGG',
    ]);
  }

  function farCity() {
    const W = 96, H = 14, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 3 + hash(x, 1, 131) % 4, h = 3 + hash(x, 2, 131) % 11;
      g.rect(x, H - h, x + w - 1, H - 1, '3');
      x += w;
    }
    return g;
  }

  const ferry = Grid.from([
    '.....WW.......',
    '...OOOOOOOO...',
    '..OoOoOoOoOO..',
    'OOOOOOOOOOOOOO',
    '.DDDDDDDDDDDD.',
  ]);

  sprite('ny.skyline', skyline());
  sprite('ny.liberty', liberty());
  sprite('ny.far', farCity());
  sprite('ny.ferry', ferry);
  sprite('quay', P.quay(96, 12));

  return {
    horizon: 62, clouds: [9, 21, 33],
    ops: [
      ['spr', 'ny.far', 0, 62, 3, 0],
      ['spr', 'ny.skyline', 46, 66, 1, 2],
      ['water', 62, 78],
      ['spr', 'ny.liberty', 30, 64, 2, 2],
      ['boat', 'ny.ferry', 72, 0.8, 50, 1],
      ['birds', 46, 3, 2],
      ['spr', 'quay', 0, 88, 0, 0],
      ['flag', 5, 50, 77, 0],
    ],
  };
};
