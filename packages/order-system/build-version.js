// build-version.js
const fs = require('fs');
const path = require('path');

const version = new Date().toISOString();
const filePath = path.resolve(__dirname, 'dist/version.json');

fs.writeFileSync(filePath, JSON.stringify({ version }), 'utf-8');
console.log('📦 已生成项目版本文件 version.json, 当前版本号:', version);
console.log(`============================================`);
