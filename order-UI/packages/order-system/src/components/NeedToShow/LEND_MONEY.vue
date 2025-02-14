<script>
export default {
	name: 'LENDMONEY',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {}
		}
	},
	methods: {
		handleProcess(that) {
			that.dialogVisible = false;
		},
		handleReject() {}
	}
};
</script>
<template>
	<div>
		<el-descriptions title="借款信息">
			<el-descriptions-item label="目标类型">
				{{ needToShowInfo.targetType }}
			</el-descriptions-item>
			<el-descriptions-item label="目标">
				{{ needToShowInfo.target }}
			</el-descriptions-item>
			<el-descriptions-item label="金额">
				{{ needToShowInfo.moneyAmount }} 元
			</el-descriptions-item>
			<el-descriptions-item label="目标账户名">
				{{ needToShowInfo.targetAcountsName }}
			</el-descriptions-item>
			<el-descriptions-item label="目标银行账号">
				{{ needToShowInfo.targetBankNo }}
			</el-descriptions-item>
			<el-descriptions-item label="目标开户银行">
				{{ needToShowInfo.targetBankName }}
			</el-descriptions-item>
			<el-descriptions-item label="本人账户名">
				{{ needToShowInfo.selfAcountsName }}
			</el-descriptions-item>
			<el-descriptions-item label="本人银行账号">
				{{ needToShowInfo.selfBankNo }}
			</el-descriptions-item>
			<el-descriptions-item label="本人开户银行">
				{{ needToShowInfo.selfBankName }}
			</el-descriptions-item>
			<el-descriptions-item label="期货日期">
				{{ needToShowInfo.futuresDate }}
			</el-descriptions-item>
			<el-descriptions-item label="借款原因">
				{{ needToShowInfo.reason }}
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.comments || '无' }}
			</el-descriptions-item>
			<el-descriptions-item label="添加时间">
				{{ needToShowInfo.addtime }}
			</el-descriptions-item>
			<el-descriptions-item label="审核状态">
				{{ needToShowInfo.checkState }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
