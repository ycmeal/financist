/* Pixel scenes for the «Траты» header, 96×84. Same algorithm as PixelCity.swift: change both. */
const PixelCity = ((D) => {
  const COLS = 96, ROWS = 84, FLAG_W = 15, FLAG_H = 10;
  const { MAT, SPR, SCENES, CLOUDS } = D;
  const floor = Math.floor;

  /* Light for each part of the day. Shapes get `tint`; far ones blend into `haze`. */
  const LIGHT = {
    day: {
      sky: [0x4FA3E3, 0x63AEE8, 0x79BAEC, 0x8FC6F0, 0xA6D2F3, 0xBEDEF5],
      tint: [1, 1, 1], flood: [1, 1, 1], flagTint: [1, 1, 1], haze: 0xBEDEF5, hazeK: 0.6,
      sun: 0xFFE27A, sunHi: 0xFFF8D6, glow: 0, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xBEDEF5,
      cloud: [0xFFFFFF, 0xF1F7FB, 0xD2E3EF],
      water: [0x8CC6E8, 0x5DA2D2, 0x4686BE], lagoon: [0x8FE0E0, 0x4CC3D2, 0x2E9FBF], foam: 0xDDF0FA, glint: 0xFFF7D8,
      windows: 0, lamp: 0xFFD877, lamp2: 0xFFE9A6, bird: 0x3E4A5C,
    },
    dawn: {
      sky: [0x5767B4, 0x7676C0, 0x9C86C6, 0xC898C0, 0xEDAFAA, 0xFFCC9E],
      tint: [0.96, 0.84, 0.88], flood: [0.96, 0.84, 0.88], flagTint: [0.98, 0.9, 0.92], haze: 0xF2BBA8, hazeK: 0.55,
      sun: 0xFFB869, sunHi: 0xFFE3B0, glow: 0xFFD8A8, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xC9C6EC,
      cloud: [0xFFEDE6, 0xFFD6CF, 0xE6AFB6],
      water: [0xEDB2A8, 0x9D8CC0, 0x7471AE], lagoon: [0xF0BDB0, 0x93A9C8, 0x6C86B4], foam: 0xFFE1D0, glint: 0xFFE2A8,
      windows: 30, lamp: 0xFFD877, lamp2: 0xFFE9A6, bird: 0x4B4766,
    },
    dusk: {
      sky: [0x2A2766, 0x45307C, 0x713C8A, 0xA84B82, 0xDA6670, 0xFF9662],
      tint: [0.8, 0.6, 0.7], flood: [0.8, 0.6, 0.7], flagTint: [0.92, 0.8, 0.84], haze: 0xE07872, hazeK: 0.5,
      sun: 0xFF7A3D, sunHi: 0xFFC07A, glow: 0xFFAE6E, moon: 0xF4F1DE, moonShade: 0xC9C5A8, star: 0xFFFFFF, starDim: 0xB9A6D6,
      cloud: [0xFFB59A, 0xF08E8A, 0xB0607E],
      water: [0xE8806E, 0x8A4E84, 0x4F3A74], lagoon: [0xE9907A, 0x7E6596, 0x4B4A7E], foam: 0xFFB384, glint: 0xFFC27E,
      windows: 50, lamp: 0xFFD06A, lamp2: 0xFFE39A, bird: 0x3A2C4E,
    },
    night: {
      sky: [0x050920, 0x09102C, 0x0E1739, 0x141F47, 0x1A2856, 0x223266],
      tint: [0.22, 0.26, 0.42], flood: [0.62, 0.52, 0.4], flagTint: [0.72, 0.7, 0.72], haze: 0x223266, hazeK: 0.45,
      sun: 0xFFE27A, sunHi: 0xFFF8D6, glow: 0, moon: 0xF5F2DC, moonShade: 0xC8C4A6, star: 0xFFFFFF, starDim: 0x8FA2DA,
      cloud: [0x2E3B6E, 0x253260, 0x1C2850],
      water: [0x1D2B5A, 0x152149, 0x0F1838], lagoon: [0x1B3460, 0x15294F, 0x0F1E3E], foam: 0x33467E, glint: 0xCFD3B8,
      windows: 45, lamp: 0xFFD46A, lamp2: 0xFFE6A0, bird: 0,
    },
  };

  /* Stable pseudo-random number for a cell. */
  function hash(x, y, s) {
    let h = (Math.imul(x, 374761393) + Math.imul(y, 668265263) + Math.imul(s, 2147483647)) | 0;
    h = Math.imul(h ^ (h >>> 13), 1274126177);
    return (h ^ (h >>> 16)) >>> 0;
  }

  const channel = (c, k) => (c >>> k) & 255;
  const pack = (r, g, b) => (floor(r + 0.5) << 16) | (floor(g + 0.5) << 8) | floor(b + 0.5);
  /* a → b by k (0…1). */
  function mix(a, b, k) {
    const r = channel(a, 16), g = channel(a, 8), bl = channel(a, 0);
    return pack(r + (channel(b, 16) - r) * k, g + (channel(b, 8) - g) * k, bl + (channel(b, 0) - bl) * k);
  }
  function multiply(c, m) {
    return pack(Math.min(255, channel(c, 16) * m[0]), Math.min(255, channel(c, 8) * m[1]), Math.min(255, channel(c, 0) * m[2]));
  }

  /* Flag cloth: rows move by WAVE, folds get lighter or darker. */
  const WAVE = [0, 1, 1, 1, 0, 0, -1, -1, -1, 0];
  const FOLD = [1.12, 1, 1, 0.86, 1, 0.86, 1, 1, 1.12, 1];

  /**
   * scene: id from SCENES; part: 'dawn' | 'day' | 'dusk' | 'night'; sun: 0…1 or null (then the moon);
   * flag: FLAG_W*FLAG_H colors or null; t: seconds since midnight; seed: number.
   */
  function render(sceneId, part, sun, flag, t, seed) {
    const L = LIGHT[part], S = SCENES[sceneId];
    const dark = part === 'dusk' || part === 'night';
    const px = new Uint32Array(COLS * ROWS);
    const set = (x, y, v) => { if (x >= 0 && x < COLS && y >= 0 && y < ROWS) px[y * COLS + x] = v; };

    // Sky: six bands down to the horizon, dithered where they meet.
    const H = S.horizon;
    const sky = (x, y) => {
      if (y >= H) return L.sky[5];
      const band = floor(y * 6 / H);
      const first = Math.ceil(band * H / 6);
      if (band > 0 && y === first && (x + y) % 2 === 0) return L.sky[band - 1];
      if (band > 0 && y === first + 1 && x % 4 === (y % 2) * 2) return L.sky[band - 1];
      return L.sky[band];
    };
    for (let y = 0; y < ROWS; y++) for (let x = 0; x < COLS; x++) set(x, y, sky(x, y));

    // Stars, below the status bar.
    if (sun == null) {
      for (let y = 13; y < H - 3; y++) for (let x = 0; x < COLS; x++) {
        const h = hash(x, y, seed);
        if (h % 61 === 0) set(x, y, ((h >>> 8) + floor(t * 1.5)) % 4 === 0 ? L.starDim : L.star);
        else if (h % 151 === 3) set(x, y, L.starDim);
      }
    }

    // Sun on an arc right of the greeting, or a crescent moon.
    const disk = (cx, cy, r, paint) => {
      for (let y = floor(cy - r - 1); y <= Math.ceil(cy + r + 1); y++)
        for (let x = floor(cx - r - 1); x <= Math.ceil(cx + r + 1); x++) {
          const dx = x + 0.5 - cx, dy = y + 0.5 - cy, d2 = dx * dx + dy * dy;
          if (d2 <= r * r) paint(x, y, dx, dy, d2);
        }
    };
    let glintX = null;
    if (sun != null) {
      const cx = 52 + 40 * sun, cy = 50 - 80 * sun * (1 - sun);
      const r = part === 'day' ? 3.5 : 4.5;
      if (L.glow) disk(cx, cy, r + 3, (x, y, dx, dy, d2) => {
        if (d2 <= (r + 1.5) * (r + 1.5) || (x + y) % 2 === 0) set(x, y, L.glow);
      });
      disk(cx, cy, r, (x, y, dx, dy) => set(x, y, dx + dy < -r * 0.6 ? L.sunHi : L.sun));
      glintX = cx;
    } else {
      const cx = 50, cy = 19, r = 3.5;
      disk(cx, cy, r, (x, y, dx) => set(x, y, dx > r * 0.35 ? L.moonShade : L.moon));
      disk(cx - 1.6, cy - 1.2, r * 0.93, (x, y) => set(x, y, sky(x, y)));
      glintX = cx;
    }

    // Clouds drift slowly to the right.
    S.clouds.forEach((row, i) => {
      const shape = CLOUDS[i % CLOUDS.length], w = shape[0].length, span = COLS + w;
      const x0 = floor(((hash(i, 3, seed) % span) + t / (2.5 + i)) % span) - w;
      shape.forEach((line, dy) => {
        for (let dx = 0; dx < w; dx++) {
          const k = 'hxs'.indexOf(line[dx]);
          if (k >= 0) set(x0 + dx, row + dy, L.cloud[k]);
        }
      });
    });

    // Shapes: material colors in this light, cached per depth.
    const cache = {};
    const color = (ch, depth, lit, x, y) => {
      const m = MAT[ch];
      if (m[1] === 1 && part !== 'day' && hash(x, y, seed + 7) % 100 < L.windows) {
        return hash(x, y, seed + 11) % 4 === 0 ? L.lamp2 : L.lamp;
      }
      if (m[1] === 2 && dark) return L.lamp;
      if (m[1] === 3 && dark) return m[0];
      const key = ch + depth + (lit ? '*' : '');
      if (cache[key] === undefined) {
        cache[key] = mix(multiply(m[0], lit ? L.flood : L.tint), L.haze, depth * L.hazeK / 4);
      }
      return cache[key];
    };
    const sprite = (rows, x0, bottom, depth, flags) => {
      const h = rows.length, w = rows[0].length;
      for (let dy = 0; dy < h; dy++) for (let dx = 0; dx < w; dx++) {
        const ch = rows[dy][flags & 1 ? w - 1 - dx : dx];
        if (ch !== '.') set(x0 + dx, bottom - h + dy, color(ch, depth, (flags & 2) !== 0, x0 + dx, bottom - h + dy));
      }
    };

    const frame = (names, fps) => typeof names === 'string' ? SPR[names] : SPR[names[floor(t * fps) % names.length]];

    for (const op of S.ops) {
      switch (op[0]) {
        case 'spr': sprite(SPR[op[1]], op[2], op[3], op[4], op[5]); break;
        case 'water': {
          // Water: lighter at the horizon, ripples drift, a glittering path under the sun or moon.
          const [, y0, y1, x0 = 0, x1 = COLS, style = 0] = op, n = y1 - y0;
          const tone = style === 1 ? L.lagoon : L.water;
          for (let y = y0; y < y1; y++) {
            const f = (y - y0) * 6 / n;
            for (let x = x0; x < x1; x++) {
              const band = f < 1 ? 0 : f < 3 ? 1 : 2;
              const edge = (f >= 1 && f < 1.5) || (f >= 3 && f < 3.5);
              set(x, y, tone[edge && (x + y) % 2 === 0 ? band - 1 : band]);
            }
          }
          for (let y = y0 + 1; y < y1; y++) {
            const dir = y % 2 === 0 ? 1 : -1, speed = 0.4 + (y % 3) * 0.3, count = 2 + floor((y - y0) / 4);
            for (let k = 0; k < count; k++) {
              const len = 2 + hash(k, y, seed) % 3, span = COLS + len;
              const p = floor(hash(y, k, seed + 3) % span + t * speed) % span;
              const start = dir > 0 ? p - len : COLS - p;
              for (let i = 0; i < len; i++) if (start + i >= x0 && start + i < x1) set(start + i, y, L.foam);
            }
          }
          if (glintX != null && glintX >= x0 && glintX < x1) {
            const step = floor(t * 3);
            for (let y = y0 + 1; y < y1; y++) {
              const half = 1 + floor((y - y0) / 6);
              for (let x = floor(glintX) - half; x <= floor(glintX) + half; x++) {
                if ((x * 3 + y + step) % 4 !== 0 && hash(x, y + step, seed) % 3 !== 0) set(x, y, L.glint);
              }
            }
          }
          break;
        }
        case 'boat': {
          // Sails across and comes back from the other side; negative speed goes left.
          // A list of names is a walk cycle: frames change `fps` times a second. dayOnly: not at night (paragliders).
          const [, names, bottom, speed, offset, depth, fps = 0, dayOnly = 0] = op;
          if (dayOnly && part === 'night') break;
          const rows = frame(names, fps), w = rows[0].length, span = COLS + w;
          const p = floor((offset + t * Math.abs(speed)) % span);
          sprite(rows, speed > 0 ? p - w : COLS - p, bottom, depth, speed > 0 ? 0 : 1);
          break;
        }
        case 'anim': {
          const [, names, x, bottom, depth, fps] = op;
          sprite(frame(names, fps), x, bottom, depth, 0);
          break;
        }
        case 'bob': {
          // Hot-air balloons: slowly up and down; they do not fly at night.
          if (part === 'night') break;
          const [, name, x, bottom, depth, amp, period] = op;
          const phase = floor(t / period) % (amp * 2);
          sprite(SPR[name], x, bottom - (phase < amp ? phase : amp * 2 - phase), depth, 0);
          break;
        }
        case 'sparkle': {
          // The Eiffel Tower twinkles for five minutes at the start of every hour after dark.
          if (part !== 'night' || floor(t / 60) % 60 >= 5) break;
          const [, name, x0, bottom] = op, rows = SPR[name], h = rows.length, step = floor(t * 4);
          for (let dy = 0; dy < h; dy++) for (let dx = 0; dx < rows[0].length; dx++) {
            if (rows[dy][dx] !== '.' && hash(x0 + dx, bottom - h + dy, seed + step) % 9 === 0) set(x0 + dx, bottom - h + dy, 0xFFFFFF);
          }
          break;
        }
        case 'birds': {
          if (!L.bird) break;
          const [, y, count, speed] = op, span = COLS + 40;
          for (let i = 0; i < count; i++) {
            const x = floor((hash(i, 5, seed) % 30 + i * 6 + t * speed) % span) - 20;
            const by = y + (i % 2) * 2 + hash(i, 6, seed) % 3;
            if ((floor(t * 3) + i) % 2 === 0) { set(x, by, L.bird); set(x + 1, by + 1, L.bird); set(x + 2, by, L.bird); }
            else { set(x, by + 1, L.bird); set(x + 1, by + 1, L.bird); set(x + 2, by + 1, L.bird); }
          }
          break;
        }
        case 'flag': {
          const [, x, top, bottom, depth] = op;
          for (let y = top; y < bottom; y++) set(x, y, color('D', depth, false, x, y));
          set(x, top - 1, color('Y', depth, false, x, top - 1));
          if (!flag) break;
          const phase = floor(t * 4);
          for (let fx = 0; fx < FLAG_W; fx++) {
            const i = ((fx - phase) % 10 + 10) % 10;
            const wave = fx < 2 ? 0 : WAVE[i], fold = fx < 1 ? 1 : FOLD[i];
            for (let fy = 0; fy < FLAG_H; fy++) {
              const v = flag[fy * FLAG_W + fx];
              set(x + 1 + fx, top + fy + wave, multiply(v, L.flagTint.map(m => m * fold)));
            }
          }
          break;
        }
      }
    }
    return px;
  }

  function partFor(hour) { return hour >= 5 && hour < 8 ? 'dawn' : hour >= 8 && hour < 17 ? 'day' : hour >= 17 && hour < 21 ? 'dusk' : 'night'; }
  function sunFor(minutes) { return minutes >= 360 && minutes <= 1200 ? (minutes - 360) / 840 : null; }

  /* Flag of a country as FLAG_W*FLAG_H colors. */
  function flagPixels(code) {
    const f = D.FLAGS[code];
    if (!f) return null;
    const out = [];
    for (const row of f.rows) for (const ch of row) out.push(f.colors[ch]);
    return out;
  }

  /* Places of a country, the next one on every entry into the app. */
  function sceneFor(code, visit) {
    const list = D.PLACES[code] || D.PLACES[''];
    return list[((visit % list.length) + list.length) % list.length];
  }

  function draw(canvas, opts) {
    canvas.width = COLS; canvas.height = ROWS;
    const g = canvas.getContext('2d');
    const img = g.createImageData(COLS, ROWS);
    const px = render(opts.scene, opts.part, opts.sun, opts.flag, opts.t, opts.seed);
    for (let i = 0; i < px.length; i++) {
      img.data[i * 4] = px[i] >>> 16 & 255; img.data[i * 4 + 1] = px[i] >>> 8 & 255; img.data[i * 4 + 2] = px[i] & 255; img.data[i * 4 + 3] = 255;
    }
    g.putImageData(img, 0, 0);
  }

  return { COLS, ROWS, FLAG_W, FLAG_H, render, draw, partFor, sunFor, flagPixels, sceneFor, hash, scenes: Object.keys(SCENES) };
})(PIXEL_DATA);
