<script>
export default {
	name: 'PAYMENT',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => {
				return {};
			}
		}
	}
};
</script>

<template>
	<div>
		<el-card>
			<el-descriptions title="付款信息">
				<el-descriptions-item label="所属公司">{{
					needToShowInfo.companyName
				}}</el-descriptions-item>
				<el-descriptions-item label="资金日期">{{
					needToShowInfo.fundsDate
				}}</el-descriptions-item>
				<el-descriptions-item label="付款类型">{{
					needToShowInfo.payType
				}}</el-descriptions-item>
				<el-descriptions-item label="金额"
					>{{ needToShowInfo.moneyAmount }} 元</el-descriptions-item
				>
				<el-descriptions-item label="付款状态">{{
					needToShowInfo.paymentState
				}}</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{
					needToShowInfo.auditState
				}}</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
