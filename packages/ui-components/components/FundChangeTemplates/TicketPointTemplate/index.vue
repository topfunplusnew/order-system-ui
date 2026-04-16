<script>
/**
 * 票点变动详情模板
 * invoicein/invoiceout/invoiceother 表：customer、Supplier、invoiceAmount、customerPointAmount、supplierPointAmount 等
 * 范式：记录(x) 合并 3 行，排除 customerDiff、supplierDiff，diff-summary-table 展示 2 行
 */
import { format, add } from 'mathjs';
import _ from 'lodash';
import { TICKET_POINT_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildTicketPointDiffFields, mapTicketPointRecordToRow, resolveTicketPointSummaryLabel } from '@/utils/fundChange/ticketPoint';

export default {
	name: 'TicketPointTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '票点' },
		summaryOnly: { type: Boolean, default: false }
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
			const customerDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.customerDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const supplierDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.supplierDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			return [
				{ label: `${prefix}客户变动差额`, value: customerDiff },
				{ label: `${prefix}供应商变动差额`, value: supplierDiff }
			];
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
		}
	},
	methods: {
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const tname = record.tableName || this.moduleName;
				const beforeRow = { ...this.mapBeforeRow(original, record, index, tname), rowType: 'before', isRecordFirst: true, recordIndex: index + 1, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index, tname), rowType: 'after', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', subLabel: '差额', ...this.buildDiffFields(original, changed, record, tname) };
				this.tableData.push(beforeRow, afterRow, diffRow);
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
			if (row.isRecordFirst) return [3, 1];
			return [0, 0];
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" style="width: 100%">
			<el-table-column :label="resolvedSummaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<span v-if="scope.row.isRecordFirst">{{ resolvedSummaryModuleLabel }}（{{ scope.row.recordIndex }}）</span>
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
