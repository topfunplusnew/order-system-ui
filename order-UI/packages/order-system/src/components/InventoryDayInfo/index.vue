<template>
	<div class="inventory-day-info">
		<a-spin :spinning="loading" tip="加载库存信息中...">
			<div v-if="inventoryList.length === 0 && !loading" class="empty-state">
				<a-empty description="暂无库存数据" />
			</div>
			<a-list v-else :data-source="inventoryList" :pagination="pagination" item-layout="vertical" size="large">
				<template #renderItem="{ item }">
					<a-list-item key="item.id">
						<template #actions>
							<span>
								<a-icon type="calendar" />
								{{ item.storeDate }}
							</span>
							<span v-if="item.checkState">
								<a-tag :color="getStatusColor(item.checkState)">
									{{ item.checkState }}
								</a-tag>
							</span>
						</template>
						<a-list-item-meta>
							<template #title>
								<span class="inventory-title">
									<a-icon type="database" />
									库存 #{{ item.id }}
									<a-tag v-if="item.storeHouseName" color="green" class="warehouse-tag">
										{{ item.storeHouseName }}
									</a-tag>
								</span>
							</template>
							<template #description>
								<div class="inventory-description">
									<!-- 基本信息 -->
									<div class="basic-info">
										<div v-if="item.supplier" class="info-row">
											<span class="label">供应商:</span>
											<span class="value supplier-value">{{ item.supplier }}</span>
										</div>
										<div v-if="item.goodsCompany" class="info-row">
											<span class="label">货物来源公司:</span>
											<span class="value">{{ item.goodsCompany }}</span>
										</div>
									</div>

									<!-- 陆运信息 -->
									<div v-if="item.landCarNo || item.landDriverName || item.landDriverTel" class="transport-section">
										<div class="section-title">
											<a-icon type="car" />
											陆运信息
										</div>
										<div class="transport-details">
											<div v-if="item.landCarNo" class="info-row">
												<span class="label">车牌号:</span>
												<span class="value">{{ item.landCarNo }}</span>
											</div>
											<div v-if="item.landDriverName" class="info-row">
												<span class="label">司机姓名:</span>
												<span class="value">{{ item.landDriverName }}</span>
											</div>
											<div v-if="item.landDriverTel" class="info-row">
												<span class="label">司机电话:</span>
												<span class="value">{{ item.landDriverTel }}</span>
											</div>
											<div v-if="item.landBankNo" class="info-row">
												<span class="label">银行卡号:</span>
												<span class="value">{{ item.landBankNo }}</span>
											</div>
											<div v-if="item.landBankName" class="info-row">
												<span class="label">开户行:</span>
												<span class="value">{{ item.landBankName }}</span>
											</div>
										</div>
									</div>

									<!-- 海运信息 -->
									<div v-if="item.seaCarNo || item.seaDriverName || item.seaDriverTel" class="transport-section">
										<div class="section-title">
											<a-icon type="global" />
											海运信息
										</div>
										<div class="transport-details">
											<div v-if="item.seaCarNo" class="info-row">
												<span class="label">柜号:</span>
												<span class="value">{{ item.seaCarNo }}</span>
											</div>
											<div v-if="item.seaDriverName" class="info-row">
												<span class="label">海运公司:</span>
												<span class="value">{{ item.seaDriverName }}</span>
											</div>
											<div v-if="item.seaDriverTel" class="info-row">
												<span class="label">公司电话:</span>
												<span class="value">{{ item.seaDriverTel }}</span>
											</div>
											<div v-if="item.seaBankNo" class="info-row">
												<span class="label">银行卡号:</span>
												<span class="value">{{ item.seaBankNo }}</span>
											</div>
											<div v-if="item.seaBankName" class="info-row">
												<span class="label">开户行:</span>
												<span class="value">{{ item.seaBankName }}</span>
											</div>
										</div>
									</div>

									<!-- 其他信息 -->
									<div class="additional-info">
										<div v-if="item.fleet" class="info-row">
											<span class="label">车队:</span>
											<span class="value">{{ item.fleet }}</span>
										</div>
										<div v-if="item.userName" class="info-row">
											<span class="label">录入员:</span>
											<span class="value">{{ item.userName }}</span>
										</div>
										<div v-if="item.totalLandFreight" class="info-row">
											<span class="label">陆运费总计:</span>
											<span class="value freight-value">¥{{ formatMoney(item.totalLandFreight) }}</span>
										</div>
										<div v-if="item.totalSeaFreight" class="info-row">
											<span class="label">海运费总计:</span>
											<span class="value freight-value">¥{{ formatMoney(item.totalSeaFreight) }}</span>
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
					tableName: BatchQueryTableName.INVENTORY,
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

	.inventory-title {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 16px;
		font-weight: 500;

		.warehouse-tag {
			margin-left: auto;
		}
	}

	.inventory-description {
		.info-row {
			display: flex;
			margin-bottom: 8px;

			.label {
				min-width: 100px;
				color: #666;
				font-weight: 500;
			}

			.value {
				flex: 1;
				color: #333;

				&.supplier-value {
					color: #1890ff;
					font-weight: 500;
				}

				&.freight-value {
					color: #52c41a;
					font-weight: 600;
				}
			}

			&.comments {
				.value {
					color: #666;
					font-style: italic;
				}
			}
		}

		.basic-info,
		.additional-info {
			margin: 12px 0;
		}

		.transport-section {
			margin: 16px 0;
			padding: 12px;
			background-color: #fafafa;
			border-radius: 6px;
			border-left: 3px solid #1890ff;

			.section-title {
				display: flex;
				align-items: center;
				gap: 6px;
				font-weight: 600;
				color: #1890ff;
				margin-bottom: 8px;
				font-size: 14px;
			}

			.transport-details {
				padding-left: 20px;

				.info-row {
					margin-bottom: 6px;

					.label {
						min-width: 80px;
						font-size: 13px;
					}
				}
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
