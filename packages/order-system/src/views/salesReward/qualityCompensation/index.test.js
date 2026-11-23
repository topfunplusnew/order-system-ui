/*
 * 用户需求：完成 DOS-74 质量赔偿统计表，订单指标取自订单，赔偿信息手动录入，剩余利润按公式计算并支持查询、审核、删除、导出；金额不能再出现 NaN，并按对接文档提供附件管理入口。
 * 实际改动：以源码契约测试锁定 14 个业务字段、订单预览、固定奖励类型、金额安全处理、附件管理入口与 POST 表单导出行为。
 */
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

const source = fs.readFileSync(path.resolve(__dirname, 'index.vue'), 'utf8');
const configSource = fs.readFileSync(path.resolve(__dirname, 'qualityCompensation.config.js'), 'utf8');

describe('质量赔偿统计表 DOS-74 字段契约', () => {
	test('展示完整的 14 个业务列并使用质量赔偿字段', () => {
		['订单ID', '订单日期', '客户名称', '订单不含税利润', '厂家返利及降价金额合计', '客户及厂家佣金合计', '综合单车利润', '厂家赔偿我方金额', '厂家赔偿我方日期', '我方赔偿客户金额', '我方赔偿客户日期', '质量赔偿后剩余利润', '质量问题简易描述', '备注'].forEach(label =>
			expect(source).toContain(`label="${label}"`)
		);
		expect(source).toContain('row-key="id"');
		expect(configSource).toContain("export const INCENTIVE_TYPE = '质量赔偿';");
		expect(source).toContain('INCENTIVE_TYPE');
	});

	test('选择订单后加载后端订单指标，剩余利润走 NaN 安全公式', () => {
		expect(source).toContain('getOrderRewardData');
		expect(source).toContain('handleLoadOrderData');
		expect(source).toContain('calcRemainingProfit(this.form)');
		expect(configSource).toContain('safe(form.comprehensiveProfit) + safe(form.manufacturerCompensationAmount) - safe(form.customerCompensationAmount)');
	});

	test('金额展示、输入与合计都不会产生 NaN', () => {
		expect(source).toContain('formatAmountText(value)');
		expect(source).toContain('sanitizeAmountInput(value)');
		expect(source).toContain('normalizeAmountField(this.form[field])');
		expect(source).toContain('sumAmount(data, prop).toFixed(2)');
		expect(source).not.toContain('Number(this.form[field]).toFixed(2)');
		expect(source).not.toContain('data.reduce((total, row) => total + Number(row[prop] || 0), 0)');
	});

	test('查询和导出固定质量赔偿类型，导出不携带分页并使用表单 POST', () => {
		expect(source).toContain('orderDateBegin');
		expect(source).toContain('manufacturerCompensationDateBegin');
		expect(source).toContain('customerCompensationDateBegin');
		expect(source).toContain("this.download('system/salesReward/export'");
		expect(source).toContain('质量赔偿统计表_');
		expect(source).toContain('delete exportParams.pageNum');
		expect(source).toContain('delete exportParams.pageSize');
	});

	test('金额、文本和审核状态符合业务边界', () => {
		expect(source).toContain('不能小于 0');
		expect(source).toContain('最多 500 个字符');
		expect(source).toContain('最多 550 个字符');
		expect(source).toContain(':disabled="scope.row.auditState === \'已审核\'"');
		expect(source).not.toContain('supplementSalesReward');
		expect(source).not.toContain('paymentStatus');
	});
});

describe('质量赔偿统计表附件契约', () => {
	test('操作列提供附件管理入口，只按编辑权限展示且已审核行仍可操作', () => {
		const buttonLine = source.split('\n').find(line => line.includes('附件管理') && line.includes('<el-button')) || '';
		expect(buttonLine).toContain('v-hasPermi="[\'system:salesReward:edit\']"');
		expect(buttonLine).not.toContain(':disabled');
		expect(source).toContain('handleAttachmentManage(scope.row)');
	});

	test('附件保存走 PUT /system/salesReward/attachments 并回填最新附件列表', () => {
		expect(source).toContain('updateSalesRewardAttachments');
		expect(source).toContain('salesRewardId: rowId');
		expect(source).toContain('attachmentIds: normalizeAttachmentIds(this.rowAttachmentDraft)');
		expect(source).toContain('resolveAttachmentList(response, this.rowAttachmentDraft)');
		expect(source).toContain("this.$set(row, 'attachmentList', latest)");
	});

	test('重新查询读 rows[].attachmentList，详情读 data.attachmentList', () => {
		expect(source).toContain('Array.isArray(detail.attachmentList)');
		expect(source).toContain('Array.isArray(row.attachmentList)');
	});

	test('新增与整单编辑可传 params.attachmentIds，编辑未改动时保留已有附件', () => {
		expect(source).toContain('payload.params = { attachmentIds }');
		expect(source).toContain('isSameAttachmentIds(attachmentIds, this.formAttachmentIds)');
		expect(source).toContain('this.formAttachmentIds = normalizeAttachmentIds(attachments);');
	});
});
