/**
 * 需求：票点管理粘贴公司名称时去除空白，只保留小括号和英文连字符 -，清除其他标点符号。
 * 改动：覆盖小括号、其他括号、连字符、中英文标点、空白、空值及表单粘贴回填的回归测试。
 */
import { describe, expect, test } from '@jest/globals';
import { sanitizeInvoiceCompanyNamePasted } from '@/utils/invoiceCompanyName';
import invoiceCompanyNameMixin from '@/views/system/shared/invoiceCompanyNameMixin';

describe('invoiceCompanyName utils', () => {
	test('removes whitespace while preserving company name parentheses and hyphens', () => {
		expect(sanitizeInvoiceCompanyNamePasted(' 章丘 明龙（分公司）- 有限公司\t\n\u3000\u00a0')).toBe('章丘明龙（分公司）-有限公司');
		expect(sanitizeInvoiceCompanyNamePasted('ABC(测试)-123')).toBe('ABC(测试)-123');
	});

	test('preserves only Chinese and English parentheses', () => {
		expect(sanitizeInvoiceCompanyNamePasted('公司()（）')).toBe('公司()（）');
	});

	test('removes brackets other than parentheses', () => {
		expect(sanitizeInvoiceCompanyNamePasted('公司[]【】{}｛｝<>《》「」『』')).toBe('公司');
	});

	test.each(['，。；：！？、·…—“”‘’', ',.;:!?_\'"/\\@#$%^&*+=|~`', '－–‐！＂＃＄％＆＇＊＋，．／：；＝？＠＼＾＿｀｜～'])('removes punctuation other than brackets and the ASCII hyphen: %s', punctuation => {
		expect(sanitizeInvoiceCompanyNamePasted(`某某${punctuation}公司（分部）-1`)).toBe('某某公司（分部）-1');
	});

	test('preserves letters and numbers in company names', () => {
		expect(sanitizeInvoiceCompanyNamePasted('École 株式会社１２３-ABC')).toBe('École株式会社１２３-ABC');
	});

	test.each([null, undefined, '', ' ,，。 \n'])('returns an empty string for empty or removable input: %s', value => {
		expect(sanitizeInvoiceCompanyNamePasted(value)).toBe('');
	});

	test('writes the cleaned pasted name back to the editable invoice field', () => {
		let prevented = false;
		const context = {
			form: { companyName: '系统客户（总部）,公司', invoiceCompanyName: '' },
			$set(target, key, value) {
				target[key] = value;
			}
		};
		invoiceCompanyNameMixin.methods.handleManualInvoiceCompanyNamePaste.call(
			context,
			{
				preventDefault() {
					prevented = true;
				},
				clipboardData: { getData: () => ' 某某（分公司）-1，有限公司！ ' }
			},
			'invoiceCompanyName'
		);
		expect(prevented).toBe(true);
		expect(context.form.invoiceCompanyName).toBe('某某（分公司）-1有限公司');
		expect(context.form.companyName).toBe('系统客户（总部）,公司');
	});
});
