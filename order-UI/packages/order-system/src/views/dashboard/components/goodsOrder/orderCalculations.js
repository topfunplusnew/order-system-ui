import { fix, fix_2 } from '../../../../api/tool/format';

/**
 * 计算吨位
 * 规则: (厚度 - 误差) * 长度 * 宽度 * 出厂片数 / 1000000 / 20 / 20
 * @param {object} row - 订单详情行数据
 */
function calculateTonnage(row) {
	row.tonnage = fix(((Number(row.height) - Number(row.erro)) * Number(row.length) * Number(row.width) * Number(row.pieces)) / 1000000 / 20 / 20);
}

/**
 * 计算出厂货款
 * 规则: 长度 * 宽度 * 出厂片数 * 出厂单价 + 杂费
 * @param {object} row - 订单详情行数据
 */
function calculatePaymentFactory(row) {
	row.paymentFactory = fix_2((Number(row.length) * Number(row.width) * Number(row.pieces)) * Number(row.price) + Number(row.sundryCost));
}

/**
 * 计算总货款
 * 规则: 长度 * 宽度 * 卸货片数 * 卸货单价 + 总货款杂费
 * @param {object} row - 订单详情行数据
 */
function calculatePayment(row) {
	row.payments = fix_2((Number(row.length) * Number(row.width) * Number(row.actualPieces)) * Number(row.paymentUnload) + Number(row.paymentsWithSundry));
}

/**
 * 计算陆运费
 * 规则: (吨位 * 陆运费单价) + 加费
 * @param {object} row - 订单详情行数据
 */
function calculateLandFreight(row) {
	row.landFreight = fix_2(Number(row.tonnage) * Number(row.landFreightPrice) + Number(row.additionalFees));
}

/**
 * 计算总运费 (陆运 + 海运)
 * @param {object} row - 订单详情行数据
 * @param {boolean} isSea - 是否包含海运
 */
function calculateTotalFreight(row, isSea) {
	// 总运费 = 陆运费 + 海运费(如果有)
	row.freight = fix_2(Number(row.landFreight) + (isSea ? Number(row.seaFreight) : 0));
}

/**
 * 计算利润
 * 规则: 总货款 - 出厂货款 - 总运费
 * @param {object} row - 订单详情行数据
 */
function calculateProfit(row) {
	console.log(`利润`, row);
	row.profit = fix_2(Number(row.payments) - Number(row.paymentFactory) - Number(row.freight));
}

/**
 * 计算不含税利润 (根据含税状态区分)
 * @param {object} row - 订单详情行数据
 */
function calculateProfitNoTax(row) {
	const { payments, paymentFactory, freight, otherCost, isIncludeTaxFactory, isIncludeTaxSale, height, length, width, pieces } = row;
	const taxRate = 1.075;
	// 总货款
	const numPayments = Number(payments);
	// 出厂货款
	const numPaymentFactory = Number(paymentFactory);
	// 运费
	const numFreight = Number(freight);
	// 其他费用
	const numOtherCost = Number(otherCost);
	const numHeight = Number(height);
	const numLength = Number(length);
	const numWidth = Number(width);
	const numPieces = Number(pieces);

	// 根据厂家和客户是否含税，匹配四种情况
	if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 0) {
		// Case 1 (否, 否): 总货款 - 出厂货款 - 总运费 - 其他费用
		row.profitNoTax = fix_2(numPayments - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 0) {
		// Case 2 (是, 否): 总货款 - (出厂货款 / 1.075) - 总运费 - 其他费用
		row.profitNoTax = fix_2(numPayments - numPaymentFactory / taxRate - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 1) {
		// Case 3 (否, 是): (总货款 / 1.075) - 出厂货款 - 总运费 - 其他费用
		row.profitNoTax = fix_2(numPayments / taxRate - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 1) {
		// Case 4 (是, 是): (总货款 - 出厂货款 - 总运费 * 1.075 - (厚度 * 长度 * 宽度 * 出厂片数 / 1000000 / 20 * 0.5) - 其他费用
		const specialCost = ((numHeight * numLength * numWidth * numPieces) / 1000000 / 20) * 0.5;
		row.profitNoTax = fix_2(numPayments - numPaymentFactory - numFreight * taxRate - specialCost - numOtherCost);
	} else {
		row.profitNoTax = 0; // 异常情况返回0
	}

	console.log(`不含税利润`, row.profitNoTax);
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
