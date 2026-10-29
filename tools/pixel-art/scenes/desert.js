/* Desert: dunes, a camel caravan, an oasis with palms, a Bedouin tent. Starry nights. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, dunes, palm, CAMEL } = P;

  function tent() {
    return Grid.from([
      '......bb......',
      '....bbBBbb....',
      '..bbBBBBBBbb..',
      'bbBBBBBBBBBBbb',
      '.BBRRBBBBRRBB.',
      '.BBBBBDDBBBBB.',
      '.BBBBBDDBBBBB.',
      '.bbbbbDDbbbbb.',
    ]);
  }

  sprite('des.far', dunes(96, 10, [[12, 2, 14], [44, 0, 18], [78, 3, 16], [104, 1, 14]], ['A', 'a'], 3));
  sprite('des.mid', dunes(96, 24, [[26, 4, 18], [60, 1, 20], [98, 5, 14]], ['A', 'a'], 5));
  sprite('des.near', dunes(96, 20, [[40, 6, 26], [100, 3, 24]], ['A', 'a'], 7));
  sprite('des.tent', tent());
  sprite('camel.0', CAMEL[0]);
  sprite('camel.1', CAMEL[1]);
  sprite('palm.big', palm(16, 1, 3, 0));
  sprite('palm.mid', palm(13, -1, 5, 0));
  sprite('palm.small', palm(9, 0, 8, 1));

  return {
    horizon: 62, clouds: [12],
    ops: [
      ['spr', 'des.far', 0, 62, 3, 0],
      ['spr', 'des.mid', 0, 78, 2, 0],
      ['water', 64, 68, 66, 92],
      ['spr', 'palm.mid', 62, 66, 1, 0],
      ['spr', 'palm.big', 74, 66, 1, 0],
      ['spr', 'palm.small', 86, 66, 1, 0],
      ['boat', ['camel.0', 'camel.1'], 66, 0.6, 20, 1, 2],
      ['boat', ['camel.1', 'camel.0'], 66, 0.6, 34, 1, 2],
      ['boat', ['camel.0', 'camel.1'], 66, 0.6, 48, 1, 2],
      ['spr', 'des.near', 0, 86, 0, 0],
      ['spr', 'des.tent', 12, 72, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
