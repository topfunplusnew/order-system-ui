<script>
import { getMoneySummary } from '@/api/system/statement';
import { fix } from '@/api/tool/format';
import * as echarts from 'echarts';
import { subtract, add, format, abs, compare } from 'mathjs';

export default {
	name: 'SysMoneyLog',
	data() {
		return {
			fixedMoneyTableData: [],
			changeMoneyTableData: [],
			spanArr: [],
			DataTypes: Object.freeze({
				FIXED: 0,
				CHANGE: 1
			}),
			diffRows: [],
			diffModules: [],
			diffList: [],

			// 两个表格上方的日期选择（可独立选择）
			targetLeftDate: null,
			targetRightDate: null,

			activeTab: 'card',
			diffChart: null,
			loadingCount: 0
		};
	},
	computed: {
		columnHeaderFix() {
			return this.targetRightDate || '未选择日期';
		},
		columnHeaderChange() {
			return this.targetLeftDate || '未选择日期';
		},
		diffSummary() {
			if (this.diffList.length === 0) return null;
			const totalDiff = this.diffList.reduce((sum, item) => {
				const diffValue = Number(item.diffValue || 0);
				return add(sum, abs(diffValue));
			}, 0);
			return {
				totalCount: this.diffList.length,
				totalDiffValue: format(totalDiff, { notation: 'fixed', precision: 2 })
			};
		},
		loading() {
			return this.loadingCount > 0;
		},
		chartData() {
			if (this.diffList.length === 0) return null;
			return {
				categories: this.diffList.map(item => item.label.replace(/^[①②③④⑤⑥⑦⑧⑨⓪]/g, '').replace(/---.*$/, '')),
				leftValues: this.diffList.map(item => Number(item.leftValue)),
				rightValues: this.diffList.map(item => Number(item.rightValue)),
				diffValues: this.diffList.map(item => Number(item.diffValue))
			};
		}
	},
	watch: {
		targetLeftDate: {
			handler(val) {
				if (val) this.fetchLeftData();
				else {
					this.changeMoneyTableData = [];
					this.calculateDiff();
				}
			}
		},
		targetRightDate: {
			handler(val) {
				if (val) this.fetchRightData();
				else {
					this.fixedMoneyTableData = [];
					this.calculateDiff();
				}
			}
		},
		diffList: {
			handler() {
				if (this.activeTab === 'chart' && this.diffList.length > 0) {
					this.$nextTick(() => this.initChart());
				}
			},
			deep: true
		}
	},
	methods: {
		fix,
		/** 获取左侧表格数据 */
		async fetchLeftData() {
			if (!this.targetLeftDate) return;
			this.loadingCount++;
			try {
				const res = await getMoneySummary({ endTime: this.targetLeftDate });
				const data = res?.data;
				this.changeMoneyTableData = data ? this.formatTableDataFromSnapshot(data) : [];
				this.calculateDiff();
				if (this.activeTab === 'chart' && this.diffList.length > 0) {
					this.$nextTick(() => this.initChart());
				}
			} catch (e) {
				this.$message.error('获取左侧数据失败，请重试');
				this.changeMoneyTableData = [];
			} finally {
				this.loadingCount--;
			}
		},
		/** 获取右侧表格数据 */
		async fetchRightData() {
			if (!this.targetRightDate) return;
			this.loadingCount++;
			try {
				const res = await getMoneySummary({ endTime: this.targetRightDate });
				const data = res?.data;
				this.fixedMoneyTableData = data ? this.formatTableDataFromSnapshot(data) : [];
				this.calculateDiff();
				if (this.activeTab === 'chart' && this.diffList.length > 0) {
					this.$nextTick(() => this.initChart());
				}
			} catch (e) {
				this.$message.error('获取右侧数据失败，请重试');
				this.fixedMoneyTableData = [];
			} finally {
				this.loadingCount--;
			}
		},
		calculateDiff(leftTableData, rightTableData) {
			this.diffRows = [];
			this.diffModules = [];
			this.diffList = [];
			const leftData = leftTableData || this.fixedMoneyTableData;
			const rightData = rightTableData || this.changeMoneyTableData;
			if (!leftData?.length || !rightData?.length) return;

			const minLength = Math.min(leftData.length, rightData.length);
			for (let i = 0; i < minLength; i++) {
				if (!leftData[i] || !rightData[i]) continue;
				const leftValue = Number(leftData[i].anotherLabel || 0);
				const rightValue = Number(rightData[i].anotherLabel || 0);
				const diffValue = subtract(rightValue, leftValue);
				const absDiffValue = abs(diffValue);
				if (compare(absDiffValue, 0) === 1) {
					this.diffRows.push(i);
					if (rightData[i].moduleName) this.diffModules.push(rightData[i].moduleName);
					if (i > 0) {
						this.diffList.push({
							label: leftData[i].label,
							leftValue: format(leftValue, { notation: 'fixed', precision: 2 }),
							rightValue: format(rightValue, { notation: 'fixed', precision: 2 }),
							diffValue: format(diffValue, { notation: 'fixed', precision: 2 }),
							moduleName: rightData[i].moduleName,
							rowIndex: i
						});
					}
				}
			}
		},
		/**
		 * 将 getMoneySummary 返回的扁平 data 转为表格行结构
		 * @param {Object} data - 接口返回的 data 对象
		 * @returns {Array<Object>} 表格行数据 { label, value, anotherLabel, anotherValue, moduleName }
		 */
		formatTableDataFromSnapshot(data) {
			const formatNumber = value => format(typeof value === 'number' ? value : Number(value || 0), { notation: 'fixed', precision: 2 });
			const createRow = (label, val, anotherLabel, anotherValue, moduleName) => ({
				label,
				value: formatNumber(val),
				anotherLabel: formatNumber(anotherLabel),
				anotherValue: formatNumber(anotherValue),
				moduleName
			});

			const total = this.calculateTotalBalance(data);
			const v = key => Number(data[key] ?? 0);

			return [
				createRow('资金总额=①+②-③-④+⑤+⑥+⑦-⑧-⑨+⓪', total, total, 0, null),
				createRow('①客户欠款合计数', v('companyTotalBalance'), v('companyTotalBalance'), 0, 'companyTotalBalance'),
				createRow('②所有银行卡资金合计', v('selfCompanyTotalFunds'), v('selfCompanyTotalFunds'), 0, 'selfCompanyTotalFunds'),
				createRow('⑤其他应收-个人/公司从公司借款', v('loanFromCompany'), v('loanFromCompany'), 0, 'loanFromCompany'),
				createRow('⑥期货保证金', v('futuresMarginBalance'), v('futuresMarginBalance'), 0, 'futuresMarginBalance'),
				createRow('⑦厂家保证金', v('paymentMarginBalance'), v('paymentMarginBalance'), 0, 'paymentMarginBalance'),
				createRow('⓪库存金额', v('remainingInventoryAmount'), v('remainingInventoryAmount'), 0, 'remainingInventoryAmount'),
				createRow('③欠厂家货款', v('supplierTotalBalance'), v('supplierTotalBalance'), 0, 'supplierTotalBalance'),
				createRow('④未支付运费合计', v('driverUnpaidAmount'), v('driverUnpaidAmount'), 0, 'driverUnpaidAmount'),
				createRow('⑧收取保证金', v('receiveMarginBalance'), v('receiveMarginBalance'), 0, 'receiveMarginBalance'),
				createRow('⑨公司从外面借款合计', v('loanBalance'), v('loanBalance'), 0, 'loanBalance')
			];
		},
		calculateTotalBalance(data) {
			const safe = {
				companyTotalBalance: Number(data?.companyTotalBalance || 0),
				selfCompanyTotalFunds: Number(data?.selfCompanyTotalFunds || 0),
				supplierTotalBalance: Number(data?.supplierTotalBalance || 0),
				driverUnpaidAmount: Number(data?.driverUnpaidAmount || 0),
				loanFromCompany: Number(data?.loanFromCompany || 0),
				futuresMarginBalance: Number(data?.futuresMarginBalance || 0),
				paymentMarginBalance: Number(data?.paymentMarginBalance || 0),
				receiveMarginBalance: Number(data?.receiveMarginBalance || 0),
				loanBalance: Number(data?.loanBalance || 0),
				remainingInventoryAmount: Number(data?.remainingInventoryAmount || 0)
			};
			let result = add(safe.companyTotalBalance, safe.selfCompanyTotalFunds, safe.loanFromCompany, safe.futuresMarginBalance, safe.paymentMarginBalance, safe.remainingInventoryAmount);
			result = subtract(result, safe.supplierTotalBalance);
			result = subtract(result, safe.driverUnpaidAmount);
			result = subtract(result, safe.receiveMarginBalance);
			result = subtract(result, safe.loanBalance);
			return format(result, { notation: 'fixed', precision: 2 });
		},
		handleTabChange(tab) {
			this.activeTab = tab.name;
			if (tab.name === 'chart' && this.diffList.length > 0) {
				this.$nextTick(() => this.initChart());
			}
		},
		initChart() {
			if (!this.chartData) return;
			const chartDom = document.getElementById('sysMoneyDiffChart');
			if (!chartDom) return;
			if (this.diffChart) {
				this.diffChart.dispose();
			}
			this.diffChart = echarts.init(chartDom);
			const option = {
				tooltip: {
					trigger: 'axis',
					axisPointer: { type: 'shadow' },
					formatter: params => {
						let result = params[0].name + '<br/>';
						params.forEach(item => {
							const absValue = abs(Number(item.value || 0));
							const formattedValue = absValue.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
							result += `${item.marker}${item.seriesName}: ${item.value >= 0 ? '+' : ''}${formattedValue}<br/>`;
						});
						return result;
					}
				},
				legend: { data: ['左侧日期', '右侧日期', '差异值'], top: 10 },
				grid: { left: '3%', right: '4%', bottom: '15%', top: '15%', containLabel: true },
				xAxis: {
					type: 'category',
					data: this.chartData.categories,
					axisLabel: { rotate: 45, interval: 0, fontSize: 12 }
				},
				yAxis: {
					type: 'value',
					axisLabel: {
						formatter: value => abs(Number(value || 0)).toLocaleString('zh-CN', { maximumFractionDigits: 0 })
					}
				},
				series: [
					{
						name: this.targetLeftDate || '左侧日期',
						type: 'bar',
						data: this.chartData.leftValues,
						itemStyle: { color: '#409eff' },
						label: { show: true, position: 'top', formatter: v => (v.value >= 0 ? '+' : '') + Number(v.value).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
					},
					{
						name: this.targetRightDate || '右侧日期',
						type: 'bar',
						data: this.chartData.rightValues,
						itemStyle: { color: '#67c23a' },
						label: { show: true, position: 'top', formatter: v => (v.value >= 0 ? '+' : '') + Number(v.value).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
					},
					{
						name: '差异值',
						type: 'line',
						data: this.chartData.diffValues,
						itemStyle: { color: '#e6a23c' },
						lineStyle: { width: 3 },
						symbol: 'circle',
						symbolSize: 8,
						label: { show: true, position: 'top', formatter: v => (v.value >= 0 ? '+' : '') + Number(v.value).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
					}
				]
			};
			this.diffChart.setOption(option);
			window.addEventListener('resize', this.handleChartResize);
		},
		handleChartResize() {
			this.diffChart?.resize();
		},
		calculateProfitChange(anotherLabel, value) {
			return format(subtract(Number(value || 0), Number(anotherLabel || 0)), { notation: 'fixed', precision: 2 });
		},
		isDiffLarge(diffValue, threshold = 1000) {
			return compare(abs(Number(diffValue || 0)), threshold) === 1;
		},
		tableRowClassName({ rowIndex }) {
			return this.diffRows.includes(rowIndex) ? 'diff-row' : '';
		},
		objectSpanMethod({ row, column, rowIndex, columnIndex }) {
			if (columnIndex === 0) {
				if (rowIndex === 0) return { rowspan: 1, colspan: 1 };
				if (rowIndex === 1) return { rowspan: 6, colspan: 1 };
				if (rowIndex === 7) return { rowspan: 4, colspan: 1 };
				return { rowspan: 0, colspan: 0 };
			}
			if (columnIndex === 3) {
				if (rowIndex === 0) return { rowspan: this.fixedMoneyTableData.length, colspan: 1 };
				return { rowspan: 0, colspan: 0 };
			}
			return { rowspan: 1, colspan: 1 };
		}
	},
	beforeDestroy() {
		if (this.diffChart) {
			this.diffChart.dispose();
			this.diffChart = null;
		}
		window.removeEventListener('resize', this.handleChartResize);
	}
};
</script>

<template>
	<div>
		<div class="container">
			<el-row>
				<el-alert title="请为左右两个表格分别选择日期，选择后自动加载数据并展示差异对比" type="info" :closable="false" />
			</el-row>
			<br />

			<el-row :gutter="30" v-loading="loading">
				<!-- 左侧表格 -->
				<el-col :span="12">
					<el-row class="date-row">
						<el-col :span="14">
							<el-date-picker v-model="targetLeftDate" type="date" value-format="yyyy-MM-dd" placeholder="选择左侧表格日期" style="width: 100%" size="mini" clearable />
						</el-col>
					</el-row>
					<br />
					<el-table size="mini" :data="changeMoneyTableData" border class="money-table" :span-method="objectSpanMethod" :row-class-name="tableRowClassName">
						<el-table-column :label="columnHeaderChange" align="center" show-overflow-tooltip>
							<el-table-column label="科目名称" show-overflow-tooltip>
								<template slot-scope="scope">
									<div v-if="scope.$index === 0">股东权益</div>
									<div v-if="scope.$index === 1">资产类</div>
									<div v-if="scope.$index === 7">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目" show-overflow-tooltip width="300px" />
							<el-table-column prop="value" label="上日资金总额" show-overflow-tooltip />
							<el-table-column label="当日利润变动" show-overflow-tooltip>
								<template slot-scope="scope">
									<div v-if="scope.$index === 0">{{ calculateProfitChange(scope.row.anotherLabel, scope.row.value) }}</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" show-overflow-tooltip />
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" show-overflow-tooltip />
						</el-table-column>
					</el-table>
				</el-col>

				<!-- 右侧表格 -->
				<el-col :span="12">
					<el-row class="date-row">
						<el-col :span="14">
							<el-date-picker v-model="targetRightDate" type="date" value-format="yyyy-MM-dd" placeholder="选择右侧表格日期" style="width: 100%" size="mini" clearable />
						</el-col>
					</el-row>
					<br />
					<el-table size="mini" :data="fixedMoneyTableData" border class="money-table" :span-method="objectSpanMethod" :row-class-name="tableRowClassName">
						<el-table-column :label="columnHeaderFix" align="center" show-overflow-tooltip>
							<el-table-column label="科目名称" show-overflow-tooltip>
								<template slot-scope="scope">
									<div v-if="scope.$index === 0">股东权益</div>
									<div v-if="scope.$index === 1">资产类</div>
									<div v-if="scope.$index === 7">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目" show-overflow-tooltip width="300px" />
							<el-table-column prop="value" label="上日资金总额" show-overflow-tooltip />
							<el-table-column label="当日利润变动" show-overflow-tooltip>
								<template slot-scope="scope">
									<div v-if="scope.$index === 0">{{ calculateProfitChange(scope.row.anotherLabel, scope.row.value) }}</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" show-overflow-tooltip />
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" show-overflow-tooltip />
						</el-table-column>
					</el-table>
				</el-col>
			</el-row>

			<!-- 差异对比结果 - 暂时注释
			<div v-if="diffList.length > 0" class="diff-comparison-section">
				<el-card class="diff-card">
					<div slot="header" class="diff-header">
						<span class="diff-title"><i class="el-icon-warning-outline" /> 差异对比结果</span>
						<el-tag v-if="diffSummary" type="warning" size="medium" class="diff-summary-tag">共发现 {{ diffSummary.totalCount }} 项差异</el-tag>
					</div>
					<el-tabs v-model="activeTab" @tab-click="handleTabChange">
						<el-tab-pane label="卡片对比" name="card">
							<div class="diff-content">
								<div v-for="(item, index) in diffList" :key="index" class="diff-item">
									<div class="diff-item-header">
										<span class="diff-label">{{ item.label }}</span>
										<el-tag :type="isDiffLarge(item.diffValue, 1000) ? 'danger' : 'warning'" size="medium" class="diff-value-tag">差异: {{ Number(item.diffValue) > 0 ? '+' : '' }}{{ item.diffValue }}</el-tag>
									</div>
									<div class="diff-item-body">
										<div class="diff-value-item">
											<span class="diff-value-label">{{ targetLeftDate || '左侧日期' }}:</span>
											<span class="diff-value left-value">{{ item.leftValue }}</span>
										</div>
										<div class="diff-arrow"><i class="el-icon-right" /></div>
										<div class="diff-value-item">
											<span class="diff-value-label">{{ targetRightDate || '右侧日期' }}:</span>
											<span class="diff-value right-value">{{ item.rightValue }}</span>
										</div>
									</div>
								</div>
							</div>
						</el-tab-pane>
						<el-tab-pane label="图表对比" name="chart">
							<div class="chart-container">
								<div id="sysMoneyDiffChart" class="diff-chart" />
							</div>
						</el-tab-pane>
					</el-tabs>
				</el-card>
			</div>

			<div v-else-if="fixedMoneyTableData.length > 0 && changeMoneyTableData.length > 0" class="no-diff-tip">
				<el-alert title="两个时间点的数据完全一致，无差异" type="success" :closable="false" />
			</div>
			-->
		</div>
	</div>
</template>

<style scoped lang="scss">
.container {
	margin: 30px;
}

.date-row {
	align-items: center;
}

.diff-comparison-section {
	margin-top: 30px;
}

.diff-card {
	border: 1px solid #e4e7ed;
	border-radius: 4px;
	box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.diff-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.diff-title {
	font-size: 18px;
	font-weight: bold;
	color: #303133;
	i {
		margin-right: 8px;
		color: #e6a23c;
		font-size: 20px;
	}
}

.diff-content {
	margin-top: 20px;
}

.diff-item {
	padding: 20px;
	margin-bottom: 16px;
	background: #f5f7fa;
	border: 1px solid #e4e7ed;
	border-radius: 4px;
	cursor: pointer;
	transition: all 0.3s;
	&:hover {
		background: #ecf5ff;
		border-color: #409eff;
		box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
	}
	&:last-child {
		margin-bottom: 0;
	}
}

.diff-item-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.diff-label {
	font-size: 16px;
	font-weight: 500;
	color: #606266;
	flex: 1;
}

.diff-item-body {
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.diff-value-item {
	display: flex;
	flex-direction: column;
	flex: 1;
}

.diff-value-label {
	font-size: 14px;
	color: #909399;
	margin-bottom: 6px;
}

.diff-value {
	font-size: 20px;
	font-weight: bold;
	&.left-value {
		color: #409eff;
	}
	&.right-value {
		color: #67c23a;
	}
}

.diff-arrow {
	margin: 0 20px;
	color: #909399;
	font-size: 22px;
}

.no-diff-tip {
	margin-top: 30px;
}

.chart-container {
	padding: 20px 0;
}

.diff-chart {
	width: 100%;
	height: 500px;
	min-height: 500px;
}

::v-deep .diff-summary-tag {
	font-size: 14px;
	padding: 4px 12px;
	height: auto;
}

::v-deep .diff-value-tag {
	font-size: 16px;
	font-weight: bold;
	padding: 4px 16px;
}

.money-table {
	::v-deep .el-table__body-wrapper .el-table__body tr.diff-row {
		background-color: #ffeb3b !important;
		td {
			background-color: #ffeb3b !important;
		}
	}
	::v-deep .el-table__fixed-body-wrapper .el-table__body tr.diff-row {
		background-color: #ffeb3b !important;
		td {
			background-color: #ffeb3b !important;
		}
	}
}
</style>
