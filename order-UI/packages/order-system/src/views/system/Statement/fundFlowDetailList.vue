<template>
	<div class="bank-statement">
		<!-- 查询条件部分 -->
		<el-form :model="query" label-width="100px" class="query-form" :inline="true" size="mini">
			<el-form-item label="开始日期：" prop="startTime">
				<el-date-picker v-model="query.startTime" type="date" placeholder="选择开始日期" size="mini"
					value-format="yyyy-MM-dd" :clearable="false"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束日期：" prop="endTime">
				<el-date-picker v-model="query.endTime" type="date" placeholder="选择结束日期" size="mini"
					value-format="yyyy-MM-dd" :clearable="false" :disabled="!query.startTime"
					:picker-options="endTimePickerOptions"></el-date-picker>
			</el-form-item>
			<el-form-item label="我方卡号：" required>
				<el-row>
					<el-col :span="20">
						<el-input v-model="query.ourBankNO" placeholder="请输入我方卡号" size="mini" disabled></el-input>
					</el-col>
					<el-col :span="4">
						<SearchOption :get-data="listBankAccount" icon="el-icon-search"
							:limit-info="{ acountsType: '己方公司' }" query-label="银行卡查找" query-info="bankNo"
							:query-name="queryBank" @commitBack="value => (query.ourBankNO = value.bankNo)"
							@update:queryName="value => (queryBank = value)">
							<template #table-columns>
								<el-table-column label="公司名称" align="center" prop="companyName">
									<template #default="scope">
										{{ scope.row.companyName }}
									</template>
								</el-table-column>
								<el-table-column label="开户行" align="center" prop="bankName">
									<template #default="scope">
										{{ scope.row.bankName }}
									</template>
								</el-table-column>
								<el-table-column label="开户名" align="center" prop="acountsName">
									<template #default="scope">
										{{ scope.row.acountsName }}
									</template>
								</el-table-column>
								<el-table-column label="账号" align="center" prop="bankNo">
									<template #default="scope">
										{{ scope.row.bankNo }}
									</template>
								</el-table-column>
							</template>
						</SearchOption>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="银行账户类型" required>
				<BankType @updateSelectedType="
					value => {
						query.bankCardType = value;
					}
				" :baned="true" />
			</el-form-item>
			<el-form-item label="对象名称：">
				<el-input v-model="query.otherName" placeholder="请输入对象名称" size="mini"></el-input>
			</el-form-item>
			<el-form-item label="对方户名：">
				<el-input v-model="query.otherAccountName" placeholder="请输入对方户名" size="mini"></el-input>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="fetchStatementData" :loading="loading">查询</el-button>
				<el-button size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 银行流水明细表格  正借负贷 -->
		<el-table :data="statementData" border style="width: 100%" class="statement-table" size="mini"
			v-loading="loading" element-loading-text="数据加载中...">
			<el-table-column prop="operateDate" label="月" show-overflow-tooltip>
				<template slot-scope="{ row }">
					{{ row.operateDate ? row.operateDate.substring(5, 7) : '' }}
				</template>
			</el-table-column>
			<el-table-column prop="operateDate" label="日" show-overflow-tooltip>
				<template slot-scope="{ row }">
					{{ row.operateDate ? row.operateDate.substring(8, 9) : '' }}
				</template>
			</el-table-column>
			<el-table-column prop="operateDate" label="时间" show-overflow-tooltip>
				<template slot-scope="{ row }">
					{{ row.operateDate ? row.operateDate.substring(11, 16) : '' }}
				</template>
			</el-table-column>

			<el-table-column prop="payNO" label="凭证号数" show-overflow-tooltip></el-table-column>
			<el-table-column prop="changeType" label="类型(收款/付款)" show-overflow-tooltip></el-table-column>
			<el-table-column prop="displayPayType" label="支付类型" show-overflow-tooltip></el-table-column>
			<el-table-column prop="companyType" label="对象类型（客户/供应商/本公司/运费/票点/日常费用）"
				show-overflow-tooltip></el-table-column>
			<el-table-column prop="otherCompanyName" label="对象名称" show-overflow-tooltip></el-table-column>
			<el-table-column prop="otherAcountsName" label="对方户名（对方真实收付款名称）" show-overflow-tooltip></el-table-column>
			<el-table-column prop="otherBankNO" label="对方银行账号" show-overflow-tooltip></el-table-column>
			<el-table-column prop="changeType" label="摘要" show-overflow-tooltip></el-table-column>
			<!--			<el-table-column prop="tableName" label="业务表名" show-overflow-tooltip></el-table-column>-->
			<el-table-column prop="moneyAmount" label="借" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span>{{ row.moneyAmount > 0 ? row.moneyAmount : '' }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="moneyAmount" label="贷" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span>{{ row.moneyAmount > 0 ? '' : row.moneyAmount }}</span>
				</template>
			</el-table-column>
			<el-table-column label="方向" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span>{{ row.balance > 0 ? '借' : '贷' }}</span>
				</template>
			</el-table-column>
			<el-table-column prop="balance" label="余额" align="right" show-overflow-tooltip></el-table-column>

			<!--      加一个操作列-->
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template #default="{ row }">
					<el-button type="text" size="mini" @click="handleCheckDetail(row)">查看明细</el-button>
				</template>
			</el-table-column>
		</el-table>

		<!-- 数据为空时的提示 -->
		<el-empty v-if="!loading && statementData.length === 0" description="暂无数据"></el-empty>

		<div v-if="currentComponent">
			<DialogWrapper :current-component="currentComponent" :dialog-visible="dialogVisible" />
		</div>
	</div>
</template>

<script>
import { findFundFlowBalanceInLocalCurrencyAtDate, getFundFlowDetailList } from '@/api/system/statement'; // 假设你的请求方法在该文件中，需根据实际路径调整
import { TableName } from '@/api/tool/enums';
import { getReceiveMoneyByPayNo } from '@/api/system/receiveMoney';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import DialogWrapper from '@/views/dashboard/components/common/DialogWrapper.vue';
import RECEIVE_MONEY from '@/components/NeedToShow/RECEIVE_MONEY.vue';
import { getRecord } from '@/api/system/record';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import { getPaymentByNo } from '@/api/system/payment';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import BankType from '@/views/dashboard/components/common/BankType.vue';

export default {
	components: { BankType, SearchOption, DialogWrapper },
	mixins: [common_dialog],
	data() {
		return {
			queryBank: '',
			query: {
				startTime: '',
				endTime: '',
				otherName: '',
				otherAccountName: '',
				ourBankNO: '',
				bankCardType: ''
			},
			statementData: [], // 银行流水数据
			loading: false, // 加载状态
			endTimePickerOptions: {
				// 移除日期禁用限制，允许选择任何日期
				disabledDate: date => {
					return false;
				}
			}
		};
	},
	methods: {
		listBankAccount,
		handleCheckDetail(row) {
			// 如果表名是receiveMoney（表示收款的）则通过接口根据UUID获取收款信息详细信息 展示收款信息后用户可以在这里再联查其他表
			if (row.tableName === TableName.RECEIVE_MONEY) {
				getReceiveMoneyByPayNo(row.payNO).then(res => {
					if (res.data) {
						this.openDialog(
							RECEIVE_MONEY,
							'收款信息',
							'700px',
							{
								needToShowInfo: res.data
							},
							false
						);
					}
				});
			} else if (row.tableName === TableName.CASH_RECORD) {
				getRecord(row.payNO).then(res => {
					this.openDialog(
						OFFSETTING,
						`现金记账`,
						'700px',
						{
							needToShowInfo: res.data
						},
						false
					);
				});
			} else {
				getPaymentByNo(row.payNO).then(res => {
					this.openDialog(
						PAYMENT,
						`付款信息`,
						'700px',
						{
							needToShowInfo: res.data
						},
						false
					);
				});
			}
			//如果表名是cash_record，则直接根据payNo返回的是cash_record中表的主键，可以直接查询
			//其余类型均属于payment表，通过接口 获取付款信息详细信息根据uuid
			//根据UUID获取具体付款信息，用户可以在付款信息这里继续查看对应信息（因为这里有对应的表名和对应id）
		},
		// 获取银行流水数据
		fetchStatementData() {
			// 清空
			this.statementData = [];
			// 报表中是必须都要传递 但这里后端不传也可以 按照开始时间 如果不传就是至今
			if (!this.query.startTime || !this.query.endTime) {
				this.$message.warning('请选择开始日期和结束日期');
				return;
			}

			// 添加日期校验逻辑
			const startDate = new Date(this.query.startTime);
			const endDate = new Date(this.query.endTime);
			if (endDate < startDate) {
				this.$message.warning('结束日期不能早于开始日期');
				return;
			}

			this.loading = true;
			// 先查询上年指定时间结转
			const query = {
				startTime: this.query.startTime,
				ourBankNO: this.query.ourBankNO,
				bankCardType: this.query.bankCardType
			};
			findFundFlowBalanceInLocalCurrencyAtDate(query).then(async response => {
				if (response.code === 200) {
					const lastYearData = response.data;
					if (!lastYearData) {
						this.$message.error('查询上年结转数据失败');
						return;
					}

					getFundFlowDetailList(this.query).then(res => {
						if (res.code === 200) {
							this.statementData = res.data;
							this.statementData.unshift({
								...lastYearData,
								changeType: '上年结转'
							});
						} else {
							this.$message.error(res.msg || '获取银行流水数据失败');
						}
					});
				} else {
					this.$message.error(response.msg || '获取银行流水数据失败');
				}
			});
			this.loading = false;
		},
		// 重置查询条件
		resetQuery() {
			this.query = {
				startTime: '',
				endTime: '',
				ourUserName: '',
				otherName: '',
				otherAccountName: ''
			};
			this.statementData = [];
		}
	}
	// created() {
	// 	// 初始加载数据
	// 	this.fetchStatementData();
	// }
};
</script>

<style scoped>
.bank-statement {
	padding: 15px;
}

.query-form {
	margin-bottom: 15px;
}

.statement-table {
	font-size: 12px;
	margin-top: 15px;
}

.el-date-editor {
	width: 100%;
}
</style>
