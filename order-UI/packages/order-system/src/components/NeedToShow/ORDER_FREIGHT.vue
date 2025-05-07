<script>
export default {
	name: 'ORDERFREIGHT',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {}
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
		<el-descriptions title="订单运费信息">
			<el-descriptions-item label="运费类型">{{ needToShowInfo.freightType }}</el-descriptions-item>
			<el-descriptions-item label="金额">{{ needToShowInfo.moneyAmount }}</el-descriptions-item>
			<el-descriptions-item label="对方户名">{{ needToShowInfo.otherAcountsName }}</el-descriptions-item>
			<el-descriptions-item label="对方账号">{{ needToShowInfo.otherBankNo }}</el-descriptions-item>
			<el-descriptions-item label="对方开户行">{{ needToShowInfo.otherBankName }}</el-descriptions-item>
			<el-descriptions-item label="支付状态">{{ needToShowInfo.paymentState }}</el-descriptions-item>
			<el-descriptions-item label="司机姓名">{{ needToShowInfo.driverName }}</el-descriptions-item>
			<el-descriptions-item label="车牌号">{{ needToShowInfo.carNo }}</el-descriptions-item>
			<el-descriptions-item label="车队">{{ needToShowInfo.fleet }}</el-descriptions-item>
			<!--      <el-descriptions-item label="付款人员姓名">{{ needToShowInfo.payUserName }}</el-descriptions-item>-->
			<el-descriptions-item label="备注">{{ needToShowInfo.comments }}</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
