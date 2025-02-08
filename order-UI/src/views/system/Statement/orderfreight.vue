<!-- 运费报表-->
<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getOrderFreight } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';

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
				<el-button type="primary" icon="el-icon-refresh" @click="refresh">
					刷新
				</el-button>
			</el-row>
			<hr color="#e6e6e6" />
			<!--    时间范围搜索行-->
			<el-row>
				<el-form
					ref="queryForm"
					:model="queryParams"
					size="mini"
					:inline="true"
					label-width="100px"
				>
					<!-- <el-form-item label="时间" prop="companyName">
						<el-date-picker
							v-model="queryParams.beginTime"
							type="date"
							size="mini"
							value-format="yyyy-MM-dd"
							placeholder="选择日期"
						/>
					</el-form-item> -->
					<el-form-item>
						<el-date-picker
							v-model="queryParams.endTime"
							type="date"
							size="mini"
							value-format="yyyy-MM-dd"
							placeholder="选择日期"
						/>
					</el-form-item>
					<el-form-item>
						<el-button
							type="primary"
							icon="el-icon-search"
							size="mini"
							@click="handleQuery"
						>
							搜索
						</el-button>
					</el-form-item>
				</el-form>
			</el-row>
			<hr color="#e6e6e6" />
			<el-row>
				<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">
					运费报表
				</el-row>
				<el-row>
					<right-toolbar :columns="columns">
						<template #print>
							<el-col :span="1.5">
								<el-button
									plain
									icon="el-icon-printer"
									size="mini"
									@click="printHTML"
								/>
							</el-col>
						</template>
						<template #export>
							<el-col :span="1.5">
								<el-button
									v-hasPermi="['system:supplier:export']"
									plain
									icon="el-icon-folder-opened"
									size="mini"
									@click="handleExport"
								/>
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
						<el-table-column
							label="序号"
							align="center"
							type="index"
							width="50"
						/>
						<!-- todo 缺少字段 -->
						<!-- <el-table-column
							v-if="columns[0].visible"
							label="卸货客户"
							align="center"
							prop="carNo"
							width="200"
						/> -->
						<el-table-column
							show-overflow-tooltip
							label="时间"
							align="center"
							width="140"
						>
							<template slot-scope="">
								{{ queryParams.endTime }}
							</template>
						</el-table-column>
						<el-table-column
							v-if="columns[0].visible"
							label="车号"
							align="center"
							prop="carNo"
							width="200"
						/>
						<el-table-column
							v-if="columns[1].visible"
							label="收款人姓名"
							align="center"
							prop="otherAcountsName"
							width="200"
						/>
						<el-table-column
							v-if="columns[2].visible"
							label="收款银行卡号"
							align="center"
							prop="otherBankNo"
							width="200"
						/>
						<el-table-column
							v-if="columns[3].visible"
							label="收款司机"
							align="driverName"
							prop="driverName"
							width="200"
						/>

						<el-table-column
							v-if="columns[3].visible"
							label="上日欠运费"
							align="center"
							prop="previousDayUnpaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[4].visible"
							label="当日应付运费"
							align="center"
							prop="dailyTotalAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[5].visible"
							label="本日付款金额"
							align="center"
							prop="dailyPaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[6].visible"
							label="本日欠款余额"
							align="center"
							prop="dailyUnpaidAmount"
							width="200"
						/>

						<el-table-column
							v-if="columns[7].visible"
							label="上月结转欠款金额"
							align="center"
							prop="previousMonthUnpaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[8].visible"
							label="本月付款金额合计"
							align="center"
							prop="monthlyPaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[9].visible"
							label="本月累计应付运费"
							align="center"
							prop="monthlyTotalAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[10].visible"
							label="本月欠款金额"
							align="center"
							prop="monthlyUnpaidAmount"
							width="200"
						/>

						<el-table-column
							v-if="columns[11].visible"
							label="上年结转欠款金额"
							align="center"
							prop="previousYearUnpaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[12].visible"
							label="本年付款金额合计"
							align="center"
							prop="monthlyUnpaidAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[13].visible"
							label="本年累计应付运费"
							align="center"
							prop="yearlyTotalAmount"
							width="200"
						/>
						<el-table-column
							v-if="columns[14].visible"
							label="本年欠款金额"
							align="center"
							prop="yearlyUnpaidAmount"
							width="200"
						/>
					</el-table>
					<pagination
						v-show="total > 0"
						:total="total"
						:page.sync="queryParams.pageNum"
						:limit.sync="queryParams.pageSize"
						@pagination="handleQuery"
					/>
				</el-row>
			</el-row>
		</div>
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="请选择导出时间"
			:visible.sync="dialogVisible"
			width="30%"
		>
			<el-form
				ref="queryForm"
				:model="queryParams"
				size="mini"
				label-width="68px"
			>
				<!-- <el-form-item label="开始时间" prop="beginTime">
					<el-date-picker
						v-model="queryParams.beginTime"
						type="date"
						placeholder="选择时间"
						value-format="yyyy-MM-dd"
						size="mini"
					/>
				</el-form-item> -->
				<el-form-item label="时间" prop="endTime">
					<el-date-picker
						v-model="queryParams.endTime"
						type="date"
						placeholder="选择时间"
						value-format="yyyy-MM-dd"
						size="mini"
					/>
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
