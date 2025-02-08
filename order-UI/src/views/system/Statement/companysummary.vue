<!--向外借钱-->
<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh"
				>刷新
			</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="68px"
		>
			<!-- <el-form-item label="开始时间" prop="beginTime">
				<el-date-picker
					v-model="queryParams.beginTime"
					type="date"
					placeholder="请选择开始时间"
					value-format="yyyy-MM-dd"
				>
				</el-date-picker>
			</el-form-item> -->
			<el-form-item label="时间" prop="endTime">
				<el-date-picker
					v-model="queryParams.endTime"
					type="date"
					placeholder="请选择结束时间"
					value-format="yyyy-MM-dd"
				>
				</el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索
				</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">
			客户报表
		</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						>
						</el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:company:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						>
						</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="tableData"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column
				v-if="columns[0].visible"
				show-overflow-tooltip
				label="序号"
				align="center"
				prop="index"
				width="140"
			/>
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
				v-if="columns[1].visible"
				show-overflow-tooltip
				label="客户名称"
				align="center"
				prop="companyName"
				width="140"
			/>
			<el-table-column
				v-if="columns[2].visible"
				show-overflow-tooltip
				label="上日欠款结转"
				align="center"
				prop="previousDayCarryover"
				width="140"
			/>
			<el-table-column
				v-if="columns[3].visible"
				show-overflow-tooltip
				label="本日发货金额"
				align="center"
				prop="dailyOrderPayments"
				width="140"
			/>
			<el-table-column
				v-if="columns[4].visible"
				show-overflow-tooltip
				label="本日票点金额"
				align="center"
				prop="dailyInvoiceAmount"
				width="140"
			/>
			<el-table-column
				v-if="columns[5].visible"
				show-overflow-tooltip
				label="本日回款金额"
				align="center"
				prop="dailyReceiveMoney"
				width="140"
			/>
			<el-table-column
				v-if="columns[6].visible"
				show-overflow-tooltip
				label="本日欠款余额"
				align="center"
				prop="amountOwedToday"
				width="140"
			>
				<template slot-scope="scope">
					{{
						Number(scope.row.previousDayCarryover) +
						Number(scope.row.dailyOrderPayments) +
						Number(scope.row.dailyInvoiceAmount) -
						Number(scope.row.dailyReceiveMoney)
					}}
				</template>
			</el-table-column>
			<el-table-column
				v-if="columns[7].visible"
				show-overflow-tooltip
				label="本日客户利润"
				align="center"
				prop="dailyProfit"
				width="140"
			/>
			<el-table-column
				v-if="columns[8].visible"
				show-overflow-tooltip
				label="上月欠款金额结转"
				align="center"
				prop="previousMonthCarryover"
				width="140"
			/>
			<el-table-column
				v-if="columns[9].visible"
				show-overflow-tooltip
				label="本月发货金额合计"
				align="center"
				prop="monthlyOrderPayments"
				width="140"
			/>
			<el-table-column
				v-if="columns[10].visible"
				show-overflow-tooltip
				label="本月购入票点"
				align="center"
				prop="monthlyInvoiceAmount"
				width="140"
			/>
			<el-table-column
				v-if="columns[11].visible"
				show-overflow-tooltip
				label="本月回款金额"
				align="center"
				prop="monthlyReceiveMoney"
				width="140"
			/>
			<el-table-column
				v-if="columns[12].visible"
				show-overflow-tooltip
				label="本月欠款"
				align="center"
				prop="amountOwedThisMonth"
				width="140"
			>
				<template slot-scope="scope">
					{{
						fix(
							Number(scope.row.previousMonthCarryover) +
								Number(scope.row.monthlyOrderPayments) +
								Number(scope.row.monthlyInvoiceAmount) -
								Number(scope.row.monthlyReceiveMoney)
						)
					}}
				</template>
			</el-table-column>
			<el-table-column
				v-if="columns[13].visible"
				show-overflow-tooltip
				label="本月客户利润"
				align="center"
				prop="monthlyProfit"
				width="140"
			/>
			<el-table-column
				v-if="columns[14].visible"
				show-overflow-tooltip
				label="上年结转"
				align="center"
				prop="previousYearCarryover"
				width="140"
			/>
			<el-table-column
				v-if="columns[15].visible"
				show-overflow-tooltip
				label="本年发货金额"
				align="center"
				prop="yearlyOrderPayments"
				width="140"
			/>
			<el-table-column
				v-if="columns[16].visible"
				show-overflow-tooltip
				label="本年票点"
				align="center"
				prop="yearlyInvoiceAmount"
				width="140"
			/>
			<el-table-column
				v-if="columns[17].visible"
				show-overflow-tooltip
				label="本年回款金额"
				align="center"
				prop="yearlyReceiveMoney"
				width="140"
			/>
			<el-table-column
				v-if="columns[18].visible"
				show-overflow-tooltip
				label="本年利润"
				align="center"
				prop="yearlyProfit"
				width="140"
			/>
			<el-table-column
				v-if="columns[19].visible"
				show-overflow-tooltip
				label="欠款"
				align="center"
				prop="arrearsThisYear"
				width="140"
			>
				<template slot-scope="scope">
					{{
						fix(
							Number(scope.row.previousYearCarryover) +
								Number(scope.row.yearlyOrderPayments) +
								Number(scope.row.yearlyInvoiceAmount) -
								Number(scope.row.yearlyReceiveMoney)
						)
					}}
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>
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
					>
					</el-date-picker>
				</el-form-item> -->
				<el-form-item label="时间" prop="endTime">
					<el-date-picker
						v-model="queryParams.endTime"
						type="date"
						placeholder="时间"
						value-format="yyyy-MM-dd"
						size="mini"
					>
					</el-date-picker>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getCompanySummary } from '../../../api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from '../../../api/tool/format';
export default {
	name: 'Companysummary',
	dicts: ['order_target_type'],
	mixins: [mixin_printHTML],
	data() {
		return {
			// 遮罩层
			loading: true,
			total: 0,
			tableData: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				// beginTime: '',
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			// 表单校验
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '客户名称', visible: true },
				{ key: 2, label: '上日欠款结转', visible: true },
				{ key: 3, label: '本日发货金额', visible: true },
				{ key: 4, label: '本日票点金额', visible: true },
				{ key: 5, label: '本日回款金额', visible: true },
				{ key: 6, label: '本日欠款金额', visible: true },
				{ key: 7, label: '本日客户利润', visible: true },
				{ key: 8, label: '上月欠款金额结转', visible: true },
				{ key: 9, label: '本月发货金额合计', visible: true },
				{ key: 10, label: '本月购入票点', visible: true },
				{ key: 11, label: '本月回款金额', visible: true },
				{ key: 12, label: '本月欠款', visible: true },
				{ key: 13, label: '本月客户利润', visible: true },
				{ key: 14, label: '上年结转', visible: true },
				{ key: 15, label: '本年发货金额', visible: true },
				{ key: 16, label: '本年票点', visible: true },
				{ key: 17, label: '本年回款金额', visible: true },
				{ key: 18, label: '本年利润', visible: true },
				{ key: 19, label: '欠款', visible: true }
			],
			dialogVisible: false
		};
	},
	created() {
		this.getList();
	},
	methods: {
		fix,
		/** 查询向外部借出款信息列表 */
		getList() {
			this.loading = true;
			getCompanySummary(this.queryParams).then(response => {
				console.log(response);
				this.tableData = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		handleCheckCarNoFreight(row) {
			console.log(row);
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		refresh() {
			this.getList();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/companysummary',
				{
					...this.queryParams
				},
				`客户报表_${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		/** 导出按钮操作 */
		handleExport() {
			this.dialogVisible = true;
		}
	}
};
</script>
