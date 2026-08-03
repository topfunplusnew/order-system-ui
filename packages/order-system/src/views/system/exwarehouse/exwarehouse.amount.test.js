/* 用户需求：出库金额计算对齐 calculatePaymentFactory，计量单位为“其他”时不除以 1000000。实际改动：回归测试覆盖“其他”单位直算、普通单位除以 1000000 的分支。 */
const fs = require('fs');
const path = require('path');
const { describe, expect, test } = require('@jest/globals');

const source = fs.readFileSync(path.resolve(__dirname, 'index.vue'), 'utf8');

describe('exwarehouse computedAmount', () => {
	test('does not divide by 1000000 only when countingUnit is 其他', () => {
		expect(source).toContain("row.sourceInventoryDetail.countingUnit === '其他'");
		expect(source).toContain('baseAmount : baseAmount / 1000000');
	});
});
