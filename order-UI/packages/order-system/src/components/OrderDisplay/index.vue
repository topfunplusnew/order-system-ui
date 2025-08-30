<script>
import OrderInfos from '@/views/dashboard/components/goodsOrder/OrderInfos.vue';
import OrderDetailInfo from '@/views/dashboard/components/goodsOrder/OrderDetailInfo.vue';

export default {
	name: 'OrderDisplay',
	components: { OrderInfos, OrderDetailInfo },
	props: {
		// 订单表头信息
		orderInfo: {
			type: Object,
			default: () => ({})
		},
		// 订单明细列表
		orderDetailInfoList: {
			type: Array,
			default: () => []
		},
		// 是否禁用明细里的操作列（查看场景默认禁用）
		ban: {
			type: Boolean,
			default: true
		},
		// 可选：卡片最大高度，便于在弹窗中使用
		maxBodyHeight: {
			type: [Number, String],
			default: '70vh'
		}
	},
	methods: {
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div class="order-display-wrapper">
		<el-card class="order-display-card" shadow="never">
			<div slot="header" class="header">
				<div class="title">
					<i class="el-icon-document"></i>
					<span>订单信息</span>
				</div>
				<div class="meta">
					<span v-if="orderInfo && orderInfo.orderDate">订单日期：{{ orderInfo.orderDate }}</span>
				</div>
			</div>

			<div class="body" :style="{ maxHeight: typeof maxBodyHeight === 'number' ? maxBodyHeight + 'px' : maxBodyHeight }">
				<!-- 表头信息 -->
				<OrderInfos :orderInfo="orderInfo || {}" />
				<el-divider></el-divider>
				<!-- 明细表格（内部自带合计行） -->
				<OrderDetailInfo :orderDetailInfoList="orderDetailInfoList || []" :ban="ban" />
			</div>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.order-display-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.order-display-card {
	border: 1px solid #ebeef5;
	border-radius: 8px;

	::v-deep .el-card__header {
		padding: 12px 16px;
		background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
		border-bottom: 1px solid #ebeef5;
	}
}

.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;

	.title {
		display: flex;
		align-items: center;
		gap: 8px;
		font-weight: 600;
		color: #303133;

		i {
			color: #409eff;
		}
	}

	.meta {
		display: flex;
		gap: 12px;
		color: #909399;
		font-size: 12px;
	}
}

.gap-l {
	margin-left: 6px;
}

.body {
	overflow: auto;
	padding: 12px 12px 4px 12px;
}

.stats {
	margin-bottom: 8px;

	.num {
		color: #f56c6c;
	}

	.sep {
		margin: 0 8px;
		color: #dcdfe6;
	}
}

@media screen and (max-width: 768px) {
	.header {
		flex-direction: column;
		align-items: flex-start;
	}

	.meta {
		flex-wrap: wrap;
	}
}
</style>
