<script>
export default {
	name: 'BANK_ACCEPTANCE',
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
		<el-descriptions :column="3" size="mini">
			<el-descriptions-item label="操作日期">{{ needToShowInfo.operateDate }}</el-descriptions-item>
			<el-descriptions-item label="票据号">{{ needToShowInfo.billNo }}</el-descriptions-item>
			<el-descriptions-item label="签发日期">{{ needToShowInfo.issueDate }}</el-descriptions-item>
			<el-descriptions-item label="到期日期">{{ needToShowInfo.dueDate }}</el-descriptions-item>
			<el-descriptions-item label="票据账户">{{ needToShowInfo.billAccount }}</el-descriptions-item>
			<el-descriptions-item label="票据日期">{{ needToShowInfo.billDate }}</el-descriptions-item>
			<el-descriptions-item label="票据类型">{{ needToShowInfo.billType }}</el-descriptions-item>
			<el-descriptions-item label="理由">{{ needToShowInfo.reason }}</el-descriptions-item>
			<el-descriptions-item label="票据金额">{{ needToShowInfo.billAmount }}</el-descriptions-item>
			<el-descriptions-item label="贴现点数">{{ needToShowInfo.inDiscountPoints }}</el-descriptions-item>
			<el-descriptions-item label="贴现金额">{{ needToShowInfo.inDiscountAmount }}</el-descriptions-item>
			<el-descriptions-item label="票据类别">{{ needToShowInfo.billCategory }}</el-descriptions-item>
			<el-descriptions-item label="来源">{{ needToShowInfo.origin }}</el-descriptions-item>
			<el-descriptions-item label="背书人">{{ needToShowInfo.endorser }}</el-descriptions-item>
			<el-descriptions-item label="被背书人">{{ needToShowInfo.endorsee }}</el-descriptions-item>
			<el-descriptions-item label="背书理由">{{ needToShowInfo.endorseReason }}</el-descriptions-item>
			<el-descriptions-item label="备注">{{ needToShowInfo.comments }}</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
