<script>
export default {
	name: 'BALANCEACCOUNT',
	props: {
		balanceData: {
			type: Object,
			default: () => ({})
		}
	}
};
</script>

<template>
	<div class="balance-account">
		<el-card class="balance-card">
			<el-descriptions title="结算账户详情" :column="2" border>
				<el-descriptions-item label="操作日期">
					{{ balanceData.operateDate || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="金额">
					{{ balanceData.moneyAmount ? balanceData.moneyAmount + ' 元' : '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司名称">
					{{ balanceData.companyName || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司ID">
					{{ balanceData.companyID || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="公司类型">
					{{ formatCompanyType(balanceData.companyType) }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ balanceData.comments || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="添加时间">
					{{ balanceData.addtime || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="用户ID">
					{{ balanceData.userId || '暂无数据' }}
				</el-descriptions-item>
				<el-descriptions-item label="用户名">
					{{ balanceData.userName || '暂无数据' }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<script>
export default {
	methods: {
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
