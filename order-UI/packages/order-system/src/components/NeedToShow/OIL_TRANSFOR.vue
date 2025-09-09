<script>
export default {
	name: 'OILTRANSFOR',
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
		<el-descriptions title="加油卡充值信息" :column="5" border size="mini">
			<el-descriptions-item label="主卡号">
				{{ needToShowInfo.oilMainCardNo }}
			</el-descriptions-item>
			<el-descriptions-item label="副卡号">
				{{ needToShowInfo.oilSecondCardNo }}
			</el-descriptions-item>
			<el-descriptions-item label="圈存金额">{{ needToShowInfo.rechargeMoney }} 元</el-descriptions-item>
			<el-descriptions-item label="圈存时间">
				{{ needToShowInfo.rechargeDate }}
			</el-descriptions-item>
			<el-descriptions-item label="圈存人员姓名">
				{{ needToShowInfo.rechargeName }}
			</el-descriptions-item>
			<el-descriptions-item label="操作人员">
				{{ needToShowInfo.userName || '暂无数据' }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
