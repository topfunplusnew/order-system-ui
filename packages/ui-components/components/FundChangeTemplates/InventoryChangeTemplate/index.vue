<!--
	变更记录（每次需求变更在此追加，最新在上；格式：日期 - 改了什么）：
	- [2026-08-16] 展示字段注释重构为"AI 友好字段地图"格式（固定锚点 + prop|label|source|note 字段表），便于 AI 快速解析；仅注释，未改业务逻辑。
	历史：
	- [2026-08-16] 新增"本组件展示字段一览"注释（字段名/中文列名/数据来源/差额行说明）。
	- 用户需求：FundChangeTemplates 内所有模板增加导出表格数据功能。实际改动：接入共享 FundChangeExportButton，导出当前模板的变更明细与差额汇总数据。
-->
<script>
/**
 * InventoryChangeTemplate - 入库管理(inventory_main)资金变动详情模板
 *
 * ================= AI FIELD MAP（AI 字段地图） =================
 * 本注释为 AI 阅读设计：锚点固定、字段为表格格式，可用 grep/正则定位。
 * 修改本组件时，若增删/重命名字段，必须同步更新下方字段表。
 *
 * ── DATA ENTRY（数据入口）─────────────────────────────
 * compareData: Array   /system/backuplog/v3/getByIds 返回 data
 *   item.originalInfo 修改前主表;  item.changedInfo 修改后主表
 *   item.originalInfo.inventoryDetailList / item.changedInfo.inventoryDetailList 明细数组
 * summaryData: Object  后端汇总（见 BOTTOM SUMMARY）
 * targetDate:  String  日期范围过滤（utils/fundChange/dateScopedRows）
 *
 * ── RENDER STRUCTURE（渲染结构）────────────────────────
 * 1. FundChangeExportButton   导出按钮（明细 + 差额汇总）
 * 2. el-table 主明细表（summaryOnly=false 时显示）
 *    固定列① 入库单  组内首行合并，显示「入库单(N) + backupTime」
 *    固定列② 变更    修改前 / 修改后 / 差额（before-row / after-row / diff-row）
 *    数据列 42 列    = INVENTORY_MAIN_COLUMNS 过滤 [inventoryDiff, supplierDiff, freightDiff]
 *    合计行          仅差额行合计: factoryPayment / stockAmount / totalFreight
 * 3. el-table 底部汇总表（diff-summary-table）
 *    buildBackendSummaryRows(summaryData, 'inventory_main', prefix, [...])
 *    展示键: remainingInventoryAmount 剩余库存金额 / supplierTotalBalance 供应商欠款 / driverUnpaidAmount 司机未付运费
 *
 * ── COLUMNS（数据列字段表）─────────────────────────────
 * 格式: prop | 中文列名 | source 来源 | note 备注
 * source 中 info=主表 originalInfo/changedInfo; detail=inventoryDetailList 单条明细
 *   status               | 状态           | CONST 固定'已入库'                        |
 *   inboundTime          | 入库时间       | info.storeDate                           | 截取前10位
 *   warehouse            | 仓库           | info.storeHouseName                      |
 *   truckPlate           | 陆运车牌       | info.landCarNo                           |
 *   seaCabinetNo         | 海运柜号       | info.seaCarNo                            |
 *   seaCompany           | 海运公司       | info.seaBankName                         |
 *   supplierName         | 供应商         | detail.supplier                          |
 *   gradeName            | 级别名称       | detail.levelName                         |
 *   countingUnit         | 计量单位       | detail.countingUnit                      |
 *   thickness            | 厚度           | detail.height                            |
 *   length               | 长度           | detail.length                            |
 *   width                | 宽度           | detail.width                             |
 *   piecesPerPack        | 每包片数       | detail.piecesPerPack                     |
 *   packs                | 包数           | detail.packs                             |
 *   factoryPieces        | 出厂片数       | detail.actualPieces ?? detail.stockNumber |
 *   factoryUnitPrice     | 出厂单价       | detail.price                             |
 *   factoryTaxFlag       | 出厂是否含税   | detail.isIncludeTaxFactory               | '含税'/'不含税'
 *   sundryCost           | 杂费           | detail.sundryCost                        |
 *   factoryPayment       | 出厂货款       | sum(detail.paymentFactory)               |
 *   stockQuantity        | 库存量(片数)   | detail.stockNumber                       |
 *   unloadPrice          | 卸货价         | detail.paymentUnload                     |
 *   stockTaxFlag         | 库存是否含税   | detail.isIncludeTaxSale                  | '含税'/'不含税'
 *   stockAmount          | 库存金额       | detail.payments ?? calcStockAmount()      | 计算: 长*宽*量*卸货价(单位'其他'时 量*价)
 *   erro                 | 误差           | detail.erro                              |
 *   tonnage              | 吨位           | detail.tonnage                           |
 *   landFreightPrice     | 陆运费单价     | detail.landFreightPrice                  |
 *   additionalFees       | 加费           | detail.additionalFees                    |
 *   landFreight          | 陆运费         | detail.landFreight                       |
 *   seaFreight           | 海运费         | detail.seaFreight                        |
 *   totalFreight         | 总运费         | detail.freight ?? (landFreight+seaFreight) |
 *   otherCost            | 其他费用       | detail.otherCost                         |
 *   profit               | 利润           | sum(detail.profit)                       |
 *   profitNoTax          | 不含税利润     | sum(detail.profitNoTax)                  |
 *   inputUser            | 录入员         | info.userName                            |
 *   fleet                | 车队           | info.fleet                               |
 *   remark               | 备注           | info.comments                            |
 *   otherInfo            | 其他信息       | info.mainComments                        |
 *   logisticsProfit      | 物流利润       | sum(detail.logisticsProfit)              |
 *   customerCommission   | 客户佣金       | sum(detail.customerCommission)           |
 *   factoryCommission    | 厂家佣金       | sum(detail.factoryCommission)            |
 *   factoryRebateAmount  | 厂家返利金额   | sum(detail.factoryRebateAmount)          |
 *   factoryDiscountAmount| 厂家降价金额   | sum(detail.factoryDiscountAmount)        |
 *
 * ── DIFF ROW（差额行 rowType='diff'，均为 修改后-修改前）────
 *   inventoryDiff 库存变动差额 = 库存金额差（即 stockAmount 差额）
 *   supplierDiff  供应商变动差额 = paymentFactory 差（→ 回填 factoryPayment）
 *   freightDiff   运费变动差额 = freight 差（→ 回填 totalFreight）
 *   另回填: stockQuantity = 库存量差; stockAmount = inventoryDiff
 *   注: inventoryDiff/supplierDiff/freightDiff 不直接展示（已从 columns 过滤），仅体现于差额行回填列与合计行
 *
 * ── BOTTOM SUMMARY（底部汇总表展示键）─────────────────
 *   remainingInventoryAmount | supplierTotalBalance | driverUnpaidAmount
 */
import { format, subtract, add } from 'mathjs';
import _ from 'lodash';
import { INVENTORY_MAIN_COLUMNS } from '@/utils/fundChangeExcelColumns';
import { buildBackendSummaryRows } from '@/utils/fundChange/backendSummary';
import { buildDateScopedDiffFields, filterDetailPairsByScope, getScopedRowCount, getScopedRowTypes, resolveDateScopedChange } from '@/utils/fundChange/dateScopedRows';
import { getFundChangeTemplateDateFields } from '@/utils/fundChange/dateScopeFields';

import FundChangeExportButton from '../export/FundChangeExportButton.vue';

export default {
	name: 'InventoryChangeTemplate',
	components: { FundChangeExportButton },
	props: {
		compareData: { type: Array, default: () => [] },
		moduleName: { type: String, default: '' },
		summaryData: { type: Object, default: () => ({}) },
		summaryModuleLabel: { type: String, default: '入库管理' },
		summaryOnly: { type: Boolean, default: false },
		targetDate: { type: String, default: '' }
	},
	data() {
		return { tableData: [] };
	},
	computed: {
		columns() {
			const excludeProps = ['inventoryDiff', 'supplierDiff', 'freightDiff'];
			return INVENTORY_MAIN_COLUMNS.filter(c => !excludeProps.includes(c.prop)).map(c => (c.aggregator ? c : { ...c, showSummary: false }));
		},
		diffRows() {
			return this.tableData.filter(r => r.rowType === 'diff');
		},
		diffSummaryTableData() {
			const prefix = this.summaryModuleLabel || '入库管理';
			return buildBackendSummaryRows(this.summaryData, 'inventory_main', prefix, ['remainingInventoryAmount', 'supplierTotalBalance', 'driverUnpaidAmount']);
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
		/** 一对修改前/修改后对应一条明细，每组末尾一行差额（记录级） */
		processData() {
			this.tableData = [];
			(this.compareData || []).forEach((record, groupIndex) => {
				const original = record.originalInfo || {};
				const changed = record.changedInfo || {};
				const origList = original.inventoryDetailList || [];
				const chgList = changed.inventoryDetailList || [];
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
		/** 单条明细映射为行数据 */
		mapDetailToRow(info, detail) {
			const list = [detail];
			const factoryPay = this.sumDetailField(list, 'paymentFactory');
			const stockAmt = Number(detail.payments != null ? detail.payments : this.calcStockAmount(list));
			const landFreight = Number(detail.landFreight || 0);
			const seaFreight = Number(detail.seaFreight || 0);
			const totalFreight = Number(detail.freight != null ? detail.freight : add(landFreight, seaFreight));
			return {
				status: '已入库',
				inboundTime: info.storeDate ? (info.storeDate + '').slice(0, 10) : '',
				warehouse: info.storeHouseName,
				truckPlate: info.landCarNo,
				seaCabinetNo: info.seaCarNo || '',
				seaCompany: info.seaBankName || '',
				supplierName: detail.supplier || '',
				gradeName: detail.levelName || '',
				countingUnit: detail.countingUnit || '',
				thickness: detail.height,
				length: detail.length,
				width: detail.width,
				piecesPerPack: detail.piecesPerPack,
				packs: detail.packs,
				factoryPieces: detail.actualPieces ?? detail.stockNumber,
				factoryUnitPrice: detail.price,
				factoryTaxFlag: detail.isIncludeTaxFactory ? '含税' : '不含税',
				sundryCost: detail.sundryCost,
				factoryPayment: factoryPay,
				stockQuantity: detail.stockNumber,
				unloadPrice: detail.paymentUnload,
				stockTaxFlag: detail.isIncludeTaxSale ? '含税' : '不含税',
				stockAmount: format(stockAmt, { notation: 'fixed', precision: 2 }),
				erro: detail.erro,
				tonnage: detail.tonnage,
				landFreightPrice: detail.landFreightPrice,
				additionalFees: detail.additionalFees,
				landFreight: format(landFreight, { notation: 'fixed', precision: 2 }),
				seaFreight: format(seaFreight, { notation: 'fixed', precision: 2 }),
				totalFreight: format(totalFreight, { notation: 'fixed', precision: 2 }),
				otherCost: detail.otherCost,
				profit: _.sumBy(list, d => Number(d.profit || 0)),
				profitNoTax: _.sumBy(list, d => Number(d.profitNoTax || 0)),
				inputUser: info.userName,
				fleet: info.fleet,
				remark: info.comments,
				otherInfo: info.mainComments,
				logisticsProfit: _.sumBy(list, d => Number(d.logisticsProfit || 0)),
				customerCommission: _.sumBy(list, d => Number(d.customerCommission || 0)),
				factoryCommission: _.sumBy(list, d => Number(d.factoryCommission || 0)),
				factoryRebateAmount: _.sumBy(list, d => Number(d.factoryRebateAmount || 0)),
				factoryDiscountAmount: _.sumBy(list, d => Number(d.factoryDiscountAmount || 0))
			};
		},
		calcStockAmount(list) {
			let total = 0;
			(list || []).forEach(d => {
				const unit = d.countingUnit || '';
				const stock = Number(d.stockNumber || 0);
				const price = Number(d.paymentUnload || 0);
				const len = Number(d.length || 0) / 1000;
				const w = Number(d.width || 0) / 1000;
				if (unit === '其他') total += stock * price;
				else total += len * w * stock * price;
			});
			return total;
		},
		sumDetailField(list, field) {
			const sum = _.sumBy(list || [], i => Number(_.get(i, field) || 0));
			return format(sum, { notation: 'fixed', precision: 2 });
		},
		calcInventoryDiff(origList, chgList) {
			const calc = list => {
				let total = 0;
				(list || []).forEach(d => {
					const unit = d.countingUnit || '';
					const stock = Number(d.stockNumber || 0);
					const price = Number(d.paymentUnload || 0);
					const len = Number(d.length || 0) / 1000;
					const w = Number(d.width || 0) / 1000;
					if (unit === '其他') total += stock * price;
					else total += len * w * stock * price;
				});
				return total;
			};
			return this.calculateFieldDiff(calc(chgList), calc(origList));
		},
		/** 记录级差额字段，差额行填充：出厂货款、库存金额、总运费及合计用字段 */
		buildDiffFields(original, changed, _record) {
			const inventoryDiff = this.calcInventoryDiff(original.inventoryDetailList, changed.inventoryDetailList);
			const supplierDiff = this.sumOrderDetailDiff(original.inventoryDetailList || [], changed.inventoryDetailList || [], 'paymentFactory');
			const freightDiff = this.sumDetailFreightDiff(original.inventoryDetailList || [], changed.inventoryDetailList || []);
			const stockQtyDiff = this.sumOrderDetailDiff(original.inventoryDetailList || [], changed.inventoryDetailList || [], 'stockNumber');
			return { inventoryDiff, supplierDiff, freightDiff, factoryPayment: supplierDiff, stockQuantity: stockQtyDiff, stockAmount: inventoryDiff, totalFreight: freightDiff };
		},
		sumDetailFreightDiff(origList, chgList) {
			const sumFreight = list =>
				_.sumBy(list || [], item => {
					if (item.freight != null) return Number(item.freight || 0);
					return Number(item.landFreight || 0) + Number(item.seaFreight || 0);
				});
			return this.calculateFieldDiff(sumFreight(chgList), sumFreight(origList));
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
		},
		/** 入库单列合并：每组首行合并该组所有行（明细数*2+差额） */
		inboundSpanMethod({ row, columnIndex }) {
			if (columnIndex !== 0) return [1, 1];
			if (row.isGroupFirst) return [row.groupRowCount || 3, 1];
			return [0, 0];
		},
		/** 表格合计行：出厂货款、库存金额、总运费的差额合计 */
		getTableSummary(param) {
			const { columns } = param;
			const sums = [];
			const diffRows = this.diffRows;
			const factoryPaymentSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.factoryPayment) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const stockAmountSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.inventoryDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			const totalFreightSum = format(
				_.reduce(diffRows, (acc, r) => add(acc, Number(r.freightDiff) || 0), 0),
				{ notation: 'fixed', precision: 2 }
			);
			columns.forEach((col, index) => {
				if (index === 0 || index === 1) sums.push('');
				else if (col.property === 'factoryPayment') sums.push(factoryPaymentSum);
				else if (col.property === 'stockAmount') sums.push(stockAmountSum);
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
		<el-table v-if="!summaryOnly" :data="tableData" border :row-class-name="tableRowClassName" :span-method="inboundSpanMethod" show-summary :summary-method="getTableSummary" style="width: 100%">
			<el-table-column label="入库单" width="100" fixed class-name="inbound-col">
				<template slot-scope="scope">
					<template v-if="scope.row.isGroupFirst">
						<div>入库单（{{ scope.row.groupIndex + 1 }}）</div>
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
.sub-label {
	font-size: 12px;
	color: #666;
	margin-top: 4px;
}
::v-deep .inbound-col {
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
