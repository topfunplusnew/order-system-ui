<template>
	<div>
		<el-form
			ref="queryForm"
			:model="queryItems"
			size="mini"
			:inline="true"
			label-width="70px"
		>
			<el-row>
				<el-col :span="6">
					<el-form-item label="开始时间" prop="beginTime">
						<el-date-picker
							v-model="queryItems.orderDateStart"
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
							v-model="queryItems.orderDateEnd"
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
							v-model="queryItems.customer"
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
							v-model="queryItems.supplierNames"
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
							v-model="queryItems.landDriverName"
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
							v-model="queryItems.seaDriverName"
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
							v-model="queryItems.fleet"
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
							v-model="queryItems.checkState"
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
				</el-col>
			</el-row>
		</el-form>

		<!--    批量开票-->
		<div class="options">
			<el-button
				v-if="invoiceType === PUBLIC_DICT_TYPE.CUSTOMER"
				type="success"
				size="mini"
				:disabled="op_customer"
				@click="handleInvoiceOutBatch"
			>
				开具客户发票
			</el-button>
			<el-button
				v-if="invoiceType === PUBLIC_DICT_TYPE.SUPPLIER"
				type="success"
				size="mini"
				:disabled="op_supplier"
				@click="handleInvoiceInBatch"
			>
				开具供应商发票
			</el-button>
		</div>
	</div>
</template>
<script>
import { OptionInvent, Options } from '../../mixins/order/order_Invoice';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { parseTime } from '@/utils/ruoyi';

// 发票对象
export class InvoiceObject {
	constructor(
		invoiceDate,
		invoiceObject,
		invoiceAmount,
		companyType,
		companyName,
		companyID,
		invoiceCompanyName,
		ticketPoint,
		ticketPointAmount,
		isOrderTax,
		comments
	) {
		this.invoiceDate = invoiceDate;
		this.invoiceObject = invoiceObject;
		this.invoiceAmount = invoiceAmount;
		this.companyType = companyType;
		this.companyName = companyName;
		this.companyID = companyID;
		this.invoiceCompanyName = invoiceCompanyName;
		this.ticketPoint = ticketPoint;
		this.ticketPointAmount = ticketPointAmount;
		this.isOrderTax = isOrderTax;
		this.comments = comments;
	}
}

export default {
	name: 'QuerySearchBar',
	props: {
		queryParams: {
			type: Object,
			default: () => ({})
		}
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		// 计算属性，用来处理 queryParams 的 get 和 set
		queryItems: {
			get() {
				return this.queryParams;
			},
			set(val) {
				this.$emit('updateQuery', val); // 触发父组件的更新事件
			}
		},
		...mapGetters(['selectedOrder', 'ticketPoint', 'comment'])
	},
	watch: {
		// 监听选择订单的变化
		selectedOrder: {
			handler(val) {
				console.log(val);
				// 判断是否长度大于0
				typeof val === 'object' && val.length > 0
					? this.handleToggle(false)
					: this.handleToggle(true);

				// 先清除上一次的状态
				this.$store.dispatch('excel/clearSelectedInvoiceList');

				// 对选择的每一个订单进行转换处理 把订单对象转为开票对象
				const invoiceList = val.map(element => {
					return this.handleTransform(element);
				});

				// 存储vuex
				this.$store.dispatch('excel/setSelectedInvoiceList', invoiceList);
			},
			immediate: true,
			deep: true
		}
	},
	data() {
		return {
			// 选择框筛选
			optionInvent: OptionInvent, // 假设 OptionInvent 是已定义的数据
			options: Options, // 假设 Options 是已定义的数据
			// 按钮的禁用状态
			op_customer: true,
			op_supplier: true,

			// 开票类型
			invoiceType: null
		};
	},
	methods: {
		// 批量发票卖出
		handleInvoiceOutBatch() {},
		// 批量发票买入
		handleInvoiceInBatch() {},
		// todo 分配金额的具体函数 选择某一个订单后要扣钱
		handleTransform(orderItem) {
			if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
				// 客户
				return new InvoiceObject(
					parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
					'山东鹏展',
					orderItem.allPayments,
					PUBLIC_DICT_TYPE.CUSTOMER,
					orderItem.customer,
					orderItem.customerID,
					orderItem.customer,
					this.ticketPoint,
					Number(this.ticketPoint) * Number(orderItem.allPayments),
					orderItem.id,
					this.comment
				);
			} else {
				// 拿到出厂货款
				const paymentFactory = orderItem.smailOrderDetails.reduce(
					(acc, cur) => acc + cur.paymentFactory,
					0
				);
				// 供应商
				return new InvoiceObject(
					parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
					orderItem.supplier, // 同理
					paymentFactory,
					PUBLIC_DICT_TYPE.SUPPLIER,
					// todo 这里是数组中 不好操作
					orderItem.supplier,
					orderItem.supplierID, // 供应商id
					'山东鹏展',
					this.ticketPoint,
					Number(this.ticketPoint) * paymentFactory,
					orderItem.id,
					this.comment
				);
			}
		},
		// 处理查询的方法
		handleQuery() {
			this.$emit('updateQuery', this.queryItems);
		},
		handleToggle(toggle) {
			this.op_customer = toggle;
			this.op_supplier = toggle;
		}
	},
	mounted() {
		this.$bus.$on('update-goods-order-company', value => {
			this.invoiceType = value.type;
		});
	}
};
</script>
<style lang="scss" scoped>
.options {
	display: flex;

	el-button {
		margin-left: 10px;
	}
}
</style>
