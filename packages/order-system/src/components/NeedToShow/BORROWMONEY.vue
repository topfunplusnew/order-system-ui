<script>
export default {
	name: 'BORROWMONEY',
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
		<el-descriptions title="借款信息" :column="5" border size="mini">
			<el-descriptions-item label="户名">{{ needToShowInfo.acountsName }}</el-descriptions-item>
			<el-descriptions-item label="抵押担保">{{ needToShowInfo.mortgageGuarantee }}</el-descriptions-item>
			<el-descriptions-item label="贷款来源">{{ needToShowInfo.origin }}</el-descriptions-item>
			<el-descriptions-item label="贷款发放日期">{{ needToShowInfo.loanDate }}</el-descriptions-item>
			<el-descriptions-item label="贷款时间">{{ needToShowInfo.loanDuring }}</el-descriptions-item>
			<el-descriptions-item label="打入账户">{{ needToShowInfo.acountsName }}</el-descriptions-item>
			<el-descriptions-item label="打入账号">{{ needToShowInfo.bankNo }}</el-descriptions-item>
			<el-descriptions-item label="操作人员">
				{{ needToShowInfo.userName || '暂无数据' }}
			</el-descriptions-item>
		</el-descriptions>
	</div>
</template>

<style scoped lang="scss"></style>
