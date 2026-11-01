// 需求：票据余额表查询日期使用 billDate。
// 实际改动：测试默认查询参数包含空值 billDate。
import { describe, expect, test } from '@jest/globals';

describe('createBalanceListQueryParams', () => {
	test('uses an empty billDate by default', async () => {
		const { createBalanceListQueryParams } = await import('@/views/system/bankacceptance/BalanceList.query');

		expect(createBalanceListQueryParams()).toMatchObject({
			pageNum: 1,
			pageSize: 20,
			billDate: '',
			balanceOperator: '',
			balanceValue: ''
		});
	});
});
