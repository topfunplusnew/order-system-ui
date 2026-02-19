<script>
/**
 * 订单调整单变动详情模板
 * compareData 为 getByIds 返回的 data 数组，每项含 originalInfo、changedInfo
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';
import { ORDER_ADJUSTMENT_COLUMNS } from '@/utils/fundChangeExcelColumns';

export default {
	name: 'OrderAdjustmentTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		/** 底部统计 data（calculateByIds 返回） */
		summaryData: { type: Object, default: () => ({}) }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			return ORDER_ADJUSTMENT_COLUMNS.map(c => (c.aggregator ? c : { ...c, showSummary: false }));
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
				const beforeRow = { ...this.mapBeforeRow(original, record, index), rowType: 'before', label: `订单调整单(${index + 1})`, subLabel: '修改前' };
				const afterRow = { ...this.mapAfterRow(changed, record, index), rowType: 'after', label: '', subLabel: '修改后' };
				const diffRow = { rowType: 'diff', label: '', subLabel: '差额', ...this.buildDiffFields(original, changed, record) };
				this.tableData.push(beforeRow, afterRow, diffRow);
			});
		},
		mapBeforeRow(info, _record, _index) {
			const firstDetail = _.get(info, 'orderDetailList[0]', {});
			const totalFreight = Number(info.landFreight || 0) + Number(info.seaFreight || 0);
			return {
				status: info.checkState,
				orderDate: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				customerName: info.customer,
				truckPlate: info.landCarNo,
				seaCabinetNo: info.seaCarNo || '',
				seaCompany: info.seaBankName || '',
				supplierName: _.isArray(info.supplierNames) ? info.supplierNames.join(',') : info.supplierNames || '',
				warehouse: info.storeHouseName || firstDetail.storeHouseName || '',
				gradeName: firstDetail.levelName || '',
				allPayments: info.allPayments,
				landFreight: info.landFreight,
				seaFreight: info.seaFreight,
				totalFreight: format(totalFreight, { notation: 'fixed', precision: 2 })
			};
		},
		mapAfterRow(info, _record, _index) {
			return this.mapBeforeRow(info, _record, _index);
		},
		buildDiffFields(original, changed, _record) {
			const customerDiff = this.calculateFieldDiff(changed.allPayments, original.allPayments);
			const supplierDiff = this.sumOrderDetailDiff(original.orderDetailList || [], changed.orderDetailList || [], 'paymentFactory');
			const freightDiff = this.calculateFieldDiff(Number(changed.landFreight || 0) + Number(changed.seaFreight || 0), Number(original.landFreight || 0) + Number(original.seaFreight || 0));
			return { customerDiff, supplierDiff, inventoryDiff: '0.00', freightDiff };
		},
		sumOrderDetailDiff(origList, chgList, field) {
			const origSum = _.sumBy(origList || [], i => Number(_.get(i, field) || 0));
			const chgSum = _.sumBy(chgList || [], i => Number(_.get(i, field) || 0));
			return this.calculateFieldDiff(chgSum, origSum);
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
			<el-table-column v-for="col in columns.filter(c => c.prop)" :key="col.prop" :prop="col.prop" :label="col.label" :width="col.width" :fixed="col.fixed" />
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
