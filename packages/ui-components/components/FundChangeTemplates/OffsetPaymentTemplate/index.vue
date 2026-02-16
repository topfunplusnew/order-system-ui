<script>
/**
 * 冲抵款变动详情模板
 * cash_record 表：amount、sourceCompanyType、targetCompanyType、type
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';

export default {
	name: 'OffsetPaymentTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			return [
				{ prop: 'offsetDate', label: '冲抵日期', width: 120, showSummary: false },
				{ prop: 'customerName', label: '客户名称', width: 120, showSummary: false },
				{ prop: 'supplierName', label: '供应商名称', width: 120, showSummary: false },
				{ prop: 'offsetAmount', label: '冲抵金额', width: 120, showSummary: false },
				{ prop: 'offsetType', label: '冲抵类型', width: 120, showSummary: false },
				{ prop: 'customerDiff', label: '客户变动差额', aggregator: 'absSum', summaryLabel: '客户变动差额汇总' },
				{ prop: 'supplierDiff', label: '供应商变动差额', aggregator: 'absSum', summaryLabel: '供应商变动差额汇总' }
			];
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		summaryMap() {
			const map = {};
			this.columns.forEach(col => {
				if (col.showSummary === false) return;
				const values = _.map(this.diffRows, col.prop).map(v => Number(v) || 0);
				const agg = _.isFunction(col.aggregator) ? col.aggregator : AGGREGATOR_MAP[col.aggregator] || AGGREGATOR_MAP.sum;
				map[col.prop] = agg(values, { diffRows: this.diffRows, precision: 2 });
			});
			return map;
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
				const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', label: `记录(${index + 1})`, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', label: '', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', label: '', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		mapBeforeRow(info) {
			const srcType = info.sourceCompanyType || '';
			const tgtType = info.targetCompanyType || '';
			const custName = srcType === '客户' ? info.sourceCompanyName || '' : tgtType === '客户' ? info.targetCompanyName || '' : '';
			const supName = srcType === '供应商' ? info.sourceCompanyName || '' : tgtType === '供应商' ? info.targetCompanyName || '' : '';
			return {
				offsetDate: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				customerName: custName,
				supplierName: supName,
				offsetAmount: info.amount,
				offsetType: info.type === 'transfer' ? '划转' : '冲抵'
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		buildDiffFields(original, changed, _record) {
			// 冲抵款：sourceCompanyType=客户时 customerDiff=original.amount-changed.amount；targetCompanyType=客户时 customerDiff=changed.amount-original.amount
			const srcType = _.get(original, 'sourceCompanyType') || _.get(changed, 'sourceCompanyType');
			const tgtType = _.get(original, 'targetCompanyType') || _.get(changed, 'targetCompanyType');
			const isTransfer = _.get(original, 'type') === 'transfer' || _.get(changed, 'type') === 'transfer';
			let customerDiff = '0.00';
			let supplierDiff = '0.00';
			if (!isTransfer) {
				const origAmt = Number(original.amount || 0);
				const chgAmt = Number(changed.amount || 0);
				if (srcType === '客户' || tgtType === '客户') {
					customerDiff = srcType === '客户' ? this.calculateFieldDiff(origAmt, chgAmt) : this.calculateFieldDiff(chgAmt, origAmt);
				}
				if (srcType === '供应商' || tgtType === '供应商') {
					supplierDiff = srcType === '供应商' ? this.calculateFieldDiff(origAmt, chgAmt) : this.calculateFieldDiff(chgAmt, origAmt);
				}
			}
			return { customerDiff, supplierDiff };
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
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<el-table :data="tableData" border :row-class-name="tableRowClassName" style="width: 100%">
			<el-table-column width="150" fixed>
				<template slot-scope="scope">
					<div v-if="scope.row.label">{{ scope.row.label }}</div>
					<div class="sub-label">{{ scope.row.subLabel }}</div>
				</template>
			</el-table-column>
			<el-table-column v-for="col in columns" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" />
		</el-table>
		<div class="summary-section" v-if="diffRows.length">
			<div class="summary-item" v-for="col in columns.filter(c => c.showSummary !== false)" :key="col.prop">
				<span class="summary-label">{{ col.summaryLabel || col.label }}：</span>
				<span class="summary-value">{{ summaryMap[col.prop] }}</span>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.fund-change-template {
	padding: 20px;
}
.sub-label {
	font-size: 12px;
	color: #666;
	margin-top: 4px;
}
::v-deep .before-row {
	background-color: #f0f9ff;
}
::v-deep .after-row {
	background-color: #fff7e6;
}
::v-deep .diff-row {
	background-color: #fff1f0;
	font-weight: bold;
}
.summary-section {
	margin-top: 20px;
	padding: 10px;
	background: #f5f5f5;
	border-radius: 4px;
	display: flex;
	flex-wrap: wrap;
	gap: 16px 24px;
}
.summary-item {
	font-size: 14px;
}
.summary-label {
	color: #606266;
}
.summary-value {
	font-weight: bold;
	margin-left: 4px;
	color: #f56c6c;
}
</style>
