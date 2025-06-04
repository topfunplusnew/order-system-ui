/**
 * 精度控制工具函数
 */

/**
 * 格式化数值为指定精度
 * @param {number|string} value - 要格式化的数值
 * @param {number} precision - 小数位数
 * @returns {string} 格式化后的数值字符串
 */
export function formatPrecision(value, precision = 2) {
	if (!value || isNaN(value)) return '0.' + '0'.repeat(precision);
	return parseFloat(value).toFixed(precision);
}

/**
 * 高精度价格字段（4位小数）- 仅限输入单价
 */
export const HIGH_PRECISION_FIELDS = ['price', 'paymentUnload'];

/**
 * 标准精度字段（2位小数）- 包括计算结果和其他输入字段
 */
export const STANDARD_PRECISION_FIELDS = [
	// 输入字段
	'sundryCost',
	'landFreightPrice',
	'additionalFees',
	'seaFreight',
	'otherCost',
	'paymentsWithSundry',
	// 计算结果字段
	'paymentFactory',
	'payments',
	'landFreight',
	'freight',
	'profit',
	'profitNoTax',
	'tonnage',
	// 佣金和返利字段
	'logisticsProfit',
	'customerCommission',
	'factoryCommission',
	'factoryRebateAmount',
	'factoryDiscountAmount'
];

/**
 * 根据字段名获取对应的精度
 * @param {string} fieldName - 字段名
 * @returns {number} 精度位数
 */
export function getPrecisionByField(fieldName) {
	if (HIGH_PRECISION_FIELDS.includes(fieldName)) {
		return 4;
	}
	return 2;
}

/**
 * 批量格式化对象中的数值字段
 * @param {object} obj - 要格式化的对象
 * @param {array} fields - 要格式化的字段数组
 * @returns {object} 格式化后的对象
 */
export function formatObjectPrecision(obj, fields = []) {
	const result = { ...obj };
	fields.forEach(field => {
		if (result[field] !== undefined && result[field] !== null) {
			const precision = getPrecisionByField(field);
			result[field] = formatPrecision(result[field], precision);
		}
	});
	return result;
}

/**
 * 格式化计算结果为2位小数
 * @param {number|string} value - 计算结果值
 * @returns {string} 格式化后的2位小数字符串
 */
export function formatCalculationResult(value) {
	return formatPrecision(value, 2);
}
