import { describe, expect, test } from '@jest/globals';
import { createDepositMoneyQueryParams, syncDepositMoneyPagination } from '@/views/system/depositMoney/depositMoney.pagination';

describe('depositMoney pagination helpers', () => {
	test('uses 20 as the default page size to match the pagination selector', () => {
		expect(createDepositMoneyQueryParams()).toMatchObject({
			pageNum: 1,
			pageSize: 20
		});
	});

	test('uses pagination event payload first to avoid stale pageNum and pageSize', () => {
		const queryParams = createDepositMoneyQueryParams();

		const result = syncDepositMoneyPagination(queryParams, {
			page: 2,
			limit: 50
		});

		expect(result).toEqual({
			pageNum: 2,
			pageSize: 50
		});
		expect(queryParams).toMatchObject({
			pageNum: 2,
			pageSize: 50
		});
	});
});
