<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form ref="queryForm" :model="queryParams" size="mini" inline="true" label-width="68px">
			<el-form-item label="日期" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="请选择日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">供应商当日发生业务统计表</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
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
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="序号" align="center" prop="index" />
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="日期" align="center" prop="date">
				<template slot-scope="">
					{{ this.queryParams.endTime }}
				</template>
			</el-table-column>
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="供应商名称" align="center" prop="companyName" />
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="昨日欠款金额" align="center" prop="previousDayCarryover" />
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="当日进货金额" align="center" prop="dailyOrderPayments" />
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="当日采购票点金额" align="center" prop="dailyInvoiceAmount" />
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="当日付款金额" align="center" prop="dailyReceiveMoney" />
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="当日欠款金额" align="center">
				<template slot-scope="scope">
					{{ fix(Number(scope.row.previousDayCarryover) + Number(scope.row.dailyOrderPayments) + Number(scope.row.dailyInvoiceAmount) - Number(scope.row.dailyReceiveMoney)) }}
				</template>
			</el-table-column>
		</el-table>
		<el-row style="font-weight: bold; font-size: 16px; margin: 10px 30px">数据量总数: {{ total }}</el-row>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="请选择导出时间" :visible.sync="dialogVisible" width="30%">
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
				<el-form-item label="日期" prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
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
import { getTodaySupplierSummary } from '../../../api/system/statement';
export default {
	name: 'SystemSupplierChangeSummary',
	data() {
		return {
			loading: true,
			total: 0,
			tableData: [],
			queryParams: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '供应商名称', visible: true },
				{ key: 3, label: '昨日欠款金额', visible: true },
				{ key: 4, label: '当日进货金额', visible: true },
				{ key: 5, label: '当日采购票点金额', visible: true },
				{ key: 6, label: '当日付款金额', visible: true },
				{ key: 7, label: '当日欠款金额', visible: true }
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
			getTodaySupplierSummary(this.queryParams).then(response => {
				this.tableData = response.rows;
				this.total = response.total;
				this.loading = false;
			});
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
			this.download(
				'statistics/export/todaysupplierSummary',
				{
					...this.queryParams
				},
				`供应商当日发生业务统计表_${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		handleExport() {
			this.dialogVisible = true;
		}
	}
};
</script>

<style></style>
