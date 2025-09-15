<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';

export default {
	name: 'DEPOSITMONEY',
	mixins: [common_dialog],
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {
				return {};
			}
		}
	},
	data() {
		return {
			detailVisible: false
		};
	},
	computed: {
		// 格式化金额显示
		formattedAmount() {
			const amount = this.needToShowInfo.moneyAmount || 0;
			return `￥${Number(amount).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}`;
		},
		// 格式化未退款金额
		formattedUnrefundedAmount() {
			const amount = this.needToShowInfo.unrefundedAmount || 0;
			return `￥${Number(amount).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}`;
		},
		// 退款记录列表
		refundList() {
			return this.needToShowInfo.depositRefundList || [];
		},
		// 已退款总金额
		totalRefundAmount() {
			const total = this.refundList.reduce((sum, item) => sum + (parseFloat(item.moneyAmount) || 0), 0);
			return `￥${Number(total).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}`;
		}
	},
	methods: {
		// 查看详细信息
		handleCheckDetail() {
			if (this.needToShowInfo.id) {
				this.detailVisible = true;
			} else {
				this.$message.warning('无详细信息可查看');
			}
		},
		// 处理弹窗确认 - 弹窗系统要求的方法
		handleProcess() {
			return Promise.resolve();
		},
		// 处理弹窗取消 - 弹窗系统要求的方法
		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div>
		<el-card size="mini" shadow="hover">
			<!-- 卡片头部 -->
			<div slot="header" class="clearfix">
				<span>保证金收取信息</span>
				<el-button type="text" @click="handleCheckDetail" style="float: right">查看详细</el-button>
			</div>

			<!-- 保证金信息展示 -->
			<el-descriptions :column="3" border size="mini">
				<el-descriptions-item label="保证金公司">
					{{ needToShowInfo.depositCompany || '暂无' }}
				</el-descriptions-item>
				<el-descriptions-item label="收取时间">
					{{ needToShowInfo.depositDate || '暂无' }}
				</el-descriptions-item>
				<el-descriptions-item label="保证金金额" label-class-name="money-label">
					<span style="color: #e6a23c; font-weight: bold">{{ formattedAmount }}</span>
				</el-descriptions-item>

				<el-descriptions-item label="对象类型">
					{{ needToShowInfo.targetType || '暂无' }}
				</el-descriptions-item>
				<el-descriptions-item label="对象名称">
					{{ needToShowInfo.target || '暂无' }}
				</el-descriptions-item>
				<el-descriptions-item label="未退款金额" label-class-name="money-label">
					<span :style="{ color: needToShowInfo.unrefundedAmount > 0 ? '#f56c6c' : '#67c23a', fontWeight: 'bold' }">
						{{ formattedUnrefundedAmount }}
					</span>
				</el-descriptions-item>
				<el-descriptions-item label="已退款金额" label-class-name="money-label">
					<span style="color: #67c23a; font-weight: bold">{{ totalRefundAmount }}</span>
				</el-descriptions-item>
				<el-descriptions-item label="操作人员">
					{{ needToShowInfo.userName || '暂无' }}
				</el-descriptions-item>

				<el-descriptions-item label="事由" :span="2">
					{{ needToShowInfo.reason || '暂无' }}
				</el-descriptions-item>
				<el-descriptions-item label="退款记录">
					<el-tag v-if="refundList.length > 0" type="info">{{ refundList.length }}条记录</el-tag>
					<span v-else>暂无</span>
				</el-descriptions-item>

				<el-descriptions-item label="备注" :span="3">
					<el-tag v-if="needToShowInfo.comments" size="small" type="info">{{ needToShowInfo.comments }}</el-tag>
					<span v-else>暂无备注</span>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>

		<!-- 详细信息弹窗 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="保证金收取详细信息" :visible.sync="detailVisible" width="1000px" append-to-body>
			<div class="detail-content">
				<!-- 基本信息 -->
				<el-card size="small" shadow="never" style="margin-bottom: 20px">
					<div slot="header">
						<span>基本信息</span>
					</div>
					<el-descriptions :column="3" border size="small">
						<el-descriptions-item label="ID">{{ needToShowInfo.id }}</el-descriptions-item>
						<el-descriptions-item label="添加时间">{{ needToShowInfo.addtime }}</el-descriptions-item>
						<el-descriptions-item label="操作人员">{{ needToShowInfo.userName }}</el-descriptions-item>
						<el-descriptions-item label="保证金公司">{{ needToShowInfo.depositCompany }}</el-descriptions-item>
						<el-descriptions-item label="对象类型">{{ needToShowInfo.targetType }}</el-descriptions-item>
						<el-descriptions-item label="对象名称">{{ needToShowInfo.target }}</el-descriptions-item>
						<el-descriptions-item label="保证金金额">
							<span style="color: #e6a23c; font-weight: bold">{{ formattedAmount }}</span>
						</el-descriptions-item>
						<el-descriptions-item label="未退款金额">
							<span :style="{ color: needToShowInfo.unrefundedAmount > 0 ? '#f56c6c' : '#67c23a', fontWeight: 'bold' }">
								{{ formattedUnrefundedAmount }}
							</span>
						</el-descriptions-item>
						<el-descriptions-item label="已退款金额">
							<span style="color: #67c23a; font-weight: bold">{{ totalRefundAmount }}</span>
						</el-descriptions-item>
						<el-descriptions-item label="收取时间">{{ needToShowInfo.depositDate }}</el-descriptions-item>
						<el-descriptions-item label="事由">{{ needToShowInfo.reason }}</el-descriptions-item>
						<el-descriptions-item label="备注" :span="3">
							{{ needToShowInfo.comments || '暂无备注' }}
						</el-descriptions-item>
					</el-descriptions>
				</el-card>

				<!-- 账户信息 -->
				<el-card size="small" shadow="never" style="margin-bottom: 20px">
					<div slot="header">
						<span>账户信息</span>
					</div>
					<el-row :gutter="20">
						<el-col :span="12">
							<h4>对方账户信息</h4>
							<div class="bank-info">
								<p>
									<strong>账户名：</strong>
									{{ needToShowInfo.targetAccountsName || '暂无' }}
								</p>
								<p>
									<strong>账号：</strong>
									{{ needToShowInfo.targetBankNo || '暂无' }}
								</p>
								<p>
									<strong>开户行：</strong>
									{{ needToShowInfo.targetBankName || '暂无' }}
								</p>
							</div>
						</el-col>
						<el-col :span="12">
							<h4>我方收款账户信息</h4>
							<div class="bank-info">
								<p>
									<strong>账户名：</strong>
									{{ needToShowInfo.selfAccountsName || '暂无' }}
								</p>
								<p>
									<strong>账号：</strong>
									{{ needToShowInfo.selfBankNo || '暂无' }}
								</p>
								<p>
									<strong>开户行：</strong>
									{{ needToShowInfo.selfBankName || '暂无' }}
								</p>
							</div>
						</el-col>
					</el-row>
				</el-card>

				<!-- 退款记录 -->
				<el-card size="small" shadow="never" v-if="refundList.length > 0">
					<div slot="header">
						<span>退款记录 ({{ refundList.length }}条)</span>
					</div>
					<el-table :data="refundList" border size="small" max-height="300">
						<el-table-column prop="id" label="退款ID" width="80" align="center" />
						<el-table-column prop="refundDate" label="退款时间" width="160" align="center" />
						<el-table-column prop="moneyAmount" label="退款金额" width="120" align="right">
							<template #default="{ row }">
								<span style="color: #67c23a; font-weight: bold">￥{{ Number(row.moneyAmount).toLocaleString('zh-CN', { minimumFractionDigits: 2 }) }}</span>
							</template>
						</el-table-column>
						<el-table-column prop="accountsName" label="退款账户" show-overflow-tooltip />
						<el-table-column prop="bankNo" label="账号" show-overflow-tooltip />
						<el-table-column prop="userName" label="操作人" width="100" align="center" />
						<el-table-column prop="comments" label="备注" show-overflow-tooltip />
					</el-table>
				</el-card>

				<!-- 无退款记录提示 -->
				<el-card size="small" shadow="never" v-else>
					<div slot="header">
						<span>退款记录</span>
					</div>
					<el-empty description="暂无退款记录" :image-size="80" />
				</el-card>
			</div>

			<div slot="footer" class="dialog-footer">
				<el-button @click="detailVisible = false">关闭</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.money-label {
	font-weight: bold;
}

:deep(.el-descriptions__label) {
	font-weight: 600;
	color: #606266;
}

:deep(.el-descriptions__content) {
	color: #303133;
}

.el-card {
	margin-bottom: 20px;
}

.clearfix:before,
.clearfix:after {
	display: table;
	content: '';
}

.clearfix:after {
	clear: both;
}

.detail-content {
	max-height: 600px;
	overflow-y: auto;

	h4 {
		margin: 0 0 10px 0;
		color: #409eff;
		font-size: 14px;
		font-weight: 600;
	}
}

.bank-info {
	background: #f8f9fa;
	padding: 10px;
	border-radius: 4px;
	margin-bottom: 10px;

	p {
		margin: 5px 0;
		line-height: 1.4;
		font-size: 13px;

		strong {
			color: #409eff;
			margin-right: 8px;
		}
	}
}

.dialog-footer {
	text-align: center;
}
</style>
