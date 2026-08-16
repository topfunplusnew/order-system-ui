<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 新增"AI 字段地图"注释（字段名/中文列名/数据来源/差额行说明），便于 AI 快速了解展示内容；仅注释，未改业务逻辑。
	历史：
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * OrderAdjustmentTemplate - 订单调整单(goodsorder)资金变动详情模板
 * compareData 为 getByIds 返回的 data 数组，每项含 originalInfo、changedInfo、orderDetailList
 * 按 orderDetailList 展开，每明细一对 修改前/修改后，每组末尾一行差额
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表（goodsorder）
 *   originalInfo.orderDetailList / changedInfo.orderDetailList 明细数组（按 id 配对展开）
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（utils/fundChange/dateScopedRows）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 订单调整单  组内首行合并，显示「订单调整单(groupIndex+1) + backupTime」
 *    固定列② 变更        修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 41 列         = ORDER_ADJUSTMENT_COLUMNS 过滤 [customerDiff, supplierDiff, inventoryDiff, freightDiff]
 *    合计行              差额行合计: factoryPayment / paymentsWithSundry / allPayments / totalFreight
 * 3. el-table 底部汇总表（diff-summary-table）
 *    buildBackendSummaryRows(summaryData, 'goodsorder', prefix, ['companyTotalBalance', 'supplierTotalBalance', 'remainingInventoryAmount', 'driverUnpaidAmount'])
 *    展示键: 见 BOTTOM SUMMARY
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo; detail=orderDetailList 单条明细（优先 detail，缺省回退 info）
 *   status                | 状态           | info.checkState                          |
 *   orderDate             | 订单日期       | info.orderDate || info.addtime          | 截取前10位
 *   customerName          | 客户           | detail.customer || info.customer        |
 *   truckPlate            | 车牌           | detail.carNumber || info.landCarNo      |
 *   seaCabinetNo          | 海运柜号       | info.seaCarNo                            |
 *   seaCompany            | 海运公司       | info.seaBankName                         |
 *   supplierName          | 供应商         | detail.supplier || info.supplierNames    | 数组时 join(',')
 *   warehouse             | 仓库名称       | detail.storeHouseName || info.storeHouseName |
 *   gradeName             | 级别名称       | detail.levelName                         |
 *   countingUnit          | 计量单位       | detail.countingUnit                      |
 *   thickness             | 厚度           | detail.height                            |
 *   length                | 长度           | detail.length                            |
 *   width                 | 宽度           | detail.width                             |
 *   piecesPerPack         | 每包片数       | detail.piecesPerPack                     |
 *   packs                 | 包数           | detail.packs                             |
 *   factoryPieces         | 出厂片数       | detail.pieces                            |
 *   factoryUnitPrice      | 出厂单价       | detail.price                             |
 *   factoryTaxFlag        | 出厂是否含税   | detail.isIncludeTaxFactory               | '是'/'否'/''
 *   sundryCost            | 杂费           | detail.sundryCost                        | 保留2位
 *   factoryPayment        | 出厂货款       | detail.paymentFactory                    | 保留2位; 差额行回填
 *   actualPieces          | 卸货片数       | detail.actualPieces                      |
 *   unloadPrice           | 卸货价         | detail.paymentUnload                     |
 *   stockTaxFlag          | 销售是否含税   | detail.isIncludeTaxSale                  | '是'/'否'/''
 *   paymentsWithSundry    | 总货款杂费     | detail.paymentsWithSundry                | 保留2位; 差额行回填
 *   allPayments           | 总货款         | detail.payments                          | 保留2位; 差额行回填
 *   erro                  | 误差           | detail.erro                              |
 *   tonnage               | 吨位           | detail.tonnage                           |
 *   landFreightPrice      | 陆运费单价     | detail.landFreightPrice                  |
 *   additionalFees        | 加费           | detail.additionalFees                    |
 *   landFreight           | 陆运费         | detail.landFreight ?? info.landFreight   | 保留2位
 *   seaFreight            | 海运费         | detail.seaFreight ?? info.seaFreight     | 保留2位
 *   totalFreight          | 总运费         | detail.freight ?? (landFreight+seaFreight)| 保留2位; 差额行回填
 *   otherCost             | 其他费用       | detail.otherCost                         |
 *   profit                | 利润           | detail.profit                            |
 *   profitNoTax           | 不含税利润     | detail.profitNoTax                       |
 *   logisticsProfit       | 物流利润       | detail.logisticsProfit                   |
 *   customerCommission    | 客户佣金       | detail.customerCommission                |
 *   factoryCommission     | 厂家佣金       | detail.factoryCommission                 |
 *   factoryRebateAmount   | 计提厂家返利金额 | detail.factoryRebateAmount             |
 *   factoryDiscountAmount | 计提厂家降价金额 | detail.factoryDiscountAmount           |
 *   remark                | 备注           | detail.comments || info.comments         |
 *
 * ── DIFF ROW（差额行 rowType='diff'）────────────────────
 *   buildDiffFields → buildOrderAdjustmentDiffFields(original, changed)，按明细求和 修改后-修改前:
 *   customerDiff  客户变动差额 = sum(detail.payments 修改后) - sum(修改前)（= allPaymentsDiff）
 *   supplierDiff  供应商变动差额 = sum(detail.paymentFactory 修改后) - sum(修改前)（→ 回填 factoryPayment）
 *   inventoryDiff 库存变动差额 = 固定 '0.00'（占位，不参与计算）
 *   freightDiff   运费变动差额 = sum(freight 修改后) - sum(修改前)（→ 回填 totalFreight; freight 取 detail.freight 或 landFreight+seaFreight）
 *   allPayments / paymentsWithSundry 差额直接回填对应列
 *   注: customerDiff/supplierDiff/inventoryDiff/freightDiff 不直接展示（已从 columns 过滤），仅体现于差额行回填列与合计行
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   companyTotalBalance 客户变动差额 | supplierTotalBalance 供应商变动差额
 *   remainingInventoryAmount 库存变动差额 | driverUnpaidAmount 运费变动差额
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
