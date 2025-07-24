<script>
export default {
	name: 'OrderHistoryList',
	props: {
		goodsOrderList: {
			type: Array,
			default() {
				return [];
			}
		}
	},

	data() {
		return {};
	},
	methods: {
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-table
			id="printBox"
			v-horizontal-scroll="'always'"
			fit
			border
			:data="goodsOrderList"
			max-height="462px"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
		>
			<el-table-column show-overflow-tooltip label="日期" align="center" prop="orderDate" />
			<el-table-column show-overflow-tooltip label="客户" align="center" prop="customer" />
			<el-table-column show-overflow-tooltip label="供应商" align="center" prop="supplierNames" width="200"></el-table-column>
			<el-table-column show-overflow-tooltip label="陆运车牌" align="center" prop="landCarNo" />
			<el-table-column show-overflow-tooltip label="陆运司机电话" align="center" prop="landDriverTel" width="100px" />
			<el-table-column show-overflow-tooltip label="陆地司机姓名" align="center" prop="landDriverName" width="100px" />
			<el-table-column show-overflow-tooltip label="总货款" align="center" prop="allPayments" width="100px"></el-table-column>
			<el-table-column show-overflow-tooltip label="陆运费" align="center" prop="landFreight" width="100px" />
			<!--      原为海运车牌号-->
			<el-table-column show-overflow-tooltip label="海运柜号" align="center" prop="seaCarNo">
				<template #default="scope">
					{{ !scope.row.seaCarNo ? '无' : scope.row.seaCarNo }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="海运司机电话" align="center" prop="seaDriverTel" width="100px">
				<template #default="scope">
					{{ !scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel }}
				</template>
			</el-table-column>
			<!--      原为海运司机姓名-->
			<el-table-column show-overflow-tooltip label="海运公司" align="center" prop="seaDriverName" width="100px">
				<template #default="scope">
					{{ !scope.row.seaDriverName ? '无' : scope.row.seaDriverTel }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="海运费" align="center" prop="seaFreight" width="100px" />
			<el-table-column show-overflow-tooltip label="销售经理" align="center" prop="saleManager" />
			<el-table-column show-overflow-tooltip label="车队" align="center" prop="fleet" />
			<el-table-column show-overflow-tooltip label="录入员" align="center" prop="userName" width="120px" />
			<el-table-column show-overflow-tooltip label="审核状态" align="center" prop="checkState" width="120"></el-table-column>
			<el-table-column show-overflow-tooltip label="开票状态" align="center" prop="invoiceState" width="120px" />
			<el-table-column show-overflow-tooltip label="客户是否开票" align="center" prop="customerIsInvoice" width="150px">
				<template #default="scope">
					{{ scope.row.customerIsInvoice === 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="供应商是否开票" align="center" prop="isSupplierInvoice" width="120px">
				<template #default="scope">
					{{ scope.row.isSupplierInvoice >= 1 ? '是' : '否' }}
				</template>
			</el-table-column>
			<el-table-column show-overflow-tooltip label="备注" align="center" prop="comments" />
			<el-table-column show-overflow-tooltip label="修改时间" align="center" prop="updateTime">
				<template #default="scope">
					{{ scope.row.tableEditMessage.modifyTime }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改原因" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage.reason }}
				</template>
			</el-table-column>

			<el-table-column show-overflow-tooltip label="修改人" align="center">
				<template #default="scope">
					{{ scope.row.tableEditMessage.userName }}
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>

<style scoped lang="scss"></style>
