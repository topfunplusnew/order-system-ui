/**
 * 用户需求：客户和供应商信息列表的“修改记录”按钮，需要根据修改时间是否为 null 控制禁用状态，编辑按钮不受影响。
 * 实际改动：同时校验客户、供应商页面仅在修改记录按钮上绑定 updateTime 为 null 的 disabled 条件。
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
	});
});
