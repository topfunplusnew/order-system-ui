import { fix } from '../../../api/tool/format';
import { formatCalculationResult } from '../../../utils/precision';

/**
 * 安全减法，确保结果不为负
 * @param {number} base - 被减数
 * @param {number} subtractor - 减数
 * @returns {number} - 差值
 */
function safeSubtract(base, subtractor) {
	const result = Number(base) - Number(subtractor);
	return result < 0 ? 0 : result;
}

/**
 * 计算吨位
 */
function calculateTonnage(row) {
	const height = Number(row.height);
	const erro = Number(row.erro);
	const length = Number(row.length);
	const width = Number(row.width);
	const pieces = Number(row.pieces);

	// If (height - erro) is negative, tonnage will be 0
	const effectiveHeight = safeSubtract(height, erro);
	row.tonnage = fix((effectiveHeight * length * width * pieces) / 1000000 / 20 / 20);
}

/**
 * 计算出厂货款
 */
function calculatePaymentFactory(row) {
	const length = Number(row.length);
	const width = Number(row.width);
	const pieces = Number(row.pieces);
	const price = Number(row.price);
	const sundryCost = Number(row.sundryCost);

	if (row.isIncludeTaxFactory === 0) {
		row.paymentFactory = fix(((length * width * pieces) / 1000000) * price + sundryCost);
	} else {
		row.paymentFactory = fix((length * width * pieces * price) / 1000000 + sundryCost);
	}
}

/**
 * 计算库存金额
 */
function calculatePayment(row) {
	const length = Number(row.length);
	const width = Number(row.width);
	const pieces = Number(row.pieces);
	const paymentUnload = Number(row.paymentUnload);
	const paymentsWithSundry = Number(row.paymentsWithSundry);

	if (row.isIncludeTaxFactory === 0 && row.isIncludeTaxSale === 0) {
		row.payments = fix(((length * width * pieces) / 1000000) * paymentUnload + paymentsWithSundry);
	} else {
		row.payments = fix((length * width * pieces * paymentUnload) / 1000000 + paymentsWithSundry);
	}
}

/**
 * 计算陆运费
 */
function calculateLandFreight(row) {
	const tonnage = Number(row.tonnage);
	const landFreightPrice = Number(row.landFreightPrice);
	const additionalFees = Number(row.additionalFees);

	row.landFreight = fix(tonnage * landFreightPrice + additionalFees);
}

/**
 * 计算总运费 (陆运 + 海运)
 */
function calculateTotalFreight(row, isSea) {
	const landFreight = Number(row.landFreight);
	const seaFreight = Number(row.seaFreight);
	const additionalFees = Number(row.additionalFees);

	row.freight = fix(landFreight + (isSea ? seaFreight : 0) + additionalFees);
}

/**
 * 计算利润
 */
function calculateProfit(row) {
	const payments = Number(row.payments);
	const paymentFactory = Number(row.paymentFactory);
	const freight = Number(row.freight);

	// If (payments - paymentFactory - freight) is negative, profit will be 0
	row.profit = fix(safeSubtract(payments, paymentFactory + freight));
}

/**
 * 计算不含税利润 (根据含税状态区分)
 */
function calculateProfitNoTax(row) {
	const { isIncludeTaxFactory, isIncludeTaxSale } = row;
	const numPayments = Number(row.payments);
	const numPaymentFactory = Number(row.paymentFactory);
	const numFreight = Number(row.freight);
	const numOtherCost = Number(row.otherCost || 0);
	const taxRate = 1.075;

	let calculatedProfitNoTax = 0;

	if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 0) {
		calculatedProfitNoTax = safeSubtract(numPayments, numPaymentFactory + numFreight + numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 0) {
		calculatedProfitNoTax = safeSubtract(numPayments, numPaymentFactory / taxRate + numFreight + numOtherCost);
	} else if (isIncludeTaxFactory === 0 && isIncludeTaxSale === 1) {
		calculatedProfitNoTax = safeSubtract(numPayments / taxRate, numPaymentFactory + numFreight + numOtherCost);
	} else if (isIncludeTaxFactory === 1 && isIncludeTaxSale === 1) {
		const height = Number(row.height);
		const length = Number(row.length);
		const width = Number(row.width);
		const pieces = Number(row.pieces);
		const specialCost = ((height * length * width * pieces) / 1000000 / 20) * 0.5;
		calculatedProfitNoTax = safeSubtract(numPayments / taxRate, numPaymentFactory / taxRate + numFreight + specialCost + numOtherCost);
	} else {
		calculatedProfitNoTax = 0;
	}
	row.profitNoTax = fix(calculatedProfitNoTax);
}

/**
 * 更新库存行项目的所有计算值
 */
export function updateInventoryRowCalculations(row, isSea, isLand) {
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
	// 计算利润
	calculateProfit(row);
	// 计算不含税利润
	calculateProfitNoTax(row);

	// 计算出厂货款 (保持4位小数精度计算，但结果格式化为2位)
	if (row.pieces && row.price) {
		const factoryPayment = Number(row.pieces) * Number(row.price) + Number(row.sundryCost || 0);
		row.paymentFactory = formatCalculationResult(factoryPayment);
	}

	// 计算库存金额 (2位小数)
	if (row.stockNumber && row.paymentUnload) {
		const payments = Number(row.stockNumber) * Number(row.paymentUnload);
		row.payments = formatCalculationResult(payments);
	}

	// 计算吨位 (2位小数)
	if (row.height && row.length && row.width && row.stockNumber && row.erro) {
		const tonnage = (Number(row.height) * Number(row.length) * Number(row.width) * Number(row.stockNumber) * Number(row.erro)) / 1000000;
		row.tonnage = formatCalculationResult(tonnage);
	}

	// 计算陆运费 (2位小数)
	if (isLand && row.landFreightPrice && row.tonnage) {
		const landFreight = Number(row.landFreightPrice) * Number(row.tonnage) + Number(row.additionalFees || 0);
		row.landFreight = formatCalculationResult(landFreight);
	}

	// 计算总运费 (2位小数)
	const totalFreight = Number(row.landFreight || 0) + Number(row.seaFreight || 0);
	row.freight = formatCalculationResult(totalFreight);

	// 计算利润 (2位小数)
	if (row.payments && row.paymentFactory) {
		const profit = Number(row.payments) - Number(row.paymentFactory) - Number(row.freight || 0) - Number(row.otherCost || 0);
		row.profit = formatCalculationResult(profit);
	}

	// 计算不含税利润 (2位小数)
	if (row.profit) {
		let profitNoTax = Number(row.profit);
		// 如果销售含税，则除以1.13
		if (row.isIncludeTaxSale === 1) {
			profitNoTax = profitNoTax / 1.13;
		}
		// 如果出厂不含税，则需要调整
		if (row.isIncludeTaxFactory === 0) {
			// 调整计算逻辑
		}
		row.profitNoTax = formatCalculationResult(profitNoTax);
	}
}
