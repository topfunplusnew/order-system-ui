<script>
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';
import { fix } from '../../../../api/tool/format';
import { getGoodsOrder } from '@/api/system/goodsOrder';
import OrderDisplay from '@/components/OrderDisplay/index.vue';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';

export default {
	name: 'InvoiceItem',
	components: { EllipsisText },
	mixins: [common_dialog],
	props: {
		invoice: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {
			visible: false
		};
	},
	computed: {
		// 可能的订单ID来源：orderId / sourceId / params.sourceId / params.orderId
		invoiceOrderId() {
			if (!this.invoice) return null;
			return this.invoice.isOrderTax || null;
		},

		amount() {
			if (!this.invoice || Object.keys(this.invoice).length === 0) {
				return '无';
			}
			return fix(this.invoice.ticketPointAmount);
		},
		// 格式化票点显示
		formattedTicketPoint() {
			if (!this.invoice || !this.invoice.ticketPoint) return '0';
			return Number(this.invoice.ticketPoint).toFixed(3);
		},
		// 格式化开票金额显示
		formattedInvoiceAmount() {
			if (!this.invoice || !this.invoice.invoiceAmount) return '0';
			return fix(this.invoice.invoiceAmount);
		}
	},
	mounted() {
		console.log('InvoiceItem mounted invoice:', this.invoice);
	},
	methods: {
		fix,
		// 打开并联查订单
		openOrder(orderId) {
			if (!orderId) {
				this.$message.warn('无关联订单ID');
				return;
			}
			getGoodsOrder(orderId)
				.then(res => {
					if (!res || !res.data) {
						this.$message.error('获取订单信息失败');
						return;
					}
					// 使用 openDialog 打开 OrderDisplay 组件查看订单详情
					this.openDialog(
						OrderDisplay,
						'查看订单信息',
						'700px',
						{
							orderInfo: res.data,
							orderDetailInfoList: res.data.orderDetailList || []
						},
						false
					);
				})
				.catch(err => {
					console.error('getGoodsOrder error', err);
					this.$message.error('查询订单失败');
				});
		},
		handleCheckInvoice() {
			this.$refs.invoiceItem.classList.add('active');
			this.visible = true;
		},
		handleClose() {
			this.$refs.invoiceItem.classList.remove('active');
			this.visible = false;
		}
	}
};
</script>

<template>
	<div class="invoice-item-wrapper">
		<div class="invoice-card" ref="invoiceItem" @click="handleCheckInvoice">
			<!-- 默认显示：公司名称和金额 -->
			<div class="invoice-header">
				<div class="company-info">
					<i class="el-icon-office-building company-icon"></i>
					<span class="company-name">{{ invoice.companyName || '未知公司' }}</span>
				</div>
				<div class="invoice-amount-compact">
					<span class="amount-label">金额：</span>
					<span class="amount-value">{{ formattedInvoiceAmount }}</span>
				</div>
				<div class="invoice-type">
					<el-tag :type="invoice.companyType === '客户' ? 'success' : 'warning'" size="mini" effect="light">
						{{ invoice.companyType }}
					</el-tag>
				</div>
			</div>

			<!-- 展开内容：详细信息 -->
			<div class="invoice-content">
				<div class="amount-info">
					<div class="amount-item">
						<span class="label">开票金额：</span>
						<span class="value invoice-amount">{{ formattedInvoiceAmount }}</span>
					</div>
					<div class="amount-item" v-if="invoice.ticketPoint > 0">
						<span class="label">票点：</span>
						<span class="value ticket-point">{{ formattedTicketPoint }}</span>
					</div>
					<div class="amount-item" v-if="invoice.ticketPointAmount > 0">
						<span class="label">票点金额：</span>
						<span class="value ticket-amount">{{ amount }}</span>
					</div>
					<div class="amount-item" v-if="invoice.isOrderTax">
						<span class="label">对应订单ID：</span>
						<span class="value ticket-amount">{{ invoice.isOrderTax }}</span>
					</div>
					<div class="amount-item" v-if="invoice.batchInvoiceId">
						<span class="label">对应模板ID：</span>
						<span class="value ticket-amount">{{ invoice.batchInvoiceId }}</span>
					</div>
				</div>
			</div>

			<div class="invoice-actions">
				<el-button type="text" size="mini" icon="el-icon-view" class="view-btn" @click.stop="handleCheckInvoice">查看详情</el-button>
			</div>
		</div>

		<!--		查看开票信息的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="开票信息详情" :visible.sync="visible" width="600px" append-to-body class="invoice-detail-dialog">
			<div class="dialog-header">
				<div class="company-detail">
					<i class="el-icon-office-building"></i>
					<span class="company-name">{{ invoice.companyName }}</span>
					<el-tag :type="invoice.companyType === 'CUSTOMER' ? 'success' : 'warning'" size="small">
						{{ invoice.companyType === 'CUSTOMER' ? '客户发票' : '供应商发票' }}
					</el-tag>
				</div>
			</div>

			<el-descriptions :column="2" size="medium" border>
				<el-descriptions-item label="我方开票实体" :span="2">
					<EllipsisText :title="invoice.invoiceObject" />
				</el-descriptions-item>
				<el-descriptions-item label="发票日期">
					<EllipsisText :title="invoice.invoiceDate" />
				</el-descriptions-item>
				<el-descriptions-item label="发票金额">
					<span class="highlight-amount">{{ formattedInvoiceAmount }}</span>
				</el-descriptions-item>
				<el-descriptions-item label="开票公司">
					<EllipsisText :title="invoice.invoiceCompanyName" />
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					<el-tag :type="invoice.companyType === 'CUSTOMER' ? 'success' : 'warning'" size="mini">
						{{ invoice.companyType === 'CUSTOMER' ? '客户' : '供应商' }}
					</el-tag>
				</el-descriptions-item>
				<el-descriptions-item label="对应订单">
					<span v-if="invoiceOrderId">
						<el-button type="text" size="mini" @click="openOrder(invoiceOrderId)">查看订单 {{ invoiceOrderId }}</el-button>
					</span>
					<span v-else>无</span>
				</el-descriptions-item>
				<el-descriptions-item label="对应模板ID" v-if="invoice.batchInvoiceId">
					<span class="template-id">{{ invoice.batchInvoiceId }}</span>
				</el-descriptions-item>
				<el-descriptions-item label="票点" v-if="invoice.ticketPoint > 0">
					<span class="ticket-info">{{ formattedTicketPoint }}</span>
				</el-descriptions-item>
				<el-descriptions-item label="票点金额" v-if="invoice.ticketPointAmount > 0">
					<span class="ticket-amount-info">{{ amount }}</span>
				</el-descriptions-item>
				<el-descriptions-item label="备注" :span="2" v-if="invoice.comments">
					<EllipsisText :title="invoice.comments" />
				</el-descriptions-item>
			</el-descriptions>

			<span slot="footer" class="dialog-footer">
				<el-button type="primary" @click="handleClose">关 闭</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.invoice-item-wrapper {
	margin-bottom: 8px;
}

.invoice-card {
	background: #ffffff;
	border: 1px solid #e4e7ed;
	border-radius: 6px;
	padding: 0;
	cursor: pointer;
	transition: all 0.3s ease;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
	height: 60px;
	overflow: hidden;
	display: flex;
	flex-direction: column;

	&:hover {
		height: auto;
		min-height: 60px;
		padding: 12px;
		border-color: #409eff;
		box-shadow: 0 2px 12px rgba(64, 158, 255, 0.15);
		transform: translateY(-1px);
	}

	&.active {
		height: auto;
		min-height: 60px;
		padding: 12px;
		border-color: #409eff;
		box-shadow: 0 0 8px rgba(64, 158, 255, 0.25);
	}
}

.invoice-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px;
	height: 60px;
	box-sizing: border-box;

	.company-info {
		display: flex;
		align-items: center;
		gap: 6px;
		flex: 1;
		min-width: 0;

		.company-icon {
			color: #409eff;
			font-size: 14px;
			flex-shrink: 0;
		}

		.company-name {
			font-weight: 600;
			color: #303133;
			font-size: 13px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
	}

	.invoice-amount-compact {
		display: flex;
		align-items: center;
		gap: 4px;
		flex-shrink: 0;
		margin-left: 12px;

		.amount-label {
			font-size: 12px;
			color: #909399;
		}

		.amount-value {
			font-size: 14px;
			font-weight: 600;
			color: #67c23a;
		}
	}

	.invoice-type {
		flex-shrink: 0;
		display: none;
	}
}

.invoice-card:hover > .invoice-header,
.invoice-card.active > .invoice-header {
	padding: 0;
	margin-bottom: 8px;
	padding-bottom: 6px;
	border-bottom: 1px solid #f5f7fa;
	height: auto;

	.invoice-amount-compact {
		display: none;
	}

	.invoice-type {
		display: block;
	}
}

.invoice-content {
	margin-bottom: 8px;
	display: none;
	padding: 0 12px;

	.amount-info {
		display: flex;
		flex-direction: column;
		gap: 4px;

		.amount-item {
			display: flex;
			justify-content: space-between;
			align-items: center;
			font-size: 12px;

			.label {
				color: #606266;
				font-weight: 500;
				min-width: 60px;
			}

			.value {
				font-weight: 600;
				text-align: right;

				&.invoice-amount {
					color: #67c23a;
					font-size: 14px;
				}

				&.ticket-point {
					color: #409eff;
					font-size: 12px;
				}

				&.ticket-amount {
					color: #e6a23c;
					font-size: 12px;
				}
			}
		}
	}
}

.invoice-card:hover > .invoice-content,
.invoice-card.active > .invoice-content {
	display: block;
}

.invoice-actions {
	display: none;
	flex: 0 0 auto;
	justify-content: center;
	padding: 6px 12px 0;
	border-top: 1px solid #f5f7fa;

	.view-btn {
		color: #409eff;
		font-size: 12px;
		padding: 2px 8px;

		&:hover {
			color: #66b1ff;
			background-color: rgba(64, 158, 255, 0.1);
		}
	}
}

.invoice-card:hover > .invoice-actions,
.invoice-card.active > .invoice-actions {
	display: flex;
}

/* 弹窗样式 */
.invoice-detail-dialog {
	::v-deep .el-dialog {
		border-radius: 8px;
		overflow: hidden;
	}

	::v-deep .el-dialog__header {
		background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
		border-bottom: 1px solid #e1ecf4;
		padding: 16px 20px;

		.el-dialog__title {
			font-weight: 600;
			color: #2c3e50;
			font-size: 16px;
		}
	}

	::v-deep .el-dialog__body {
		padding: 20px;
	}

	::v-deep .el-dialog__footer {
		border-top: 1px solid #ebeef5;
		padding: 12px 20px;
		text-align: center;
	}
}

.dialog-header {
	margin-bottom: 16px;
	padding: 12px;
	background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
	border-radius: 6px;
	border-left: 4px solid #409eff;

	.company-detail {
		display: flex;
		align-items: center;
		gap: 8px;

		i {
			color: #409eff;
			font-size: 16px;
		}

		.company-name {
			font-weight: 600;
			color: #303133;
			font-size: 16px;
		}
	}
}

.highlight-amount {
	color: #67c23a;
	font-weight: bold;
	font-size: 14px;
}

.ticket-info {
	color: #409eff;
	font-weight: 600;
	font-size: 13px;
}

.ticket-amount-info {
	color: #e6a23c;
	font-weight: 600;
	font-size: 13px;
}

.template-id {
	color: #909399;
	font-weight: 500;
	font-size: 13px;
}

.dialog-footer {
	text-align: center;
	padding: 16px 0;

	.el-button {
		min-width: 80px;
		border-radius: 4px;
	}
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
	.invoice-card {
		padding: 10px;
		margin-bottom: 6px;
	}

	.invoice-header {
		.company-info .company-name {
			max-width: 80px;
			font-size: 12px;
		}
	}

	.invoice-content .amount-info .amount-item {
		font-size: 11px;

		.value.invoice-amount {
			font-size: 13px;
		}
	}

	.invoice-detail-dialog {
		::v-deep .el-dialog {
			margin: 0 !important;
			width: 95% !important;
			max-width: none !important;
		}
	}
}

@media screen and (max-width: 480px) {
	.invoice-card {
		padding: 8px;
	}

	.dialog-header .company-detail {
		flex-direction: column;
		align-items: flex-start;
		gap: 4px;
	}

	.invoice-content .amount-info {
		.amount-item {
			.label {
				min-width: 50px;
			}
		}
	}
}

/* 平滑动画效果 */
.invoice-card {
	animation: fadeInUp 0.3s ease-out;
}

@keyframes fadeInUp {
	from {
		opacity: 0;
		transform: translateY(10px);
	}

	to {
		opacity: 1;
		transform: translateY(0);
	}
}

/* Element UI 组件样式重写 */
::v-deep .el-descriptions {
	.el-descriptions__header {
		margin-bottom: 16px;

		.el-descriptions__title {
			font-weight: 600;
			color: #303133;
			font-size: 16px;
		}
	}

	.el-descriptions-item__label {
		color: #606266;
		font-weight: 500;
		background: #fafbfc !important;
	}

	.el-descriptions-item__content {
		color: #303133;
		font-weight: 500;
	}
}

::v-deep .el-tag {
	border-radius: 12px;
	font-size: 11px;
	height: 20px;
	line-height: 18px;
}
</style>
