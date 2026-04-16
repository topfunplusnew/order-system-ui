import { format, subtract } from 'mathjs';
import _ from 'lodash';

export function formatOrderAdjustmentAmount(value) {
	return format(Number(value || 0), { notation: 'fixed', precision: 2 });
}

export function resolveOrderAdjustmentPaymentsWithSundry(detail = {}) {
	return Number(detail.paymentsWithSundry || 0);
}

export function calculateOrderAdjustmentFieldDiff(afterVal, beforeVal) {
	return format(subtract(Number(afterVal || 0), Number(beforeVal || 0)), { notation: 'fixed', precision: 2 });
}

export function sumOrderAdjustmentDetailDiff(origList = [], chgList = [], field) {
	const origSum = _.sumBy(origList || [], item => Number(_.get(item, field) || 0));
	const changedSum = _.sumBy(chgList || [], item => Number(_.get(item, field) || 0));
	return calculateOrderAdjustmentFieldDiff(changedSum, origSum);
}

export function sumOrderAdjustmentFreightDiff(origList = [], chgList = []) {
	const sumFreight = list =>
		_.sumBy(list || [], item => {
			if (item.freight != null) return Number(item.freight || 0);
			return Number(item.landFreight || 0) + Number(item.seaFreight || 0);
		});

	return calculateOrderAdjustmentFieldDiff(sumFreight(chgList), sumFreight(origList));
}

export function buildOrderAdjustmentDiffFields(original = {}, changed = {}) {
	const originalDetailList = original.orderDetailList || [];
	const changedDetailList = changed.orderDetailList || [];
	const allPaymentsDiff = sumOrderAdjustmentDetailDiff(originalDetailList, changedDetailList, 'payments');
	const supplierDiff = sumOrderAdjustmentDetailDiff(originalDetailList, changedDetailList, 'paymentFactory');
	const paymentsWithSundryDiff = sumOrderAdjustmentDetailDiff(originalDetailList, changedDetailList, 'paymentsWithSundry');
	const freightDiff = sumOrderAdjustmentFreightDiff(originalDetailList, changedDetailList);

	return {
		allPayments: allPaymentsDiff,
		customerDiff: allPaymentsDiff,
		supplierDiff,
		inventoryDiff: '0.00',
		freightDiff,
		factoryPayment: supplierDiff,
		paymentsWithSundry: paymentsWithSundryDiff,
		totalFreight: freightDiff
	};
}
