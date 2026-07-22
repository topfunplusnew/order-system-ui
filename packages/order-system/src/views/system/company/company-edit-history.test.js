/**
 * 用户需求：客户和供应商信息增加“未修改/有修改”搜索条件，并保留修改记录按钮状态逻辑。
 * 实际改动：同时校验两个页面使用 modified 布尔查询字段、未修改/有修改下拉选项及修改记录按钮禁用条件。
 */
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
		expect(source).toContain(':disabled="scope.row.updateTime == null" @click="handleViewEditHistory(scope.row)">修改记录</el-button>');
		expect(source).not.toContain(':disabled="scope.row.updateTime == null" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>');
		expect(source).toContain('<el-form-item label="修改状态" prop="modified">');
		expect(source).toContain('v-model="queryParams.modified"');
		expect(source).toContain('<el-option label="未修改" :value="false" />');
		expect(source).toContain('<el-option label="有修改" :value="true" />');
		expect(source).toContain('modified: null');
	});
});
