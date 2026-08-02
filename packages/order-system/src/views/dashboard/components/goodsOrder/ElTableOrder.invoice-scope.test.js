/*
 * 用户需求：修复点击“已开票”后开票记录表格因 scope 未定义而无法显示数据的问题。
 * 实际改动：回归检查客户和供应商名称列必须显式声明 Element UI 表格默认插槽的 scope 参数。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

describe('ElTableOrder invoice table scoped slots', () => {
	const componentPath = path.resolve(__dirname, './ElTableOrder.vue');
	const source = fs.readFileSync(componentPath, 'utf8');

	test.each(['客户名称', '供应商名称'])('%s列声明 scope 后再读取行数据', label => {
		const columnStart = source.indexOf(`label="${label}"`);
		const columnEnd = source.indexOf('</el-table-column>', columnStart);
		const columnSource = source.slice(columnStart, columnEnd);

		expect(columnStart).toBeGreaterThan(-1);
		expect(columnSource).toContain('<template #default="scope">');
		expect(columnSource).toContain('scope.row.companyName');
	});
});
