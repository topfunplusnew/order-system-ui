<template>
	<div class="bank-statement">
		<!-- 查询条件部分 -->
		<el-form :model="query" label-width="100px" class="query-form" :inline="true">
			<el-form-item label="开始日期：" prop="startTime">
				<el-date-picker v-model="query.startTime" type="date" placeholder="选择开始日期" size="small" value-format="yyyy-MM-dd" :clearable="false"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束日期：" prop="endTime">
				<el-date-picker
					v-model="query.endTime"
					type="date"
					placeholder="选择结束日期"
					size="small"
					value-format="yyyy-MM-dd"
					:clearable="false"
					:disabled="!query.startTime"
					:picker-options="endTimePickerOptions"
				></el-date-picker>
			</el-form-item>
			<el-form-item label="我方卡号：" required>
				<el-input v-model="query.ourBankNO" placeholder="请输入我方卡号" size="small"></el-input>
			</el-form-item>
			<el-form-item label="对象名称：">
				<el-input v-model="query.otherName" placeholder="请输入对象名称" size="small"></el-input>
			</el-form-item>
			<el-form-item label="对方户名：">
				<el-input v-model="query.otherAccountName" placeholder="请输入对方户名" size="small"></el-input>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="small" @click="fetchStatementData" :loading="loading">查询</el-button>
				<el-button size="small" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 银行流水明细表格  正借负贷 -->
		<el-table :data="statementData" border style="width: 100%" class="statement-table" size="mini" v-loading="loading" element-loading-text="数据加载中...">
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
			<el-table-column prop="companyType" label="对象类型（客户/供应商/本公司/运费/票点/日常费用）" show-overflow-tooltip></el-table-column>
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
					<span>{{ row.moneyAmount < 0 ? row.moneyAmount : '' }}</span>
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
	</div>
</template>

<script>
import { findFundFlowBalanceInLocalCurrencyAtDate, getFundFlowDetailList } from '@/api/system/statement'; // 假设你的请求方法在该文件中，需根据实际路径调整
import _ from 'lodash';

export default {
	data() {
		return {
			query: {
				startTime: '',
				endTime: '',
				otherName: '',
				otherAccountName: '',
				ourBankNO: ''
			},
			statementData: [], // 银行流水数据
			loading: false, // 加载状态
			endTimePickerOptions: {
				disabledDate: date => {
					// 结束日期不能早于开始日期
					return this.query.startTime && date < new Date(this.query.startTime);
				}
			}
		};
	},
	methods: {
		handleCheckDetail(row) {},
		// 获取银行流水数据
		fetchStatementData() {
			// 清空
			this.statementData = [];
			// 报表中是必须都要传递 但这里后端不传也可以 按照开始时间 如果不传就是至今
			if (!this.query.startTime || !this.query.endTime) {
				this.$message.warning('请选择开始日期和结束日期');
				return;
			}
			this.loading = true;
			// 先查询上年指定时间结转
			const query = {
				startTime: this.query.startTime,
				ourBankNO: this.query.ourBankNO
			};
			findFundFlowBalanceInLocalCurrencyAtDate(query).then(async response => {
				if (response.code === 200) {
					const lastYearData = response.data;
					console.log(lastYearData);
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
