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

	test('OrderDetailInfo keeps 4px horizontal padding after auto width is enabled', () => {
		const detailInfoPath = path.resolve(__dirname, '../views/dashboard/components/goodsOrder/OrderDetailInfo.vue');
		const source = fs.readFileSync(detailInfoPath, 'utf8');

		expect(source).toContain(':cell-style="getTableCellStyle"');
		expect(source).toContain(':header-cell-style="getTableHeaderCellStyle"');
		expect(source).toContain("padding: this.enableAutoWidth ? '0 4px' : '0'");
		expect(source).toContain('::v-deep .order-detail-table.auto-width-enabled .cell');
		expect(source).toContain('box-sizing: border-box !important;');
		expect(source).toContain('::v-deep .order-detail-table.auto-width-enabled .expand-cursor-wrapper');
		expect(source).toContain('::v-deep .order-detail-table.auto-width-enabled .expand-cursor-wrapper.has-overflow .text-container');
		expect(source).toContain('::v-deep .order-detail-table.auto-width-enabled .expand-cursor-wrapper .expand-button');
	});

	test('OrderDetailInfo passes centered text alignment into ExpandCursor for table cells', () => {
		const detailInfoPath = path.resolve(__dirname, '../views/dashboard/components/goodsOrder/OrderDetailInfo.vue');
		const source = fs.readFileSync(detailInfoPath, 'utf8');

		expect(source).toContain('<ExpandCursor text-align="center">');
	});
});
