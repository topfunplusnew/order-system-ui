import { describe, expect, test, jest } from '@jest/globals';

describe('createBalanceListQueryParams', () => {
	test('uses today as the default operateDate', async () => {
		jest.useFakeTimers();
		jest.setSystemTime(new Date('2026-04-24T10:20:30'));

		const { createBalanceListQueryParams } = await import('@/views/system/bankacceptance/BalanceList.query');

		expect(createBalanceListQueryParams()).toMatchObject({
			pageNum: 1,
			pageSize: 20,
			operateDate: '2026-04-24',
			balanceOperator: '',
			balanceValue: ''
		});

		jest.useRealTimers();
	});
});
