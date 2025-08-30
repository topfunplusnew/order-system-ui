<script>
import CompanyInformation from './CompanyInformation.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';

export default {
	name: 'CompanysList',
	components: {
		CompanyInformation,
		DialogWrapper
	},
	mixins: [common_dialog],
	props: {
		companyTotalInfo: {
			type: Array,
			default: () => {
				return [];
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
			// 构建公司信息数据
			const companyInfo = {
				companyName: row.name || '暂无',
				companyType: row.type || '暂无',
				leader: row.leader || '暂无',
				region: row.region || '暂无',
				leaderTel: row.leaderTel || '暂无',
				comments: row.comments || '暂无',
				supplierLoading: false
			};

			// 使用 openDialog 方法打开公司信息弹窗
			this.openDialog(
				CompanyInformation,
				`${row.type || '公司'}详细信息`,
				'500px',
				{
					companyInfo: companyInfo
				},
				false
			);

			this.$emit('handleCheck', row);
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
		<el-table :data="companyTotalInfo" :row-style="handleRowClassName" :cell-style="() => ({ padding: '2px' })"
			size="mini" style="width: 100%" height="100%" border>
			<!--多选框-->
			<el-table-column prop="id" label="ID" width="60"></el-table-column>
			<el-table-column prop="us" label="我方"></el-table-column>
			<el-table-column prop="name" label="对方公司"></el-table-column>
			<el-table-column prop="type" label="类型" width="80"></el-table-column>
			<el-table-column prop="total" label="金额" width="100">
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
}
</style>
