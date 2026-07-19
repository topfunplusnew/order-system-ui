import { describe, expect, test } from '@jest/globals';
import { normalizeInvoiceOtherDateRange } from '@/views/system/invoiceOther/invoiceOther.query';

describe('invoiceOther query helpers', () => {
	test('expands same-day date range end to 23:59:59 without mutating source data', () => {
		const source = ['2026-04-20 00:00:00', '2026-04-20 00:00:00'];

		const result = normalizeInvoiceOtherDateRange(source);

		expect(result).toEqual(['2026-04-20 00:00:00', '2026-04-20 23:59:59']);
		expect(source).toEqual(['2026-04-20 00:00:00', '2026-04-20 00:00:00']);
	});

	test('expands cross-day range end to the end of the selected day', () => {
		expect(normalizeInvoiceOtherDateRange(['2026-07-01 00:00:00', '2026-07-30 00:00:00'])).toEqual(['2026-07-01 00:00:00', '2026-07-30 23:59:59']);
	});
});
