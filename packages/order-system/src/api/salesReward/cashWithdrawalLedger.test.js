/* 用户需求：对接支取现金台账 Controller 的完整接口。实际改动：先以测试固定列表、详情、新增、修改、附件替换、删除、审核和导出的请求契约。 */
/* global describe, test, expect, jest, beforeEach */
import request from '@/utils/request';
import { addCashWithdrawalLedger, auditCashWithdrawalLedger, delCashWithdrawalLedger, exportCashWithdrawalLedger, getCashWithdrawalLedger, listCashWithdrawalLedger, replaceCashWithdrawalLedgerAttachments, updateCashWithdrawalLedger } from './cashWithdrawalLedger';

jest.mock('@/utils/request', () => jest.fn());

describe('cash withdrawal ledger API', () => {
	beforeEach(() => request.mockClear());

	test('uses the documented list and detail endpoints', () => {
		const query = { pageNum: 1, pageSize: 10 };
		listCashWithdrawalLedger(query);
		getCashWithdrawalLedger(9);

		expect(request).toHaveBeenNthCalledWith(1, { url: '/system/cashWithdrawalLedger/list', method: 'get', params: query });
		expect(request).toHaveBeenNthCalledWith(2, { url: '/system/cashWithdrawalLedger/9', method: 'get' });
	});

	test('creates and updates records with JSON bodies', () => {
		const createData = { withdrawalDate: '2026-07-24', amount: 100 };
		const updateData = { id: 9, withdrawalDate: '2026-07-25', amount: 120 };
		addCashWithdrawalLedger(createData);
		updateCashWithdrawalLedger(updateData);

		expect(request).toHaveBeenNthCalledWith(1, { url: '/system/cashWithdrawalLedger', method: 'post', data: createData });
		expect(request).toHaveBeenNthCalledWith(2, { url: '/system/cashWithdrawalLedger', method: 'put', data: updateData });
	});

	test('replaces the complete attachment collection', () => {
		const data = { cashWithdrawalLedgerId: 9, attachmentIds: [101, 102] };
		replaceCashWithdrawalLedgerAttachments(data);

		expect(request).toHaveBeenCalledWith({ url: '/system/cashWithdrawalLedger/attachments', method: 'put', data });
	});

	test('serializes deletion and passes an audit boolean', () => {
		delCashWithdrawalLedger([9, 10]);
		auditCashWithdrawalLedger(9, false);

		expect(request).toHaveBeenNthCalledWith(1, { url: '/system/cashWithdrawalLedger/9,10', method: 'delete' });
		expect(request).toHaveBeenNthCalledWith(2, { url: '/system/cashWithdrawalLedger/audit/9', method: 'put', params: { approved: false } });
	});

	test('exports a blob with flat query parameters', () => {
		const query = { auditState: '未审核' };
		exportCashWithdrawalLedger(query);

		expect(request).toHaveBeenCalledWith({ url: '/system/cashWithdrawalLedger/export', method: 'post', params: query, responseType: 'blob' });
	});
});
