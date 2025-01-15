<!--订单列表单独组件-->
<script>
import { listGoodsOrder } from '../../../../api/system/goodsOrder';
import QuerySearchBar from '../goodsOrder/QuerySearchBar.vue';
import { OptionInvent, Options } from '../../mixins/order/order_Invoice';

export default {
	name: 'OrderList',
	components: { QuerySearchBar },
	props: {
		selectedGoodsOrderList: []
	},
	data() {
		return {
			goodsOrderList: [],
			loading: false,
			total: 0,
			queryParams: {
				orderDateStart: null,
				orderDateEnd: null,
				pageNum: 1,
				pageSize: 50,
				ordersNo: null,
				orderDate: null,
				customer: null,
				customerID: null,
				landCarID: null,
				landCarNo: null,
				landDriverTel: null,
				landDriverName: null,
				seaCarID: null,
				seaCarNo: null,
				seaDriverTel: null,
				seaDriverName: null,
				checkUserId: null,
				checkState: null,
				invoiceState: null,
				path: null,
				PaymentState: null,
				landBankName: null,
				landBankNo: null,
				seaBankName: null,
				seaBankNo: null,
				receiveProof: null,
				saleManager: null,
				fleet: null,
				isAdjusted: null,
				adjustDate: null,
				isAdjust: 0,
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null
			}
		};
	},
	created() {
		this.getList();
	},
	methods: {
		Options() {
			return Options;
		},
		OptionInvent() {
			return OptionInvent;
		},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		handleSelectionChange(selection) {
			this.$emit('update:selectedGoodsOrderList', selection);
		},
		// 获取供应商的名称列表
		// getSupplierNames(list) {
		//   if (list.length === 0) {
		//     return;
		//   }
		//   return list.map(item => {
		//     return {
		//       supplier: item.supplier,
		//       supplierID: item.supplierID
		//     }
		//   })
		// },
		getList() {
			this.loading = true;
			listGoodsOrder(this.queryParams).then(response => {
				this.goodsOrderList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		}
	}
};
</script>

<template>
	<div>
		<!--    搜索组-->
		<QuerySearchBar
			:handle-query="handleQuery"
			:options="Options()"
			:options-invoice="OptionInvent()"
			:query-params="queryParams"
			:show-search="true"
		/>
		<!--    这里可以添加一些操作-->
		<slot name="option"></slot>
		<!--    订单列表-->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			fit
			border
			:data="goodsOrderList"
			max-height="750"
			size="mini"
			:cell-style="
				() => {
					return { padding: '2px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				type="selection"
				width="55"
				fixed="left"
			></el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="ID"
				align="center"
				prop="id"
				fixed="left"
			/>
			<el-table-column
				show-overflow-tooltip
				label="日期"
				align="center"
				prop="orderDate"
				fixed="left"
			/>
			<el-table-column
				show-overflow-tooltip
				label="客户"
				align="center"
				prop="customer"
				fixed="left"
			/>
			<el-table-column
				show-overflow-tooltip
				label="供应商"
				align="center"
				prop="supplierNames"
				fixed="left"
				width="200"
			>
				<!--        <template #default="scope">-->
				<!--          <el-row>-->
				<!--          <span v-for="(item, index) in getSupplierNames(scope.row.orderDetailList)" :key="index">-->
				<!--                {{ item.supplier }}-->
				<!--          </span>-->
				<!--          </el-row>-->
				<!--        </template>-->
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="陆运车牌"
				align="center"
				prop="landCarNo"
			/>
			<el-table-column
				show-overflow-tooltip
				label="陆运司机电话"
				align="center"
				prop="landDriverTel"
				width="100px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="陆地司机姓名"
				align="center"
				prop="landDriverName"
				width="100px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="陆运费"
				align="center"
				prop="landFreight"
				width="100px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="柜号"
				align="center"
				prop="seaCarNo"
			>
				<template #default="scope">{{
					!scope.row.seaCarNo ? '无' : scope.row.seaCarNo
				}}</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="海运司机电话"
				align="center"
				prop="seaDriverTel"
				width="100px"
			>
				<template #default="scope">{{
					!scope.row.seaDriverTel ? '无' : scope.row.seaDriverTel
				}}</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="海运公司"
				align="center"
				prop="seaDriverName"
				width="100px"
			>
				<template #default="scope">{{
					!scope.row.seaDriverName ? '无' : scope.row.seaDriverName
				}}</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="海运费"
				align="center"
				prop="seaFreight"
				width="100px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="销售经理"
				align="center"
				prop="saleManager"
			/>
			<el-table-column
				show-overflow-tooltip
				label="车队"
				align="center"
				prop="fleet"
			/>
			<el-table-column
				show-overflow-tooltip
				label="审核状态"
				align="center"
				prop="checkState"
				width="120"
			/>
			<el-table-column
				show-overflow-tooltip
				label="开票状态"
				align="center"
				prop="invoiceState"
				width="120px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="打款状态"
				align="center"
				prop="paymentState"
				width="120px"
			/>
			<el-table-column
				show-overflow-tooltip
				label="是否可编辑"
				align="center"
				prop="isedit"
				width="100px"
			>
				<template slot-scope="scope">
					<el-tag :type="scope.row.isedit === 0 ? 'danger' : 'success'">
						{{ scope.row.isedit === 0 ? '否' : '是' }}
					</el-tag>
				</template>
			</el-table-column>
			<el-table-column
				show-overflow-tooltip
				label="备注"
				align="center"
				prop="comments"
			/>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>
	</div>
</template>

<style scoped lang="scss"></style>
