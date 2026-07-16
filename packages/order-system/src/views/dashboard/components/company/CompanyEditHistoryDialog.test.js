/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('CompanyEditHistoryDialog', () => {
	test('renders the five company history columns from the Apifox response', () => {
		const componentPath = path.resolve(__dirname, './CompanyEditHistoryDialog.vue');
		const source = fs.readFileSync(componentPath, 'utf8');

		expect(source).toContain('title="修改记录"');
		expect(source).toContain('prop="extraInfo.changedCompanyName" label="修改后内容"');
		expect(source).toContain('prop="modifyUserName" label="修改人"');
		expect(source).toContain('prop="extraInfo.originalCompanyName" label="修改前内容"');
		expect(source).toContain('prop="modifyTime" label="修改时间"');
		expect(source).toContain('prop="reason" label="修改原因"');
	});
});
