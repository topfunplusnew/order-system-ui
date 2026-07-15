/* global describe, test, expect */
import { buildDeletedQueryParams, getDeletedColumnLabel, isDeletedPageRoute } from './deletedPage';

describe('deletedPage helpers', () => {
	test('buildDeletedQueryParams preserves filters and forces deleted query direction', () => {
		expect(buildDeletedQueryParams({ pageNum: 2, queryNotDeleted: true, customer: 'A' })).toEqual({
			pageNum: 2,
			queryNotDeleted: false,
			customer: 'A'
		});
	});

	test('getDeletedColumnLabel renames update metadata only in deleted mode', () => {
		expect(getDeletedColumnLabel('最后修改时间', true)).toBe('删除时间');
		expect(getDeletedColumnLabel('最后修改人', true)).toBe('删除人');
		expect(getDeletedColumnLabel('最后修改时间', false)).toBe('最后修改时间');
	});

	test('isDeletedPageRoute detects deleted page routes', () => {
		expect(isDeletedPageRoute({ path: '/system/deletedInfo/payment', name: 'DeletedPayment' })).toBe(true);
		expect(isDeletedPageRoute({ path: '/system/payment', name: 'Payment' })).toBe(false);
	});
});
