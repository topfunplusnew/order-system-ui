<script>
import InvoiceItem from '@/views/dashboard/components/common/InvoiceItem.vue';
import { mapGetters } from 'vuex';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { parseTime } from '@/utils/ruoyi';
import { getUuid } from '@/utils/trash/utils';
import { TableName } from '@/api/tool/enums';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import ReadyList from '@/views/dashboard/components/common/ReadyList.vue';

// 发票对象
export class InvoiceObject {
	constructor(invoiceDate, invoiceObject, invoiceAmount, companyType, companyName, companyID, invoiceCompanyName, ticketPoint, ticketPointAmount, isOrderTax, comments) {
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
		// 随机生成一个uuid
		this.params = {
			uuid: getUuid(),
			tableName: this.companyType === PUBLIC_DICT_TYPE.CUSTOMER ? TableName.INVOICE_OUT : TableName.INVOICE_IN
		};
	}
}

export default {
	name: 'InvoiceBody',
	components: { DialogWrapper, InvoiceItem },
	mixins: [common_dialog],
	props: {},
	watch: {
		// 监听选择订单的变化
		selectedOrder: {
			handler(val) {
				// 判断是否长度大于0
				typeof val === 'object' && val.length > 0 ? this.handleToggle(false) : this.handleToggle(true);

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
		...mapGetters(['selectedInvoiceList', 'selectedOrder', 'ticketPoint', 'comment', 'invoiceAmount'])
	},
	methods: {
		// 批量开发票
		async handleInvoiceBatch() {
			// 首先从vuex拿出数据
			const invoiceList = this.$store.getters.selectedInvoiceList;

			// 校验一下
			if (invoiceList.length === 0) {
				this.$message.warning('开票列表为空,请检查!');
			}

			// 弹出弹窗 让用户检查
			this.handleCheckInvoice(invoiceList);
		},

		// 校验
		handleCheckInvoice(resultList) {
			// 打开弹窗
			this.openDialog(
				ReadyList,
				'待开票列表',
				'900px',
				{
					list: resultList
				},
				false
			);
		},
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
				// 己方公司实体
				sessionStorage.getItem('us'),
				Number(orderItem.allPayments),
				PUBLIC_DICT_TYPE.CUSTOMER,
				orderItem.customer,
				orderItem.customerID,
				orderItem.customer,
				0,
				Number(orderItem.allPayments),
				orderItem.id,
				this.comment
			);
		},
		// 对供应商进行处理
		handleSupplier(orderItem) {
			if (!orderItem.smailOrderDetails || orderItem.smailOrderDetails.length === 0) return null;

			// 先找到该检索的供应商
			const _suppliers = orderItem.smailOrderDetails.filter(item => {
				if (item.supplierID === this.supplierId) return item;
			});

			if (_suppliers.length === 0) return null;

			// 计算该供应商的出场货款
			const paymentFactory = _suppliers.reduce((pre, cur) => pre + cur.paymentFactory, 0);

			// 供应商
			return new InvoiceObject(
				parseTime(new Date(), '{y}-{m}-{d} {h}:{i}:{s}'),
				sessionStorage.getItem('us'),
				Number(paymentFactory),
				PUBLIC_DICT_TYPE.SUPPLIER,
				_suppliers[0].supplier,
				_suppliers[0].supplierID, // 供应商id
				_suppliers[0].supplier,
				0,
				Number(paymentFactory),
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

		this.$bus.$on('invoice-clear', () => {
			// 重置开票金额
			sessionStorage.clear();
			this.$store.dispatch('excel/clearInvoiceAmount');
			// 重置开票列表
			this.$store.dispatch('excel/clearSelectedInvoiceList');
			// 清除右上角公司信息
			this.companyName = null;
			this.invoiceType = null;
			this.supplierId = null;
		});
	},
	beforeDestroy() {
		// 清除事件监听 防止内存泄漏
		this.$bus.$off('select-goods:update'); // 清理事件监听
		this.$bus.$off('update-goods-order-company');
		this.$bus.$off('invoice-clear');
	}
};
</script>

<template>
	<div>
		<el-card class="box-card">
			<div slot="header" class="clearfix">
				<span class="bold-text">开票信息</span>
			</div>
			<div>{{ '公司名称：' + (companyName ? companyName : '无') }}</div>
			<div>
				剩余开票金额：
				<span class="money">{{ invoiceAmount ? invoiceAmount : '无' }}</span>
			</div>
			<div class="invoice-list">
				<InvoiceItem v-for="(item, index) in selectedInvoiceList" :key="index" :invoice="item" />
			</div>

			<!--    批量开票-->
			<div class="options">
				<el-button v-if="invoiceType === PUBLIC_DICT_TYPE.CUSTOMER" type="success" size="mini" :disabled="op_customer" @click="handleInvoiceBatch">开具客户发票</el-button>
				<el-button v-if="invoiceType === PUBLIC_DICT_TYPE.SUPPLIER" type="success" size="mini" :disabled="op_supplier" @click="handleInvoiceBatch">开具供应商发票</el-button>
			</div>
		</el-card>

		<!--    通用弹窗 配合common_dialogs 使用-->
		<div v-if="currentComponent">
			<DialogWrapper
				:current-component="currentComponent"
				:dialog-visible="dialogVisible"
				:dialog-props="dialogProps"
				:dialog-title="dialogTitle"
				:dialog-width="dialogWidth"
				@update:dialogVisible="args => (dialogVisible = false)"
				@close="handleCloseDialog"
				@confirm="handleDialogConfirm"
			/>
		</div>
	</div>
</template>

<style scoped lang="scss">
.bold-text {
	font-weight: bold;
}

.invoice-list {
	height: 600px;
	overflow-y: scroll;
}

.money {
	color: red;
	font-weight: bolder;
}

.options {
	display: flex;
	justify-content: center;
	align-items: center;

	el-button {
		margin-left: 10px;
	}
}
</style>
