<template>
	<div class="daily-expense-reports">
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="startTime">
				<el-date-picker v-model="queryParams.startTime" type="date" placeholder="开始日期" value-format="yyyy-MM-dd" />
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="结束日期" value-format="yyyy-MM-dd" />
			</el-form-item>
			<el-form-item>
				<el-button type="danger" @click="searchData">查询</el-button>
			</el-form-item>
			<el-form-item>
				<el-button @click="resetQuery">刷新</el-button>
			</el-form-item>
		</el-form>

		<div class="report-title">费用日报表</div>
		<div class="date-display">
			日期:
			<span style="color: red">{{ queryParams.startTime }} 至 {{ queryParams.endTime }}</span>
		</div>

		<right-toolbar :columns="columns" @queryTable="getList">
			<template #print>
				<el-col :span="1.5">
					<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
				</el-col>
			</template>
			<!--        导出-->
			<template #export>
				<el-col :span="1.5">
					<el-button v-hasPermi="['system:bankaccount:export']" plain icon="el-icon-folder-opened" size="mini" @click="excelExport([''])"></el-button>
				</el-col>
			</template>
		</right-toolbar>
		<div id="printBox">
			<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
				<el-table-column type="index" label="序号" width="80" />
				<el-table-column prop="expenseType" label="对象" v-if="columns[0].visible" />
				<el-table-column prop="expenseAmount" label="付款金额" v-if="columns[1].visible" />
				<el-table-column prop="accountName" label="付款户名" v-if="columns[2].visible" />
				<el-table-column prop="expenseDate" label="时间" v-if="columns[3].visible" />
				<el-table-column prop="remark" label="备注" v-if="columns[4].visible" />
			</el-table>
		</div>
	</div>
</template>

<script>
import { parseTime } from '@/utils/ruoyi';
import { getDailyExpenseReports } from '@/api/system/statement';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';

export default {
	name: 'DailyExpenseReports',
	mixins: [common_excel, mixin_printHTML],
	data() {
		return {
			queryParams: {
				startTime: parseTime(new Date(), '{y}-{m}-{d}'),
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			loading: false,
			tableData: [],
			columns: [
				{ key: 0, label: `对象`, visible: true },
				{ key: 1, label: `付款金额`, visible: true },
				{ key: 2, label: `付款户名`, visible: true },
				{ key: 3, label: `时间`, visible: true },
				{ key: 4, label: `备注`, visible: true }
			]
		};
	},
	methods: {
		getList() {
			this.loading = true;
			getDailyExpenseReports(this.queryParams)
				.then(res => {
					this.tableData = res.data;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		searchData() {
			this.getList();
		},
		resetQuery() {
			this.reset();
			this.searchData();
		},
		reset() {
			this.queryParams = {
				startTime: parseTime(new Date(), '{y}-{m}-{d}'),
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			};
		}
	},
	created() {
		this.searchData();
	}
};
</script>

<style lang="scss" scoped>
.daily-expense-reports {
	padding: 20px;

	.search-bar {
		margin-bottom: 20px;

		.el-button {
			margin-left: 10px;
		}
	}

	.report-title {
		font-size: 20px;
		font-weight: bold;
		text-align: start;
		margin-bottom: 15px;
	}

	.date-display {
		margin-bottom: 15px;
	}

	.table-operations {
		text-align: right;
		margin-bottom: 10px;

		.el-button {
			margin-left: 10px;
		}
	}

	.no-data {
		text-align: center;
		color: #999;
		padding: 20px;
	}
}
</style>
