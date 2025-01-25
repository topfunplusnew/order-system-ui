<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh"
				>刷新</el-button
			>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form
			ref="queryForm"
			:model="queryParams"
			size="mini"
			inline="true"
			label-width="68px"
		>
			<el-form-item label="日期" prop="date">
				<el-date-picker
					v-model="queryParams.date"
					type="date"
					placeholder="请选择日期"
					value-format="yyyy-MM-dd"
				></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
					>搜索</el-button
				>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px"
			>运费当日发生业务统计表</el-row
		>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						></el-button>
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
			/>
			<el-table-column
				v-if="columns[1].visible"
				show-overflow-tooltip
				label="日期"
				align="center"
				prop="date"
			/>
			<el-table-column
				v-if="columns[2].visible"
				show-overflow-tooltip
				label="车牌号"
				align="center"
				prop="licensePlate"
			/>
			<el-table-column
				v-if="columns[3].visible"
				show-overflow-tooltip
				label="司机"
				align="center"
				prop="driver"
			/>
			<el-table-column
				v-if="columns[4].visible"
				show-overflow-tooltip
				label="车队"
				align="center"
				prop="fleet"
			/>
			<el-table-column
				v-if="columns[5].visible"
				show-overflow-tooltip
				label="上日应付运费"
				align="center"
				prop="previousDayFreight"
			/>
			<el-table-column
				v-if="columns[6].visible"
				show-overflow-tooltip
				label="当日应付运费"
				align="center"
				prop="dailyFreight"
			/>
			<el-table-column
				v-if="columns[7].visible"
				show-overflow-tooltip
				label="本日付费金额"
				align="center"
				prop="dailyPayment"
			/>
			<el-table-column
				v-if="columns[8].visible"
				show-overflow-tooltip
				label="本日欠运费余额"
				align="center"
				prop="dailyDebt"
			>
				<template slot-scope="scope">
					{{
						Number(scope.row.previousDayFreight) +
						Number(scope.row.dailyFreight) -
						Number(scope.row.dailyPayment)
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
				<el-form-item label="日期" prop="date">
					<el-date-picker
						v-model="queryParams.date"
						type="date"
						placeholder="选择日期"
						value-format="yyyy-MM-dd"
						size="mini"
					></el-date-picker>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { parseTime } from '../../../utils/ruoyi';
import { fix } from '../../../api/tool/format';
export default {
	name: 'SystemFreightChangeSummary',
	data() {
		return {
			loading: true,
			total: 0,
			tableData: [],
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				date: parseTime(new Date(), '{y}-{m}-{d}')
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '车牌号', visible: true },
				{ key: 3, label: '司机', visible: true },
				{ key: 4, label: '车队', visible: true },
				{ key: 5, label: '上日应付运费', visible: true },
				{ key: 6, label: '当日应付运费', visible: true },
				{ key: 7, label: '本日付费金额', visible: true },
				{ key: 8, label: '本日欠运费余额', visible: true }
			],
			dialogVisible: false
		};
	},
	created() {
		this.getList();
	},
	methods: {
		fix,
		getList() {
			this.loading = true;
			// 模拟数据
			this.tableData = [
				{
					index: 1,
					date: '2023-10-01',
					licensePlate: '粤A12345',
					driver: '司机A',
					fleet: '车队A',
					previousDayFreight: 1000,
					dailyFreight: 500,
					dailyPayment: 300,
					dailyDebt: 1200
				},
				{
					index: 2,
					date: '2023-10-01',
					licensePlate: '粤B67890',
					driver: '司机B',
					fleet: '车队B',
					previousDayFreight: 2000,
					dailyFreight: 1000,
					dailyPayment: 600,
					dailyDebt: 2400
				}
			];
			this.total = this.tableData.length;
			this.loading = false;
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		refresh() {
			this.getList();
		},
		handleSubmitTime() {
			// 模拟导出逻辑
			console.log('导出数据', this.queryParams);
			this.dialogVisible = false;
		},
		handleExport() {
			this.dialogVisible = true;
		}
	}
};
</script>

<style></style>
