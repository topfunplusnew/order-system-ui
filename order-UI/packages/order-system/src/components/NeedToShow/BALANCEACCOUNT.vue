<template>
	<div class="balance-account">
		<el-card class="balance-card">
			<el-descriptions title="结算账户详情" :column="2" border>
				<el-descriptions-item label="操作日期">
					{{ needToShowInfo.operateDate || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="金额">
					{{ needToShowInfo.moneyAmount ? needToShowInfo.moneyAmount + ' 元' : '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司名称">
					{{ needToShowInfo.companyName || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司ID">
					{{ needToShowInfo.companyID || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					{{ formatCompanyType(needToShowInfo.companyType) }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ needToShowInfo.comments || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="添加时间">
					{{ needToShowInfo.addtime || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="用户ID">
					{{ needToShowInfo.userId || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="用户名">
					{{ needToShowInfo.userName || '暂无数据' }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<script>
export default {
	name: 'BALANCEACCOUNT',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	methods: {
		handleProcess() {},
		handleReject() {},
		formatCompanyType(type) {
			switch (type) {
				case 1:
					return '供应商';
				case 2:
					return '客户';
				default:
					return '未知类型';
			}
		}
	}
};
</script>

<style scoped lang="scss">
.balance-account {
	padding: 20px;
}

.balance-card {
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.el-descriptions-item__label {
	font-weight: bold;
	color: #333;
}

.el-descriptions-item__content {
	color: #666;
}
</style>
