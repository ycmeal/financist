/* Tian Shan / Caucasus: snowy peaks, a turquoise lake, spruces, yurts and horses on the meadow. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, peaks, pine, hills, roundTree } = P;

  const yurt = Grid.from([
    '...WWW...',
    '.WWWWWWw.',
    'WWWWWWWww',
    'RYRYRYRYr',
    'WWWDDWWww',
    'WWWDDWWww',
  ]);
  const horse = Grid.from([
    'bBBBBb..',
    '.BBBBBBb',
    '.B..B..B',
    '.b..b...',
  ]);

  function appleTree() {
    const g = roundTree(7, 8, 9);
    for (const [x, y] of [[1, 2], [4, 1], [5, 4], [2, 4]]) g.set(x, y, 'R');
    return g;
  }

  function meadow() {
    const W = 96, H = 18, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, hash(x, y, 141) % 11 === 0 ? 'j' : hash(x, y, 142) % 37 === 0 ? 'Y' : 'J');
    return g;
  }

  sprite('mnt.peaks', peaks(96, 40, [[10, 20, 22], [36, 14, 20], [62, 2, 24], [84, 0, 22], [104, 10, 16]],
    { rock: '1', shade: '2', snowDepth: 11, seed: 11 }));
  sprite('mnt.foothills', hills(96, 14, [[6, 4, 24], [40, 2, 26], [76, 5, 28], [100, 3, 20]], ['j', 'f']));
  sprite('mnt.spruce', pine(13));
  sprite('mnt.spruceSmall', pine(9));
  sprite('mnt.yurt', yurt);
  sprite('mnt.horse', horse);
  sprite('mnt.apple', appleTree());
  sprite('mnt.meadow', meadow());

  return {
    horizon: 62, clouds: [10, 22, 34],
    ops: [
      ['spr', 'mnt.peaks', 0, 62, 3, 0],
      ['spr', 'mnt.foothills', 0, 66, 2, 0],
      ['spr', 'mnt.spruce', 58, 64, 2, 0],
      ['spr', 'mnt.spruceSmall', 66, 64, 2, 0],
      ['spr', 'mnt.spruce', 88, 65, 2, 0],
      ['water', 64, 69, 30, 96, 1],
      ['spr', 'mnt.meadow', 0, 87, 1, 0],
      ['spr', 'mnt.yurt', 60, 75, 1, 0],
      ['spr', 'mnt.yurt', 74, 74, 1, 0],
      ['spr', 'mnt.horse', 40, 75, 1, 0],
      ['spr', 'mnt.horse', 86, 77, 0, 1],
      ['spr', 'mnt.apple', 24, 74, 1, 0],
      ['birds', 46, 3, 1.4],
      ['flag', 5, 50, 76, 0],
    ],
  };
};
