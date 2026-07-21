<!-- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。 -->
<script>
/**
 * 订单调整单变动详情模板
 * compareData 为 getByIds 返回的 data 数组，每项含 originalInfo、changedInfo、orderDetailList
 * 按 orderDetailList 展开，每明细一对 修改前/修改后，每组末尾一行差额
 */
import { format, add } from 'mathjs';
import _ from 'lodash';
import { ORDER_ADJUSTMENT_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildOrderAdjustmentDiffFields, formatOrderAdjustmentAmount, resolveOrderAdjustmentPaymentsWithSundry } from '@/utils/fundChange/orderAdjustment';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedDiffFields, filterDetailPairsByScope, getScopedRowCount, getScopedRowTypes, resolveDateScopedChange } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'OrderAdjustmentTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '订单调整单' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['customerDiff', 'supplierDiff', 'inventoryDiff', 'freightDiff'];
			return ORDER_ADJUSTMENT_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '订单调整单';
			return buildBackendSummaryRows(this.summaryData, 'goodsorder', prefix, ['companyTotalBalance', 'supplierTotalBalance', 'remainingInventoryAmount', 'driverUnpaidAmount']);
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
		getDetailKey(detail = {}, index = 0) {
			return detail.id != null ? `id:${detail.id}` : `idx:${index}`;
		},
		buildDetailPairs(origList = [], chgList = []) {
			const pairMap = new Map();
			origList.forEach((detail, index) => {
				const key = this.getDetailKey(detail, index);
				pairMap.set(key, { key, original: detail || {}, changed: {} });
			});
			chgList.forEach((detail, index) => {
				const key = this.getDetailKey(detail, index);
				const current = pairMap.get(key) || { key, original: {}, changed: {} };
				current.changed = detail || {};
				pairMap.set(key, current);
			});
			const pairs = Array.from(pairMap.values());
			return pairs.length ? pairs : [{ key: 'empty:0', original: {}, changed: {} }];
		},
		/**
		 * 统一税标识文案
		 * @param {number|string|boolean} value - 原始税标识
		 * @returns {string}
		 */
		formatTaxFlag(value) {
			if (value === 1 || value === '1' || value === true) return '是';
			if (value === 0 || value === '0' || value === false) return '否';
			return '';
		},
		/**
		 * 按 orderDetailList 展开，每明细一对 修改前/修改后，每组末尾一行差额
		 */
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, groupIndex) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const origList = original.orderDetailList || [];
				const chgList = changed.orderDetailList || [];
				const scope = resolveDateScopedChange(original, changed, this.targetDate, getFundChangeTemplateDateFields(this.$options.name));
				const rowTypes = getScopedRowTypes(scope, record.backupType);
				if (!rowTypes.length) return;
				const detailPairs = filterDetailPairsByScope(this.buildDetailPairs(origList, chgList), scope, record.backupType);
				if (!detailPairs.length) return;
				const detailCount = detailPairs.length;
				const groupRowCount = getScopedRowCount(scope, detailCount, record.backupType);
				const groupRows = [];
				detailPairs.forEach((pair, detailIndex) => {
					if (rowTypes.includes('before')) groupRows.push({ ...this.mapDetailToRow(original, pair.original), rowType: 'before', groupIndex, detailIndex, subLabel: '修改前', groupRowCount });
					if (rowTypes.includes('after')) groupRows.push({ ...this.mapDetailToRow(changed, pair.changed), rowType: 'after', groupIndex, detailIndex, subLabel: '修改后', groupRowCount });
				});
				const diffFields = buildDateScopedDiffFields(original, changed, scope, (scopedOriginal, scopedChanged) => this.buildDiffFields(scopedOriginal, scopedChanged, record));
				groupRows.push({ rowType: 'diff', groupIndex, subLabel: '差额', groupRowCount, ...diffFields });
				groupRows[0].isGroupFirst = true;
				groupRows[0].backupTime = _.toString(record.backupTime || '').slice(0, 10);
				this.tableData.push(...groupRows);
			});
		},
		/**
		 * 单条明细映射为行数据
		 * @param {Object} info - 主表信息（originalInfo 或 changedInfo）
		 * @param {Object} detail - 明细项
		 * @returns {Object} 行数据
		 */
		mapDetailToRow(info, detail) {
			const landFreight = Number(detail.landFreight != null ? detail.landFreight : info.landFreight || 0);
			const seaFreight = Number(detail.seaFreight != null ? detail.seaFreight : info.seaFreight || 0);
			const totalFreight = Number(detail.freight != null ? detail.freight : add(landFreight, seaFreight));
			const factoryPayment = Number(detail.paymentFactory || 0);
			const sundryCost = Number(detail.sundryCost || 0);
			const paymentsWithSundry = resolveOrderAdjustmentPaymentsWithSundry(detail);
			return {
				status: info.checkState,
				orderDate: info.orderDate ? String(info.orderDate).slice(0, 10) : info.addtime ? String(info.addtime).slice(0, 10) : '',
				customerName: detail.customer || info.customer,
				truckPlate: detail.carNumber || info.landCarNo,
				seaCabinetNo: info.seaCarNo || '',
				seaCompany: info.seaBankName || '',
				supplierName: detail.supplier || (_.isArray(info.supplierNames) ? info.supplierNames.join(',') : info.supplierNames || ''),
				warehouse: detail.storeHouseName || info.storeHouseName || '',
				gradeName: detail.levelName || '',
				countingUnit: detail.countingUnit || '',
				thickness: detail.height,
				length: detail.length,
				width: detail.width,
				piecesPerPack: detail.piecesPerPack,
				packs: detail.packs,
				factoryPieces: detail.pieces,
				factoryUnitPrice: detail.price,
				factoryTaxFlag: this.formatTaxFlag(detail.isIncludeTaxFactory),
				sundryCost: format(sundryCost, { notation: 'fixed', precision: 2 }),
				factoryPayment: format(factoryPayment, { notation: 'fixed', precision: 2 }),
				actualPieces: detail.actualPieces,
				unloadPrice: detail.paymentUnload,
				stockTaxFlag: this.formatTaxFlag(detail.isIncludeTaxSale),
				paymentsWithSundry: formatOrderAdjustmentAmount(paymentsWithSundry),
				allPayments: detail.payments != null ? format(Number(detail.payments || 0), { notation: 'fixed', precision: 2 }) : '',
				erro: detail.erro,
				tonnage: detail.tonnage,
				landFreightPrice: detail.landFreightPrice,
				additionalFees: detail.additionalFees,
				landFreight: landFreight ? format(landFreight, { notation: 'fixed', precision: 2 }) : '0.00',
				seaFreight: seaFreight ? format(seaFreight, { notation: 'fixed', precision: 2 }) : '0.00',
				totalFreight: format(totalFreight, { notation: 'fixed', precision: 2 }),
				otherCost: detail.otherCost,
				profit: detail.profit,
				profitNoTax: detail.profitNoTax,
				logisticsProfit: detail.logisticsProfit,
				customerCommission: detail.customerCommission,
				factoryCommission: detail.factoryCommission,
				factoryRebateAmount: detail.factoryRebateAmount,
				factoryDiscountAmount: detail.factoryDiscountAmount,
				remark: detail.comments || info.comments || ''
			};
		},
		/**
		 * 差额行字段：填充出厂货款、总货款杂费、总货款、总运费，以及 diff-summary-table 用的 4 项
		 * @param {Object} original - 修改前
		 * @param {Object} changed - 修改后
		 * @param {Object} _record - 备份记录
		 * @returns {Object}
		 */
		buildDiffFields(original, changed, _record) {
			return buildOrderAdjustmentDiffFields(original, changed);
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
		/**
		 * 第一列合并：每组首行合并该组所有行
		 * @param {Object} param - { row, columnIndex }
		 * @returns {[number, number]}
		 */
		orderSpanMethod({ row, columnIndex }) {
			if (columnIndex !== 0) return [1, 1];
			if (row.isGroupFirst) return [row.groupRowCount || 3, 1];
			return [0, 0];
		},
		/**
		 * 表格合计行：出厂货款、总货款杂费、总货款、总运费差额合计
		 * @param {Object} param - { columns }
		 * @returns {string[]}
		 */
		getTableSummary(param) {
			const { columns } = param;
			const sums = [];
			const diffRows = this.diffRows;
			const factoryPaymentSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.factoryPayment) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const paymentsWithSundrySum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.paymentsWithSundry) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const allPaymentsSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.allPayments) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const totalFreightSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.totalFreight) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'factoryPayment') sums.push(factoryPaymentSum);
				else if (col.property === 'paymentsWithSundry') sums.push(paymentsWithSundrySum);
				else if (col.property === 'allPayments') sums.push(allPaymentsSum);
				else if (col.property === 'totalFreight') sums.push(totalFreightSum);
				else sums.push('');
			});
			return sums;
		}
	}
};
</script>

<template>
	<div class="fund-change-template">
		<FundChangeExportButton :columns="columns" :rows="tableData" :summary-rows="diffSummaryTableData" :module-label="summaryModuleLabel" :summary-only="summaryOnly" />
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="orderSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column label="订单调整单" width="120" fixed class-name="record-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isGroupFirst">
						<div>订单调整单（{{ scope.row.groupIndex + 1 }}）</div>
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
