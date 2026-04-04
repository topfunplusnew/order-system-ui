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
					{{ warehouseData.outAmount !== undefined && warehouseData.outAmount !== null ? warehouseData.outAmount : '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="操作人">
					{{ formatValue(warehouseData.userName) }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>

		<el-card class="warehouse-card" id="in-card" size="mini" v-if="warehouseData.sourceInventoryDetail">
			<el-alert title="该入库信息为该出库信息详情的上游" type="info" show-icon class="mb-2" :closable="false" style="margin-bottom: 16px" />
			<INVENTORY :title="'出库关联入库信息'" :need-to-show-info="sourceInventoryInfo" />
		</el-card>
	</div>
</template>

<script>
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
// import VueSuperFlow from 'vue-super-flow';
import 'vue-super-flow/lib/index.css';

export default {
	name: 'WAREHOUSE',
	components: { INVENTORY },
	props: {
		warehouseData: {
			type: Object,
			default: () => ({})
		}
	},
	computed: {
		sourceInventoryInfo() {
			const detail = this.warehouseData.sourceInventoryDetail;
			if (!detail) {
				return {};
			}
			return {
				storeDate: detail.storeDate || detail.addtime || '',
				storeHouseName: detail.storeHouseName || this.warehouseData.storeHouseName || '',
				fleet: detail.fleet || '',
				landBankNo: detail.landBankNo || '',
				landCarNo: detail.landCarNo || '',
				seaCarNo: detail.seaCarNo || '',
				seaDriverName: detail.seaDriverName || '',
				userName: detail.userName || '',
				inventoryDetailList: [detail]
			};
		}
	},
	methods: {
		formatValue(val) {
			return val !== null && val !== undefined && val !== '' ? val : '暂无数据';
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
