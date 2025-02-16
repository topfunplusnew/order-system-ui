<script>
export default {
	name: 'BANK_ACCEPTANCE',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-description :column="3" border size="mini">
			<el-description-item label="操作日期">{{ needToShowInfo.operateDate }}</el-description-item>
			<el-description-item label="票据号">{{ needToShowInfo.billNo }}</el-description-item>
			<el-description-item label="签发日期">{{ needToShowInfo.issueDate }}</el-description-item>
			<el-description-item label="到期日期">{{ needToShowInfo.dueDate }}</el-description-item>
			<el-description-item label="票据账户">{{ needToShowInfo.billAccount }}</el-description-item>
			<el-description-item label="票据日期">{{ needToShowInfo.billDate }}</el-description-item>
			<el-description-item label="票据类型">{{ needToShowInfo.billType }}</el-description-item>
			<el-description-item label="理由">{{ needToShowInfo.reason }}</el-description-item>
			<el-description-item label="票据金额">{{ needToShowInfo.billAmount }}</el-description-item>
			<el-description-item label="贴现点数">{{ needToShowInfo.inDiscountPoints }}</el-description-item>
			<el-description-item label="贴现金额">{{ needToShowInfo.inDiscountAmount }}</el-description-item>
			<el-description-item label="票据类别">{{ needToShowInfo.billCategory }}</el-description-item>
			<el-description-item label="来源">{{ needToShowInfo.origin }}</el-description-item>
			<el-description-item label="背书人">{{ needToShowInfo.endorser }}</el-description-item>
			<el-description-item label="被背书人">{{ needToShowInfo.endorsee }}</el-description-item>
			<el-description-item label="背书理由">{{ needToShowInfo.endorseReason }}</el-description-item>
			<el-description-item label="备注">{{ needToShowInfo.comments }}</el-description-item>
		</el-description>
	</div>
</template>

<style scoped lang="scss"></style>
