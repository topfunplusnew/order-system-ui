<template>
	<div>
		<!-- 导入按钮 -->
		<el-button size="mini" type="success" @click="handleImport">银行卡资金对账</el-button>

		<!-- 导入Excel弹窗 -->
		<el-dialog :visible.sync="importDialogVisible" title="导入Excel表格" @close="handleImportDialogClose">
			<div class="dialog-content">
				<p>请上传银行明细相关excel文件，excel文件中每一个sheet为一个银行卡的明细</p>
				<el-button type="primary" @click="downloadTemplate" size="mini">下载excel模板</el-button>
				<br />
				<input type="file" @change="handleFileUpload" accept=".xlsx, .xls" ref="fileInput" />
				<div v-if="uploadedFiles.length > 0" class="uploaded-files">
					<h4>已上传的文件：</h4>
					<ul>
						<li v-for="(file, index) in uploadedFiles" :key="index" class="uploaded-file-item">
							<div class="sub-file-item">
								<ExcelIcon class="excel-icon" />
								<el-link @click="handleFileClick(file)">{{ file.name }}</el-link>
							</div>
							<el-button type="danger" size="mini" @click="handleFileDelete(file)">删除</el-button>
						</li>
					</ul>
				</div>
			</div>
		</el-dialog>

		<!-- 选择Sheet弹窗 -->
		<el-dialog :visible.sync="sheetDialogVisible" title="选择银行卡(sheet表)">
			<div class="dialog-content">
				<p>sheet中为银行卡的明细，请选择银行卡明细进行对账</p>
				<div class="sheet-select-container">
					<el-select v-model="selectedSheet" placeholder="请选择一个Sheet" size="mini">
						<el-option v-for="(sheet, index) in sheets" :key="index" :label="sheet" :value="sheet"></el-option>
					</el-select>
					<el-button type="primary" size="mini" @click="showSheetData">确认</el-button>
				</div>
			</div>
		</el-dialog>

		<!-- 展示Sheet数据弹窗 -->
		<el-dialog :visible.sync="dataDialogVisible" title="Sheet数据" fullscreen>
			<div class="sheet-data-container">
				<div class="left-panel">
					<h3>
						系统查询卡号为
						<span class="titles">{{ selectedSheet }}</span>
						的银行卡明细数据
					</h3>
					<!-- 展示系统数据 -->
					<div class="system-data-container">
						<table>
							<thead>
								<tr>
									<th>银行卡号</th>
									<th>操作日期</th>
									<th>变动类型</th>
									<th>金额</th>
									<th>公司类型</th>
									<th>银行卡类型</th>
									<th>用户名</th>
								</tr>
							</thead>
							<tbody>
								<tr v-for="(item, index) in systemData" :key="index">
									<td>{{ item.selfBankNo }}</td>
									<td>{{ item.operateDate }}</td>
									<td>{{ item.changeType }}</td>
									<td>{{ item.moneyAmount }}</td>
									<td>{{ item.companyType }}</td>
									<td>{{ item.bankCardType }}</td>
									<td>{{ item.userName }}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="right-panel">
					<h3>导入的银行卡流水明细</h3>
					<div class="excel-data-container">
						<table>
							<thead>
								<tr>
									<th v-for="(header, index) in excelHeaders" :key="index">
										{{ header }}
									</th>
								</tr>
							</thead>
							<tbody>
								<tr v-for="(row, rowIndex) in excelData" :key="rowIndex">
									<td v-for="(cell, cellIndex) in row" :key="cellIndex">
										{{ cell }}
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</el-dialog>
	</div>
</template>

<script>
import * as XLSX from 'xlsx';
import { getBankCardChangeSummary } from '@/api/system/statement';
import ExcelIcon from '@/views/dashboard/components/icons/ExcelIcon.vue';

export default {
	name: 'BankExcelImport',
	components: {
		ExcelIcon
	},
	data() {
		return {
			importDialogVisible: false,
			sheetDialogVisible: false,
			dataDialogVisible: false,
			sheets: [],
			selectedSheet: '',
			excelHeaders: [],
			excelData: [],
			fileData: null, // 添加 fileData 属性
			systemData: [], // 添加 systemData 属性
			uploadedFiles: [] // 添加 uploadedFiles 属性
		};
	},
	methods: {
		// 点击打开准备上传文件的弹窗
		handleImport() {
			this.importDialogVisible = true;
		},
		// 点击上传框 触发的上传
		handleFileUpload(event) {
			const file = event.target.files[0];
			if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
				this.$message.error('只能上传Excel文件');
				return;
			}
			const reader = new FileReader();
			reader.onload = e => {
				this.fileData = new Uint8Array(e.target.result); // 保存文件数据到 fileData
				const workbook = XLSX.read(this.fileData, { type: 'array' });
				this.sheets = workbook.SheetNames;
				this.uploadedFiles.push({
					name: file.name,
					data: this.fileData
				});
				this.importDialogVisible = false;
				// 打开选择sheet表的弹窗
				this.sheetDialogVisible = true;
				// 每次上传后清除上传的文件
				this.$refs.fileInput.value = '';
			};
			reader.readAsArrayBuffer(file);
		},
		// 点击删除文件
		handleFileDelete(file) {
			this.uploadedFiles = this.uploadedFiles.filter(f => f !== file);
			this.$message.success('文件已删除');
		},
		// 点击已上传的文件
		handleFileClick(file) {
			this.fileData = file.data;
			const workbook = XLSX.read(this.fileData, { type: 'array' });
			this.sheets = workbook.SheetNames;
			this.sheetDialogVisible = true;
		},
		// 关闭
		handleImportDialogClose() {
			this.importDialogVisible = false;
		},
		async showSheetData() {
			// 获取系统数据
			const query = {};
			if (!/^\d{16,19}$/.test(this.selectedSheet)) {
				this.$message.error('银行卡号格式错误，请将sheet表名称命名为符合规范的银行卡号！');
				return;
			}
			query.selfBankNo = this.selectedSheet;
			const response = await getBankCardChangeSummary(query);
			this.systemData = response.rows;

			// 获取Excel数据
			const workbook = XLSX.read(this.fileData, { type: 'array' });
			const worksheet = workbook.Sheets[this.selectedSheet];
			const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
			this.excelHeaders = jsonData[0] || []; // 确保 jsonData[0] 存在
			this.excelData = jsonData.slice(1);

			this.sheetDialogVisible = false;
			this.dataDialogVisible = true;
		},
		downloadTemplate() {
			const workbook = XLSX.utils.book_new();
			const sheetName = `(此处应为合规的银行卡号)`;
			const data = [
				['操作日期', '变动类型', '金额', '公司类型', '银行卡类型', '用户名'],
				['2023-01-01', '存款', '1000.00', '公司A', '储蓄卡', '张三'],
				['2023-01-02', '取款', '500.00', '公司B', '信用卡', '李四'],
				['请按照', '规范', '填写', '', '', '']
			];
			const worksheet = XLSX.utils.aoa_to_sheet(data);
			XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);
			XLSX.writeFile(workbook, '银行卡明细模板.xlsx');
		}
	}
};
</script>

<style scoped>
.dialog-content {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 20px;
}

.uploaded-files {
	margin-top: 20px;
	width: 100%;
}

.uploaded-file-item {
	display: flex;
	align-items: center;
	justify-content: space-around;
	margin-top: 10px;
	padding: 10px;
	background-color: #f9f9f9;
	border: 1px solid #e0e0e0;
	border-radius: 5px;
	gap: 26px;

	.sub-file-item {
		display: flex;
		gap: 26px;
	}
}

.uploaded-file-item .excel-icon {
	width: 20px;
	height: 25px;
}

.sheet-select-container {
	display: flex;
	align-items: center;
	margin-top: 10px;
}

.sheet-select-container .el-select {
	margin-right: 10px;
}

.sheet-data-container {
	display: flex;
	height: 100%;
	background-color: #f0f2f5;
	border-radius: 10px;
	padding: 20px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.left-panel,
.right-panel {
	width: 50%;
	padding: 10px; /* 调整内边距 */
	overflow-y: auto;
	max-height: 700px; /* 固定高度 */
	background-color: #ffffff;
	border-radius: 10px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.left-panel {
	margin-right: 10px;
}

.system-data-container {
	max-height: 700px; /* 固定高度 */
	overflow-y: auto; /* 竖向滚动条 */
}

.excel-data-container {
	overflow-y: auto; /* 竖向滚动条 */
}

table {
	width: 100%;
	border-collapse: collapse;
	font-size: 12px; /* 调整字体大小 */
}

th,
td {
	border: 1px solid #ddd;
	padding: 4px; /* 调整内边距 */
	text-align: left;
}

th {
	background-color: #f2f2f2;
	font-weight: bold;
}

.titles {
	color: #409eff;
	font-weight: bold;
	margin: 10px 0;
}
</style>
