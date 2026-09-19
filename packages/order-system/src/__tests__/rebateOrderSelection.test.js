/*
 * 用户需求：混选供应商被拒绝后，重新搜索并单选不能继续被隐藏的旧勾选阻止。
 * 实际改动：覆盖校验失败回退到已确认集合、首次重新单选成功及追加失败保留原单货物的行为。
 * 用户补充需求：返利计算全程使用 math.js BigNumber；验证页面显示、手工金额判定、流水比较和提交均不转回 Number。
 * 实际改动：增加真实页面方法的大数/小数集成回归，模拟接口仅用于检查提交字段和超额备注行为。
 * 用户需求：供应商返利只选择一行时，已选货物不能混入其他返利单或未确认的历史选择。
 * 实际改动：执行真实组件的选择监听和页面回填方法，覆盖旧缓存隔离、本单跨查询追加、取消勾选及新建重置。
 * 浏览器补充验证：挂载真实 Element UI 表格，覆盖查询换数据触发自动清选时，保留本单勾选并允许用户取消。
 */
/* global describe, test, expect, jest, beforeEach, afterEach */
import fs from 'fs';
import path from 'path';
import { transformSync } from '@babel/core';
import Vue from 'vue';
import _ from 'lodash';
import * as math from 'mathjs';
import ElementUI from 'element-ui';
import { parseComponent, compileToFunctions } from 'vue-template-compiler';
import * as rebateNumbers from '../utils/rebateMath';

const rebateApi = { getRebate: jest.fn(), addRebate: jest.fn(() => Promise.resolve({})), updateRebate: jest.fn(() => Promise.resolve({})) };

Vue.use(ElementUI);
Vue.directive('horizontal-scroll', {});
Vue.component('pagination', { render: h => h('div') });

// 项目未配置 .vue 的 Jest transformer：编译真实 script，仅隔离无关 UI 和网络依赖。
function loadComponent(relativePath, withTemplate = false) {
	const source = fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');
	const script = source.match(/<script>([\s\S]*?)<\/script>/)[1];
	const { code } = transformSync(script, {
		babelrc: false,
		configFile: false,
		browserslistConfigFile: false,
		presets: [['@babel/preset-env', { targets: { node: 'current' } }]]
	});
	const module = { exports: {} };
	const dependencies = {
		lodash: _,
		mathjs: math,
		'@/utils/rebateMath': rebateNumbers,
		'@/api/system/Rebate': rebateApi,
		'@/components/SearchOption.vue': { render: h => h('div') },
		'@/api/system/company': { listCompany: jest.fn() },
		'@/api/system/productLevel': { listProductLevel: jest.fn() },
		'@/api/tool/format': { fix: value => Number(value).toFixed(4) },
		'@/api/tool/enums': { RebateType: { Weight: 'weight', Square: 'square' } }
	};
	new Function('require', 'module', 'exports', code)(name => dependencies[name] || {}, module, module.exports);
	if (withTemplate) Object.assign(module.exports.default, compileToFunctions(parseComponent(source).template.content));
	return module.exports.default;
}

const OrderDetailList = loadComponent('../views/dashboard/components/rebate/OrderDetailList.vue');
const Rebate = loadComponent('../views/system/rebate/index.vue');
const OrderDetailInfo = loadComponent('../views/dashboard/components/goodsOrder/OrderDetailInfo.vue');
const cacheKey = 'rebate-selected-order-details';
const oldRow = { id: 10, supplier: '供应商甲', supplierID: 1, length: 1000, width: 1000, height: 20, pieces: 100 };
const row = { ...oldRow, id: 20, pieces: 2 };
const anotherRow = { ...row, id: 30 };
let instances = [];

function createList(selectedOrderDetails = [], orderDetailList = [row]) {
	const vm = new Vue({ ...OrderDetailList, propsData: { selectedOrderDetails, orderDetailList }, render: h => h('div') });
	instances.push(vm);
	return vm;
}

function createPage(goods = []) {
	const vm = {
		goods,
		form: { unitPrice: 2, rebateMethod: 'square' },
		RebateType: { Weight: 'weight', Square: 'square' },
		queryParamsSupplier: { params: {} },
		orderDetailListKey: 0,
		$message: { warning: jest.fn(), info: jest.fn(), success: jest.fn(), error: jest.fn() },
		$modal: { msgSuccess: jest.fn() },
		resetForm: jest.fn(),
		getDetailBySupper: jest.fn()
	};
	Object.entries(Rebate.methods).forEach(([name, method]) => {
		if (typeof method === 'function') vm[name] = method.bind(vm);
	});
	vm.getList = jest.fn();
	['calculationError', 'calculatedArea', 'calculatedWeightBox', 'calculatedRebate'].forEach(name => {
		const computed = Rebate.computed[name];
		if (!computed) return;
		Object.defineProperty(vm, name, { get: (typeof computed === 'function' ? computed : computed.get).bind(vm) });
	});
	return vm;
}

beforeEach(() => localStorage.clear());
afterEach(() => {
	instances.forEach(vm => {
		vm.$destroy();
		if (vm.$el && vm.$el.parentNode) vm.$el.parentNode.removeChild(vm.$el);
	});
	instances = [];
	localStorage.clear();
});

describe('返利页面高精度集成', () => {
	test('已选货物弹窗和流水表合计均保留大数小数位', () => {
		const page = createPage();
		const data = [
			{ actualReceived: '9007199254740993.1', payments: '9007199254740993.1' },
			{ actualReceived: '0.2', payments: '0.2' }
		];
		expect(page.getRebateDetailSummaries({ columns: [{}, { property: 'actualReceived' }], data })).toEqual(['合计', '9007199254740993.3']);
		expect(OrderDetailInfo.methods.getSummaries({ columns: [{}, { property: 'payments' }], data })).toEqual(['合计', '9007199254740993.30 元']);
	});

	test('修改流水后恰好达到总额时不误报超额，提交金额保留十进制文本', async () => {
		const page = createPage();
		page.currentEditIndex = 1;
		page.currentRebateData = { id: 1, rebate: '9007199254740993.3' };
		page.rebateDetailList = [
			{ id: 11, actualReceived: '9007199254740993.1' },
			{ id: 12, actualReceived: '0.1' }
		];
		page.editRebateDetailForm = { amount: '0.2', date: '2026-09-19', comment: '' };
		page.$refs = { editRebateDetailForm: { validate: callback => callback(true) } };
		page.$prompt = jest.fn(() => Promise.resolve({ value: '测试备注' }));
		page.submitEditRebateDetail();
		await new Promise(resolve => setTimeout(resolve, 0));
		expect(page.$prompt).not.toHaveBeenCalled();
		expect(rebateApi.updateRebate).toHaveBeenCalledWith(expect.objectContaining({ detailList: [{ id: 11, actualReceived: '9007199254740993.1' }, expect.objectContaining({ id: 12, actualReceived: '0.2' })] }));
	});

	test('大数基数、金额显示和新增提交均不丢失尾数', () => {
		const page = createPage([{ ...row, length: '1000', width: '1000', pieces: '9007199254740993.1234' }]);
		expect(page.calculatedArea).toBe('9007199254740993.1234');
		expect(page.calculatedRebate).toBe('18014398509481986.2468');
		page.$refs = { form: { validate: callback => callback(true) } };
		page.$modal = { msgSuccess: jest.fn() };
		page.getList = jest.fn();
		page.submitForm();
		expect(rebateApi.addRebate).toHaveBeenCalledWith(expect.objectContaining({ rebate: '18014398509481986.2468', area: '9007199254740993.1234', unitPrice: '2' }));
	});

	test('金额输入 4 与计算值 4.0000 相等，不应误判为手工覆盖', () => {
		const page = createPage([row]);
		Rebate.computed.calculatedRebate.set.call(page, '4');
		expect(page.isManualEditRebate).toBe(false);
	});

	test('新增到账 0.2 加已有 0.1，恰好等于 0.3 时不弹出超额备注', async () => {
		const page = createPage();
		page.currentRebateRow = { id: 1, rebate: '0.3' };
		page.rebateForm = { amount: '0.2', date: '2026-09-19' };
		page.$refs = { rebateForm: { validate: callback => callback(true) } };
		page.$modal = { msgSuccess: jest.fn() };
		page.$prompt = jest.fn(() => Promise.resolve({ value: '测试备注' }));
		page.getList = jest.fn();
		rebateApi.getRebate.mockResolvedValue({ data: { id: 1, rebate: '0.3', detailList: [{ actualReceived: '0.1' }] } });
		page.submitRebateForm();
		await new Promise(resolve => setTimeout(resolve, 0));
		expect(page.$prompt).not.toHaveBeenCalled();
		expect(rebateApi.updateRebate).toHaveBeenCalledWith(expect.objectContaining({ detailList: [{ actualReceived: '0.1' }, expect.objectContaining({ actualReceived: '0.2' })] }));
	});

	test('非法金额阻止新增提交', () => {
		const page = createPage([row]);
		page.form.unitPrice = 'Infinity';
		page.$refs = { form: { validate: callback => callback(true) } };
		page.submitForm();
		expect(rebateApi.addRebate).not.toHaveBeenCalled();
		expect(page.$message.error).toHaveBeenCalled();
	});
});

describe('供应商返利选单隔离', () => {
	test('首次混选被拒绝后，搜索单一供应商再勾选即可确认', async () => {
		const otherSupplierRow = { ...anotherRow, supplier: '供应商乙', supplierID: 2 };
		const page = createPage();
		const list = createList([], [row, otherSupplierRow]);
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		list.handleSelectionChange([row, otherSupplierRow]);
		list.submitSelectOrderDetail();
		expect(page.$message.warning).toHaveBeenCalledTimes(1);
		expect(page.goods).toEqual([]);
		list.orderDetailList = [row];
		await Vue.nextTick();
		list.handleSelectionChange([row]);
		list.submitSelectOrderDetail();
		expect(page.$message.warning).toHaveBeenCalledTimes(1);
		expect(page.goods).toEqual([row]);
		expect(page.form.orderDetailIds).toEqual([row.id]);
	});

	test('追加混选失败只撤销未确认选择，保留本单已确认货物', async () => {
		const otherSupplierRow = { ...anotherRow, supplier: '供应商乙', supplierID: 2 };
		const page = createPage([oldRow]);
		const list = createList([oldRow], [row, otherSupplierRow]);
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		list.handleSelectionChange([row, otherSupplierRow]);
		list.submitSelectOrderDetail();
		await Vue.nextTick();
		expect(list.selectedList).toEqual([oldRow]);
		expect(page.goods).toEqual([oldRow]);
		list.orderDetailList = [row];
		await Vue.nextTick();
		list.handleSelectionChange([row]);
		list.submitSelectOrderDetail();
		expect(page.goods).toEqual([oldRow, row]);
		expect(page.$message.warning).toHaveBeenCalledTimes(1);
	});

	test('已确认甲供应商后仅选择乙供应商仍拒绝，并恢复甲的已确认选择', async () => {
		const otherSupplierRow = { ...anotherRow, supplier: '供应商乙', supplierID: 2 };
		const page = createPage([oldRow]);
		const list = createList([oldRow], [oldRow, otherSupplierRow]);
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		list.handleSelectionChange([otherSupplierRow]);
		list.submitSelectOrderDetail();
		await Vue.nextTick();
		expect(list.selectedList).toEqual([oldRow]);
		expect(page.goods).toEqual([oldRow]);
		expect(page.$message.warning).toHaveBeenCalledTimes(1);
	});

	test('真实表格搜索刷新不丢勾选，用户取消勾选仍生效', async () => {
		const component = loadComponent('../views/dashboard/components/rebate/OrderDetailList.vue', true);
		const list = new Vue({ ...component, propsData: { orderDetailList: [row, anotherRow], selectedOrderDetails: [row] } }).$mount();
		document.body.appendChild(list.$el);
		instances.push(list);
		await Vue.nextTick();
		await Vue.nextTick();
		expect(list.$refs.orderDetailTable.selection.map(item => item.id)).toEqual([20]);
		// 接口重新返回同一已选 ID 的新对象，模拟切换条件后把本单已选行并入结果。
		list.orderDetailList = [{ ...anotherRow }, { ...row }];
		await Vue.nextTick();
		await Vue.nextTick();
		await Vue.nextTick();
		expect(list.selectedList.map(item => item.id)).toEqual([20]);
		expect(list.$refs.orderDetailTable.selection.map(item => item.id)).toEqual([20]);
		list.$el.querySelectorAll('.el-table__fixed-body-wrapper input[type="checkbox"]')[1].click();
		await Vue.nextTick();
		expect(list.selectedList.map(item => item.id)).toEqual([]);
	});

	test('旧缓存存在时首次仅选一行，已选货物、提交 ID 和返利金额均只包含该行', async () => {
		localStorage.setItem(cacheKey, JSON.stringify([oldRow]));
		const page = createPage();
		const list = createList();
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		await Vue.nextTick();
		list.handleSelectionChange([row]);
		list.submitSelectOrderDetail();
		expect(page.goods).toEqual([row]);
		expect(page.form.orderDetailIds).toEqual([row.id]);
		expect(page.form.area).toBe('2');
		expect(page.form.rebate).toBe('4.0000');
	});

	test('编辑/追加仅恢复本单已确认数据，不用全局缓存覆盖', () => {
		localStorage.setItem(cacheKey, JSON.stringify([oldRow]));
		const list = createList([row]);
		expect(list.selectedList).toEqual([row]);
		const page = createPage([row]);
		page.openAppendOrderList();
		expect(page.goods).toEqual([row]);
	});

	test('本单在不同查询中选择仍可累积，回到原结果取消勾选后不会重新合并回来', async () => {
		const page = createPage([oldRow]);
		const list = createList([oldRow]);
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		list.handleSelectionChange([row]);
		list.orderDetailList = [anotherRow];
		await Vue.nextTick();
		list.handleSelectionChange([anotherRow]);
		expect(list.selectedList.map(item => item.id)).toEqual([10, 20, 30]);
		list.orderDetailList = [oldRow];
		await Vue.nextTick();
		list.handleSelectionChange([]);
		list.submitSelectOrderDetail();
		expect(page.goods).toEqual([row, anotherRow]);
		expect(page.form.orderDetailIds).toEqual([20, 30]);
	});

	test('关闭未确认的选择后重开，不带入刚才的临时勾选', () => {
		const draft = createList();
		draft.handleSelectionChange([oldRow]);
		draft.$destroy();
		const reopened = createList();
		expect(reopened.selectedList).toEqual([]);
	});

	test('父页面恢复表格勾选时，不清掉本次跨查询新增的临时选择', async () => {
		const page = createPage([oldRow]);
		const list = createList([oldRow], [oldRow, row]);
		await Vue.nextTick();
		list.handleSelectionChange([oldRow, row]);
		let checked = [];
		list.$refs.orderDetailTable = {
			clearSelection() {
				checked = [];
				list.handleSelectionChange(checked);
			},
			toggleRowSelection(item) {
				checked.push(item);
				list.handleSelectionChange(checked);
			}
		};
		page.$refs = { appendOrderDetailList: list };
		page.restoreAppendSelection();
		await Vue.nextTick();
		expect(checked).toEqual([oldRow, row]);
		expect(list.selectedList).toEqual([oldRow, row]);
	});

	test('仍禁止混选不同供应商的订单明细', () => {
		const page = createPage([row]);
		page.handleSelectOrderDetailChange([row, { ...anotherRow, supplier: '供应商乙' }]);
		expect(page.$message.warning).toHaveBeenCalled();
		expect(page.goods).toEqual([row]);
	});

	test('新建下一张返利单后选择为空，即使浏览器还存在历史缓存', async () => {
		localStorage.setItem(cacheKey, JSON.stringify([oldRow]));
		const page = createPage([oldRow]);
		page.handleAdd();
		const list = createList(page.goods);
		await Vue.nextTick();
		expect(list.selectedList).toEqual([]);
		expect(page.form.orderDetailIds).toEqual([]);
	});

	test('清空已选后只提交本次新勾选的明细', async () => {
		const page = createPage([oldRow]);
		const list = createList([oldRow]);
		list.$on('handleClearSelected', page.clearSelectedOrderDetails);
		list.$on('handleSelect', page.handleSelectOrderDetailChange);
		list.clearSelectedOrderDetails();
		await Vue.nextTick();
		list.handleSelectionChange([row]);
		list.submitSelectOrderDetail();
		expect(page.goods).toEqual([row]);
		expect(page.form.orderDetailIds).toEqual([20]);
	});
});
