<script>
import { getMoneyChangeSummary } from '@/api/system/statement';

export default {
	name: 'MoneyChangeTotalAmount',
	data() {
		return {
			changeForm: {
				startTime: '',
				endTime: ''
			},
			changeTableData: [],
			spanArr: [] // 存储合并信息的数组
		};
	},
	created() {},
	methods: {
		async handleChangeSearch() {
			const response = await getMoneyChangeSummary(this.changeForm);
			const data = response.data;
			this.changeTableData = this.formatTableData(data);
		},
		formatValue(row, column, cellValue) {
			return Number(cellValue).toFixed(2);
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
		formatTableData(list, type) {
			const { startTimeMoney, endTimeMoney } = list;

			// 计算数据差异的函数
			const calculateDifference = field => startTimeMoney[field] - endTimeMoney[field];

			// 计算各个字段的差异
			const data = {
				companyTotalBalance: calculateDifference('companyTotalBalance'),
				supplierTotalBalance: calculateDifference('supplierTotalBalance'),
				companyTotalInvoiceAmount: calculateDifference('companyTotalInvoiceAmount'),
				supplierTotalInvoiceAmount: calculateDifference('supplierTotalInvoiceAmount'),
				driverUnpaidAmount: calculateDifference('driverUnpaidAmount'),
				selfCompanyTotalFunds: calculateDifference('selfCompanyTotalFunds'),
				loanBalance: calculateDifference('loanBalance'),
				futuresMarginBalance: calculateDifference('futuresMarginBalance'),
				loanFromCompany: calculateDifference('loanFromCompany')
			};

			// 创建表格数据的函数
			const createRow = (label, value, anotherLabel, anotherValue) => ({
				label,
				value,
				anotherLabel,
				anotherValue
			});

			// 返回格式化后的数据
			return [
				createRow('资金总额（即股东权益）=①+②+③+④+⑤+⑥+⑦', this.calculateTotalBalance(data), this.calculateTotalBalance(startTimeMoney), this.calculateTotalBalance(endTimeMoney)),
				createRow('①客户欠款合计数', data.companyTotalBalance, startTimeMoney.companyTotalBalance, endTimeMoney.companyTotalBalance),
				createRow('②所有银行卡资金合计', data.selfCompanyTotalFunds, startTimeMoney.selfCompanyTotalFunds, endTimeMoney.selfCompanyTotalFunds),
				createRow('③欠厂家货款', data.supplierTotalBalance, startTimeMoney.supplierTotalBalance, endTimeMoney.supplierTotalBalance),
				createRow('④未支付运费合计', data.driverUnpaidAmount, startTimeMoney.driverUnpaidAmount, endTimeMoney.driverUnpaidAmount),
				createRow('⑤期货保证金', data.futuresMarginBalance, startTimeMoney.futuresMarginBalance, endTimeMoney.futuresMarginBalance),
				createRow('⑥其他应收-个人从公司借款', data.loanFromCompany, startTimeMoney.loanFromCompany, endTimeMoney.loanFromCompany),
				createRow('⑦公司从外面借款合计', data.loanBalance, startTimeMoney.loanBalance, endTimeMoney.loanBalance),
				createRow('客户票点合计', data.companyTotalInvoiceAmount, startTimeMoney.companyTotalInvoiceAmount, endTimeMoney.companyTotalInvoiceAmount),
				createRow('供应商票点合计', data.supplierTotalInvoiceAmount, startTimeMoney.supplierTotalInvoiceAmount, endTimeMoney.supplierTotalInvoiceAmount)
			];
		}
	}
};
</script>

<template>
	<div>
		<div class="container">
			<el-form :inline="true" :model="changeForm" class="search-form">
				<el-form-item label="基准日期">
					<el-date-picker v-model="changeForm.startTime" type="date" value-format="yyyy-MM-dd" placeholder="选择基准日期"></el-date-picker>
				</el-form-item>
				<el-form-item label="比较日期">
					<el-date-picker v-model="changeForm.endTime" type="date" value-format="yyyy-MM-dd" placeholder="选择结束日期"></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleChangeSearch">搜索</el-button>
				</el-form-item>
			</el-form>

			<!-- 表格 -->
			<el-row :gutter="10">
				<el-table :data="changeTableData" border class="money-table" :row-style="tableRowClassName" :span-method="objectSpanMethod">
					<el-table-column prop="label" label="项目"></el-table-column>
					<el-table-column prop="value" label="基准日期金额" :formatter="formatValue"></el-table-column>
					<el-table-column prop="des" label="对比日资金流变动">
						<template slot-scope="scope">
							<div>{{ scope.row.value - scope.row.anotherLabel }}</div>
						</template>
					</el-table-column>
					<el-table-column prop="anotherLabel" label="对比日期总额" :formatter="formatValue"></el-table-column>
					<el-table-column prop="anotherValue" label="对比日期总额变动情况(对比日期-基准日期)" :formatter="formatValue"></el-table-column>
				</el-table>
			</el-row>
		</div>
	</div>
</template>

<style scoped lang="scss">
.container {
	margin: 30px;
}
</style>
