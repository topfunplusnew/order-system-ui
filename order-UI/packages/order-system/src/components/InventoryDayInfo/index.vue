<template>
	<div class="inventory-day-info">
		<a-spin :spinning="loading" tip="加载库存信息中...">
			<div v-if="inventoryList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无库存数据" />
			</div>
			<div v-else class="table-container">
				<!-- 表头 -->
				<div class="table-header">
					<div class="header-cell date-col">日期</div>
					<div class="header-cell warehouse-col">仓库</div>
					<div class="header-cell supplier-col">供应商</div>
					<div class="header-cell company-col">货物来源</div>
					<div class="header-cell transport-col">运输信息</div>
					<div class="header-cell freight-col">运费</div>
					<div class="header-cell status-col">状态</div>
					<div class="header-cell operator-col">操作员</div>
				</div>

				<!-- 表格内容 -->
				<div class="table-body">
					<div v-for="item in inventoryList" :key="item.id" class="table-row">
						<div class="table-cell date-col">
							{{ item.storeDate || '-' }}
						</div>
						<div class="table-cell warehouse-col">
							{{ item.storeHouseName || '-' }}
						</div>
						<div class="table-cell supplier-col">
							{{ item.supplier || '-' }}
						</div>
						<div class="table-cell company-col">
							{{ item.goodsCompany || '-' }}
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
						<div class="table-cell freight-col">
							<div v-if="item.totalLandFreight" class="freight-item">陆运: ¥{{ formatMoney(item.totalLandFreight) }}</div>
							<div v-if="item.totalSeaFreight" class="freight-item">海运: ¥{{ formatMoney(item.totalSeaFreight) }}</div>
						</div>
						<div class="table-cell status-col">
							<a-tag v-if="item.checkState" :color="getStatusColor(item.checkState)">
								{{ item.checkState }}
							</a-tag>
							<span v-else>-</span>
						</div>
						<div class="table-cell operator-col">
							<div v-if="item.userName">{{ item.userName }}</div>
							<div v-if="item.fleet" class="fleet-info">{{ item.fleet }}</div>
						</div>
					</div>
				</div>

				<!-- 分页 -->
				<div class="pagination-wrapper">
					<a-pagination v-bind="pagination" :total="inventoryList.length" @change="handlePageChange" @showSizeChange="handleSizeChange" />
				</div>
			</div>
		</a-spin>
	</div>
</template>

<script>
import { getBussinessInfoTodayList } from '@/api/system/goodsOrder';
import { BatchQueryTableName } from '@/api/tool/enums';

export default {
	name: 'InventoryDayInfo',
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
			inventoryList: [],
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
					this.fetchInventoryData();
				} else {
					this.inventoryList = [];
				}
			},
			immediate: true
		}
	},
	methods: {
		// 获取库存数据
		async fetchInventoryData() {
			if (!this.ids || this.ids.length === 0) {
				this.inventoryList = [];
				return;
			}

			this.loading = true;
			try {
				const params = {
					tableName: BatchQueryTableName.INVENTORY_MAIN,
					ids: this.ids
				};

				const response = await getBussinessInfoTodayList(params);
				this.inventoryList = response.data || [];
			} catch (error) {
				console.error('获取库存数据失败:', error);
				this.$message.error('获取库存数据失败');
				this.inventoryList = [];
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
		}
	}
};
</script>

<style scoped lang="scss">
.inventory-day-info {
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

		.warehouse-col {
			width: 100px;
			min-width: 100px;
			flex-shrink: 0;
		}

		.supplier-col {
			width: 120px;
			min-width: 120px;
			flex-shrink: 0;
			color: #1890ff;
			font-weight: 500;
		}

		.company-col {
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

		.freight-col {
			width: 140px;
			min-width: 140px;
			flex-shrink: 0;
			flex-direction: column;
			align-items: flex-start;

			.freight-item {
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

			.fleet-info {
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
