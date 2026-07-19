/* global describe, test, expect */
import fs from 'fs';
import path from 'path';
import { getOrderFreightDocumentDate } from './orderFreightDocumentDate';

describe('order freight source document date', () => {
	test('uses the goods order date for order freight', () => {
		expect(getOrderFreightDocumentDate({ goodsOrder: { orderDate: '2026-05-24 14:30:13' }, inventoryMain: null })).toBe('2026-05-24 14:30:13');
	});

	test('uses the inventory store date for inventory freight', () => {
		expect(getOrderFreightDocumentDate({ goodsOrder: null, inventoryMain: { storeDate: '2026-05-25 09:10:00' } })).toBe('2026-05-25 09:10:00');
	});

	test('returns an empty value for legacy rows without source detail', () => {
		expect(getOrderFreightDocumentDate({})).toBe('');
	});

	test('documents and renders the date immediately after freight source', () => {
		const componentPath = path.resolve(__dirname, './index.vue');
		const source = fs.readFileSync(componentPath, 'utf8');
		const sourceColumn = 'label="运费来源"';
		const dateColumn = 'label="订单日期"';

		expect(source).toContain('运费支付列表“订单日期”字段维护说明');
		expect(source).toContain('goodsOrder.orderDate');
		expect(source).toContain('inventoryMain.storeDate');
		expect(source.indexOf(dateColumn)).toBeGreaterThan(source.indexOf(sourceColumn));
		expect(source.indexOf(dateColumn)).toBeLessThan(source.indexOf('label="客户"'));
	});
});
