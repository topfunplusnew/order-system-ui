<template>
	<div>
		<el-form
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="70px"
		>
			<el-row>
				<el-col :span="6">
					<el-form-item label="开始时间" prop="beginTime">
						<el-date-picker
							v-model="queryParams.orderDateStart"
							type="datetime"
							placeholder="选择时间"
							value-format="yyyy-MM-dd HH:mm:ss"
							size="mini"
						></el-date-picker>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="结束时间" prop="endTime">
						<el-date-picker
							v-model="queryParams.orderDateEnd"
							type="datetime"
							placeholder="选择时间"
							value-format="yyyy-MM-dd HH:mm:ss"
							size="mini"
						></el-date-picker>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="客户名称" prop="customer">
						<el-input
							v-model="queryParams.customer"
							placeholder="请输入客户名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="供应商" prop="supplierNames">
						<el-input
							v-model="queryParams.supplierNames"
							placeholder="请输入供应商名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="司机名称" prop="landDriverName">
						<el-input
							v-model="queryParams.landDriverName"
							placeholder="请输入司机名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="海运公司" prop="seaDriverName">
						<el-input
							v-model="queryParams.seaDriverName"
							placeholder="请输入海运公司"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="车队名称" prop="fleet">
						<el-input
							v-model="queryParams.fleet"
							placeholder="请输入车队名称"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="审核状态" prop="checkState">
						<el-select
							v-model="queryParams.checkState"
							placeholder="请选择"
							size="mini"
							clearable
						>
							<el-option
								v-for="item in options"
								:key="item.value"
								:label="item.label"
								:value="item.value"
							></el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="4">
					<el-form-item>
						<el-button
							type="primary"
							icon="el-icon-search"
							size="mini"
							@click="handleQuery"
						>
							搜索
						</el-button>
					</el-form-item>
					<el-form-item>
						<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
							>刷新
						</el-button>
					</el-form-item>
				</el-col>
			</el-row>
		</el-form>
	</div>
</template>
<script>
import { OptionInvent, Options } from '../../mixins/order/order_Invoice';

export default {
	name: 'QuerySearchBar',
	props: {},
	data() {
		return {
			// 选择框筛选
			optionInvent: OptionInvent, // 假设 OptionInvent 是已定义的数据
			options: Options, // 假设 Options 是已定义的数据,
			// 查询参数
			queryParams: {}
		};
	},
	methods: {
		// 处理查询的方法
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.queryParams.pageSize = 50;
			this.$emit('updateQuery', this.queryParams);
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.resetParams();
			this.handleQuery();
		},
		resetParams() {
			this.queryParams = {
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
				isAdjust: null,
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null,
				comments: null
			};
		}
	}
};
</script>
<style lang="scss" scoped></style>
