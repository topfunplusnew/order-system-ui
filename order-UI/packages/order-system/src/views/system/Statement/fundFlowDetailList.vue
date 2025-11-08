<template>
	<div class="bank-statement">
		<!-- 查询条件部分 -->
		<el-form id="top-search-form-item" :model="query" class="query-form" :inline="true" size="mini" label-width="150px">
			<el-form-item label="日期范围：" prop="dateRange">
				<el-date-picker v-model="query.dateRange" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" size="mini" style="width: 240px"></el-date-picker>
			</el-form-item>
			<el-form-item label="我方卡号：" required>
				<el-row>
					<el-col :span="20">
						<el-input v-model="query.ourBankNO" placeholder="请输入我方卡号" size="mini" disabled></el-input>
					</el-col>
					<el-col :span="4">
						<SearchOption
							:get-data="listBankAccount"
							icon="el-icon-search"
							:limit-info="{ acountsType: '己方公司' }"
							query-label="户名查找"
							query-info="acountsName"
							:query-name="queryBank"
							@commitBack="value => (query.ourBankNO = value.bankNo)"
							@update:queryName="value => (queryBank = value)"
						>
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
				<BankType
					@updateSelectedType="
						value => {
							query.bankCardType = value;
						}
					"
					:baned="true"
				/>
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

		<el-row :gutter="10" class="mb8">
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="fetchStatementData">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 银行流水明细表格  正借负贷 -->
		<u-table :data="statementData" border style="width: 100%" class="statement-table" size="mini" v-loading="loading" element-loading-text="数据加载中...">
			<CustomTableColumn v-if="columns[0].visible" prop="operateDate" label="日期" show-overflow-tooltip>
				<template slot-scope="{ row }">
					{{ row.operateDate ? dayjs(row.operateDate).format('YYYY-MM-DD') : '' }}
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[1].visible" prop="operateDate" label="时间" show-overflow-tooltip>
				<template slot-scope="{ row }">
					{{ row.operateDate ? dayjs(row.operateDate).format('HH:mm:ss') : '' }}
				</template>
			</CustomTableColumn>
			<!-- 将收入、支出、余额列移到时间列之后 -->
			<CustomTableColumn v-if="columns[10].visible" prop="moneyAmount" label="收入" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span v-if="row.moneyAmount > 0" style="color: #67c23a">￥{{ row.moneyAmount.toLocaleString('zh-CN', { minimumFractionDigits: 2 }) }}</span>
					<span v-else>￥0.00</span>
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[11].visible" prop="moneyAmount" label="支出" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span v-if="row.moneyAmount < 0" style="color: #f56c6c">￥{{ Math.abs(row.moneyAmount).toLocaleString('zh-CN', { minimumFractionDigits: 2 }) }}</span>
					<span v-else>￥0.00</span>
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[12].visible" prop="balance" label="余额" align="right" show-overflow-tooltip>
				<template #default="{ row }">
					<span :style="{ color: row.balance >= 0 ? '#67c23a' : '#f56c6c' }">￥{{ row.balance.toLocaleString('zh-CN', { minimumFractionDigits: 2 }) }}</span>
				</template>
			</CustomTableColumn>
			<CustomTableColumn v-if="columns[2].visible" prop="payNO" label="凭证号数" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[3].visible" prop="changeType" label="类型（收款/付款）" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[4].visible" prop="displayPayType" label="支付类型" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[5].visible" prop="otherCompanyType" label="对象类型" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[6].visible" prop="otherCompanyName" label="对象名称" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[7].visible" prop="otherAcountsName" label="对方户名" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[8].visible" prop="otherBankNO" label="对方银行卡号" show-overflow-tooltip></CustomTableColumn>
			<CustomTableColumn v-if="columns[9].visible" prop="changeType" label="摘要" show-overflow-tooltip></CustomTableColumn>

			<!--      加一个操作列-->
			<CustomTableColumn label="操作" align="center" class-name="small-padding fixed-width" fixed="right">
				<template #default="{ row }">
					<el-button type="text" size="mini" @click="handleCheckDetail(row)">查看明细</el-button>
				</template>
			</CustomTableColumn>
		</u-table>
	</div>
</template>

<script>
import { findFundFlowBalanceInLocalCurrencyAtDate, getFundFlowDetailList } from '@/api/system/statement'; // 假设你的请求方法在该文件中，需根据实际路径调整
import { TableName } from '@/api/tool/enums';
import { getReceiveMoneyByPayNo } from '@/api/system/receiveMoney';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import RECEIVE_MONEY from '@/components/NeedToShow/RECEIVE_MONEY.vue';
import { getRecord } from '@/api/system/record';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import { getPaymentByNo } from '@/api/system/payment';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import dayjs from 'dayjs';
import { getDepositMoney } from '@/api/system/depositMoney';
import DEPOSITMONEY from '@/components/NeedToShow/DEPOSITMONEY.vue';

export default {
	components: { BankType, SearchOption },
	mixins: [common_dialog],
	data() {
		const today = new Date().toISOString().split('T')[0];
		return {
			dayjs, // 将 dayjs 添加到 data 中，使其在模板中可用
			queryBank: '',
			showSearch: true,
			query: {
				dateRange: [],
				startTime: '',
				endTime: '',
				otherName: '',
				otherAccountName: '',
				ourBankNO: '',
				bankCardType: ''
			},
			statementData: [], // 银行流水数据
			loading: false, // 加载状态
			// 隐藏列信息
			columns: [
				{ key: 0, label: `日期`, visible: true },
				{ key: 1, label: `时间`, visible: true },
				{ key: 10, label: `收入`, visible: true },
				{ key: 11, label: `支出`, visible: true },
				{ key: 12, label: `余额`, visible: true },
				{ key: 2, label: `凭证号数`, visible: true },
				{ key: 3, label: `类型（收款/付款）`, visible: true },
				{ key: 4, label: `支付类型`, visible: true },
				{ key: 5, label: `对象类型`, visible: true },
				{ key: 6, label: `对象名称`, visible: true },
				{ key: 7, label: `对方户名`, visible: true },
				{ key: 8, label: `对方银行卡号`, visible: true },
				{ key: 9, label: `摘要`, visible: true }
			],
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
			} else if (row.tableName === TableName.DEPOSITMONEY) {
				getDepositMoney(row.payNO).then(res => {
					this.openDialog(
						DEPOSITMONEY,
						'收取保证金',
						'700px',
						{
							needToShowInfo: res.data
						},
						false
					);
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
			// 将日期范围转换为 startTime 和 endTime
			if (this.query.dateRange && this.query.dateRange.length === 2) {
				this.query.startTime = this.query.dateRange[0];
				this.query.endTime = this.query.dateRange[1];
			} else {
				this.query.startTime = '';
				this.query.endTime = '';
			}
			// 报表中是必须都要传递 但这里后端不传也可以 按照开始时间 如果不传就是至今
			if (!this.query.startTime || !this.query.endTime) {
				this.$message.warning('请选择开始日期和结束日期');
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
			const today = new Date().toISOString().split('T')[0];
			this.query = {
				dateRange: [today, today],
				startTime: today,
				endTime: today,
				ourBankNO: '',
				bankCardType: '',
				otherName: '',
				otherAccountName: ''
			};
			this.statementData = [];
		},
		/** 导出按钮操作 */
		handleExport() {
			// 将日期范围转换为 startTime 和 endTime
			if (this.query.dateRange && this.query.dateRange.length === 2) {
				this.query.startTime = this.query.dateRange[0];
				this.query.endTime = this.query.dateRange[1];
			} else {
				this.query.startTime = '';
				this.query.endTime = '';
			}
			// 验证必填参数
			if (!this.query.startTime || !this.query.endTime || !this.query.ourBankNO || !this.query.bankCardType) {
				this.$message.warning('请完善查询条件后再导出');
				return;
			}

			// 构建导出URL
			const baseUrl = '/statistics/export/FundFlowDetailList';
			const params = new URLSearchParams({
				startTime: this.query.startTime,
				endTime: this.query.endTime,
				ourBankNO: this.query.ourBankNO,
				bankCardType: this.query.bankCardType
			});

			// 添加可选参数
			if (this.query.otherName) {
				params.append('otherName', this.query.otherName);
			}
			if (this.query.otherAccountName) {
				params.append('otherAccountName', this.query.otherAccountName);
			}

			this.download(`${baseUrl}?${params.toString()}`, {}, `资金流水明细_${new Date().getTime()}.xlsx`);
		}
	},
	watch: {
		columns: {
			handler: function (newVal) {
				localStorage.setItem('fundflowdetail-columns', JSON.stringify(newVal));
			},
			deep: true
		}
	},
	created() {
		const today = new Date().toISOString().split('T')[0]; // 获取 YYYY-MM-DD 格式的当前日期
		this.query.dateRange = [today, today];
		this.query.startTime = today;
		this.query.endTime = today; // 同时也将结束时间设为今天

		if (localStorage.getItem('fundflowdetail-columns') === 'null' || !localStorage.getItem('fundflowdetail-columns')) {
			localStorage.setItem('fundflowdetail-columns', JSON.stringify(this.columns));
		} else {
			this.columns = JSON.parse(localStorage.getItem('fundflowdetail-columns'));
		}
	}
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
