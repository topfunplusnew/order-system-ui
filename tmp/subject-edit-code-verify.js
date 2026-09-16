/**
 * 用「真实组件源码」验证科目编码问题（修复前 vs 修复后）。
 *
 * 直接把 packages/order-system/src/views/system/subject/index.vue 的 <script> 抽出来，
 * 用 @babel 转成 CommonJS 后以真实 Vue 2.6 实例化（保留真实的 computed/watch 调度语义），
 * 只把接口层换成可控返回顺序的假实现，然后走一遍用户真实操作：
 *   点「修改」 → 只改科目名称 → 点「确定」 → 看 updateSubject 实际提交的 body
 *
 * 用法：
 *   node tmp/subject-edit-code-verify.js old   # 跑 git HEAD 里的修复前代码
 *   node tmp/subject-edit-code-verify.js new   # 跑当前工作区的修复后代码
 */
const path = require('path');
const fs = require('fs');
const { execSync } = require('child_process');

const ROOT = '/Users/zhangming/Code/Projects/order-system-ui';
const SFC_REL = 'packages/order-system/src/views/system/subject/index.vue';
const SRC = path.join(ROOT, 'packages/order-system/src');
const REV = process.argv[2] === 'old' ? 'old' : 'new';

const Vue = require(path.join(ROOT, 'node_modules/vue'));
const _ = require(path.join(ROOT, 'node_modules/lodash'));
const babel = require(path.join(ROOT, 'node_modules/@babel/core'));
Vue.config.productionTip = false;
Vue.config.devtools = false;

// ------------------------------------------------------------------ 模块加载器
const presetEnv = require.resolve('@babel/preset-env', { paths: [ROOT] });

function evalModule(source, filename, customRequire) {
	const { code } = babel.transformSync(source, {
		filename,
		presets: [[presetEnv, { targets: { node: 'current' } }]],
		babelrc: false,
		configFile: false,
		sourceType: 'module'
	});
	const mod = { exports: {} };
	new Function('require', 'module', 'exports', '__filename', '__dirname', code)(customRequire, mod, mod.exports, filename, path.dirname(filename));
	return mod.exports.default !== undefined ? mod.exports.default : mod.exports;
}

function realModule(relPath) {
	const abs = path.join(SRC, relPath);
	return evalModule(fs.readFileSync(abs, 'utf8'), abs, spec => {
		throw new Error(`真实模块 ${relPath} 里未预期的引用: ${spec}`);
	});
}

const realEnums = realModule('api/tool/enums.js');
const realSubjectNoUtil = realModule('utils/subjectNo.js');

// ------------------------------------------------------------------ 假接口
const DB = [
	{ id: 1, title: '收入', parentId: 0, subjectNo: '1001', orderNum: 1, STATUS: '1' },
	{ id: 2, title: 'A科目', parentId: 1, subjectNo: '1001001', orderNum: 1, STATUS: '1' },
	{ id: 3, title: 'B科目', parentId: 1, subjectNo: '1001002', orderNum: 2, STATUS: '1' },
	{ id: 4, title: 'C科目', parentId: 1, subjectNo: '1001003', orderNum: 3, STATUS: '1' }
];
const clone = v => JSON.parse(JSON.stringify(v));
const sleep = ms => new Promise(r => setTimeout(r, ms));

let delays = { getSubject: () => 10, listSubject: () => 15 };
let sent = null;

const api = {
	getSubject(id) {
		return sleep(delays.getSubject(id)).then(() => ({ data: clone(DB.find(s => s.id === Number(id))) }));
	},
	listSubject(query) {
		return sleep(delays.listSubject(query)).then(() => ({ data: clone(DB) }));
	},
	addSubject(data) {
		sent = { method: 'POST', body: clone(data) };
		return Promise.resolve({});
	},
	updateSubject(data) {
		sent = { method: 'PUT', body: clone(data) };
		return Promise.resolve({});
	},
	delSubject() {
		return Promise.resolve({});
	}
};

const Modal = { confirm: ({ onOk }) => onOk() };

let modalCalls = 0;

function makeComponent() {
	const source = REV === 'old' ? execSync(`git show HEAD:${SFC_REL}`, { cwd: ROOT, encoding: 'utf8' }) : fs.readFileSync(path.join(ROOT, SFC_REL), 'utf8');
	const script = source.match(/<script>([\s\S]*?)<\/script>/)[1];
	const options = evalModule(script, SFC_REL, spec => {
		if (spec === 'vue') return Vue;
		if (spec === 'lodash') return _;
		if (spec === '@riophae/vue-treeselect') return { name: 'Treeselect' };
		if (spec === 'ant-design-vue')
			return {
				Modal: {
					confirm: cfg => {
						modalCalls++;
						return Modal.confirm(cfg);
					}
				}
			};
		if (spec === '@/api/system/subject') return api;
		if (spec === '@/api/tool/enums') return realEnums;
		if (spec === '@/utils/subjectNo') return realSubjectNoUtil;
		if (spec.includes('mixins/print')) return { mixin_printHTML: {} };
		if (spec.endsWith('.css') || spec.endsWith('.scss') || spec.endsWith('.less')) return {};
		throw new Error(`组件未预期的引用: ${spec}`);
	});
	// created 里的 getList/handleTree 依赖全局 mixin，不参与本次验证
	delete options.created;
	const vm = new Vue(options);
	// 让 submitForm 能跑通（$refs/$modal/resetForm 由全局 mixin 提供）
	vm.$refs.form = { validate: cb => cb(true) };
	vm.$modal = { msgSuccess() {}, msgError() {} };
	vm.resetForm = () => {};
	vm.handleTree = data => data; // handleTree 也来自全局 mixin，本场景只需能跑通
	return vm;
}

// ------------------------------------------------------------------ 场景
async function editScenario(label, row, delayCfg, extra) {
	delays = delayCfg;
	sent = null;
	const vm = makeComponent();
	vm.handleUpdate(clone(row));
	await sleep(200);
	const afterOpen = vm.form.subjectNo;
	vm.form.title = row.title + '改'; // 用户只改了名称，编码框一个字符没碰
	if (extra) extra(vm);
	await sleep(60);
	const beforeSubmit = vm.form.subjectNo;
	vm.submitForm();
	const origin = DB.find(s => s.id === row.id).subjectNo;
	return {
		label,
		afterOpen,
		beforeSubmit,
		submittedNo: sent && sent.body ? sent.body.subjectNo : null,
		submittedTitle: sent && sent.body ? sent.body.title : null,
		origin,
		kept: sent && sent.body && sent.body.subjectNo === origin
	};
}

async function addScenario(label, row, delayCfg) {
	delays = delayCfg;
	sent = null;
	const vm = makeComponent();
	vm.handleAdd(clone(row));
	await sleep(200);
	vm.submitForm();
	return { label, submittedNo: sent && sent.body ? sent.body.subjectNo : null, parentId: sent && sent.body ? sent.body.parentId : null };
}

const ORDERS = [
	['A,B,C', { getSubject: id => (Number(id) === 2 ? 10 : 20), listSubject: () => 30 }],
	['A,C,B', { getSubject: id => (Number(id) === 2 ? 10 : 30), listSubject: () => 20 }],
	['B,A,C', { getSubject: id => (Number(id) === 2 ? 20 : 10), listSubject: () => 30 }],
	['B,C,A', { getSubject: id => (Number(id) === 2 ? 30 : 10), listSubject: () => 20 }],
	['C,A,B', { getSubject: id => (Number(id) === 2 ? 20 : 30), listSubject: () => 10 }],
	['C,B,A', { getSubject: id => (Number(id) === 2 ? 30 : 20), listSubject: () => 10 }]
];

(async () => {
	console.log(`\n=========== 被测代码：${REV === 'old' ? 'git HEAD（修复前）' : '当前工作区（修复后）'} ===========\n`);
	const A = DB.find(s => s.id === 2);

	console.log('场景1：点「修改」→ 只改名称 → 点「确定」，看 PUT 提交的 subjectNo（A科目原编码 1001001）');
	console.log('  三请求返回顺序 | 提交的 subjectNo | 结果');
	console.log('  ---------------|------------------|-------------------------------');
	let keptCount = 0;
	for (const [order, cfg] of ORDERS) {
		const r = await editScenario(order, A, cfg);
		keptCount += r.kept ? 1 : 0;
		console.log(`  ${order.padEnd(14)} | ${String(r.submittedNo).padEnd(16)} | ${r.kept ? '✓ 保持原编码' : '✗ 编码被改坏'}`);
	}
	console.log(`  → 6 种返回顺序中保住原编码的有 ${keptCount} 种\n`);

	console.log('场景2：点「修改」后用户主动切换父级 → 点「确定」');
	const parentChange = await editScenario('切换父级', A, ORDERS[0][1], vm => {
		vm.form.parentId = 3;
	});
	console.log(`  提交的 subjectNo = ${JSON.stringify(parentChange.submittedNo)}  (原编码 ${parentChange.origin}) → ${parentChange.kept ? '✓ 未被自动改动' : '✗ 被自动改动'}\n`);

	console.log('场景3：新增子科目（编码自动生成仍应生效）');
	const addSub = await addScenario('新增', DB.find(s => s.id === 1), ORDERS[3][1]);
	console.log(`  在「收入(1001)」下新增 → subjectNo = ${JSON.stringify(addSub.submittedNo)}  ${addSub.submittedNo === '1001004' ? '✓ 生成正确' : '✗ 生成异常'}\n`);

	console.log('场景4：在根节点下新增（无父级编码可继承，保持手动录入）');
	const addRoot = await addScenario('根新增', { id: 0, title: '科目根信息' }, ORDERS[3][1]);
	console.log(`  subjectNo = ${JSON.stringify(addRoot.submittedNo)}  ${addRoot.submittedNo === null ? '✓ 未自动生成' : '✗ 不应自动生成'}\n`);

	console.log('场景5：新增时用户切换父级 → 编码应跟随新父级重新生成');
	const parentSwitch = {};
	{
		delays = ORDERS[3][1];
		sent = null;
		const vm = makeComponent();
		vm.handleAdd(clone(DB.find(s => s.id === 1))); // 先在「收入(1001)」下
		await sleep(150);
		parentSwitch.firstNo = vm.form.subjectNo;
		vm.form.parentId = 3; // 改选「B科目(1001002)」
		await sleep(250);
		parentSwitch.secondNo = vm.form.subjectNo;
		parentSwitch.switched = parentSwitch.secondNo === '1001002001';
		console.log(`  收入(1001) 下 → ${JSON.stringify(parentSwitch.firstNo)}；改选 B科目(1001002) → ${JSON.stringify(parentSwitch.secondNo)}  ${parentSwitch.switched ? '✓ 跟随新父级重新生成' : '✗ 未重新生成'}\n`);
	}

	const pass = keptCount === ORDERS.length && parentChange.kept && addSub.submittedNo === '1001004' && addRoot.submittedNo === null && parentSwitch.switched;
	console.log(`=========== 结论：${pass ? '✓ 全部符合预期' : '✗ 存在不符合预期的行为'} ===========\n`);
	process.exit(pass ? 0 : 1);
})();
