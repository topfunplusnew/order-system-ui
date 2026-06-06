import { describe, expect, test } from '@jest/globals';
import { buildFuturesDepositDiffFields, mapFuturesDepositRecordToRow, sumFuturesDepositDiffRows } from '@/utils/fundChange/futuresDeposit';
import { FUTURES_MARGIN_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

describe('futures deposit fund change helpers', () => {
	test('scopes futures deposit records by futuresDate', () => {
		expect(getFundChangeTemplateDateFields('FuturesDepositTemplate')).toEqual(['futuresDate']);
	});

	test('maps backend lendmoney futures fields to displayed row fields', () => {
		const row = mapFuturesDepositRecordToRow({
			id: 28,
			type: '期货保证金',
			reason: '1',
			target: '国泰君安',
			targetType: '供应商',
			futuresDate: '2026-05-24 12:00:00',
			moneyAmount: 150000,
			selfBankNo: '6231700190093951272',
			targetBankNo: '11043401040004854',
			selfAcountsName: '王建金-青岛银行',
			targetAcountsName: '方正中期期货有限公司',
			unrecoveredAmount: 150000,
			futuresMarginCompany: '国泰君安'
		});

		expect(row).toEqual({
			futuresCompany: '国泰君安',
			companyName: '国泰君安',
			objectType: '供应商',
			marginAmount: 150000,
			recoverAmount: '0.00',
			badDebtTotal: '0.00',
			unrecoverAmount: '150000.00',
			otherAccountName: '方正中期期货有限公司',
			otherAccountNo: '11043401040004854',
			otherBankName: '',
			selfPayAccountName: '王建金-青岛银行',
			selfAccountNo: '6231700190093951272',
			selfBankName: '',
			payTime: '2026-05-24',
			reason: '1',
			remark: ''
		});
	});

	test('builds insert diff under depositAmount', () => {
		expect(buildFuturesDepositDiffFields({}, { moneyAmount: 150000 })).toEqual({
			marginAmount: '150000.00',
			recoverAmount: '0.00',
			badDebtTotal: '0.00',
			unrecoverAmount: '150000.00'
		});
	});

	test('uses futures margin table columns without operation and hidden diff fields', () => {
		expect(FUTURES_MARGIN_COLUMNS.filter(column => !['operation', 'marginDiff'].includes(column.prop)).map(column => column.prop)).toEqual([
			'futuresCompany',
			'companyName',
			'objectType',
			'marginAmount',
			'recoverAmount',
			'badDebtTotal',
			'unrecoverAmount',
			'otherAccountName',
			'otherAccountNo',
			'otherBankName',
			'selfPayAccountName',
			'selfAccountNo',
			'selfBankName',
			'payTime',
			'reason',
			'remark'
		]);
	});

	test('sums numeric diff columns for footer', () => {
		expect(
			sumFuturesDepositDiffRows([
				{ marginAmount: '0.00', recoverAmount: '700000.00', badDebtTotal: '500000.00', unrecoverAmount: '-1200000.00' },
				{ marginAmount: '600000.00', recoverAmount: '0.00', badDebtTotal: '0.00', unrecoverAmount: '600000.00' }
			])
		).toEqual({
			marginAmount: '600000.00',
			recoverAmount: '700000.00',
			badDebtTotal: '500000.00',
			unrecoverAmount: '-600000.00'
		});
	});
});
