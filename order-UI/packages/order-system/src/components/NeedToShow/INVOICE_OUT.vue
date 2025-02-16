<script>
export default {
	name: 'INVOICEOUT',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="发票信息">
				<el-descriptions-item label="发票编号">{{ needToShowInfo.invoiceObject }}</el-descriptions-item>
				<el-descriptions-item label="发票日期">{{ needToShowInfo.invoiceDate }}</el-descriptions-item>
				<el-descriptions-item label="发票金额">{{ needToShowInfo.invoiceAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="公司类型">{{ needToShowInfo.companyType }}</el-descriptions-item>
				<el-descriptions-item label="公司名称">{{ needToShowInfo.companyName }}</el-descriptions-item>
				<el-descriptions-item label="发票公司名称">{{ needToShowInfo.invoiceCompanyName }}</el-descriptions-item>
				<el-descriptions-item label="票点">{{ needToShowInfo.ticketPoint }}</el-descriptions-item>
				<el-descriptions-item label="票点金额">{{ needToShowInfo.ticketPointAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="是否订单税">{{ needToShowInfo.isOrderTax === 1 ? '是' : '否' }}</el-descriptions-item>
				<el-descriptions-item label="欠款金额">{{ needToShowInfo.oweAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments || '无' }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
