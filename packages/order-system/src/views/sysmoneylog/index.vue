<template>
	<div class="sys-money-log">
		<!-- 顶部搜索：单一日期选择 -->
		<el-form id="top-search-form-item" :inline="true" :model="searchForm" class="search-form" label-width="80px">
			<el-form-item label="日期">
				<el-date-picker v-model="searchForm.endTime" value-format="yyyy-MM-dd" type="date" placeholder="选择日期" style="width: 160px" size="mini" />
			</el-form-item>
			<el-form-item>
				<el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
				<el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
			</el-form-item>
		</el-form>

		<!-- 左右表格布局 -->
		<div v-loading="loading" class="table-layout">
			<!-- 左侧表格：昨日数据 -->
			<div class="table-box left-table">
				<el-table :data="leftTableData" border class="money-table" size="mini" :row-style="tableRowClassName">
					<el-table-column :label="leftDateDisplay" align="center">
						<el-table-column prop="label" label="项目" show-overflow-tooltip min-width="280" />
						<el-table-column prop="value" label="金额" show-overflow-tooltip width="160" :formatter="formatValue" />
					</el-table-column>
				</el-table>
			</div>

			<!-- 中间：当日利润变动（表头形式） -->
			<div class="middle-panel">
				<div class="profit-header">当日利润变动</div>
				<div class="profit-value">{{ dailyProfitChange }}</div>
			</div>

			<!-- 右侧表格：日期仅覆盖项目+金额列 -->
			<div class="table-box right-table">
				<el-table :data="rightTableData" border class="money-table" size="mini" :row-style="tableRowClassName">
					<el-table-column :label="rightDateDisplay" align="center">
						<el-table-column prop="label" label="项目" show-overflow-tooltip min-width="280" />
						<el-table-column prop="value" label="金额" show-overflow-tooltip width="160" :formatter="formatValue" />
					</el-table-column>
					<el-table-column label="当日资金总额变动" show-overflow-tooltip width="140">
						<template slot-scope="scope">
							{{ getDailyChange(scope.$index) }}
						</template>
					</el-table-column>
				</el-table>
			</div>
		</div>
	</div>
</template>

<script>
import { getMoneySummary } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';
import { subtract, add, format } from 'mathjs';

export default {
	name: 'SysMoneyLog',
	data() {
		return {
			searchForm: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			leftTableData: [],
			rightTableData: [],
			leftDate: null,
			rightDate: null,
			loading: false
		};
	},
	computed: {
		leftDateDisplay() {
			return this.leftDate || '--';
		},
		rightDateDisplay() {
			return this.rightDate || '--';
		},
		/**
		 * 当日利润变动 = 右侧资金总额 - 左侧资金总额
		 * @returns {string}
		 */
		dailyProfitChange() {
			if (!this.leftTableData?.length || !this.rightTableData?.length) return '--';
			const leftTotal = Number(this.leftTableData[0]?.value ?? 0);
			const rightTotal = Number(this.rightTableData[0]?.value ?? 0);
			const diff = subtract(rightTotal, leftTotal);
			return format(diff, { notation: 'fixed', precision: 2 });
		}
	},
	created() {
		this.handleSearch();
	},
	methods: {
		/** 选择日期后点击搜索，自动请求昨日+当日两次接口 */
		async handleSearch() {
			const selectedDate = this.searchForm.endTime;
			if (!selectedDate) {
				this.$message.warning('请选择日期');
				return;
			}
			const yesterday = this.getYesterday(selectedDate);
			this.leftDate = yesterday;
			this.rightDate = selectedDate;
			this.loading = true;
			try {
				const [leftRes, rightRes] = await Promise.all([getMoneySummary({ endTime: yesterday }), getMoneySummary({ endTime: selectedDate })]);
				this.leftTableData = this.formatTableData(leftRes?.data);
				this.rightTableData = this.formatTableData(rightRes?.data);
			} catch (e) {
				this.$message.error('获取数据失败，请重试');
				this.leftTableData = [];
				this.rightTableData = [];
			} finally {
				this.loading = false;
			}
		},
		/**
		 * 获取前一天日期
		 * @param {string} dateStr yyyy-MM-dd
		 * @returns {string}
		 */
		getYesterday(dateStr) {
			const d = new Date(dateStr);
			d.setDate(d.getDate() - 1);
			return parseTime(d, '{y}-{m}-{d}');
		},
		/**
		 * 格式化表格数据，与 totalMoneyChange 一致
		 * @param {Object} data 接口返回 data
		 * @returns {Array}
		 */
		formatTableData(data) {
			if (!data) return [];
			const formatNum = v => format(Number(v ?? 0), { notation: 'fixed', precision: 2 });
			const row = (label, val) => ({ label, value: formatNum(val) });
			const v = key => data[key] ?? 0;
			return [
				row('资金总额=⓪+①+②-③-④+⑤+⑥+⑦-⑧-⑨', this.calculateTotalBalance(data)),
				row('⓪库存金额', v('remainingInventoryAmount')),
				row('①客户欠款合计数', v('companyTotalBalance')),
				row('②所有银行卡资金合计', v('selfCompanyTotalFunds')),
				row('③欠厂家货款', v('supplierTotalBalance')),
				row('④未支付运费合计', v('driverUnpaidAmount')),
				row('⑤其他应收-个人/公司从公司借款', v('loanFromCompany')),
				row('⑥期货保证金', v('futuresMarginBalance')),
				row('⑦厂家保证金', v('paymentMarginBalance')),
				row('⑧收取保证金', v('receiveMarginBalance')),
				row('⑨公司从外面借款合计', v('loanBalance')),
				row('客户票点合计', v('companyTotalInvoiceAmount')),
				row('供应商票点合计', v('supplierTotalInvoiceAmount'))
			];
		},
		/**
		 * 计算资金总额：0+①+②-③-④+⑤+⑥+⑦-⑧-⑨
		 */
		calculateTotalBalance(data) {
			const s = {
				remainingInventoryAmount: Number(data?.remainingInventoryAmount || 0),
				companyTotalBalance: Number(data?.companyTotalBalance || 0),
				selfCompanyTotalFunds: Number(data?.selfCompanyTotalFunds || 0),
				supplierTotalBalance: Number(data?.supplierTotalBalance || 0),
				driverUnpaidAmount: Number(data?.driverUnpaidAmount || 0),
				loanFromCompany: Number(data?.loanFromCompany || 0),
				futuresMarginBalance: Number(data?.futuresMarginBalance || 0),
				paymentMarginBalance: Number(data?.paymentMarginBalance || 0),
				receiveMarginBalance: Number(data?.receiveMarginBalance || 0),
				loanBalance: Number(data?.loanBalance || 0)
			};
			let r = add(s.remainingInventoryAmount, s.companyTotalBalance, s.selfCompanyTotalFunds, s.loanFromCompany, s.futuresMarginBalance, s.paymentMarginBalance);
			r = subtract(r, s.supplierTotalBalance);
			r = subtract(r, s.driverUnpaidAmount);
			r = subtract(r, s.receiveMarginBalance);
			r = subtract(r, s.loanBalance);
			return format(r, { notation: 'fixed', precision: 2 });
		},
		/**
		 * 当日资金总额变动：右侧值 - 左侧值
		 * @param {number} rowIndex
		 * @returns {string}
		 */
		getDailyChange(rowIndex) {
			const leftRow = this.leftTableData?.[rowIndex];
			const rightRow = this.rightTableData?.[rowIndex];
			if (!leftRow || !rightRow) return '--';
			const leftVal = Number(leftRow.value ?? 0);
			const rightVal = Number(rightRow.value ?? 0);
			const diff = subtract(rightVal, leftVal);
			return format(diff, { notation: 'fixed', precision: 2 });
		},
		formatValue(row, column, cellValue) {
			const num = Number(cellValue ?? 0);
			return Number.isFinite(num) ? num.toFixed(2) : '0.00';
		},
		tableRowClassName({ rowIndex }) {
			if (rowIndex === 0) {
				return {
					color: 'red !important',
					fontWeight: 'bold !important',
					fontSize: '16px !important'
				};
			}
			return {};
		},
		/**
		 * 导出所选日期对应的资金变动明细（区间为昨日到当日）
		 * @returns {void}
		 */
		handleExport() {
			if (!this.searchForm.endTime) {
				this.$message.warning('请先选择日期');
				return;
			}
			const startTime = this.getYesterday(this.searchForm.endTime);
			const endTime = this.searchForm.endTime;
			this.download(
				`statistics/export/getAllMoneyChange?startTime=${startTime}&endTime=${endTime}`,
				null,
				`资金变动详情_${endTime}.xlsx`
			);
		}
	}
};
</script>

<style scoped lang="scss">
.sys-money-log {
	padding: 20px;
}

.search-form {
	margin-bottom: 20px;
}

.table-layout {
	display: flex;
	align-items: stretch;
	gap: 0;
	min-height: 400px;
}

.table-box {
	flex: 1;
	min-width: 200px;
	display: flex;
	flex-direction: column;
}

.middle-panel {
	width: 140px;
	flex-shrink: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	border: 1px solid #e4e7ed;
	border-left: none;
	background: #fafafa;
}

.profit-header {
	font-size: 14px;
	font-weight: bold;
	color: #303133;
	padding: 10px 0;
	background: #f5f7fa;
	border-bottom: 1px solid #e4e7ed;
	text-align: center;
}

.profit-value {
	font-size: 18px;
	font-weight: bold;
	color: #409eff;
}

.money-table {
	width: 100%;
}
</style>
