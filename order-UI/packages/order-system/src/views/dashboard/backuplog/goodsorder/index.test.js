import { describe, expect, test } from '@jest/globals';
import { keyOptioner, paramFieldFilter } from '@/views/dashboard/backuplog/goodsorder/index';

// 测试JSON的key转换
describe('keyOptioner module', () => {
	const json = {
		name: 'zhangsan',
		age: 18,
		id: 1,
		order_id: 100,
		pay_id: 1,
		id_index: 1
	};

	test('json', () => {
		expect(keyOptioner(json)).toEqual({
			NAME: 'zhangsan',
			AGE: 18,
			ID_INDEX: 1,
			ID: 1,
			ORDER_ID: 100,
			PAY_ID: 1
		});
	});

	test('json', () => {
		expect(paramFieldFilter(json)).toEqual({
			name: 'zhangsan',
			age: 18
		});
	});
});
