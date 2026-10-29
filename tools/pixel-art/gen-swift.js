/* Writes Financist/Models/PixelData.swift from data.json — the same drawings the prototype uses. */
const fs = require('fs');
const path = require('path');
const D = JSON.parse(fs.readFileSync(__dirname + '/data.json', 'utf8'));
const out = process.argv[2] || path.join(__dirname, '../../Financist/Models/PixelData.swift');
const hex = n => '0x' + n.toString(16).toUpperCase().padStart(6, '0');
const str = s => JSON.stringify(s);
const num = n => Number.isInteger(n) ? String(n) : String(n);
const KIND = ['solid', 'window', 'lamp', 'glow'];
const block = (rows, indent) => '"""\n' + rows.map(r => indent + r).join('\n') + '\n' + indent + '"""';

const lines = [];
const L = s => lines.push(s);
L('// Сгенерировано из tools/pixel-art (node build.js && node gen-swift.js) — те же рисунки, что в макете.');
L('// Руками не править: перерисовать там и сгенерировать заново.');
L('');
L('extension PixelCity {');
L('    /// Материалы: символ рисунка → цвет днём и как он ведёт себя вечером и ночью.');
L('    static let materials: [Character: Material] = [');
for (const [ch, [c, k]] of Object.entries(D.MAT)) L(`        ${str(ch)}: Material(${hex(c)}${k ? ', .' + KIND[k] : ''}),`);
L('    ]');
L('');
L('    /// Облака: h — светлый верх, x — облако, s — тень снизу.');
L('    static let clouds: [String] = [');
for (const c of D.CLOUDS) L('        ' + block(c, '        ') + ',');
L('    ]');
L('');
L('    /// Рисунки: каждая строка — ряд точек, «.» — пусто.');
L('    static let sprites: [String: String] = [');
for (const [name, rows] of Object.entries(D.SPR)) L(`        ${str(name)}: ` + block(rows, '        ') + ',');
L('    ]');
L('');
const op = o => {
  switch (o[0]) {
    case 'spr': return `.sprite(${str(o[1])}, x: ${o[2]}, bottom: ${o[3]}, depth: ${o[4]}, flags: ${o[5]})`;
    case 'water': {
      const [, y0, y1, x0 = 0, x1 = 96, style = 0] = o;
      return `.water(top: ${y0}, bottom: ${y1}` + (x0 !== 0 || x1 !== 96 ? `, from: ${x0}, to: ${x1}` : '') + (style ? ', lagoon: true' : '') + ')';
    }
    case 'boat': {
      const [, names, bottom, speed, offset, depth, fps = 0] = o;
      return `.boat([${[].concat(names).map(str).join(', ')}], bottom: ${bottom}, speed: ${num(speed)}, offset: ${num(offset)}, depth: ${depth}` + (fps ? `, fps: ${num(fps)}` : '') + ')';
    }
    case 'anim': return `.anim([${o[1].map(str).join(', ')}], x: ${o[2]}, bottom: ${o[3]}, depth: ${o[4]}, fps: ${num(o[5])})`;
    case 'bob': return `.bob(${str(o[1])}, x: ${o[2]}, bottom: ${o[3]}, depth: ${o[4]}, amp: ${o[5]}, period: ${num(o[6])})`;
    case 'sparkle': return `.sparkle(${str(o[1])}, x: ${o[2]}, bottom: ${o[3]})`;
    case 'birds': return `.birds(row: ${o[1]}, count: ${o[2]}, speed: ${num(o[3])})`;
    case 'flag': return `.flag(x: ${o[1]}, top: ${o[2]}, bottom: ${o[3]}, depth: ${o[4]})`;
    default: throw new Error('op ' + o[0]);
  }
};
L('    /// Места: небо до горизонта, ряды облаков и что рисовать — по порядку, от дальнего к ближнему.');
L('    static let scenes: [String: Scene] = [');
for (const [id, s] of Object.entries(D.SCENES)) {
  L(`        ${str(id)}: Scene(horizon: ${s.horizon}, clouds: [${s.clouds.join(', ')}], ops: [`);
  for (const o of s.ops) L('            ' + op(o) + ',');
  L('        ]),');
}
L('    ]');
L('');
L('    /// Места каждой страны — сменяются по дням. Пустой код — для остальных стран.');
L('    static let places: [String: [String]] = [');
for (const [code, list] of Object.entries(D.PLACES)) L(`        ${str(code)}: [${list.map(str).join(', ')}],`);
L('    ]');
L('');
L(`    /// Флаги ${D.FLAGS.TR.rows[0].length}×${D.FLAGS.TR.rows.length}, нарисованные вручную.`);
L('    static let flags: [String: Flag] = [');
for (const [code, f] of Object.entries(D.FLAGS)) {
  const colors = Object.entries(f.colors).map(([k, v]) => `${str(k)}: ${hex(v)}`).join(', ');
  L(`        ${str(code)}: Flag(colors: [${colors}], rows: ` + block(f.rows, '        ') + '),');
}
L('    ]');
L('}');
L('');
fs.writeFileSync(out, lines.join('\n'));
console.log('wrote', out, fs.statSync(out).size, 'bytes');
