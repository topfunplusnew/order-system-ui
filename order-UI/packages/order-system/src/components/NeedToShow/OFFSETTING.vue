<template>
	<div>
		<el-card>
			<el-descriptions title="冲抵信息" :column="5" border size="mini">
				<el-descriptions-item label="金额">{{ needToShowInfo.amount }}</el-descriptions-item>
				<el-descriptions-item label="备注">{{ needToShowInfo.remarks || '无' }}</el-descriptions-item>
				<el-descriptions-item label="时间">{{ formatDate(needToShowInfo.transactionTime) }}</el-descriptions-item>
				<el-descriptions-item label="支出方公司名称">{{ needToShowInfo.sourceCompanyName || '无' }}</el-descriptions-item>
				<el-descriptions-item label="支出方公司类型">{{ needToShowInfo.sourceCompanyType || '无' }}</el-descriptions-item>
				<el-descriptions-item label="收入方公司名称">{{ needToShowInfo.targetCompanyName || '无' }}</el-descriptions-item>
				<el-descriptions-item label="收入方公司类型">{{ needToShowInfo.targetCompanyType || '无' }}</el-descriptions-item>
				<el-descriptions-item label="备注">{{ needToShowInfo.remark || '无' }}</el-descriptions-item>
				<el-descriptions-item label="操作人员">
					{{ needToShowInfo.userName || '暂无数据' }}
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<script>
export default {
	name: 'OFFSETTING',
	props: {
		needToShowInfo: {
			type: Object,
			required: true // 确保传入的对象是必需的
		}
	},
	methods: {
		formatDate(dateString) {
			if (!dateString) return '无'; // 如果日期为空，返回 '无'
			const date = new Date(dateString);
			return date.toLocaleString(); // 格式化日期
		},
		handleReject() {
			return Promise.resolve();
		},
		handleProcess() {
			return Promise.resolve();
		}
	}
};
</script>

<style scoped lang="scss">
/* 样式可以根据需求进行定制 */
</style>
