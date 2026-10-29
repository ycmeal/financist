/* Uzungöl: a mountain lake on the Black Sea coast, a white mosque with two minarets, wooden houses. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, pine, minaret } = P;

  function mountains() {
    const g = peaks(96, 40, [[6, 20, 24], [34, 24, 22], [70, 0, 30], [96, 6, 24]], { rock: 'I', shade: 'i', snow: 'f', snowShade: 'i', snowDepth: 0, seed: 41 });
    for (let y = 0; y < g.h; y++) for (let x = 0; x < g.w; x++) {
      const c = g.get(x, y);
      if (c !== '.' && hash(x, y, 43) % 4 === 0) g.set(x, y, c === 'I' ? 'F' : 'f');
    }
    return g;
  }

  function mosque() {
    const W = 26, H = 32, C = 13, g = new Grid(W, H);
    g.rect(4, 19, 21, H - 1, 'W'); g.vline(21, 19, H - 1, 'w');
    for (let x = 6; x <= 19; x += 3) { g.set(x, 23, 'o'); g.set(x, 24, 'o'); g.set(x, 27, 'o'); g.set(x, 28, 'o'); }
    g.rect(C - 1, 27, C + 1, H - 1, 'D');
    for (let i = 0; i < 6; i++) g.hline(3 + i, 22 - i, 18 - i, i === 5 ? 'D' : 'K');
    g.dome(C, 13, 2.5, P.domePaint('L', 'l', null, 2.5)); g.set(C - 1, 10, 'Y');
    minaret(g, 2, 2, H, [9, 15]);
    minaret(g, 23, 2, H, [9, 15]);
    return g;
  }

  const house = Grid.from(['...GGGG...', '.GGGGGGGG.', 'GGGGGGGGGG', '.BBoBBoBB.', '.BBBBBBBb.', '.BBoBBDBb.']);

  const pier = Grid.from(['BBBBBBBBBBBBBB', 'b..b...b...b..', 'b..b...b...b..']);

  sprite('uzg.mountains', mountains());
  sprite('uzg.mosque', mosque());
  sprite('uzg.house', house);
  sprite('uzg.pier', pier);
  sprite('uzg.pine', pine(13));
  sprite('uzg.pineSmall', pine(9));

  return {
    horizon: 58, clouds: [10, 22, 33],
    ops: [
      ['spr', 'uzg.mountains', 0, 62, 3, 0],
      ['spr', 'uzg.house', 40, 60, 2, 0],
      ['spr', 'uzg.house', 52, 58, 2, 0],
      ['spr', 'uzg.house', 86, 61, 2, 0],
      ['water', 60, 78],
      ['spr', 'uzg.mosque', 60, 66, 1, 2],
      ['spr', 'uzg.pier', 44, 70, 1, 0],
      ['spr', 'uzg.pine', 26, 70, 1, 0],
      ['spr', 'uzg.pineSmall', 33, 70, 1, 0],
      ['spr', 'uzg.pine', 90, 72, 0, 0],
      ['birds', 46, 3, 1.4],
      ['flag', 5, 50, 74, 0],
    ],
  };
};
