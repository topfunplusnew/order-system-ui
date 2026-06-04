import { describe, expect, test } from '@jest/globals';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

describe('fund change date scope field config', () => {
	test('uses fundsDate for payment template', () => {
		expect(getFundChangeTemplateDateFields('PaymentTemplate')).toEqual(['fundsDate']);
	});

	test('returns an empty field list for unknown templates', () => {
		expect(getFundChangeTemplateDateFields('UnknownTemplate')).toEqual([]);
	});
});
