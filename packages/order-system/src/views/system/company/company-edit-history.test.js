/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

const readView = relativePath => fs.readFileSync(path.resolve(__dirname, relativePath), 'utf8');

describe('customer and supplier company edit history integration', () => {
	test.each([
		['客户', './index.vue'],
		['供应商', '../companygive/index.vue']
	])('%s page exposes history and reason-gated editing', (label, relativePath) => {
		const source = readView(relativePath);

		expect(source).toContain('@click="handleViewEditHistory(scope.row)">修改记录</el-button>');
		expect(source).toContain('<CompanyEditHistoryDialog :visible.sync="historyDialogVisible" :company-id="historyCompanyId" :company-type="companyType" />');
		expect(source).toContain('if (companyData.shouldTrackEditReason === true)');
		expect(source).toContain('editReason: value.trim()');
		expect(source).toContain('delete data.shouldTrackEditReason;');
	});
});
