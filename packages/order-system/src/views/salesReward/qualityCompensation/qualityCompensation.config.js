/*
 * 用户需求：质量赔偿统计表无论填写/粘贴什么数据都不能再出现 NaN，并按 salesReward 附件接口支持上传、追加、替换和清空附件。
 * 实际改动：把金额解析、格式化、汇总、载荷白名单与附件 ID 归一化收敛为纯函数，页面与单测共用同一套规则。
 */

/** 本期页面固定的奖励类型 */
export const INCENTIVE_TYPE = '质量赔偿';

/** 金额为空时的占位文案 */
export const AMOUNT_PLACEHOLDER = '—';

/** 金额边界：最多 18 位整数、2 位小数，且不允许负数 */
export const AMOUNT_PATTERN = /^\d{1,18}(\.\d{1,2})?$/;

// 千分位逗号、半角/全角空格
const SEPARATOR_PATTERN = /[,\s\u00a0\u3000]/g;

/**
 * 把任意输入归一化成一串可解析的数字文本
 * 兼容全角数字、全角小数点、千分位逗号和粘贴进来的空格
 * @param {*} value - 原始输入
 * @returns {string} 归一化后的文本（可能为空串）
 */
export function normalizeNumericText(value) {
	if (value === null || value === undefined) return '';
	const text = String(value)
		.replace(/[\uff10-\uff19]/g, ch => String.fromCharCode(ch.charCodeAt(0) - 0xfee0)) // 全角数字 → 半角
		.replace(/[\uff0e\u3002]/g, '.') // 全角小数点、中文句号 → 小数点
		.replace(/[\uff0d\u2212\uff3f]/g, '-') // 全角负号、减号 → 半角
		.replace(SEPARATOR_PATTERN, ''); // 去掉千分位逗号与空格
	return text.trim();
}

/**
 * 把任意输入转成有限数字，永远不返回 NaN
 * @param {*} value - 原始输入
 * @returns {number|null} 有限数字；无法解析时返回 null
 */
export function toFiniteNumber(value) {
	if (value === null || value === undefined) return null;
	if (typeof value === 'number') return Number.isFinite(value) ? value : null;
	const text = normalizeNumericText(value);
	if (text === '') return null;
	const number = Number(text);
	return Number.isFinite(number) ? number : null;
}

/**
 * 展示用金额格式化：解析失败统一显示占位符，不再出现 NaN
 * @param {*} value - 原始金额
 * @param {string} [placeholder='—'] - 无法解析时的占位文案
 * @returns {string} 两位小数的金额文本或占位文案
 */
export function formatAmountText(value, placeholder = AMOUNT_PLACEHOLDER) {
	const number = toFiniteNumber(value);
	return number === null ? placeholder : number.toFixed(2);
}

/**
 * 输入过程中清洗金额文本：只保留数字与一个小数点，最多 18 位整数、2 位小数
 * @param {*} value - 输入框当前内容
 * @returns {string} 清洗后的文本
 */
export function sanitizeAmountInput(value) {
	if (value === null || value === undefined) return '';
	const digitsAndDots = normalizeNumericText(value).replace(/[^\d.]/g, '');
	if (digitsAndDots === '') return '';
	const dotIndex = digitsAndDots.indexOf('.');
	const integerRaw = dotIndex === -1 ? digitsAndDots : digitsAndDots.slice(0, dotIndex);
	const integerPart = integerRaw.replace(/^0+(?=\d)/, '').slice(0, 18);
	if (dotIndex === -1) return integerPart;
	const decimalPart = digitsAndDots
		.slice(dotIndex + 1)
		.replace(/\./g, '')
		.slice(0, 2);
	return `${integerPart}.${decimalPart}`;
}

/**
 * 失焦时的金额回显：合法则补两位小数，非法则清空（绝不写入 NaN 文本）
 * @param {*} value - 输入框当前内容
 * @returns {string|null} 两位小数的金额文本或 null
 */
export function normalizeAmountField(value) {
	if (value === null || value === undefined) return null;
	if (normalizeNumericText(value) === '') return null;
	const number = toFiniteNumber(value);
	return number === null ? null : number.toFixed(2);
}

/**
 * 可空金额校验：空值放行，非空必须是 0 或正整数 + 最多 2 位小数
 * @param {*} value - 待校验值
 * @returns {boolean} 是否合法
 */
export function isValidOptionalAmount(value) {
	if (value === null || value === undefined || normalizeNumericText(value) === '') return true;
	return AMOUNT_PATTERN.test(normalizeNumericText(value));
}

/**
 * 质量赔偿后剩余利润 = 综合单车利润 + 厂家赔偿我方金额 - 我方赔偿客户金额
 * 参与计算的任一项为空或非法都按 0 处理，结果恒为有限数字
 * @param {Object} [form] - 表单数据
 * @returns {number} 剩余利润
 */
export function calcRemainingProfit(form = {}) {
	const safe = value => {
		const number = toFiniteNumber(value);
		return number === null ? 0 : number;
	};
	return safe(form.comprehensiveProfit) + safe(form.manufacturerCompensationAmount) - safe(form.customerCompensationAmount);
}

/**
 * 表格合计行求和：跳过空值与非法值，结果恒为有限数字
 * @param {Array<Object>} rows - 表格数据
 * @param {string} prop - 字段名
 * @returns {number} 合计
 */
export function sumAmount(rows, prop) {
	return (Array.isArray(rows) ? rows : []).reduce((total, row) => {
		const number = toFiniteNumber(row ? row[prop] : null);
		return number === null ? total : total + number;
	}, 0);
}

const trimToNull = value => {
	if (value === null || value === undefined) return null;
	const text = String(value).trim();
	return text === '' ? null : text;
};

// 提交时保留完整数字文本（最长 18 位整数），避免转成 Number 后丢精度
const toPayloadAmount = value => {
	const text = normalizeNumericText(value);
	if (text === '') return null;
	return toFiniteNumber(value) === null ? null : text;
};

/**
 * 组装新增/修改质量赔偿的提交载荷（白名单字段，金额永远不会是 NaN）
 * @param {Object} [form] - 表单数据
 * @returns {Object} 提交载荷
 */
export function buildQualityCompensationPayload(form = {}) {
	const payload = {
		incentiveType: INCENTIVE_TYPE,
		orderId: form.orderId === null || form.orderId === undefined || form.orderId === '' ? null : form.orderId,
		manufacturerCompensationAmount: toPayloadAmount(form.manufacturerCompensationAmount),
		manufacturerCompensationDate: form.manufacturerCompensationDate || null,
		customerCompensationAmount: toPayloadAmount(form.customerCompensationAmount),
		customerCompensationDate: form.customerCompensationDate || null,
		qualityIssueDescription: trimToNull(form.qualityIssueDescription),
		remark: trimToNull(form.remark)
	};
	if (form.id !== null && form.id !== undefined && form.id !== '') payload.id = form.id;
	return payload;
}

/**
 * 归一化附件 ID：支持附件对象数组、ID 数组或混合数组，去重并丢弃空值
 * @param {Array<Object|number|string>} [attachmentList] - 附件列表
 * @returns {Array<number|string>} 去重后的附件 ID 列表
 */
export function normalizeAttachmentIds(attachmentList) {
	const ids = (Array.isArray(attachmentList) ? attachmentList : []).map(item => (item && typeof item === 'object' ? item.id : item)).filter(id => id !== null && id !== undefined && id !== '');
	return [...new Set(ids)];
}

/**
 * 判断两组附件 ID 是否等价（顺序无关），用于编辑时决定是否提交 params.attachmentIds
 * @param {Array<Object|number|string>} [left] - 附件列表 A
 * @param {Array<Object|number|string>} [right] - 附件列表 B
 * @returns {boolean} 是否等价
 */
export function isSameAttachmentIds(left, right) {
	const normalize = list => normalizeAttachmentIds(list).map(String).sort();
	const a = normalize(left);
	const b = normalize(right);
	return a.length === b.length && a.every((id, index) => id === b[index]);
}

/**
 * 从接口响应中取出最新附件列表：PUT 附件接口 data 直接返回列表，详情接口返回 data.attachmentList
 * @param {Object} response - 接口响应
 * @param {Array<Object>} [fallback] - 响应缺失时的兜底列表
 * @returns {Array<Object>} 附件列表
 */
export function resolveAttachmentList(response, fallback) {
	const data = response && response.data;
	if (Array.isArray(data)) return data;
	if (data && Array.isArray(data.attachmentList)) return data.attachmentList;
	return Array.isArray(fallback) ? [...fallback] : [];
}
