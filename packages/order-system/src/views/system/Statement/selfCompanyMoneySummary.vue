<template>
	<div class="app-container">
		<el-row>
			<el-col :span="24">
				<el-card>
					<el-form id="top-search-form-item" :inline="true" :model="queryParams" class="demo-form-inline" label-width="150px">
						<el-form-item label="日期">
							<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" />
						</el-form-item>
						<el-form-item>
							<el-button type="primary" @click="fetchData">查询</el-button>
						</el-form-item>
					</el-form>
				</el-card>
			</el-col>
		</el-row>
		<el-row style="margin-top: 20px">
			<el-col :span="24">
				<el-row :gutter="10" class="mb8">
					<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="fetchData">
						<template #print>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
							</el-col>
						</template>
						<template #export>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
							</el-col>
						</template>
					</right-toolbar>
				</el-row>

				<el-table id="printBox" :data="tableData" border stripe size="mini">
					<el-table-column type="index" label="序号" width="50" />
					<el-table-column v-if="columns[0].visible" prop="date" label="日期" />
					<el-table-column v-if="columns[1].visible" prop="displayName" label="己方公司" />
					<el-table-column v-if="columns[2].visible" prop="acountsName" label="开户名称" />
					<el-table-column v-if="columns[3].visible" prop="bankNo" label="银行账号" />
					<el-table-column v-if="columns[4].visible" label="资金日报部分">
						<el-table-column prop="previousBalance" label="上日余额" />
						<el-table-column prop="totalIncome" label="本日收款" />
						<el-table-column prop="totalExpense" label="本日付款" />
						<el-table-column prop="currentBalance" label="本日余额" />
					</el-table-column>
					<el-table-column v-if="columns[5].visible" label="资金月报部分">
						<el-table-column prop="previousMonthBalance" label="上月余额" />
						<el-table-column prop="monthlyIncome" label="本月收款" />
						<el-table-column prop="monthlyExpense" label="本月付款" />
						<el-table-column prop="monthlyBalance" label="本月余额" />
					</el-table-column>
					<el-table-column v-if="columns[6].visible" label="资金年报部分">
						<el-table-column prop="previousYearBalance" label="上年余额" />
						<el-table-column prop="yearlyIncome" label="本年收款" />
						<el-table-column prop="yearlyExpense" label="本年付款" />
						<el-table-column prop="yearlyBalance" label="本年余额" />
					</el-table-column>
				</el-table>
			</el-col>
		</el-row>
	</div>
</template>

<script>
import { getTodaySelfCompanyMoneySummary } from '@/api/system/statement';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';

export default {
	mixins: [mixin_printHTML],
	data() {
		const today = new Date();
		const oneMonthAgo = new Date();
		oneMonthAgo.setMonth(today.getMonth() - 1);
		return {
			showSearch: true,
			queryParams: {
				endTime: this.formatDate(today)
			},
			tableData: [],
			// 隐藏列信息
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `己方公司`, visible: true },
				{ key: 2, label: `开户名称`, visible: true },
				{ key: 3, label: `银行账号`, visible: true },
				{ key: 4, label: `资金日报部分`, visible: true },
				{ key: 5, label: `资金月报部分`, visible: true },
				{ key: 6, label: `资金年报部分`, visible: true }
			]
		};
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('selfCompanyMoneySummary-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		this.fetchData();
		const saved = localStorage.getItem('selfCompanyMoneySummary-columns');
		if (saved && saved !== 'null') {
			const parsed = JSON.parse(saved);
			this.columns = Array.isArray(parsed) && parsed.length === this.columns.length ? parsed : this.columns;
		}
		localStorage.setItem('selfCompanyMoneySummary-columns', JSON.stringify(this.columns));
	},
	methods: {
		formatDate(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0');
			const d = String(date.getDate()).padStart(2, '0');
			return `${y}-${m}-${d}`;
		},
		async fetchData() {
			const response = await getTodaySelfCompanyMoneySummary(this.queryParams);
			if (response.code === 200) {
				this.tableData = response.data.map(item => {
					// 对付款相关字段进行数值取反操作
					// 原因：后端返回的付款数据为负数（表示支出），前端显示需要转换为正数（取反）
					// 涉及的字段：本日付款、本月付款、本年付款
					const totalExpense = item.totalExpense != null ? -item.totalExpense : null; // 本日付款取反
					const monthlyExpense = item.monthlyExpense != null ? -item.monthlyExpense : null; // 本月付款取反
					const yearlyExpense = item.yearlyExpense != null ? -item.yearlyExpense : null; // 本年付款取反

					return {
						...item,
						date: this.formatDate(new Date(this.queryParams.endTime)),
						acountsName: item.acountsName || '-',
						bankNo: item.bankNo || '-',
						// 使用取反后的付款字段值
						totalExpense,
						monthlyExpense,
						yearlyExpense
					};
				});
			} else {
				this.$message.error('获取数据失败');
			}
		},
		/** 导出按钮操作 */
		handleExport() {
			// 使用模拟地址，因为后端还没有完善
			this.download('/statistics/export/todaySelfCompanyMoneySummary?endTime=' + this.queryParams.endTime, null, `己方资金汇总_${new Date().getTime()}.xlsx`);
		}
	}
};
</script>

<style scoped>
.app-container {
	padding: 20px;
	background-color: #f5f7fa;
}
.demo-form-inline .el-form-item {
	margin-right: 20px;
}
</style>
