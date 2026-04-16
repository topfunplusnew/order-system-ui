import { describe, expect, test } from '@jest/globals';
import {
	buildTicketPointDiffFields,
	mapTicketPointRecordToRow,
	resolveTicketPointSummaryLabel,
	UNIFIED_TICKET_POINT_MODULE_LABEL
} from '@/utils/fundChange/ticketPoint';

describe('ticketPoint fund change helpers', () => {
	test('maps single-party invoice records as unified counterparties', () => {
		const row = mapTicketPointRecordToRow({
			companyType: '客户',
			companyName: '章丘明龙',
			invoiceDate: '2026-04-08 15:05:52',
			invoiceAmount: 42956,
			invoiceObject: '鲁运',
			invoiceCompanyName: '济南明龙玻璃有限公司',
			ticketPoint: 0.075,
			ticketPointAmount: 3221.7,
			extraInfo: {
				comment: null,
				actualInvoiceTime: null,
				actualInvoiceAmount: null,
				currentMonthOweInvoiceAmount: null
			}
		});

		expect(row).toEqual({
			status: '已开票',
			invoiceDate: '2026-04-08',
			selfSubject: '济南明龙玻璃有限公司',
			invoiceAmount: 42956,
			incomeCompanyType: '客户',
			incomeCompanyName: '章丘明龙',
			incomeInvoiceUnit: '鲁运',
			incomePoint: 0.075,
			incomePointAmount: 3221.7,
			isOrderTax: undefined,
			costCompanyType: '',
			costCompanyName: '',
			costInvoiceUnit: '',
			costPoint: '',
			costPointAmount: '',
			pointDiff: '',
			actualInvoiceAmount: '',
			actualInvoiceDate: '',
			monthlyDebt: '',
			remark: ''
		});
	});

	test('assigns single-party diff by company type instead of buy/sell table name', () => {
		expect(
			buildTicketPointDiffFields(
				{ companyType: '客户', ticketPointAmount: 3221.7 },
				{ companyType: '客户', ticketPointAmount: 3436.48 },
				'invoiceout'
			)
		).toEqual({
			customerDiff: '214.78',
			supplierDiff: '0.00'
		});

		expect(
			buildTicketPointDiffFields(
				{ companyType: '供应商', ticketPointAmount: 3221.7 },
				{ companyType: '供应商', ticketPointAmount: 3436.48 },
				'invoiceout'
			)
		).toEqual({
			customerDiff: '0.00',
			supplierDiff: '214.78'
		});
	});

	test('keeps dual-party ticket point diffs for third-party invoices', () => {
		expect(
			buildTicketPointDiffFields(
				{ customerPointAmount: 17000, supplierPointAmount: 16500 },
				{ customerPointAmount: 17200, supplierPointAmount: 16800 },
				'invoiceother'
			)
		).toEqual({
			customerDiff: '200.00',
			supplierDiff: '300.00'
		});
	});

	test('uses unified summary label for invoice-related modules', () => {
		expect(resolveTicketPointSummaryLabel('invoiceout', '发票卖出')).toBe(UNIFIED_TICKET_POINT_MODULE_LABEL);
		expect(resolveTicketPointSummaryLabel('allinvoice', '发票买入')).toBe(UNIFIED_TICKET_POINT_MODULE_LABEL);
	});
});
