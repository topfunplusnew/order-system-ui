import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

describe('INVENTORY table column config', () => {
	test('supplier column is not locked to a fixed width', () => {
		const componentPath = path.resolve(__dirname, 'INVENTORY.vue');
		const source = fs.readFileSync(componentPath, 'utf8');

		expect(source).not.toMatch(/<el-table-column\s+prop="supplier"[^>]*\swidth=/);
	});
});
