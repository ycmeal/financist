/* Dubai: Burj Khalifa and towers, Burj Al Arab in the sea, a dhow, palms on the beach. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, palm } = P;

  function skyline() {
    const W = 44, H = 52, g = new Grid(W, H);
    const tower = (x0, w, h, wall, shade, seed, top) => {
      const y0 = H - h;
      g.rect(x0, y0, x0 + w - 1, H - 1, wall); g.vline(x0 + w - 1, y0, H - 1, shade);
      for (let y = y0 + 2; y < H - 1; y += 2) for (let x = x0 + 1; x < x0 + w - 1; x++) if (hash(x, y, seed) % 3) g.set(x, y, 'o');
      if (top === 'slant') for (let i = 0; i < w; i++) for (let y = y0; y < y0 + i; y++) g.set(x0 + w - 1 - i, y, '.');
      if (top === 'round') { g.set(x0, y0, '.'); g.set(x0 + w - 1, y0, '.'); g.hline(x0 + 1, x0 + w - 2, y0 - 1, wall); }
      if (top === 'mast') g.vline(x0 + Math.floor(w / 2), y0 - 4, y0 - 1, 'G');
    };
    tower(0, 6, 24, 'm', 'm', 1, 'mast');
    tower(7, 5, 16, 'S', 's', 2, null);
    tower(26, 5, 30, 'G', 'g', 3, 'slant');
    tower(32, 4, 24, 'G', 'g', 4, 'slant');
    tower(37, 6, 20, 'M', 'm', 5, 'round');
    tower(40, 4, 12, 'W', 'w', 6, null);
    // Burj Khalifa: stepped needle.
    const C = 18, segs = [[5, 10], [4, 9], [3, 8], [2, 7], [1, 6]];
    let y = H;
    for (const [half, h] of segs) {
      for (let yy = y - h; yy < y; yy++) for (let x = C - half; x <= C + half; x++) {
        g.set(x, yy, x === C ? 'G' : x > C ? 'm' : 'M');
        if (x !== C && (yy + x) % 3 === 0 && hash(x, yy, 9) % 2) g.set(x, yy, 'o');
      }
      y -= h;
    }
    g.vline(C, y - 9, y - 1, 'G'); g.set(C, y - 10, '*');
    for (let x = 0; x < W; x++) for (let yy = H - 4; yy < H; yy++) if (g.get(x, yy) === '.' || yy >= H - 2) g.set(x, yy, yy === H - 4 ? 'w' : 'W');
    for (let x = 1; x < W; x += 3) g.set(x, H - 2, 'o');
    return g;
  }

  function burjAlArab() {
    const W = 12, H = 24, g = new Grid(W, H);
    for (let y = 2; y < H - 1; y++) {
      const u = (y - 2) / (H - 3);
      const right = 3 + Math.round(Math.sin(Math.min(1, u * 1.15) * Math.PI * 0.62) * 7.5);
      for (let x = 3; x <= right; x++) g.set(x, y, x === right ? 'w' : (x + y) % 4 === 0 ? 'w' : 'W');
    }
    g.vline(2, 0, H - 2, 'G'); g.vline(1, 6, H - 2, 'g');
    g.hline(0, 2, 4, 'G'); g.set(0, 5, 'D');
    g.hline(0, W - 1, H - 1, 'G');
    return g.trim();
  }

  function dhow() {
    return Grid.from([
      '.....B.........',
      '.....BWW.......',
      '....BWWWW......',
      '....BWWWWW.....',
      '...BWWWWWWW....',
      '...BWWWWWWWW...',
      '..BbbbbbbbbbbB.',
      '......B........',
      'BB....B......BB',
      '.BBBBBBBBBBBBB.',
      '..bbbbbbbbbbb..',
    ]);
  }

  function farSkyline() {
    const W = 50, H = 12, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 2 + hash(x, 1, 41) % 3, h = 3 + hash(x, 2, 41) % 9;
      g.rect(x, H - h, x + w - 1, H - 1, '3');
      if (h > 6) g.set(x + 1, H - h + 2, 'o');
      x += w + hash(x, 3, 41) % 2;
    }
    return g;
  }

  function beach() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y === 0 ? 'W' : hash(x, y, 13) % 17 === 0 ? 'a' : 'A');
    return g;
  }

  sprite('dxb.skyline', skyline());
  sprite('dxb.arab', burjAlArab());
  sprite('dxb.dhow', dhow());
  sprite('dxb.far', farSkyline());
  sprite('dxb.beach', beach());
  sprite('palm.big', palm(16, 1, 3, 0));
  sprite('palm.mid', palm(13, -1, 5, 0));
  sprite('palm.small', palm(9, 0, 8, 1));

  return {
    horizon: 62, clouds: [11, 26],
    ops: [
      ['spr', 'dxb.far', 46, 63, 3, 0],
      ['water', 62, 74],
      ['spr', 'dxb.arab', 40, 66, 2, 2],
      ['spr', 'dxb.skyline', 52, 66, 1, 2],
      ['boat', 'dxb.dhow', 71, 0.9, 10, 1],
      ['birds', 47, 3, 1.5],
      ['spr', 'dxb.beach', 0, 86, 0, 0],
      ['spr', 'palm.big', 20, 72, 0, 0],
      ['spr', 'palm.small', 33, 72, 0, 0],
      ['spr', 'palm.mid', 84, 72, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
