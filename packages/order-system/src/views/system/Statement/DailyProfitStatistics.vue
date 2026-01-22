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
				// 订单系统票点成本（进项发票）
				systemInvoiceInDay: 0,
				systemInvoiceInMonth: 0,
				systemInvoiceInYear: 0,
				// 订单系统票点收入（销项发票）
				systemInvoiceOutDay: 0,
				systemInvoiceOutMonth: 0,
				systemInvoiceOutYear: 0,
				// 订单系统管理费用（日常费用）
				systemDailyExpenseDay: 0,
				systemDailyExpenseMonth: 0,
				systemDailyExpenseYear: 0,
				// 实收返利金额
				systemActualReceivedRebateDay: 0,
				systemActualReceivedRebateMonth: 0,
				systemActualReceivedRebateYear: 0,
				// 当日新增入库
				systemNewInventoryDay: 0,
				systemNewInventoryMonth: 0,
				systemNewInventoryYear: 0,
				// 平账（客户平账 - 供应商平账）
				systemBalanceAccountsDay: 0,
				systemBalanceAccountsMonth: 0,
				systemBalanceAccountsYear: 0,
				// 订单系统利润
				systemProfitDay: 0,
				systemProfitMonth: 0,
				systemProfitYear: 0,
				// 合计
				systemTotalDay: 0,
				systemTotalMonth: 0,
				systemTotalYear: 0
			}
		};
	},
	methods: {
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
				<!-- 订单系统利润 -->
				<tr class="bg-yellow">
					<td rowspan="7">订单系统利润</td>
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
					<td>订单系统利润小计</td>
					<td>￥ {{ dailyProfitStatistics.systemProfitDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemProfitMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemProfitYear.toFixed(2) }}</td>
				</tr>

				<!-- 实收返利金额 -->
				<tr class="bg-green">
					<td colspan="2">加：实收返利金额</td>
					<td>￥ {{ dailyProfitStatistics.systemActualReceivedRebateDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemActualReceivedRebateMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemActualReceivedRebateYear.toFixed(2) }}</td>
				</tr>

				<!-- 当日新增入库 -->
				<tr class="bg-blue">
					<td colspan="2">当日新增入库</td>
					<td>￥ {{ dailyProfitStatistics.systemNewInventoryDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemNewInventoryMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemNewInventoryYear.toFixed(2) }}</td>
				</tr>

				<!-- 平账 -->
				<tr class="bg-purple">
					<td colspan="2">减：平账（客户平账 - 供应商平账）</td>
					<td>￥ {{ dailyProfitStatistics.systemBalanceAccountsDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemBalanceAccountsMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemBalanceAccountsYear.toFixed(2) }}</td>
				</tr>

				<!-- 合计 -->
				<tr class="bg-orign">
					<td colspan="2">合计（利润 + 实收返利 - 平账）</td>
					<td>￥ {{ dailyProfitStatistics.systemTotalDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemTotalMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemTotalYear.toFixed(2) }}</td>
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

.bg-purple {
	background-color: #b4a7d6;
}
</style>
