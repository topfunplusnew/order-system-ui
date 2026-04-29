<script>
/**
 * 借入款管理变动详情模板
 * borrowedmoney 表：moneyAmount、repayments[].moneyAmount、repayments[].ratio
 * 范式：记录(x) 合并 3 行，排除 bankCardDiff，buildDiffFields 填 borrowAmount，diff-summary-table 展示
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { BORROWEDMONEY_COLUMNS } from '@/utils/fundChangeExcelColumns';

export default {
	name: 'BorrowInTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '借入款管理' },
		summaryOnly: { type: Boolean, default: false }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['bankCardDiff'];
			return BORROWEDMONEY_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '借入款管理';
			const bankCardDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.borrowAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			return [{ label: `${prefix}银行卡资金变动差额`, value: bankCardDiff }];
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
				const backupTime = _.toString(record.backupTime || '').slice(0, 10);
				const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', isRecordFirst: true, recordIndex: index + 1, backupTime, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		calcRepaidAndUnrepaid(info) {
			const repaid = _.sumBy(info.repayments || [], r => Number(r.moneyAmount || 0));
			const principal = Number(info.moneyAmount || 0);
			const repaidInterest = _.sumBy(info.repayments || [], r => Number(r.ratio || 0));
			const unrepaid = subtract(principal, repaid);
			return {
				repaidAmount: format(repaid, { notation: 'fixed', precision: 2 }),
				unrepaidAmount: format(unrepaid, { notation: 'fixed', precision: 2 }),
				repaidInterest: format(repaidInterest, { notation: 'fixed', precision: 2 })
			};
		},
		mapBeforeRow(info) {
			const { repaidAmount, unrepaidAmount, repaidInterest } = this.calcRepaidAndUnrepaid(info);
			return {
				id: info.id,
				lenderSource: info.lenderName || info.companyName || '',
				borrowAmount: info.moneyAmount,
				interestRate: info.interestRate,
				grantDate: info.grantDate ? (info.grantDate + '').slice(0, 10) : '',
				loanYears: info.loanYears,
				mortgage: info.mortgage || '',
				intoAccount: info.intoAccountName || info.bankName || '',
				intoAccountNo: info.bankNo || info.intoAccountNo || '',
				repaidAmount,
				unrepaidAmount,
				repaidInterest,
				remark: info.remark || ''
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			// 借入款：moneyAmount增加、还款减少银行卡
			const origPrincipal = Number(original.moneyAmount || 0);
			const chgPrincipal = Number(changed.moneyAmount || 0);
			const origRepayP = _.sumBy(original.repayments || [], r => Number(r.moneyAmount || 0));
			const chgRepayP = _.sumBy(changed.repayments || [], r => Number(r.moneyAmount || 0));
			const origRepayI = _.sumBy(original.repayments || [], r => Number(r.ratio || 0));
			const chgRepayI = _.sumBy(changed.repayments || [], r => Number(r.ratio || 0));
			const diff = add(subtract(chgPrincipal, origPrincipal), add(subtract(origRepayP, chgRepayP), subtract(origRepayI, chgRepayI)));
			const bankCardDiff = format(diff, { notation: 'fixed', precision: 2 });
			return { borrowAmount: bankCardDiff };
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
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.borrowAmount) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'borrowAmount') sums.push(amountSum);
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
