<script>
import CompanyInformation from './CompanyInformation.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { getCompany } from '../../../../api/system/company';
import _ from 'lodash';

export default {
	name: 'CompanysList',
	components: {
		DialogWrapper
	},
	mixins: [common_dialog],
	props: {
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
		}
	},
	data() {
		return {
			selectedRowId: null
		};
	},
	mounted() {
		// 重置行的样式
		this.$bus.$on('select-goods-row:update', () => (this.selectedRowId = null));
	},
	beforeDestroy() {
		// 清除事件监听 防止内存泄漏
		this.$bus.$off('select-goods:update'); // 清理事件监听
	},
	methods: {
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
			// 先显示公司信息弹窗
			this.handleCheck(row);

			this.$bus.$emit('update-goods-order-company', row);
			// 维护开票金额
			this.$store.dispatch('excel/clearInvoiceAmount');
			this.$store.dispatch('excel/setInvoiceAmount', row.total);
			// 需要暂存我方实体
			sessionStorage.setItem('us', row.us || '');
			sessionStorage.setItem('invoiceAmount', row.total);

			// 方便变颜色
			this.selectedRowId = row.id;
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
		<el-table :data="companyTotalInfo" :row-style="handleRowClassName" :cell-style="() => ({ padding: '2px' })" size="mini" style="width: 100%" height="100%" border>
			<!--多选框-->
			<el-table-column prop="id" label="ID" width="60"></el-table-column>
			<el-table-column prop="us" label="我方"></el-table-column>
			<el-table-column prop="name" label="对方公司"></el-table-column>
			<el-table-column prop="type" label="类型" width="80"></el-table-column>
			<el-table-column prop="total" label="开票金额" width="100">
				<template slot-scope="scope">
					<span class="bold-text money">{{ scope.row.total }}</span>
				</template>
			</el-table-column>
			<el-table-column label="操作" width="120" fixed="right">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleCheck(scope.row)">查看</el-button>
					<el-button size="mini" type="text" @click="handleFilterOrders(scope.row)">检索</el-button>
				</template>
			</el-table-column>
		</el-table>
		<!--通用弹窗 配合common_dialog使用-->
		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<style scoped lang="scss">
.companies-list-wrapper {
	height: 100%;
	display: flex;
	flex-direction: column;
}

/* 统计信息样式 */
.statistics-summary {
	margin-bottom: 12px;
	flex-shrink: 0;
}

.statistics-card {
	border-radius: 6px;
	border: 1px solid #e4e7ed;

	::v-deep .el-card__header {
		padding: 8px 12px;
		background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
		border-bottom: 1px solid #e4e7ed;
	}

	::v-deep .el-card__body {
		padding: 10px 12px;
	}
}

.statistics-header {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 12px;
	font-weight: 600;
	color: #409eff;

	i {
		font-size: 14px;
	}
}

.statistics-content {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.stat-item {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 12px;
	background: #f5f7fa;

	.stat-label {
		font-weight: 500;
		color: #606266;
		min-width: 50px;
	}

	.stat-count {
		color: #909399;
		font-size: 11px;
		padding: 1px 6px;
		background: #e4e7ed;
		border-radius: 10px;
	}

	.stat-amount {
		font-weight: bold;
		margin-left: auto;
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
}
</style>
