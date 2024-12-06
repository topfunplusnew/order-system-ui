<!--订单页面-->
<template>
	<div class="app-container">
		<!--    表格列 数据大量展示-->
		<ElTableOrder :is-adjust-order="true" />

		<!-- 订单历史信息查看  mixin_order_orderHistory -->
		<OrderHistoryCheck
			:check-history-order-visible="checkHistoryOrderVisible"
			:checkcurrent-order-item-info="checkcurrentOrderItemInfo"
			:order-history-info-list="orderHistoryInfoList"
			:parse-time="parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}')"
			@close="closeOrderHistoryCheck"
		/>
	</div>
</template>

<script>
import ElTableOrder from '@/views/dashboard/components/goodsOrder/ElTableOrder.vue';
import OrderHistoryCheck from '@/views/dashboard/components/goodsOrder/OrderHistoryCheck.vue';
import { mapGetters } from 'vuex';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_order_Invoice } from '../../dashboard/mixins/order/order_Invoice';
import { mixin_order_base } from '../../dashboard/mixins/order/order_base';
import { mixin_order_orderHistory } from '../../dashboard/mixins/order/order_history';

export default {
	name: 'AdjustOrders',
	// 组件注册
	components: {
		OrderHistoryCheck,
		ElTableOrder
	},
	// 混入 订单逻辑分布在混入文件中
	mixins: [mixin_order_Invoice, mixin_order_orderHistory, mixin_order_base],
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
<style lang="scss">
//对于订单表格中的供应商的样式设计
.item {
	margin-right: 5px;
	/* 添加一些间距 */
	margin-top: 5px;
	cursor: pointer;

	&:hover {
		transform: scale(1.1);
		font-weight: bolder;
		color: #1ab394;
	}
}

.center {
	// 解决vue-code-diff对不齐和显示下拉标志问题
	max-height: 600px;
	overflow-y: auto;
	overflow-x: hidden;

	/* 样式穿透-起始行左右对齐，*/
	.d2h-code-side-line {
		height: 15px;
	}

	code.hljs {
		padding: 0;
	}

	// 删除行统计显示
	.d2h-code-side-linenumber {
		display: none;
	}

	.d2h-code-side-line {
		padding: unset;
	}

	.d2h-code-line-ctn {
		width: unset;
	}

	// 删除第一行的统计结果
	.d2h-info {
		display: none;
	}
}

.el-icon-arrow-down {
	font-size: 12px;
}
</style>
