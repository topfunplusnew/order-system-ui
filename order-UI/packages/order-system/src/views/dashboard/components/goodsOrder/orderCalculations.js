import { fix, fix_2 } from '../../../../api/tool/format';
import { round, subtract, add, multiply, divide } from 'mathjs';
/**
 * 特殊字段列表：这些字段需要保持用户输入的完整精度（不截断）
 * - price: 出厂单价
 * - paymentUnload: 卸货价
 */
const SPECIAL_PRECISION_FIELDS = ['price', 'paymentUnload'];

/**
 * 获取用于计算的数值（优先使用_raw字段）
 * 特殊字段（price, paymentUnload）：使用完整精度
 * 其他字段：先保留两位小数再计算
 * @param {object} row - 订单详情行数据
 * @param {string} field - 字段名
 * @returns {number} 用于计算的数值
 */
function getRawValue(row, field) {
	// 优先使用_raw字段（完整精度），如果没有则使用原字段
	const rawValue = row[`_${field}_raw`] !== undefined ? row[`_${field}_raw`] : row[field];
	const numValue = Number(rawValue) || 0;

	// 判断是否为特殊字段
	const isSpecialField = SPECIAL_PRECISION_FIELDS.includes(field);

	if (isSpecialField) {
		// 特殊字段：使用完整精度
		return numValue;
	} else {
		// 其他字段：先保留两位小数再计算，使用 mathjs 确保精度
		return round(numValue, 2);
	}
}

/**
 * 设置计算后的值（保存完整精度到_raw字段，格式化值到显示字段）
 * 解决精度累积误差问题：计算时使用完整精度，显示时格式化
 * @param {object} row - 订单详情行数据
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
 * 计算吨位
 * 规则: (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 * 注意：使用 Number() 转换确保使用完整数值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
 */
function calculateTonnage(row) {
	// 确保所有值都转换为Number类型，使用完整精度进行计算
	const height = Number(row.height) || 0;
	const erro = Number(row.erro) || 0;
	const length = Number(row.length) || 0;
	const width = Number(row.width) || 0;
	const pieces = Number(row.pieces) || 0;

	// 使用 mathjs 进行精确计算，避免浮点数精度误差
	const rawTonnage = divide(divide(divide(multiply(multiply(multiply(subtract(height, erro), length), width), pieces), 1000000), 20), 20);
	// 四舍五入到两位小数，确保精度
	const roundedTonnage = round(rawTonnage, 2);
	setCalculatedValue(row, 'tonnage', roundedTonnage, 2); // 吨位显示2位小数，计算时使用完整精度
}

/**
 * 计算出厂货款
 * 规则:
 * - 当计量单位为"片"时: 长度 * 宽度 * 出厂片数 / 1000000 * 出厂单价 + 杂费
 * - 当计量单位为"其他"时: 长度 * 宽度 * 出厂片数 * 出厂单价 + 杂费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
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
		// 使用 mathjs 进行精确计算
		rawPaymentFactory = add(multiply(multiply(multiply(length, width), pieces), price), sundryCost);
	} else {
		// 计量单位为"片"时，除以1000000（原来的逻辑）
		// 使用 mathjs 进行精确计算
		rawPaymentFactory = add(multiply(divide(multiply(multiply(length, width), pieces), 1000000), price), sundryCost);
	}
	// 四舍五入到两位小数，确保精度
	const roundedPaymentFactory = round(rawPaymentFactory, 2);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'paymentFactory', roundedPaymentFactory, 2);
}

/**
 * 计算总货款
 * 规则:
 * - 当计量单位为"片"时: 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 总货款杂费
 * - 当计量单位为"其他"时: 长度 * 宽度 * 卸货片数 * 卸货单价 + 总货款杂费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
 */
function calculatePayment(row) {
	// 使用完整精度值进行计算
	const length = Number(row.length) || 0;
	const width = Number(row.width) || 0;
	const actualPieces = Number(row.actualPieces) || 0;
	const paymentUnload = getRawValue(row, 'paymentUnload'); // 使用完整精度值
	const paymentsWithSundry = getRawValue(row, 'paymentsWithSundry'); // 使用完整精度值

	let rawPayments;
	if (row.countingUnit === '其他') {
		// 计量单位为"其他"时，不除以1000000
		// 使用 mathjs 进行精确计算
		rawPayments = add(multiply(multiply(multiply(length, width), actualPieces), paymentUnload), paymentsWithSundry);
	} else {
		// 计量单位为"片"时，除以1000000（原来的逻辑）
		// 使用 mathjs 进行精确计算
		rawPayments = add(multiply(divide(multiply(multiply(length, width), actualPieces), 1000000), paymentUnload), paymentsWithSundry);
	}
	// 四舍五入到两位小数，确保精度
	const roundedPayments = round(rawPayments, 2);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'payments', roundedPayments, 2);
}

/**
 * 计算陆运费
 * 规则: (吨位 * 陆运费单价) + 加费
 * 注意：吨位、陆运费单价、加费都是非特殊字段，会先保留两位再计算
 * @param {object} row - 订单详情行数据
 */
function calculateLandFreight(row) {
	// 吨位、陆运费单价、加费都是非特殊字段，getRawValue会自动保留两位小数
	const tonnage = getRawValue(row, 'tonnage');
	const landFreightPrice = getRawValue(row, 'landFreightPrice');
	const additionalFees = getRawValue(row, 'additionalFees');
	// 使用 mathjs 进行精确计算
	const rawLandFreight = add(multiply(tonnage, landFreightPrice), additionalFees);
	// 四舍五入到两位小数，确保精度
	const roundedLandFreight = round(rawLandFreight, 2);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'landFreight', roundedLandFreight, 2);
}

/**
 * 计算总运费 (陆运 + 海运)
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
 * @param {boolean} isSea - 是否包含海运
 */
function calculateTotalFreight(row, isSea) {
	// 使用完整精度值进行计算
	const landFreight = getRawValue(row, 'landFreight'); // 使用陆运费的完整精度值
	const seaFreight = isSea ? getRawValue(row, 'seaFreight') : 0; // 使用海运费的完整精度值
	// 使用 mathjs 进行精确计算
	const rawFreight = add(landFreight, seaFreight);
	// 四舍五入到两位小数，确保精度
	const roundedFreight = round(rawFreight, 2);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'freight', roundedFreight, 2);
}

/**
 * 计算利润
 * 规则: 总货款 - 出厂货款 - 总运费
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
 */
function calculateProfit(row) {
	// 使用完整精度值进行计算
	const payments = getRawValue(row, 'payments'); // 使用总货款的完整精度值
	const paymentFactory = getRawValue(row, 'paymentFactory'); // 使用出厂货款的完整精度值
	const freight = getRawValue(row, 'freight'); // 使用总运费的完整精度值
	console.log(`payments,paymentFactory,freight`, payments, paymentFactory, freight);
	// 使用 mathjs 进行精确计算，避免浮点数精度误差
	const rawProfit = subtract(subtract(payments, paymentFactory), freight);
	// 四舍五入到两位小数，确保精度
	const roundedProfit = round(rawProfit, 2);
	console.log(`rawProfit`, roundedProfit);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'profit', roundedProfit, 2);
}

/**
 * 计算不含税利润 (根据含税状态区分)
 * 注意：使用完整精度值进行计算，保持计算精度
 * @param {object} row - 订单详情行数据
 */
function calculateProfitNoTax(row) {
	const taxRate = 1.075;
	// 使用完整精度值进行计算
	const numPayments = getRawValue(row, 'payments'); // 使用总货款的完整精度值
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
		// Case 1 (否, 否): 总货款 - 出厂货款 - 总运费 - 其他费用
		// 使用 mathjs 进行精确计算，避免浮点数精度误差
		rawProfitNoTax = subtract(subtract(subtract(numPayments, numPaymentFactory), numFreight), numOtherCost);
		console.log(`rawProfitNoTax`, rawProfitNoTax);
		console.log(`numPayments,numPaymentFactory,numFreight,numOtherCost`, numPayments, numPaymentFactory, numFreight, numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 0) {
		// Case 2 (是, 否): 总货款 - (出厂货款 / 1.075) - 总运费 - 其他费用
		const paymentFactoryNoTax = divide(numPaymentFactory, taxRate);
		rawProfitNoTax = subtract(subtract(subtract(numPayments, paymentFactoryNoTax), numFreight), numOtherCost);
		console.log(`rawProfitNoTax`, rawProfitNoTax);
		console.log(`numPayments,numPaymentFactory,numFreight,numOtherCost`, numPayments, numPaymentFactory, numFreight, numOtherCost);
	} else if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 1) {
		// Case 3 (否, 是): (总货款 / 1.075) - 出厂货款 - 总运费 - 其他费用
		const paymentsNoTax = divide(numPayments, taxRate);
		rawProfitNoTax = subtract(subtract(subtract(paymentsNoTax, numPaymentFactory), numFreight), numOtherCost);
		console.log(`rawProfitNoTax`, rawProfitNoTax);
		console.log(`numPayments,numPaymentFactory,numFreight,numOtherCost`, numPayments, numPaymentFactory, numFreight, numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 1) {
		// Case 4 (是, 是): (总货款 - 出厂货款 - 总运费 * 1.075 - (厚度 * 长度 * 宽度 * 出厂片数 / 1000000 / 20 * 0.5) - 其他费用
		const specialCost = multiply(divide(divide(multiply(multiply(multiply(numHeight, numLength), numWidth), numPieces), 1000000), 20), 0.5);
		const freightWithTax = multiply(numFreight, taxRate);
		rawProfitNoTax = subtract(subtract(subtract(subtract(numPayments, numPaymentFactory), freightWithTax), specialCost), numOtherCost);
		console.log(`rawProfitNoTax`, rawProfitNoTax);
		console.log(`numPayments,numPaymentFactory,numFreight,numOtherCost`, numPayments, numPaymentFactory, numFreight, numOtherCost);
	} else {
		rawProfitNoTax = 0; // 异常情况返回0
	}
	// 四舍五入到两位小数，确保精度
	const roundedProfitNoTax = round(rawProfitNoTax, 2);
	// 保存完整精度值用于后续计算
	setCalculatedValue(row, 'profitNoTax', roundedProfitNoTax, 2);
}

/**
 * 更新订单行项目的所有计算值
 * @param {object} row - 订单详情行数据
 * @param {boolean} isSea - 是否包含海运
 * @param {boolean} isLand - 是否包含陆运
 */
export function updateOrderRowCalculations(row, isSea, isLand) {
	// 按依赖顺序计算 - 计算函数内部会使用 Number() 进行转换
	calculateTonnage(row); // 先算吨位和可能的卸货片数填充
	calculatePaymentFactory(row); // 算厂家货款
	calculatePayment(row); // 算总货款
	if (isLand) {
		calculateLandFreight(row); // 算陆运费
	} else {
		row.landFreight = 0; // 如果没有陆运，陆运费为0
	}
	calculateTotalFreight(row, isSea); // 算总运费
	calculateProfit(row); // 算利润
	calculateProfitNoTax(row); // 算不含税利润
}
