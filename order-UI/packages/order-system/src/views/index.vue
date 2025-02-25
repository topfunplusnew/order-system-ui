<template>
	<div>
		<el-row style="margin: 35px 0" :gutter="40">
			<!-- 标记1 -->
			<el-col :span="12">
				<el-row :gutter="10">
					<el-col :span="24">
						<div style="font-weight: bold; font-size: 24px; color: #156fb2; line-height: 60px">今日发货列表</div>
					</el-col>
					<el-form :inline="true" :model="queryParams">
						<el-form-item label="开始时间">
							<el-date-picker
								v-model="queryParams.startTime"
								type="datetime"
								size="mini"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="开始日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="结束时间">
							<el-date-picker
								v-model="queryParams.endTime"
								type="datetime"
								size="mini"
								value-format="yyyy-MM-dd HH:mm:ss"
								placeholder="结束日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
						</el-form-item>
					</el-form>
				</el-row>
				<el-row :gutter="50">
					<el-col>
						<right-toolbar :columns="columns" @queryTable="getList">
							<template #print>
								<el-col :span="1.5">
									<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
								</el-col>
							</template>
							<!--        导出-->
							<template #export>
								<el-col :span="1.5">
									<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
								</el-col>
							</template>
						</right-toolbar>
						<!--        发货列表-->
						<el-table
							id="printBox"
							size="mini"
							:data="tableData"
							max-height="500"
							show-summary
							border
							style="width: 100%"
							:loading="loading"
							:header-cell-style="{
								background: '#f0f0f0',
								color: '#333'
							}"
							:cell-style="
								() => {
									return { padding: '2px' };
								}
							"
						>
							<el-table-column prop="index" label="序号" width="50" align="center" type="index"></el-table-column>
							<el-table-column v-if="columns[0].visible" prop="orderDate" label="日期" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[1].visible" prop="companyName" label="客户" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[2].visible" prop="salesman" label="业务员" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[3].visible" prop="arrears" label="欠款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[4].visible" prop="profit" label="含税利润" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[5].visible" prop="profitNoTax" label="不含税利润" width="110" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[6].visible" prop="payments" label="总货款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[7].visible" prop="paymentFactory" label="出厂货款" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[8].visible" prop="tonnage" label="吨位" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[9].visible" prop="clerk" label="内勤" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[10].visible" prop="landCarNo" label="陆运车牌" show-overflow-tooltip>
								<template #default="scope">
									<span v-if="scope.row.landCarNo !== null">
										{{ scope.row.landCarNo }}
									</span>
									<span v-else>无</span>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[11].visible" prop="seaCarNo" label="柜号" show-overflow-tooltip>
								<template #default="scope">
									<span v-if="scope.row.seaCarNo !== null">
										{{ scope.row.seaCarNo }}
									</span>
									<span v-else>无</span>
								</template>
							</el-table-column>
							<el-table-column v-if="columns[12].visible" prop="fleet" label="车队" show-overflow-tooltip></el-table-column>
							<el-table-column v-if="columns[13].visible" prop="freight" label="运费" show-overflow-tooltip></el-table-column>
						</el-table>
						<pagination
							v-show="total > 0"
							:total="total"
							:page.sync="queryParams.pageNum"
							:limit.sync="queryParams.pageSize"
							@pagination="getList"
							style="width: 100%; text-align: center"
						/>
						<!--        分页-->
					</el-col>
				</el-row>
			</el-col>
			<!-- 标记2 -->
			<el-col :span="12">
				<el-row :gutter="10">
					<el-col :span="24">
						<div style="font-weight: bold; font-size: 24px; color: #156fb2; line-height: 60px">利润</div>
					</el-col>
					<el-form :inline="true" :model="queryParamsHome">
						<el-form-item label="开始日期">
							<el-date-picker
								v-model="queryParamsHome.beginTime"
								type="date"
								size="mini"
								value-format="yyyy-MM-dd"
								placeholder="开始日期"
								class="responsive-date-picker"
							></el-date-picker>
						</el-form-item>
						<el-form-item label="时间">
							<el-date-picker v-model="queryParamsHome.endTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="结束日期" class="responsive-date-picker"></el-date-picker>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" size="mini" @click="handleProfitSearch">搜索</el-button>
						</el-form-item>
					</el-form>
				</el-row>
				<el-row>
					<el-table height="130" :empty-text="' '" :data="dailyProfit">
						<el-table-column :label="`￥${moneyAmount}`" align="center">
							<el-table-column prop="dailyProfit" label="利润总额">
								<el-table-column prop="dailyExpense" label="费用合计"></el-table-column>
							</el-table-column>
							<el-table-column :label="`￥${dailyProfit}`">
								<el-table-column :label="`￥${dailyExpense}`"></el-table-column>
							</el-table-column>
						</el-table-column>
					</el-table>
				</el-row>
			</el-col>
		</el-row>
	</div>
</template>

<script>
import { getDailyProfit, getDeliveryList } from '../api/system/statement';
import { mixin_printHTML } from './dashboard/mixins/print';
import { parseTime } from '@/utils/ruoyi';

export default {
	name: 'Index',
	mixins: [mixin_printHTML],
	data() {
		// 获取今天零点
		const startTime = new Date();
		startTime.setHours(0, 0, 0, 0); // 设置为今天零点

		// 获取今天晚上十二点
		const endTime = new Date();
		endTime.setHours(23, 59, 59, 999); // 设置为今天晚上12点

		// 格式化函数
		function formatDate(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0');
			const d = String(date.getDate()).padStart(2, '0');
			const h = String(date.getHours()).padStart(2, '0');
			const i = String(date.getMinutes()).padStart(2, '0');
			const s = String(date.getSeconds()).padStart(2, '0');
			return `${y}-${m}-${d} ${h}:${i}:${s}`;
		}

		return {
			loading: false,
			queryParams: {
				startTime: formatDate(startTime),
				endTime: formatDate(endTime),
				pageNum: 1,
				pageSize: 10
			},
			queryParamsHome: {
				beginTime: parseTime(new Date(), '{y}-{m}-{d}'),
				endTime: formatDate(new Date(), '{y}-{m}-{d}')
			},
			tableData: [],
			total: 0,
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `客户`, visible: true },
				{ key: 2, label: `录入员`, visible: true },
				{ key: 3, label: `欠款`, visible: true },
				{ key: 4, label: `含税利润`, visible: true },
				{ key: 5, label: `不含税利润`, visible: true },
				{ key: 6, label: `总货款`, visible: true },
				{ key: 7, label: `出厂货款`, visible: true },
				{ key: 8, label: `吨位`, visible: true },
				{ key: 9, label: `内勤`, visible: true },
				{ key: 10, label: `陆运车牌`, visible: true },
				{ key: 11, label: `柜号`, visible: true },
				{ key: 12, label: `车队`, visible: true },
				{ key: 13, label: `运费`, visible: true }
			],
			dailyProfit: null,
			dailyExpense: null,
			moneyAmount: null
		};
	},
	created() {
		this.getList();
		this.handleProfitSearch();
	},
	methods: {
		handleSearch() {
			this.getList();
		},
		handleProfitSearch() {
			this.dailyProfit = [];
			getDailyProfit(this.queryParamsHome).then(res => {
				this.dailyProfit = res.data.dailyProfit;
				this.dailyExpense = res.data.dailyExpense;
				this.moneyAmount = res.data.dailyProfit - res.data.dailyExpense;
			});
		},
		getList() {
			this.loading = true;
			getDeliveryList(this.queryParams).then(res => {
				this.tableData = res.rows;
				this.total = res.total;
				this.loading = false;
			});
		},
		handleExport() {
			this.download(
				'statistics/export/todayOrderList',
				{
					startTime: this.queryParams.startTime,
					endTime: this.queryParams.endTime
				},
				`todayOrderList${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss">
@import '~element-ui/lib/theme-chalk/index.css';

.button-search {
	line-height: 60px;
}

.el-row {
	margin-bottom: 20px;
}

.el-col {
	border-radius: 4px;
}

.el-date-editor.el-input,
.el-date-editor.el-input__inner {
	width: 150px;
}

.responsive-date-picker {
	width: 150px;
}

.el-button--mini {
	padding: 6px 12px;
}

.el-table th {
	font-weight: bold;
}

.el-table td,
.el-table th {
	padding: 8px;
}

.el-table .cell {
	font-size: 14px;
}

.el-table thead {
	font-weight: bold;
}

// Media Queries for responsiveness
@media (max-width: 960px) {
	.el-row {
		margin: 20px 0;
	}

	.el-col {
		margin-bottom: 10px;
	}

	.el-date-editor.el-input,
	.el-date-editor.el-input__inner,
	.responsive-date-picker {
		width: 100%;
	}

	.el-button--mini {
		width: 100%;
		margin-top: 10px;
	}

	.el-table {
		overflow-x: auto;
	}
}
</style>
