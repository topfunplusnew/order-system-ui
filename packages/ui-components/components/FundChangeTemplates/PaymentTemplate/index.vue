<script>
/**
 * 付款变动详情模板
 * payment 表：moneyAmount、companyType、landFreight 等
 * 范式：记录(x) 合并 3 行，排除 amountDiff，buildDiffFields 填 amount，diff-summary-table 展示
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { PAYMENT_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedRecordRows } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

export default {
	name: 'PaymentTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '付款' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['amountDiff'];
			return PAYMENT_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '付款';
			return buildBackendSummaryRows(this.summaryData, 'payment', prefix);
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
		pickFirstValue(info, keys = [], defaultValue = '') {
			for (const key of keys) {
				const value = info?.[key];
				if (value !== undefined && value !== null && value !== '') {
					return value;
				}
			}
			return defaultValue;
		},
		formatDateTime(value) {
			return value ? String(value).slice(0, 19) : '-';
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
					beforeRow: { ...this.mapBeforeRow(original, record, index), recordIndex: index + 1, backupTime },
					afterRow: { ...this.mapAfterRow(changed, record, index), recordIndex: index + 1, backupTime },
					buildDiffFields: (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged, record)
				});
				this.tableData.push(...rows);
			});
		},
		mapBeforeRow(info) {
			const dt = this.pickFirstValue(info, ['fundsDate', 'payTime', 'changedTargetTime', 'addtime']);
			return {
				status: this.pickFirstValue(info, ['paymentState'], '已付款'),
				paymentDate: this.formatDateTime(dt),
				paymentType: info.payType || '-',
				companyName: info.companyName || '-',
				companyType: info.companyType || '',
				amount: info.moneyAmount,
				selfAccountName: this.pickFirstValue(info, ['selfAccountsName', 'selfAcountsName', 'selfAccountName', 'bankName'], ''),
				selfAccountNo: this.pickFirstValue(info, ['selfBankNo', 'bankNo'], ''),
				selfBankName: this.pickFirstValue(info, ['selfBankName', 'bankFullName'], ''),
				otherAccountName: this.pickFirstValue(info, ['otherAccountsName', 'otherAcountsName', 'otherAccountName'], ''),
				otherAccountNo: this.pickFirstValue(info, ['otherBankNo', 'otherAccountNo'], ''),
				otherBankName: this.pickFirstValue(info, ['otherBankName'], ''),
				remark: this.pickFirstValue(info, ['comments', 'remark'], '')
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			// 付款：修改后 - 修改前（金额增加为正）
			const amountDiff = this.calculateFieldDiff(original.moneyAmount, changed.moneyAmount);
			return { amount: amountDiff };
		},
		calculateFieldDiff(afterVal, beforeVal) {
			const after = Number(afterVal || 0);
			const before = Number(beforeVal || 0);
			return format(subtract(after, before), { notation: 'fixed', precision: 2 });
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
			const sums = [];
			const diffRows = this.diffRows;
			const amountSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.amount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'amount') sums.push(amountSum);
				else sums.push('');
			});
			return sums;
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
