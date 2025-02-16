<template>
	<el-dialog :close-on-click-modal="false" :show-close="false" title="原订单信息" :visible.sync="currentOrderItemInfoVisible" width="68%">
		<el-row>
			<el-card class="box-card" shadow="hover">
				<OrderInfos :orderInfo="currentOrderItemInfo" />
			</el-card>
			<el-card class="box-card" shadow="hover">
				<OrderDetailInfo :orderDetailInfoList="currentOrderItemInfo.orderDetailList" />
			</el-card>
		</el-row>
		<span slot="footer" class="dialog-footer">
			<el-button @click="close">取 消</el-button>
			<el-button type="primary" @click="close">确 定</el-button>
		</span>
	</el-dialog>
</template>
<script>
import OrderDetailInfo from '@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue';
import OrderInfos from './OrderInfos.vue';

export default {
	name: 'PrimativeOrderInfo',
	components: { OrderDetailInfo, OrderInfos },
	props: {
		currentOrderItemInfo: {},
		currentOrderItemInfoVisible: {}
	},
	methods: {
		close() {
			this.$emit('close');
		}
	}
};
</script>
