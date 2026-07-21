/* 用户需求：FundChangeTemplates 目录内所有模板增加表格数据导出功能。实际改动：测试共享导出数据、文件名规则以及全部十四个模板统一接入导出按钮。 */
/* global describe, test, expect */
import fs from 'fs';
import path from 'path';
import { buildFundChangeExportFileName, buildFundChangeExportSheets } from '../../../../../ui-components/components/FundChangeTemplates/export/fundChangeExport';

const templateRoot = path.resolve(__dirname, '../../../../../ui-components/components/FundChangeTemplates');

describe('fund change template export', () => {
	test('builds detail and summary sheets from displayed template data', () => {
		const sheets = buildFundChangeExportSheets({
			moduleLabel: '付款',
			columns: [
				{ label: '日期', prop: 'paymentDate' },
				{ label: '金额', prop: 'amount' }
			],
			rows: [{ recordIndex: 1, backupTime: '2026-07-21', subLabel: '修改前', paymentDate: '2026-07-20', amount: 100 }],
			summaryRows: [{ label: '付款资金差额', value: -20 }],
			summaryOnly: false
		});

		expect(sheets).toEqual([
			{
				name: '变更明细',
				data: [
					['模块', '备份日期', '变更', '日期', '金额'],
					['付款（1）', '2026-07-21', '修改前', '2026-07-20', 100]
				]
			},
			{
				name: '差额汇总',
				data: [
					['项目', '金额'],
					['付款资金差额', -20]
				]
			}
		]);
	});

	test('supports summary-only mode and empty data', () => {
		expect(buildFundChangeExportSheets({ moduleLabel: '收款', rows: [{ subLabel: '差额' }], summaryRows: [{ label: '汇总', value: 5 }], summaryOnly: true })).toEqual([
			{
				name: '差额汇总',
				data: [
					['项目', '金额'],
					['汇总', 5]
				]
			}
		]);
		expect(buildFundChangeExportSheets({ columns: [], rows: [], summaryRows: [] })).toEqual([]);
	});

	test('builds a filesystem-safe timestamped filename', () => {
		expect(buildFundChangeExportFileName('订单/调整单', new Date('2026-07-21T12:34:56'))).toBe('订单_调整单_资金变动详情_20260721_123456.xlsx');
	});

	test('all fourteen templates use the shared export button', () => {
		const templateDirs = fs
			.readdirSync(templateRoot, { withFileTypes: true })
			.filter(entry => entry.isDirectory() && entry.name !== 'export')
			.map(entry => entry.name)
			.sort();

		expect(templateDirs).toHaveLength(14);
		templateDirs.forEach(templateDir => {
			const source = fs.readFileSync(path.join(templateRoot, templateDir, 'index.vue'), 'utf8');
			expect(source).toContain('FundChangeExportButton');
			expect(source).toContain(':columns="columns"');
			expect(source).toContain(':rows="tableData"');
			expect(source).toContain(':summary-rows="diffSummaryTableData"');
		});
	});
});
