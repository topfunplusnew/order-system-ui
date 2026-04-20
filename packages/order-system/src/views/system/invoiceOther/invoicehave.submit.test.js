import { describe, expect, test } from '@jest/globals';
import { normalizeCustomerPointAmountForSubmit } from '@/views/system/invoiceOther/invoicehave.submit';

describe('invoicehave submit helpers', () => {
	test('normalizes empty customerPointAmount values to numeric zero', () => {
		expect(normalizeCustomerPointAmountForSubmit(null)).toBe(0);
		expect(normalizeCustomerPointAmountForSubmit(undefined)).toBe(0);
		expect(normalizeCustomerPointAmountForSubmit('')).toBe(0);
	});

	test('keeps non-empty customerPointAmount values unchanged', () => {
		expect(normalizeCustomerPointAmountForSubmit(12.34)).toBe(12.34);
		expect(normalizeCustomerPointAmountForSubmit('0.0000')).toBe('0.0000');
	});
});
