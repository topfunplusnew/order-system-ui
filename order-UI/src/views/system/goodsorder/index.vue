<!--订单页面-->
<template>
	<div class="app-container">
		<!--    表格列 数据大量展示-->
		<ElTableOrder :is-adjust-order="false" />
	</div>
</template>

<script>
import ElTableOrder from '@/views/dashboard/components/goodsOrder/ElTableOrder.vue';
import { mapGetters } from 'vuex';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_order_Invoice } from '../../dashboard/mixins/order/order_Invoice';
import { mixin_order_orderHistory } from '../../dashboard/mixins/order/order_history';

export default {
	name: 'GoodsOrder',
	// 组件注册
	components: {
		ElTableOrder
	},
	// 混入 订单逻辑分布在混入文件中
	mixins: [mixin_order_Invoice, mixin_order_orderHistory],
	data() {
		return {};
	},
	computed: {
		...mapGetters(['orderItemList']), // 获取订单列表
		...mapGetters(['currentOrderInfo']) // 拿到暂存里的订单信息
	},
	methods: {
		parseTime
	}
};
</script>
<style lang="scss" scoped>
.el-icon-arrow-down {
	font-size: 12px;
}
</style>
