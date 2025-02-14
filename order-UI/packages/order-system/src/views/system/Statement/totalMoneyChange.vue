<template>
	<div class="total-money-change">
		<!-- 搜索框 -->
		<el-form :inline="true" :model="searchForm" class="search-form">
			<el-form-item label="日期">
				<el-date-picker
					v-model="searchForm.endTime"
					type="date"
					placeholder="选择日期"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" @click="handleSearch">搜索</el-button>
			</el-form-item>
			<el-form-item>
				<el-button type="success" @click="openChangeDialog"
					>查看资金变动
				</el-button>
			</el-form-item>
		</el-form>

		<!-- 表格 -->
		<el-table
			:data="tableData"
			border
			class="money-table"
			:row-style="tableRowClassName"
		>
			<el-table-column prop="label" label="项目"></el-table-column>
			<el-table-column
				prop="value"
				label="金额"
				:formatter="formatValue"
			></el-table-column>
		</el-table>

		<!-- 资金变动弹窗 -->
		<el-dialog
			:visible.sync="changeDialogVisible"
			title="查看资金变动"
			width="800px"
		>
			<el-form :inline="true" :model="changeForm" class="search-form">
				<el-form-item label="基准日期">
					<el-date-picker
						v-model="changeForm.startTime"
						type="date"
						value-format="yyyy-MM-dd"
						placeholder="选择基准日期"
					></el-date-picker>
				</el-form-item>
				<el-form-item label="比较日期">
					<el-date-picker
						v-model="changeForm.endTime"
						type="date"
						value-format="yyyy-MM-dd"
						placeholder="选择结束日期"
					></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleChangeSearch"
						>搜索
					</el-button>
				</el-form-item>
			</el-form>

			<!-- 表格 -->
			<el-row :gutter="10">
				<!--				<el-col :span="12">-->
				<el-table
					:data="changeTableData"
					border
					class="money-table"
					:row-style="tableRowClassName"
				>
					<el-table-column
						prop="label"
						label="项目"
					></el-table-column>
					<el-table-column
						prop="value"
						label="金额(资金变化)"
						:formatter="formatValue"
					></el-table-column>
				</el-table>
				<!--				</el-col>-->
				<!--				<el-col :span="12">-->
				<!--					<el-table-->
				<!--						:data="anotherTableData"-->
				<!--						border-->
				<!--						class="money-table"-->
				<!--						:row-style="tableRowClassName"-->
				<!--					>-->
				<!--						<el-table-column-->
				<!--							prop="label"-->
				<!--							label="项目"-->
				<!--						></el-table-column>-->
				<!--						<el-table-column-->
				<!--							prop="value"-->
				<!--							label="金额"-->
				<!--							:formatter="formatValue"-->
				<!--						></el-table-column>-->
				<!--					</el-table>-->
				<!--				</el-col>-->
			</el-row>
		</el-dialog>
	</div>
</template>

<script>
import { getMoneySummary, getMoneyChangeSummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';

export default {
	name: 'TotalMoneyChange',
	data() {
		return {
			searchForm: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			changeForm: {
				startTime: '',
				endTime: ''
			},
			tableData: [],
			changeTableData: [],
			anotherTableData: [],
			changeDialogVisible: false
		};
	},
	created() {
		this.handleSearch();
	},
	methods: {
		async handleSearch() {
			const response = await getMoneySummary(this.searchForm);
			const data = response.data;
			this.tableData = this.formatTableData(data);
		},
		async handleChangeSearch() {
			const response = await getMoneyChangeSummary(this.changeForm);
			const data = response.data;
			this.changeTableData = this.formatTableData(data);
		},
		formatTableData(list, type) {
			const { startTimeMoney, endTimeMoney } = list;

			// 计算数据差异的函数
			const calculateDifference = field =>
				startTimeMoney[field] - endTimeMoney[field];

			// 计算各个字段的差异
			const data = {
				companyTotalBalance: calculateDifference('companyTotalBalance'),
				supplierTotalBalance: calculateDifference(
					'supplierTotalBalance'
				),
				companyTotalInvoiceAmount: calculateDifference(
					'companyTotalInvoiceAmount'
				),
				supplierTotalInvoiceAmount: calculateDifference(
					'supplierTotalInvoiceAmount'
				),
				driverUnpaidAmount: calculateDifference('driverUnpaidAmount'),
				selfCompanyTotalFunds: calculateDifference(
					'selfCompanyTotalFunds'
				),
				loanBalance: calculateDifference('loanBalance'),
				futuresMarginBalance: calculateDifference(
					'futuresMarginBalance'
				),
				loanFromCompany: calculateDifference('loanFromCompany')
			};

			// 创建表格数据的函数
			const createRow = (label, value) => ({ label, value });

			// 返回格式化后的数据
			return [
				createRow(
					'资金总余额=①+②+③+④+⑤+⑥+⑦',
					this.calculateTotalBalance(data)
				),
				createRow('①客户欠款合计数', data.companyTotalBalance),
				createRow('②所有银行卡资金合计', data.selfCompanyTotalFunds),
				createRow('③欠厂家货款', data.supplierTotalBalance),
				createRow('④未支付运费合计', data.driverUnpaidAmount),
				createRow('⑤期货保证金', data.futuresMarginBalance),
				createRow('⑥其他应收-个人从公司借款', data.loanFromCompany),
				createRow('⑦公司从外面借款合计', data.loanBalance),
				createRow('客户票点合计', data.companyTotalInvoiceAmount),
				createRow('供应商票点合计', data.supplierTotalInvoiceAmount)
			];
		},
		calculateTotalBalance(data) {
			return (
				data.companyTotalBalance +
				data.selfCompanyTotalFunds +
				data.supplierTotalBalance +
				data.driverUnpaidAmount +
				data.futuresMarginBalance +
				data.loanFromCompany +
				data.loanBalance
			).toFixed(2);
		},
		formatValue(row, column, cellValue) {
			return Number(cellValue).toFixed(2);
		},
		tableRowClassName({ rowIndex }) {
			if (rowIndex === 0) {
				return {
					color: 'red !important',
					fontWeight: 'bold !important',
					fontSize: '22px !important'
				};
			}
			return {};
		},
		openChangeDialog() {
			this.changeDialogVisible = true;
		}
	}
};
</script>

<style scoped>
.total-money-change {
	padding: 20px;
}

.search-form {
	margin-bottom: 20px;
}

.money-table {
	width: 100%;
}
</style>
