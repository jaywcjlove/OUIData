import ouiData from "oui-data" with {type: "json"};
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const destFile = path.resolve(__dirname, '../Sources/OUIData/Resources/oui.json');

// Write to file
fs.writeFileSync(destFile, JSON.stringify(ouiData, null, 2), 'utf8');
console.log(`Generated Swift file at`, destFile);