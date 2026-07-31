// 用户需求：首页所有金额在原数据小数不超过两位时保持原样，超过两位时四舍五入。实际改动：提供仅影响展示的统一金额格式化方法。
import { number, round } from 'mathjs';

export function formatHomepageAmount(value) {
	if (value === null || typeof value === 'undefined' || value === '') return value;

	const numericValue = number(value);
	if (!Number.isFinite(numericValue)) return value;

	const decimalPart = String(value).split('.')[1];
	const decimalPlaces = decimalPart ? decimalPart.replace(/[eE].*$/, '').length : 0;
	return decimalPlaces > 2 ? round(numericValue, 2) : value;
}
