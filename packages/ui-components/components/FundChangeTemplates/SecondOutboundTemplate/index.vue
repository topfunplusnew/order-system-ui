<script>
/**
 * 二次出库变动详情模板
 * exwarehouse 表：storeHouseName、outDirection、outDate、sourceInventoryDetail、outAmount
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';

export default {
	name: 'SecondOutboundTemplate',
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
				{ prop: 'warehouse', label: '仓库名称', width: 120, showSummary: false },
				{ prop: 'outboundDirection', label: '出库方向', width: 120, showSummary: false },
				{ prop: 'outboundDate', label: '变动日期(出库)', width: 120, showSummary: false },
				{ prop: 'gradeName', label: '产品级别', width: 150, showSummary: false },
				{ prop: 'thickness', label: '厚度', width: 80, showSummary: false },
				{ prop: 'length', label: '长度', width: 80, showSummary: false },
				{ prop: 'width', label: '宽度', width: 80, showSummary: false },
				{ prop: 'outboundQuantity', label: '出库量', width: 100, showSummary: false },
				{ prop: 'stockPrice', label: '存货价', width: 100, showSummary: false },
				{ prop: 'originalInventoryAmount', label: '原库存金额', width: 120, showSummary: false },
				{ prop: 'inventoryDiff', label: '库存变动差额', aggregator: 'absSum', summaryLabel: '库存变动差额汇总' }
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
			const detail = info.sourceInventoryDetail || {};
			const unit = detail.countingUnit || '';
			const stock = Number(detail.stockNumber || info.outAmount || 0);
			const price = Number(detail.paymentUnload || 0);
			const len = Number(detail.length || 0) / 1000;
			const w = Number(detail.width || 0) / 1000;
			let invAmt = 0;
			if (unit === '其他') invAmt = stock * price;
			else invAmt = len * w * Number(info.outAmount || 0) * price;
			return {
				warehouse: info.storeHouseName,
				outboundDirection: info.outDirection === '二次加工' ? '二次入库出库' : info.outDirection || '',
				outboundDate: info.outDate ? (info.outDate + '').slice(0, 10) : '',
				gradeName: detail.levelName,
				thickness: detail.height,
				length: detail.length,
				width: detail.width,
				outboundQuantity: info.outAmount,
				stockPrice: price,
				originalInventoryAmount: format(invAmt, { notation: 'fixed', precision: 2 })
			};
		},
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
		},
		calcInventoryAmount(info) {
			const detail = info.sourceInventoryDetail || {};
			const unit = detail.countingUnit || '';
			const outAmt = Number(info.outAmount || 0);
			const price = Number(detail.paymentUnload || 0);
			const len = Number(detail.length || 0) / 1000;
			const w = Number(detail.width || 0) / 1000;
			if (unit === '其他') return outAmt * price;
			return len * w * outAmt * price;
		},
		buildDiffFields(original, changed, _record) {
			// 出库：库存减少，差额 = 修改前 - 修改后（修改后出库越多，库存越少）
			const origAmt = this.calcInventoryAmount(original);
			const chgAmt = this.calcInventoryAmount(changed);
			const invDiff = this.calculateFieldDiff(origAmt, chgAmt);
			return { inventoryDiff: invDiff };
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
