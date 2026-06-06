import { describe, expect, test } from '@jest/globals';
import { buildRebateDiffFields, buildRebateRecordRows, mapRebateRecordToRow, resolveRebateScopedChange, sumRebateDiffRows } from '@/utils/fundChange/rebate';
import { CHANGE_ROW_SCOPE } from '@/utils/fundChange/dateScopedRows';
import { REBATE_COLUMNS } from '@/utils/fundChangeExcelColumns';

const originalRebate = {
	rebate: 98178.9533,
	supplier: '寿光新烁材料科技有限公司-龙通',
	unitPrice: 2,
	detailList: [{ actualReceived: 95422.04, actualReceivedDate: '2026-05-14 11:37:27' }],
	rebateDate: '2026-05-14 11:37:06',
	rebateType: '返利',
	rebateMethod: '1',
	rebateReason: '3月返利',
	receivedRebateDate: '2026-05-14 11:37:27'
};

const changedRebate = {
	...originalRebate,
	userName: '刘振龙',
	detailList: [
		{ actualReceived: 95022.04, actualReceivedDate: '2026-05-14 11:37:27' },
		{ actualReceived: 400, actualReceivedDate: '2026-05-24 13:00:00' }
	]
};

describe('rebate fund change helpers', () => {
	test('scopes rebate changes by detail actual received date', () => {
		expect(resolveRebateScopedChange(originalRebate, changedRebate, '2026-05-24')).toBe(CHANGE_ROW_SCOPE.AFTER);
	});

	test('maps backend rebate fields and scoped detail amount to displayed row fields', () => {
		expect(mapRebateRecordToRow(changedRebate, '2026-05-24')).toEqual({
			rebateDate: '2026-05-14 11:37:06',
			rebateType: '返利',
			supplierName: '寿光新烁材料科技有限公司-龙通',
			rebateMethod: '重箱',
			unitPrice: 2,
			rebateAmount: 98178.9533,
			rebateReason: '3月返利',
			receivedDate: '2026-05-24 13:00:00',
			receivedAmount: '400.00',
			actualReceivedTime: '2026-05-24 13:00:00',
			actualReceivedAmount: '400.00',
			remark: ''
		});
	});

	test('builds update rows with blank before side when only changed detail matches target date', () => {
		expect(
			buildRebateRecordRows({
				original: originalRebate,
				changed: changedRebate,
				targetDate: '2026-05-24',
				backupType: 'update',
				recordIndex: 1,
				backupTime: '2026-05-27'
			})
		).toEqual([
			{ recordIndex: 1, backupTime: '2026-05-27', rowType: 'before', subLabel: '修改前', isRecordFirst: true, recordRowCount: 3 },
			{
				rebateDate: '2026-05-14 11:37:06',
				rebateType: '返利',
				supplierName: '寿光新烁材料科技有限公司-龙通',
				rebateMethod: '重箱',
				unitPrice: 2,
				rebateAmount: 98178.9533,
				rebateReason: '3月返利',
				receivedDate: '2026-05-24 13:00:00',
				receivedAmount: '400.00',
				actualReceivedTime: '2026-05-24 13:00:00',
				actualReceivedAmount: '400.00',
				remark: '',
				recordIndex: 1,
				backupTime: '2026-05-27',
				rowType: 'after',
				subLabel: '修改后',
				recordRowCount: 3
			},
			{ rowType: 'diff', subLabel: '差额', recordRowCount: 3, receivedAmount: '400.00', supplierDiff: '400.00' }
		]);
	});

	test('builds received rebate amount diff for matching detail dates', () => {
		expect(buildRebateDiffFields(originalRebate, changedRebate, '2026-05-14')).toEqual({
			receivedAmount: '-400.00',
			supplierDiff: '-400.00'
		});
	});

	test('uses screenshot rebate columns without hidden supplier diff field', () => {
		expect(REBATE_COLUMNS.filter(column => column.prop !== 'supplierDiff').map(column => column.label)).toEqual([
			'计提返利日期',
			'类型',
			'供应商',
			'返利方式',
			'（返利/降价）单价',
			'金额',
			'返利原因',
			'收到返利日期',
			'收到返利金额',
			'实收返利时间',
			'实收金额',
			'备注'
		]);
	});

	test('sums received rebate amount diff rows for footer', () => {
		expect(sumRebateDiffRows([{ receivedAmount: '-3497.12' }, { receivedAmount: '9324.66' }])).toEqual({
			receivedAmount: '5827.54'
		});
	});
});
