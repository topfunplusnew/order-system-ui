import { describe, expect, test } from '@jest/globals';
import { buildReceiveDepositDiffFields, buildReceiveDepositRecordRows, mapReceiveDepositRecordToRow, resolveReceiveDepositScopedChange, sumReceiveDepositDiffRows } from '@/utils/fundChange/receiveDeposit';
import { DEPOSIT_MONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { CHANGE_ROW_SCOPE } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

const originalDeposit = {
	reason: '司机保证金',
	target: '王逊强',
	userName: '刘振龙',
	selfBankNo: '6228481259193023075',
	targetType: '客户',
	depositDate: '2025-10-31 00:00:00',
	moneyAmount: 80000,
	selfBankName: '河北省邢台市沙河金百家支行',
	targetBankNo: '6228481251439377910',
	depositCompany: '司机保证金',
	targetBankName: null,
	selfAccountsName: '孙梅-农行',
	unrefundedAmount: 70000,
	depositRefundList: [],
	targetAccountsName: '王逊强',
	comments: '实际收取时间2022-02-11'
};

const changedDeposit = {
	...originalDeposit,
	depositRefundList: [
		{
			refundDate: '2026-05-24 12:12:00',
			badDebtFlag: 0,
			moneyAmount: 10000,
			selfBankNo: '6229370100008135948',
			selfBankName: '德州银行股份有限公司东方红支行',
			otherBankNo: '2222222222222222222',
			selfAccountName: '张长勇-德州银行',
			otherAccountName: '平平安安'
		}
	]
};

describe('receive deposit fund change helpers', () => {
	test('scopes receive deposit records by depositDate', () => {
		expect(getFundChangeTemplateDateFields('ReceiveDepositTemplate')).toEqual(['depositDate']);
	});

	test('maps backend deposit_money fields to displayed row fields', () => {
		const row = mapReceiveDepositRecordToRow({
			reason: '司机保证金',
			target: '王逊强',
			userName: '刘振龙',
			selfBankNo: '6228481259193023075',
			targetType: '客户',
			depositDate: '2025-10-31 00:00:00',
			moneyAmount: 80000,
			selfBankName: '河北省邢台市沙河金百家支行',
			targetBankNo: '6228481251439377910',
			depositCompany: '司机保证金',
			targetBankName: null,
			selfAccountsName: '孙梅-农行',
			unrefundedAmount: 70000,
			depositRefundList: [{ moneyAmount: 10000, badDebtFlag: 0 }],
			targetAccountsName: '王逊强',
			comments: '实际收取时间2022-02-11'
		});

		expect(row).toEqual({
			depositCompany: '司机保证金',
			objectType: '客户',
			objectName: '王逊强',
			depositAmount: 80000,
			unrefundAmount: '70000.00',
			otherAccountName: '王逊强',
			otherAccountNo: '6228481251439377910',
			otherBankName: '',
			selfReceiveAccountName: '孙梅-农行',
			selfAccountNo: '6228481259193023075',
			selfBankName: '河北省邢台市沙河金百家支行',
			receiveTime: '2025-10-31',
			reason: '司机保证金',
			remark: '实际收取时间2022-02-11',
			operatorName: '刘振龙'
		});
	});

	test('computes unrefund amount from refund list snapshot before stale unrefundedAmount', () => {
		expect(mapReceiveDepositRecordToRow(originalDeposit).unrefundAmount).toBe('80000.00');
		expect(mapReceiveDepositRecordToRow(changedDeposit).unrefundAmount).toBe('70000.00');
	});

	test('scopes receive deposit changes by refundDate as well as depositDate', () => {
		expect(resolveReceiveDepositScopedChange(originalDeposit, changedDeposit, '2026-05-24')).toBe(CHANGE_ROW_SCOPE.AFTER);
	});

	test('builds update rows for refund-date scoped changes', () => {
		expect(
			buildReceiveDepositRecordRows({
				original: originalDeposit,
				changed: changedDeposit,
				targetDate: '2026-05-24',
				backupType: 'update',
				recordIndex: 1,
				backupTime: '2026-05-26'
			})
		).toEqual([
			{
				depositCompany: '司机保证金',
				objectType: '客户',
				objectName: '王逊强',
				depositAmount: 80000,
				unrefundAmount: '80000.00',
				otherAccountName: '王逊强',
				otherAccountNo: '6228481251439377910',
				otherBankName: '',
				selfReceiveAccountName: '孙梅-农行',
				selfAccountNo: '6228481259193023075',
				selfBankName: '河北省邢台市沙河金百家支行',
				receiveTime: '2025-10-31',
				reason: '司机保证金',
				remark: '实际收取时间2022-02-11',
				operatorName: '刘振龙',
				recordIndex: 1,
				backupTime: '2026-05-26',
				rowType: 'before',
				subLabel: '修改前',
				isRecordFirst: true,
				recordRowCount: 3
			},
			{
				depositCompany: '司机保证金',
				objectType: '客户',
				objectName: '王逊强',
				depositAmount: 80000,
				unrefundAmount: '70000.00',
				otherAccountName: '王逊强',
				otherAccountNo: '6228481251439377910',
				otherBankName: '',
				selfReceiveAccountName: '孙梅-农行',
				selfAccountNo: '6228481259193023075',
				selfBankName: '河北省邢台市沙河金百家支行',
				receiveTime: '2025-10-31',
				reason: '司机保证金',
				remark: '实际收取时间2022-02-11',
				operatorName: '刘振龙',
				recordIndex: 1,
				backupTime: '2026-05-26',
				rowType: 'after',
				subLabel: '修改后',
				recordRowCount: 3
			},
			{ rowType: 'diff', subLabel: '差额', recordRowCount: 3, depositAmount: '0.00', unrefundAmount: '-10000.00' }
		]);
	});

	test('falls back to refund list when unrefundedAmount is absent', () => {
		expect(
			mapReceiveDepositRecordToRow({
				moneyAmount: 80000,
				depositRefundList: [{ moneyAmount: 10000, badDebtFlag: 0 }]
			}).unrefundAmount
		).toBe('70000.00');
	});

	test('builds insert diff under amount columns', () => {
		expect(buildReceiveDepositDiffFields({}, { moneyAmount: 80000, unrefundedAmount: 80000 })).toEqual({
			depositAmount: '80000.00',
			unrefundAmount: '80000.00'
		});
	});

	test('uses receive deposit table columns without hidden diff field', () => {
		expect(DEPOSIT_MONEY_COLUMNS.filter(column => column.prop !== 'depositDiff').map(column => column.label)).toEqual([
			'保证金公司',
			'对象类型',
			'对象名称',
			'保证金金额',
			'未退款金额',
			'对方账户',
			'对方账号',
			'对方开户行',
			'我方收款账户',
			'我方账号',
			'我方开户行',
			'收取时间',
			'事由',
			'备注',
			'操作人员'
		]);
	});

	test('sums numeric diff columns for footer', () => {
		expect(
			sumReceiveDepositDiffRows([
				{ depositAmount: '0.00', unrefundAmount: '-40000.00' },
				{ depositAmount: '80000.00', unrefundAmount: '80000.00' }
			])
		).toEqual({
			depositAmount: '80000.00',
			unrefundAmount: '40000.00'
		});
	});
});
