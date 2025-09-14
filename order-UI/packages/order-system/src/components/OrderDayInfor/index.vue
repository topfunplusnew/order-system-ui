<template>
	<div class="order-day-info">
		<a-spin :spinning="loading" tip="加载订单信息中...">
			<div v-if="orderList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无订单数据" />
			</div>
			<a-list v-else :data-source="orderList" :pagination="pagination" item-layout="vertical" size="large">
				<template #renderItem="{ item }">
					<a-list-item key="item.id">
						<template #actions>
							<span>
								<a-icon type="calendar" />
								{{ item.orderDate }}
							</span>
							<span>
								<a-icon type="dollar" />
								{{ formatMoney(item.allPayments) }}
							</span>
							<span v-if="item.checkState">
								<a-tag :color="getStatusColor(item.checkState)">
									{{ item.checkState }}
								</a-tag>
							</span>
						</template>

						<a-list-item-meta>
							<template #title>
								<span class="order-title">
									<a-icon type="file-text" />
									订单 #{{ item.id }}
									<a-tag v-if="item.customer" color="blue" class="customer-tag">
										{{ item.customer }}
									</a-tag>
								</span>
							</template>
							<template #description>
								<div class="order-description">
									<!-- 供应商/仓库信息 -->
									<div v-if="item.supplierNames" class="info-row">
										<span class="label">供应商/仓库:</span>
										<span class="value">{{ item.supplierNames }}</span>
									</div>

									<!-- 运输信息 -->
									<div class="transport-info">
										<!-- 陆运信息 -->
										<div v-if="item.landCarNo || item.landDriverName" class="info-row">
											<span class="label">陆运:</span>
											<span class="value">
												<span v-if="item.landCarNo">车牌: {{ item.landCarNo }}</span>
												<span v-if="item.landDriverName" class="driver-info">
													司机: {{ item.landDriverName }}
													<span v-if="item.landDriverTel">({{ item.landDriverTel }})</span>
												</span>
												<span v-if="item.landFreight" class="freight-info">运费: ¥{{ formatMoney(item.landFreight) }}</span>
											</span>
										</div>

										<!-- 海运信息 -->
										<div v-if="item.seaCarNo || item.seaDriverName" class="info-row">
											<span class="label">海运:</span>
											<span class="value">
												<span v-if="item.seaCarNo">柜号: {{ item.seaCarNo }}</span>
												<span v-if="item.seaDriverName" class="driver-info">
													公司: {{ item.seaDriverName }}
													<span v-if="item.seaDriverTel">({{ item.seaDriverTel }})</span>
												</span>
												<span v-if="item.seaFreight" class="freight-info">运费: ¥{{ formatMoney(item.seaFreight) }}</span>
											</span>
										</div>
									</div>

									<!-- 其他信息 -->
									<div class="additional-info">
										<div v-if="item.fleet" class="info-row">
											<span class="label">车队:</span>
											<span class="value">{{ item.fleet }}</span>
										</div>
										<div v-if="item.saleManager" class="info-row">
											<span class="label">销售经理:</span>
											<span class="value">{{ item.saleManager }}</span>
										</div>
										<div v-if="item.userName" class="info-row">
											<span class="label">录入员:</span>
											<span class="value">{{ item.userName }}</span>
										</div>
									</div>

									<!-- 财务信息 -->
									<div class="financial-info">
										<div v-if="item.allProfit" class="info-row">
											<span class="label">利润(含税):</span>
											<span class="value profit-value">¥{{ formatMoney(item.allProfit) }}</span>
										</div>
										<div v-if="item.allProfitNoTax" class="info-row">
											<span class="label">利润(不含税):</span>
											<span class="value profit-value">¥{{ formatMoney(item.allProfitNoTax) }}</span>
										</div>
										<div v-if="item.allTonnage" class="info-row">
											<span class="label">总吨位:</span>
											<span class="value">{{ item.allTonnage }} 吨</span>
										</div>
									</div>

									<!-- 备注 -->
									<div v-if="item.comments" class="info-row comments">
										<span class="label">备注:</span>
										<span class="value">{{ item.comments }}</span>
									</div>
								</div>
							</template>
						</a-list-item-meta>
					</a-list-item>
				</template>
			</a-list>
		</a-spin>
	</div>
</template>

<script>
import { getBussinessInfoTodayList } from '@/api/system/goodsOrder';
import { BatchQueryTableName } from '@/api/tool/enums';

export default {
	name: 'OrderDayInfo',
	props: {
		ids: {
			type: Array,
			required: true,
			default: () => []
		}
	},
	data() {
		return {
			loading: false,
			orderList: [],
			pagination: {
				pageSize: 10,
				showSizeChanger: true,
				showQuickJumper: true,
				showTotal: total => `共 ${total} 条数据`
			}
		};
	},
	watch: {
		ids: {
			handler(newIds) {
				if (newIds && newIds.length > 0) {
					this.fetchOrderData();
				} else {
					this.orderList = [];
				}
			},
			immediate: true
		}
	},
	methods: {
		// 获取订单数据
		async fetchOrderData() {
			if (!this.ids || this.ids.length === 0) {
				this.orderList = [];
				return;
			}

			this.loading = true;
			try {
				const params = {
					tableName: BatchQueryTableName.GOODS_ORDER,
					ids: this.ids
				};

				const response = await getBussinessInfoTodayList(params);
				this.orderList = response.data || [];
			} catch (error) {
				console.error('获取订单数据失败:', error);
				this.$message.error('获取订单数据失败');
				this.orderList = [];
			} finally {
				this.loading = false;
			}
		},

		// 格式化金额
		formatMoney(value) {
			if (!value && value !== 0) return '-';
			return Number(value).toLocaleString('zh-CN', {
				minimumFractionDigits: 2,
				maximumFractionDigits: 2
			});
		},

		// 获取状态颜色
		getStatusColor(status) {
			const statusColors = {
				待提交: 'blue',
				审核中: 'orange',
				通过: 'green',
				未通过: 'red',
				驳回: 'volcano',
				作废: 'purple'
			};
			return statusColors[status] || 'default';
		}
	}
};
</script>

<style scoped lang="scss">
.order-day-info {
	width: 100%;

	.empty-state {
		text-align: center;
		padding: 40px;
	}

	.order-title {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 16px;
		font-weight: 500;

		.customer-tag {
			margin-left: auto;
		}
	}

	.order-description {
		.info-row {
			display: flex;
			margin-bottom: 8px;

			.label {
				min-width: 80px;
				color: #666;
				font-weight: 500;
			}

			.value {
				flex: 1;
				color: #333;
			}

			&.comments {
				.value {
					color: #666;
					font-style: italic;
				}
			}
		}

		.transport-info,
		.additional-info,
		.financial-info {
			margin: 12px 0;

			.driver-info,
			.freight-info {
				margin-left: 8px;

				&::before {
					content: ' | ';
					color: #ccc;
				}
			}

			.profit-value {
				font-weight: 600;
				color: #52c41a;
			}
		}
	}
}

// Ant Design Vue 样式定制
::v-deep .ant-list-item {
	padding: 16px 24px;
	border-bottom: 1px solid #f0f0f0;

	&:hover {
		background-color: #fafafa;
	}
}

::v-deep .ant-list-item-meta-title {
	margin-bottom: 8px;
}

::v-deep .ant-list-item-action {
	margin-left: 16px;
}

::v-deep .ant-tag {
	margin: 0 4px;
}
</style>
