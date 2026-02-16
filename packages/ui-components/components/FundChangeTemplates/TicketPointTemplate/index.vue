<script>
/**
 * 票点变动详情模板
 * invoicein/invoiceout/invoiceother 表：customer、Supplier、invoiceAmount、customerPointAmount、supplierPointAmount 等
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';

export default {
	name: 'TicketPointTemplate',
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
				{ prop: 'ticketType', label: '票点类型', width: 120, showSummary: false },
				{ prop: 'customerName', label: '客户名称', width: 120, showSummary: false },
				{ prop: 'supplierName', label: '供应商名称', width: 120, showSummary: false },
				{ prop: 'ticketAmount', label: '票点金额', width: 100, showSummary: false },
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
		getTicketType(tableName) {
			const map = { invoicein: '发票购入', invoiceout: '发票售出', invoiceother: '第三方发票' };
			return map[tableName] || '票点';
		},
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, index) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const tname = record.tableName || this.moduleName;
				const beforeRow = { ...this.mapBeforeRow(original, record, index, tname), rowType: 'before', label: `记录(${index + 1})`, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index, tname), rowType: 'after', label: '', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', label: '', subLabel: '差额', ...this.buildDiffFields(original, changed, record, tname) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		mapBeforeRow(info, record, _index, tableName) {
			return {
				ticketType: this.getTicketType(tableName),
				customerName: info.customer || info.Customer || '',
				supplierName: info.Supplier || info.supplier || '',
				ticketAmount: info.invoiceAmount
			};
		},
		mapAfterRow(info, record, _index, tableName) {
			return this.mapBeforeRow(info, record, _index, tableName);
		},
		buildDiffFields(original, changed, record, tableName) {
			// 票点：invoicein 客户售票减少客户余额；invoiceout 客户购票增加客户余额；invoiceother 第三方
			const custPointOrig = Number(original.customerPointAmount || 0);
			const custPointChg = Number(changed.customerPointAmount || 0);
			const supPointOrig = Number(original.supplierPointAmount || 0);
			const supPointChg = Number(changed.supplierPointAmount || 0);
			let customerDiff = '0.00';
			let supplierDiff = '0.00';
			if (tableName === 'invoicein') {
				customerDiff = this.calculateFieldDiff(custPointOrig, custPointChg);
				supplierDiff = this.calculateFieldDiff(supPointChg, supPointOrig);
			} else if (tableName === 'invoiceout') {
				customerDiff = this.calculateFieldDiff(custPointChg, custPointOrig);
				supplierDiff = this.calculateFieldDiff(supPointOrig, supPointChg);
			} else {
				customerDiff = this.calculateFieldDiff(custPointChg, custPointOrig);
				supplierDiff = this.calculateFieldDiff(supPointChg, supPointOrig);
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
