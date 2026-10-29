/* Builds PIXEL_DATA (materials, sprites, scenes, flags) for the runtime. Dev-only. */
const fs = require('fs');
const { Grid } = require('./lib');
const P = require('./pieces');
const { MAT, CLOUDS } = require('./materials');
const { FLAGS } = require('./flags');

const SPR = {};
function sprite(name, grid) {
  const rows = (grid instanceof Grid ? grid : Grid.from(grid)).rows();
  if (SPR[name] && SPR[name].join() !== rows.join()) throw new Error('sprite twice: ' + name);
  for (const r of rows) for (const ch of r) if (ch !== '.' && !MAT[ch]) throw new Error(`sprite ${name}: no material ${ch}`);
  SPR[name] = rows;
  return name;
}

const SCENE_IDS = [
  'istanbul', 'cappadocia', 'galata', 'pamukkale', 'oludeniz', 'ephesus', 'uzungol',
  'samarkand', 'khiva', 'bukhara', 'guremir', 'tashkent', 'chimgan', 'bazaar',
  'dubai', 'desert', 'moscow', 'village', 'paris', 'coast', 'newyork', 'city',
];
const SCENES = {};
for (const id of SCENE_IDS) {
  const s = require('./scenes/' + id)({ sprite, P });
  for (const op of s.ops) if (['spr', 'boat', 'bob', 'anim', 'sparkle'].includes(op[0])) {
    for (const n of [].concat(op[1])) if (!SPR[n]) throw new Error(`${id}: no sprite ${n}`);
  }
  SCENES[id] = s;
}

/* Places of each country, one per entry into the app in turn; '' — when the country is unknown. */
const PLACES = {
  TR: ['istanbul', 'cappadocia', 'galata', 'pamukkale', 'oludeniz', 'ephesus', 'uzungol'],
  UZ: ['samarkand', 'khiva', 'bukhara', 'guremir', 'tashkent', 'chimgan', 'bazaar'],
  AE: ['dubai', 'desert'],
  RU: ['moscow', 'village'],
  EU: ['paris', 'coast'],
  US: ['newyork'],
  '': ['city'],
};

const data = { MAT, CLOUDS, SPR, SCENES, FLAGS, PLACES };
fs.writeFileSync(__dirname + '/data.js', 'const PIXEL_DATA = ' + JSON.stringify(data) + ';\n');
fs.writeFileSync(__dirname + '/data.json', JSON.stringify(data));
if (process.argv[2] === '--print') for (const n of process.argv.slice(3)) console.log(n + '\n' + SPR[n].join('\n'));
console.log('sprites', Object.keys(SPR).length, 'scenes', Object.keys(SCENES).length, 'flags', Object.keys(FLAGS).length,
  'bytes', fs.statSync(__dirname + '/data.js').size);
