<script>
import { parseTime } from '@/utils/ruoyi';
import { getDailyProfitStatistics } from '@/api/system/statement';

export default {
	name: 'DailyProfitStatistics',
	data() {
		return {
			queryParams: {
				date: parseTime(new Date(), '{y}-{m}-{d}')
			},
			loading: false,
			dailyProfitStatistics: {
				// 当日新增入库
				systemNewInventoryDay: 0,
				systemNewInventoryMonth: 0,
				systemNewInventoryYear: 0,
				// 订单系统玻璃收入
				systemGlassRevenueDay: 0,
				systemGlassRevenueMonth: 0,
				systemGlassRevenueYear: 0,
				// 订单系统玻璃成本
				systemGlassCostDay: 0,
				systemGlassCostMonth: 0,
				systemGlassCostYear: 0,
				// 订单系统应付运费
				systemPayableFreightDay: 0,
				systemPayableFreightMonth: 0,
				systemPayableFreightYear: 0,
				// 订单系统票点收入（销项发票）
				systemInvoiceOutDay: 0,
				systemInvoiceOutMonth: 0,
				systemInvoiceOutYear: 0,
				// 订单系统票点成本（进项发票）
				systemInvoiceInDay: 0,
				systemInvoiceInMonth: 0,
				systemInvoiceInYear: 0,
				// 订单系统管理费用（日常费用）
				systemDailyExpenseDay: 0,
				systemDailyExpenseMonth: 0,
				systemDailyExpenseYear: 0,
				// 订单系统利润
				systemProfitDay: 0,
				systemProfitMonth: 0,
				systemProfitYear: 0,
				// 实收返利金额
				systemActualReceivedRebateDay: 0,
				systemActualReceivedRebateMonth: 0,
				systemActualReceivedRebateYear: 0,
				// 平账（客户-供应商）
				systemBalanceAccountsDay: 0,
				systemBalanceAccountsMonth: 0,
				systemBalanceAccountsYear: 0,
				// 合计
				systemTotalDay: 0,
				systemTotalMonth: 0,
				systemTotalYear: 0,
				// 应收厂家返利金额
				systemFactoryRebateReceivableDay: 0,
				systemFactoryRebateReceivableMonth: 0,
				systemFactoryRebateReceivableYear: 0,
				// 应收厂家降价金额
				systemFactoryDiscountReceivableDay: 0,
				systemFactoryDiscountReceivableMonth: 0,
				systemFactoryDiscountReceivableYear: 0,
				// 应付客户佣金金额
				systemCustomerCommissionPayableDay: 0,
				systemCustomerCommissionPayableMonth: 0,
				systemCustomerCommissionPayableYear: 0,
				// 应付厂家佣金金额
				systemFactoryCommissionPayableDay: 0,
				systemFactoryCommissionPayableMonth: 0,
				systemFactoryCommissionPayableYear: 0,
				// 票点未入账金额
				systemUnrecordedInvoiceAmountDay: 0,
				systemUnrecordedInvoiceAmountMonth: 0,
				systemUnrecordedInvoiceAmountYear: 0,
				// 未入账金额结余
				systemUnrecordedBalanceDay: 0,
				systemUnrecordedBalanceMonth: 0,
				systemUnrecordedBalanceYear: 0,
				// 本日应当利润
				systemExpectedProfitDay: 0,
				systemExpectedProfitMonth: 0,
				systemExpectedProfitYear: 0
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		formatMoney(value) {
			const num = Number(value) || 0;
			return num.toFixed(2);
		},
		getList() {
			this.loading = true;
			getDailyProfitStatistics(this.queryParams)
				.then(res => {
					if (!res.data) {
						this.$message.warning('当前搜索条件下，无相关信息');
						return;
					}
					this.dailyProfitStatistics = { ...this.dailyProfitStatistics, ...res.data };
				})
				.finally(() => {
					this.loading = false;
				});
		},
		handleQuery() {
			this.getList();
		},
		resetQuery() {
			this.queryParams.date = parseTime(new Date(), '{y}-{m}-{d}');
			this.handleQuery();
		},
		/**
		 * 导出本日应当利润（与当前查询日期一致）
		 * @returns {void}
		 */
		handleExport() {
			this.download(
				'statistics/export/getDailyProfitStatistics',
				{
					date: this.queryParams.date
				},
				`本日应当利润_${this.queryParams.date || parseTime(new Date(), '{y}-{m}-{d}')}.xlsx`
			);
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
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-form-item>
		</el-form>

		<table class="profit-table" v-loading="loading">
			<thead>
				<tr>
					<th colspan="5" class="table-title">本日应当利润 {{ queryParams.date }}</th>
				</tr>
				<tr>
					<th width="200"></th>
					<th width="300">项目</th>
					<th width="150">当日合计</th>
					<th width="150">本月累计</th>
					<th width="150">本年累计</th>
				</tr>
			</thead>
			<tbody>
				<!-- 当日订单系统利润部分 -->
				<tr class="bg-yellow">
					<td rowspan="11" class="section-title">当日订单系统利润</td>
					<td>加：当日新增入库</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemNewInventoryDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemNewInventoryMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemNewInventoryYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>加：订单系统玻璃收入</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassRevenueDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassRevenueMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassRevenueYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统玻璃成本</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassCostDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassCostMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemGlassCostYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统应付运费</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemPayableFreightDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemPayableFreightMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemPayableFreightYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>加：订单系统票点收入</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceOutDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceOutMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceOutYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统票点成本</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceInDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceInMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemInvoiceInYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统管理费用</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemDailyExpenseDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemDailyExpenseMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemDailyExpenseYear) }}</td>
				</tr>
				<tr class="bg-yellow summary-row">
					<td>订单系统利润</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemProfitDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemProfitMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemProfitYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>实收返利金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemActualReceivedRebateDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemActualReceivedRebateMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemActualReceivedRebateYear) }}</td>
				</tr>
				<tr class="bg-yellow">
					<td>平账（客户平账 - 供应商平账）</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemBalanceAccountsDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemBalanceAccountsMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemBalanceAccountsYear) }}</td>
				</tr>
				<tr class="bg-yellow total-row">
					<td>合计（利润 + 实收返利 - 平账）</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemTotalDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemTotalMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemTotalYear) }}</td>
				</tr>

				<!-- 未入账部分（权责发生） -->
				<tr class="bg-green">
					<td rowspan="6" class="section-title">
						未入账部分
						<br />
						（权责发生）
					</td>
					<td>①当日应收厂家返利金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryRebateReceivableDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryRebateReceivableMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryRebateReceivableYear) }}</td>
				</tr>
				<tr class="bg-green">
					<td>②当日应收厂家降价金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryDiscountReceivableDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryDiscountReceivableMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryDiscountReceivableYear) }}</td>
				</tr>
				<tr class="bg-green">
					<td>③当日应付客户佣金金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemCustomerCommissionPayableDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemCustomerCommissionPayableMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemCustomerCommissionPayableYear) }}</td>
				</tr>
				<tr class="bg-green">
					<td>④当日应付厂家佣金金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryCommissionPayableDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryCommissionPayableMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemFactoryCommissionPayableYear) }}</td>
				</tr>
				<tr class="bg-green">
					<td>⑤当月票点未入账金额</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedInvoiceAmountDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedInvoiceAmountMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedInvoiceAmountYear) }}</td>
				</tr>
				<tr class="bg-green summary-row">
					<td>当月未入账金额结余=①+②-③-④+⑤</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedBalanceDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedBalanceMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemUnrecordedBalanceYear) }}</td>
				</tr>

				<!-- 本日应当利润 -->
				<tr class="bg-orange result-row">
					<td colspan="2" class="result-title">本日应当利润</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemExpectedProfitDay) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemExpectedProfitMonth) }}</td>
					<td>￥ {{ formatMoney(dailyProfitStatistics.systemExpectedProfitYear) }}</td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<style scoped lang="scss">
.profit-table {
	width: 95%;
	margin: 20px auto;
	border-collapse: collapse;
	text-align: center;
	font-size: 14px;
}

.profit-table th,
.profit-table td {
	padding: 10px 12px;
	border: 1px solid #999;
}

.profit-table th {
	background-color: #f5f5f5;
	font-weight: bold;
}

.table-title {
	font-size: 16px;
	background-color: #409eff !important;
	color: #fff;
}

.section-title {
	font-weight: bold;
	vertical-align: middle;
	background-color: inherit;
}

.bg-yellow {
	background-color: #ffff00;
}

.bg-green {
	background-color: #92d050;
}

.bg-orange {
	background-color: #ffc000;
}

.summary-row td {
	font-weight: bold;
}

.total-row td {
	font-weight: bold;
	border-top: 2px solid #333;
}

.result-row td {
	font-weight: bold;
	font-size: 16px;
}

.result-title {
	text-align: center;
}

.profit-table tr:hover {
	opacity: 0.9;
}
</style>
