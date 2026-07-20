/* 用户需求：创建主卡登记与副卡登记页面并严格区分字段和提交规则。实际改动：测试主副卡列配置、查询和导出参数、请求白名单及批量删除序列化。 */
/* global describe, test, expect */
import { buildLedgerColumns, buildLedgerExportParams, buildLedgerPayload, buildLedgerQuery, serializeLedgerIds } from './oilCardLedger.config';

describe('oil card ledger configuration', () => {
	test('builds documented main-card columns', () => {
		const columns = buildLedgerColumns('主卡');

		expect(columns).toHaveLength(13);
		expect(columns.map(column => column.label)).toEqual(['加油卡卡号', '使用加油卡时间', '使用加油卡车辆车牌号', '地点、事由', '充值金额', '期初余额', '主卡转副卡充值金额', '加油量（升）', '单价', '金额(元）', '是否有小票', '加油卡余额', '备注']);
		expect(columns[0].path).toEqual(['oilCard', 'oilCardNo']);
		expect(columns[2].path).toEqual(['vehicle', 'licensePlate']);
	});

	test('builds documented sub-card columns without recharge amount', () => {
		const columns = buildLedgerColumns('副卡');

		expect(columns).toHaveLength(12);
		expect(columns.some(column => column.prop === 'rechargeAmount')).toBe(false);
		expect(columns.find(column => column.prop === 'transferAmount').label).toBe('主卡转副卡圈存金额');
		expect(columns.find(column => column.prop === 'refuelingAmount').label).toBe('加油金额(元）');
	});

	test('maps page filters to backend query names and fixed card type', () => {
		expect(
			buildLedgerQuery(
				{
					pageNum: 2,
					pageSize: 20,
					oilCardNo: ' 1001 ',
					licensePlate: ' 鲁A1 ',
					hasReceipt: '是',
					locationReason: ' 加油 '
				},
				'主卡',
				['2026-04-01', '2026-04-30']
			)
		).toEqual({
			cardType: '主卡',
			pageNum: 2,
			pageSize: 20,
			'params[oilCardNo]': '1001',
			'params[licensePlate]': '鲁A1',
			'params[beginTime]': '2026-04-01',
			'params[endTime]': '2026-04-30',
			hasReceipt: '是',
			locationReason: '加油'
		});
	});

	test('removes pagination while retaining current filters for export', () => {
		const exportParams = buildLedgerExportParams({ pageNum: 3, pageSize: 20, oilCardNo: '1002' }, '副卡', []);

		expect(exportParams).toEqual({
			cardType: '副卡',
			'params[oilCardNo]': '1002'
		});
	});

	test('whitelists main-card payload fields and excludes backend fields', () => {
		const payload = buildLedgerPayload(
			{
				id: 8,
				oilCardId: 22,
				useDate: '2026-04-04 10:30:00',
				vehicleId: null,
				rechargeAmount: 5000,
				comments: '测试',
				cardType: '副卡',
				userName: '不应提交',
				oilCard: { oilCardNo: '1001' }
			},
			'主卡',
			true
		);

		expect(payload).toEqual({
			id: 8,
			oilCardId: 22,
			useDate: '2026-04-04 10:30:00',
			vehicleId: null,
			rechargeAmount: 5000,
			comments: '测试'
		});
	});

	test('removes id for create and recharge amount for sub-card payloads', () => {
		const payload = buildLedgerPayload({ id: 8, oilCardId: 31, useDate: '2026-04-04 14:00:00', rechargeAmount: 3000, openingBalance: 800 }, '副卡', false);

		expect(payload).toEqual({ oilCardId: 31, useDate: '2026-04-04 14:00:00', openingBalance: 800 });
	});

	test('serializes one or multiple ids for the delete path', () => {
		expect(serializeLedgerIds(7)).toBe('7');
		expect(serializeLedgerIds([7, 9])).toBe('7,9');
	});
});
