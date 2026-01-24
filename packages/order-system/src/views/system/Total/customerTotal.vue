<!--向外借钱-->
<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="日期范围" prop="dateRange">
				<el-date-picker v-model="dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" style="width: 240px" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">客户统计</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:company:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="totalList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" label="日期" align="center" prop="time" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="客户名称" align="center" prop="companyName" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="发货车数" align="center" prop="uniqueOrderCount" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="不含税利润" align="center" prop="totalProfit" show-overflow-tooltip />
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="请选择导出时间段" :visible.sync="dialogVisible" width="350px">
			<el-row>
				<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
					<el-form-item label="开始时间" prop="beginTime">
						<el-date-picker v-model="queryParams.beginTime" type="datetime" placeholder="选择时间" value-format="yyyy-MM-dd HH:mm:ss" size="mini"></el-date-picker>
					</el-form-item>
					<el-form-item label="结束时间" prop="endTime">
						<el-date-picker v-model="queryParams.endTime" type="datetime" placeholder="选择时间" value-format="yyyy-MM-dd HH:mm:ss" size="mini"></el-date-picker>
					</el-form-item>
				</el-form>
			</el-row>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { parseTime } from '../../../utils/ruoyi';
import { getCustomerTotal } from '../../../api/system/total';

export default {
	name: 'CustomerTotal',
	mixins: [mixin_printHTML],
	data() {
		const lastYearDate = this.getlastYearDate();
		const defaultStartDate = parseTime(lastYearDate, '{y}-{m}-{d}');
		const defaultEndDate = parseTime(new Date(), '{y}-{m}-{d}');
		return {
			// 遮罩层
			loading: true,
			total: 0,
			totalList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 日期范围
			dateRange: [defaultStartDate, defaultEndDate],
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				beginTime: null,
				endTime: null
			},
			// 表单校验
			columns: [
				{ key: 0, label: '日期', visible: true },
				{ key: 1, label: '客户名称', visible: true },
				{ key: 2, label: '发货车数', visible: true },
				{ key: 3, label: '不含税利润', visible: true }
			],
			dialogVisible: false
		};
	},
	created() {
		// 初始化时格式化日期范围并设置查询参数
		this.formatDateRange();
		if (this.dateRange && this.dateRange.length === 2) {
			this.queryParams.beginTime = this.dateRange[0];
			this.queryParams.endTime = this.dateRange[1];
		}
		this.getList();
	},
	methods: {
		getlastYearDate() {
			const currentDate = new Date();
			const lastYearDate = new Date(currentDate);
			lastYearDate.setFullYear(currentDate.getFullYear() - 1);
			return lastYearDate;
		},
		// 格式化日期范围
		formatDateRange() {
			if (this.dateRange && this.dateRange.length === 2) {
				// 开始时间：如果只有日期没有时间，添加 00:00:00
				if (String(this.dateRange[0]).length === 10) {
					this.dateRange[0] += ' 00:00:00';
				}
				// 结束时间：如果只有日期没有时间，添加 23:59:59
				if (String(this.dateRange[1]).length === 10) {
					this.dateRange[1] += ' 23:59:59';
				}
			}
		},
		/** 查询向外部借出款信息列表 */
		getList() {
			this.loading = true;
			// 通过 dateRange 给 beginTime 和 endTime 赋值
			if (this.dateRange && this.dateRange.length === 2) {
				this.queryParams.beginTime = this.dateRange[0];
				this.queryParams.endTime = this.dateRange[1];
			} else {
				this.queryParams.beginTime = null;
				this.queryParams.endTime = null;
			}
			getCustomerTotal(this.queryParams).then(response => {
				this.totalList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		/** 搜索按钮操作 */
		handleQuery() {
			// 格式化时间范围
			this.formatDateRange();
			this.queryParams.pageNum = 1;
			this.getList();
		},
		refresh() {
			this.getList();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/customerSummary',
				{
					startTime: this.queryParams.beginTime,
					endTime: this.queryParams.endTime
				},
				`客户统计${new Date().getTime()}.xlsx`
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
