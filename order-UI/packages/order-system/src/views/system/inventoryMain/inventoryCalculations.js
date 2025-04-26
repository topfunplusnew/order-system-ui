import { fix } from '../../../api/tool/format';

/**
 * 计算吨位
 * 规则: (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 * @param {object} row - 库存详情行数据
 */
function calculateTonnage(row) {
	row.tonnage = fix(((Number(row.height) - Number(row.erro)) * row.length * row.width * row.pieces) / 1000000 / 20 / 20);
}

/**
 * 计算出厂货款
 * 规则: 基于是否含税的不同计算方式
 * @param {object} row - 库存详情行数据
 */
function calculatePaymentFactory(row) {
	if (row.isIncludeTaxFactory === 0) {
		row.paymentFactory = fix(((row.length * row.width * row.pieces) / 1000000) * row.price + Number(row.sundryCost));
	} else {
		row.paymentFactory = fix((row.length * row.width * row.pieces * row.price) / 1000000 + Number(row.sundryCost));
	}
}

/**
 * 计算库存金额
 * 规则: 基于是否含税的不同计算方式
 * @param {object} row - 库存详情行数据
 */
function calculatePayment(row) {
	if (row.isIncludeTaxFactory === 0 && row.isIncludeTaxSale === 0) {
		row.payments = fix(((Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000) * Number(row.paymentUnload) + Number(row.paymentsWithSundry));
	} else {
		row.payments = fix((Number(row.length) * Number(row.width) * Number(row.pieces) * Number(row.paymentUnload)) / 1000000 + Number(row.paymentsWithSundry));
	}
}

/**
 * 计算陆运费
 * 规则: (吨位 * 陆运费单价) + 加费
 * @param {object} row - 库存详情行数据
 */
function calculateLandFreight(row) {
	row.landFreight = fix(Number(row.tonnage) * Number(row.landFreightPrice) + Number(row.additionalFees));
}

/**
 * 计算总运费 (陆运 + 海运)
 * @param {object} row - 库存详情行数据
 * @param {boolean} isSea - 是否包含海运
 */
function calculateTotalFreight(row, isSea) {
	// 总运费 = 陆运费 + 海运费(如果有)
	row.freight = fix(Number(row.landFreight) + (isSea ? Number(row.seaFreight) : 0));
}

/**
 * 计算利润
 * 规则: 总库存金额 - 出厂货款 - 总运费
 * @param {object} row - 库存详情行数据
 */
function calculateProfit(row) {
	row.profit = fix(Number(row.payments) - Number(row.paymentFactory) - Number(row.freight));
}

/**
 * 计算不含税利润 (根据含税状态区分)
 * @param {object} row - 库存详情行数据
 */
function calculateProfitNoTax(row) {
	const { payments, paymentFactory, freight, otherCost, isIncludeTaxFactory, isIncludeTaxSale, height, length, width, pieces } = row;
	const numPayments = Number(payments);
	const numPaymentFactory = Number(paymentFactory);
	const numFreight = Number(freight);
	const numOtherCost = Number(otherCost || 0);
	const taxRate = 1.075;

	// 根据厂家和客户是否含税，匹配四种情况
	if (isIncludeTaxFactory == 0 && isIncludeTaxSale == 0) {
		// Case 1 (否, 否): 总货款 - 出厂货款 - 总运费 - 其他费用
		row.profitNoTax = fix(numPayments - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 1 && isIncludeTaxSale == 0) {
		// Case 2 (是, 否): 总货款 - (出厂货款 / 1.075) - 总运费 - 其他费用
		row.profitNoTax = fix(numPayments - numPaymentFactory / taxRate - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 0 && isIncludeTaxSale == 1) {
		// Case 3 (否, 是): (总货款 / 1.075) - 出厂货款 - 总运费 - 其他费用
		row.profitNoTax = fix(numPayments / taxRate - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 1 && isIncludeTaxSale == 1) {
		// Case 4 (是, 是): 特殊计算方式
		const specialCost = ((Number(height) * Number(length) * Number(width) * Number(pieces)) / 1000000 / 20) * 0.5;
		row.profitNoTax = fix(numPayments / taxRate - numPaymentFactory / taxRate - numFreight - specialCost - numOtherCost);
	} else {
		row.profitNoTax = 0; // 异常情况返回0
	}
}

/**
 * 更新库存行项目的所有计算值
 * @param {object} row - 库存详情行数据
 * @param {boolean} isSea - 是否包含海运
 * @param {boolean} isLand - 是否包含陆运
 */
export function updateInventoryRowCalculations(row, isSea, isLand) {
	// 确保所有值都是数字类型
	const numericFields = [
		'height',
		'length',
		'width',
		'pieces',
		'erro',
		'price',
		'sundryCost',
		'paymentUnload',
		'paymentsWithSundry',
		'landFreightPrice',
		'additionalFees',
		'seaFreight',
		'otherCost'
	];

	// 按依赖顺序计算
	calculateTonnage(row); // 先计算吨位
	calculatePaymentFactory(row); // 计算出厂货款
	calculatePayment(row); // 计算库存金额

	if (isLand) {
		calculateLandFreight(row); // 计算陆运费
	} else {
		row.landFreight = 0; // 如果没有陆运，陆运费为0
	}

	calculateTotalFreight(row, isSea); // 计算总运费
	calculateProfit(row); // 计算利润
	calculateProfitNoTax(row); // 计算不含税利润
}
