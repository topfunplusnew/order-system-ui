import { describe, expect, test } from '@jest/globals';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

describe('fund change date scope field config', () => {
	test('uses fundsDate for payment template', () => {
		expect(getFundChangeTemplateDateFields('PaymentTemplate')).toEqual(['fundsDate']);
	});

	test('uses transactionTime for offset payment template', () => {
		expect(getFundChangeTemplateDateFields('OffsetPaymentTemplate')).toEqual(['transactionTime']);
	});

	test('uses depositDate for receive deposit template', () => {
		expect(getFundChangeTemplateDateFields('ReceiveDepositTemplate')).toEqual(['depositDate']);
	});

	test('returns an empty field list for unknown templates', () => {
		expect(getFundChangeTemplateDateFields('UnknownTemplate')).toEqual([]);
	});
});
