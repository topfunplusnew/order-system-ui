/*
 * 用户需求：供应商返利页面使用 math.js 高精度计算，避免小数误差、大数溢出和提交时丢精度。
 * 实际改动：验证面积/重箱、金额舍入、流水累加和比较，以及非法数值拦截与十进制字符串序列化。
 */
/* global describe, test, expect */
import { rebateMath, decimal, decimalText, decimalFixed, calculateRebateBasis, calculateRebateAmount, sumRebateAmounts, exceedsRebate, isSameRebateAmount, hasRebateDifference } from './rebateMath';

describe('返利 BigNumber 计算', () => {
	test('十进制相加与金额比较不会把 0.1 + 0.2 判为超过 0.3', () => {
		expect(sumRebateAmounts([{ actualReceived: '0.1' }, { actualReceived: '0.2' }])).toBe('0.3');
		expect(exceedsRebate('0.1', '0.2', '0.3')).toBe(false);
		expect(exceedsRebate('0.1', '0.2001', '0.3')).toBe(true);
		expect(exceedsRebate('2', '0', '10')).toBe(false);
	});

	test('尺寸直接从字符串计算，先累加基数再统一舍入金额', () => {
		const rows = [
			{ length: '1000.1', width: '1000', pieces: '0.1', height: '0.2' },
			{ length: '1000.1', width: '1000', pieces: '0.2', height: '0.2' }
		];
		expect(calculateRebateBasis(rows, false)).toBe('0.30003');
		expect(calculateRebateBasis(rows, true)).toBe('0.0030003');
		expect(calculateRebateAmount('0.30003', '0.5')).toBe('0.1500');
		expect(calculateRebateAmount('1', '1.23455')).toBe('1.2346');
		expect(calculateRebateAmount('1', '-1.23455')).toBe('-1.2346');
	});

	test('超过 Number 安全整数范围仍保留小数，并可序列化为字符串', () => {
		const result = calculateRebateAmount('9007199254740993.1234', '2');
		expect(result).toBe('18014398509481986.2468');
		expect(JSON.stringify({ rebate: result })).toBe('{"rebate":"18014398509481986.2468"}');
		expect(sumRebateAmounts([{ actualReceived: '9007199254740993.1' }, { actualReceived: '0.2' }])).toBe('9007199254740993.3');
	});

	test('极大金额加小数时自动提高有效精度，大额超收一分钱仍准确识别', () => {
		expect(sumRebateAmounts([{ actualReceived: '1e200' }, { actualReceived: '0.1' }])).toBe('1' + '0'.repeat(200) + '.1');
		expect(exceedsRebate('0.01', '9007199254740993.3', '9007199254740993.3')).toBe(true);
	});

	test('超出普通浮点数范围的乘积不会变成 Infinity', () => {
		const result = calculateRebateAmount('1e200', '1e200');
		expect(result).toBe('1' + '0'.repeat(400) + '.0000');
		expect(result).not.toMatch(/Infinity|NaN|e\+/);
	});

	test('空值为零，金额手动编辑判断按数值而非字符串类型比较', () => {
		expect(calculateRebateBasis([{}], false)).toBe('0');
		expect(isSameRebateAmount('4', '4.0000')).toBe(true);
		expect(hasRebateDifference('9007199254740993.02', '9007199254740993.01')).toBe(false);
		expect(hasRebateDifference('9007199254740993.0201', '9007199254740993.01')).toBe(true);
	});

	test.each(['abc', 'Infinity', '-Infinity', 'NaN', Infinity, NaN, 9007199254740992])('拒绝非法或已丢精度的数值 %s', value => {
		expect(() => decimal(value)).toThrow();
	});

	test('货物合计保留两位小数，且隔离配置不修改 math.js 默认实例', () => {
		expect(decimalFixed(rebateMath.add(decimal('9007199254740993.10'), decimal('0.20')), 2)).toBe('9007199254740993.30');
		expect(decimalText(decimal(null))).toBe('0');
		expect(require('mathjs').config().number).toBe('number');
	});
});
