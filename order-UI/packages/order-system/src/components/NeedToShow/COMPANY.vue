<script>
export default {
	name: 'COMPANY',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {}
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
		<el-descriptions :column="3" title="公司信息">
			<el-descriptions-item label="名称">{{ needToShowInfo.companyName }}</el-descriptions-item>
			<el-descriptions-item label="联系人">{{ needToShowInfo.relationName }}</el-descriptions-item>
			<el-descriptions-item label="联系人电话">{{ needToShowInfo.relationTel }}</el-descriptions-item>
			<el-descriptions-item label="地址">{{ needToShowInfo.address }}</el-descriptions-item>
			<el-descriptions-item label="开户行">{{ needToShowInfo.bankName }}</el-descriptions-item>
			<el-descriptions-item label="开户名">{{ needToShowInfo.acountsName }}</el-descriptions-item>
			<el-descriptions-item label="账号">{{ needToShowInfo.bankNo }}</el-descriptions-item>
			<el-descriptions-item label="余额">{{ needToShowInfo.surplusMoney }}</el-descriptions-item>
			<el-descriptions-item label="客户类别">{{ needToShowInfo.companyType }}</el-descriptions-item>
			<el-descriptions-item label="业务员">{{ needToShowInfo.salesman }}</el-descriptions-item>
			<el-descriptions-item label="老板">{{ needToShowInfo.leader }}</el-descriptions-item>
			<el-descriptions-item label="老板联系人电话">{{ needToShowInfo.leaderTel }}</el-descriptions-item>
			<el-descriptions-item label="销售经理">{{ needToShowInfo.salesManager }}</el-descriptions-item>
			<el-descriptions-item label="省">{{ needToShowInfo.province }}</el-descriptions-item>
			<el-descriptions-item label="市县">{{ needToShowInfo.city }}</el-descriptions-item>
			<el-descriptions-item label="乡镇">{{ needToShowInfo.county }}</el-descriptions-item>
			<el-descriptions-item label="备注">{{ needToShowInfo.comments }}</el-descriptions-item>
			<el-descriptions-item label="区域">{{ needToShowInfo.region }}</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
