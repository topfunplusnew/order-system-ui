import { describe, expect, test } from '@jest/globals';
import { buildSupplierDepositDiffFields, mapSupplierDepositRecordToRow, sumSupplierDepositDiffRows } from '@/utils/fundChange/supplierDeposit';
import { FACTORY_MARGIN_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

describe('supplier deposit fund change helpers', () => {
	test('scopes supplier deposit records by futuresDate', () => {
		expect(getFundChangeTemplateDateFields('SupplierDepositTemplate')).toEqual(['futuresDate']);
	});

	test('maps backend lendmoney supplier deposit fields to displayed row fields', () => {
		const row = mapSupplierDepositRecordToRow({
			type: '厂家保证金',
			reason: '保证金',
			target: '安全保证金',
			selfBankNo: '1612008019200320030',
			targetType: '供应商',
			futuresDate: '2026-05-24 08:00:00',
			moneyAmount: 10000,
			selfBankName: '工行德州分行',
			targetBankNo: '0406329719300023646',
			targetBankName: null,
			selfAcountsName: '山东翔飞玻璃有限公司-工行',
			recoverMoneyList: [],
			targetAcountsName: '\t沙河市安全实业有限公司',
			unrecoveredAmount: 10000,
			futuresMarginCompany: '安全'
		});

		expect(row).toEqual({
			marginType: '厂家保证金',
			companyName: '安全',
			objectType: '供应商',
			targetCompanyName: '安全保证金',
			amount: 10000,
			recoverAmount: '0.00',
			badDebtTotal: '0.00',
			unrecoverAmount: '10000.00',
			otherAccountName: '沙河市安全实业有限公司',
			otherAccountNo: '0406329719300023646',
			otherBankName: '',
			selfPayAccountName: '山东翔飞玻璃有限公司-工行',
			selfAccountNo: '1612008019200320030',
			selfBankName: '工行德州分行',
			payTime: '2026-05-24',
			reason: '保证金'
		});
	});

	test('builds insert diff under numeric columns', () => {
		expect(buildSupplierDepositDiffFields({}, { moneyAmount: 10000, unrecoveredAmount: 10000 })).toEqual({
			amount: '10000.00',
			recoverAmount: '0.00',
			badDebtTotal: '0.00',
			unrecoverAmount: '10000.00'
		});
	});

	test('uses screenshot factory margin columns without hidden and remark fields', () => {
		expect(FACTORY_MARGIN_COLUMNS.filter(column => !['amountDiff', 'remark'].includes(column.prop)).map(column => column.label)).toEqual([
			'类型',
			'公司名称',
			'对方类型',
			'公司名称',
			'金额',
			'收回金额',
			'累计坏账',
			'未收回金额',
			'对方账户',
			'对方账号',
			'对方开户行',
			'我方支付账户',
			'我方账号',
			'我方开户行',
			'支付时间',
			'事由'
		]);
	});

	test('sums numeric diff columns for footer', () => {
		expect(
			sumSupplierDepositDiffRows([
				{ amount: '0.00', recoverAmount: '20000.00', badDebtTotal: '10000.00', unrecoverAmount: '-30000.00' },
				{ amount: '40000.00', recoverAmount: '0.00', badDebtTotal: '0.00', unrecoverAmount: '40000.00' }
			])
		).toEqual({
			amount: '40000.00',
			recoverAmount: '20000.00',
			badDebtTotal: '10000.00',
			unrecoverAmount: '10000.00'
		});
	});
});
