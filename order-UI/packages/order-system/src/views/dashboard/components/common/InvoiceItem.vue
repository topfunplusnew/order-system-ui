<script>
import EllipsisText from '@/views/dashboard/components/common/EllipsisText.vue';
import { fix } from '../../../../api/tool/format';

export default {
	name: 'InvoiceItem',
	components: { EllipsisText },
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
		amount() {
			if (this.invoice === null) {
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
		console.log(this.invoice);
	},
	methods: {
		fix,
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
			<div class="invoice-header">
				<div class="company-info">
					<i class="el-icon-office-building company-icon"></i>
					<span class="company-name">{{ invoice.companyName || '未知公司' }}</span>
				</div>
				<div class="invoice-type">
					<el-tag :type="invoice.companyType === 'CUSTOMER' ? 'success' : 'warning'" size="mini"
						effect="light">
						{{ invoice.companyType === 'CUSTOMER' ? '客户' : '供应商' }}
					</el-tag>
				</div>
			</div>

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
				</div>
			</div>

			<div class="invoice-actions">
				<el-button type="text" size="mini" icon="el-icon-view" class="view-btn"
					@click.stop="handleCheckInvoice">
					查看详情
				</el-button>
			</div>
		</div>

		<!--		查看开票信息的弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="开票信息详情"
			:visible.sync="visible" width="600px" append-to-body class="invoice-detail-dialog">
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
				<el-descriptions-item label="开票实体" :span="2">
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
	padding: 12px;
	cursor: pointer;
	transition: all 0.3s ease;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);

	&:hover {
		border-color: #409eff;
		box-shadow: 0 2px 12px rgba(64, 158, 255, 0.15);
		transform: translateY(-1px);
	}

	&.active {
		border-color: #409eff;
		box-shadow: 0 0 8px rgba(64, 158, 255, 0.25);
	}
}

.invoice-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 8px;
	padding-bottom: 6px;
	border-bottom: 1px solid #f5f7fa;

	.company-info {
		display: flex;
		align-items: center;
		gap: 6px;

		.company-icon {
			color: #409eff;
			font-size: 14px;
		}

		.company-name {
			font-weight: 600;
			color: #303133;
			font-size: 13px;
			max-width: 120px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
	}

	.invoice-type {
		flex-shrink: 0;
	}
}

.invoice-content {
	margin-bottom: 8px;

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

.invoice-actions {
	display: flex;
	justify-content: center;
	padding-top: 6px;
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
