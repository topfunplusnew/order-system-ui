<template>
	<div class="total-money-change">
		<!-- 搜索框 -->
		<el-form :inline="true" :model="searchForm" class="search-form">
			<el-form-item label="日期">
				<el-date-picker v-model="searchForm.endTime" value-format="yyyy-MM-dd" type="date" placeholder="选择日期"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" @click="handleSearch">搜索</el-button>
			</el-form-item>
			<!--			<el-form-item>-->
			<!--				<el-button type="success" @click="openChangeDialog">查看资金变动</el-button>-->
			<!--			</el-form-item>-->
		</el-form>

		<!-- 表格 -->
		<el-table :data="tableData" border class="money-table" :row-style="tableRowClassName">
			<el-table-column prop="label" label="项目"></el-table-column>
			<el-table-column prop="value" label="金额" :formatter="formatValue"></el-table-column>
		</el-table>

		<!-- 资金变动弹窗 -->
		<el-dialog :visible.sync="changeDialogVisible" title="查看资金变动" width="1100px">
			<el-form :inline="true" :model="changeForm" class="search-form">
				<el-form-item label="日期查询">
					<el-date-picker v-model="changeForm.endTime" type="date" value-format="yyyy-MM-dd" placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="handleChangeSearch">搜索</el-button>
				</el-form-item>
			</el-form>

			<!-- 表格 -->
			<el-row :gutter="10">
				<el-table :data="changeTableData" border class="money-table" :row-style="tableRowClassName" :span-method="objectSpanMethod">
					<el-table-column label="科目名称">
						<template slot-scope="scope">
							<!-- 只在第一行显示“股东权益” -->
							<div v-if="scope.$index === 0">股东权益</div>
							<!-- 合并“资产类” -->
							<div v-if="scope.$index === 1">资产类</div>
							<!-- 合并“负债类” -->
							<div v-if="scope.$index === 6">负债类</div>
						</template>
					</el-table-column>
					<el-table-column prop="label" label="项目"></el-table-column>
					<el-table-column prop="value" label="上日资金总额" :formatter="formatValue"></el-table-column>
					<el-table-column label="对比日资金流变动">
						<template slot-scope="scope">
							<!-- 只在第一行显示差值 -->
							<div v-if="scope.$index === 0">
								{{ fix(scope.row.anotherLabel - scope.row.value) }}
							</div>
						</template>
					</el-table-column>
					<el-table-column prop="anotherLabel" label="本日资金总额" :formatter="formatValue"></el-table-column>
					<el-table-column prop="anotherValue" label="当日资金总额变动情况" :formatter="formatValue"></el-table-column>
				</el-table>
			</el-row>
		</el-dialog>
	</div>
</template>

<script>
import { getMoneySummary, getMoneyChangeSummary } from '@/api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from 'order-system/src/api/tool/format';
import { getPreviousDay } from '@/utils/Date';

export default {
	name: 'TotalMoneyChange',
	data() {
		return {
			searchForm: {
				endTime: parseTime(new Date(), '{y}-{m}-{d}')
			},
			changeForm: {
				startTime: '',
				endTime: ''
			},
			tableData: [],
			changeTableData: [],
			anotherTableData: [],
			changeDialogVisible: false
		};
	},
	created() {
		this.handleSearch();
	},
	methods: {
		fix,
		async handleSearch() {
			const response = await getMoneySummary(this.searchForm);
			const data = response.data;
			this.tableData = this.formatShowTableData(data);
		},
		async handleChangeSearch() {
			// 开始时间为endTime往前推一天
			this.changeForm.startTime = parseTime(getPreviousDay(new Date(this.changeForm.endTime)), '{y}-{m}-{d}');
			const response = await getMoneyChangeSummary(this.changeForm);
			const data = response.data;
			this.changeTableData = this.formatTableData(data);
		},
		formatShowTableData(data) {
			const createRow = (label, value, anotherLabel, anotherValue) => ({
				label,
				value,
				anotherLabel,
				anotherValue
			});
			return [
				createRow('资金总额=①+②+③+④+⑤+⑥+⑦', this.calculateTotalBalance(data)),
				createRow('①客户欠款合计数', data.companyTotalBalance),
				createRow('②所有银行卡资金合计', data.selfCompanyTotalFunds),
				createRow('③欠厂家货款', data.supplierTotalBalance),
				createRow('④未支付运费合计', data.driverUnpaidAmount),
				createRow('⑤期货保证金', data.futuresMarginBalance),
				createRow('⑥其他应收-个人从公司借款', data.loanFromCompany),
				createRow('⑦公司从外面借款合计', data.loanBalance),
				createRow('客户票点合计', data.companyTotalInvoiceAmount),
				createRow('供应商票点合计', data.supplierTotalInvoiceAmount)
			];
		},
		formatTableData(list, type) {
			const { startTimeMoney, endTimeMoney } = list;

			// 计算数据差异的函数
			const calculateDifference = field => startTimeMoney[field] - endTimeMoney[field];

			// 计算各个字段的差异
			const data = {
				companyTotalBalance: calculateDifference('companyTotalBalance'),
				supplierTotalBalance: calculateDifference('supplierTotalBalance'),
				driverUnpaidAmount: calculateDifference('driverUnpaidAmount'),
				selfCompanyTotalFunds: calculateDifference('selfCompanyTotalFunds'),
				loanBalance: calculateDifference('loanBalance'),
				futuresMarginBalance: calculateDifference('futuresMarginBalance'),
				loanFromCompany: calculateDifference('loanFromCompany'),
				remainingInventoryAmount: calculateDifference('remainingInventoryAmount')
			};

			// 创建表格数据的函数
			const createRow = (label, value, anotherLabel, anotherValue) => ({
				label,
				value,
				anotherLabel,
				anotherValue
			});

			// 返回格式化后的数据
			return [
				createRow('资金总额（即股东权益）=①+②+③+④+⑤-⑥-⑦-⑧', this.calculateTotalBalance(data), this.calculateTotalBalance(startTimeMoney), this.calculateTotalBalance(endTimeMoney)),
				createRow('①应收账款---客户欠款合计数', data.companyTotalBalance, startTimeMoney.companyTotalBalance, endTimeMoney.companyTotalBalance),
				createRow('②银行存款---公司所有银行资金合计', data.selfCompanyTotalFunds, startTimeMoney.selfCompanyTotalFunds, endTimeMoney.selfCompanyTotalFunds),
				createRow('③保证金----期货保证金', data.futuresMarginBalance, startTimeMoney.futuresMarginBalance, endTimeMoney.futuresMarginBalance),
				createRow('④其他应收---个人或公司从我公司借款', data.loanFromCompany, startTimeMoney.loanFromCompany, endTimeMoney.loanFromCompany),
				createRow('⑤库存', data.remainingInventoryAmount, startTimeMoney.remainingInventoryAmount, endTimeMoney.remainingInventoryAmount),
				createRow('⑥应付账款---运费合计', data.driverUnpaidAmount, startTimeMoney.driverUnpaidAmount, endTimeMoney.driverUnpaidAmount),
				createRow('⑦应付账款---欠厂家货款', data.supplierTotalBalance, startTimeMoney.supplierTotalBalance, endTimeMoney.supplierTotalBalance),
				createRow('⑧其他应付款---公司从外面借款合计', data.loanBalance, startTimeMoney.loanBalance, endTimeMoney.loanBalance)
			];
		},
		calculateTotalBalance(data) {
			return (
				data.companyTotalBalance + // ①应收账款---客户欠款合计数
				data.selfCompanyTotalFunds + // ②银行存款---公司所有银行资金合计
				data.futuresMarginBalance + // ③保证金----期货保证金
				data.loanFromCompany + // ④其他应收---个人或公司从我公司借款
				data.remainingInventoryAmount - // ⑤库存
				data.driverUnpaidAmount - // ⑥应付账款---运费合计
				data.supplierTotalBalance - // ⑦应付账款---欠厂家货款
				data.loanBalance
			) // ⑧其他应付款---公司从外面借款合计
				.toFixed(2);
		},
		formatValue(row, column, cellValue) {
			return Number(cellValue).toFixed(2);
		},
		tableRowClassName({ rowIndex }) {
			if (rowIndex === 0) {
				return {
					color: 'red !important',
					fontWeight: 'bold !important',
					fontSize: '22px !important'
				};
			}
			return {};
		},
		openChangeDialog() {
			this.changeDialogVisible = true;
		},
		// 合并行的方法
		objectSpanMethod({ row, column, rowIndex, columnIndex }) {
			// 合并“科目名称”列
			if (columnIndex === 0) {
				if (rowIndex === 0) {
					// 第一行显示“股东权益”，不合并
					return {
						rowspan: 1,
						colspan: 1
					};
				} else if (rowIndex === 1) {
					// 合并“资产类”行
					return {
						rowspan: 5, // 合并 5 行
						colspan: 1
					};
				} else if (rowIndex === 6) {
					// 合并“负债类”行
					return {
						rowspan: 3, // 合并 3 行
						colspan: 1
					};
				} else {
					// 其他行不显示
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
			// 合并“对比日资金流变动”列
			else if (columnIndex === 3) {
				if (rowIndex === 0) {
					// 第一行显示差值，合并所有行
					return {
						rowspan: this.changeTableData.length,
						colspan: 1
					};
				} else {
					// 其他行不显示
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
			// 其他列不合并
			else {
				return {
					rowspan: 1,
					colspan: 1
				};
			}
		}
	}
};
</script>

<style scoped>
.total-money-change {
	padding: 20px;
}

.search-form {
	margin-bottom: 20px;
}

.money-table {
	width: 100%;
}
</style>
