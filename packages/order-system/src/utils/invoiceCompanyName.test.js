/**
 * 2026-06-25 票点管理：仅手动填写的票据单位名称粘贴清洗单元测试
 */
import { describe, expect, test } from '@jest/globals';
import { sanitizeInvoiceCompanyNamePasted } from '@/utils/invoiceCompanyName';

describe('invoiceCompanyName utils', () => {
	test('sanitizeInvoiceCompanyNamePasted removes spaces and brackets', () => {
		expect(sanitizeInvoiceCompanyNamePasted(' 章丘明龙（分公司） ')).toBe('章丘明龙分公司');
		expect(sanitizeInvoiceCompanyNamePasted('ABC(测试)[公司]')).toBe('ABC测试公司');
	});

	test('sanitizeInvoiceCompanyNamePasted keeps other punctuation', () => {
		expect(sanitizeInvoiceCompanyNamePasted('某某公司,有限公司')).toBe('某某公司,有限公司');
	});
});
