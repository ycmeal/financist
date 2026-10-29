/* Dev-only helpers to draw sprites as character grids. Not shipped: only their output is. */
class Grid {
  constructor(w, h, fill = '.') {
    this.w = w; this.h = h;
    this.a = Array.from({ length: h }, () => Array(w).fill(fill));
  }
  static from(rows) {
    const g = new Grid(rows[0].length, rows.length);
    rows.forEach((r, y) => [...r].forEach((c, x) => { g.a[y][x] = c; }));
    return g;
  }
  in(x, y) { return x >= 0 && x < this.w && y >= 0 && y < this.h; }
  set(x, y, c) { x = Math.round(x); y = Math.round(y); if (this.in(x, y) && c != null) this.a[y][x] = c; return this; }
  get(x, y) { return this.in(x, y) ? this.a[y][x] : '.'; }
  /* Inclusive rectangle. */
  rect(x0, y0, x1, y1, c) { for (let y = y0; y <= y1; y++) for (let x = x0; x <= x1; x++) this.set(x, y, typeof c === 'function' ? c(x, y) : c); return this; }
  hline(x0, x1, y, c) { return this.rect(x0, y, x1, y, c); }
  vline(x, y0, y1, c) { return this.rect(x, y0, x, y1, c); }
  /* Paste another grid or rows; '.' stays transparent. */
  paste(src, x0, y0, flip = false) {
    const rows = src instanceof Grid ? src.rows() : src;
    rows.forEach((r, dy) => [...r].forEach((c, dx) => {
      const cx = flip ? r.length - 1 - dx : dx;
      const ch = r[cx];
      if (ch !== '.') this.set(x0 + dx, y0 + dy, ch);
    }));
    return this;
  }
  /* Paste with the bottom-left corner at (x0, bottom - 1). */
  place(src, x0, bottom, flip = false) {
    const rows = src instanceof Grid ? src.rows() : src;
    return this.paste(rows, x0, bottom - rows.length, flip);
  }
  /* Upper half-disc standing on row `base` (exclusive), centered between pixels when cx has .5. */
  dome(cx, base, r, paint) {
    for (let y = Math.floor(base - r - 1); y < base; y++)
      for (let x = Math.floor(cx - r - 1); x <= Math.ceil(cx + r + 1); x++) {
        const dx = x + 0.5 - cx, dy = y + 0.5 - base;
        if (dx * dx + dy * dy <= r * r) this.set(x, y, typeof paint === 'function' ? paint(dx, dy, x, y) : paint);
      }
    return this;
  }
  /* Ellipse with center (cx, cy). */
  ellipse(cx, cy, rx, ry, paint) {
    for (let y = Math.floor(cy - ry - 1); y <= Math.ceil(cy + ry + 1); y++)
      for (let x = Math.floor(cx - rx - 1); x <= Math.ceil(cx + rx + 1); x++) {
        const dx = (x + 0.5 - cx) / rx, dy = (y + 0.5 - cy) / ry;
        if (dx * dx + dy * dy <= 1) this.set(x, y, typeof paint === 'function' ? paint(dx, dy, x, y) : paint);
      }
    return this;
  }
  rows() { return this.a.map(r => r.join('')); }
  /* Drop empty columns/rows around (keeps the bottom so sprites stay on the ground). */
  trim() {
    let x0 = this.w, x1 = -1, y0 = this.h;
    for (let y = 0; y < this.h; y++) for (let x = 0; x < this.w; x++) if (this.a[y][x] !== '.') {
      x0 = Math.min(x0, x); x1 = Math.max(x1, x); y0 = Math.min(y0, y);
    }
    const g = new Grid(x1 - x0 + 1, this.h - y0);
    for (let y = y0; y < this.h; y++) for (let x = x0; x <= x1; x++) g.a[y - y0][x - x0] = this.a[y][x];
    return g;
  }
  flip() { const g = new Grid(this.w, this.h); for (let y = 0; y < this.h; y++) for (let x = 0; x < this.w; x++) g.a[y][x] = this.a[y][this.w - 1 - x]; return g; }
  replace(map) { for (let y = 0; y < this.h; y++) for (let x = 0; x < this.w; x++) if (map[this.a[y][x]] !== undefined) this.a[y][x] = map[this.a[y][x]]; return this; }
}

/* Same hash as the runtime, for deterministic builder noise. */
function hash(x, y, s) {
  let h = (Math.imul(x, 374761393) + Math.imul(y, 668265263) + Math.imul(s, 2147483647)) | 0;
  h = Math.imul(h ^ (h >>> 13), 1274126177);
  return (h ^ (h >>> 16)) >>> 0;
}

/* Shaded dome paint: light from the upper left. */
const domePaint = (base, shade, light, r) => (dx, dy) => {
  if (dx > r * 0.35) return shade;
  if (light && dx < -r * 0.2 && dy < -r * 0.45) return light;
  return base;
};

module.exports = { Grid, hash, domePaint };
