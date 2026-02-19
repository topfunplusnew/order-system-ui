<script>
/**
 * 入库管理变动详情模板
 * compareData 为 getByIds 返回的 data 数组
 * originalInfo/changedInfo 含 storeDate、storeHouseName、inventoryDetailList、allLandFreight 等
 */
import { format, subtract } from 'mathjs';
import _ from 'lodash';
import { AGGREGATOR_MAP } from '@/utils/fundChangeAggregators';
import { INVENTORY_MAIN_COLUMNS } from '@/utils/fundChangeExcelColumns';

export default {
	name: 'InventoryChangeTemplate',
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
			return INVENTORY_MAIN_COLUMNS.map(c => (c.aggregator ? c : { ...c, showSummary: false }));
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
			const firstDetail = _.get(info, 'inventoryDetailList[0]', {});
			const list = info.inventoryDetailList || [];
			const factoryPay = this.sumDetailField(list, 'paymentFactory');
			const stockAmt = this.calcStockAmount(list);
			const totalFreight = Number(info.allLandFreight || 0) + Number(info.allSeaFreight || 0);
			return {
				status: '已入库',
				inboundTime: info.storeDate ? (info.storeDate + '').slice(0, 10) : '',
				warehouse: info.storeHouseName,
				truckPlate: info.landCarNo,
				seaCabinetNo: info.seaCarNo || '',
				seaCompany: info.seaBankName || '',
				supplierName: firstDetail.supplier || '',
				gradeName: firstDetail.levelName || '',
				countingUnit: firstDetail.countingUnit || '',
				thickness: firstDetail.height,
				length: firstDetail.length,
				width: firstDetail.width,
				piecesPerPack: firstDetail.piecesPerPack,
				packs: firstDetail.packs,
				factoryPieces: firstDetail.actualPieces ?? firstDetail.stockNumber,
				factoryUnitPrice: firstDetail.price,
				factoryTaxFlag: firstDetail.isIncludeTaxFactory ? '含税' : '不含税',
				sundryCost: firstDetail.sundryCost ?? info.sundryCost,
				factoryPayment: factoryPay,
				stockQuantity: firstDetail.stockNumber,
				unloadPrice: firstDetail.paymentUnload,
				stockTaxFlag: firstDetail.isIncludeTaxSale ? '含税' : '不含税',
				stockAmount: format(stockAmt, { notation: 'fixed', precision: 2 }),
				erro: firstDetail.erro,
				tonnage: info.allTonnage,
				landFreightPrice: firstDetail.landFreightPrice,
				additionalFees: info.additionalFees ?? firstDetail.additionalFees,
				landFreight: info.allLandFreight,
				seaFreight: info.allSeaFreight,
				totalFreight: format(totalFreight, { notation: 'fixed', precision: 2 }),
				otherCost: firstDetail.otherCost,
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
		mapAfterRow(info) {
			return this.mapBeforeRow(info);
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
		buildDiffFields(original, changed, _record) {
			const inventoryDiff = this.calcInventoryDiff(original.inventoryDetailList, changed.inventoryDetailList);
			const supplierDiff = this.sumOrderDetailDiff(original.inventoryDetailList || [], changed.inventoryDetailList || [], 'paymentFactory');
			const freightDiff = this.calculateFieldDiff(Number(changed.allLandFreight || 0) + Number(changed.allSeaFreight || 0), Number(original.allLandFreight || 0) + Number(original.allSeaFreight || 0));
			return { inventoryDiff, supplierDiff, freightDiff };
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
