// 用户需求：首页所有金额在小数不超过两位时保留原数据，超过两位时四舍五入。实际改动：新增首页金额格式化规则及首页各金额展示入口的覆盖测试。
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';
import { formatHomepageAmount } from './homepageAmount';

describe('homepage amount formatting', () => {
	test('preserves values with at most two decimal places', () => {
		expect(formatHomepageAmount(12)).toBe(12);
		expect(formatHomepageAmount('12.3')).toBe('12.3');
		expect(formatHomepageAmount('12.30')).toBe('12.30');
		expect(formatHomepageAmount(null)).toBe(null);
	});

	test('rounds values with more than two decimal places', () => {
		expect(formatHomepageAmount(12.345)).toBe(12.35);
		expect(formatHomepageAmount('-12.344')).toBe(-12.34);
		expect(formatHomepageAmount('12034.080')).toBe(12034.08);
	});

	test('uses the formatter for every homepage amount display', () => {
		const source = fs.readFileSync(path.join(__dirname, 'index.vue'), 'utf8');
		const amountFields = ['arrears', 'profit', 'profitNoTax', 'payments', 'paymentFactory', 'freight'];

		amountFields.forEach(field => {
			expect(source).toContain(`formatHomepageAmount(scope.row.${field})`);
		});
		expect(source).toContain('`￥${formatHomepageAmount(moneyAmount)}`');
		expect(source).toContain('formatHomepageAmount(dailyProfit.dailyProfit)');
		expect(source).toContain('formatHomepageAmount(dailyExpense)');
		expect(source).toContain('sums[index] = formatHomepageAmount(total)');
	});
});
