/* Russian countryside: log houses with carved windows, birches, a river with a boat, a windmill. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, birch, pine, hills } = P;

  function izba(roof) {
    const g = Grid.from([
      '......ee......',
      '.....eEEe.....',
      '....eEEEEe....',
      '...eEEWoEEe...',
      '..eEEEEEEEEe..',
      '.eEEEEEEEEEEe.',
      'eeeeeeeeeeeeee',
      '.BBBBBBBBBBBb.',
      '.bbbbbbbbbbbb.',
      '.BWWWBBBBWWWb.',
      '.bWoWbbbbWoWb.',
      '.BWoWBBBBWoWb.',
      '.bWWWbbbbWWWb.',
      '.BBBBBBBBBBBb.',
    ]);
    return roof === 'E' ? g : g.replace({ E: roof, e: roof.toLowerCase() });
  }

  const millBody = [
    '....bBBb....',
    '...bBBBBb...',
    '..bBBBBBBb..',
    '...BBBBBb...',
    '...BBoBBb...',
    '...BBBBBb...',
    '..BBBBBBBb..',
    '..BBBDBBBb..',
    '..BBBDBBBb..',
  ];
  function mill(frame) {
    const g = new Grid(19, 19);
    g.place(millBody, 4, 19);
    const hub = [9, 11];
    const arms = frame === 0 ? [[0, -1], [0, 1], [-1, 0], [1, 0]] : [[-1, -1], [1, 1], [-1, 1], [1, -1]];
    for (const [dx, dy] of arms) for (let s = 1; s <= 8; s++) {
      const x = hub[0] + dx * s, y = hub[1] + dy * s * (dx && dy ? 1 : 1);
      if (frame === 1 && s > 6) continue;
      g.set(x, y, s > 2 ? 'B' : 'b');
      if (s > 2) g.set(x + (dy ? 1 : 0), y + (dx && !dy ? 1 : 0), s % 2 ? 'W' : 'w');
    }
    g.set(hub[0], hub[1], 'b');
    return g;
  }

  function forest() {
    const W = 96, H = 12, g = new Grid(W, H);
    for (let x = 0; x < W; x++) {
      const t = 3 + (hash(x, 1, 101) % 4) + Math.round(Math.cos(x / 9) * 1.5);
      const peak = x % 3 === 1 ? t - 1 : t;
      for (let y = peak; y < H; y++) g.set(x, y, x % 3 === 2 ? 'i' : 'I');
    }
    return g;
  }

  function haystack() {
    return Grid.from(['..yYy..', '.yYYYy.', 'yYYYYYy', 'YYYYYYy', 'YYYYYyy']);
  }

  function fence(w) {
    const g = new Grid(w, 4);
    for (let x = 0; x < w; x++) { g.set(x, 1, 'B'); if (x % 2 === 0) { g.set(x, 0, 'B'); g.set(x, 2, 'b'); g.set(x, 3, 'b'); } }
    return g;
  }

  function meadow() {
    const W = 96, H = 18, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
      const v = hash(x, y, 103) % 41;
      g.set(x, y, v === 0 ? 'Y' : v === 1 ? 'W' : v < 7 ? 'j' : 'J');
    }
    return g;
  }

  const rowboat = Grid.from(['...b......', 'BBBBBBBBBB', '.bbbbbbbb.']);

  sprite('vil.forest', forest());
  sprite('vil.hills', hills(96, 10, [[16, 2, 30], [60, 4, 34], [96, 1, 24]]));
  sprite('vil.izba', izba('E'));
  sprite('vil.izbaGreen', izba('N'));
  sprite('vil.izbaGrey', izba('G'));
  sprite('vil.mill.0', mill(0));
  sprite('vil.mill.1', mill(1));
  sprite('vil.birch', birch(18, 7));
  sprite('vil.birchSmall', birch(13, 9));
  sprite('vil.hay', haystack());
  sprite('vil.fence', fence(26));
  sprite('vil.meadow', meadow());
  sprite('vil.boat', rowboat);

  return {
    horizon: 60, clouds: [9, 20, 32],
    ops: [
      ['spr', 'vil.forest', 0, 58, 3, 0],
      ['spr', 'vil.hills', 0, 64, 2, 0],
      ['anim', ['vil.mill.0', 'vil.mill.1'], 44, 62, 2, 1],
      ['spr', 'vil.izbaGrey', 58, 64, 1, 0],
      ['spr', 'vil.izba', 72, 65, 1, 0],
      ['spr', 'vil.izbaGreen', 84, 66, 1, 0],
      ['spr', 'vil.hay', 30, 63, 2, 0],
      ['spr', 'vil.fence', 60, 67, 1, 0],
      ['water', 66, 74],
      ['boat', 'vil.boat', 71, 0.5, 10, 0],
      ['spr', 'vil.birch', 22, 66, 1, 0],
      ['spr', 'vil.birchSmall', 52, 66, 1, 0],
      ['birds', 48, 4, 1.8],
      ['spr', 'vil.meadow', 0, 88, 0, 0],
      ['flag', 5, 50, 74, 0],
    ],
  };
};
