#!/usr/bin/env node
/**
 * 扫描业务 CRUD 列表页主表格是否包含 ID（prop="id"）与 addtime（prop="addtime"）列。
 * 用法：
 *   node scripts/scan-table-id-addtime-columns.js          # 控制台摘要
 *   node scripts/scan-table-id-addtime-columns.js --json   # JSON 输出
 *   node scripts/scan-table-id-addtime-columns.js --markdown # 更新用 Markdown 片段
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const SRC = path.join(ROOT, 'packages/order-system/src');

/**
 * 读取 vue 文件及同目录 columns.js 配置
 * @param {string} vuePath 绝对路径
 * @returns {string}
 */
function getScanContent(vuePath) {
	let content = fs.readFileSync(vuePath, 'utf8');
	const dir = path.dirname(vuePath);
	for (const m of content.matchAll(/import\s+\w+\s+from\s+['"](\.\/[^'"]*columns[^'"]*)['"]/gi)) {
		const colPath = path.normalize(path.join(dir, m[1]));
		for (const ext of ['', '.js']) {
			const candidate = colPath + ext;
			if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) {
				content += '\n' + fs.readFileSync(candidate, 'utf8');
			}
		}
	}
	return content;
}

/**
 * @param {string} content
 * @returns {boolean}
 */
function hasIdCol(content) {
	return (
		/<el-table-column[^>]*\bprop=["']id["']/.test(content) ||
		/<virtual-column[^>]*\bprop=["']id["']/.test(content) ||
		/tableColumns:\s*\[[\s\S]*?\bprop:\s*['"]id['"]/.test(content)
	);
}

/**
 * @param {string} content
 * @returns {boolean}
 */
function hasAddtimeCol(content) {
	return (
		/<el-table-column[^>]*\bprop=["']addtime["']/.test(content) ||
		/<virtual-column[^>]*\bprop=["']addtime["']/.test(content) ||
		/tableColumns:\s*\[[\s\S]*?\bprop:\s*['"]addtime['"]/.test(content)
	);
}

/**
 * 是否纳入业务 CRUD 扫描范围
 * @param {string} filePath 相对 SRC 的路径
 * @returns {boolean}
 */
function isCrudPage(filePath) {
	return (
		filePath.match(/views\/(system|salesReward|moneyDetail|inventoryDetailViews|sysmoneylog|report)\//) &&
		!filePath.includes('/components/') &&
		!filePath.includes('Statement/') &&
		!filePath.includes('Total/') &&
		!filePath.includes('goback/') &&
		!filePath.match(/\/(user|role|dept|menu|post|dict|config|notice|monitor)\//)
	);
}

/**
 * @returns {Array<{ file: string, hasId: boolean, hasAddtime: boolean }>}
 */
function scanAll() {
	const files = execSync(`rg -l "<el-table" --glob "*.vue" ${SRC}`, { encoding: 'utf8', cwd: ROOT })
		.trim()
		.split('\n')
		.filter(Boolean);

	return files
		.map(fileFromRg => {
			const absPath = path.isAbsolute(fileFromRg) ? fileFromRg : path.join(ROOT, fileFromRg);
			const rel = path.relative(SRC, absPath).replace(/\\/g, '/');
			return { absPath, rel };
		})
		.filter(({ rel }) => isCrudPage(rel))
		.map(({ absPath, rel }) => {
			const content = getScanContent(absPath);
			return {
				file: rel,
				hasId: hasIdCol(content),
				hasAddtime: hasAddtimeCol(content)
			};
		})
		.sort((a, b) => a.file.localeCompare(b.file));
}

/**
 * @param {Array} rows
 * @returns {{ complete: Array, missingAddtime: Array, missingId: Array, missingBoth: Array }}
 */
function categorize(rows) {
	return {
		complete: rows.filter(r => r.hasId && r.hasAddtime),
		missingAddtime: rows.filter(r => r.hasId && !r.hasAddtime),
		missingId: rows.filter(r => !r.hasId && r.hasAddtime),
		missingBoth: rows.filter(r => !r.hasId && !r.hasAddtime)
	};
}

/**
 * @param {string} relPath
 * @returns {string}
 */
function toRepoPath(relPath) {
	return `packages/order-system/src/${relPath}`;
}

/**
 * @param {Array<{ file: string }>} items
 * @param {string} missingLabel
 * @returns {string}
 */
function checklist(items, missingLabel) {
	return items
		.map(r => `- [ ] \`${r.file}\`（缺：${missingLabel}）— [\`${path.basename(r.file)}\`](${toRepoPath(r.file)})`)
		.join('\n');
}

function printSummary() {
	const rows = scanAll();
	const { complete, missingAddtime, missingId, missingBoth } = categorize(rows);
	const missingTotal = missingAddtime.length + missingId.length + missingBoth.length;

	console.log('业务 CRUD 表格 ID / addtime 扫描');
	console.log('扫描时间:', new Date().toISOString().slice(0, 10));
	console.log('页面总数:', rows.length);
	console.log('已完备:', complete.length);
	console.log('待补齐:', missingTotal);
	console.log('  - 仅缺 addtime:', missingAddtime.length);
	console.log('  - 仅缺 ID:', missingId.length);
	console.log('  - 两列均缺:', missingBoth.length);
	console.log('');
	console.log('重新生成文档: yarn scan:table-columns');
}

function printJson() {
	const rows = scanAll();
	console.log(JSON.stringify({ scannedAt: new Date().toISOString(), ...categorize(rows), total: rows.length }, null, 2));
}

function printMarkdown() {
	const rows = scanAll();
	const { complete, missingAddtime, missingId, missingBoth } = categorize(rows);
	const missingTotal = missingAddtime.length + missingId.length + missingBoth.length;
	const date = new Date().toISOString().slice(0, 10);

	console.log(`<!-- 以下统计由 scripts/scan-table-id-addtime-columns.js 生成，${date} -->`);
	console.log(`| 类别 | 数量 |`);
	console.log(`|------|------|`);
	console.log(`| 扫描页面总数 | ${rows.length} |`);
	console.log(`| 已同时具备 ID + addtime | ${complete.length} |`);
	console.log(`| 至少缺一列 | ${missingTotal} |`);
	console.log(`| 仅缺 addtime | ${missingAddtime.length} |`);
	console.log(`| 仅缺 ID | ${missingId.length} |`);
	console.log(`| 两列均缺 | ${missingBoth.length} |`);
}

const arg = process.argv[2];
if (arg === '--json') {
	printJson();
} else if (arg === '--markdown') {
	printMarkdown();
} else {
	printSummary();
}
