<script>
export default {
	name: 'INVENTORYDETAIL',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	methods: {
		handleProcess() {
			// 处理逻辑
			return Promise.resolve();
		},
		handleReject() {
			// 拒绝逻辑
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div class="inventory-detail">
		<el-card shadow="hover" size="mini" class="card-container">
			<el-descriptions title="库存详细信息" size="mini" :column="3" border>
				<el-descriptions-item label="供应商">{{ needToShowInfo.supplier || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="入库日期">
					{{ needToShowInfo.storeDate ? new Date(needToShowInfo.storeDate).toLocaleString() : '暂无日期' }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库">{{ needToShowInfo.storeHouseName || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="级别名称">{{ needToShowInfo.levelName || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="计量单位">{{ needToShowInfo.countingUnit || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="长度">{{ needToShowInfo.length || '0' }}</el-descriptions-item>
				<el-descriptions-item label="宽度">{{ needToShowInfo.width || '0' }}</el-descriptions-item>
				<el-descriptions-item label="厚度">{{ needToShowInfo.height || '0' }}</el-descriptions-item>
				<el-descriptions-item label="总片数">{{ needToShowInfo.pieces || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="每包片数">{{ needToShowInfo.piecesPerPack || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="包数">{{ needToShowInfo.packs || '0' }}</el-descriptions-item>
				<el-descriptions-item label="入库时片数">{{ needToShowInfo.stockNumber || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="库存">{{ needToShowInfo.actualPieces || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="吨位">{{ needToShowInfo.tonnage || '0' }} 吨</el-descriptions-item>
				<el-descriptions-item label="单价">{{ needToShowInfo.price || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="出厂货款">{{ needToShowInfo.paymentFactory || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="存货价">{{ needToShowInfo.paymentUnload || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="陆运单价">{{ needToShowInfo.landFreightPrice || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="陆运费">{{ needToShowInfo.landFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="海运费">{{ needToShowInfo.seaFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="杂费">{{ needToShowInfo.sundryCost || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="其他费用">{{ needToShowInfo.otherCost || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="总运费">{{ needToShowInfo.freight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="库存金额">{{ needToShowInfo.payments || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="利润">{{ needToShowInfo.profit || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="不含税利润">{{ needToShowInfo.profitNoTax || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.inventory-detail {
	padding: 20px;
	background-color: #f5f7fa;
	border-radius: 8px;
}

.card-container {
	border-radius: 8px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
	padding: 20px;
}
</style>
