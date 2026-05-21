import * as XLSX from 'xlsx';
import FileSaver from 'file-saver';

/**
 * 从单元格文本中解析数字（支持 "1,234.56"、"[借] 1,234.56"、"[贷] 1,234.56"、"1,234.56 元" 等格式）
 * [借] 表示正数，[贷] 表示负数
 * @returns {number|null} 解析出的数字，无法解析时返回 null
 */
function parseNumericFromText(text) {
	if (text == null || typeof text !== 'string') return null;
	const str = String(text).trim();
	const creditMatch = str.match(/^\[贷\]\s*(.+)$/);
	let cleaned = str
		.replace(/^\[[^\]]*\]\s*/g, '')
		.replace(/\s*元\s*$/g, '')
		.replace(/,/g, '')
		.trim();
	if (!cleaned) return null;
	const num = Number(cleaned);
	if (!Number.isFinite(num)) return null;
	if (creditMatch) return -Math.abs(num);
	return num;
}

/** 为工作表中可解析为数字的单元格设置 Excel 数字格式，便于计算 */
function applyNumberFormatToSheet(ws) {
	if (!ws || !ws['!ref']) return;
	const range = XLSX.utils.decode_range(ws['!ref']);
	for (let R = range.s.r; R <= range.e.r; R++) {
		for (let C = range.s.c; C <= range.e.c; C++) {
			const addr = XLSX.utils.encode_cell({ r: R, c: C });
			const cell = ws[addr];
			if (!cell || cell.t === 'n') continue;
			const raw = cell.v;
			const parsed = parseNumericFromText(raw != null ? String(raw) : '');
			if (parsed !== null) {
				cell.t = 'n';
				cell.v = parsed;
				cell.z = '#,##0.00';
			}
		}
	}
}

export const common_excel = {
	methods: {
		/**
		 * 导出当前页面表格为 Excel
		 * @param {Array<string>} unnecessaryColumns - 需要排除的列名
		 * @param {string} fileName - 导出文件名
		 * @param {{ skipNumberFormat?: boolean }} [options] - skipNumberFormat 为 true 时保留 [借]/[贷] 文本格式
		 */
		excelExport(unnecessaryColumns = [], fileName = 'table', options = {}) {
			// 延迟执行，确保DOM完全渲染
			this.$nextTick(() => {
				this._performExcelExport(unnecessaryColumns, fileName, options);
			});
		},

		/**
		 * 执行 Excel 导出
		 * @param {Array<string>} unnecessaryColumns - 需要排除的列名
		 * @param {string} fileName - 导出文件名
		 * @param {{ skipNumberFormat?: boolean }} [options] - 导出选项
		 */
		_performExcelExport(unnecessaryColumns = [], fileName = 'table', options = {}) {
			// 尝试多个可能的表格ID
			const possibleTableIds = ['#educe-table', '#printBox'];
			let table = null;
			let foundTableId = '';

			for (const id of possibleTableIds) {
				table = document.querySelector(id);
				if (table) {
					foundTableId = id;
					console.log('找到表格元素:', id);
					break;
				}
			}

			if (!table) {
				console.error('未找到表格元素，尝试了以下ID:', possibleTableIds);
				this.$message.error('未找到表格元素，无法导出');
				return;
			}

			// 检查表格是否有数据行
			const allRows = table.querySelectorAll('tr');
			const dataRows = Array.from(allRows).slice(1); // 排除第一行（表头）
			if (dataRows.length === 0) {
				this.$message.warning('表格暂无数据，无法导出');
				return;
			}
			if (!unnecessaryColumns || unnecessaryColumns.length === 0) {
				unnecessaryColumns = ['操作'];
				console.log('未传入需要排除的列，默认排除操作列');
			}

			// 获取表格的列索引映射，键为表头文本，值为列索引
			const headerCells = table.querySelectorAll('th');
			const columnIndexMap = {};
			headerCells.forEach((cell, index) => {
				columnIndexMap[cell.textContent.trim()] = index;
			});

			// 获取要排除的列索引
			const columnsToExclude = unnecessaryColumns.map(column => columnIndexMap[column]).filter(index => index !== undefined);

			// 创建一个新的表格元素来存储过滤后的数据
			const newTable = document.createElement('table');
			const newHeaderRow = document.createElement('tr');
			const headerRow = table.querySelector('tr');
			headerRow.querySelectorAll('th').forEach((th, index) => {
				if (!columnsToExclude.includes(index)) {
					const newTh = document.createElement('th');
					newTh.textContent = th.textContent;
					newHeaderRow.appendChild(newTh);
				}
			});
			newTable.appendChild(newHeaderRow);

			// 遍历原表格的每一行，过滤掉不需要的列
			dataRows.forEach(row => {
				const newRow = document.createElement('tr');
				const cells = row.querySelectorAll('td');
				cells.forEach((cell, index) => {
					if (!columnsToExclude.includes(index)) {
						const newCell = document.createElement('td');
						newCell.textContent = cell.textContent;
						newRow.appendChild(newCell);
					}
				});
				newTable.appendChild(newRow);
			});
			// 1. 生成Excel工作簿对象，使用过滤后的新表格
			var wb = XLSX.utils.table_to_book(newTable, { raw: true });

			// 2. 设置列宽并应用数字格式
			var ws = wb.Sheets[wb.SheetNames[0]];
			ws['!cols'] = new Array(newTable.rows[0].cells.length).fill({ width: 40 });
			if (!options.skipNumberFormat) {
				applyNumberFormatToSheet(ws);
			}

			// 3. 获取二进制字符串作为输出（cellNF 确保数字格式写入以便 Excel 计算）
			var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array', cellNF: true });

			try {
				FileSaver.saveAs(new Blob([wbout], { type: 'application/octet-stream' }), `${fileName}.xlsx`);
			} catch (e) {
				if (typeof console !== 'undefined') console.log(e, wbout);
			}
			return wbout;
		}
	}
};
