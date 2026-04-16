import { describe, expect, test } from '@jest/globals';
import { buildOrderAdjustmentDiffFields, resolveOrderAdjustmentPaymentsWithSundry } from '@/utils/fundChange/orderAdjustment';

describe('orderAdjustment fund change helpers', () => {
	test('keeps paymentsWithSundry bound to its own field', () => {
		expect(
			resolveOrderAdjustmentPaymentsWithSundry({
				paymentFactory: 120.5,
				sundryCost: 8.8,
				paymentsWithSundry: null
			})
		).toBe(0);
		expect(
			resolveOrderAdjustmentPaymentsWithSundry({
				paymentFactory: 120.5,
				sundryCost: 8.8,
				paymentsWithSundry: 6.6
			})
		).toBe(6.6);
	});

	test('fills factoryPayment and paymentsWithSundry on diff rows', () => {
		const original = {
			orderDetailList: [
				{ paymentFactory: 100, payments: 200, paymentsWithSundry: 5, landFreight: 10 },
				{ paymentFactory: 50, payments: 80, paymentsWithSundry: 3, seaFreight: 2 }
			]
		};
		const changed = {
			orderDetailList: [
				{ paymentFactory: 120, payments: 250, paymentsWithSundry: 8, landFreight: 12 },
				{ paymentFactory: 40, payments: 70, paymentsWithSundry: 4, seaFreight: 1 }
			]
		};

		expect(buildOrderAdjustmentDiffFields(original, changed)).toEqual({
			allPayments: '40.00',
			customerDiff: '40.00',
			supplierDiff: '10.00',
			inventoryDiff: '0.00',
			freightDiff: '1.00',
			factoryPayment: '10.00',
			paymentsWithSundry: '4.00',
			totalFreight: '1.00'
		});
	});
});
