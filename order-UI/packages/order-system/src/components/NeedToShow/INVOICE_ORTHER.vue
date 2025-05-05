<script>
export default {
	name: 'INVOICEORTHER',
	props: {
		needToShowInfo: {
			type: Object
		}
	},
	methods: {
		handleProcess() {},
		handleReject() {}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="发票信息">
				<el-descriptions-item label="订单号">{{ needToShowInfo.ordersNo }}</el-descriptions-item>
				<el-descriptions-item label="发票日期">{{ needToShowInfo.invoiceDate }}</el-descriptions-item>
				<el-descriptions-item label="发票金额">{{ needToShowInfo.invoiceAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="供应商">{{ needToShowInfo.supplier }}</el-descriptions-item>
				<el-descriptions-item label="供应商票点">{{ needToShowInfo.supplierTicketPoint }}</el-descriptions-item>
				<el-descriptions-item label="供应商票点金额">{{ needToShowInfo.supplierPointAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="客户">{{ needToShowInfo.customer }}</el-descriptions-item>
				<el-descriptions-item label="客户票点">{{ needToShowInfo.customerTicketPoint }}</el-descriptions-item>
				<el-descriptions-item label="客户票点金额">{{ needToShowInfo.customerPointAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>

				<!-- 添加 extraInfo 相关信息展示 -->
				<el-descriptions-item label="实际开票金额">
					{{ needToShowInfo.extraInfo && needToShowInfo.extraInfo.actualInvoiceAmount }}
				</el-descriptions-item>
				<el-descriptions-item label="实际开票时间">
					{{ needToShowInfo.extraInfo && needToShowInfo.extraInfo.actualInvoiceTime }}
				</el-descriptions-item>
				<el-descriptions-item label="当月欠票金额">
					{{ needToShowInfo.extraInfo && needToShowInfo.extraInfo.currentMonthOweInvoiceAmount }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">{{ needToShowInfo.extraInfo && needToShowInfo.extraInfo.comment }}</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
