<script>
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';

export default {
	name: 'PAYMENT_APPLY_INFO',
	components: {},
	mixins: [common_dialog],
	props: {
		needToShowInfo: {
			type: Object,
			default: () => ({})
		}
	},
	data() {
		return {
			infoVisible: false
		};
	},
	methods: {
		handleCheck() {
			if (!this.needToShowInfo.id) {
				this.$message.warning('数据有误:缺少ID');
				return;
			}
			this.infoVisible = true;
		},
		formatDate(date) {
			return date || 'N/A';
		},
		handleReject() {},
		handleProcess() {}
	}
};
</script>

<template>
	<div>
		<el-card>
			<div slot="header" class="clearfix">
				<span>付款申请信息</span>
			</div>
			<el-descriptions :column="2" border>
				<el-descriptions-item label="申请ID">{{ needToShowInfo.id }}</el-descriptions-item>
				<el-descriptions-item label="公司名称">{{ needToShowInfo.companyName }}</el-descriptions-item>
				<el-descriptions-item label="公司类型">{{ needToShowInfo.companyType }}</el-descriptions-item>
				<el-descriptions-item label="资金日期">{{ formatDate(needToShowInfo.fundsDate) }}</el-descriptions-item>
				<el-descriptions-item label="付款类型">{{ needToShowInfo.payType }}</el-descriptions-item>
				<el-descriptions-item label="金额">{{ needToShowInfo.moneyAmount }} 元</el-descriptions-item>
				<el-descriptions-item label="收款公司">{{ needToShowInfo.otherAcountsName }}</el-descriptions-item>
				<el-descriptions-item label="收款银行">{{ needToShowInfo.otherBankName }}</el-descriptions-item>
				<el-descriptions-item label="收款账号">{{ needToShowInfo.otherBankNo }}</el-descriptions-item>
				<el-descriptions-item label="申请人">{{ needToShowInfo.userName }}</el-descriptions-item>
				<el-descriptions-item label="申请时间">{{ formatDate(needToShowInfo.addTime) }}</el-descriptions-item>
				<el-descriptions-item label="审核状态">{{ needToShowInfo.checkState }}</el-descriptions-item>
				<el-descriptions-item label="原因">{{ needToShowInfo.reason || '无' }}</el-descriptions-item>
				<el-descriptions-item label="备注">{{ needToShowInfo.comments || '无' }}</el-descriptions-item>
			</el-descriptions>

			<div class="audit-records">
				<h3>审核记录</h3>
				<el-table :data="needToShowInfo.auditInfoList" border style="width: 100%">
					<el-table-column prop="flowname" label="审核步骤" />
					<el-table-column prop="step" label="步骤" />
					<el-table-column prop="userName" label="审核人" />
					<el-table-column prop="auditdate" label="审核时间" />
					<el-table-column prop="checkState" label="审核状态" />
					<el-table-column prop="auditcomment" label="审核意见">
						<template slot-scope="scope">
							{{ scope.row.auditcomment || '无' }}
						</template>
					</el-table-column>
				</el-table>
			</div>
		</el-card>
	</div>
</template>

<style scoped lang="scss">
.el-descriptions {
	margin: 20px 0;
}

.audit-records {
	margin-top: 30px;
}

.audit-records h3 {
	margin-bottom: 15px;
	font-size: 16px;
	font-weight: bold;
}

.el-table {
	margin-top: 10px;
}
</style>
