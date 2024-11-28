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
		}
	}
};
</script>

<template>
	<div>
		<el-table
			:data="companyTotalInfo"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			style="width: 100%"
			max-height="850"
			border
		>
			<!--                      多选框-->
			<el-table-column type="selection" width="55"></el-table-column>
			<el-table-column prop="id" label="ID"></el-table-column>
			<el-table-column prop="name" label="购买方公司"></el-table-column>
			<el-table-column prop="total" label="金额">
				<template slot-scope="scope">
					<span class="bold-text">{{ scope.row.total }}</span>
				</template>
			</el-table-column>
			<el-table-column label="供应商信息">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="handleCheck(scope.row)"
						>查看
					</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
