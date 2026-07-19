import fs from 'fs';
import path from 'path';
import { describe, expect, jest, test } from '@jest/globals';

jest.mock('@/api/system/statement', () => ({
	getReceiveReport: jest.fn(),
	getPaymentReport: jest.fn()
}));

import { createFundReportQuery, FUND_REPORT_COLUMNS, FUND_REPORT_CONFIG, hasRequiredReportDate } from './fundReportConfig';

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

	test('creates page-one filters with today as the required date', () => {
		expect(createFundReportQuery('2026-07-20')).toEqual({
			pageNum: 1,
			pageSize: 20,
			date: '2026-07-20',
			selfAccountName: '',
			otherCompanyName: '',
			otherAccountName: ''
		});
		expect(hasRequiredReportDate({ date: '2026-07-20' })).toBe(true);
		expect(hasRequiredReportDate({ date: '' })).toBe(false);
		expect(hasRequiredReportDate({})).toBe(false);
	});

	test('uses one shared component and thin route wrappers', () => {
		const statementDir = __dirname;
		const sharedSource = fs.readFileSync(path.join(statementDir, 'components/FundReport.vue'), 'utf8');
		const receiveSource = fs.readFileSync(path.join(statementDir, 'receiveReport.vue'), 'utf8');
		const paymentSource = fs.readFileSync(path.join(statementDir, 'paymentReport.vue'), 'utf8');

		expect(receiveSource).toContain('<FundReport report-type="receive" />');
		expect(paymentSource).toContain('<FundReport report-type="payment" />');
		expect(sharedSource).toContain('hasRequiredReportDate(this.queryParams)');
		expect(sharedSource).toContain('.listApi(this.queryParams)');
		expect(sharedSource).toContain('this.download(');
		expect(sharedSource).toContain(':page.sync="queryParams.pageNum"');
		expect(sharedSource).toContain(':limit.sync="queryParams.pageSize"');
		expect(sharedSource).toContain('FUND_REPORT_COLUMNS');
		expect(sharedSource).toContain('scope.$index + 1 + (queryParams.pageNum - 1) * queryParams.pageSize');
	});
});
