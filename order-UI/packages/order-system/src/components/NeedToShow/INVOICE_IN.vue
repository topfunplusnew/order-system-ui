<script>
export default {
	name: 'INVOICEIN',
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
		<el-descriptions title="开票信息">
			<el-descriptions-item label="开票日期">{{ needToShowInfo.invoiceDate }}</el-descriptions-item>
			<el-descriptions-item label="我方收票实体">{{ needToShowInfo.invoiceObject }}</el-descriptions-item>
			<el-descriptions-item label="开票金额">{{ needToShowInfo.invoiceAmount }}</el-descriptions-item>
			<el-descriptions-item label="对方公司类别">{{ needToShowInfo.companyType }}</el-descriptions-item>
			<el-descriptions-item label="对方公司名称">{{ needToShowInfo.companyName }}</el-descriptions-item>
			<el-descriptions-item label="票据单位名称">{{ needToShowInfo.invoiceCompanyName }}</el-descriptions-item>
			<el-descriptions-item label="票点">{{ needToShowInfo.ticketPoint }}</el-descriptions-item>
			<el-descriptions-item label="票点金额">{{ needToShowInfo.ticketPointAmount }}</el-descriptions-item>

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
	</div>
</template>

<style scoped lang="scss"></style>
