<script>
export default {
	name: 'INVENTORY',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	}
};
</script>

<template>
	<div class="inventory-container">
		<el-card class="inventory-card">
			<el-descriptions title="库存信息" border column="3" :labelStyle="{ width: '150px' }">
				<el-descriptions-item label="供应商">{{ needToShowInfo.supplier || '-' }}</el-descriptions-item>
				<el-descriptions-item label="总运费单价">{{ needToShowInfo.allFreightPrice || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项陆运费之和">{{ needToShowInfo.allLandFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项海运费之和">{{ needToShowInfo.allSeaFreight || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="子项吨位之和">{{ needToShowInfo.allTonnage || '0' }} 吨</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{ needToShowInfo.checkState || '-' }}</el-descriptions-item>
				<el-descriptions-item label="审核人编号">{{ needToShowInfo.checkUserId || '-' }}</el-descriptions-item>
				<el-descriptions-item label="车队">{{ needToShowInfo.fleet || '-' }}</el-descriptions-item>
				<el-descriptions-item label="货物来源公司">{{ needToShowInfo.goodsCompany || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运银行账号">{{ needToShowInfo.landBankNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运车牌">{{ needToShowInfo.landCarNo || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆地司机姓名">{{ needToShowInfo.landDriverName || '-' }}</el-descriptions-item>
				<el-descriptions-item label="陆运司机电话">{{ needToShowInfo.landDriverTel || '-' }}</el-descriptions-item>
				<el-descriptions-item label="入库日期">
					{{ needToShowInfo.storeDate ? new Date(needToShowInfo.storeDate).toLocaleDateString() : '-' }}
				</el-descriptions-item>
				<el-descriptions-item label="仓库名称">{{ needToShowInfo.storeHouseName || '-' }}</el-descriptions-item>
				<el-descriptions-item label="库存数量">{{ needToShowInfo.stockNumber || '0' }} 片</el-descriptions-item>
				<el-descriptions-item label="单价">{{ needToShowInfo.price || '0' }} 元</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>

			<!--      库存个体信息-->
			<el-table :data="needToShowInfo.inventoryDetailList" stripe style="width: 100%">
				<el-table-column prop="storeHouseName" label="仓库名称" width="150" />
				<el-table-column prop="storeDate" label="入库日期" width="180">
					<template #default="scope">{{ new Date(scope.row.storeDate).toLocaleDateString() }}</template>
				</el-table-column>
				<el-table-column prop="supplier" label="供应商" width="150" />
				<el-table-column prop="levelName" label="等级名称" width="200" />
				<el-table-column prop="stockNumber" label="库存数量" width="120">
					<template #default="scope">{{ scope.row.stockNumber }} {{ scope.row.countingUnit }}</template>
				</el-table-column>
				<el-table-column prop="price" label="单价" width="120">
					<template #default="scope">{{ scope.row.price }} 元</template>
				</el-table-column>
				<el-table-column prop="landFreight" label="陆运费" width="120">
					<template #default="scope">{{ scope.row.landFreight || '0' }} 元</template>
				</el-table-column>
				<el-table-column prop="seaFreight" label="海运费" width="120">
					<template #default="scope">{{ scope.row.seaFreight || '0' }} 元</template>
				</el-table-column>
				<el-table-column prop="profit" label="利润" width="150">
					<template #default="scope">{{ scope.row.profit || '0' }} 元</template>
				</el-table-column>
				<el-table-column prop="factoryCommission" label="厂家佣金" width="150">
					<template #default="scope">
						<el-tag size="small">{{ scope.row.factoryCommission || '无' }}</el-tag>
					</template>
				</el-table-column>
				<el-table-column prop="comments" label="备注" width="150">
					<template #default="scope">
						<el-tag size="small">{{ scope.row.comments || '无' }}</el-tag>
					</template>
				</el-table-column>
			</el-table>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.inventory-container {
	padding: 20px;
	background-color: #f5f7fa;
}

.inventory-card {
	border-radius: 8px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.el-descriptions-item__label {
	font-weight: bold;
	color: #606266;
}
</style>
