/*
 * 用户需求：批量开票查询订单时，在 queryParams.params 中增加
 * excludeInvoiceProductLevels = true，自动过滤指定的振龙产品等级。
 * 实际改动：回归测试要求组件初始化/重置保留该参数，并在每次调用
 * listGoodsOrder 前强制补回该参数，避免搜索条件覆盖 params 后丢失过滤。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('批量开票订单查询产品等级过滤', () => {
	const source = fs.readFileSync(path.resolve(__dirname, './InvoiceOrderSelTable.vue'), 'utf8');

	test('重置后的默认查询参数开启产品等级过滤', () => {
		const resetStart = source.indexOf('resetParams() {');
		expect(resetStart).toBeGreaterThan(-1);
		const resetSource = source.slice(resetStart, source.indexOf('\n\t\t}\n\t}\n};', resetStart));

		expect(resetSource).toContain('excludeInvoiceProductLevels: true');
	});

	test('每次请求订单列表前都强制开启产品等级过滤', () => {
		const getListStart = source.indexOf('async getList() {');
		expect(getListStart).toBeGreaterThan(-1);
		const requestSource = source.slice(getListStart, source.indexOf('const res = await listGoodsOrder', getListStart));

		expect(requestSource).toContain('this.queryParams.params.excludeInvoiceProductLevels = true;');
	});
});
