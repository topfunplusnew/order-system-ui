import { describe, expect, test } from '@jest/globals';
import { createDailyExpenseReportColumns, resolveDailyExpenseReportTime } from '@/views/system/Statement/DailyExpenseReports.config';

describe('DailyExpenseReports config', () => {
	test('inserts apply date after index and renames expense time to payment time', () => {
		expect(createDailyExpenseReportColumns().map(column => column.label)).toEqual(['申请时间', '对象', '付款金额', '付款户名', '付款账号', '收款户名', '收款账号', '付款时间', '附件', '备注']);
	});

	test('prefers dedicated time fields and falls back to legacy expenseDate', () => {
		expect(resolveDailyExpenseReportTime({ paymentDate: '2026-04-20 12:00:00', expenseDate: '2026-04-19 08:00:00' }, 'payment')).toBe('2026-04-20 12:00:00');
		expect(resolveDailyExpenseReportTime({ applyDate: '2026-04-18 09:30:00' }, 'apply')).toBe('2026-04-18 09:30:00');
		expect(resolveDailyExpenseReportTime({ expenseDate: '2026-04-19 08:00:00' }, 'payment')).toBe('2026-04-19 08:00:00');
		expect(resolveDailyExpenseReportTime({ expenseDate: '2026-04-19 08:00:00' }, 'apply')).toBe('2026-04-19 08:00:00');
	});
});
