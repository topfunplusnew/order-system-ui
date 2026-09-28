/*
 * 用户需求：主批量开票订单查询必须携带 params.excludeInvoiceProductLevels=true，过滤指定产品等级。
 * 实际改动：回归测试锁定 SelectGoods 初始化/重置和 listGoodsOrder 请求前的过滤参数。
 */
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

const source = fs.readFileSync(path.resolve(__dirname, './SelectGoods.vue'), 'utf8');

describe('主批量开票订单查询产品等级过滤', () => {
	test('重置查询参数默认开启产品等级过滤', () => {
		expect(source).toContain('excludeInvoiceProductLevels: true');
	});

	test('每次请求订单列表前强制保留产品等级过滤', () => {
		const getListStart = source.indexOf('async getList() {');
		const requestStart = source.indexOf('const res = await listGoodsOrder', getListStart);
		expect(getListStart).toBeGreaterThan(-1);
		expect(requestStart).toBeGreaterThan(getListStart);
		expect(source.slice(getListStart, requestStart)).toContain('this.queryParams.params.excludeInvoiceProductLevels = true;');
	});
});
