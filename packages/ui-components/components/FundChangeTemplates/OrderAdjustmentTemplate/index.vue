<script>
/**
 * 订单调整单变动详情模板
 * compareData 为 getByIds 返回的 data 数组，每项含 originalInfo、changedInfo、orderDetailList
 * 按 orderDetailList 展开，每明细一对 修改前/修改后，每组末尾一行差额
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { ORDER_ADJUSTMENT_COLUMNS } from '@/utils/fundChangeExcelColumns';

export default {
	name: 'OrderAdjustmentTemplate',
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '订单调整单' },
		summaryOnly: { type: Boolean, default: false }
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
			const customerDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.customerDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const supplierDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.supplierDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const inventoryDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.inventoryDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const freightDiff = format(
				_.reduce(this.diffRows, (acc, r) => add(acc, Number(r.freightDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			return [
				{ label: `${prefix}客户变动差额`, value: customerDiff },
				{ label: `${prefix}供应商变动差额`, value: supplierDiff },
				{ label: `${prefix}库存变动差额`, value: inventoryDiff },
				{ label: `${prefix}运费变动差额`, value: freightDiff }
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
				const detailCount = Math.max(origList.length, chgList.length, 1);
				const groupRows = [];
				for (let d = 0; d < detailCount; d++) {
					const origDetail = origList[d] || {};
					const chgDetail = chgList[d] || {};
					groupRows.push({ ...this.mapDetailToRow(original, origDetail), rowType: 'before', groupIndex, detailIndex: d, subLabel: '修改前', groupRowCount: detailCount * 2 + 1 });
					groupRows.push({ ...this.mapDetailToRow(changed, chgDetail), rowType: 'after', groupIndex, detailIndex: d, subLabel: '修改后', groupRowCount: detailCount * 2 + 1 });
				}
				groupRows.push({ rowType: 'diff', groupIndex, subLabel: '差额', groupRowCount: detailCount * 2 + 1, ...this.buildDiffFields(original, changed, record) });
				groupRows[0].isGroupFirst = true;
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
			const totalFreight = Number(info.landFreight || 0) + Number(info.seaFreight || 0);
			const factoryPayment = Number(detail.paymentFactory || 0);
			const sundryCost = Number(detail.sundryCost || info.sundryCost || 0);
			const paymentsWithSundry = add(factoryPayment, sundryCost);
			return {
				status: info.checkState,
				orderDate: info.addtime ? (info.addtime + '').slice(0, 10) : '',
				customerName: info.customer,
				truckPlate: info.landCarNo,
				seaCabinetNo: info.seaCarNo || '',
				seaCompany: info.seaBankName || '',
				supplierName: _.isArray(info.supplierNames) ? info.supplierNames.join(',') : info.supplierNames || '',
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
				paymentsWithSundry: format(paymentsWithSundry, { notation: 'fixed', precision: 2 }),
				allPayments: info.allPayments,
				erro: detail.erro,
				tonnage: info.allTonnage,
				landFreightPrice: detail.landFreightPrice,
				additionalFees: info.additionalFees,
				landFreight: info.landFreight,
				seaFreight: info.seaFreight,
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
		 * 差额行字段：填主表 allPayments、totalFreight，以及 diff-summary-table 用的 4 项
		 * @param {Object} original - 修改前
		 * @param {Object} changed - 修改后
		 * @param {Object} _record - 备份记录
		 * @returns {Object}
		 */
		buildDiffFields(original, changed, _record) {
			const allPaymentsDiff = this.calculateFieldDiff(changed.allPayments, original.allPayments);
			const freightDiff = this.calculateFieldDiff(Number(changed.landFreight || 0) + Number(changed.seaFreight || 0), Number(original.landFreight || 0) + Number(original.seaFreight || 0));
			const customerDiff = this.calculateFieldDiff(changed.allPayments, original.allPayments);
			const supplierDiff = this.sumOrderDetailDiff(original.orderDetailList || [], changed.orderDetailList || [], 'paymentFactory');
			const inventoryDiff = '0.00';
			return { allPayments: allPaymentsDiff, totalFreight: freightDiff, customerDiff, supplierDiff, inventoryDiff, freightDiff };
		},
		/**
		 * 明细列表某字段差额
		 * @param {Array} origList - 修改前明细
		 * @param {Array} chgList - 修改后明细
		 * @param {string} field - 字段名
		 * @returns {string}
		 */
		sumOrderDetailDiff(origList, chgList, field) {
			const origSum = _.sumBy(origList || [], i => Number(_.get(i, field) || 0));
			const chgSum = _.sumBy(chgList || [], i => Number(_.get(i, field) || 0));
			return this.calculateFieldDiff(chgSum, origSum);
		},
		/**
		 * 计算单字段差额（mathjs 高精度）
		 * @param {number|string} afterVal
		 * @param {number|string} beforeVal
		 * @returns {string}
		 */
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
		 * 表格合计行：allPayments、totalFreight 差额合计
		 * @param {Object} param - { columns }
		 * @returns {string[]}
		 */
		getTableSummary(param) {
			const { columns } = param;
			const sums = [];
			const diffRows = this.diffRows;
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
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="orderSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column label="订单调整单" width="120" fixed class-name="record-col">
				<template slot-scope="scope">
					<span v-if="scope.row.isGroupFirst">订单调整单（{{ scope.row.groupIndex + 1 }}）</span>
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
