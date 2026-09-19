/*
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
		'@/components/SearchOption.vue': { render: h => h('div') },
		'@/api/system/company': { listCompany: jest.fn() },
		'@/api/system/productLevel': { listProductLevel: jest.fn() },
		'@/api/tool/format': { fix: value => Number(value.toFixed(2)) },
		'@/api/tool/enums': { RebateType: { Weight: 'weight', Square: 'square' } }
	};
	new Function('require', 'module', 'exports', code)(name => dependencies[name] || {}, module, module.exports);
	if (withTemplate) Object.assign(module.exports.default, compileToFunctions(parseComponent(source).template.content));
	return module.exports.default;
}

const OrderDetailList = loadComponent('../views/dashboard/components/rebate/OrderDetailList.vue');
const Rebate = loadComponent('../views/system/rebate/index.vue');
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
		$message: { warning: jest.fn(), info: jest.fn(), success: jest.fn() },
		resetForm: jest.fn(),
		getDetailBySupper: jest.fn()
	};
	Object.entries(Rebate.methods).forEach(([name, method]) => {
		if (typeof method === 'function') vm[name] = method.bind(vm);
	});
	['calculatedArea', 'calculatedWeightBox', 'calculatedRebate'].forEach(name => {
		const computed = Rebate.computed[name];
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

describe('供应商返利选单隔离', () => {
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
		expect(page.form.area).toBe(2);
		expect(page.form.rebate).toBe(4);
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
