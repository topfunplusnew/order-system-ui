<template>
	<div>
		<!-- 导入按钮 -->
		<el-button size="mini" type="success" @click="handleImport"
			>银行卡资金对账</el-button
		>

		<!-- 导入Excel弹窗 -->
		<el-dialog :visible.sync="importDialogVisible" title="导入Excel表格">
			<div class="dialog-content">
				<input type="file" @change="handleFileUpload" />
			</div>
		</el-dialog>

		<!-- 选择Sheet弹窗 -->
		<el-dialog :visible.sync="sheetDialogVisible" title="选择银行卡(sheet表)">
			<div class="dialog-content">
				<p>sheet中为银行卡的明细，请选择银行卡明细进行对账</p>
				<div class="sheet-select-container">
					<el-select
						v-model="selectedSheet"
						placeholder="请选择一个Sheet"
						size="mini"
					>
						<el-option
							v-for="(sheet, index) in sheets"
							:key="index"
							:label="sheet"
							:value="sheet"
						></el-option>
					</el-select>
					<el-button type="primary" size="mini" @click="showSheetData"
						>确认</el-button
					>
				</div>
			</div>
		</el-dialog>

		<!-- 展示Sheet数据弹窗 -->
		<el-dialog :visible.sync="dataDialogVisible" title="Sheet数据" fullscreen>
			<div class="sheet-data-container">
				<div class="left-panel">
					<h3>系统数据</h3>
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
					<h3>Excel数据</h3>
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

export default {
	name: 'BankExcelImport',
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
			systemData: [] // 添加 systemData 属性
		};
	},
	methods: {
		handleImport() {
			this.importDialogVisible = true;
		},
		handleFileUpload(event) {
			const file = event.target.files[0];
			const reader = new FileReader();
			reader.onload = e => {
				this.fileData = new Uint8Array(e.target.result); // 保存文件数据到 fileData
				const workbook = XLSX.read(this.fileData, { type: 'array' });
				this.sheets = workbook.SheetNames;
				this.importDialogVisible = false;
				this.sheetDialogVisible = true;
			};
			reader.readAsArrayBuffer(file);
		},
		async showSheetData() {
			// 获取系统数据
			const query = {};
			if (!/^\d{16,19}$/.test(this.selectedSheet)) {
				this.$message.error('银行卡号格式错误');
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
}
.left-panel,
.right-panel {
	width: 50%;
	padding: 20px;
	overflow-y: auto;
	max-height: 650px; /* 固定高度 */
}
.left-panel {
	background-color: #f5f5f5;
}
.right-panel {
	background-color: #ffffff;
}

.system-data-container {
	max-height: 600px; /* 固定高度 */
	overflow-y: auto; /* 竖向滚动条 */
}

.excel-data-container {
	max-height: 600px; /* 固定高度 */
	overflow-y: auto; /* 竖向滚动条 */
}

table {
	width: 100%;
	border-collapse: collapse;
}

th,
td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

th {
	background-color: #f2f2f2;
	font-weight: bold;
}
</style>
