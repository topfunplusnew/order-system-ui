<script>
export default {
	name: 'RECEIVEMONEY',
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
			<el-descriptions title="收款信息">
				<el-descriptions-item label="所属公司">{{
					needToShowInfo.companyName
				}}</el-descriptions-item>
				<el-descriptions-item label="收款编号">{{
					needToShowInfo.receiveNO
				}}</el-descriptions-item>
				<el-descriptions-item label="资金日期">{{
					needToShowInfo.fundsDate
				}}</el-descriptions-item>
				<el-descriptions-item label="收款类型">{{
					needToShowInfo.receiveType
				}}</el-descriptions-item>
				<el-descriptions-item label="金额"
					>{{ needToShowInfo.moneyAmount }} 元</el-descriptions-item
				>
				<el-descriptions-item label="付款账户名称">{{
					needToShowInfo.selfAcountsName
				}}</el-descriptions-item>
				<el-descriptions-item label="付款银行账号">{{
					needToShowInfo.selfBankNo
				}}</el-descriptions-item>
				<el-descriptions-item label="付款银行名称">{{
					needToShowInfo.selfBankName
				}}</el-descriptions-item>
				<el-descriptions-item label="付款银行类型">{{
					needToShowInfo.selfBankCardType
				}}</el-descriptions-item>
				<el-descriptions-item label="收款账户名称">{{
					needToShowInfo.otherAcountsName
				}}</el-descriptions-item>
				<el-descriptions-item label="收款银行账号">{{
					needToShowInfo.otherBankNo
				}}</el-descriptions-item>
				<el-descriptions-item label="收款银行名称">{{
					needToShowInfo.otherBankName
				}}</el-descriptions-item>
				<el-descriptions-item label="收款银行类型">{{
					needToShowInfo.otherBankCardType
				}}</el-descriptions-item>
				<el-descriptions-item label="备注">
					<el-tag size="small">{{ needToShowInfo.comments }}</el-tag>
				</el-descriptions-item>
			</el-descriptions>
		</el-card>
	</div>
</template>

<style scoped lang="scss"></style>
