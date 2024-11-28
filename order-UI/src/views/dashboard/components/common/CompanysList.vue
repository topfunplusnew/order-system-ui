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
	methods: {
		handleCheck(row) {
			this.$emit('handleCheck', row);
		},
		//  选一个供应商 筛选一个list 只开票属于该id的 类型为type的 公司
		// handleSelectionChange(selection) {
		// 	this.handleStoreCompanyInfo(selection);
		// },
		handleStoreCompanyInfo(selection) {
			this.$store.dispatch('excel/setCompanyList', selection);
		},
		// 筛选右侧的订单 通过事件总线提醒
		handleFilterOrders(row) {
			this.$bus.$emit('update-goods-order-company', row);
		}
	}
};
</script>

<template>
	<div>
		<el-table
			:data="companyTotalInfo"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			size="mini"
			style="width: 100%"
			max-height="850"
			border
		>
			<!--                      多选框-->
			<el-table-column prop="id" label="ID"></el-table-column>
			<el-table-column prop="name" label="公司名称"></el-table-column>
			<el-table-column prop="type" label="类型"></el-table-column>
			<el-table-column prop="total" label="金额">
				<template slot-scope="scope">
					<span class="bold-text">{{ scope.row.total }}</span>
				</template>
			</el-table-column>
			<el-table-column label="公司信息" width="120">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleCheck(scope.row)"
						>查看
					</el-button>
					<el-button
						size="mini"
						type="text"
						@click="handleFilterOrders(scope.row)"
					>
						检索
					</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
