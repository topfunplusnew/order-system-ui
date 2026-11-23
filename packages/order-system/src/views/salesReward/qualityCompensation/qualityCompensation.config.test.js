/*
 * 用户需求：质量赔偿统计表不能出现 NaN，并按 salesReward 附件接口支持上传/追加/替换/清空。
 * 实际改动：以单测固定金额解析、清洗、合计、载荷白名单和附件 ID 归一化规则。
 */
/* global describe, test, expect */
import {
	AMOUNT_PLACEHOLDER,
	INCENTIVE_TYPE,
	buildQualityCompensationPayload,
	calcRemainingProfit,
	formatAmountText,
	isSameAttachmentIds,
	isValidOptionalAmount,
	normalizeAmountField,
	normalizeAttachmentIds,
	normalizeNumericText,
	resolveAttachmentList,
	sanitizeAmountInput,
	sumAmount,
	toFiniteNumber
} from './qualityCompensation.config';

describe('质量赔偿金额解析与展示永不为 NaN', () => {
	test('无法解析的金额统一显示占位符', () => {
		[null, undefined, '', '   ', 'abc', '100元', NaN, Infinity].forEach(value => {
			expect(formatAmountText(value)).toBe(AMOUNT_PLACEHOLDER);
		});
	});

	test('兼容千分位、全角数字与首尾空格', () => {
		expect(formatAmountText('1,234.56')).toBe('1234.56');
		expect(formatAmountText('１２３')).toBe('123.00');
		expect(formatAmountText(' 100 ')).toBe('100.00');
		expect(formatAmountText(0)).toBe('0.00');
		expect(formatAmountText(1234.5678)).toBe('1234.57');
		expect(formatAmountText('100')).toBe('100.00');
	});

	test('toFiniteNumber 只返回有限数字或 null', () => {
		expect(toFiniteNumber('1,000')).toBe(1000);
		expect(toFiniteNumber('１２')).toBe(12);
		expect(toFiniteNumber('')).toBeNull();
		expect(toFiniteNumber('abc')).toBeNull();
		expect(toFiniteNumber(NaN)).toBeNull();
		expect(normalizeNumericText('1,２３４.５')).toBe('1234.5');
	});

	test('剩余利润公式对空值和非法值按 0 处理', () => {
		expect(calcRemainingProfit({ comprehensiveProfit: 1000, manufacturerCompensationAmount: 100, customerCompensationAmount: 50 })).toBe(1050);
		expect(calcRemainingProfit({ comprehensiveProfit: '1,000.50', manufacturerCompensationAmount: '100', customerCompensationAmount: '' })).toBe(1100.5);
		expect(calcRemainingProfit({ comprehensiveProfit: null, manufacturerCompensationAmount: undefined, customerCompensationAmount: 'abc' })).toBe(0);
		expect(Number.isFinite(calcRemainingProfit({}))).toBe(true);
	});

	test('合计行跳过空值与非法值', () => {
		const rows = [{ orderProfit: '1,234.56' }, { orderProfit: null }, { orderProfit: 'abc' }, { orderProfit: '10.44' }];
		expect(sumAmount(rows, 'orderProfit').toFixed(2)).toBe('1245.00');
		expect(sumAmount([], 'orderProfit')).toBe(0);
		expect(sumAmount(null, 'orderProfit')).toBe(0);
	});

	test('输入清洗只保留数字与一个小数点', () => {
		expect(sanitizeAmountInput('1,234.56')).toBe('1234.56');
		expect(sanitizeAmountInput('１２３')).toBe('123');
		expect(sanitizeAmountInput('100元')).toBe('100');
		expect(sanitizeAmountInput('abc')).toBe('');
		expect(sanitizeAmountInput('1.2.3')).toBe('1.23');
		expect(sanitizeAmountInput('00123')).toBe('123');
		expect(sanitizeAmountInput('12.345')).toBe('12.34');
		expect(sanitizeAmountInput('-50')).toBe('50');
		expect(sanitizeAmountInput('1'.repeat(30))).toHaveLength(18);
	});

	test('失焦回显不再写入 NaN 文本', () => {
		expect(normalizeAmountField('100')).toBe('100.00');
		expect(normalizeAmountField('1,234.56')).toBe('1234.56');
		expect(normalizeAmountField('')).toBeNull();
		expect(normalizeAmountField(null)).toBeNull();
		expect(normalizeAmountField('abc')).toBeNull();
		expect(normalizeAmountField('１２３')).toBe('123.00');
	});

	test('可空金额校验允许空值并拒绝负数与超精度', () => {
		expect(isValidOptionalAmount('')).toBe(true);
		expect(isValidOptionalAmount(null)).toBe(true);
		expect(isValidOptionalAmount('0')).toBe(true);
		expect(isValidOptionalAmount('100.5')).toBe(true);
		expect(isValidOptionalAmount('-1')).toBe(false);
		expect(isValidOptionalAmount('1.234')).toBe(false);
		expect(isValidOptionalAmount('abc')).toBe(false);
	});
});

describe('质量赔偿提交载荷', () => {
	test('白名单字段并归一化金额', () => {
		const payload = buildQualityCompensationPayload({
			incentiveType: '被忽略',
			orderId: 9,
			manufacturerCompensationAmount: '1,000',
			manufacturerCompensationDate: '2026-01-02',
			customerCompensationAmount: '',
			customerCompensationDate: null,
			qualityIssueDescription: '  破损  ',
			remark: '  ',
			auditState: '已审核'
		});
		expect(payload).toEqual({
			incentiveType: INCENTIVE_TYPE,
			orderId: 9,
			manufacturerCompensationAmount: '1000',
			manufacturerCompensationDate: '2026-01-02',
			customerCompensationAmount: null,
			customerCompensationDate: null,
			qualityIssueDescription: '破损',
			remark: null
		});
	});

	test('只在有主键时带 id，非法金额不进入载荷', () => {
		expect(buildQualityCompensationPayload({ orderId: 1 }).id).toBeUndefined();
		const payload = buildQualityCompensationPayload({ id: 5, orderId: 1, manufacturerCompensationAmount: 'abc' });
		expect(payload.id).toBe(5);
		expect(payload.manufacturerCompensationAmount).toBeNull();
	});

	test('超长金额按原文提交，不因转 Number 丢精度', () => {
		expect(buildQualityCompensationPayload({ orderId: 1, customerCompensationAmount: '123456789012345678' }).customerCompensationAmount).toBe('123456789012345678');
		expect(buildQualityCompensationPayload({ orderId: 1, customerCompensationAmount: '１２.５' }).customerCompensationAmount).toBe('12.5');
	});
});

describe('质量赔偿附件 ID 处理', () => {
	test('附件 ID 去重并丢弃空值', () => {
		expect(normalizeAttachmentIds([{ id: 81 }, { id: 82 }, { id: 81 }, { id: null }, null, 83])).toEqual([81, 82, 83]);
		expect(normalizeAttachmentIds([])).toEqual([]);
		expect(normalizeAttachmentIds(null)).toEqual([]);
	});

	test('比较附件是否变化时不关心顺序', () => {
		expect(isSameAttachmentIds([{ id: 81 }, { id: 82 }], [82, 81])).toBe(true);
		expect(isSameAttachmentIds([81], [81, 82])).toBe(false);
		expect(isSameAttachmentIds([], [])).toBe(true);
	});

	test('保存成功后优先使用接口返回的最新附件列表', () => {
		const fallback = [{ id: 81 }];
		expect(resolveAttachmentList({ data: [{ id: 81 }, { id: 82 }] }, fallback)).toEqual([{ id: 81 }, { id: 82 }]);
		expect(resolveAttachmentList({ data: { attachmentList: [{ id: 9 }] } }, fallback)).toEqual([{ id: 9 }]);
		expect(resolveAttachmentList({ data: null }, fallback)).toEqual([{ id: 81 }]);
	});
});
