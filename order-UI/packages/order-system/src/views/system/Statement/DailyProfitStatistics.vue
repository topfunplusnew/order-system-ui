<script>
import { parseTime } from '@/utils/ruoyi';
import { getDailyProfitStatistics } from '@/api/system/statement';

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
				systemDailyExpenseYear: 0
			}
		};
	},
	computed: {
		dailyProfit() {
			return (
				this.dailyProfitStatistics.systemGlassRevenueDay -
				this.dailyProfitStatistics.systemGlassCostDay -
				this.dailyProfitStatistics.systemPayableFreightDay +
				this.dailyProfitStatistics.systemInvoiceOutDay -
				this.dailyProfitStatistics.systemInvoiceInDay -
				this.dailyProfitStatistics.systemDailyExpenseDay
			);
		},
		monthlyProfit() {
			return (
				this.dailyProfitStatistics.systemGlassRevenueMonth -
				this.dailyProfitStatistics.systemGlassCostMonth -
				this.dailyProfitStatistics.systemPayableFreightMonth +
				this.dailyProfitStatistics.systemInvoiceOutMonth -
				this.dailyProfitStatistics.systemInvoiceInMonth -
				this.dailyProfitStatistics.systemDailyExpenseMonth
			);
		},
		yearlyProfit() {
			// 年度利润计算
			return (
				this.dailyProfitStatistics.systemGlassRevenueYear -
				this.dailyProfitStatistics.systemGlassCostYear -
				this.dailyProfitStatistics.systemPayableFreightYear +
				this.dailyProfitStatistics.systemInvoiceOutYear -
				this.dailyProfitStatistics.systemInvoiceInYear -
				this.dailyProfitStatistics.systemDailyExpenseYear
			);
		}
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
		// 处理查询
		handleQuery() {
			this.getList();
		},
		// 重置查询
		resetQuery() {
			this.queryParams.date = parseTime(new Date(), '{y}-{m}-{d}');
			this.handleQuery();
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form :model="queryParams" ref="queryForm" :inline="true" class="search-form" size="mini">
			<el-form-item label="日期">
				<el-date-picker v-model="queryParams.date" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width: 240px" size="mini" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
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
					<!-- 新增年合计列 -->
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
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统玻璃成本</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统应付运费</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>加：订单系统票点收入</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统票点成本</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>减：订单系统管理费用</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-yellow">
					<td>订单系统利润</td>
					<td>￥ {{ dailyProfit.toFixed(2) }}</td>
					<td>￥ {{ monthlyProfit.toFixed(2) }}</td>
					<td>￥ {{ yearlyProfit.toFixed(2) }}</td>
					<!-- 年度利润 -->
				</tr>

				<!-- 未入账部分 -->
				<tr class="bg-green">
					<td rowspan="5">未入账部分（权责发生）</td>
					<td>①当日应收计提厂家返利金额</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemGlassCostYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-green">
					<td>②当日应收计提厂家降价金额</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemPayableFreightYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-green">
					<td>③当日应付客户佣金金额</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceOutYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-green">
					<td>④当日票点差额(即厂家含税和客户含税差额，已折合票点）</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>
				<tr class="bg-green">
					<td>当月未入账金额结余=①+②-③+④</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemDailyExpenseYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>

				<!-- 已入账部分 -->
				<tr>
					<td rowspan="1">已入账部分</td>
					<td>减去上个月返利在本日入账的金额（订单系统上面供应商返利台账取数）</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
				</tr>

				<!-- 本日应当利润 -->
				<tr class="bg-orign">
					<td colspan="2">本日应当利润</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInDay.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInMonth.toFixed(2) }}</td>
					<td>￥ {{ dailyProfitStatistics.systemInvoiceInYear.toFixed(2) }}</td>
					<!-- 年度数据 -->
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
</style>
