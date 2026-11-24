<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" inline="true" label-width="150px">
			<el-form-item label="日期" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="请选择日期" value-format="yyyy-MM-dd"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">资金（银行）当日发生业务统计表</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList" table-name="views-system-statement-system-bank-account-change-summary-columns">
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="tableData"
			size="mini"
			show-summary
			:summary-method="getSummaries"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<el-table-column v-if="columns[0].visible" show-overflow-tooltip label="序号" align="center" prop="serialNumber" />
			<el-table-column v-if="columns[1].visible" show-overflow-tooltip label="日期" align="center" prop="reportDate" />
			<el-table-column v-if="columns[2].visible" show-overflow-tooltip label="己方公司" align="center" prop="selfCompany" />
			<el-table-column v-if="columns[3].visible" show-overflow-tooltip label="开户名称" align="center" prop="accountOpenName" />
			<el-table-column v-if="columns[4].visible" show-overflow-tooltip label="银行账号" align="center" prop="bankNo" />
			<el-table-column v-if="columns[5].visible" show-overflow-tooltip label="上日余额" align="center" prop="previousDayBalance" />
			<el-table-column v-if="columns[6].visible" show-overflow-tooltip label="本日收款" align="center" prop="dailyReceipts" />
			<el-table-column v-if="columns[7].visible" show-overflow-tooltip label="本日付款" align="center" prop="dailyPayments" />
			<el-table-column v-if="columns[8].visible" show-overflow-tooltip label="本日余额" align="center" prop="currentDayBalance" />
		</el-table>
		<el-row style="font-weight: bold; font-size: 16px; margin: 10px 30px">数据量总数: {{ total }}</el-row>
	</div>
</template>

<script>
import { add, subtract } from 'mathjs';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from '../../../api/tool/format';
import { getTodayBankAccountChangeSummary } from '../../../api/system/statement';
import { buildAmountSummaries } from '@/utils/tableSummary';

export default {
	name: 'SystemBankAccountChangeSummary',
	data() {
		return {
			loading: true,
			total: 0,
			tableData: [],
			queryParams: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '日期', visible: true },
				{ key: 2, label: '己方公司', visible: true },
				{ key: 3, label: '开户名称', visible: true },
				{ key: 4, label: '银行账号', visible: true },
				{ key: 5, label: '上日余额', visible: true },
				{ key: 6, label: '本日收款', visible: true },
				{ key: 7, label: '本日付款', visible: true },
				{ key: 8, label: '本日余额', visible: true }
			]
		};
	},
	created() {
		this.getList();
	},
	methods: {
		fix,
		/**
		 * 计算本日余额（接口未返回时兜底）
		 * @param {Object} row - 行数据
		 * @param {number|string} row.previousDayBalance - 上日余额
		 * @param {number|string} row.dailyReceipts - 本日收款
		 * @param {number|string} row.dailyPayments - 本日付款
		 * @returns {number}
		 */
		calcCurrentDayBalance(row) {
			const previousDayBalance = Number(row.previousDayBalance) || 0;
			const dailyReceipts = Number(row.dailyReceipts) || 0;
			const dailyPayments = Number(row.dailyPayments) || 0;
			return Number(subtract(add(previousDayBalance, dailyReceipts), dailyPayments));
		},
		/**
		 * 格式化接口行数据
		 * @param {Object} row - 接口原始行
		 * @returns {Object}
		 */
		formatRow(row) {
			const currentDayBalance = row.currentDayBalance != null && row.currentDayBalance !== '' ? row.currentDayBalance : this.calcCurrentDayBalance(row);
			return {
				...row,
				serialNumber: row.serialNumber ?? '-',
				reportDate: row.reportDate || this.queryParams.endTime || '-',
				selfCompany: row.selfCompany || '-',
				accountOpenName: row.accountOpenName || '-',
				bankNo: row.bankNo || '-',
				previousDayBalance: row.previousDayBalance,
				dailyReceipts: row.dailyReceipts,
				dailyPayments: row.dailyPayments,
				currentDayBalance
			};
		},
		/**
		 * 表格合计行
		 * @param {Object} param - element-ui summary 参数
		 * @returns {Array<string>}
		 */
		getSummaries(param) {
			return buildAmountSummaries({
				...param,
				amountProps: ['previousDayBalance', 'dailyReceipts', 'dailyPayments', 'currentDayBalance']
			});
		},
		/**
		 * 查询列表数据
		 */
		getList() {
			this.loading = true;
			getTodayBankAccountChangeSummary(this.queryParams).then(response => {
				const rows = response.rows || [];
				this.tableData = rows.map(row => this.formatRow(row));
				this.total = response.total || rows.length;
				this.loading = false;
			});
		},
		/**
		 * 按日期搜索
		 */
		handleQuery() {
			this.getList();
		},
		/**
		 * 刷新列表
		 */
		refresh() {
			this.getList();
		},
		/**
		 * 按顶部所选日期直接导出
		 */
		handleExport() {
			if (!this.queryParams.endTime) {
				this.$message.warning('请先选择日期');
				return;
			}
			this.download(
				'statistics/export/todaybankaccountchangesummary',
				{
					...this.queryParams
				},
				`资金（银行）当日发生业务统计表_${parseTime(new Date().getTime())}.xlsx`
			);
		}
	}
};
</script>

<style></style>
