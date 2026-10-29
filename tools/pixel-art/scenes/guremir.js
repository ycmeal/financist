/* Samarkand, Gur-e-Amir: Timur's mausoleum with the ribbed turquoise dome on a tiled drum. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, roundTree } = P;

  function mausoleum() {
    const W = 40, H = 46, C = 19.5, g = new Grid(W, H);
    // Base with tile panels and the portal niche.
    g.rect(5, 31, 34, H - 1, 'A'); g.vline(34, 31, H - 1, 'a'); g.hline(5, 34, 31, 'T');
    for (const x0 of [7, 27]) { g.rect(x0, 34, x0 + 5, H - 3, 'U'); for (let y = 35; y < H - 3; y += 2) for (let x = x0 + 1; x < x0 + 5; x += 2) g.set(x + (y % 4 === 1 ? 1 : 0), y, 'T'); }
    for (let y = 34; y < H; y++) { const half = y < 36 ? [1, 2][y - 34] : 3; for (let x = Math.round(C - half); x <= Math.round(C + half) - 1; x++) g.set(x, y, 'U'); }
    g.rect(18, H - 5, 21, H - 1, 'D');
    // Drum: patterned tiles, white inscription band on top.
    g.rect(11, 18, 28, 30, 'U'); g.vline(28, 18, 30, 'u');
    for (let y = 21; y <= 29; y++) for (let x = 11; x <= 28; x++) if ((x + y) % 4 === 0 || (x - y + 40) % 4 === 0) g.set(x, y, x > 25 ? 't' : 'T');
    g.hline(11, 28, 18, 'W'); g.hline(11, 28, 19, 'W'); for (let x = 12; x <= 27; x += 2) g.set(x, 19, 'U');
    g.hline(10, 29, 20, 'T');
    // Ribbed melon dome, a little wider than the drum, with a gold finial.
    for (let y = 3; y <= 17; y++) {
      const k = (y - 3) / 14, half = 11 * Math.sqrt(Math.max(0, 1 - Math.pow(1 - k, 2))) * (y > 14 ? 0.96 : 1);
      for (let x = Math.round(C - half); x <= Math.round(C + half) - 1; x++) {
        const rib = Math.abs(Math.round(x - C + 0.5)) % 2 === 0;
        const right = x > C + half * 0.4;
        g.set(x, y, right ? (rib ? 'u' : 't') : (x < C - half * 0.3 && y < 9 ? 'V' : rib ? 't' : 'T'));
      }
    }
    g.hline(9, 30, 17, 'T');
    g.set(19, 2, 'Y'); g.set(20, 2, 'Y'); g.set(19, 1, 'Y'); g.set(19, 0, 'y');
    // Two thick tiled minarets.
    for (const x0 of [0, 35]) {
      for (let y = 16; y < H; y++) for (let x = x0; x < x0 + 4; x++) {
        const band = y % 5 === 0 ? 'T' : y % 5 === 2 ? 'U' : null;
        g.set(x, y, band ? (x === x0 + 3 ? band.toLowerCase() : band) : (x === x0 + 3 ? 'a' : 'A'));
      }
      g.hline(x0 - 1, x0 + 4, 15, 'A'); g.hline(x0 - 1, x0 + 4, 16, 'T');
    }
    return g;
  }

  function paving() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y % 4 === 3 || (x + (Math.floor(y / 4) % 2) * 3) % 6 === 0 ? 's' : 'S');
    return g;
  }

  sprite('gur.mausoleum', mausoleum());
  sprite('gur.paving', paving());
  sprite('tree.big', roundTree(13, 14, 7));
  sprite('tree.round', roundTree(9, 10, 4));

  return {
    horizon: 62, clouds: [9, 21, 33],
    ops: [
      ['spr', 'gur.mausoleum', 56, 70, 1, 2],
      ['spr', 'tree.big', 34, 70, 1, 0],
      ['spr', 'tree.round', 46, 70, 1, 0],
      ['spr', 'tree.round', 92, 72, 0, 0],
      ['birds', 46, 3, 1.5],
      ['spr', 'gur.paving', 0, 86, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
