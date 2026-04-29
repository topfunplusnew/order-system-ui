<script>
/**
 * 厂家保证金变动详情模板
 * lendmoney 表 type=厂家保证金/押金：moneyAmount、recoverMoneyList[].moneyAmount
 * 范式：记录(x) 合并 3 行，排除 bankCardDiff、supplierDepositDiff，buildDiffFields 填 depositAmount，diff-summary-table 展示
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';

export default {
	name: 'SupplierDepositTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '厂家保证金' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			return [
				{ prop: 'depositDate', label: '保证金日期', width: 120, showSummary: false },
				{ prop: 'supplierName', label: '厂家名称', width: 120, showSummary: false },
				{ prop: 'depositAmount', label: '保证金金额', width: 120 },
				{ prop: 'bankCardNo', label: '银行卡号', width: 150, showSummary: false }
			];
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '厂家保证金';
			const supplierDepositDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.depositAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			return [{ label: `${prefix}变动差额`, value: supplierDepositDiff }];
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
		sumRecoverNonBadDebt(list) {
			return _.sumBy(
				_.filter(list || [], r => r.badDebtFlag !== 1),
				r => Number(r.moneyAmount || 0)
			);
		},
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', isRecordFirst: true, recordIndex: index + 1, backupTime, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		mapBeforeRow(info) {
			return {
				depositDate: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				supplierName: info.companyName || info.borrowerName || '',
				depositAmount: info.moneyAmount,
				bankCardNo: info.bankNo || ''
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			const origLoan = Number(original.moneyAmount || 0);
			const chgLoan = Number(changed.moneyAmount || 0);
			const supplierDepositDiff = format(subtract(chgLoan, origLoan), { notation: 'fixed', precision: 2 });
			return { depositAmount: supplierDepositDiff };
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
		},
		getTableSummary(param) {
			const { columns } = param;
			const sums = [];
			const diffRows = this.diffRows;
			const amountSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.depositAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'depositAmount') sums.push(amountSum);
				else sums.push('');
			});
			return sums;
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<el-table :data="tableData" border :row-class-name="tableRowClassName" :span-method="recordSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
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
		<el-table v-if="diffRows.length" :data="diffSummaryTableData" border class="diff-summary-table" :show-header="false">
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
