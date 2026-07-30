/* 用户需求：新增 salesReward/cashWithdrawalLedger/index 页面并参考车辆派出管理处理附件和审核。实际改动：先以源码契约测试固定页面路径、十列、日期、账户、权限和冻结逻辑。 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('cash withdrawal ledger page', () => {
	test('implements the approved page contract', () => {
		const source = fs.readFileSync(path.resolve(__dirname, './index.vue'), 'utf8');
		const workbookColumns = ['取现日期', '取现金额', '取现账户名称+账号后5位数', '取现审批单、取现小票', '取现经办人', '取现用途', '其他附件', '审核状态', '审核人', '备注'];

		workbookColumns.forEach(label => expect(source).toContain(`label="${label}"`));
		expect(source).toContain('type="daterange"');
		expect(source).toContain('type="date"');
		expect(source).toContain('value-format="yyyy-MM-dd"');
		expect(source).toContain('v-model.trim="form.accountInfo"');
		expect(source).toContain('flag="withdrawalProof"');
		expect(source).toContain('flag="otherAttachment"');
		expect(source).toContain('system:cashwithdrawalledger:add');
		expect(source).toContain('system:cashwithdrawalledger:audit');
		expect(source).toContain("row.auditState === '已审核'");
		expect(source).toContain('replaceCashWithdrawalLedgerAttachments');
		expect(source).toContain('approved');
		expect(source).toContain('exportCashWithdrawalLedger(exportParams)');
		expect(source).toContain('saveAs(blob');
	});
});
