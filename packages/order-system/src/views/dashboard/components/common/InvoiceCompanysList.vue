<script>
import CompanyInformation from './CompanyInformation.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import { getCompany } from '../../../../api/system/company';
import _ from 'lodash';

export default {
	name: 'InvoiceCompanysList',
	mixins: [common_dialog],
	props: {
		side: {
			type: String, // 'purchase' | 'seller'
			default: 'purchase'
		},
		companyTotalInfo: {
			type: Array,
			default: () => {
				return [];
			}
		},
		statisticsInfo: {
			type: Object,
			default: () => {
				return {
					suppliers: { total: 0, count: 0 },
					customers: { total: 0, count: 0 }
				};
			}
		},
		// 当前批量开票模式
		mode: {
			type: String,
			default: 'in'
		},
		// 当前批量开票凭证号
		voucher: {
			type: String,
			default: ''
		}
	},
	data() {
		return {
			selectedRowId: null,
			viewTemplateVisible: false
		};
	},
	computed: {
		// 从 Vuex 获取批次详情数据
		batchDetailRows() {
			return this.$store.getters.batchDetailRows || [];
		},
		selectedTemplateData() {
			// 根据 side 筛选批次数据
			if (this.side === 'purchase') {
				return this.batchDetailRows.filter(row => row.sellerId === 0);
			}
			return this.batchDetailRows.filter(row => row.sellerId !== 0);
		}
	},
	mounted() {
		// 重置行的样式
		this.$bus.$on('select-goods-row:update', () => (this.selectedRowId = null));
	},
	beforeDestroy() {
		this.$bus.$off('select-goods-row:update');
	},
	methods: {
		// 获取公司ID
		getCompanyId(row) {
			if (!row) return null;
			return Number(row.id) || null;
		},
		// 判断是否已操作（基于后端返回的 invoiced 字段）
		isOperated(row) {
			return !!(row && row.invoiced);
		},
		openTemplateViewer() {
			// 仅在有数据时打开
			if (!this.selectedTemplateData || this.selectedTemplateData.length === 0) {
				this.$message.info('暂无模板数据');
				return;
			}
			this.viewTemplateVisible = true;
		},
		handleCheck(row) {
			const { id, type } = row;
			getCompany(id, type).then(res => {
				const companyData = _.cloneDeep(res.data);
				// 构建公司信息数据
				const companyInfo = {
					// 基础信息
					companyName: companyData.companyName || '暂无',
					companyType: companyData.companyType || type || '暂无',

					// 联系人信息
					relationName: companyData.relationName || '暂无',
					relationTel: companyData.relationTel || '暂无',
					leader: companyData.leader || '暂无',
					leaderTel: companyData.leaderTel || '暂无',
					salesman: companyData.salesman || '暂无',
					salesManager: companyData.salesManager || '暂无',

					// 地址信息
					region: companyData.region || '暂无',
					province: companyData.province || '暂无',
					city: companyData.city || '暂无',
					county: companyData.county || '暂无',
					address: companyData.address || '暂无',

					// 银行信息
					bankName: companyData.bankName || '暂无',
					acountsName: companyData.acountsName || '暂无',
					bankNo: companyData.bankNo || '暂无',

					// 其他信息
					comments: companyData.comments || '暂无',
					addtime: companyData.addtime || '暂无',
					userName: companyData.userName || '暂无',

					supplierLoading: false
				};

				// 使用 openDialog 方法打开公司信息弹窗
				this.openDialog(
					CompanyInformation,
					`${companyData.companyName || '公司'}详细信息`,
					'800px',
					{
						companyInfo: companyInfo
					},
					false
				);
				this.$emit('handleCheck', row);
			});
		},
		// 筛选右侧的订单 通过事件总线提醒
		handleFilterOrders(row) {
			// 查找相同对方ID的所有记录（可能我方公司不同）
			const sameIdRows = this.companyTotalInfo.filter(item => item.id === row.id);

			// 合并所有相同ID的记录的total
			const mergedTotal = sameIdRows.reduce((sum, item) => {
				return sum + (Number(item.total) || 0);
			}, 0);

			// 合并票点金额（取平均值或第一个，这里取第一个的票点）
			const mergedTicketPointAmount = sameIdRows.reduce((sum, item) => {
				return sum + (Number(item.ticketPointAmount) || 0);
			}, 0);

			// 创建一个合并后的row对象，保留原始row的其他属性
			const mergedRow = {
				...row,
				total: mergedTotal,
				ticketPointAmount: mergedTicketPointAmount,
				// 标记这是合并后的数据，包含所有我方公司信息
				_mergedRows: sameIdRows,
				_isMerged: sameIdRows.length > 1
			};

			this.$bus.$emit('update-goods-order-company', mergedRow);
			// 维护开票金额 - 使用合并后的总金额
			this.$store.dispatch('excel/clearInvoiceAmount');
			this.$store.dispatch('excel/setInvoiceAmount', mergedTotal);
			// 需要暂存我方实体 - 如果有多条记录，存储所有我方公司信息
			if (sameIdRows.length > 1) {
				// 存储所有我方公司名称的数组
				const allUsNames = sameIdRows.map(item => item.us).filter(Boolean);
				sessionStorage.setItem('us', JSON.stringify(allUsNames));
			} else {
				sessionStorage.setItem('us', row.us || '');
			}
			sessionStorage.setItem('invoiceAmount', mergedTotal);
			// 存储当前选中行的公司ID，供 InvoiceBody 精确回写
			const companyId = this.getCompanyId(row);
			sessionStorage.setItem('companyList_selected_company_id', companyId);
			// 存储合并信息，供生成发票时使用
			if (sameIdRows.length > 1) {
				sessionStorage.setItem(
					'merged_company_info',
					JSON.stringify({
						companyId: companyId,
						rows: sameIdRows.map(item => ({
							us: item.us,
							total: item.total,
							ticketPoint: item.ticketPoint,
							ticketPointAmount: item.ticketPointAmount
						}))
					})
				);
			} else {
				sessionStorage.removeItem('merged_company_info');
			}
			// 方便变颜色
			this.selectedRowId = row.id;
			// 不在检索时标记，由开具发票成功后由上层写入映射
		},
		// 点击某一行变颜色的函数
		handleRowClassName({ row }) {
			if (!row) {
				return {};
			}
			if (!row.type) {
				return {};
			}
			return this.selectedRowId === row.id
				? {
						background: '#c5f695 !important'
				  }
				: {}; // 返回高亮类名
		}
	}
};
</script>

<template>
	<div class="companies-list-wrapper">
		<!-- 统计信息展示区域 -->
		<div v-if="statisticsInfo.suppliers.count > 0 || statisticsInfo.customers.count > 0" class="statistics-summary">
			<el-card class="statistics-card" shadow="never">
				<div slot="header" class="statistics-header">
					<i class="el-icon-s-data"></i>
					<span>统计</span>
					<el-button type="text" size="mini" @click="openTemplateViewer">查看模板数据（{{ side === 'purchase' ? '购买方' : '销方' }}）</el-button>
				</div>
				<div class="statistics-content">
					<div v-if="statisticsInfo.suppliers.count > 0" class="stat-item supplier-stat">
						<span class="stat-label">供应商:</span>
						<span class="stat-count">{{ statisticsInfo.suppliers.count }}家</span>
						<span class="stat-amount">累计价税合计：¥{{ statisticsInfo.suppliers.total }}</span>
					</div>
					<div v-if="statisticsInfo.customers.count > 0" class="stat-item customer-stat">
						<span class="stat-label">客户:</span>
						<span class="stat-count">{{ statisticsInfo.customers.count }}家</span>
						<span class="stat-amount">累计价税合计：¥{{ statisticsInfo.customers.total }}</span>
					</div>
				</div>
			</el-card>
		</div>

		<!-- 公司列表表格 -->
		<div class="table-wrapper">
			<el-table :data="companyTotalInfo" :row-style="handleRowClassName" :cell-style="() => ({ padding: '2px' })" size="mini" style="width: 100%">
				<!--多选框-->
				<el-table-column label="操作">
					<template slot-scope="scope">
						<el-button size="mini" type="text" @click="handleCheck(scope.row)">查看</el-button>
						<el-button size="mini" type="text" @click="handleFilterOrders(scope.row)">检索</el-button>
					</template>
				</el-table-column>
				<el-table-column prop="id" label="ID"></el-table-column>
				<el-table-column prop="us" label="我方"></el-table-column>
				<el-table-column prop="name" label="对方公司"></el-table-column>
				<el-table-column prop="type" label="类型"></el-table-column>
				<el-table-column prop="total" label="开票金额">
					<template slot-scope="scope">
						<span class="bold-text money">{{ scope.row.total }}</span>
					</template>
				</el-table-column>
				<el-table-column label="已操作" align="center">
					<template slot-scope="scope">
						<el-tag size="mini" :type="isOperated(scope.row) ? 'success' : 'info'">{{ isOperated(scope.row) ? '是' : '否' }}</el-tag>
					</template>
				</el-table-column>
			</el-table>
		</div>

		<!-- 查看模板数据弹窗 -->
		<el-dialog :modal="false" title="模板数据预览" :visible.sync="viewTemplateVisible" width="800px" append-to-body>
			<el-table :data="selectedTemplateData" size="mini" :max-height="700" border>
				<el-table-column prop="sellerId" label="销方ID" width="90" />
				<el-table-column prop="sellerName" label="销方名称" width="160" />
				<el-table-column prop="sellerType" label="销方类型" width="90" />
				<el-table-column prop="purchaseId" label="购买方ID" width="90" />
				<el-table-column prop="purchaseName" label="购买方名称" width="160" />
				<el-table-column prop="purchaseType" label="购买方类型" width="100" />
				<el-table-column prop="total" label="价税合计" width="110" />
				<el-table-column prop="ticketPoint" label="票点" width="80" />
				<el-table-column prop="ticketPointAmount" label="票点金额" width="110" />
			</el-table>
			<span slot="footer" class="dialog-footer">
				<el-button size="mini" @click="viewTemplateVisible = false">关闭</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.companies-list-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

/* 表格包装器样式 - 仅保留必要的行分割 */
.table-wrapper {
	overflow-x: auto;
	overflow-y: visible;
	width: 100%;

	/* 美化水平滚动条 */
	&::-webkit-scrollbar {
		height: 8px;
	}

	&::-webkit-scrollbar-thumb {
		background: #dcdfe6;
		border-radius: 4px;

		&:hover {
			background: #c0c4cc;
		}
	}

	&::-webkit-scrollbar-track {
		background: #f5f7fa;
		border-radius: 4px;
	}

	/* 表格样式 - 紧凑设计，仅保留行分割 */
	.el-table {
		white-space: nowrap;
		border: none;

		::v-deep .el-table__header-wrapper {
			.el-table__header {
				th {
					padding: 6px 0;
					border-bottom: 1px solid rgba(0, 0, 0, 0.08);
					border-right: none;
					background: transparent;
					font-size: 12px;
					font-weight: 600;

					&:last-child {
						border-right: none;
					}
				}
			}
		}

		::v-deep .el-table__body-wrapper {
			overflow-y: visible !important;
			max-height: none !important;

			.el-table__body {
				td {
					padding: 4px 0;
					border-bottom: 1px solid rgba(0, 0, 0, 0.06);
					border-right: none;
					font-size: 12px;

					&:last-child {
						border-right: none;
					}
				}

				tr:hover {
					background-color: rgba(64, 158, 255, 0.04);
				}

				tr:last-child td {
					border-bottom: none;
				}
			}
		}
	}
}

/* 统计信息样式 - 紧凑设计 */
.statistics-summary {
	margin-bottom: 8px;
	flex-shrink: 0;
}

.statistics-card {
	border-radius: 4px;
	border: none;
	background: transparent;

	::v-deep .el-card__header {
		padding: 6px 10px;
		background: transparent;
		border-bottom: 1px solid rgba(0, 0, 0, 0.06);
	}

	::v-deep .el-card__body {
		padding: 8px 10px;
		background: transparent;
	}
}

.statistics-header {
	display: flex;
	align-items: center;
	gap: 4px;
	font-size: 12px;
	font-weight: 600;
	color: #409eff;

	i {
		font-size: 13px;
	}
}

.statistics-content {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.stat-item {
	display: flex;
	align-items: center;
	gap: 6px;
	padding: 3px 6px;
	border-radius: 3px;
	font-size: 11px;
	background: #f5f7fa;

	.stat-label {
		font-weight: 500;
		color: #606266;
		min-width: 45px;
	}

	.stat-count {
		color: #909399;
		font-size: 10px;
		padding: 1px 5px;
		background: #e4e7ed;
		border-radius: 8px;
	}

	.stat-amount {
		font-weight: bold;
		margin-left: auto;
		font-size: 11px;
	}

	&.supplier-stat .stat-amount {
		color: #e6a23c;
	}

	&.customer-stat .stat-amount {
		color: #67c23a;
	}
}

.highlight-row {
	background-color: #c5f695 !important;
	/* 设置选中行的背景颜色 */
}

.money {
	color: #ff0000;
	font-weight: bold;
}

.ticket-point {
	color: #409eff;
	font-weight: bold;
	font-size: 12px;
}

.ticket-amount {
	color: #e6a23c;
	font-weight: bold;
	font-size: 12px;
}

.ticket-point {
	color: #409eff;
	font-weight: bold;
	font-size: 12px;
}

.ticket-amount {
	color: #e6a23c;
	font-weight: bold;
	font-size: 12px;
}

// 表格行样式优化
::v-deep .el-table {
	.el-table__row {
		&:hover {
			background-color: #f5f7fa;
		}
	}

	.el-table__header {
		background-color: #fafafa;

		th {
			background-color: #fafafa !important;
			color: #606266;
			font-weight: 600;
		}
	}

	.el-button--text {
		padding: 2px 8px;
		margin: 0 2px;
		border-radius: 4px;
		transition: all 0.3s ease;

		&:hover {
			background-color: #409eff;
			color: white;
		}
	}
}

/* 响应式适配 */
@media screen and (max-width: 768px) {
	.companies-list-wrapper {
		.el-table {
			font-size: 12px;
		}
	}

	/* 在小屏幕下确保表格水平滚动正常工作 */
	.table-wrapper {
		max-width: 100%;

		.el-table {
			min-width: 500px; /* 减少最小宽度以适应中等屏幕 */
		}
	}

	.statistics-content {
		gap: 4px;
	}

	.stat-item {
		padding: 3px 6px;
		font-size: 11px;

		.stat-label {
			min-width: 45px;
		}
	}
}

@media screen and (max-width: 480px) {
	.statistics-card {
		::v-deep .el-card__header {
			padding: 6px 10px;
		}

		::v-deep .el-card__body {
			padding: 8px 10px;
		}
	}

	.statistics-header {
		font-size: 11px;

		i {
			font-size: 12px;
		}
	}

	.stat-item {
		flex-direction: column;
		align-items: flex-start;
		gap: 4px;

		.stat-amount {
			margin-left: 0;
			align-self: flex-end;
		}
	}

	/* 在最小屏幕下进一步优化表格 */
	.table-wrapper {
		.el-table {
			min-width: 450px; /* 进一步减少最小宽度 */
		}

		/* 优化滚动条在小屏幕上的显示 */
		&::-webkit-scrollbar {
			height: 6px;
		}
	}
}
</style>
