<script>
export default {
	name: 'OILCARDCONSUME',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="加油卡消费信息">
			<el-descriptions-item label="加油卡卡号">
				{{ needToShowInfo.oilCardNo }}
			</el-descriptions-item>
			<el-descriptions-item label="使用加油卡时间">
				{{ needToShowInfo.useDate }}
			</el-descriptions-item>
			<el-descriptions-item label="使用加油卡车辆车牌号">
				{{ needToShowInfo.carNo }}
			</el-descriptions-item>
			<el-descriptions-item label="期初余额">
				{{ needToShowInfo.startCardSurplus }}
			</el-descriptions-item>
			<el-descriptions-item label="加油量(升)">
				{{ needToShowInfo.refuelingNumber }} 升
			</el-descriptions-item>
			<el-descriptions-item label="单价">
				{{ needToShowInfo.unitPrice }}
			</el-descriptions-item>
			<el-descriptions-item label="加油金额(元)">
				{{ needToShowInfo.refuelingMoney }} 元
			</el-descriptions-item>
			<el-descriptions-item label="充值金额(元)">
				{{ needToShowInfo.rechargeMoney }} 元
			</el-descriptions-item>
			<el-descriptions-item label="加油卡余额">
				{{ needToShowInfo.endCardSurplus }}
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.comments }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
