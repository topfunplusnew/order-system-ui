/* global describe, test, expect, jest, beforeEach */
import request from '@/utils/request';
import { getPaymentReport, getReceiveReport } from './statement';

jest.mock('@/utils/request', () => jest.fn());

describe('fund report APIs', () => {
	beforeEach(() => {
		request.mockClear();
	});

	test('queries the receive report with the supplied filters', () => {
		const query = { date: '2026-07-20', selfAccountName: '我方账户', pageNum: 1, pageSize: 20 };

		getReceiveReport(query);

		expect(request).toHaveBeenCalledWith({
			url: '/statistics/receiveReport',
			method: 'get',
			params: query
		});
	});

	test('queries the payment report with the supplied filters', () => {
		const query = { date: '2026-07-20', otherCompanyName: '对方公司', pageNum: 2, pageSize: 50 };

		getPaymentReport(query);

		expect(request).toHaveBeenCalledWith({
			url: '/statistics/paymentReport',
			method: 'get',
			params: query
		});
	});
});
