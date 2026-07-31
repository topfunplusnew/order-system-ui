// 用户需求：收款报表和付款报表的单日期搜索改为日期范围，并以 yyyy-MM-dd 格式通过 startDate、endDate 传给后端。实际改动：新增日期范围查询参数、必填校验及共享页面控件契约测试。
import fs from 'fs';
import path from 'path';
import { describe, expect, jest, test } from '@jest/globals';

jest.mock('@/api/system/statement', () => ({
	getReceiveReport: jest.fn(),
	getPaymentReport: jest.fn()
}));

import { applyFundReportDateRange, createFundReportQuery, FUND_REPORT_COLUMNS, FUND_REPORT_CONFIG, hasRequiredReportDateRange } from './fundReportConfig';

const expectedFields = [
	'source',
	'operateDate',
	'businessType',
	'otherCompanyName',
	'otherCompanyType',
	'amount',
	'selfAccountName',
	'selfBankNo',
	'selfBankName',
	'selfBankCardType',
	'otherAccountName',
	'otherBankNo',
	'otherBankName',
	'comments',
	'bankFlowNo',
	'createByName',
	'addtime',
	'updateTime',
	'updateByName'
];

describe('fund report configuration', () => {
	test('maps receive and payment reports to their dedicated endpoints and labels', () => {
		expect(FUND_REPORT_CONFIG.receive).toMatchObject({
			title: '收款报表',
			businessTypeLabel: '收入类型',
			exportPath: '/statistics/export/receiveReport',
			exportFileName: '收款报表',
			tableName: 'views-system-statement-receive-report-columns'
		});
		expect(FUND_REPORT_CONFIG.payment).toMatchObject({
			title: '付款报表',
			businessTypeLabel: '支出类型',
			exportPath: '/statistics/export/paymentReport',
			exportFileName: '付款报表',
			tableName: 'views-system-statement-payment-report-columns'
		});
		expect(typeof FUND_REPORT_CONFIG.receive.listApi).toBe('function');
		expect(typeof FUND_REPORT_CONFIG.payment.listApi).toBe('function');
	});

	test('keeps the 19 backend fields in the Excel order', () => {
		expect(FUND_REPORT_COLUMNS.map(column => column.prop)).toEqual(expectedFields);
	});

	test('creates page-one filters with today as the required date range', () => {
		expect(createFundReportQuery('2026-07-20')).toEqual({
			pageNum: 1,
			pageSize: 20,
			startDate: '2026-07-20',
			endDate: '2026-07-20',
			selfAccountName: '',
			otherCompanyName: '',
			otherAccountName: ''
		});
		expect(hasRequiredReportDateRange({ startDate: '2026-07-20', endDate: '2026-07-21' })).toBe(true);
		expect(hasRequiredReportDateRange({ startDate: '2026-07-20', endDate: '' })).toBe(false);
		expect(hasRequiredReportDateRange({})).toBe(false);
	});

	test('maps and clears the selected date range using backend field names', () => {
		const query = createFundReportQuery('2026-07-20');

		applyFundReportDateRange(query, ['2026-07-01', '2026-07-31']);
		expect(query).toMatchObject({ startDate: '2026-07-01', endDate: '2026-07-31' });

		applyFundReportDateRange(query, []);
		expect(query).toMatchObject({ startDate: null, endDate: null });
	});

	test('uses one shared component and thin route wrappers', () => {
		const statementDir = __dirname;
		const sharedSource = fs.readFileSync(path.join(statementDir, 'components/FundReport.vue'), 'utf8');
		const receiveSource = fs.readFileSync(path.join(statementDir, 'receiveReport.vue'), 'utf8');
		const paymentSource = fs.readFileSync(path.join(statementDir, 'paymentReport.vue'), 'utf8');

		expect(receiveSource).toContain('<FundReport report-type="receive" />');
		expect(paymentSource).toContain('<FundReport report-type="payment" />');
		expect(sharedSource).toContain('type="daterange"');
		expect(sharedSource).toContain('value-format="yyyy-MM-dd"');
		expect(sharedSource).toContain('v-model="dateRange"');
		expect(sharedSource).toContain('hasRequiredReportDateRange(this.queryParams)');
		expect(sharedSource).toContain('applyFundReportDateRange(this.queryParams, value)');
		expect(sharedSource).toContain('.listApi(this.queryParams)');
		expect(sharedSource).toContain('this.download(');
		expect(sharedSource).toContain(':page.sync="queryParams.pageNum"');
		expect(sharedSource).toContain(':limit.sync="queryParams.pageSize"');
		expect(sharedSource).toContain('FUND_REPORT_COLUMNS');
		expect(sharedSource).toContain('scope.$index + 1 + (queryParams.pageNum - 1) * queryParams.pageSize');
	});
});
