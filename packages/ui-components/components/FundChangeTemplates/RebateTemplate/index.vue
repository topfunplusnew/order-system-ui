<script>
/**
 * 返利变动详情模板
 * rebate 表：rebate、supplier、rebateDate、detailList[].actualReceived 等
 * 范式：记录(x) 合并 3 行，差额行展示返利金额变化，底部小表使用后端 supplierTotalBalance/rebate 汇总。
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { REBATE_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

export default {
	name: 'RebateTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '返利' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['supplierDiff'];
			return REBATE_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '返利';
			return buildBackendSummaryRows(this.summaryData, 'rebate', prefix, ['supplierTotalBalance']);
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
		formatDate(value) {
			return value ? String(value).slice(0, 10) : '';
		},
		formatAmount(value) {
			return format(Number(value || 0), { notation: 'fixed', precision: 2 });
		},
		formatRebateMethod(value) {
			if (value === 2 || value === '2' || value === '面积') return '面积';
			if (value === 1 || value === '1' || value === '重箱') return '重箱';
			return value || '';
		},
		getDetailList(info = {}) {
			return info.detailList || info.rebateDetailList || [];
		},
		sumReceivedAmount(info = {}) {
			return _.reduce(this.getDetailList(info), (acc, item) => add(acc, Number(item.actualReceived ?? item.moneyAmount ?? 0) || 0), 0);
		},
		getEarliestReceivedDate(info = {}) {
			const dates = this.getDetailList(info)
				.map(item => item.actualReceivedDate || item.receivedDate || item.rebateDate)
				.filter(Boolean)
				.sort();
			return dates[0] ? this.formatDate(dates[0]) : '未收到';
		},
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const rows = buildDateScopedRecordRows({
					original,
					changed,
					targetDate: this.targetDate,
					backupType: record.backupType,
					dateFields: getFundChangeTemplateDateFields(this.$options.name),
					beforeRow: { ...this.mapBeforeRow(original), recordIndex: index + 1, backupTime },
					afterRow: { ...this.mapAfterRow(changed), recordIndex: index + 1, backupTime },
					buildDiffFields: (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged)
				});
				this.tableData.push(...rows);
			});
		},
		mapBeforeRow(info) {
			const receivedAmount = this.sumReceivedAmount(info);
			return {
				rebateDate: this.formatDate(info.rebateDate),
				rebateType: info.rebateType || '',
				supplierName: info.supplier || info.supplierName || info.companyName || '',
				rebateMethod: this.formatRebateMethod(info.rebateMethod),
				unitPrice: info.unitPrice,
				rebateAmount: info.rebate,
				rebateReason: info.rebateReason || '',
				receivedDate: this.getEarliestReceivedDate(info),
				receivedAmount: receivedAmount ? this.formatAmount(receivedAmount) : '未收到',
				remark: info.comments || info.remark || ''
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed) {
			const supplierDiff = format(subtract(Number(changed.rebate || 0), Number(original.rebate || 0)), { notation: 'fixed', precision: 2 });
			return {
				rebateAmount: supplierDiff,
				supplierDiff
			};
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
			const amountSum = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.rebateAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			return columns.map((col, index) => {
				if (index === 0 || index === 1) return '';
				if (col.property === 'rebateAmount') return amountSum;
				return '';
			});
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column :label="summaryModuleLabel" width="100" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isRecordFirst">
						<div>{{ summaryModuleLabel }}（{{ scope.row.recordIndex }}）</div>
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
