/*
 * 用户需求：完成 DOS-74 质量赔偿统计表，订单指标取自订单，赔偿信息手动录入，剩余利润按公式计算并支持查询、审核、删除、导出。
 * 实际改动：以源码契约测试锁定 14 个业务字段、订单预览、固定奖励类型、空值处理和 POST 表单导出行为。
 */
import fs from 'fs';
import path from 'path';
import { describe, expect, test } from '@jest/globals';

const source = fs.readFileSync(path.resolve(__dirname, 'index.vue'), 'utf8');

describe('质量赔偿统计表 DOS-74 字段契约', () => {
	test('展示完整的 14 个业务列并使用质量赔偿字段', () => {
		['订单ID', '订单日期', '客户名称', '订单不含税利润', '厂家返利及降价金额合计', '客户及厂家佣金合计', '综合单车利润', '厂家赔偿我方金额', '厂家赔偿我方日期', '我方赔偿客户金额', '我方赔偿客户日期', '质量赔偿后剩余利润', '质量问题简易描述', '备注'].forEach(label =>
			expect(source).toContain(`label="${label}"`)
		);
		expect(source).toContain('row-key="id"');
		expect(source).toContain("const INCENTIVE_TYPE = '质量赔偿';");
	});

	test('选择订单后加载后端订单指标，赔偿公式允许空值且独立计算', () => {
		expect(source).toContain('getOrderRewardData');
		expect(source).toContain('handleLoadOrderData');
		expect(source).toContain('Number(this.form.comprehensiveProfit || 0) + Number(this.form.manufacturerCompensationAmount || 0) - Number(this.form.customerCompensationAmount || 0)');
		expect(source).toContain('Number(this.form.manufacturerCompensationAmount || 0)');
		expect(source).toContain('Number(this.form.customerCompensationAmount || 0)');
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
