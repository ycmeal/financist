/* Istanbul, Beyoğlu: the Galata Tower above old houses, the red tram on the street below. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, minaret } = P;
  const SHADE = { C: 'c', P: 'p', S: 's', W: 'w', E: 'e', A: 'a' };

  function tower() {
    const W = 15, H = 46, C = 7, g = new Grid(W, H);
    for (let y = 17; y < H; y++) {
      const half = y > H - 6 ? 6 : 5;
      for (let x = C - half; x <= C + half; x++) g.set(x, y, x > C + 2 ? 's' : x < C - 3 ? 'C' : 'S');
    }
    for (const y of [23, 30, 37]) g.hline(C - 5, C + 5, y, 's');
    for (const [x, y] of [[C - 2, 19], [C + 2, 20], [C - 2, 26], [C + 2, 27], [C - 2, 33], [C + 2, 34]]) { g.set(x, y, 'o'); g.set(x, y + 1, 'o'); }
    g.rect(C - 1, H - 4, C + 1, H - 1, 'D'); g.set(C, H - 5, 'D');
    g.hline(C - 6, C + 6, 15, 'S'); g.hline(C - 5, C + 5, 16, 's');
    for (let y = 11; y <= 14; y++) for (let x = C - 5; x <= C + 5; x++) g.set(x, y, x > C + 2 ? 's' : 'S');
    for (let x = C - 4; x <= C + 4; x += 2) { g.set(x, 12, 'o'); g.set(x, 13, 'o'); }
    g.hline(C - 6, C + 6, 10, 'W');
    for (let i = 0; i < 10; i++) {
      const y = 9 - i, half = Math.round(5.4 * (1 - i / 10));
      for (let x = C - half; x <= C + half; x++) g.set(x, y, x > C ? 'l' : 'L');
    }
    g.set(C, 0, 'Y');
    return g;
  }

  /* Old apartment houses: coloured facades, tall windows, bay windows, shop awnings. */
  function houses(W, H, seed, minH, spread) {
    const g = new Grid(W, H);
    let x = 0, i = 0;
    while (x < W) {
      const w = 7 + hash(x, 1, seed) % 4, h = minH + hash(x, 2, seed) % spread;
      const wall = ['C', 'P', 'S', 'W', 'E', 'A'][(i * 4 + seed) % 6], shade = SHADE[wall];
      const top = H - h;
      g.rect(x, top, x + w - 1, H - 1, wall); g.vline(x + w - 1, top, H - 1, shade);
      g.hline(x, x + w - 1, top, 'w'); g.hline(x + 1, x + w - 2, top - 1, 'g');
      for (let y = top + 2; y < H - 4; y += 3) for (let xx = x + 1; xx < x + w - 2; xx += 2) { g.set(xx, y, 'o'); g.set(xx, y + 1, 'o'); }
      if (w > 8 && h > 12) { g.rect(x + 2, top + 4, x + w - 3, top + 6, shade); g.set(x + 3, top + 5, 'o'); g.set(x + w - 4, top + 5, 'o'); }
      g.hline(x, x + w - 1, H - 3, ['R', 'N', 'U', 'E'][(i + seed) % 4]);
      g.rect(x + 1, H - 2, x + w - 2, H - 1, 'o');
      x += w; i++;
    }
    return g;
  }

  /* Süleymaniye across the Golden Horn, in the haze. */
  function farSkyline() {
    const W = 58, H = 14, g = new Grid(W, H);
    for (let x = 0; x < W; x++) { const t = 9 + (hash(x, 1, 41) % 3); for (let y = t; y < H; y++) g.set(x, y, '3'); }
    g.dome(30.5, 8, 5, '3'); g.rect(24, 8, 37, H - 1, '3');
    g.dome(22.5, 10, 2.5, '3'); g.dome(38.5, 10, 2.5, '3');
    for (const x of [21, 25, 36, 40]) { g.vline(x, x === 25 || x === 36 ? 1 : 4, H - 1, '3'); }
    g.dome(10.5, 11, 3, '3'); g.vline(6, 6, H - 1, '3'); g.vline(15, 6, H - 1, '3');
    return g;
  }

  const tram = Grid.from([
    '..........D.........',
    '...........D........',
    '............D.......',
    '..WWWWWWWWWWWWWWWW..',
    '.RCCCCCCCCCCCCCCCCR.',
    '.RooRooRooRooRooRoR.',
    '.RooRooRooRooRooRoR.',
    '.RRRRRRRRRRRRRRRRRR.',
    '.RRDRRRRRRRRRRRRRRR.',
    '.rrrrrrrrrrrrrrrrrr.',
    '..KK............KK..',
  ]);

  function street() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y < 2 ? 'G' : (y % 3 === 1 || (x + (Math.floor(y / 3) % 2) * 2) % 4 === 0) ? 'g' : 'G');
    g.hline(0, W - 1, 6, 'D'); g.hline(0, W - 1, 9, 'D');
    return g;
  }

  sprite('gal.tower', tower());
  sprite('gal.far', farSkyline());
  sprite('gal.back', houses(96, 22, 3, 14, 6));
  sprite('gal.left', houses(44, 24, 5, 14, 8));
  sprite('gal.right', houses(18, 26, 7, 18, 6));
  sprite('gal.tram', tram);
  sprite('gal.street', street());

  return {
    horizon: 60, clouds: [9, 21, 33],
    ops: [
      ['spr', 'gal.far', 0, 60, 3, 0],
      ['spr', 'gal.back', 0, 70, 2, 0],
      ['spr', 'gal.tower', 61, 64, 1, 2],
      ['spr', 'gal.left', 0, 70, 1, 0],
      ['spr', 'gal.right', 78, 70, 1, 0],
      ['birds', 44, 4, 2],
      ['spr', 'gal.street', 0, 86, 0, 0],
      ['boat', 'gal.tram', 77, -0.9, 20, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
