<script>
export default {
	name: 'INVOICEIN',
	props: {
		needToShowInfo: {
			type: Object
		}
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
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
