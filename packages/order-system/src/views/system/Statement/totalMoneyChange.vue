<template>
	<div class="total-money-change">
		<!-- 搜索框 -->
		<el-form id="top-search-form-item" :inline="true" :model="searchForm" class="search-form" label-width="150px">
			<el-form-item label="日期">
				<el-date-picker v-model="searchForm.endTime" value-format="yyyy-MM-dd" type="date" placeholder="选择日期"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" @click="handleSearch" size="mini">搜索</el-button>
			</el-form-item>
		</el-form>

		<!-- 表格 -->
		<el-table :data="tableData" border class="money-table" :row-style="tableRowClassName">
			<el-table-column prop="label" label="项目" show-overflow-tooltip></el-table-column>
			<el-table-column prop="value" label="金额" :formatter="formatValue" show-overflow-tooltip></el-table-column>
		</el-table>
	</div>
</template>

<script>
import { getMoneySummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from 'order-system/src/api/tool/format';
import { create, all } from 'mathjs';

const math = create(all, { number: 'BigNumber', precision: 64 });

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
				createRow('资金总额=⓪+①+②-③-④+⑤+⑥+⑦-⑧-⑨', this.calculateTotalBalance(data)),
				createRow('⓪库存金额', data.remainingInventoryAmount),
				createRow('①客户欠款合计数', data.companyTotalBalance),
				createRow('②所有银行卡资金合计', data.selfCompanyTotalFunds),
				createRow('③欠厂家货款', data.supplierTotalBalance),
				createRow('④未支付运费合计', data.driverUnpaidAmount),
				createRow('⑤其他应收-个人从公司借款', data.loanFromCompany),
				createRow('⑥期货保证金', data.futuresMarginBalance),
				createRow('⑦支付保证金', data.paymentMarginBalance),
				createRow('⑧收取保证金', data.receiveMarginBalance),
				createRow('⑨公司从外面借款合计', data.loanBalance),
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
				loanFromCompany: data.loanFromCompany || 0,
				futuresMarginBalance: data.futuresMarginBalance || 0,
				paymentMarginBalance: data.paymentMarginBalance || 0,
				receiveMarginBalance: data.receiveMarginBalance || 0,
				loanBalance: data.loanBalance || 0,
				remainingInventoryAmount: data.remainingInventoryAmount || 0
			};

			// 按照公式计算资金总额：①+②-③-④+⑤+⑥+⑦-⑧-⑨+⓪
			const result = math.evaluate(
				'companyTotalBalance + selfCompanyTotalFunds - supplierTotalBalance - driverUnpaidAmount + loanFromCompany + futuresMarginBalance + paymentMarginBalance - receiveMarginBalance - loanBalance + remainingInventoryAmount',
				safeData
			);

			return math.format(result, { notation: 'fixed', precision: 2 });
		},
		formatValue(row, column, cellValue) {
			const num = Number(cellValue ?? 0);
			return Number.isFinite(num) ? num.toFixed(2) : '0.00';
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
