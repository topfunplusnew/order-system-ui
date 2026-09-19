/*
 * 用户需求：供应商返利相关数字统一使用 math.js 高精度计算，避免浮点误差、溢出和提交时精度丢失。
 * 实际改动：使用独立的 BigNumber 实例（至少 128 位，随输入位数提高）；尺寸、金额、汇总及比较直接解析十进制字符串，
 * 输出普通十进制字符串，金额按原规则保留小数；拒绝非法、非有限和已超出安全整数范围的 Number。
 */
import { create, bignumberDependencies, addDependencies, multiplyDependencies, divideDependencies, subtractDependencies, absDependencies } from 'mathjs';

export const rebateMath = create({ bignumberDependencies, addDependencies, multiplyDependencies, divideDependencies, subtractDependencies, absDependencies }, { number: 'BigNumber', precision: 128 });

export function decimal(value) {
	if (typeof value === 'number' && (!Number.isFinite(value) || (Number.isInteger(value) && !Number.isSafeInteger(value)))) {
		throw new Error('数值超出安全范围，请使用完整的十进制文本');
	}
	const text = value == null || value === '' ? '0' : String(value).trim();
	if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?$/i.test(text || '0')) throw new Error('请输入有效的数字');
	const result = rebateMath.bignumber(text || '0');
	if (!result.isFinite() || Math.abs(result.e) > 10000) throw new Error('数值超出可计算范围');
	// 面积/重箱与单价最多五个因子；按最大十进制跨度预留精度，
	// 同时覆盖大数与极小数混合累加，避免固定精度把小额流水舍掉。
	const requiredPrecision = Math.max(128, 16 * (Math.abs(result.e) + result.sd() + 1));
	if (requiredPrecision > rebateMath.config().precision) rebateMath.config({ precision: requiredPrecision });
	return result;
}

export function decimalText(value) {
	return decimal(value).toFixed();
}

export function decimalFixed(value, places = 4) {
	// 只在最终展示/金额边界四舍五入，不经过 Number 或全局 fix 工具。
	return decimal(value).toFixed(places, rebateMath.BigNumber.ROUND_HALF_UP);
}

export function calculateRebateBasis(goods = [], weight = false) {
	const total = goods.reduce((sum, row) => {
		let amount = rebateMath.multiply(decimal(row.length), decimal(row.width), decimal(row.pieces));
		if (weight) amount = rebateMath.multiply(amount, decimal(row.height));
		return rebateMath.add(sum, rebateMath.divide(amount, decimal(weight ? '20000000' : '1000000')));
	}, decimal('0'));
	return decimalText(total);
}

export function calculateRebateAmount(basis, unitPrice, places = 4) {
	return decimalFixed(rebateMath.multiply(decimal(basis), decimal(unitPrice)), places);
}

export function sumRebateAmounts(rows = [], field = 'actualReceived') {
	return decimalText(rows.reduce((sum, row) => rebateMath.add(sum, decimal(row[field])), decimal('0')));
}

export function exceedsRebate(current, existing, original) {
	return decimal(current).gt(decimal(original)) || rebateMath.add(decimal(existing), decimal(current)).gt(decimal(original));
}

export function isSameRebateAmount(left, right) {
	return decimal(left).eq(decimal(right));
}

export function hasRebateDifference(left, right) {
	return rebateMath.abs(rebateMath.subtract(decimal(left), decimal(right))).gt(decimal('0.01'));
}
