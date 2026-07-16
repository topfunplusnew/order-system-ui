/* global describe, test, expect, jest */
import request from '@/utils/request';
import { getDeletedGoodsOrder } from './goodsOrder';

jest.mock('@/utils/request', () => jest.fn());

describe('deleted goods order detail API', () => {
	test('requests the dedicated deleted detail endpoint', () => {
		getDeletedGoodsOrder(123);

		expect(request).toHaveBeenCalledWith({
			url: '/system/goodsOrder/deleted/123',
			method: 'get'
		});
	});
});
