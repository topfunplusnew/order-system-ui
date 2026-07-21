/* 用户需求：正常发货记录、入库记录、出库记录的日期搜索改为时间范围搜索。实际改动：测试三页统一使用时分秒范围控件，并正确同步、清空各自接口的开始和结束参数。 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';
import { applyInventoryRecordDateRange } from './inventoryRecordDateRange';

const readSource = relativePath => fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');

describe('inventory record date-time range', () => {
	test('maps and clears a selected range on the existing backend fields', () => {
		const query = { pageNum: 1, startDate: null, endDate: null };

		applyInventoryRecordDateRange(query, ['2026-07-01 08:30:00', '2026-07-21 18:45:30'], 'startDate', 'endDate');
		expect(query).toMatchObject({ startDate: '2026-07-01 08:30:00', endDate: '2026-07-21 18:45:30' });

		applyInventoryRecordDateRange(query, [], 'startDate', 'endDate');
		expect(query).toMatchObject({ startDate: null, endDate: null });
	});

	test.each([
		['正常发货记录', '../system/exwarehouse/index.vue'],
		['入库记录', './inventoryIn/index.vue'],
		['出库记录', './inventoryOut/index.vue']
	])('%s uses one date-time range picker', (label, relativePath) => {
		const source = readSource(relativePath);

		expect(source).toContain('type="datetimerange"');
		expect(source).toContain('value-format="yyyy-MM-dd HH:mm:ss"');
		expect(source).toContain(":default-time=\"['00:00:00', '23:59:59']\"");
		expect(source).toContain('applyInventoryRecordDateRange');
	});
});
