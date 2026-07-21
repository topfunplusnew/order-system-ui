<!-- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。 -->
<script>
/**
 * 票点变动详情模板
 * invoicein/invoiceout/invoiceother 表：customer、Supplier、invoiceAmount、customerPointAmount、supplierPointAmount 等
 * 范式：记录(x) 合并 3 行，排除 customerDiff、supplierDiff，diff-summary-table 展示 2 行
 */
import _ from 'lodash';
import { TICKET_POINT_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildTicketPointDiffFields, mapTicketPointRecordToRow, resolveTicketPointSummaryLabel, sumTicketPointIncomeDiffRows } from '@/utils/fundChange/ticketPoint';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'TicketPointTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '票点' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		resolvedSummaryModuleLabel() {
			return resolveTicketPointSummaryLabel(this.moduleName, this.summaryModuleLabel);
		},
		columns() {
			const excludeProps = ['customerDiff', 'supplierDiff'];
			return TICKET_POINT_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.resolvedSummaryModuleLabel;
			return buildBackendSummaryRows(this.summaryData, this.moduleName, prefix, ['companyTotalBalance', 'supplierTotalBalance']);
		}
	},
	created() {
		this.processData();
	},
	watch: {
		compareData: {
			handler() {
				this.processData();
			},
			deep: true
		},
		targetDate() {
			this.processData();
		}
	},
	methods: {
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const tname = record.tableName || this.moduleName;
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const rows = buildDateScopedRecordRows({
					original,
					changed,
					targetDate: this.targetDate,
					backupType: record.backupType,
					dateFields: getFundChangeTemplateDateFields(this.$options.name),
					beforeRow: { ...this.mapBeforeRow(original, record, index, tname), recordIndex: index + 1, backupTime },
					afterRow: { ...this.mapAfterRow(changed, record, index, tname), recordIndex: index + 1, backupTime },
					buildDiffFields: (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged, record, tname)
				});
				this.tableData.push(...rows);
			});
		},
		mapBeforeRow(info, _record, _index, _tableName) {
			return mapTicketPointRecordToRow(info);
		},
		mapAfterRow(info, record, index, tableName) {
			return this.mapBeforeRow(info, record, index, tableName);
		},
		buildDiffFields(original, changed, record, tableName) {
			return buildTicketPointDiffFields(original, changed, tableName || record.tableName || this.moduleName);
		},
		tableRowClassName({ row }) {
			if (row.rowType === 'before') return 'before-row';
			if (row.rowType === 'after') return 'after-row';
			if (row.rowType === 'diff') return 'diff-row';
			return '';
		},
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		},
		recordSpanMethod({ row, columnIndex }) {
			if (columnIndex !== 0) return [1, 1];
			if (row.isRecordFirst) return [row.recordRowCount || 3, 1];
			return [0, 0];
		},
		getTableSummary(param) {
			const { columns } = param;
			const incomePointAmountSum = sumTicketPointIncomeDiffRows(this.diffRows);
			return columns.map((col, index) => {
				if (index === 0 || index === 1) return '';
				if (col.property === 'incomePointAmount') return incomePointAmountSum;
				return '';
			});
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<FundChangeExportButton :columns="columns" :rows="tableData" :summary-rows="diffSummaryTableData" :module-label="summaryModuleLabel" :summary-only="summaryOnly" />
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column :label="resolvedSummaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isRecordFirst">
						<div>{{ resolvedSummaryModuleLabel }}（{{ scope.row.recordIndex }}）</div>
						<div v-if="scope.row.backupTime" class="backup-time">{{ scope.row.backupTime }}</div>
					</template>
				</template>
			</el-table-column>
			<el-table-column label="变更" width="80" fixed>
				<template slot-scope="scope">{{ scope.row.subLabel }}</template>
			</el-table-column>
			<el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" />
		</el-table>
		<el-table v-if="diffRows.length" :data="diffSummaryTableData" border class="diff-summary-table" :show-header="false" :class="{ 'summary-only': summaryOnly }">
			<el-table-column prop="label" width="280">
				<template slot-scope="scope">
					<span class="diff-summary-label">{{ scope.row.label }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="value" width="120" align="right">
				<template slot-scope="scope">
					<span class="diff-summary-value">{{ scope.row.value }}</span>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss">
.fund-change-template {
	padding: 20px;
}
::v-deep .record-col {
	vertical-align: middle;
	text-align: center;
}
.backup-time {
	margin-top: 4px;
	font-size: 12px;
	color: #909399;
}
::v-deep .before-row {
	background-color: #f0f9ff;
}
::v-deep .after-row td {
	background-color: #fff3ca !important;
}
::v-deep .diff-row {
	background-color: #fff1f0;
	font-weight: bold;
}
::v-deep .el-table__footer td {
	background-color: #fff8e6 !important;
	font-weight: bold;
}
::v-deep .el-table__footer tr td {
	padding: 8px 10px;
	line-height: 1.5;
	vertical-align: middle;
	height: 38px !important;
}
.diff-summary-table.summary-only {
	margin-top: 0;
}
.diff-summary-table {
	margin-top: 16px;
	width: auto !important;
	.diff-summary-label {
		text-align: left;
	}
	.diff-summary-value {
		text-align: right;
	}
	::v-deep .el-table__body td {
		background: #fff !important;
		padding: 8px 12px;
	}
}
</style>
