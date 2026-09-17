/*
 * 用户需求：批量开票大弹窗的公司列表增加时间列（invoiceDate），数据按 invoiceDate 再拆分，并支持按 invoiceDate 搜索。
 * 实际改动：新增开票时间归一化、公司行聚合唯一键、日期范围匹配三个纯函数，供 BatchInvoicePanel 拆分与筛选使用。
 */
/* global describe, test, expect */
import { buildCompanyRowKey, buildInvoiceDateByBatchRowId, isInvoiceDateInRange, normalizeInvoiceDate, withFallbackInvoiceDate } from './companyInvoiceDate';

describe('normalizeInvoiceDate', () => {
	test('带时分秒的开票时间按天归一化', () => {
		expect(normalizeInvoiceDate('2024-07-27 10:23:45')).toBe('2024-07-27');
	});

	test('仅日期的开票时间保持原样', () => {
		expect(normalizeInvoiceDate('2024-07-27')).toBe('2024-07-27');
	});

	test('补零到 yyyy-MM-dd', () => {
		expect(normalizeInvoiceDate('2024-7-5 08:00:00')).toBe('2024-07-05');
	});

	test('空值返回空字符串', () => {
		expect(normalizeInvoiceDate(null)).toBe('');
		expect(normalizeInvoiceDate(undefined)).toBe('');
		expect(normalizeInvoiceDate('')).toBe('');
	});

	test('非日期格式原样返回，避免误判', () => {
		expect(normalizeInvoiceDate('待开票')).toBe('待开票');
	});
});

describe('buildCompanyRowKey', () => {
	test('同一公司同一我方公司同一天使用同一个键', () => {
		const first = buildCompanyRowKey(1001, '我方A', '2024-07-27 10:23:45');
		const second = buildCompanyRowKey('1001', '我方A', '2024-07-27');
		expect(first).toBe(second);
	});

	test('不同开票日期拆分为不同的键', () => {
		expect(buildCompanyRowKey(1001, '我方A', '2024-07-27')).not.toBe(buildCompanyRowKey(1001, '我方A', '2024-07-28'));
	});

	test('不同我方公司拆分为不同的键', () => {
		expect(buildCompanyRowKey(1001, '我方A', '2024-07-27')).not.toBe(buildCompanyRowKey(1001, '我方B', '2024-07-27'));
	});

	test('未开票（无开票时间）与已开票拆分为不同的键', () => {
		expect(buildCompanyRowKey(1001, '我方A', null)).not.toBe(buildCompanyRowKey(1001, '我方A', '2024-07-27'));
	});
});

describe('isInvoiceDateInRange', () => {
	test('未选择范围时全部匹配', () => {
		expect(isInvoiceDateInRange('2024-07-27', [])).toBe(true);
		expect(isInvoiceDateInRange(null, null)).toBe(true);
	});

	test('落在范围内（含边界）时匹配', () => {
		expect(isInvoiceDateInRange('2024-07-27 10:23:45', ['2024-07-27', '2024-07-28'])).toBe(true);
		expect(isInvoiceDateInRange('2024-07-28', ['2024-07-27', '2024-07-28'])).toBe(true);
	});

	test('超出范围时不匹配', () => {
		expect(isInvoiceDateInRange('2024-07-26', ['2024-07-27', '2024-07-28'])).toBe(false);
		expect(isInvoiceDateInRange('2024-07-29', ['2024-07-27', '2024-07-28'])).toBe(false);
	});

	test('指定范围时未开票（无开票时间）的记录不匹配', () => {
		expect(isInvoiceDateInRange(null, ['2024-07-27', '2024-07-28'])).toBe(false);
		expect(isInvoiceDateInRange('', ['2024-07-27', '2024-07-28'])).toBe(false);
	});
});

describe('buildInvoiceDateByBatchRowId', () => {
	test('按批次行ID收集开票时间', () => {
		const map = buildInvoiceDateByBatchRowId([
			{ batchInvoiceId: 11, invoiceDate: '2024-07-27 10:00:00' },
			{ batchInvoiceId: 22, invoiceDate: '2024-07-28 09:30:00' }
		]);

		expect(map.get(11)).toBe('2024-07-27 10:00:00');
		expect(map.get(22)).toBe('2024-07-28 09:30:00');
	});

	test('同一批次行多条发票时保留最后一次开票时间', () => {
		const map = buildInvoiceDateByBatchRowId([
			{ batchInvoiceId: 11, invoiceDate: '2024-07-27 10:00:00' },
			{ batchInvoiceId: 11, invoiceDate: '2024-07-29 11:00:00' }
		]);

		expect(map.size).toBe(1);
		expect(map.get(11)).toBe('2024-07-29 11:00:00');
	});

	test('跳过没有批次行ID或没有开票时间的发票（如按订单单独开票）', () => {
		const map = buildInvoiceDateByBatchRowId([{ batchInvoiceId: null, invoiceDate: '2024-07-27 10:00:00' }, { batchInvoiceId: 33, invoiceDate: null }, { batchInvoiceId: '', invoiceDate: '2024-07-27 10:00:00' }, null, { batchInvoiceId: 44, invoiceDate: '2024-07-27 10:00:00' }]);

		expect([...map.keys()]).toEqual([44]);
	});

	test('非数组入参返回空 Map', () => {
		expect(buildInvoiceDateByBatchRowId(undefined).size).toBe(0);
		expect(buildInvoiceDateByBatchRowId(null).size).toBe(0);
	});
});

describe('withFallbackInvoiceDate', () => {
	test('后端有开票时间时不覆盖', () => {
		const row = { id: 11, invoiceDate: '2024-07-27 10:00:00' };
		expect(withFallbackInvoiceDate(row, new Map([[11, '2024-07-30 10:00:00']]))).toBe(row);
	});

	test('后端缺失时补上本批记录的开票时间', () => {
		const row = { id: 11, invoiceDate: null };
		expect(withFallbackInvoiceDate(row, new Map([[11, '2024-07-30 10:00:00']])).invoiceDate).toBe('2024-07-30 10:00:00');
	});

	test('映射里没有该行时原样返回', () => {
		const row = { id: 99, invoiceDate: null };
		expect(withFallbackInvoiceDate(row, new Map([[11, '2024-07-30 10:00:00']]))).toBe(row);
	});

	test('空行或空映射安全返回', () => {
		expect(withFallbackInvoiceDate(null, new Map())).toBeNull();
		expect(withFallbackInvoiceDate({ id: 1 }, null)).toEqual({ id: 1 });
	});
});
