/* 用户需求：转 、支现金台账日期精确到日、账户手填并按两类附件和审核规则保存。实际改动：先以测试固定查询、金额、载荷、附件和删除规则。 */
/* global describe, test, expect */
import { buildCashWithdrawalExportParams, buildCashWithdrawalPayload, buildCashWithdrawalQuery, groupCashWithdrawalAttachments, isValidCashWithdrawalAmount, mergeCashWithdrawalAttachmentIds, serializeCashWithdrawalIds } from './cashWithdrawalLedger.config';

describe('cash withdrawal ledger configuration', () => {
	test('maps a day range to flat inclusive date fields', () => {
		expect(buildCashWithdrawalQuery({ pageNum: 2, pageSize: 20, accountInfo: ' 招商  ', handlerName: ' 张三 ', purpose: '', auditState: '未审核' }, ['2026-07-01', '2026-07-31'])).toEqual({
			pageNum: 2,
			pageSize: 20,
			beginWithdrawalDate: '2026-07-01',
			endWithdrawalDate: '2026-07-31',
			accountInfo: '招商',
			handlerName: '张三',
			auditState: '未审核'
		});
	});

	test('removes pagination for export', () => {
		expect(buildCashWithdrawalExportParams({ pageNum: 3, pageSize: 50, accountInfo: '账户' }, [])).toEqual({ accountInfo: '账户' });
	});

	test('validates DECIMAL(28,8) positive values without arithmetic', () => {
		expect(isValidCashWithdrawalAmount('0.00000001')).toBe(true);
		expect(isValidCashWithdrawalAmount('12345678901234567890.12345678')).toBe(true);
		expect(isValidCashWithdrawalAmount('0')).toBe(false);
		expect(isValidCashWithdrawalAmount('-1')).toBe(false);
		expect(isValidCashWithdrawalAmount('123456789012345678901')).toBe(false);
		expect(isValidCashWithdrawalAmount('1.123456789')).toBe(false);
	});

	test('whitelists create and update payload fields', () => {
		const form = {
			id: 8,
			withdrawalDate: '2026-07-24',
			amount: '10000.50000000',
			accountInfo: ' 招商银行 12345 ',
			handlerName: ' 张三 ',
			purpose: ' 备用金 ',
			remark: '',
			auditState: '已审核',
			params: { attachmentIds: [101, 102] }
		};

		expect(buildCashWithdrawalPayload(form, false)).toEqual({
			withdrawalDate: '2026-07-24',
			amount: 10000.5,
			accountInfo: '招商银行 12345',
			handlerName: '张三',
			purpose: '备用金',
			remark: null,
			params: { attachmentIds: [101, 102] }
		});
		expect(buildCashWithdrawalPayload(form, true)).toEqual({
			id: 8,
			withdrawalDate: '2026-07-24',
			amount: 10000.5,
			accountInfo: '招商银行 12345',
			handlerName: '张三',
			purpose: '备用金',
			remark: null
		});
	});

	test('groups exact flags and merges unique attachment ids', () => {
		const attachments = [
			{ id: 1, flag: 'withdrawalProof' },
			{ id: 2, flag: 'otherAttachment' },
			{ id: 1, flag: 'withdrawalProof' },
			{ id: 3, flag: 'ignored' }
		];
		expect(groupCashWithdrawalAttachments(attachments)).toEqual({ withdrawalProof: [attachments[0], attachments[2]], otherAttachment: [attachments[1]] });
		expect(mergeCashWithdrawalAttachmentIds(attachments)).toEqual([1, 2]);
	});

	test('serializes selected ids', () => {
		expect(serializeCashWithdrawalIds(8)).toBe('8');
		expect(serializeCashWithdrawalIds([8, 9])).toBe('8,9');
	});
});
