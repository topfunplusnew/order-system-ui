<!-- 运费报表-->
<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { parseTime } from '@/utils/ruoyi';
import { getSubjectSummary } from '../../../api/system/statement';
import { fix } from '../../../api/tool/format';

export default {
	name: 'Subjectsummary',
	mixins: [mixin_printHTML],
	data() {
		return {
			queryParams: {
				subjectName: '',
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			loading: false,
			columns: [
				{ key: 0, label: '费用科目汇总和费用占比', visible: true },
				{ key: 1, label: '费用科目名称', visible: true },
				{ key: 2, label: '费用日报', visible: true },
				{ key: 3, label: '付款金额', visible: true },
				{ key: 4, label: '占比', visible: true },
				{ key: 5, label: '费用月报', visible: true },
				{ key: 6, label: '付款金额', visible: true },
				{ key: 7, label: '占比', visible: true },
				{ key: 8, label: '费用年报', visible: true },
				{ key: 9, label: '付款金额', visible: true },
				{ key: 10, label: '占比', visible: true }
			],

			statementList: []
		};
	},
	created() {
		this.loading = true;
		getSubjectSummary(this.queryParams).then(res => {
			if (Reflect.has(res, 'data')) {
				this.statementList = res.data.detail;
				this.loading = false;
			} else {
				this.statementList = [];
				this.loading = false;
			}
		});
	},
	methods: {
		getSummaries(param) {
			const { columns, data } = param;
			const sums = {};

			columns.forEach(column => {
				if (column.property === 'daySum' || column.property === 'monthSum' || column.property === 'yearSum') {
					sums[column.property] = data.reduce((total, item) => total + parseFloat(item[column.property]), 0);
				}
			});

			return columns.map(column => {
				switch (column.property) {
					case 'daySum':
						return `总计: ${fix(sums.daySum)}`;
					case 'monthSum':
						return `总计: ${fix(sums.monthSum)}`;
					case 'yearSum':
						return `总计: ${fix(sums.yearSum)}`;
					default:
						return '';
				}
			});
		},
		// 时间查询
		handleQuery() {
			getSubjectSummary(this.queryParams).then(res => {
				this.loading = true;
				if (Reflect.has(res, 'data')) {
					this.statementList = res.data.detail;
					this.loading = false;
				} else {
					this.statementList = [];
					this.loading = false;
				}
			});
		},
		refresh() {
			this.handleQuery();
		},
		handleExport() {
			this.download(
				'statistics/export/subjectsummary',
				{
					endTime: this.queryParams.endTime
				},
				`费用科目汇总_${parseTime(new Date().getTime())}.xlsx`
			);
		}
	}
};
</script>

<template>
	<div>
		<div class="app-container">
			<!--    刷新行-->
			<el-row style="background-color: #e6e6e6">
				<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
			</el-row>
			<hr color="#e6e6e6" />
			<!--    时间范围搜索行-->
			<el-row>
				<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
					<el-form-item label="日期" prop="endTime">
						<el-date-picker v-model="queryParams.endTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
					</el-form-item>
					<el-form-item label="科目">
						<el-input v-model="queryParams.subjectName" placeholder="请输入科目名称" clearable @keyup.enter.native="handleQuery" size="mini" />
					</el-form-item>
					<el-form-item>
						<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					</el-form-item>
				</el-form>
			</el-row>
			<hr color="#e6e6e6" />
			<el-row>
				<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">费用科目汇总</el-row>
				<el-row>
					<right-toolbar :columns="columns">
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
					<el-table
						id="printBox"
						v-loading="loading"
						v-horizontal-scroll="'always'"
						fit
						border
						:data="statementList"
						show-summary
						:summary-method="getSummaries"
						size="mini"
						:cell-style="
							() => {
								return { padding: '2px' };
							}
						"
					>
						<!-- 费用科目汇总和费用占比 -->
						<el-table-column v-if="columns[0].visible" label="费用科目汇总和费用占比" align="center">
							<!-- 费用科目名称 -->
							<el-table-column v-if="columns[1].visible" label="费用科目名称" align="center" prop="payType" width="300" />

							<!-- 费用日报 -->
							<el-table-column v-if="columns[2].visible" label="费用日报" align="center" prop="carNo">
								<!-- 付款金额 -->
								<el-table-column v-if="columns[3].visible" label="付款金额" align="center" prop="daySum" width="300" />

								<!-- 占比 -->
								<el-table-column v-if="columns[4].visible" label="占比" align="center" prop="dayPercentage" width="300">
									<template #default="scope">{{ (scope.row.dayPercentage * 100).toFixed(2) }}%</template>
								</el-table-column>
							</el-table-column>

							<!-- 费用月报 -->
							<el-table-column v-if="columns[5].visible" label="费用月报" align="center" prop="carNo">
								<!-- 付款金额 -->
								<el-table-column v-if="columns[6].visible" label="付款金额" align="center" prop="monthSum" width="300" />

								<!-- 占比 -->
								<el-table-column v-if="columns[7].visible" label="占比" align="center" prop="monthPercentage" width="300">
									<template #default="scope">{{ (scope.row.monthPercentage * 100).toFixed(2) }}%</template>
								</el-table-column>
							</el-table-column>

							<!-- 费用年报 -->
							<el-table-column v-if="columns[8].visible" label="费用年报" align="center" prop="carNo">
								<!-- 付款金额 -->
								<el-table-column v-if="columns[9].visible" label="付款金额" align="center" prop="yearSum" width="300" />

								<!-- 占比 -->
								<el-table-column v-if="columns[10].visible" label="占比" align="center" prop="yearPercentage" width="300">
									<template #default="scope">{{ (scope.row.yearPercentage * 100).toFixed(2) }}%</template>
								</el-table-column>
							</el-table-column>
						</el-table-column>
					</el-table>
				</el-row>
			</el-row>
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
