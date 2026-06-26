import { describe, expect, test } from '@jest/globals';
import { sanitizeCompanyNamePasted, validateCompanyNameForSave } from '@/utils/companyName';

describe('companyName utils', () => {
	test('sanitizeCompanyNamePasted removes spaces and brackets', () => {
		expect(sanitizeCompanyNamePasted(' 章丘明龙（分公司） ')).toBe('章丘明龙分公司');
		expect(sanitizeCompanyNamePasted('ABC(测试)[公司]')).toBe('ABC测试公司');
	});

	test('validateCompanyNameForSave rejects punctuation other than removed brackets', () => {
		expect(validateCompanyNameForSave('章丘明龙,有限公司').valid).toBe(false);
		expect(validateCompanyNameForSave('章丘明龙有限公司').valid).toBe(true);
		expect(validateCompanyNameForSave('ABC Company 123').valid).toBe(true);
	});
});
