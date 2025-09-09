<template>
	<div class="warehouse-detail">
		<el-card class="warehouse-card" id="out-card" size="mini">
			<el-descriptions title="出库详情" size="mini" :column="5" border>
				<el-descriptions-item label="仓库">
					{{ formatValue(warehouseData.storeHouseName) }}
				</el-descriptions-item>
				<el-descriptions-item label="出库日期">
					{{ formatValue(warehouseData.outDate) }}
				</el-descriptions-item>
				<el-descriptions-item label="出库类型">
					{{ formatValue(warehouseData.outDirection) }}
				</el-descriptions-item>
				<el-descriptions-item label="出库数量">
					{{ warehouseData.outAmount !== undefined && warehouseData.outAmount !== null ? warehouseData.outAmount + ' 件' : '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="操作人">
					{{ formatValue(warehouseData.userName) }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ formatValue(warehouseData.remark) }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>

		<el-card class="warehouse-card" id="in-card" size="mini" v-if="warehouseData.sourceInventoryDetail">
			<el-alert title="该入库信息为该出库信息详情的上游" type="info" show-icon class="mb-2" :closable="false" style="margin-bottom: 16px" />
			<el-descriptions title="出库关联入库信息" size="mini" :column="5" border>
				<el-descriptions-item label="供应商">
					{{ formatValue(warehouseData.sourceInventoryDetail.supplier) }}
				</el-descriptions-item>
				<el-descriptions-item label="级别名称">
					{{ formatValue(warehouseData.sourceInventoryDetail.levelName) }}
				</el-descriptions-item>
				<el-descriptions-item label="计量单位">
					{{ formatValue(warehouseData.sourceInventoryDetail.countingUnit) }}
				</el-descriptions-item>
				<el-descriptions-item label="厚度">
					{{
						warehouseData.sourceInventoryDetail.height !== undefined && warehouseData.sourceInventoryDetail.height !== null
							? warehouseData.sourceInventoryDetail.height + ' mm'
							: '暂无数据'
					}}
				</el-descriptions-item>
				<el-descriptions-item label="长度">
					{{
						warehouseData.sourceInventoryDetail.length !== undefined && warehouseData.sourceInventoryDetail.length !== null
							? warehouseData.sourceInventoryDetail.length + ' mm'
							: '暂无数据'
					}}
				</el-descriptions-item>
				<el-descriptions-item label="宽度">
					{{ warehouseData.sourceInventoryDetail.width !== undefined && warehouseData.sourceInventoryDetail.width !== null ? warehouseData.sourceInventoryDetail.width + ' mm' : '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="每包片数">
					{{ formatValue(warehouseData.sourceInventoryDetail.piecesPerPack) }}
				</el-descriptions-item>
				<el-descriptions-item label="包数">
					{{ formatValue(warehouseData.sourceInventoryDetail.packs) }}
				</el-descriptions-item>
				<el-descriptions-item label="出厂片数">
					{{ formatValue(warehouseData.sourceInventoryDetail.pieces) }}
				</el-descriptions-item>
				<el-descriptions-item label="出厂单价">
					{{
						warehouseData.sourceInventoryDetail.price !== undefined && warehouseData.sourceInventoryDetail.price !== null
							? fix2(warehouseData.sourceInventoryDetail.price) + ' 元'
							: '暂无数据'
					}}
				</el-descriptions-item>
				<el-descriptions-item label="出厂是否含税">
					<el-tag disable-transitions>{{ boolTag(warehouseData.sourceInventoryDetail.isIncludeTaxFactory) }}</el-tag>
				</el-descriptions-item>
				<el-descriptions-item label="杂费">
					{{ formatValue(warehouseData.sourceInventoryDetail.sundryCost) }}
				</el-descriptions-item>
				<el-descriptions-item label="出厂货款">
					{{ formatValue(warehouseData.sourceInventoryDetail.paymentFactory) }}
				</el-descriptions-item>
				<el-descriptions-item label="存货价">
					{{ formatValue(warehouseData.sourceInventoryDetail.paymentUnload) }}
				</el-descriptions-item>
				<el-descriptions-item label="入库片数">
					{{ formatValue(warehouseData.sourceInventoryDetail.stockNumber) }}
				</el-descriptions-item>
				<el-descriptions-item label="库存是否含税">
					<el-tag disable-transitions>{{ boolTag(warehouseData.sourceInventoryDetail.isIncludeTaxSale) }}</el-tag>
				</el-descriptions-item>
				<el-descriptions-item label="库存金额">
					{{ formatValue(warehouseData.sourceInventoryDetail.payments) }}
				</el-descriptions-item>
				<el-descriptions-item label="误差">
					{{ formatValue(warehouseData.sourceInventoryDetail.erro) }}
				</el-descriptions-item>
				<el-descriptions-item label="吨位">
					{{ formatValue(warehouseData.sourceInventoryDetail.tonnage) }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运费单价">
					{{ formatValue(warehouseData.sourceInventoryDetail.landFreightPrice) }}
				</el-descriptions-item>
				<el-descriptions-item label="加费">
					{{ formatValue(warehouseData.sourceInventoryDetail.additionalFees) }}
				</el-descriptions-item>
				<el-descriptions-item label="陆运费">
					{{ formatValue(warehouseData.sourceInventoryDetail.landFreight) }}
				</el-descriptions-item>
				<el-descriptions-item label="海运费">
					{{ formatValue(warehouseData.sourceInventoryDetail.seaFreight) }}
				</el-descriptions-item>
				<el-descriptions-item label="总运费">
					{{ formatValue(warehouseData.sourceInventoryDetail.freight) }}
				</el-descriptions-item>
				<el-descriptions-item label="其他费用">
					{{ formatValue(warehouseData.sourceInventoryDetail.otherCost) }}
				</el-descriptions-item>
				<el-descriptions-item label="利润">
					{{ formatValue(warehouseData.sourceInventoryDetail.profit) }}
				</el-descriptions-item>
				<el-descriptions-item label="不含税利润">
					{{ formatValue(warehouseData.sourceInventoryDetail.profitNoTax) }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ formatValue(warehouseData.sourceInventoryDetail.comments) }}
				</el-descriptions-item>
				<el-descriptions-item label="物流利润">
					{{ formatValue(warehouseData.sourceInventoryDetail.logisticsProfit) }}
				</el-descriptions-item>
				<el-descriptions-item label="客户佣金">
					{{ formatValue(warehouseData.sourceInventoryDetail.customerCommission) }}
				</el-descriptions-item>
				<el-descriptions-item label="厂家佣金">
					{{ formatValue(warehouseData.sourceInventoryDetail.factoryCommission) }}
				</el-descriptions-item>
				<el-descriptions-item label="计提厂家返利金额">
					{{ formatValue(warehouseData.sourceInventoryDetail.factoryRebateAmount) }}
				</el-descriptions-item>
				<el-descriptions-item label="计提厂家降价金额">
					{{ formatValue(warehouseData.sourceInventoryDetail.factoryDiscountAmount) }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<script>
import { fix_2 } from '../../api/tool/format';
// import VueSuperFlow from 'vue-super-flow';
import 'vue-super-flow/lib/index.css';

export default {
	name: 'WAREHOUSE',
	components: {},
	props: {
		warehouseData: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {};
	},
	methods: {
		formatValue(val) {
			return val !== null && val !== undefined && val !== '' ? val : '暂无数据';
		},
		boolTag(val) {
			if (val === 0) return '否';
			if (val === 1) return '是';
			return '未知';
		},
		fix2(val) {
			if (val === null || val === undefined || val === '') return '暂无数据';
			return fix_2(val);
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

<style scoped lang="scss">
.warehouse-detail {
	padding: 20px;
}

.warehouse-card {
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.el-descriptions-item__label {
	font-weight: bold;
	color: #333;
}

.el-descriptions-item__content {
	color: #666;
}
</style>
