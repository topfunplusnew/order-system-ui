import * as XLSX from 'xlsx';
import FileSaver from 'file-saver';

export const common_excel = {
	methods: {
		excelExport(unnecessaryColumns = [], fileName = 'table') {
			// 延迟执行，确保DOM完全渲染
			this.$nextTick(() => {
				this._performExcelExport(unnecessaryColumns, fileName);
			});
		},

		_performExcelExport(unnecessaryColumns = [], fileName = 'table') {
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
			const dataRows = table.querySelectorAll('tr:not(:first-child)');
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
						const cellText = cell.textContent.trim();

						// 检查是否为数字并保持数字格式
						if (this.isNumeric(cellText)) {
							// 对于数字，设置data-t属性为'n'（数字类型）
							newCell.setAttribute('data-t', 'n');
							newCell.setAttribute('data-v', this.parseNumeric(cellText));
							newCell.textContent = cellText;
						} else {
							newCell.textContent = cellText;
						}
						newRow.appendChild(newCell);
					}
				});
				newTable.appendChild(newRow);
			});

			// 1. 生成Excel工作簿对象，使用过滤后的新表格，保持原始数据类型
			var wb = XLSX.utils.table_to_book(newTable, {
				raw: false,
				cellDates: true,
				dateNF: 'yyyy-mm-dd'
			});

			// 2. 设置列宽和数字格式
			// 获取工作表
			var ws = wb.Sheets[wb.SheetNames[0]];
			// 设置列宽（单位：字符宽度）
			ws['!cols'] = new Array(newTable.rows[0].cells.length).fill({ width: 40 });

			// 处理数字格式
			this.formatWorksheetNumbers(ws);

			// 3. 获取二进制字符串作为输出
			var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });

			try {
				FileSaver.saveAs(new Blob([wbout], { type: 'application/octet-stream' }), `${fileName}.xlsx`);
			} catch (e) {
				if (typeof console !== 'undefined') console.log(e, wbout);
			}
			return wbout;
		},

		// 检查字符串是否为数字（包括负数、小数、千分位分隔符、货币符号、借贷标记等）
		isNumeric(str) {
			if (!str || typeof str !== 'string') return false;

			// 移除常见的非数字字符：千分位分隔符(逗号)、空格、货币符号、借贷标记等
			const cleanStr = str
				.replace(/^\[借\]\s*/, '') // 移除借标记
				.replace(/^\[贷\]\s*/, '') // 移除贷标记
				.replace(/[,\s¥$€£]/g, '') // 移除逗号、空格、常见货币符号
				.replace(/^\((.+)\)$/, '-$1'); // 将括号表示的负数转换为负号格式 (123) -> -123

			// 检查是否为数字（包括负数和小数）
			const numPattern = /^-?\d+(\.\d+)?$/;
			return numPattern.test(cleanStr) && !isNaN(parseFloat(cleanStr)) && isFinite(parseFloat(cleanStr));
		},

		// 解析数字字符串为数值
		parseNumeric(str) {
			if (!str || typeof str !== 'string') return 0;

			let cleanStr = str;
			let isNegative = false;

			// 处理借贷标记
			if (cleanStr.startsWith('[借]')) {
				cleanStr = cleanStr.replace(/^\[借\]\s*/, '');
				// 借方为正数
			} else if (cleanStr.startsWith('[贷]')) {
				cleanStr = cleanStr.replace(/^\[贷\]\s*/, '');
				// 贷方为负数
				isNegative = true;
			}

			// 移除其他非数字字符
			cleanStr = cleanStr
				.replace(/[,\s¥$€£]/g, '')
				.replace(/^\((.+)\)$/, '-$1'); // 处理括号表示的负数

			const parsed = parseFloat(cleanStr);
			if (isNaN(parsed) || !isFinite(parsed)) return 0;

			// 根据借贷标记决定正负
			return isNegative ? -Math.abs(parsed) : parsed;
		},

		// 为工作表中的数字单元格设置数字格式
		formatWorksheetNumbers(worksheet) {
			const range = XLSX.utils.decode_range(worksheet['!ref']);

			for (let row = range.s.r; row <= range.e.r; row++) {
				for (let col = range.s.c; col <= range.e.c; col++) {
					const cellAddress = XLSX.utils.encode_cell({ r: row, c: col });
					const cell = worksheet[cellAddress];

					if (cell && cell.v !== undefined) {
						const cellValue = cell.v;

						// 如果是字符串，检查是否为数字格式
						if (typeof cellValue === 'string' && this.isNumeric(cellValue)) {
							const numValue = this.parseNumeric(cellValue);
							cell.v = numValue;
							cell.t = 'n'; // 设置单元格类型为数字

							// 根据数字特征设置格式
							if (numValue % 1 === 0) {
								// 整数格式
								cell.z = '#,##0';
							} else {
								// 小数格式
								cell.z = '#,##0.00';
							}
						}
						// 如果已经是数字类型，确保设置了格式
						else if (typeof cellValue === 'number') {
							cell.t = 'n';
							if (cellValue % 1 === 0) {
								cell.z = '#,##0';
							} else {
								cell.z = '#,##0.00';
							}
						}
					}
				}
			}
		}
	}
};
