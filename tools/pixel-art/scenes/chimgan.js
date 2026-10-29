/* Chimgan: snowy Chatkal peaks over the turquoise Charvak reservoir, poplars, a dacha. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, hills, poplar, roundTree } = P;

  function foothills() {
    const g = hills(96, 16, [[8, 6, 24], [40, 3, 28], [74, 5, 30], [100, 2, 22]], ['j', 'a']);
    for (let y = 0; y < g.h; y++) for (let x = 0; x < g.w; x++) if (g.get(x, y) !== '.' && hash(x, y, 161) % 7 === 0) g.set(x, y, 'i');
    return g;
  }

  const dacha = Grid.from([
    '....eEEe....',
    '..eEEEEEEe..',
    'eEEEEEEEEEEe',
    '.WWoWWWWoWw.',
    '.WWoWWDWoWw.',
    '.WWWWWDWWWw.',
  ]);

  function meadow() {
    const W = 96, H = 16, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, hash(x, y, 163) % 13 === 0 ? 'j' : hash(x, y, 164) % 41 === 0 ? 'P' : 'J');
    return g;
  }

  sprite('chm.peaks', peaks(96, 38, [[16, 22, 22], [44, 12, 22], [74, 0, 30], [100, 8, 20]], { rock: '1', shade: '2', snowDepth: 9, seed: 17 }));
  sprite('chm.foothills', foothills());
  sprite('chm.dacha', dacha);
  sprite('chm.meadow', meadow());
  sprite('uz.poplar', poplar(16, 3));
  sprite('chm.poplar', poplar(12, 5));
  sprite('tree.big', roundTree(13, 14, 7));

  return {
    horizon: 60, clouds: [10, 22, 34],
    ops: [
      ['spr', 'chm.peaks', 0, 60, 3, 0],
      ['spr', 'chm.foothills', 0, 66, 2, 0],
      ['water', 62, 72, 0, 96, 1],
      ['spr', 'chm.meadow', 0, 86, 0, 0],
      ['spr', 'uz.poplar', 26, 72, 1, 0],
      ['spr', 'chm.poplar', 32, 72, 1, 0],
      ['spr', 'uz.poplar', 38, 72, 1, 0],
      ['spr', 'chm.dacha', 58, 74, 1, 0],
      ['spr', 'tree.big', 82, 76, 0, 0],
      ['birds', 46, 3, 1.4],
      ['flag', 5, 50, 76, 0],
    ],
  };
};
