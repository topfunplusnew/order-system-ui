import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

describe('BreakOut inventory view flow', () => {
	test('uses INVENTORY dialog flow consistent with ExWarehouse', () => {
		const componentPath = path.resolve(__dirname, 'index.vue');
		const source = fs.readFileSync(componentPath, 'utf8');

		expect(source).toContain("import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';");
		expect(source).toContain('getInventoryMainByDetailId');
		expect(source).toContain("this.openDialog(INVENTORY, '查看库存信息', '100%', { needToShowInfo: res.data || {} }, false, false);");
		expect(source).not.toContain('inventoryInfoVisible');
		expect(source).not.toContain('title="库存信息"');
	});
});
