import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

describe('InventoryMain layout structure', () => {
	test('keeps tree panel and table area inside one shared-height split layout', () => {
		const componentPath = path.resolve(__dirname, 'index.vue');
		const source = fs.readFileSync(componentPath, 'utf8');

		expect(source).toContain('ref="inventoryMainSplitLayout"');
		expect(source).toContain('class="inventory-main-split-layout"');
		expect(source).toContain('class="inventory-main-right-panel"');
		expect(source).toContain('class="inventory-main-pagination"');
		expect(source).toContain(':height="inventoryMainTableHeight"');
	});
});
