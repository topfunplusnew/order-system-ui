import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

describe('table auto width scope', () => {
	test('does not register table auto width globally in main.js', () => {
		const mainPath = path.resolve(__dirname, '../main.js');
		const source = fs.readFileSync(mainPath, 'utf8');

		expect(source).not.toContain('Vue.mixin(createTableAutoWidthMixin())');
	});

	test('CheckOrder explicitly opts OrderDetailInfo into auto width', () => {
		const checkOrderPath = path.resolve(__dirname, '../views/dashboard/components/goodsOrder/CheckOrder.vue');
		const source = fs.readFileSync(checkOrderPath, 'utf8');

		expect(source).toContain(':enable-auto-width="true"');
	});

	test('OrderDetailInfo keeps auto width disabled by default', () => {
		const detailInfoPath = path.resolve(__dirname, '../views/dashboard/components/goodsOrder/OrderDetailInfo.vue');
		const source = fs.readFileSync(detailInfoPath, 'utf8');

		expect(source).toContain('enableAutoWidth');
		expect(source).toContain('default: false');
	});
});
