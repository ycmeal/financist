/* Ephesus: the Library of Celsus, a marble street, cypresses. */
module.exports = ({ sprite, P }) => {
  const { Grid, hash, cypress, hills } = P;

  function celsus() {
    const W = 34, H = 31, g = new Grid(W, H);
    // Back walls.
    g.rect(1, 15, 32, 27, 'C'); g.rect(4, 3, 29, 13, 'C');
    for (let y = 15; y <= 27; y += 4) g.hline(1, 32, y, 'c');
    // Doors with frames.
    for (const [x0, x1, y0] of [[15, 18, 18], [7, 9, 20], [24, 26, 20]]) { g.rect(x0, y0, x1, 27, 'D'); g.hline(x0 - 1, x1 + 1, y0 - 1, 'W'); }
    // Statues in niches.
    for (const x of [4, 12, 21, 29]) { g.set(x, 23, 'S'); g.set(x, 24, 'S'); g.set(x, 25, 's'); g.set(x, 22, 's'); }
    // Lower columns in pairs.
    for (const x of [3, 5, 11, 13, 20, 22, 28, 30]) { g.vline(x, 16, 27, 'W'); g.set(x, 15, 'V'); }
    for (const [a, b] of [[2, 6], [10, 14], [19, 23], [27, 31]]) { g.hline(a, b, 14, 'W'); g.hline(a, b, 13, 'w'); }
    g.hline(1, 32, 12, 'W');
    // Upper columns and pediments.
    for (const x of [8, 10, 15, 18, 23, 25]) { g.vline(x, 4, 11, 'W'); g.set(x, 3, 'V'); }
    g.paste(['....W....', '..WWWWW..', 'WWWWWWWWW'], 12, 0);
    for (const x0 of [6, 21]) g.paste(['.WWWWW.', 'WWWWWWW'], x0, 1);
    for (let y = 4; y <= 11; y += 7) for (const x of [12, 21]) g.set(x, y, 'o');
    // Steps.
    g.hline(0, 33, 28, 'W'); g.hline(0, 33, 29, 'w'); g.hline(0, 33, 30, 'W');
    return g;
  }

  function street() {
    const W = 96, H = 14, g = new Grid(W, H);
    for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) g.set(x, y, y % 4 === 3 || (x + (Math.floor(y / 4) % 2) * 5) % 10 === 0 ? 'w' : 'W');
    return g;
  }

  /* Fallen column drums and stumps along the street. */
  function fragments() {
    const W = 50, H = 6, g = new Grid(W, H);
    for (const x of [0, 9, 17, 30, 41]) { g.vline(x, 1 + (x % 3), H - 1, 'W'); g.vline(x + 1, 1 + (x % 3), H - 1, 'w'); g.hline(x - 1, x + 2, 1 + (x % 3), 'V'); }
    g.rect(22, 3, 27, 5, 'W'); g.hline(22, 27, 5, 'w'); g.set(21, 4, 'w'); g.set(28, 4, 'w');
    return g;
  }

  sprite('eph.celsus', celsus());
  sprite('eph.street', street());
  sprite('eph.fragments', fragments());
  sprite('eph.hills', hills(96, 14, [[10, 3, 26], [46, 1, 30], [86, 4, 26]], ['j', 'f']));
  sprite('cypress.tall', cypress(14));
  sprite('cypress.mid', cypress(11));

  return {
    horizon: 62, clouds: [10, 24],
    ops: [
      ['spr', 'eph.hills', 0, 64, 3, 0],
      ['spr', 'eph.celsus', 58, 70, 1, 2],
      ['spr', 'cypress.tall', 46, 70, 1, 0],
      ['spr', 'cypress.mid', 51, 70, 1, 0],
      ['spr', 'cypress.tall', 93, 70, 1, 0],
      ['spr', 'eph.fragments', 10, 72, 1, 0],
      ['birds', 44, 3, 1.5],
      ['spr', 'eph.street', 0, 86, 0, 0],
      ['flag', 5, 50, 72, 0],
    ],
  };
};
