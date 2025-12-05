<!-- 运费报表-->
<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getOrderFreight } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { fix_2 } from '@/api/tool/format';

export default {
	name: 'Orderfreight',
	mixins: [mixin_printHTML],
	data() {
		return {
			total: 0,
			queryParams: {
				// beginTime: parseTime(
				// 	new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000),
				// 	'{y}-{m}-{d}'
				// ),
				endTime: parseTime(new Date(), '{y}-{m}-{d}'),
				pageNum: 1,
				pageSize: 50
			},
			loading: '',
			columns: [
				{ key: 0, label: `车号`, visible: true },
				{ key: 1, label: `收款人姓名`, visible: true },
				{ key: 2, label: `收款银行卡号`, visible: true },
				{ key: 3, label: `收款司机`, visible: true },
				{ key: 4, label: `上日欠运费`, visible: true },
				{ key: 5, label: `当日应付运费`, visible: true },
				{ key: 6, label: `本日付款金额`, visible: true },
				{ key: 7, label: `本日欠款余额`, visible: true },
				{ key: 8, label: `上月结转欠款金额`, visible: true },
				{ key: 9, label: `本月付款金额合计`, visible: true },
				{ key: 10, label: `本月累计应付运费`, visible: true },
				{ key: 11, label: `本月欠款金额`, visible: true },
				{ key: 12, label: `上年结转欠款金额`, visible: true },
				{ key: 13, label: `本年付款金额合计`, visible: true },
				{ key: 14, label: `本年累计应付运费`, visible: true },
				{ key: 15, label: `本年欠款金额`, visible: true }
			],
			statementList: [],
			dialogVisible: false
		};
	},
	created() {
		getOrderFreight(this.queryParams).then(res => {
			this.statementList = res.rows;
			this.total = res.total;
		});
	},
	methods: {
		fix_2,
		// 格式化数字值：0显示0，空值显示为空
		formatNumberValue(value) {
			if (value === null || value === undefined || value === '') return '';
			const num = Number(value);
			return isNaN(num) ? '' : fix_2(num);
		},
		// 格式化文本值：空值显示为空
		formatTextValue(value) {
			return value === null || value === undefined || value === '' ? '' : value;
		},
		// 计算欠款余额：如果所有参与计算的值为空则返回空，否则计算
		calculateBalance(previous, total, paid) {
			const prev = previous === null || previous === undefined || previous === '' ? null : Number(previous);
			const tot = total === null || total === undefined || total === '' ? null : Number(total);
			const pay = paid === null || paid === undefined || paid === '' ? null : Number(paid);
			if (prev === null && tot === null && pay === null) return '';
			return fix_2((prev === null ? 0 : prev) + (tot === null ? 0 : tot) - (pay === null ? 0 : pay));
		},
		// 时间查询
		handleQuery() {
			getOrderFreight(this.queryParams).then(res => {
				this.statementList = res.rows;
				this.total = res.total;
			});
		},
		refresh() {
			this.handleQuery();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/orderfreightsummary',
				{
					// beginTime: this.queryParams.beginTime,
					endTime: this.queryParams.endTime
				},
				`运费报表${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		handleExport() {
			this.dialogVisible = true;
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
					<el-form-item>
						<el-date-picker v-model="queryParams.endTime" type="date" size="mini" value-format="yyyy-MM-dd" placeholder="选择日期" />
					</el-form-item>
					<el-form-item>
						<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					</el-form-item>
				</el-form>
			</el-row>
			<hr color="#e6e6e6" />
			<el-row>
				<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">运费报表</el-row>
				<el-row>
					<right-toolbar :columns="columns">
						<template #print>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
							</el-col>
						</template>
						<template #export>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:supplier:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport" />
							</el-col>
						</template>
					</right-toolbar>
					<el-table
						id="printBox"
						v-loading="loading"
						v-horizontal-scroll="'always'"
						border
						:data="statementList"
						height="450px"
						size="mini"
						:cell-style="
							() => {
								return { padding: '2px' };
							}
						"
					>
						<el-table-column label="序号" align="center" type="index" width="50" show-overflow-tooltip />
						<el-table-column show-overflow-tooltip label="时间" align="center" width="140">
							<template slot-scope="">
								{{ queryParams.endTime }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[1].visible" label="收款人姓名" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatTextValue(scope.row.otherAcountsName) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[2].visible" label="收款银行卡号" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatTextValue(scope.row.otherBankNo) }}
							</template>
						</el-table-column>

						<el-table-column v-if="columns[3].visible" label="收款司机" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatTextValue(scope.row.driverName) }}
							</template>
						</el-table-column>

						<el-table-column v-if="columns[4].visible" label="上日欠运费" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.previousDayUnpaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[5].visible" label="当日应付运费" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.dailyTotalAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[6].visible" label="本日付款金额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.dailyPaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[7].visible" label="本日欠款余额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ calculateBalance(scope.row.previousDayUnpaidAmount, scope.row.dailyTotalAmount, -scope.row.dailyPaidAmount) }}
							</template>
						</el-table-column>

						<el-table-column v-if="columns[8].visible" label="上月结转欠款金额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.previousMonthUnpaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[9].visible" label="本月付款金额合计" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.monthlyPaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[10].visible" label="本月累计应付运费" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.monthlyTotalAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[11].visible" label="本月欠款金额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ calculateBalance(scope.row.previousMonthUnpaidAmount, scope.row.monthlyTotalAmount, -scope.row.monthlyPaidAmount) }}
							</template>
						</el-table-column>

						<el-table-column v-if="columns[12].visible" label="上年结转欠款金额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.previousYearUnpaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[13].visible" label="本年付款金额合计" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.yearlyPaidAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[14].visible" label="本年累计应付运费" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ formatNumberValue(scope.row.yearlyTotalAmount) }}
							</template>
						</el-table-column>
						<el-table-column v-if="columns[15].visible" label="本年欠款金额" align="center" width="200" show-overflow-tooltip>
							<template slot-scope="scope">
								{{ calculateBalance(scope.row.previousYearUnpaidAmount, scope.row.yearlyTotalAmount, -scope.row.yearlyPaidAmount) }}
							</template>
						</el-table-column>
					</el-table>
					<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="handleQuery" />
				</el-row>
			</el-row>
		</div>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="请选择导出时间" :visible.sync="dialogVisible" width="30%">
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
				<el-form-item label="时间" prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" />
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
