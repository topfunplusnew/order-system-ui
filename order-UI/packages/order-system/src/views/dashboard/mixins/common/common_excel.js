import * as XLSX from 'xlsx';
import FileSaver from 'file-saver';

export const common_excel = {
	methods: {
		excelExport() {
			// 1. 生成Excel工作簿对象
			var wb = XLSX.utils.table_to_book(document.querySelector('#educe-table'), { raw: true });

			// 2. 设置列宽
			// 获取工作表
			var ws = wb.Sheets[wb.SheetNames[0]];
			// 设置列宽（单位：字符宽度）
			ws['!cols'] = [
				{ width: 40 }, // 第一列宽度
				{ width: 40 }, // 第二列宽度
				{ width: 40 } // 第三列宽度
				// 根据需要继续添加
			];

			// 3. 获取二进制字符串作为输出
			var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });

			try {
				FileSaver.saveAs(new Blob([wbout], { type: 'application/octet-stream' }), 'table.xlsx');
			} catch (e) {
				if (typeof console !== 'undefined') console.log(e, wbout);
			}

			return wbout;
		}
	}
};
