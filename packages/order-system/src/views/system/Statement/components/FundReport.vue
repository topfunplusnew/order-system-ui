<!-- 用户需求：收款报表和付款报表的单日期搜索改为日期范围，并以 yyyy-MM-dd 格式通过 startDate、endDate 传给后端。实际改动：使用 daterange 控件维护起止日期，默认查询当天范围，并同步用于列表查询、重置和导出。 -->
<template>
	<div class="app-container fund-report">
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="90px" class="fund-report__search">
			<el-form-item label="日期范围" required>
				<el-date-picker v-model="dateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" clearable @change="handleDateRangeChange" />
			</el-form-item>
			<el-form-item label="我方户名" prop="selfAccountName">
				<el-input v-model.trim="queryParams.selfAccountName" placeholder="请输入我方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方公司" prop="otherCompanyName">
				<el-input v-model.trim="queryParams.otherCompanyName" placeholder="请输入对方公司" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="对方户名" prop="otherAccountName">
				<el-input v-model.trim="queryParams.otherAccountName" placeholder="请输入对方户名" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8 fund-report__toolbar">
			<right-toolbar :columns="columns" @queryTable="getList" :table-name="reportConfig.tableName">
				<template #left>
					<h3>{{ reportConfig.title }}</h3>
				</template>
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-download" size="mini" @click="handleExport" />
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table id="printBox" v-loading="loading" v-horizontal-scroll="'always'" :data="reportList" border stripe size="mini" class="fund-report__table">
			<el-table-column v-if="columns[0].visible" label="序号" align="center" width="70" fixed="left">
				<template slot-scope="scope">
					{{ scope.$index + 1 + (queryParams.pageNum - 1) * queryParams.pageSize }}
				</template>
			</el-table-column>
			<el-table-column v-for="(column, index) in reportColumns" v-if="columns[index + 1].visible" :key="column.prop" :label="column.prop === 'businessType' ? reportConfig.businessTypeLabel : column.label" :prop="column.prop" :width="column.width" align="center" show-overflow-tooltip>
				<template slot-scope="scope">
					<span v-if="column.amount">{{ formatAmount(scope.row[column.prop]) }}</span>
					<span v-else>{{ scope.row[column.prop] }}</span>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { parseTime } from '@/utils/ruoyi';
import { applyFundReportDateRange, createFundReportQuery, FUND_REPORT_COLUMNS, FUND_REPORT_CONFIG, hasRequiredReportDateRange } from '../fundReportConfig';

export default {
	name: 'FundReport',
	mixins: [mixin_printHTML],
	props: {
		reportType: {
			type: String,
			required: true,
			validator: value => Boolean(FUND_REPORT_CONFIG[value])
		}
	},
	data() {
		const today = parseTime(new Date(), '{y}-{m}-{d}');
		const queryParams = createFundReportQuery(today);
		return {
			loading: false,
			total: 0,
			reportList: [],
			dateRange: [today, today],
			queryParams,
			columns: [{ key: 0, label: '序号', visible: true }].concat(FUND_REPORT_COLUMNS.map((column, index) => ({ key: index + 1, label: column.label || '业务类型', visible: true })))
		};
	},
	computed: {
		reportConfig() {
			return FUND_REPORT_CONFIG[this.reportType];
		},
		reportColumns() {
			return FUND_REPORT_COLUMNS;
		}
	},
	created() {
		this.getList();
	},
	methods: {
		validateDate() {
			if (hasRequiredReportDateRange(this.queryParams)) return true;
			this.$message.warning('请选择完整的日期范围');
			return false;
		},
		handleDateRangeChange(value) {
			applyFundReportDateRange(this.queryParams, value);
		},
		getList() {
			if (!this.validateDate()) return;
			this.loading = true;
			this.reportConfig
				.listApi(this.queryParams)
				.then(response => {
					this.reportList = response.rows || [];
					this.total = response.total || 0;
				})
				.finally(() => {
					this.loading = false;
				});
		},
		handleQuery() {
			if (!this.validateDate()) return;
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			const today = parseTime(new Date(), '{y}-{m}-{d}');
			this.dateRange = [today, today];
			this.queryParams = createFundReportQuery(today);
			this.getList();
		},
		handleExport() {
			if (!this.validateDate()) return;
			this.download(this.reportConfig.exportPath, { ...this.queryParams }, `${this.reportConfig.exportFileName}_${parseTime(new Date(), '{y}{m}{d}{h}{i}{s}')}.xlsx`);
		},
		formatAmount(value) {
			const amount = Number(value);
			return Number.isFinite(amount) ? amount.toFixed(2) : '0.00';
		}
	}
};
</script>

<style scoped lang="scss">
.fund-report__search {
	padding-bottom: 4px;
}

.fund-report__search ::v-deep .el-form-item {
	margin-bottom: 10px;
}

.fund-report__search ::v-deep .el-input,
.fund-report__search ::v-deep .el-date-editor {
	width: 190px;
}

.fund-report__search ::v-deep .el-date-editor--daterange {
	width: 260px;
}

.fund-report__toolbar {
	margin-right: 0 !important;
	margin-left: 0 !important;
}

.fund-report__toolbar ::v-deep .toolbar-container {
	box-sizing: border-box;
	min-height: 54px;
	padding: 8px 12px;
}

.fund-report__toolbar ::v-deep h3 {
	margin: 0;
	font-size: 16px;
	line-height: 28px;
}

.fund-report__table {
	width: 100%;
}
</style>
