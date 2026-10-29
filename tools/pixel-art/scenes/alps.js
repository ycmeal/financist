/* The Alps: snowy peaks, a lake, chalets and a church with a green spire, a flowering meadow. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, pine, hills } = P;

  function chalet(seed) {
    return Grid.from([
      '....eEEe....',
      '..eEEEEEEe..',
      'eEEEEEEEEEEe',
      '.bBBoBBoBBb.',
      '.bBBBBBBBBb.',
      '.WWoWWWWoWw.',
      '.WWWWWDWWWw.',
      '.WWWWWDWWWw.',
    ]);
  }

  function church() {
    const g = new Grid(13, 22);
    g.rect(0, 14, 9, 21, 'W'); g.vline(9, 14, 21, 'w');
    for (let i = 0; i < 4; i++) g.hline(i, 9 - i, 13 - i, i === 3 ? 'e' : 'E');
    g.set(2, 17, 'o'); g.set(2, 18, 'o'); g.set(6, 17, 'o'); g.set(6, 18, 'o');
    g.rect(9, 6, 12, 21, 'W'); g.vline(12, 6, 21, 'w');
    g.paste(['.Y.', 'YKY', '.Y.'], 9, 8); g.set(10, 13, 'D'); g.set(11, 13, 'D');
    for (let i = 0; i < 6; i++) { const y = 5 - i; if (i < 2) g.hline(9, 12, y, i === 0 ? 'n' : 'N'); else g.hline(10, 11, y, 'N'); }
    g.set(10, 0, 'N'); g.set(10, -1, 'Y');
    g.hline(10, 11, 1, 'N'); g.set(11, 2, 'n'); g.set(11, 3, 'n');
    return g;
  }

  function forest() {
    const W = 96, H = 14, g = hills(96, 14, [[10, 3, 26], [44, 5, 30], [84, 2, 28]], ['I', 'i']);
    for (let x = 0; x < W; x++) for (let y = 0; y < H; y++) if (g.get(x, y) !== '.' && hash(x, y, 121) % 5 === 0) g.set(x, y, 'f');
    return g;
  }

  function meadow() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
      const v = hash(x, y, 123) % 43;
      g.set(x, y, v === 0 ? 'P' : v === 1 ? 'Y' : v === 2 ? 'W' : v < 9 ? 'j' : 'J');
    }
    return g;
  }

  sprite('alp.peaks', peaks(96, 38, [[22, 18, 22], [46, 12, 20], [70, 0, 24], [90, 8, 18], [104, 14, 16]],
    { rock: '1', shade: '2', snowDepth: 9, seed: 7 }));
  sprite('alp.forest', forest());
  sprite('alp.chalet', chalet(1));
  sprite('alp.church', church());
  sprite('alp.meadow', meadow());
  sprite('alp.pine', pine(11));

  return {
    horizon: 62, clouds: [10, 21, 36],
    ops: [
      ['spr', 'alp.peaks', 0, 62, 3, 0],
      ['spr', 'alp.forest', 0, 66, 2, 0],
      ['water', 64, 72],
      ['spr', 'alp.church', 64, 66, 1, 2],
      ['spr', 'alp.chalet', 78, 66, 1, 0],
      ['spr', 'alp.chalet', 50, 66, 1, 0],
      ['spr', 'alp.pine', 90, 67, 1, 0],
      ['spr', 'alp.pine', 40, 67, 1, 0],
      ['birds', 46, 3, 1.6],
      ['spr', 'alp.meadow', 0, 86, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
