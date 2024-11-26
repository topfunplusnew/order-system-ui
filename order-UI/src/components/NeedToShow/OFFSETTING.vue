<script>
export default {
	name: 'OFFSETTING',
	props: {
		needToShowInfo: {
			type: Object
		}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="冲抵信息">
				<el-descriptions-item label="金额"
					>{{ needToShowInfo.amount }} 元</el-descriptions-item
				>
				<el-descriptions-item label="备注">{{
					needToShowInfo.remarks || '无'
				}}</el-descriptions-item>
				<el-descriptions-item label="时间"
					>{{ new Date(needToShowInfo.transactionTime).toLocaleString() }}
				</el-descriptions-item>
				<el-descriptions-item label="源公司名称">{{
					needToShowInfo.sourceCompanyName
				}}</el-descriptions-item>
				<el-descriptions-item label="源公司类型">{{
					needToShowInfo.sourceCompanyType
				}}</el-descriptions-item>
				<el-descriptions-item label="目标公司名称">{{
					needToShowInfo.targetCompanyName
				}}</el-descriptions-item>
				<el-descriptions-item label="目标公司类型">{{
					needToShowInfo.targetCompanyType
				}}</el-descriptions-item>
				<el-descriptions-item label="备注">{{
					needToShowInfo.remark || '无'
				}}</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
