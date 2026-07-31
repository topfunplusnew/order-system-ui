// 用户需求：收款报表和付款报表使用日期范围查询，付款接口 /statistics/paymentReport 通过 startDate、endDate 传递 yyyy-MM-dd 日期。实际改动：更新接口测试数据，验证起止日期字段会原样作为 GET 参数发送。
/* global describe, test, expect, jest, beforeEach */
import request from '@/utils/request';
import { getPaymentReport, getReceiveReport } from './statement';

jest.mock('@/utils/request', () => jest.fn());

describe('fund report APIs', () => {
	beforeEach(() => {
		request.mockClear();
	});

	test('queries the receive report with the supplied filters', () => {
		const query = { startDate: '2026-07-01', endDate: '2026-07-20', selfAccountName: '我方账户', pageNum: 1, pageSize: 20 };

		getReceiveReport(query);

		expect(request).toHaveBeenCalledWith({
			url: '/statistics/receiveReport',
			method: 'get',
			params: query
		});
	});

	test('queries the payment report with the supplied filters', () => {
		const query = { startDate: '2026-07-01', endDate: '2026-07-20', otherCompanyName: '对方公司', pageNum: 2, pageSize: 50 };

		getPaymentReport(query);

		expect(request).toHaveBeenCalledWith({
			url: '/statistics/paymentReport',
			method: 'get',
			params: query
		});
	});
});
