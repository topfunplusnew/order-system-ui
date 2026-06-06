import { describe, expect, test } from '@jest/globals';
import { mapBorrowInRecordToRow } from '@/utils/fundChange/borrowIn';
import { BORROWEDMONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

describe('borrow-in fund change template config', () => {
	test('uses borrowedmoney table props for displayed fields', () => {
		expect(BORROWEDMONEY_COLUMNS.map(column => column.prop)).toEqual([
			'id',
			'origin',
			'moneyAmount',
			'ratio',
			'loanDate',
			'loanDuring',
			'mortgageGuarantee',
			'acountsName',
			'bankNo',
			'repaidAmount',
			'unrepaidAmount',
			'repaidInterest',
			'comments',
			'bankCardDiff'
		]);
	});

	test('scopes borrow-in records by loanDate', () => {
		expect(getFundChangeTemplateDateFields('BorrowInTemplate')).toEqual(['loanDate']);
	});

	test('maps backend borrowedmoney fields to displayed row fields', () => {
		const row = mapBorrowInRecordToRow({
			id: 2,
			ratio: 0.035,
			bankNo: '6228481259193023075',
			origin: '贷款',
			loanDate: '2026-05-24 19:00:00',
			loanDuring: '1',
			repayments: [],
			acountsName: '孙梅-农行',
			moneyAmount: 1000000,
			unrepaidAmount: 1000000,
			mortgageGuarantee: '无',
			comments: null
		});

		expect(row).toEqual({
			id: 2,
			origin: '贷款',
			moneyAmount: 1000000,
			ratio: 0.035,
			loanDate: '2026-05-24',
			loanDuring: '1',
			mortgageGuarantee: '无',
			acountsName: '孙梅-农行',
			bankNo: '6228481259193023075',
			repaidAmount: '0.00',
			unrepaidAmount: '1000000.00',
			repaidInterest: '0.00',
			comments: ''
		});
	});

	test('uses unrepaidAmount to match borrowedmoney page repayment display', () => {
		const row = mapBorrowInRecordToRow({
			id: 1,
			ratio: 0.033,
			bankNo: '622908573152802617',
			origin: '德州银行',
			loanDate: '2025-07-02 00:00:00',
			loanDuring: '1',
			repayments: [],
			acountsName: '张娟娟-兴业银行',
			moneyAmount: 5000000,
			unrepaidAmount: 4000000,
			mortgageGuarantee: '房产',
			comments: '2025年7月2号德州银行房贷'
		});

		expect(row.repaidAmount).toBe('1000000.00');
		expect(row.unrepaidAmount).toBe('4000000.00');
		expect(row.repaidInterest).toBe('0.00');
	});
});
