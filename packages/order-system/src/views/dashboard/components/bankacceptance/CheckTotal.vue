<script>
import { add, round, bignumber } from 'mathjs';
import InfoDialog from '../../../../components/InfoDialog.vue';
import { listBankAcceptanceBalanceMoney } from '../../../../api/system/bankAcceptance';

export default {
	name: 'CheckTotal',
	components: { InfoDialog },
	props: {
		row: {
			type: Object
		}
	},
	data() {
		return {
			loading: false,
			totalVisible: false,
			bankAcceptanceMoneyList: []
		};
	},
	methods: {
		handleCheck(row) {
			this.loading = true;
			listBankAcceptanceBalanceMoney({ billNo: row.billNo }).then(res => {
				this.bankAcceptanceMoneyList = res.rows;
				this.loading = false;
				this.totalVisible = true;
			});
		},
		/**
		 * 票据详情表格合计行
		 * @param {Object} param - { columns, data }
		 * @returns {string[]} 合计行每列的值
		 */
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			// 收入票据金额、收入贴息金额、支出票据金额、支出贴息金额 的列索引
			const sumColumnIndexes = [10, 12, 16, 18];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '合计';
					return;
				}
				if (!sumColumnIndexes.includes(index)) {
					sums[index] = '';
					return;
				}
				const values = (data || []).map(item => Number(item[column.property]) || 0);
				const total = values.reduce((acc, val) => add(acc, bignumber(val)), bignumber(0));
				sums[index] = round(total, 2).toString();
			});
			return sums;
		}
	}
};
</script>

<template>
	<div>
		<el-button type="text" size="mini" @click="handleCheck(row)">{{ row.billNo }}</el-button>

		<InfoDialog title="票据详情" :visible.sync="totalVisible">
			<template #info>
				<el-table
					id="printBox"
					v-loading="loading"
					v-horizontal-scroll="'always'"
					border
					:data="bankAcceptanceMoneyList"
					show-summary
					:summary-method="getSummaries"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
					height="480px"
				>
					<el-table-column label="ID" align="center" prop="id" width="120" show-overflow-tooltip />
					<el-table-column label="票据号码" align="center" prop="billNo" width="120" show-overflow-tooltip />
					<el-table-column label="出票日期" align="center" prop="issueDate" width="120" show-overflow-tooltip />
					<el-table-column label="到期日期" align="center" prop="dueDate" width="120" show-overflow-tooltip />
					<el-table-column label="我方承兑账户" align="center" prop="billAccount" width="120" show-overflow-tooltip />
					<el-table-column label="票据交易日期" align="center" prop="billDate" width="120" show-overflow-tooltip />
					<el-table-column label="收票事由" align="center" prop="incomeReason" width="120" show-overflow-tooltip />
					<el-table-column label="票据种类（电子/纸质）" align="center" prop="billCategory" width="120" show-overflow-tooltip />
					<el-table-column label="背书人(来源)" align="center" prop="incomeEndorserName" width="120" show-overflow-tooltip />
					<el-table-column label="收入票据来源" align="center" prop="incomeOrigin" width="120" show-overflow-tooltip />
					<el-table-column label="收入票据金额" align="center" prop="incomeBillAmount" width="120" show-overflow-tooltip />
					<el-table-column label="收入贴息点数" align="center" prop="incomeInDiscountPoints" width="120" show-overflow-tooltip />
					<el-table-column label="收入贴息金额" align="center" prop="incomeInDiscountAmount" width="120" show-overflow-tooltip />
					<el-table-column label="背书是由" align="center" prop="expenseReason" width="120" show-overflow-tooltip />
					<el-table-column label="被背书人" align="center" prop="expenseEndorserName" width="120" show-overflow-tooltip />
					<el-table-column label="支出票据来源" align="center" prop="expenseOrigin" width="120" show-overflow-tooltip />
					<el-table-column label="支出票据金额" align="center" prop="expenseBillAmount" width="120" show-overflow-tooltip />
					<el-table-column label="支出贴息点数" align="center" prop="expenseInDiscountPoints" width="120" show-overflow-tooltip />
					<el-table-column label="支出贴息金额" align="center" prop="expenseInDiscountAmount" width="120" show-overflow-tooltip />
					<el-table-column label="票据余额" align="center" prop="balance" width="120" show-overflow-tooltip />
					<el-table-column label="备注" align="center" prop="comments" width="120" show-overflow-tooltip />
				</el-table>
			</template>
		</InfoDialog>
	</div>
</template>

<style scoped lang="scss"></style>
