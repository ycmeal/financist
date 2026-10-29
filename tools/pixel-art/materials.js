/* Materials: char → [day color, kind]. Kinds: 0 solid, 1 window (lit at night), 2 lamp, 3 glows at night. */
const MAT = {
  V: [0xFFFFFF, 0], W: [0xF1EDE4, 0], w: [0xD3CCBE, 0], G: [0xB4BAC4, 0], g: [0x878E9A, 0],
  D: [0x575E6C, 0], K: [0x2B2F3A, 0],
  S: [0xE6D0A2, 0], s: [0xC6AA77, 0], A: [0xDDB47A, 0], a: [0xB98E55, 0], C: [0xF3E2C0, 0], c: [0xD6C095, 0],
  R: [0xC4473B, 0], r: [0x8F3029, 0], E: [0xDD7448, 0], e: [0xAE4E2E, 0], P: [0xEC8FA6, 0], p: [0xB9607A, 0],
  T: [0x3CBBCB, 0], t: [0x23899B, 0], U: [0x2F62B5, 0], u: [0x214689, 0], L: [0x95A5BA, 0], l: [0x6C7D95, 0],
  M: [0x8DB4D6, 0], m: [0x6189B0, 0], N: [0x57A86F, 0], n: [0x347A4F, 0],
  F: [0x6DAF55, 0], f: [0x478A3C, 0], H: [0x9ACF70, 0], I: [0x3F7A5B, 0], i: [0x2A5942, 0], J: [0x9CC46A, 0], j: [0x77A04D, 0],
  B: [0x9A6A44, 0], b: [0x6E4A2E, 0], X: [0x6B4B33, 0], Q: [0xEEEAE2, 0], q: [0x3D3A38, 0],
  Y: [0xF5C342, 0], y: [0xC28E23, 0], O: [0xFF9F43, 0],
  1: [0x8C8FAD, 0], 2: [0x6A6C8A, 0], 3: [0xB0B6CC, 0], 4: [0xA6E3E9, 0], 5: [0x63CBD6, 0],
  o: [0x86A9C8, 1], Z: [0xC9C5BA, 2], '*': [0xE5333F, 3], '+': [0xFFC23D, 3],
};

/* Clouds: h — lit top, x — body, s — shadow underneath. */
const CLOUDS = [
  ['.......hhhh.......', '....hhhxxxxh......', '...hxxxxxxxxhhh...', '.hhxxxxxxxxxxxxhh.', 'hxxxxxxxxxxxxxxxxh', '.sssxxxxxxxxxxsss.'],
  ['..........hhhh............', '.......hhhxxxxhh..........', '......hxxxxxxxxxh..hhh....', '...hhhxxxxxxxxxxxhhxxxh...',
    '..hxxxxxxxxxxxxxxxxxxxxhh.', '.hxxxxxxxxxxxxxxxxxxxxxxxh', '..sssssxxxxxxxxxxxxsssss..'],
  ['...hhh....', '.hhxxxhhh.', 'hxxxxxxxxh', '.ssssssss.'],
  ['.....hhhh...........', '..hhhxxxxhhhhhh.....', '.hxxxxxxxxxxxxxhhh..', 'ssssssssssssssssss..'],
];

module.exports = { MAT, CLOUDS };
