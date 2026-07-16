/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('ElTableOrder deleted detail lookup', () => {
	test('selects the deleted detail API only in deleted mode', () => {
		const componentPath = path.resolve(__dirname, './ElTableOrder.vue');
		const source = fs.readFileSync(componentPath, 'utf8');

		expect(source).toContain('const getOrderDetail = this.isDeletedMode ? getDeletedGoodsOrder : getGoodsOrder;');
		expect(source).toContain('getOrderDetail(id)');
	});
});
