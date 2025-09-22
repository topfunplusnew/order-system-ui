<template>
	<div class="total-money-change">
		<!-- 搜索框 -->
		<el-form :inline="true" :model="searchForm" class="search-form">
			<el-form-item label="日期">
				<el-date-picker v-model="searchForm.endTime" value-format="yyyy-MM-dd" type="date" placeholder="选择日期"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" @click="handleSearch" size="mini">搜索</el-button>
			</el-form-item>
		</el-form>

		<!-- 表格 -->
		<el-table :data="tableData" border class="money-table" :row-style="tableRowClassName">
			<el-table-column prop="label" label="项目"></el-table-column>
			<el-table-column prop="value" label="金额" :formatter="formatValue"></el-table-column>
		</el-table>
	</div>
</template>

<script>
import { getMoneySummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from 'order-system/src/api/tool/format';

export default {
	name: 'TotalMoneyChange',
	data() {
		return {
			searchForm: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			tableData: []
		};
	},
	created() {
		this.handleSearch();
	},
	methods: {
		fix,
		async handleSearch() {
			const response = await getMoneySummary(this.searchForm);
			const data = response.data;
			this.tableData = this.formatShowTableData(data);
		},
		formatShowTableData(data) {
			const createRow = (label, value) => ({
				label,
				value
			});
			return [
				createRow('资金总额=①+②-③-④+⑤+⑥-⑦', this.calculateTotalBalance(data)),
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
			const safeData = {
				companyTotalBalance: data.companyTotalBalance || 0,
				selfCompanyTotalFunds: data.selfCompanyTotalFunds || 0,
				supplierTotalBalance: data.supplierTotalBalance || 0,
				driverUnpaidAmount: data.driverUnpaidAmount || 0,
				futuresMarginBalance: data.futuresMarginBalance || 0,
				loanFromCompany: data.loanFromCompany || 0,
				loanBalance: data.loanBalance || 0
			};

			// 按照公式计算资金总额：① + ② - ③ - ④ + ⑤ + ⑥ - ⑦
			const result =
				safeData.companyTotalBalance + // ①客户欠款合计数
				safeData.selfCompanyTotalFunds - // ②所有银行卡资金合计
				safeData.supplierTotalBalance - // ③欠厂家货款
				safeData.driverUnpaidAmount + // ④未支付运费合计
				safeData.futuresMarginBalance + // ⑤期货保证金
				safeData.loanFromCompany - // ⑥其他应收-个人从公司借款
				safeData.loanBalance; // ⑦公司从外面借款合计

			return result.toFixed(2); // 保留两位小数
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
