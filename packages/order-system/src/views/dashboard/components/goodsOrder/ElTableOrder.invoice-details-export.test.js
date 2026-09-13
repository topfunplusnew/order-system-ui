/*
 * 用户需求：订单界面除了“导出订单目录”“导出全部订单”外，额外增加“导出开票明细”。
 * 实际改动：新增导出按钮与 handleExportInvoiceDetails 方法，调用 /system/goodsOrder/exportInvoiceDetails，入参与订单列表查询保持一致。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('ElTableOrder invoice details export', () => {
	const componentPath = path.resolve(__dirname, './ElTableOrder.vue');
	const source = fs.readFileSync(componentPath, 'utf8');

	test('导出工具栏在目录、明细之外提供开票明细导出按钮', () => {
		const exportSlotStart = source.indexOf('<template #export>');
		const exportSlotEnd = source.indexOf('</template>', exportSlotStart);
		const exportSlotSource = source.slice(exportSlotStart, exportSlotEnd);

		expect(exportSlotStart).toBeGreaterThan(-1);
		expect(exportSlotSource).toContain('导出订单目录');
		expect(exportSlotSource).toContain('导出全部订单');
		expect(exportSlotSource).toContain('导出开票明细');
		expect(exportSlotSource).toContain('@click="handleExportInvoiceDetails"');
	});

	test('开票明细导出调用 exportInvoiceDetails 接口', () => {
		const methodMatch = source.match(/handleExportInvoiceDetails\(\) \{([\s\S]*?)\n\t\t\},/);

		expect(methodMatch).not.toBeNull();
		expect(methodMatch[1]).toContain("'system/goodsOrder/exportInvoiceDetails'");
	});

	test('开票明细导出入参与订单列表查询保持一致', () => {
		const methodMatch = source.match(/handleExportInvoiceDetails\(\) \{([\s\S]*?)\n\t\t\},/);
		const methodSource = methodMatch[1];

		// 复用列表的 queryParams，并按调整单/订单模式补全 isAdjust
		expect(methodSource).toContain('...this.queryParams');
		expect(methodSource).toContain('isAdjust: this.isAdjustOrder ? -1 : 0');
		// 已删除数据页面沿用同一套查询参数构造
		expect(methodSource).toContain('buildDeletedQueryParams(params)');
		expect(methodSource).toContain('this.isDeletedMode ?');
	});
});
