<script>
export default {
	name: 'REBATE',
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	computed: {
		detailList() {
			return this.needToShowInfo.actualReceivedDetails.detailList || [];
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
	<div class="rebate-container">
		<el-card shadow="hover" size="mini">
			<el-descriptions title="返利信息" :column="5" border size="mini">
				<el-descriptions-item label="返利金额">{{ needToShowInfo.rebate }} 元</el-descriptions-item>
				<el-descriptions-item label="返利日期">
					{{ new Date(needToShowInfo.rebateDate).toLocaleString() }}
				</el-descriptions-item>
				<el-descriptions-item label="返利类型">
					{{ needToShowInfo.rebateType }}
				</el-descriptions-item>
				<el-descriptions-item label="返利原因">
					{{ needToShowInfo.rebateReason }}
				</el-descriptions-item>
				<el-descriptions-item label="供应商">
					{{ needToShowInfo.supplier }}
				</el-descriptions-item>
				<el-descriptions-item label="入账账户名称">
					{{ needToShowInfo.inAcountsName }}
				</el-descriptions-item>
				<el-descriptions-item label="入账银行账号">
					{{ needToShowInfo.inBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="出账账户名称">
					{{ needToShowInfo.outAcountsName }}
				</el-descriptions-item>
				<el-descriptions-item label="出账银行账号">
					{{ needToShowInfo.outBankNo }}
				</el-descriptions-item>
				<el-descriptions-item label="备注">
					{{ needToShowInfo.comments || '无' }}
				</el-descriptions-item>
				<el-descriptions-item label="操作人员">
					{{ needToShowInfo.userName || '暂无数据' }}
				</el-descriptions-item>
			</el-descriptions>
			<el-divider></el-divider>

			<el-table :data="detailList" style="width: 100%">
				<el-table-column prop="actualReceived" label="实际收到金额">
					<template slot-scope="scope">{{ scope.row.actualReceived }} 元</template>
				</el-table-column>
				<el-table-column prop="actualReceivedDate" label="实际收到日期">
					<template slot-scope="scope">
						{{ new Date(scope.row.actualReceivedDate).toLocaleString() }}
					</template>
				</el-table-column>
			</el-table>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.rebate-container {
	padding: 20px;
	background-color: #f9f9f9;
}

.el-card {
	border-radius: 8px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.el-descriptions {
	margin-bottom: 20px;
}

.el-divider {
	margin: 20px 0;
}
</style>
