<template>
	<div class="app-container">
		<el-row>
			<el-col :span="24">
				<el-card>
					<el-form
						:inline="true"
						:model="queryParams"
						class="demo-form-inline"
					>
						<el-form-item label="日期">
							<el-date-picker
								v-model="queryParams.endTime"
								type="date"
								placeholder="选择日期"
								value-format="yyyy-MM-dd"
							/>
						</el-form-item>
						<el-form-item>
							<el-button type="primary" @click="fetchData"
								>查询</el-button
							>
						</el-form-item>
					</el-form>
				</el-card>
			</el-col>
		</el-row>
		<el-row style="margin-top: 20px">
			<el-col :span="24">
				<el-table :data="tableData" border stripe size="mini">
					<el-table-column type="index" label="序号" width="50" />
					<el-table-column prop="date" label="日期" />
					<el-table-column prop="acountsName" label="户名" />
					<el-table-column prop="bankNo" label="银行账号" />
					<el-table-column prop="displayName" label="展示名称" />
					<el-table-column prop="bankCardType" label="银行卡类别" />
					<el-table-column label="资金日报部分">
						<el-table-column
							prop="previousBalance"
							label="上日余额"
						/>
						<el-table-column prop="totalIncome" label="本日收款" />
						<el-table-column prop="totalExpense" label="本日付款" />
						<el-table-column
							prop="currentBalance"
							label="本日余额"
						/>
					</el-table-column>
					<el-table-column label="资金月报部分">
						<el-table-column
							prop="previousMonthBalance"
							label="上月余额"
						/>
						<el-table-column
							prop="monthlyIncome"
							label="本月收款"
						/>
						<el-table-column
							prop="monthlyExpense"
							label="本月付款"
						/>
						<el-table-column
							prop="monthlyBalance"
							label="本月余额"
						/>
					</el-table-column>
					<el-table-column label="资金年报部分">
						<el-table-column
							prop="previousYearBalance"
							label="上年余额"
						/>
						<el-table-column prop="yearlyIncome" label="本年收款" />
						<el-table-column
							prop="yearlyExpense"
							label="本年付款"
						/>
						<el-table-column
							prop="yearlyBalance"
							label="本年余额"
						/>
					</el-table-column>
				</el-table>
			</el-col>
		</el-row>
	</div>
</template>

<script>
import { getTodaySelfCompanyMoneySummary } from '@/api/system/statement';

export default {
	data() {
		const today = new Date();
		const oneMonthAgo = new Date();
		oneMonthAgo.setMonth(today.getMonth() - 1);
		return {
			queryParams: {
				beginTime: this.formatDate(oneMonthAgo),
				endTime: this.formatDate(today)
			},
			tableData: []
		};
	},
	methods: {
		formatDate(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0');
			const d = String(date.getDate()).padStart(2, '0');
			return `${y}-${m}-${d}`;
		},
		async fetchData() {
			const response = await getTodaySelfCompanyMoneySummary(
				this.queryParams
			);
			if (response.code === 200) {
				this.tableData = response.data.map(item => {
					return {
						...item,
						date: this.formatDate(
							new Date(this.queryParams.endTime)
						),
						acountsName: item.acountsName || '-',
						bankNo: item.bankNo || '-'
					};
				});
			} else {
				this.$message.error('获取数据失败');
			}
		}
	},
	created() {
		this.fetchData();
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
