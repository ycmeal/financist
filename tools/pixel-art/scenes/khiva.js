/* Khiva: Itchan Kala clay walls, the tall Islam Khodja minaret, the tiled Kalta Minor, green domes. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, ribbedDome, poplar, CAMEL } = P;

  function islamKhodja() {
    const H = 44, W = 9, g = new Grid(W, H), C = 4;
    for (let y = 8; y < H; y++) {
      const half = 1.6 + (y - 8) / (H - 8) * 2.4;
      const band = y % 6 === 0 ? 'T' : y % 6 === 3 ? 'W' : null;
      for (let x = Math.round(C - half); x <= Math.round(C + half); x++) {
        const right = x > C + half * 0.3;
        g.set(x, y, band ? (band === 'T' ? (right ? 't' : 'T') : (right ? 'w' : 'W')) : (right ? 'a' : 'A'));
      }
    }
    g.hline(C - 3, C + 3, 7, 'T'); g.hline(C - 3, C + 3, 6, 'A'); g.hline(C - 3, C + 3, 5, 'A');
    g.set(C - 2, 5, 'D'); g.set(C, 5, 'D'); g.set(C + 2, 5, 'D'); g.vline(C + 3, 5, 6, 'a');
    g.hline(C - 3, C + 3, 4, 'T');
    g.hline(C - 1, C + 1, 3, 'T'); g.set(C + 1, 3, 't'); g.set(C, 2, 'T'); g.set(C, 1, 'Y'); g.set(C, 0, 'Y');
    return g;
  }

  function kaltaMinor() {
    const W = 15, H = 22, g = new Grid(W, H), C = 7;
    const bands = ['T', 'W', 'U', 'U', 'T', 'T', 'W', 'N', 'N', 'U', 'U', 'W', 'T', 'T', 'N', 'U', 'U', 'W', 'T', 'T', 'U', 'U'];
    for (let y = 0; y < H; y++) {
      const half = 5 + y / H * 2;
      const m = bands[y];
      for (let x = Math.round(C - half); x <= Math.round(C + half); x++) {
        const right = x > C + half * 0.35;
        let ch = m === 'U' && (x + y) % 3 === 0 ? 'T' : m;
        if (right) ch = { T: 't', W: 'w', U: 'u', N: 'n' }[ch];
        g.set(x, y, ch);
      }
    }
    g.hline(C - 5, C + 5, 0, 'T'); g.set(C, H - 3, 'D'); g.set(C, H - 2, 'D'); g.set(C, H - 1, 'D');
    return g;
  }

  /* Inside the walls: flat clay houses, a green dome with a gold top, small turquoise domes. */
  function oldTown() {
    const W = 60, H = 22, g = new Grid(W, H);
    let x = 0;
    while (x < W) {
      const w = 4 + hash(x, 1, 81) % 5, h = 4 + hash(x, 2, 81) % 4;
      g.rect(x, H - h, x + w - 1, H - 1, 'A'); g.vline(x + w - 1, H - h, H - 1, 'a');
      g.hline(x, x + w - 1, H - h, 'S');
      if (hash(x, 3, 81) % 2) g.set(x + 1, H - h + 2, 'o');
      x += w;
    }
    g.rect(8, 9, 20, H - 1, 'A'); g.vline(20, 9, H - 1, 'a'); g.hline(8, 20, 9, 'T');
    ribbedDome(g, 14.5, 9, 6, ['N', 'n', 'H']); g.set(14, 2, 'Y'); g.set(14, 1, 'Y');
    for (const cx of [30.5, 46.5]) { g.rect(Math.floor(cx) - 3, 14, Math.floor(cx) + 3, H - 1, 'A'); ribbedDome(g, cx, 14, 3.2); }
    return g;
  }

  /* Itchan Kala wall: rounded bastions and merlons. */
  function wall() {
    const W = 96, H = 16, g = new Grid(W, H);
    g.rect(0, 6, W - 1, H - 1, 'A');
    g.hline(0, W - 1, 6, 'a');
    for (let x = 0; x < W; x++) {
      if (x % 3 !== 2) g.set(x, 5, 'A');
      if (x % 3 === 0) g.set(x, 4, 'A');
      if (hash(x, 1, 91) % 9 === 0) g.set(x, 9 + hash(x, 2, 91) % 5, 'a');
    }
    for (const bx of [10, 32, 54, 76, 94]) {
      for (let y = 2; y < H; y++) for (let x = bx - 3; x <= bx + 3; x++) g.set(x, y, x < bx - 1 ? 'S' : x > bx + 1 ? 'a' : 'A');
      for (let x = bx - 3; x <= bx + 3; x += 2) g.set(x, 1, x > bx + 1 ? 'a' : 'A');
      g.vline(bx + 4, 7, H - 1, 'a');
    }
    g.hline(0, W - 1, H - 1, 'a');
    return g;
  }

  function ground() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y < 1 ? 'a' : hash(x, y, 93) % 17 === 0 ? 's' : 'S');
    return g;
  }

  sprite('khv.minaret', islamKhodja());
  sprite('khv.kalta', kaltaMinor());
  sprite('khv.town', oldTown());
  sprite('khv.wall', wall());
  sprite('khv.ground', ground());
  sprite('uz.poplar', poplar(16, 3));

  return {
    horizon: 62, clouds: [10, 23],
    ops: [
      ['spr', 'khv.town', 36, 60, 2, 2],
      ['spr', 'khv.minaret', 62, 60, 2, 2],
      ['spr', 'khv.kalta', 78, 60, 1, 2],
      ['spr', 'khv.wall', 0, 70, 1, 0],
      ['spr', 'uz.poplar', 22, 70, 1, 0],
      ['spr', 'uz.poplar', 28, 70, 1, 0],
      ['birds', 45, 3, 1.5],
      ['spr', 'khv.ground', 0, 86, 0, 0],
      ['flag', 5, 50, 70, 0],
    ],
  };
};
