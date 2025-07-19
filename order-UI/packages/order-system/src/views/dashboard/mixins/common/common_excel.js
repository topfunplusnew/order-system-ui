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
						newCell.textContent = cell.textContent;
						newRow.appendChild(newCell);
					}
				});
				newTable.appendChild(newRow);
			});
			// 1. 生成Excel工作簿对象，使用过滤后的新表格
			var wb = XLSX.utils.table_to_book(newTable, { raw: true });

			// 2. 设置列宽
			// 获取工作表
			var ws = wb.Sheets[wb.SheetNames[0]];
			// 设置列宽（单位：字符宽度）
			ws['!cols'] = new Array(newTable.rows[0].cells.length).fill({ width: 40 });

			// 3. 获取二进制字符串作为输出
			var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });

			try {
				FileSaver.saveAs(new Blob([wbout], { type: 'application/octet-stream' }), `${fileName}.xlsx`);
			} catch (e) {
				if (typeof console !== 'undefined') console.log(e, wbout);
			}
			return wbout;
		}
	}
};
