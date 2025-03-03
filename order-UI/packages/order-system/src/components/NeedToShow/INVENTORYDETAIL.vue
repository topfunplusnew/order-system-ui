<script>
export default {
	name: 'INVENTORYDETAIL',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	}
};
</script>

<template>
	<div class="inventory-detail">
		<el-card shadow="hover" class="card-container">
			<el-descriptions title="库存详细信息" :column="3" border>
				<el-descriptions-item label="供应商">{{ needToShowInfo.supplier || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="添加时间">{{ needToShowInfo.addtime || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="总运费单价">{{ needToShowInfo.allFreightPrice || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项陆运费之和">{{ needToShowInfo.allLandFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项海运费之和">{{ needToShowInfo.allSeaFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项吨位之和">{{ needToShowInfo.allTonnage || '0' }} 吨</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{ needToShowInfo.checkState || '未审核' }}</el-descriptions-item>
				<el-descriptions-item label="车队">{{ needToShowInfo.fleet || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="货物来源公司">{{ needToShowInfo.goodsCompany || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="陆运车牌">{{ needToShowInfo.landCarNo || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="陆地司机">
					{{ needToShowInfo.landDriverName || '暂无数据' }} /
					{{ needToShowInfo.landDriverTel || '暂无电话' }}
				</el-descriptions-item>
				<el-descriptions-item label="海运车牌">{{ needToShowInfo.seaCarNo || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="海运司机">
					{{ needToShowInfo.seaDriverName || '暂无数据' }} /
					{{ needToShowInfo.seaDriverTel || '暂无电话' }}
				</el-descriptions-item>
				<el-descriptions-item label="入库日期">
					{{ needToShowInfo.storeDate ? new Date(needToShowInfo.storeDate).toLocaleDateString() : '暂无日期' }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库">{{ needToShowInfo.storeHouseName || '暂无数据' }}</el-descriptions-item>
				<el-descriptions-item label="库存数量">{{ needToShowInfo.stockNumber || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="单价">{{ needToShowInfo.price || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="利润">{{ needToShowInfo.profit || '0' }} 元</el-descriptions-item>
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
