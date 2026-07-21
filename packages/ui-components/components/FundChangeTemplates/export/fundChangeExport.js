/* 用户需求：FundChangeTemplates 内所有模板支持导出表格数据。实际改动：统一构建变更明细、差额汇总工作表，生成安全文件名并通过 XLSX 写出工作簿。 */
import * as XLSX from 'xlsx';

const padNumber = value => String(value).padStart(2, '0');
const hasRows = rows => Array.isArray(rows) && rows.length > 0;

function normalizeCellValue(value) {
	return value === undefined || value === null ? '' : value;
}

function buildModuleCell(moduleLabel, row) {
	const index = row.recordIndex != null ? row.recordIndex : row.groupIndex != null ? row.groupIndex + 1 : '';
	return index === '' ? moduleLabel || '资金变动' : `${moduleLabel || '资金变动'}（${index}）`;
}

function buildDetailSheet({ columns = [], rows = [], moduleLabel = '' }) {
	const exportColumns = columns.filter(column => column && column.prop);
	return {
		name: '变更明细',
		data: [
			['模块', '备份日期', '变更', ...exportColumns.map(column => column.label || column.prop)],
			...rows.map(row => [buildModuleCell(moduleLabel, row), normalizeCellValue(row.backupTime), normalizeCellValue(row.subLabel), ...exportColumns.map(column => normalizeCellValue(row[column.prop]))])
		]
	};
}

function buildSummarySheet(summaryRows = []) {
	return {
		name: '差额汇总',
		data: [['项目', '金额'], ...summaryRows.map(row => [normalizeCellValue(row.label), normalizeCellValue(row.value)])]
	};
}

export function buildFundChangeExportSheets({ columns = [], rows = [], summaryRows = [], moduleLabel = '', summaryOnly = false } = {}) {
	const sheets = [];
	if (!summaryOnly && hasRows(rows)) sheets.push(buildDetailSheet({ columns, rows, moduleLabel }));
	if (hasRows(summaryRows)) sheets.push(buildSummarySheet(summaryRows));
	return sheets;
}

export function buildFundChangeExportFileName(moduleLabel, now = new Date()) {
	const safeLabel = String(moduleLabel || '资金变动').replace(/[\\/:*?"<>|\[\]]/g, '_');
	const timestamp = `${now.getFullYear()}${padNumber(now.getMonth() + 1)}${padNumber(now.getDate())}_${padNumber(now.getHours())}${padNumber(now.getMinutes())}${padNumber(now.getSeconds())}`;
	return `${safeLabel}_资金变动详情_${timestamp}.xlsx`;
}

function calculateColumnWidths(data) {
	const columnCount = data.reduce((max, row) => Math.max(max, row.length), 0);
	return Array.from({ length: columnCount }, (_, columnIndex) => ({
		wch: Math.min(
			30,
			Math.max(
				10,
				...data.map(row => String(normalizeCellValue(row[columnIndex])).length + 2)
			)
		)
	}));
}

export function writeFundChangeWorkbook(sheets, fileName) {
	const workbook = XLSX.utils.book_new();
	sheets.forEach(sheet => {
		const worksheet = XLSX.utils.aoa_to_sheet(sheet.data);
		worksheet['!cols'] = calculateColumnWidths(sheet.data);
		XLSX.utils.book_append_sheet(workbook, worksheet, sheet.name);
	});
	XLSX.writeFile(workbook, fileName);
}
