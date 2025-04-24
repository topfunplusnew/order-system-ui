import { fix } from '../../../../api/tool/format';

/**
 * 计算吨位
 * @param {object} row - 订单详情行数据
 */
function calculateTonnage(row) {
	row.tonnage = fix(((Number(row.height) - Number(row.erro)) * row.length * row.width * row.pieces) / 1000000 / 20 / 20);
	// 吨位计算后，自动填充卸货片数（如果尚未手动修改）
	if (!row.actualPieces || row.actualPieces === row.pieces) {
		row.actualPieces = row.pieces;
	}
}

/**
 * 计算出厂货款
 * @param {object} row - 订单详情行数据
 */
function calculatePaymentFactory(row) {
	// 出厂货款=长度*宽度*出厂片数/1000000*出厂单价+杂费 (含税与否公式一致)
	row.paymentFactory = fix(((row.length * row.width * row.pieces) / 1000000) * row.price + Number(row.sundryCost));
}

/**
 * 计算总货款
 * @param {object} row - 订单详情行数据
 */
function calculatePayment(row) {
	// 总货款 = 长度 * 宽度 * 卸货片数 / 1000000 * 卸货单价 + 总货款杂费 (含税与否公式一致)
	row.payments = fix(((row.length * row.width * row.actualPieces) / 1000000) * row.paymentUnload + Number(row.paymentsWithSundry));
}

/**
 * 计算陆运费
 * @param {object} row - 订单详情行数据
 */
function calculateLandFreight(row) {
	// 陆运费 = (吨位 * 陆运费单价) + 加费
	row.landFreight = fix(Number(row.tonnage) * Number(row.landFreightPrice) + Number(row.additionalFees));
}

/**
 * 计算总运费
 * @param {object} row - 订单详情行数据
 * @param {boolean} isSea - 是否包含海运
 */
function calculateTotalFreight(row, isSea) {
	// 总运费 = 陆运费 + 海运费(如果有)
	row.freight = fix(Number(row.landFreight) + (isSea ? Number(row.seaFreight) : 0));
}

/**
 * 计算利润
 * @param {object} row - 订单详情行数据
 */
function calculateProfit(row) {
	// 利润 = 总货款 - 出厂货款 - 总运费
	row.profit = fix(Number(row.payments) - Number(row.paymentFactory) - Number(row.freight));
}

/**
 * 计算不含税利润
 * @param {object} row - 订单详情行数据
 */
function calculateProfitNoTax(row) {
	const { payments, paymentFactory, freight, otherCost, isIncludeTaxFactory, isIncludeTaxSale, height, length, width, pieces } = row;
	const taxRate = 1.075;
	const numPayments = Number(payments);
	const numPaymentFactory = Number(paymentFactory);
	const numFreight = Number(freight);
	const numOtherCost = Number(otherCost);

	// 根据厂家和客户是否含税，匹配四种情况
	if (isIncludeTaxFactory == 0 && isIncludeTaxSale == 0) {
		// 情况A：厂家不含税，客户不含税
		row.profitNoTax = fix(numPayments - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 1 && isIncludeTaxSale == 0) {
		// 情况B：厂家含税，客户不含税
		row.profitNoTax = fix(numPayments - numPaymentFactory / taxRate - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 0 && isIncludeTaxSale == 1) {
		// 情况C：厂家不含税，客户含税
		row.profitNoTax = fix(numPayments / taxRate - numPaymentFactory - numFreight - numOtherCost);
	} else if (isIncludeTaxFactory == 1 && isIncludeTaxSale == 1) {
		// 情况D：厂家含税，客户含税
		const specialCost = ((height * length * width * pieces) / 1000000 / 20) * 0.5;
		// 注意：公式 D 中 总货款 和 出厂货款 都需要除以税率
		row.profitNoTax = fix(numPayments / taxRate - numPaymentFactory / taxRate - numFreight - specialCost - numOtherCost);
	} else {
		row.profitNoTax = 0; // 异常情况返回0
	}
}

/**
 * 更新订单行项目的所有计算值
 * @param {object} row - 订单详情行数据
 * @param {boolean} isSea - 是否包含海运
 * @param {boolean} isLand - 是否包含陆运
 */
export function updateOrderRowCalculations(row, isSea, isLand) {
	// 确保基础数据是数字类型，避免NaN错误
	row.height = Number(row.height) || 0;
	row.length = Number(row.length) || 0;
	row.width = Number(row.width) || 0;
	row.pieces = Number(row.pieces) || 0;
	row.erro = Number(row.erro) || 0;
	row.price = Number(row.price) || 0;
	row.sundryCost = Number(row.sundryCost) || 0;
	row.actualPieces = Number(row.actualPieces) || row.pieces || 0; // 如果卸货片数为空，默认为出厂片数
	row.paymentUnload = Number(row.paymentUnload) || 0;
	row.paymentsWithSundry = Number(row.paymentsWithSundry) || 0;
	row.landFreightPrice = Number(row.landFreightPrice) || 0;
	row.additionalFees = Number(row.additionalFees) || 0;
	row.seaFreight = Number(row.seaFreight) || 0;
	row.otherCost = Number(row.otherCost) || 0;
	row.isIncludeTaxFactory = Number(row.isIncludeTaxFactory); // 确保是数字0或1
	row.isIncludeTaxSale = Number(row.isIncludeTaxSale); // 确保是数字0或1

	// 按依赖顺序计算
	calculateTonnage(row);
	calculatePaymentFactory(row);
	calculatePayment(row);
	if (isLand) {
		calculateLandFreight(row);
	} else {
		row.landFreight = 0; // 如果没有陆运，陆运费为0
	}
	calculateTotalFreight(row, isSea);
	calculateProfit(row);
	calculateProfitNoTax(row);
}
