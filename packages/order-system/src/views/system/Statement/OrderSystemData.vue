<script>
import { getOrderSystemData } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { add, subtract, number } from 'mathjs';

export default {
	name: 'OrderSystemData',
	mixins: [common_excel, mixin_printHTML],
	data() {
		return {
			queryParams: {
				date: parseTime(new Date(), '{y}-{m}-{d}') // 结束时间
			},
			columns: [
				{ key: 0, label: '系统玻璃收入 (元)', visible: true },
				{ key: 1, label: '系统玻璃成本 (元)', visible: true },
				{ key: 2, label: '系统应付运费 (元)', visible: true },
				{ key: 3, label: '系统进项发票 (元)', visible: true },
				{ key: 4, label: '系统销项发票 (元)', visible: true },
				{ key: 5, label: '系统日常费用 (元)', visible: true }
			],

			orderSystemData: {
				systemGlassRevenueDay: 0,
				systemGlassRevenueMonth: 0,
				systemGlassRevenueYear: 0,
				systemGlassCostDay: 0,
				systemGlassCostMonth: 0,
				systemGlassCostYear: 0,
				systemPayableFreightDay: 0,
				systemPayableFreightMonth: 0,
				systemPayableFreightYear: 0,
				systemInvoiceOutDay: 0,
				systemInvoiceOutMonth: 0,
				systemInvoiceOutYear: 0,
				systemInvoiceInDay: 0,
				systemInvoiceInMonth: 0,
				systemInvoiceInYear: 0,
				systemDailyExpenseDay: 0,
				systemDailyExpenseMonth: 0,
				systemDailyExpenseYear: 0,
				systemActualReceivedRebateDay: 0,
				systemActualReceivedRebateMonth: 0,
				systemActualReceivedRebateYear: 0,
				systemTotalDay: 0,
				systemTotalMonth: 0,
				systemTotalYear: 0
			}
		};
	},
	created() {
		this.fetchOrderSystemData();
	},
	computed: {
		dailyProfit() {
			const d = this.orderSystemData || {};
			let profit = subtract(number(d?.systemGlassRevenueDay || 0), number(d?.systemGlassCostDay || 0));
			profit = subtract(profit, number(d?.systemPayableFreightDay || 0));
			profit = add(profit, number(d?.systemInvoiceOutDay || 0));
			profit = subtract(profit, number(d?.systemInvoiceInDay || 0));
			profit = subtract(profit, number(d?.systemDailyExpenseDay || 0));
			return number(profit);
		},
		monthlyProfit() {
			const d = this.orderSystemData || {};
			let profit = subtract(number(d?.systemGlassRevenueMonth || 0), number(d?.systemGlassCostMonth || 0));
			profit = subtract(profit, number(d?.systemPayableFreightMonth || 0));
			profit = add(profit, number(d?.systemInvoiceOutMonth || 0));
			profit = subtract(profit, number(d?.systemInvoiceInMonth || 0));
			profit = subtract(profit, number(d?.systemDailyExpenseMonth || 0));
			return number(profit);
		},
		yearlyProfit() {
			const d = this.orderSystemData || {};
			let profit = subtract(number(d?.systemGlassRevenueYear || 0), number(d?.systemGlassCostYear || 0));
			profit = subtract(profit, number(d?.systemPayableFreightYear || 0));
			profit = add(profit, number(d?.systemInvoiceOutYear || 0));
			profit = subtract(profit, number(d?.systemInvoiceInYear || 0));
			profit = subtract(profit, number(d?.systemDailyExpenseYear || 0));
			return number(profit);
		}
	},
	methods: {
		formatMoney(value) {
			return number(value || 0).toFixed(2);
		},
		fetchOrderSystemData() {
			getOrderSystemData(this.queryParams).then(res => {
				if (!res.rows && !res.data) {
					this.$message.error(res.msg || '获取后端数据失败');
					return;
				}
				this.orderSystemData = res.data || {};
			});
		},
		handleExport() {
			this.$prompt('请选择日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date'
			}).then(({ value: date }) => {
				this.download('/statistics/export/getSystemMultiDimensionData?date=' + date, null, `数据统计_${new Date().getTime()}.xlsx`);
			});
		}
	}
};
</script>

<template>
	<div>
		<div class="container">
			<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
				<el-form-item label="时间" prop="date">
					<el-date-picker v-model="queryParams.date" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="fetchOrderSystemData">搜索</el-button>
				</el-form-item>
				<el-form-item>
					<el-button type="warning" icon="el-icon-files" size="mini" @click="handleExport">导出</el-button>
				</el-form-item>
			</el-form>

			<div>
				<table class="optimized-table">
					<thead>
						<tr>
							<th>项目</th>
							<th>当日合计</th>
							<th>本月累计</th>
							<th>本年累计</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>加：订单系统玻璃收入</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassRevenueDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassRevenueMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassRevenueYear) }}</td>
						</tr>
						<tr>
							<td>减：订单系统玻璃成本</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassCostDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassCostMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemGlassCostYear) }}</td>
						</tr>
						<tr>
							<td>减：订单系统应付运费</td>
							<td>￥ {{ formatMoney(orderSystemData.systemPayableFreightDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemPayableFreightMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemPayableFreightYear) }}</td>
						</tr>
						<tr>
							<td>加：订单系统票点收入</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceOutDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceOutMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceOutYear) }}</td>
						</tr>
						<tr>
							<td>减：订单系统票点成本</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceInDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceInMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemInvoiceInYear) }}</td>
						</tr>
						<tr>
							<td>减：订单系统管理费用</td>
							<td>￥ {{ formatMoney(orderSystemData.systemDailyExpenseDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemDailyExpenseMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemDailyExpenseYear) }}</td>
						</tr>
						<tr>
							<td>订单系统利润</td>
							<td>￥ {{ formatMoney(dailyProfit) }}</td>
							<td>￥ {{ formatMoney(monthlyProfit) }}</td>
							<td>￥ {{ formatMoney(yearlyProfit) }}</td>
						</tr>
						<tr>
							<td>实收返利金额</td>
							<td>￥ {{ formatMoney(orderSystemData.systemActualReceivedRebateDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemActualReceivedRebateMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemActualReceivedRebateYear) }}</td>
						</tr>
						<tr>
							<td>合计</td>
							<td>￥ {{ formatMoney(orderSystemData.systemTotalDay) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemTotalMonth) }}</td>
							<td>￥ {{ formatMoney(orderSystemData.systemTotalYear) }}</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.container {
	margin: 30px;
}

.optimized-table {
	width: 80%;
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
</style>
