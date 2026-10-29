/* Moscow: Red Square — the Kremlin wall, Spasskaya Tower with the ruby star, St. Basil's, golden domes. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, onion, pine } = P;

  function spasskaya() {
    const W = 13, C = 6, H = 44, g = new Grid(W, H);
    let y = H;
    const base = 14;
    g.rect(C - 5, y - base, C + 5, y - 1, 'R'); g.rect(C + 4, y - base, C + 5, y - 1, 'r');
    g.rect(C - 1, y - 5, C + 1, y - 1, 'D'); g.set(C, y - 6, 'D');
    g.hline(C - 5, C + 5, y - 8, 'W'); g.hline(C - 5, C + 5, y - base, 'W');
    g.set(C - 3, y - 11, 'o').set(C + 3, y - 11, 'o').set(C - 3, y - 10, 'o').set(C + 3, y - 10, 'o');
    y -= base;
    for (const x of [C - 5, C + 5]) { g.vline(x, y - 3, y - 1, 'W'); g.set(x, y - 4, 'Y'); }
    const clock = 7;
    g.rect(C - 4, y - clock, C + 4, y - 1, 'R'); g.rect(C + 3, y - clock, C + 4, y - 1, 'r');
    g.paste(['.YYY.', 'YVKVY', 'YVKKY', 'YVVVY', '.YYY.'], C - 2, y - clock + 1);
    g.hline(C - 4, C + 4, y - clock, 'W');
    y -= clock;
    for (const x of [C - 4, C + 4]) { g.vline(x, y - 2, y - 1, 'W'); g.set(x, y - 3, 'Y'); }
    const belfry = 5;
    g.rect(C - 3, y - belfry, C + 3, y - 1, 'R'); g.vline(C + 3, y - belfry, y - 1, 'r');
    for (const x of [C - 2, C, C + 2]) g.vline(x, y - 4, y - 2, 'D');
    g.hline(C - 3, C + 3, y - belfry, 'W');
    y -= belfry;
    g.rect(C - 2, y - 3, C + 2, y - 1, 'W'); g.vline(C + 2, y - 3, y - 1, 'w'); g.set(C - 1, y - 2, 'D'); g.set(C + 1, y - 2, 'D');
    y -= 3;
    const tent = 10;
    for (let i = 0; i < tent; i++) {
      const half = Math.round(2 - i * 2 / tent);
      const yy = y - 1 - i;
      for (let x = C - half; x <= C + half; x++) g.set(x, yy, x > C ? 'n' : 'N');
      if (i % 4 === 1 && half > 0) { g.set(C - half, yy, 'Y'); g.set(C + half, yy, 'Y'); }
    }
    y -= tent;
    g.set(C, y - 1, 'Y');
    g.paste(['.*.', '***', '*.*'], C - 1, y - 4);
    return g;
  }

  function stBasil() {
    const W = 30, H = 40, g = new Grid(W, H);
    g.rect(1, 30, 28, H - 1, 'R'); g.rect(25, 30, 28, H - 1, 'r');
    g.hline(1, 28, 30, 'W'); g.hline(1, 28, 35, 'W');
    for (let x = 3; x <= 26; x += 3) { g.vline(x, 32, 34, 'D'); g.vline(x, 37, H - 1, 'D'); }
    // Central tent with white dots, small gold onion on top.
    for (let i = 0; i < 17; i++) {
      const yy = 29 - i, half = Math.round(3.4 - i * 3.4 / 17);
      for (let x = 15 - half; x <= 15 + half; x++) g.set(x, yy, (x * 2 + yy) % 4 === 0 ? 'W' : x > 15 ? 'r' : 'R');
    }
    g.hline(12, 18, 29, 'W');
    onion(g, 15, 13, 4, 4, ['Y', null, 'y']);
    // Onion domes on drums.
    const domes = [
      [5, 27, 9, 10, ['R', 'N', 'r', 'n'], 6],
      [25, 27, 9, 10, ['U', 'W', 'u', 'w'], 6],
      [10, 29, 7, 8, ['Y', 'N', 'y', 'n'], 5],
      [20, 29, 7, 8, ['T', 'Y', 't', 'y'], 5],
    ];
    for (const [cx, base, w, h, mats, drum] of domes) {
      g.rect(cx - 2, base - drum, cx + 2, base + 1, 'W');
      g.vline(cx + 2, base - drum, base + 1, 'w');
      g.set(cx, base - 2, 'o'); g.set(cx, base - 3, 'o');
      g.hline(cx - 2, cx + 2, base - drum, 'R');
      onion(g, cx, base - drum, w, h, mats);
    }
    return g;
  }

  /* Kremlin wall with swallowtail merlons. */
  function wall() {
    const W = 96, H = 14, g = new Grid(W, H);
    g.rect(0, 3, W - 1, H - 1, 'R');
    for (let x = 0; x < W; x++) {
      if (x % 4 !== 3) g.set(x, 2, 'R');
      if (x % 4 === 0 || x % 4 === 2) g.set(x, 1, 'R');
      if (hash(x, 1, 9) % 7 === 0) g.set(x, 6 + hash(x, 2, 9) % 5, 'r');
    }
    g.hline(0, W - 1, 4, 'r');
    g.hline(0, W - 1, H - 2, 'r');
    return g;
  }

  function kremlinTower(h) {
    const g = new Grid(7, h + 9);
    const b = h + 9;
    g.rect(0, b - h, 6, b - 1, 'R'); g.vline(6, b - h, b - 1, 'r');
    g.hline(0, 6, b - h, 'W'); g.set(3, b - h + 3, 'o');
    for (let i = 0; i < 7; i++) {
      const half = Math.round(2 - i * 2 / 7), yy = b - h - 1 - i;
      for (let x = 3 - half; x <= 3 + half; x++) g.set(x, yy, x > 3 ? 'n' : 'N');
    }
    g.set(3, b - h - 8, 'Y'); g.set(3, b - h - 9, '*');
    return g.trim();
  }

  /* Behind the wall: the palace with a green roof and cathedrals with golden domes. */
  function inside() {
    const W = 48, H = 16, g = new Grid(W, H);
    g.rect(0, 8, 26, H - 1, 'C'); g.hline(0, 26, 7, 'N'); g.hline(1, 25, 6, 'n');
    for (let x = 2; x <= 24; x += 3) g.set(x, 10, 'o');
    g.dome(13.5, 6, 2.6, P.domePaint('N', 'n', null, 2.6)); g.set(13, 2, 'Y');
    g.rect(30, 9, 45, H - 1, 'W'); g.vline(45, 9, H - 1, 'w');
    for (const [cx, w, h] of [[33, 5, 6], [38, 7, 8], [43, 5, 6]]) {
      g.rect(cx - 1, 9 - 2, cx + 1, 9, 'W');
      onion(g, cx, 9 - 2, w, h, ['Y', null, 'y']);
    }
    for (let x = 32; x <= 44; x += 3) g.set(x, 11, 'o');
    return g;
  }

  function farCity() {
    const W = 60, H = 18, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 3 + hash(x, 1, 31) % 4, h = 4 + hash(x, 2, 31) % 8;
      g.rect(x, H - h, x + w - 1, H - 1, '3');
      for (let yy = H - h + 1; yy < H; yy += 2) for (let xx = x + 1; xx < x + w - 1; xx += 2) g.set(xx, yy, 'o');
      x += w + hash(x, 3, 31) % 3;
    }
    g.rect(40, 1, 43, H - 1, 'M'); g.vline(43, 1, H - 1, 'm'); g.set(41, 0, 'M');
    g.rect(46, 4, 49, H - 1, 'M'); g.vline(49, 4, H - 1, 'm');
    for (let yy = 3; yy < H; yy += 2) { g.set(41, yy, 'o'); g.set(47, yy + 1, 'o'); }
    return g;
  }

  function cobbles() {
    const W = 96, H = 18, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, (y % 3 === 2) || (x + (Math.floor(y / 3) % 2) * 3) % 6 === 0 ? 'g' : 'G');
    return g;
  }

  sprite('msk.spasskaya', spasskaya());
  sprite('msk.basil', stBasil());
  sprite('msk.wall', wall());
  sprite('msk.tower', kremlinTower(8));
  sprite('msk.inside', inside());
  sprite('msk.farCity', farCity());
  sprite('msk.cobbles', cobbles());
  sprite('msk.spruce', pine(12));

  return {
    horizon: 62, clouds: [9, 20, 31],
    ops: [
      ['spr', 'msk.farCity', 0, 58, 4, 0],
      ['spr', 'msk.inside', 6, 60, 2, 2],
      ['spr', 'msk.wall', 0, 68, 1, 0],
      ['spr', 'msk.tower', 2, 56, 2, 2],
      ['spr', 'msk.tower', 40, 56, 2, 2],
      ['spr', 'msk.basil', 69, 68, 1, 2],
      ['spr', 'msk.spasskaya', 56, 68, 1, 2],
      ['spr', 'msk.spruce', 13, 68, 1, 0],
      ['spr', 'msk.spruce', 29, 68, 1, 0],
      ['spr', 'msk.spruce', 47, 68, 1, 0],
      ['birds', 44, 3, 1.8],
      ['spr', 'msk.cobbles', 0, 86, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
