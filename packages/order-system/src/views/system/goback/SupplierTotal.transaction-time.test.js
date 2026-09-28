/*
 * 用户需求：供应商余额管理页面最后增加交易时间列，显示逻辑与 CustomerTotal 的最后一次交易日期一致。
 * 实际改动：回归测试锁定 SupplierTotal 使用 lastOrderTime，并展示日期前 10 位。
 */
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

const supplierSource = fs.readFileSync(path.resolve(__dirname, './SupplierTotal.vue'), 'utf8');
const customerSource = fs.readFileSync(path.resolve(__dirname, './CustomerTotal.vue'), 'utf8');

describe('供应商余额管理交易时间列', () => {
	test('使用与 CustomerTotal 一致的 lastOrderTime 字段和日期格式', () => {
		expect(supplierSource).toContain('label="交易时间"');
		expect(supplierSource).toContain('prop="lastOrderTime"');
		expect(supplierSource).toContain("scope.row.lastOrderTime ? scope.row.lastOrderTime.slice(0, 10) : ''");
		expect(customerSource).toContain('prop="lastOrderTime"');
		expect(customerSource).toContain("scope.row.lastOrderTime ? scope.row.lastOrderTime.slice(0, 10) : ''");
	});
});
