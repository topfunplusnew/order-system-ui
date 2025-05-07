<template>
	<div>
		<el-description :column="3" border size="mini">
			<el-description-item label="名称">{{ needToShowInfo.companyName }}</el-description-item>
			<el-description-item label="联系人">{{ needToShowInfo.relationName }}</el-description-item>
			<el-description-item label="联系人电话">{{ needToShowInfo.relationTel }}</el-description-item>
			<el-description-item label="地址">{{ needToShowInfo.address }}</el-description-item>
			<el-description-item label="开户行">{{ needToShowInfo.bankName }}</el-description-item>
			<el-description-item label="开户名">{{ needToShowInfo.acountsName }}</el-description-item>
			<el-description-item label="账号">{{ needToShowInfo.bankNo }}</el-description-item>
			<el-description-item label="余额">{{ needToShowInfo.surplusMoney }}</el-description-item>
			<el-description-item label="客户类别">{{ needToShowInfo.companyType }}</el-description-item>
			<el-description-item label="业务员">{{ needToShowInfo.salesman }}</el-description-item>
			<el-description-item label="老板">{{ needToShowInfo.leader }}</el-description-item>
			<el-description-item label="老板联系人电话">{{ needToShowInfo.leaderTel }}</el-description-item>
			<el-description-item label="销售经理">{{ needToShowInfo.salesManager }}</el-description-item>
			<el-description-item label="省">{{ needToShowInfo.province }}</el-description-item>
			<el-description-item label="市县">{{ needToShowInfo.city }}</el-description-item>
			<el-description-item label="乡镇">{{ needToShowInfo.county }}</el-description-item>
			<el-description-item label="备注">{{ needToShowInfo.comments }}</el-description-item>
			<el-description-item label="区域">{{ needToShowInfo.province + needToShowInfo.city + needToShowInfo.county }}</el-description-item>
		</el-description>
	</div>
</template>

<script>
export default {
	name: 'SUPPLIER',
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

<style scoped lang="scss">
.el-description {
	margin-top: 20px;
}

.el-description-item {
	padding: 8px;
}
</style>
