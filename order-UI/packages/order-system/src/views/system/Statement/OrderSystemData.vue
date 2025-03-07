<script>
import { getOrderSystemData } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';

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

			orderSystemData: []
		};
	},
	created() {
		this.fetchOrderSystemData();
	},
	computed: {
		dailyProfit() {
			return (
				this.orderSystemData.systemGlassRevenueDay -
				this.orderSystemData.systemGlassCostDay -
				this.orderSystemData.systemPayableFreightDay +
				this.orderSystemData.systemInvoiceOutDay -
				this.orderSystemData.systemInvoiceInDay -
				this.orderSystemData.systemDailyExpenseDay
			);
		},
		monthlyProfit() {
			return (
				this.orderSystemData.systemGlassRevenueMonth -
				this.orderSystemData.systemGlassCostMonth -
				this.orderSystemData.systemPayableFreightMonth +
				this.orderSystemData.systemInvoiceOutMonth -
				this.orderSystemData.systemInvoiceInMonth -
				this.orderSystemData.systemDailyExpenseMonth
			);
		},
		yearlyProfit() {
			return (
				this.orderSystemData.systemGlassRevenueYear -
				this.orderSystemData.systemGlassCostYear -
				this.orderSystemData.systemPayableFreightYear +
				this.orderSystemData.systemInvoiceOutYear -
				this.orderSystemData.systemInvoiceInYear -
				this.orderSystemData.systemDailyExpenseYear
			);
		}
	},
	methods: {
		fetchOrderSystemData() {
			getOrderSystemData(this.queryParams).then(res => {
				if (!res.rows && !res.data) {
					this.$message.error(res.msg || '获取后端数据失败');
					return;
				}
				this.orderSystemData = res.data;
			});
		},
		handleExport() {
			this.$prompt('请选择返利日期', '提示', {
				confirmButtonText: '确定',
				cancelButtonText: '取消',
				inputType: 'date'
			}).then(({ value: date }) => {
				this.download(
					'statistics/getSystemMultiDimensionData',
					{
						date: date
					},
					`数据统计_${new Date().getTime()}.xlsx`
				);
			});
		}
	}
};
</script>

<template>
	<div>
		<div class="container">
			<el-form ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="100px">
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
							<td>￥ {{ orderSystemData.systemGlassRevenueDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemGlassRevenueMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemGlassRevenueYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>减：订单系统玻璃成本</td>
							<td>￥ {{ orderSystemData.systemGlassCostDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemGlassCostMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemGlassCostYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>减：订单系统应付运费</td>
							<td>￥ {{ orderSystemData.systemPayableFreightDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemPayableFreightMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemPayableFreightYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>加：订单系统票点收入</td>
							<td>￥ {{ orderSystemData.systemInvoiceOutDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemInvoiceOutMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemInvoiceOutYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>减：订单系统票点成本</td>
							<td>￥ {{ orderSystemData.systemInvoiceInDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemInvoiceInMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemInvoiceInYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>减：订单系统管理费用</td>
							<td>￥ {{ orderSystemData.systemDailyExpenseDay.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemDailyExpenseMonth.toFixed(2) }}</td>
							<td>￥ {{ orderSystemData.systemDailyExpenseYear.toFixed(2) }}</td>
						</tr>
						<tr>
							<td>订单系统利润</td>
							<td>￥ {{ dailyProfit.toFixed(2) }}</td>
							<td>￥ {{ monthlyProfit.toFixed(2) }}</td>
							<td>￥ {{ yearlyProfit.toFixed(2) }}</td>
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
