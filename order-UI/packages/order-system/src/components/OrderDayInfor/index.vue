<template>
	<div class="order-day-info">
		<a-spin :spinning="loading" tip="加载订单信息中...">
			<div v-if="orderList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无订单数据" />
			</div>
			<div v-else class="table-container">
				<!-- 表头 -->
				<div class="table-header">
					<div class="header-cell date-col">日期</div>
					<div class="header-cell customer-col">客户</div>
					<div class="header-cell supplier-col">供应商/仓库</div>
					<div class="header-cell transport-col">运输信息</div>
					<div class="header-cell weight-col">重量</div>
					<div class="header-cell amount-col">金额</div>
					<div class="header-cell profit-col">利润</div>
					<div class="header-cell status-col">状态</div>
					<div class="header-cell operator-col">操作员</div>
				</div>

				<!-- 表格内容 -->
				<div class="table-body">
					<div v-for="item in orderList" :key="item.id" class="table-row">
						<div class="table-cell date-col">
							{{ item.orderDate || '-' }}
						</div>
						<div class="table-cell customer-col">
							{{ item.customer || '-' }}
						</div>
						<div class="table-cell supplier-col">
							{{ item.supplierNames || '-' }}
						</div>
						<div class="table-cell transport-col">
							<div class="transport-info">
								<div v-if="item.landCarNo || item.landDriverName" class="transport-line">
									<span class="transport-type">陆运:</span>
									<span v-if="item.landCarNo">{{ item.landCarNo }}</span>
									<span v-if="item.landDriverName">{{ item.landDriverName }}</span>
									<span v-if="item.landDriverTel">({{ item.landDriverTel }})</span>
								</div>
								<div v-if="item.seaCarNo || item.seaDriverName" class="transport-line">
									<span class="transport-type">海运:</span>
									<span v-if="item.seaCarNo">{{ item.seaCarNo }}</span>
									<span v-if="item.seaDriverName">{{ item.seaDriverName }}</span>
									<span v-if="item.seaDriverTel">({{ item.seaDriverTel }})</span>
								</div>
							</div>
						</div>
						<div class="table-cell weight-col">
							{{ item.allTonnage ? `${item.allTonnage}吨` : '-' }}
						</div>
						<div class="table-cell amount-col">
							{{ formatMoney(item.allPayments) }}
						</div>
						<div class="table-cell profit-col">
							<div v-if="item.allProfit" class="profit-item">含税: ¥{{ formatMoney(item.allProfit) }}</div>
							<div v-if="item.allProfitNoTax" class="profit-item">不含税: ¥{{ formatMoney(item.allProfitNoTax) }}</div>
						</div>
						<div class="table-cell status-col">
							<a-tag v-if="item.checkState" :color="getStatusColor(item.checkState)">
								{{ item.checkState }}
							</a-tag>
							<span v-else>-</span>
						</div>
						<div class="table-cell operator-col">
							<div v-if="item.userName">{{ item.userName }}</div>
							<div v-if="item.saleManager" class="sale-manager">{{ item.saleManager }}</div>
						</div>
					</div>
				</div>

				<!-- 分页 -->
				<div class="pagination-wrapper">
					<a-pagination v-bind="pagination" :total="orderList.length" @change="handlePageChange" @showSizeChange="handleSizeChange" />
				</div>
			</div>
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
		},

		// 分页改变
		handlePageChange(page, pageSize) {
			this.pagination.current = page;
			this.pagination.pageSize = pageSize;
		},

		// 页大小改变
		handleSizeChange(current, size) {
			this.pagination.current = 1;
			this.pagination.pageSize = size;
		},
		handleReject() {
			return Promise.resolve();
		},
		handleProcess() {
			return Promise.resolve();
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

	.table-container {
		border: 1px solid #e8e8e8;
		border-radius: 4px;
		overflow: hidden;
		background: #fff;

		.table-header {
			display: flex;
			background: #fafafa;
			border-bottom: 1px solid #e8e8e8;

			.header-cell {
				padding: 12px 8px;
				font-weight: 600;
				color: #262626;
				border-right: 1px solid #e8e8e8;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 13px;

				&:last-child {
					border-right: none;
				}
			}
		}

		.table-body {
			.table-row {
				display: flex;
				border-bottom: 1px solid #f0f0f0;

				&:hover {
					background-color: #f5f5f5;
				}

				&:last-child {
					border-bottom: none;
				}

				.table-cell {
					padding: 8px;
					border-right: 1px solid #f0f0f0;
					display: flex;
					align-items: center;
					font-size: 12px;
					line-height: 1.4;
					word-break: break-word;

					&:last-child {
						border-right: none;
					}
				}
			}
		}

		// 列宽定义
		.date-col {
			width: 80px;
			min-width: 80px;
			flex-shrink: 0;
			justify-content: center;
		}

		.customer-col {
			width: 120px;
			min-width: 120px;
			flex-shrink: 0;
		}

		.supplier-col {
			width: 150px;
			min-width: 150px;
			flex-shrink: 0;
		}

		.transport-col {
			width: 200px;
			min-width: 200px;
			flex-shrink: 0;
			flex-direction: column;
			align-items: flex-start;

			.transport-info {
				width: 100%;

				.transport-line {
					margin-bottom: 2px;
					font-size: 11px;

					&:last-child {
						margin-bottom: 0;
					}

					.transport-type {
						color: #666;
						font-weight: 500;
						margin-right: 4px;
					}
				}
			}
		}

		.weight-col {
			width: 80px;
			min-width: 80px;
			flex-shrink: 0;
			justify-content: center;
		}

		.amount-col {
			width: 100px;
			min-width: 100px;
			flex-shrink: 0;
			justify-content: flex-end;
			color: #1890ff;
			font-weight: 500;
		}

		.profit-col {
			width: 150px;
			min-width: 150px;
			flex-shrink: 0;
			flex-direction: column;
			align-items: flex-start;

			.profit-item {
				font-size: 11px;
				color: #52c41a;
				font-weight: 500;
				margin-bottom: 2px;

				&:last-child {
					margin-bottom: 0;
				}
			}
		}

		.status-col {
			width: 80px;
			min-width: 80px;
			flex-shrink: 0;
			justify-content: center;
		}

		.operator-col {
			width: 100px;
			min-width: 100px;
			flex-shrink: 0;
			flex-direction: column;
			align-items: flex-start;

			.sale-manager {
				font-size: 11px;
				color: #666;
			}
		}

		.pagination-wrapper {
			padding: 16px;
			text-align: center;
			border-top: 1px solid #f0f0f0;
			background: #fafafa;
		}
	}
}

// Ant Design Vue 样式覆盖
::v-deep .ant-tag {
	margin: 0;
	font-size: 11px;
	padding: 2px 6px;
	border-radius: 2px;
}

::v-deep .ant-pagination {
	.ant-pagination-item {
		border-radius: 2px;
	}
}
</style>
