/* global describe, test, expect, jest */
import request from '@/utils/request';
import { getCompanyHistory } from './company';

jest.mock('@/utils/request', () => jest.fn());

describe('company history API', () => {
	test('requests company history with the business company type', () => {
		getCompanyHistory(12, '客户');

		expect(request).toHaveBeenCalledWith({
			url: '/system/company/history/12',
			method: 'get',
			params: {
				companyType: '客户'
			}
		});
	});
});
