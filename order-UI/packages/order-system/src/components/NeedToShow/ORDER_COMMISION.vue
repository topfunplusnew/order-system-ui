<script>
export default {
	name: 'ORDER_COMMISION',
	props: {
		needToShowInfo: {
			type: Object,
			required: true
		}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="佣金信息">
			<el-descriptions-item label="订单号">{{ needToShowInfo.ordersNo }}</el-descriptions-item>
			<el-descriptions-item label="订单日期">{{ needToShowInfo.orderDate }}</el-descriptions-item>
			<el-descriptions-item label="公司名称">{{ needToShowInfo.companyName }}</el-descriptions-item>
			<el-descriptions-item label="等级名称">{{ needToShowInfo.levelName }}</el-descriptions-item>
			<el-descriptions-item label="计数单位">{{ needToShowInfo.countingUnit }}</el-descriptions-item>
			<el-descriptions-item label="高度">{{ needToShowInfo.height }}</el-descriptions-item>
			<el-descriptions-item label="长度">{{ needToShowInfo.length }}</el-descriptions-item>
			<el-descriptions-item label="宽度">{{ needToShowInfo.width }}</el-descriptions-item>
			<el-descriptions-item label="每包片数">{{ needToShowInfo.piecesPerPack }}</el-descriptions-item>
			<el-descriptions-item label="包数">{{ needToShowInfo.packs }}</el-descriptions-item>
			<el-descriptions-item label="实际片数">{{ needToShowInfo.actualPieces }}</el-descriptions-item>
			<el-descriptions-item label="卸货付款">{{ needToShowInfo.paymentUnload }}</el-descriptions-item>
			<el-descriptions-item label="销售是否含税">{{ needToShowInfo.isIncludeTaxSale === 0 ? '否' : '是' }}</el-descriptions-item>
			<el-descriptions-item label="杂费">{{ needToShowInfo.sundryCost }}</el-descriptions-item>
			<el-descriptions-item label="付款金额">{{ needToShowInfo.payments }}</el-descriptions-item>
			<el-descriptions-item label="利润">{{ needToShowInfo.profit }}</el-descriptions-item>
			<el-descriptions-item label="不含税利润">{{ needToShowInfo.profitNoTax }}</el-descriptions-item>
			<el-descriptions-item label="备注">{{ needToShowInfo.comments }}</el-descriptions-item>
			<el-descriptions-item label="面积">{{ needToShowInfo.area }}</el-descriptions-item>
			<el-descriptions-item label="佣金单价">{{ needToShowInfo.commissionUnitPrice }}</el-descriptions-item>
			<el-descriptions-item label="已验证佣金">{{ needToShowInfo.verifiedCommission }}</el-descriptions-item>
			<el-descriptions-item label="其他付款金额">{{ needToShowInfo.otherPaymentAmount }}</el-descriptions-item>
			<el-descriptions-item label="佣金金额">{{ needToShowInfo.commissionAmount }}</el-descriptions-item>
			<el-descriptions-item label="实际客户佣金">{{ needToShowInfo.actualCustomerCommission }}</el-descriptions-item>
			<el-descriptions-item label="资金日期">{{ needToShowInfo.fundDate }}</el-descriptions-item>
			<el-descriptions-item label="差异">{{ needToShowInfo.difference }}</el-descriptions-item>
			<el-descriptions-item label="差异原因">{{ needToShowInfo.differenceReason }}</el-descriptions-item>
			<el-descriptions-item label="其他账户名称">{{ needToShowInfo.otherAcountsName }}</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
