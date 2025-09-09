<script>
export default {
	name: 'OILRECHARGE',
	props: {
		needToShowInfo: {
			type: Object
		}
	},
	methods: {
		handleProcess() {
			return Promise.resolve();
		},
		handleReject() {
			return Promise.resolve();
		}
	}
};
</script>

<template>
	<div>
		<el-descriptions title="加油卡充值信息">
			<el-descriptions-item label="加油卡卡号">
				{{ needToShowInfo.oilCardNo }}
			</el-descriptions-item>
			<el-descriptions-item label="状态">
				{{ needToShowInfo.checkState }}
			</el-descriptions-item>
			<el-descriptions-item label="充值方式">
				{{ needToShowInfo.rechargeType }}
			</el-descriptions-item>
			<el-descriptions-item label="充值金额">
				{{ needToShowInfo.rechargeMoney }}
			</el-descriptions-item>
			<el-descriptions-item label="充值时间">
				{{ needToShowInfo.rechargeDate }}
			</el-descriptions-item>
			<el-descriptions-item label="充值人员姓名">
				{{ needToShowInfo.rechargeName }}
			</el-descriptions-item>
			<el-descriptions-item label="备注">
				{{ needToShowInfo.comments }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
