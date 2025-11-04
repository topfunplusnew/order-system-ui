import { fix, fix_2 } from '../../../api/tool/format';

/**
 * 计算逻辑说明（根据出厂/销售是否含税的不同组合）：
 *
 * 1. 出厂含税：否，销售含税：否
 *    1) 出厂货款 = 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 *    2) 总货款   = 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 杂费
 *    3) 吨位     = (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 *    4) 运费     = 吨位 * 运费单价 + 加费
 *    5) 利润     = 总货款 - 出厂货款 - 运费
 *    6) 不含税利润 = 总货款 - 出厂货款 - 运费 - 其他费用
 *
 * 2. 出厂含税：是，销售含税：否
 *    1) 出厂货款 = 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 *    2) 总货款   = 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 杂费
 *    3) 吨位     = (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 *    4) 运费     = 吨位 * 运费单价 + 加费
 *    5) 利润     = 总货款 - 出厂货款 - 运费
 *    6) 不含税利润 = 总货款 - (出厂货款 / 1.075) - 运费 - 其他费用
 *
 * 3. 出厂含税：否，销售含税：是
 *    1) 出厂货款 = 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 *    2) 总货款   = 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 杂费
 *    3) 吨位     = (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 *    4) 运费     = 吨位 * 运费单价 + 加费
 *    5) 利润     = 总货款 - 出厂货款 - 运费
 *    6) 不含税利润 = (总货款 / 1.075) - 出厂货款 - 运费 - 其他费用
 *
 * 4. 出厂含税：是，销售含税：是
 *    1) 出厂货款 = 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 *    2) 总货款   = 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 杂费
 *    3) 吨位     = (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 *    4) 运费     = 吨位 * 运费单价 + 加费
 *    5) 利润     = 总货款 - 出厂货款 - 运费 （对于二次入库有问题 ，需要减去其他费用 ）
 *    6) 不含税利润 = 总货款 - 出厂货款 - (运费 * 1.075) - (厚度 * 长度 * 宽度 * 出厂片数 / 1000000 / 20 * 0.5) - 其他费用
 */

/**
 * 获取完整精度的数值（优先使用_raw字段，用于精确计算）
 * @param {object} row - 库存详情行数据
 * @param {string} field - 字段名
 * @returns {number} 完整精度的数值
 */
function getRawValue(row, field) {
	// 优先使用_raw字段（完整精度），如果没有则使用原字段
	const rawValue = row[`_${field}_raw`] !== undefined ? row[`_${field}_raw`] : row[field];
	return Number(rawValue) || 0;
}

/**
 * 设置计算后的值（保存完整精度到_raw字段，格式化值到显示字段）
 * 解决精度累积误差问题：计算时使用完整精度，显示时格式化
 * @param {object} row - 库存详情行数据
 * @param {string} field - 字段名
 * @param {number} rawValue - 完整精度的原始值
 * @param {number} precision - 显示精度（2或4位小数），默认2
 */
function setCalculatedValue(row, field, rawValue, precision = 2) {
	const numValue = Number(rawValue);
	if (isNaN(numValue)) {
		row[`_${field}_raw`] = 0;
		row[field] = precision === 2 ? fix_2(0) : fix(0);
		return;
	}
	// 保存完整精度值到 _raw 字段（用于后续计算）
	row[`_${field}_raw`] = numValue;
	// 保存格式化后的值到显示字段
	row[field] = precision === 2 ? fix_2(numValue) : fix(numValue);
}

/**
 * 安全减法，确保结果不为负
 * @param {number} base - 被减数
 * @param {number} subtractor - 减数
 * @returns {number} - 差值
 */
function safeSubtract(base, subtractor) {
	return Number(base) - Number(subtractor);
}

/**
 * 计算吨位
 * 规则: (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 * 注意：使用 Number() 转换确保使用完整数值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculateTonnage(row) {
	// 确保所有值都转换为Number类型，使用完整精度进行计算
	const height = Number(row.height) || 0;
	const erro = Number(row.erro) || 0;
	const length = Number(row.length) || 0;
	const width = Number(row.width) || 0;
	const pieces = Number(row.pieces) || 0;

	// 使用完整精度进行计算，保存完整精度值用于后续计算
	const rawTonnage = ((height - erro) * length * width * pieces) / 1000000 / 20 / 20;
	setCalculatedValue(row, 'tonnage', rawTonnage, 2); // 吨位显示2位小数，计算时使用完整精度
}

/**
 * 计算出厂货款
 * 规则:
 * - 当计量单位为"片"时: 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 * - 当计量单位为"其他"时: 长度 * 宽度 * 出厂片数 * 出厂单价 + 杂费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculatePaymentFactory(row) {
	// 使用完整精度值进行计算
	const length = Number(row.length) || 0;
	const width = Number(row.width) || 0;
	const pieces = Number(row.pieces) || 0;
	const price = getRawValue(row, 'price'); // 使用完整精度值
	const sundryCost = getRawValue(row, 'sundryCost'); // 使用完整精度值

	let rawPaymentFactory;
	if (row.countingUnit === '其他') {
		// 计量单位为"其他"时，不除以1000000
		rawPaymentFactory = length * width * pieces * price + sundryCost;
	} else {
		// 计量单位为"片"时，除以1000000（原来的逻辑）
		if (row.isIncludeTaxFactory === 0) {
			rawPaymentFactory = ((length * width * pieces) / 1000000) * price + sundryCost;
		} else {
			rawPaymentFactory = (length * width * pieces * price) / 1000000 + sundryCost;
		}
	}
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'paymentFactory', rawPaymentFactory, 2);
}

/**
 * 计算库存金额
 * 规则:
 * - 当计量单位为"片"时: 长度 * 宽度 * 入库片数 / 1000000 * 存货价 + 总货款杂费
 * - 当计量单位为"其他"时: 长度 * 宽度 * 入库片数 * 存货价 + 总货款杂费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculatePayment(row) {
	// 使用完整精度值进行计算
	const length = Number(row.length) || 0;
	const width = Number(row.width) || 0;
	const pieces = Number(row.pieces) || 0; // 库存使用pieces作为入库片数
	const paymentUnload = getRawValue(row, 'paymentUnload'); // 使用完整精度值
	const paymentsWithSundry = getRawValue(row, 'paymentsWithSundry'); // 使用完整精度值

	let rawPayments;
	if (row.countingUnit === '其他') {
		// 计量单位为"其他"时，不除以1000000
		rawPayments = length * width * pieces * paymentUnload + paymentsWithSundry;
	} else {
		// 计量单位为"片"时，除以1000000（原来的逻辑）
		if (row.isIncludeTaxFactory === 0 && row.isIncludeTaxSale === 0) {
			rawPayments = ((length * width * pieces) / 1000000) * paymentUnload + paymentsWithSundry;
		} else {
			rawPayments = (length * width * pieces * paymentUnload) / 1000000 + paymentsWithSundry;
		}
	}
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'payments', rawPayments, 2);
}

/**
 * 计算陆运费
 * 规则: (吨位 * 陆运费单价) + 加费
 * @param {object} row - 库存详情行数据
 */
function calculateLandFreight(row) {
	// 使用完整精度值进行计算
	const tonnage = fix_2(getRawValue(row, 'tonnage')); // 使用吨位的完整精度值
	const landFreightPrice = getRawValue(row, 'landFreightPrice');
	const additionalFees = getRawValue(row, 'additionalFees');
	const rawLandFreight = tonnage * landFreightPrice + additionalFees;
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'landFreight', rawLandFreight, 2);
}

/**
 * 计算总运费 (陆运 + 海运)
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 * @param {boolean} isSea - 是否包含海运
 */
function calculateTotalFreight(row, isSea) {
	// 使用完整精度值进行计算
	const landFreight = getRawValue(row, 'landFreight'); // 使用陆运费的完整精度值
	const seaFreight = isSea ? getRawValue(row, 'seaFreight') : 0; // 使用海运费的完整精度值
	const additionalFees = getRawValue(row, 'additionalFees'); // 使用加费的完整精度值
	const rawFreight = landFreight + seaFreight + additionalFees;
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'freight', rawFreight, 2);
}

/**
 * 计算利润
 * 规则: 库存金额 - 出厂货款 - 总运费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculateProfit(row) {
	// 使用完整精度值进行计算
	const payments = getRawValue(row, 'payments'); // 使用库存金额的完整精度值
	const paymentFactory = getRawValue(row, 'paymentFactory'); // 使用出厂货款的完整精度值
	const freight = getRawValue(row, 'freight'); // 使用总运费的完整精度值
	const rawProfit = payments - paymentFactory - freight;
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'profit', rawProfit, 2);
}

/**
 * 针对二次入库的特殊处理 需要减去其他费用
 * 规则: 库存金额 - 出厂货款 - 总运费 - 其他费用
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculateProfitOfSecondInventory(row) {
	// 使用完整精度值进行计算
	const payments = getRawValue(row, 'payments'); // 使用库存金额的完整精度值
	const paymentFactory = getRawValue(row, 'paymentFactory'); // 使用出厂货款的完整精度值
	const freight = getRawValue(row, 'freight'); // 使用总运费的完整精度值
	const otherCost = getRawValue(row, 'otherCost'); // 使用其他费用的完整精度值
	const rawProfit = payments - paymentFactory - freight - otherCost;
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'profit', rawProfit, 2);
}

/**
 * 计算不含税利润 (根据含税状态区分)
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 库存详情行数据
 */
function calculateProfitNoTax(row) {
	const taxRate = 1.075;
	// 使用完整精度值进行计算
	const numPayments = getRawValue(row, 'payments'); // 使用库存金额的完整精度值
	const numPaymentFactory = getRawValue(row, 'paymentFactory'); // 使用出厂货款的完整精度值
	const numFreight = getRawValue(row, 'freight'); // 使用总运费的完整精度值
	const numOtherCost = getRawValue(row, 'otherCost'); // 使用其他费用的完整精度值
	const numHeight = Number(row.height) || 0;
	const numLength = Number(row.length) || 0;
	const numWidth = Number(row.width) || 0;
	const numPieces = Number(row.pieces) || 0;
	const { isIncludeTaxFactory, isIncludeTaxSale } = row;

	let rawProfitNoTax;
	// 根据厂家和客户是否含税，匹配四种情况
	if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 0) {
		// Case 1 (否, 否): 库存金额 - 出厂货款 - 总运费 - 其他费用
		rawProfitNoTax = numPayments - numPaymentFactory - numFreight - numOtherCost;
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 0) {
		// Case 2 (是, 否): 库存金额 - (出厂货款 / 1.075) - 总运费 - 其他费用
		rawProfitNoTax = numPayments - numPaymentFactory / taxRate - numFreight - numOtherCost;
	} else if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 1) {
		// Case 3 (否, 是): (库存金额 / 1.075) - 出厂货款 - 总运费 - 其他费用
		rawProfitNoTax = numPayments / taxRate - numPaymentFactory - numFreight - numOtherCost;
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 1) {
		// Case 4 (是, 是): 库存金额 - 出厂货款 - (总运费 * 1.075) - (厚度 * 长度 * 宽度 * 出厂片数 / 1000000 / 20 * 0.5) - 其他费用
		const specialCost = ((numHeight * numLength * numWidth * numPieces) / 1000000 / 20) * 0.5;
		rawProfitNoTax = numPayments - numPaymentFactory - numFreight * taxRate - specialCost - numOtherCost;
	} else {
		rawProfitNoTax = 0; // 异常情况返回0
	}
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'profitNoTax', rawProfitNoTax, 2);
}

/**
 * 更新库存行项目的所有计算值
 */
export function updateInventoryRowCalculations(row, isSea, isLand, extraOptions = {}) {
	const { isSecondInventory = false } = extraOptions;
	// 计算吨位
	calculateTonnage(row);
	// 计算出厂货款
	calculatePaymentFactory(row);
	// 计算库存金额
	calculatePayment(row);

	if (isLand) {
		// 计算陆运费
		calculateLandFreight(row);
	} else {
		row.landFreight = 0;
	}

	// 计算总运费
	calculateTotalFreight(row, isSea);

	// 针对二次入库进行特殊处理
	if (isSecondInventory) {
		calculateProfitOfSecondInventory(row);
	} else {
		// 计算利润
		calculateProfit(row);
	}

	// 计算不含税利润
	calculateProfitNoTax(row);
}
