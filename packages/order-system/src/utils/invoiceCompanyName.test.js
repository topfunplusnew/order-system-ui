/**
 * 2026-06-25 票点管理：票据单位名称粘贴清洗与保存校验单元测试
 */
import { describe, expect, test } from '@jest/globals';
import { sanitizeInvoiceCompanyNamePasted, validateInvoiceCompanyNameForSave } from '@/utils/invoiceCompanyName';

describe('invoiceCompanyName utils', () => {
	test('sanitizeInvoiceCompanyNamePasted removes spaces and brackets', () => {
		expect(sanitizeInvoiceCompanyNamePasted(' 章丘明龙（分公司） ')).toBe('章丘明龙分公司');
		expect(sanitizeInvoiceCompanyNamePasted('ABC(测试)[公司]')).toBe('ABC测试公司');
	});

	test('validateInvoiceCompanyNameForSave rejects punctuation other than removed brackets', () => {
		expect(validateInvoiceCompanyNameForSave('章丘明龙,有限公司').valid).toBe(false);
		expect(validateInvoiceCompanyNameForSave('章丘明龙有限公司').valid).toBe(true);
		expect(validateInvoiceCompanyNameForSave('ABC Company 123').valid).toBe(true);
	});
});
