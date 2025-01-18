<!--查看订单-->
<script>
import { formatValue } from '../../../../api/tool/cons';

export default {
	name: 'OrderInfos',
	components: {},
	props: {
		orderInfo: {
			type: Object,
			default() {
				return {};
			}
		}
	},
	data() {
		return {};
	},
	created() {},
	mounted() {},
	methods: {
		formatValue,
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="订单信息" size="mini" border>
			<el-descriptions-item label="订单ID">
				{{ formatValue(orderInfo.id) }}
			</el-descriptions-item>
			<el-descriptions-item label="日期">
				{{ formatValue(orderInfo.orderDate) }}
			</el-descriptions-item>
			<el-descriptions-item label="客户">
				{{ formatValue(orderInfo.customer) }}
			</el-descriptions-item>
			<el-descriptions-item label="供应商名称">
				{{ formatValue(orderInfo.supplierNames) }}
			</el-descriptions-item>
			<el-descriptions-item label="审核状态">
				{{ formatValue(orderInfo.checkState) }}
			</el-descriptions-item>
			<el-descriptions-item label="打款状态">
				{{ formatValue(orderInfo.paymentState) }}
			</el-descriptions-item>
			<el-descriptions-item label="开票状态">
				{{ formatValue(orderInfo.invoiceState) }}
			</el-descriptions-item>
			<el-descriptions-item v-if="orderInfo.isAdjusted" label="调整日期">
				{{ formatValue(orderInfo.adjustDate) }}
			</el-descriptions-item>
			<el-descriptions-item
				v-if="
					orderInfo.customerIsInvoice !== null &&
					orderInfo.customerIsInvoice !== undefined &&
					orderInfo.customerIsInvoice !== ''
				"
				label="客户是否开票"
			>
				{{ orderInfo.customerIsInvoice === 0 ? '未开票' : '开票' }}
			</el-descriptions-item>
			<el-descriptions-item
				v-if="
					orderInfo.isSupplierInvoice !== null &&
					orderInfo.isSupplierInvoice !== undefined &&
					orderInfo.isSupplierInvoice !== ''
				"
				label="供应商是否开票"
			>
				{{ orderInfo.isSupplierInvoice === 0 ? '未开票' : '开票' }}
			</el-descriptions-item>
			<el-descriptions-item label="销售经理">
				{{ formatValue(orderInfo.saleManager) }}
			</el-descriptions-item>
			<el-descriptions-item label="车队">
				{{ formatValue(orderInfo.fleet) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运车牌">
				{{ formatValue(orderInfo.landCarNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运司机电话">
				{{ formatValue(orderInfo.landDriverTel) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运司机姓名">
				{{ formatValue(orderInfo.landDriverName) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运银行户名">
				{{ formatValue(orderInfo.landBankName) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运银行账号">
				{{ formatValue(orderInfo.landBankNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="柜号">
				{{ formatValue(orderInfo.seaCarNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运司机电话">
				{{ formatValue(orderInfo.seaDriverTel) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运公司">
				{{ formatValue(orderInfo.seaDriverName) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运银行户名">
				{{ formatValue(orderInfo.seaBankName) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运银行账号">
				{{ formatValue(orderInfo.seaBankNo) }}
			</el-descriptions-item>
			<el-descriptions-item label="陆运费">
				{{ formatValue(orderInfo.landFreight) }}
			</el-descriptions-item>
			<el-descriptions-item label="海运费">
				{{ formatValue(orderInfo.seaFreight) }}
			</el-descriptions-item>
			<el-descriptions-item label="总货款">
				{{ formatValue(orderInfo.allPayments) }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
