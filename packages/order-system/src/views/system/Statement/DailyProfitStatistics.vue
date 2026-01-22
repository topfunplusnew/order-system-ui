<script>
import { parseTime } from '@/utils/ruoyi';
import { getDailyProfitStatistics } from '@/api/system/statement';
import { fix } from '@/api/tool/format';

export default {
	name: 'DailyProfitStatistics',
	data() {
		return {
			queryParams: {
				date: ''
			},
			dailyProfitStatistics: {
				systemGlassRevenueDay: 0,
				systemGlassCostDay: 0,
				systemPayableFreightDay: 0,
				systemInvoiceOutDay: 0,
				systemInvoiceInDay: 0,
				systemDailyExpenseDay: 0,
				systemGlassRevenueMonth: 0,
				systemGlassCostMonth: 0,
				systemPayableFreightMonth: 0,
				systemInvoiceOutMonth: 0,
				systemInvoiceInMonth: 0,
				systemDailyExpenseMonth: 0,
				systemGlassRevenueYear: 0, // 年度数据
				systemGlassCostYear: 0,
				systemPayableFreightYear: 0,
				systemInvoiceOutYear: 0,
				systemInvoiceInYear: 0,
				systemDailyExpenseYear: 0,
				systemRebateReceivableDay: 0,
				systemRebateReceivableMonth: 0,
				systemRebateReceivableYear: 0,
				systemPriceReductionReceivableDay: 0,
				systemPriceReductionReceivableMonth: 0,
				systemPriceReductionReceivableYear: 0,
				systemCustomerCommissionPayableDay: 0,
				systemCustomerCommissionPayableMonth: 0,
				systemCustomerCommissionPayableYear: 0,
				systemTicketPointDiffDay: 0,
				systemTicketPointDiffMonth: 0,
				systemTicketPointDiffYear: 0,
				systemRebateLastMonthSettlementDay: 0,
				systemRebateLastMonthSettlementMonth: 0,
				systemRebateLastMonthSettlementYear: 0,
				// 客户平账（日/月/年）
				systemCustomerBalanceDay: 0,
				systemCustomerBalanceMonth: 0,
				systemCustomerBalanceYear: 0,
				// 供应商平账（日/月/年）
				systemSupplierBalanceDay: 0,
				systemSupplierBalanceMonth: 0,
				systemSupplierBalanceYear: 0
			}
		};
	},
	computed: {
		// 当日订单系统利润
		dailyProfit() {
			// 计算当日的订单系统利润：收入减去成本、运费和费用
			return (
				this.dailyProfitStatistics.systemGlassRevenueDay - // 玻璃收入
				this.dailyProfitStatistics.systemGlassCostDay - // 玻璃成本
				this.dailyProfitStatistics.systemPayableFreightDay + // 应付运费
				this.dailyProfitStatistics.systemInvoiceOutDay - // 票点收入
				this.dailyProfitStatistics.systemInvoiceInDay - // 票点成本
				this.dailyProfitStatistics.systemDailyExpenseDay // 管理费用
			);
		},
		// 本月订单系统利润
		monthlyProfit() {
			// 计算本月的订单系统利润：收入减去成本、运费和费用
			return (
				this.dailyProfitStatistics.systemGlassRevenueMonth - // 玻璃收入
				this.dailyProfitStatistics.systemGlassCostMonth - // 玻璃成本
				this.dailyProfitStatistics.systemPayableFreightMonth + // 应付运费
				this.dailyProfitStatistics.systemInvoiceOutMonth - // 票点收入
				this.dailyProfitStatistics.systemInvoiceInMonth - // 票点成本
				this.dailyProfitStatistics.systemDailyExpenseMonth // 管理费用
			);
		},
		// 本年订单系统利润
		yearlyProfit() {
			// 计算本年的订单系统利润：收入减去成本、运费和费用
			return (
				this.dailyProfitStatistics.systemGlassRevenueYear - // 玻璃收入
				this.dailyProfitStatistics.systemGlassCostYear - // 玻璃成本
				this.dailyProfitStatistics.systemPayableFreightYear + // 应付运费
				this.dailyProfitStatistics.systemInvoiceOutYear - // 票点收入
				this.dailyProfitStatistics.systemInvoiceInYear - // 票点成本
				this.dailyProfitStatistics.systemDailyExpenseYear // 管理费用
			);
		}
	},

	methods: {
		calculateUnaccountedAmount(a, b, c, d) {
			return Number(a + b - c + d).toFixed(2);
		},
		calculateUnaccountedAmountNoFix(a, b, c, d) {
			return Number(a + b - c + d);
		},
		calculateProfitToday(a, b, c) {
			return Number(a + b - c).toFixed(2);
		},
		// 计算平账：客户平账 - 供应商平账
		calculateBalance(customerBalance, supplierBalance) {
			return Number(customerBalance - supplierBalance);
		},
		// 计算本日应当利润：利润 + 实收返利 - 平账
		calculateFinalProfit(profit, rebate, balance) {
			return Number(profit + rebate - balance).toFixed(2);
		},
		getList() {
			getDailyProfitStatistics(this.queryParams).then(res => {
				if (!res.rows && !res.data) {
					this.$message.warning('当前搜索条件下，无相关信息');
					return;
				}
				this.dailyProfitStatistics = res.rows || res.data;
			});
		},
		handleQuery() {
			this.getList();
		},
		resetQuery() {
			this.queryParams.date = parseTime(new Date(), '{y}-{m}-{d}');
			this.handleQuery();
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form id="top-search-form-item" :model="queryParams" ref="queryForm" :inline="true" class="search-form" size="mini" label-width="150px">
			<el-form-item label="日期">
				<el-date-picker v-model="queryParams.date" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width: 240px" size="mini" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<table class="optimized-table">
			<thead>
				<tr>
					<th colspan="5">本日应当利润 {{ queryParams.date }}</th>
				</tr>
			</thead>
			<thead>
				<tr>
					<th></th>
					<th>项目</th>
					<th>当日合计</th>
					<th>本月累计</th>
					<th>本年累计</th>
				</tr>
			</thead>
			<tbody>
				<!-- 当日订单系统利润 -->
				<tr class="bg-yellow">
					<td rowspan="7">当日订单系统利润</td>
					<td>加：订单系统玻璃收入</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassRevenueDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassRevenueMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassRevenueYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统玻璃成本</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统应付运费</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>加：订单系统票点收入</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统票点成本</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统管理费用</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>订单系统利润</td>
					<td>￥ {{ dailyProfit.toFixed(2) }}</td>
					<td>￥ {{ monthlyProfit.toFixed(2) }}</td>
					<td>￥ {{ yearlyProfit.toFixed(2) }}</td>
				</tr>

				<!-- 未入账部分 -->
				<tr class="bg-green">
					<td rowspan="5">未入账部分（权责发生）</td>
					<td>①当日应收计提厂家返利金额</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateReceivableDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateReceivableMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateReceivableYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-green">
					<td>②当日应收计提厂家降价金额</td>
					<td>￥ {{ dailyProfitStatistics.systemPriceReductionReceivableDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPriceReductionReceivableMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPriceReductionReceivableYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-green">
					<td>③当日应付客户佣金金额</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerCommissionPayableDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerCommissionPayableMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerCommissionPayableYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-green">
					<td>④当日票点差额(即厂家含税和客户含税差额，已折合票点）</td>
					<td>￥ {{ dailyProfitStatistics.systemTicketPointDiffDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemTicketPointDiffMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemTicketPointDiffYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-green">
					<td>当月未入账金额结余=①+②-③+④</td>
					<td>
						￥
						{{ calculateUnaccountedAmount(dailyProfitStatistics.systemRebateReceivableDay, dailyProfitStatistics.systemPriceReductionReceivableDay, dailyProfitStatistics.systemCustomerCommissionPayableDay, dailyProfitStatistics.systemTicketPointDiffDay) }}
					</td>
					<td>
						￥
						{{ calculateUnaccountedAmount(dailyProfitStatistics.systemRebateReceivableMonth, dailyProfitStatistics.systemPriceReductionReceivableMonth, dailyProfitStatistics.systemCustomerCommissionPayableMonth, dailyProfitStatistics.systemTicketPointDiffMonth) }}
					</td>
					<td>
						￥
						{{ calculateUnaccountedAmount(dailyProfitStatistics.systemRebateReceivableYear, dailyProfitStatistics.systemPriceReductionReceivableYear, dailyProfitStatistics.systemCustomerCommissionPayableYear, dailyProfitStatistics.systemTicketPointDiffYear) }}
					</td>
				</tr>

				<!-- 已入账部分 -->
				<tr>
					<td rowspan="1">已入账部分</td>
					<td>加：实收返利金额（订单系统上面供应商返利台账取数）</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateLastMonthSettlementDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateLastMonthSettlementMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemRebateLastMonthSettlementYear.toFixed(2) }}</td>
				</tr>

				<!-- 平账部分 -->
				<tr class="bg-blue">
					<td rowspan="3">平账</td>
					<td>客户平账</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerBalanceDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerBalanceMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemCustomerBalanceYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-blue">
					<td>供应商平账</td>
					<td>￥ {{ dailyProfitStatistics.systemSupplierBalanceDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemSupplierBalanceMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemSupplierBalanceYear.toFixed(2) }}</td>
				</tr>
				<tr class="bg-blue">
					<td>减：平账金额（客户平账-供应商平账）</td>
					<td>￥ {{ calculateBalance(dailyProfitStatistics.systemCustomerBalanceDay, dailyProfitStatistics.systemSupplierBalanceDay).toFixed(2) }}</td>
					<td>￥ {{ calculateBalance(dailyProfitStatistics.systemCustomerBalanceMonth, dailyProfitStatistics.systemSupplierBalanceMonth).toFixed(2) }}</td>
					<td>￥ {{ calculateBalance(dailyProfitStatistics.systemCustomerBalanceYear, dailyProfitStatistics.systemSupplierBalanceYear).toFixed(2) }}</td>
				</tr>

				<!-- 本日应当利润 -->
				<tr class="bg-orign">
					<td colspan="2">本日应当利润（利润+实收返利-平账）</td>
					<td>
						￥
						{{
							calculateFinalProfit(
								dailyProfit,
								dailyProfitStatistics.systemRebateLastMonthSettlementDay,
								calculateBalance(dailyProfitStatistics.systemCustomerBalanceDay, dailyProfitStatistics.systemSupplierBalanceDay)
							)
						}}
					</td>
					<td>
						￥
						{{
							calculateFinalProfit(
								monthlyProfit,
								dailyProfitStatistics.systemRebateLastMonthSettlementMonth,
								calculateBalance(dailyProfitStatistics.systemCustomerBalanceMonth, dailyProfitStatistics.systemSupplierBalanceMonth)
							)
						}}
					</td>
					<td>
						￥
						{{
							calculateFinalProfit(
								yearlyProfit,
								dailyProfitStatistics.systemRebateLastMonthSettlementYear,
								calculateBalance(dailyProfitStatistics.systemCustomerBalanceYear, dailyProfitStatistics.systemSupplierBalanceYear)
							)
						}}
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<style scoped lang="scss">
.optimized-table {
	width: 90%; // 调整表格宽度
	margin: 0 auto;
	border-collapse: collapse;
	text-align: center;
}

th,
td {
	padding: 12px;
	border: 1px solid #ddd;
}

th {
	background-color: #f5f5f5;
	font-weight: bold;
}

tr:hover {
	background-color: #f9f9f9;
}

.bg-yellow {
	background-color: #ffff00;
}

.bg-green {
	background-color: #92d050;
}

.bg-orign {
	background-color: #ffc000;
}

.bg-blue {
	background-color: #9bc2e6;
}
</style>
