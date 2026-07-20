/* 用户需求：创建主卡登记与副卡登记页面并完成油卡登记台账接口对接。实际改动：测试油卡登记台账列表、详情、新增、修改和删除请求的路径、方法与参数。 */
/* global describe, test, expect, jest */
import request from '@/utils/request';
import { addOilCardLedger, delOilCardLedger, getOilCardLedger, listOilCardLedger, updateOilCardLedger } from './oilCardLedger';

jest.mock('@/utils/request', () => jest.fn());

describe('oil card ledger API', () => {
	test('requests the ledger list with query parameters', () => {
		const query = { cardType: '主卡', pageNum: 1, pageSize: 10 };
		listOilCardLedger(query);

		expect(request).toHaveBeenCalledWith({
			url: '/system/oilCardLedger/list',
			method: 'get',
			params: query
		});
	});

	test('requests one ledger record by id', () => {
		getOilCardLedger(12);

		expect(request).toHaveBeenCalledWith({
			url: '/system/oilCardLedger/12',
			method: 'get'
		});
	});

	test('creates a ledger record', () => {
		const data = { oilCardId: 22, useDate: '2026-04-04 10:30:00' };
		addOilCardLedger(data);

		expect(request).toHaveBeenCalledWith({
			url: '/system/oilCardLedger',
			method: 'post',
			data
		});
	});

	test('updates a ledger record', () => {
		const data = { id: 1, oilCardId: 22, useDate: '2026-04-04 10:30:00' };
		updateOilCardLedger(data);

		expect(request).toHaveBeenCalledWith({
			url: '/system/oilCardLedger',
			method: 'put',
			data
		});
	});

	test('deletes ledger records by serialized ids', () => {
		delOilCardLedger('1,2');

		expect(request).toHaveBeenCalledWith({
			url: '/system/oilCardLedger/1,2',
			method: 'delete'
		});
	});
});
