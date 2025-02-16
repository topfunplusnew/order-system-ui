<script>
export default {
	name: 'CompanysList',
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
			this.$emit('handleCheck', row);
		},
		// 筛选右侧的订单 通过事件总线提醒
		handleFilterOrders(row) {
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
	<div>
		<el-table
			:data="companyTotalInfo"
			:row-style="handleRowClassName"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			size="mini"
			style="width: 100%"
			max-height="800"
			border
		>
			<!--                      多选框-->
			<el-table-column prop="id" label="ID"></el-table-column>
			<el-table-column prop="us" label="我方"></el-table-column>
			<el-table-column prop="name" label="对方公司"></el-table-column>
			<el-table-column prop="type" label="类型"></el-table-column>
			<el-table-column prop="total" label="金额">
				<template slot-scope="scope">
					<span class="bold-text money">{{ scope.row.total }}</span>
				</template>
			</el-table-column>
			<el-table-column label="公司信息" width="120">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleCheck(scope.row)">查看</el-button>
					<el-button size="mini" type="text" @click="handleFilterOrders(scope.row)">检索</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss">
.highlight-row {
	background-color: #c5f695 !important; /* 设置选中行的背景颜色 */
}

.money {
	color: #ff0000;
	font-weight: bold;
}
</style>
