<script>
import InvoiceItem from '@/views/dashboard/components/common/InvoiceItem.vue';
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
	name: 'InvoiceBody',
	components: { InvoiceItem },
	props: {},
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
			companyName: null,
			// 开票类型
			invoiceType: null,
			// 按钮的禁用状态
			op_customer: true,
			op_supplier: true,
			// 供应商的id  只用作搜索
			supplierId: null
		};
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		...mapGetters([
			'selectedInvoiceList',
			'selectedOrder',
			'ticketPoint',
			'comment',
			'invoiceAmount'
		])
	},
	methods: {
		// 批量发票卖出
		handleInvoiceOutBatch() {},
		// 批量发票买入
		handleInvoiceInBatch() {},
		// 分配金额的具体函数 选择某一个订单后要扣钱
		handleTransform(orderItem) {
			if (this.invoiceType === PUBLIC_DICT_TYPE.CUSTOMER) {
				return this.handleCustomer(orderItem);
			} else {
				return this.handleSupplier(orderItem);
			}
		},
		// 对客户进行处理
		handleCustomer(orderItem) {
			// 不存在id 返回null
			if (!orderItem.customerID) return null;
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
		},
		// 对供应商进行处理
		handleSupplier(orderItem) {
			if (
				!orderItem.smailOrderDetails ||
				orderItem.smailOrderDetails.length === 0
			)
				return null;

			// 先找到该检索的供应商
			const _suppliers = orderItem.smailOrderDetails.filter(item => {
				if (item.supplierID === this.supplierId) return item;
			});

			if (_suppliers.length === 0) return null;

			// 计算该供应商的出场货款
			const paymentFactory = _suppliers.reduce(
				(pre, cur) => pre + cur.paymentFactory,
				0
			);

			// 供应商
			return new InvoiceObject(
				parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				_suppliers[0].supplier,
				paymentFactory,
				PUBLIC_DICT_TYPE.SUPPLIER,
				_suppliers[0].supplier,
				_suppliers[0].supplierID, // 供应商id
				'山东鹏展',
				this.ticketPoint,
				Number(this.ticketPoint) * paymentFactory,
				orderItem.id,
				this.comment
			);
		},
		handleToggle(toggle) {
			this.op_customer = toggle;
			this.op_supplier = toggle;
		}
	},
	mounted() {
		this.$bus.$on('select-goods-row:update', () => {
			this.companyName = null;
			// 清空开票金额
			this.$store.dispatch('excel/clearInvoiceAmount');
		});
		this.$bus.$on('update-goods-order-company', value => {
			this.companyName = value.name;
			this.invoiceType = value.type;
			this.supplierId = value.id;
		});
	},
	beforeDestroy() {
		// 清除事件监听 防止内存泄漏
		this.$bus.$off('select-goods:update'); // 清理事件监听
		this.$bus.$off('update-goods-order-company');
	}
};
</script>

<template>
	<div>
		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span class="bold-text">开票信息 </span>
				<div v-if="companyName">{{ '公司名称：' + companyName }}</div>
				<div v-if="invoiceAmount">
					剩余开票金额： <span class="money">{{ invoiceAmount }}</span>
				</div>
			</div>
			<div class="invoice-list">
				<InvoiceItem
					v-for="(item, index) in selectedInvoiceList"
					:key="index"
					:invoice="item"
				/>
			</div>

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
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.bold-text {
	font-weight: bold;
}

.invoice-list {
	height: 670px;
	overflow-y: scroll;
}

.money {
	color: red;
}

.options {
	display: flex;

	el-button {
		margin-left: 10px;
	}
}
</style>
