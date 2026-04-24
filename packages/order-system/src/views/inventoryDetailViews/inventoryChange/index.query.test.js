import { describe, expect, test, jest } from '@jest/globals';
import { createInventoryChangeSearchForm } from '@/views/inventoryDetailViews/inventoryChange/index.query';

describe('createInventoryChangeSearchForm', () => {
	test('uses the fixed magic start date and today as the default end date', () => {
		jest.useFakeTimers();
		jest.setSystemTime(new Date('2026-04-24T08:09:10'));

		expect(createInventoryChangeSearchForm()).toMatchObject({
			startDate: '2025-11-01',
			endDate: '2026-04-24',
			warehouseName: '',
			pageNum: 1,
			pageSize: 20
		});

		jest.useRealTimers();
	});
});
