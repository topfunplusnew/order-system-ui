<template>
	<div>
		<el-form
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="85px"
		>
			<el-row>
				<el-col :span="6">
					<el-form-item label="开始时间" prop="beginTime">
						<el-date-picker
							v-model="queryParams.orderDateStart"
							type="date"
							placeholder="选择时间"
							value-format="yyyy-MM-dd"
							size="mini"
							style="width: 70%"
						></el-date-picker>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="结束时间" prop="endTime">
						<el-date-picker
							v-model="queryParams.orderDateEnd"
							type="date"
							placeholder="选择时间"
							value-format="yyyy-MM-dd"
							style="width: 70%"
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
					<el-form-item label="车牌" prop="landCarNo">
						<el-input
							v-model="queryParams.landCarNo"
							placeholder="请输入车牌"
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
					<el-form-item label="柜号" prop="seaCarNo">
						<el-input
							v-model="queryParams.seaCarNo"
							placeholder="请输入柜号"
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
					<el-form-item label="录入员" prop="userName">
						<el-input
							v-model="queryParams.userName"
							placeholder="请输入录入员"
							clearable
							size="mini"
							@keyup.enter.native="handleQuery"
						></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="销售经理" prop="saleManager">
						<el-input
							v-model="queryParams.saleManager"
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
				<el-col :span="6">
					<el-form-item label="供应商是否开票">
						<el-select
							v-model="queryParams.params.isIncludeTaxSale"
							placeholder="请选择"
							size="mini"
							clearable
						>
							<el-option
								v-for="item in OptionInvent()"
								:key="item.value"
								:label="item.label"
								:value="item.value"
							></el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="客户是否开票">
						<el-select
							v-model="queryParams.params.isIncludeTaxFactory"
							placeholder="请选择"
							size="mini"
							clearable
						>
							<el-option
								v-for="item in OptionInvent()"
								:key="item.value"
								:label="item.label"
								:value="item.value"
							></el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-button
						type="primary"
						icon="el-icon-search"
						size="mini"
						@click="handleQuery"
					>
						搜索
					</el-button>
					<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
						>刷新
					</el-button>
				</el-col>
			</el-row>
		</el-form>
	</div>
</template>
<script>
import {
	OptionInvent,
	Options
} from '@/views/dashboard/mixins/order/order_Invoice';

export default {
	name: 'QuerySearchBar',
	props: {},
	data() {
		return {
			// 选择框筛选
			optionInvent: OptionInvent, // 假设 OptionInvent 是已定义的数据
			options: Options, // 假设 Options 是已定义的数据,
			// 查询参数
			queryParams: {
				params: {
					isIncludeTaxSale: null,
					isIncludeTaxFactory: null
				}
			}
		};
	},
	mounted() {
		// 清除搜索条件
		this.$bus.$on('select-goods:update', () => this.resetParams());
	},
	methods: {
		OptionInvent() {
			return OptionInvent;
		},
		// 处理查询的方法
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.queryParams.pageSize = 50;

			// 处理一下时间 客户要求开始时间和结束时间都是同一天 前端拼接零点和二十四点
			if (this.queryParams.orderDateStart && this.queryParams.orderDateEnd) {
				this.queryParams.orderDateStart =
					this.queryParams.orderDateStart + ' 00:00:00';
				this.queryParams.orderDateEnd =
					this.queryParams.orderDateEnd + ' 23:59:59';
			}
			// 提交
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
				// invoiceState: '未开票',
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
				isAdjust: '否',
				adjustOrderid: null,
				isedit: null,
				customerIsInvoice: null,
				isSupplierInvoice: null,
				comments: null,
				params: {
					isIncludeTaxSale: 0,
					isIncludeTaxFactory: 0
				}
			};
		}
	}
};
</script>
<style lang="scss" scoped></style>
