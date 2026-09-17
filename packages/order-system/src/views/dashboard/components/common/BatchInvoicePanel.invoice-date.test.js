/*
 * 用户需求：批量开票大弹窗的公司列表增加时间列（invoiceDate），数据按 invoiceDate 再拆分，并增加时间搜索。
 * 实际改动：拆分与筛选逻辑接入 companyInvoiceDate 工具，公司表格新增“时间”列，时间搜索覆盖查询与重置。
 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';

const readSource = name => fs.readFileSync(path.resolve(__dirname, name), 'utf8');

describe('BatchInvoicePanel 公司列表按开票时间拆分与搜索', () => {
	const source = readSource('./BatchInvoicePanel.vue');

	test('聚合唯一键包含开票日期，同一公司按 invoiceDate 拆分为多行', () => {
		expect(source).toMatch(/import \{[^}]*buildCompanyRowKey[^}]*\} from '\.\/utils\/companyInvoiceDate';/);
		expect(source).toMatch(/import \{[^}]*isInvoiceDateInRange[^}]*\} from '\.\/utils\/companyInvoiceDate';/);
		expect(source).toContain('const invoiceDate = normalizeInvoiceDate(element.invoiceDate);');
		expect(source).toContain('const _onlyKey = buildCompanyRowKey(id, us, invoiceDate);');
		// 拆分行需要携带开票时间与行唯一键
		expect(source).toContain('invoiceDate,');
		expect(source).toContain('rowKey: _onlyKey,');
	});

	test('搜索条件新增 invoiceDate 时间范围', () => {
		expect(source).toContain('invoiceDateRange: []');
		expect(source).toContain('v-model="invoiceDateRange"');
		expect(source).toContain('type="daterange"');
		expect(source).toContain('label="时间"');
		expect(source).toContain('if (!isInvoiceDateInRange(item.invoiceDate, this.invoiceDateRange)) {');
	});

	test('重置与关闭弹窗都会清空时间条件', () => {
		const matches = source.match(/this\.invoiceDateRange = \[\];/g) || [];
		// handleReset（查询区重置）与 clearComponentState（关闭弹窗）各一处，确保不残留筛选
		expect(matches.length).toBe(2);
	});
});

describe('InvoiceCompanysList 公司列表时间列', () => {
	const source = readSource('./InvoiceCompanysList.vue');

	test('公司表格新增时间列展示 invoiceDate', () => {
		const columnStart = source.indexOf('<el-table-column prop="invoiceDate" label="时间"');
		expect(columnStart).toBeGreaterThan(-1);
		const columnSource = source.slice(columnStart, source.indexOf('</el-table-column>', columnStart));

		expect(columnSource).toContain('scope.row.invoiceDate');
	});

	test('行高亮使用拆分行唯一键，避免同公司不同开票日期互相影响', () => {
		expect(source).toContain('this.selectedRowId = row.rowKey || row.id;');
		expect(source).toContain('return this.selectedRowId === (row.rowKey || row.id)');
	});
});
