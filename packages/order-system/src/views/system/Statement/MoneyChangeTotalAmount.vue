<script>
import { getMoneyChangeSummaryByDate, getTargetDates } from '@/api/system/statement';
import { fix } from 'order-system/src/api/tool/format';
import { common_dialog } from '@/views/dashboard/mixins/common/common_dialog';
import ChooseModule from '@/views/dashboard/backuplog/ChooseModule.vue';
import { TableName } from '@/api/tool/enums';
import { getBackupInfoV2 } from '@/api/system/statement';
import * as echarts from 'echarts';
import _ from 'lodash';
import { subtract, add, format, abs, compare } from 'mathjs';

export default {
	name: 'MoneyChangeTotalAmount',
	mixins: [common_dialog],
	data() {
		return {
			changeForm: {
				startTime: '',
				endTime: ''
			},
			// 数据固定后的数组
			fixedMoneyTableData: [],
			// 变动
			changeMoneyTableData: [],
			spanArr: [], // 存储合并信息的数组
			DataTypes: Object.freeze({
				FIXED: 0,
				CHANGE: 1
			}),

			diffRows: [],
			diffModules: [],
			diffList: [], // 差异对比列表

			// 表格上方查询日期
			targetLeftDate: null,
			targetRightDate: null,

			// 可选择的时间下拉列表
			availableDates: [],
			isLoadingDates: false,

			// Tab 切换
			activeTab: 'card',

			// ECharts 图表实例
			diffChart: null
		};
	},
	computed: {
		columnHeaderFix() {
			return this.targetRightDate || '未选择日期';
		},
		columnHeaderChange() {
			return this.targetLeftDate || '未选择日期';
		},
		// 差异汇总统计（使用 math.js 进行高精度计算）
		diffSummary() {
			if (this.diffList.length === 0) return null;
			// 使用 math.js 的 add 和 abs 进行高精度计算
			const totalDiff = this.diffList.reduce((sum, item) => {
				const diffValue = Number(item.diffValue || 0);
				return add(sum, abs(diffValue));
			}, 0);
			return {
				totalCount: this.diffList.length,
				totalDiffValue: format(totalDiff, { notation: 'fixed', precision: 2 })
			};
		},
		// 图表数据
		chartData() {
			if (this.diffList.length === 0) return null;
			return {
				categories: this.diffList.map(item => {
					// 简化标签名称，只保留关键信息
					return item.label.replace(/^[①②③④⑤⑥⑦⑧⑨⓪]/g, '').replace(/---.*$/, '');
				}),
				leftValues: this.diffList.map(item => Number(item.leftValue)),
				rightValues: this.diffList.map(item => Number(item.rightValue)),
				diffValues: this.diffList.map(item => Number(item.diffValue))
			};
		}
	},
	watch: {
		diffList: {
			handler() {
				if (this.activeTab === 'chart' && this.diffList.length > 0) {
					this.$nextTick(() => {
						this.initChart();
					});
				}
			},
			deep: true
		}
	},
	methods: {
		fix,
		// 顶部日期选择变化时的处理
		async handleTopDateChange(value) {
			if (value) {
				try {
					this.isLoadingDates = true;
					const response = await getTargetDates(value);
					this.availableDates = response.data || [];
					// 清空之前选择的左侧和右侧时间
					this.targetLeftDate = null;
					this.targetRightDate = null;
				} catch (error) {
					this.$message.error('获取可选时间列表失败');
					console.error('获取可选时间列表失败:', error);
				} finally {
					this.isLoadingDates = false;
				}
			} else {
				// 如果清空了顶部时间，也清空下拉选项和选择的时间
				this.availableDates = [];
				this.targetLeftDate = null;
				this.targetRightDate = null;
			}
		},
		// 对左侧时间的校验逻辑
		changeLeftDate(value) {
			// 下拉选择，无需复杂校验
			console.log(`changeLeftDate: ${value}`);
		},
		// 表格右侧时间的校验逻辑
		changeRightDate(value) {
			// 下拉选择，无需复杂校验
			console.log(`changeRightDate: ${value}`);
		},
		// 搜索
		async handleChangeSearch() {
			try {
				// 并行获取左右两侧的数据
				const [left, right] = await Promise.all([this.getChangeData(this.changeForm.endTime, this.targetLeftDate), this.getChangeData(this.changeForm.endTime, this.targetRightDate)]);

				// 格式化数据
				this.fixedMoneyTableData = this.formatTableData(left);
				this.changeMoneyTableData = this.formatTableData(right);

				// 计算差异
				this.calculateDiff();

				// 如果当前在图表 tab，更新图表
				if (this.activeTab === 'chart') {
					this.$nextTick(() => {
						this.initChart();
					});
				}
			} catch (error) {
				this.$message.error('获取数据失败，请重试');
				console.error('获取数据失败:', error);
			}
		},
		// 计算差异行和差异列表（使用 math.js 进行高精度计算）
		calculateDiff(leftTableData, rightTableData) {
			this.diffRows = [];
			this.diffModules = [];
			this.diffList = [];
			const leftData = leftTableData || this.fixedMoneyTableData;
			const rightData = rightTableData || this.changeMoneyTableData;
			if (!leftData || !rightData || leftData.length === 0 || rightData.length === 0) {
				return;
			}

			// 进行计算差异
			const minLength = Math.min(leftData.length, rightData.length);
			for (let i = 0; i < minLength; i++) {
				if (!leftData[i] || !rightData[i]) continue;

				// 使用 math.js 进行高精度计算
				// 使用本日资金总额（anotherLabel）而不是资金变动金额（anotherValue）
				const leftValue = Number(leftData[i].anotherLabel || 0);
				const rightValue = Number(rightData[i].anotherLabel || 0);
				const diffValue = subtract(leftValue, rightValue);
				const absDiffValue = abs(diffValue);

				// 如果存在差异（不允许任何误差），使用 math.js 的 compare 进行比较
				if (compare(absDiffValue, 0) === 1) {
					this.diffRows.push(i);
					if (rightData[i].moduleName) {
						this.diffModules.push(rightData[i].moduleName);
					}
					// 添加到差异列表（排除第一行总资产）
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
		 * 获取变动数据 23号修改的数据，现在给B为23,C为24,A给19现在能搜索出来
		 * @param backupDate 顶部搜索框的时间
		 * @param targetDate  下表中左侧的时间或者右侧的时间 不传则默认顶部搜索框的时间
		 * @returns {Promise<void>}
		 */
		async getChangeData(backupDate, targetDate) {
			// 查询变动数据
			const query = {
				backupDate: backupDate || this.changeForm.endTime,
				targetDate: targetDate || this.changeForm.endTime
			};
			const changeMoney = await getMoneyChangeSummaryByDate(query);
			return changeMoney.data.originalData;
		},
		// 计算总资产（使用 math.js 进行高精度计算）
		calculateTotalBalance(data) {
			// 资金总额=①+②-③-④+⑤+⑥+⑦-⑧-⑨+⓪（与 totalMoneyChange 保持一致）
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

			let result = add(
				safe.companyTotalBalance,
				safe.selfCompanyTotalFunds,
				safe.loanFromCompany,
				safe.futuresMarginBalance,
				safe.paymentMarginBalance,
				safe.remainingInventoryAmount
			);
			result = subtract(result, safe.supplierTotalBalance);
			result = subtract(result, safe.driverUnpaidAmount);
			result = subtract(result, safe.receiveMarginBalance);
			result = subtract(result, safe.loanBalance);

			return format(result, { notation: 'fixed', precision: 2 });
		},
		// 对数据进行格式化处理（使用 math.js 进行高精度计算）
		formatTableData(list) {
			// 根据type进行判断 然后存入一个数组 进行对比 然后高亮相关列
			const { startTimeMoney, endTimeMoney } = _.cloneDeep(list);

			// 计算数据差异的函数（使用 math.js 进行高精度计算）
			const calculateDifference = field => {
				const startValue = Number(startTimeMoney[field] || 0);
				const endValue = Number(endTimeMoney[field] || 0);
				return subtract(startValue, endValue);
			};

			// 格式化数值为两位小数（使用 math.js 的 format 函数）
			const formatNumber = value => {
				const numValue = typeof value === 'number' ? value : Number(value || 0);
				return format(numValue, { notation: 'fixed', precision: 2 });
			};

			// 创建表格数据的函数
			const createRow = (label, value, anotherLabel, anotherValue, moduleName) => ({
				label,
				value: formatNumber(value),
				anotherLabel: formatNumber(anotherLabel),
				anotherValue: formatNumber(anotherValue),
				moduleName
			});

			// 计算各个字段的差异（使用高精度计算）
			const data = {
				companyTotalBalance: calculateDifference('companyTotalBalance'),
				supplierTotalBalance: calculateDifference('supplierTotalBalance'),
				driverUnpaidAmount: calculateDifference('driverUnpaidAmount'),
				selfCompanyTotalFunds: calculateDifference('selfCompanyTotalFunds'),
				loanBalance: calculateDifference('loanBalance'),
				futuresMarginBalance: calculateDifference('futuresMarginBalance'),
				loanFromCompany: calculateDifference('loanFromCompany'),
				paymentMarginBalance: calculateDifference('paymentMarginBalance'),
				receiveMarginBalance: calculateDifference('receiveMarginBalance'),
				remainingInventoryAmount: calculateDifference('remainingInventoryAmount')
			};

			return [
				createRow('资金总额=①+②-③-④+⑤+⑥+⑦-⑧-⑨+⓪', this.calculateTotalBalance(startTimeMoney), this.calculateTotalBalance(endTimeMoney), this.calculateTotalBalance(data), null),
				createRow('①客户欠款合计数', startTimeMoney.companyTotalBalance, endTimeMoney.companyTotalBalance, data.companyTotalBalance, `companyTotalBalance`),
				createRow('②所有银行卡资金合计', startTimeMoney.selfCompanyTotalFunds, endTimeMoney.selfCompanyTotalFunds, data.selfCompanyTotalFunds, `selfCompanyTotalFunds`),
				createRow('⑤其他应收-个人从公司借款', startTimeMoney.loanFromCompany, endTimeMoney.loanFromCompany, data.loanFromCompany, `loanFromCompany`),
				createRow('⑥期货保证金', startTimeMoney.futuresMarginBalance, endTimeMoney.futuresMarginBalance, data.futuresMarginBalance, `futuresMarginBalance`),
				createRow('⑦支付保证金', startTimeMoney.paymentMarginBalance, endTimeMoney.paymentMarginBalance, data.paymentMarginBalance, `paymentMarginBalance`),
				createRow('⓪库存金额', startTimeMoney.remainingInventoryAmount, endTimeMoney.remainingInventoryAmount, data.remainingInventoryAmount, `remainingInventoryAmount`),
				createRow('③欠厂家货款', startTimeMoney.supplierTotalBalance, endTimeMoney.supplierTotalBalance, data.supplierTotalBalance, `supplierTotalBalance`),
				createRow('④未支付运费合计', startTimeMoney.driverUnpaidAmount, endTimeMoney.driverUnpaidAmount, data.driverUnpaidAmount, `driverUnpaidAmount`),
				createRow('⑧收取保证金', startTimeMoney.receiveMarginBalance, endTimeMoney.receiveMarginBalance, data.receiveMarginBalance, `receiveMarginBalance`),
				createRow('⑨公司从外面借款合计', startTimeMoney.loanBalance, endTimeMoney.loanBalance, data.loanBalance, `loanBalance`)
			];
		},
		// 点击差异项查看详情
		handleDiffItemClick(item) {
			if (!item.moduleName) {
				console.warn('差异项没有模块名');
				return;
			}
			// 查看明细，传递项目名称
			this.viewModuleDetail(item.moduleName, item.label);
		},
		// 查看模块详情
		viewModuleDetail(moduleName, projectName) {
			// 需要查询的表名 后端需要根据表名来获取对应的变动数据
			// 这里默认是查询所有的表名 后续需要根据实际情况进行修改
			const query = {
				variableName: moduleName,
				backupDate: this.changeForm.endTime,
				firstTargetDate: this.targetLeftDate,
				secondTargetDate: this.targetRightDate
			};
			// 获取变动明细 这里的接口是测试接口 后续需要换成 getBackupInfoV1 接口
			// getBackupInfoV1
			getBackupInfoV2(query).then(res => {
				if (_.isEmpty(res.rows)) {
					this.$message.warning('该模块没有变动信息');
					return;
				}
				const tableNames = res.rows.map(item => item.tableName);
				const uniqueTableNames = _.uniq(tableNames);
				console.log(uniqueTableNames);
				// 提取表名并去重，过滤掉不需要的表
				const moduleList = _.without(uniqueTableNames, [TableName.ORDER_DETAIL, TableName.INVENTORDETAIL]);
				// 使用项目名称作为弹窗标题
				const dialogTitle = projectName || '请选择模块查看其详细资金变动';
				this.openDialog(
					ChooseModule,
					dialogTitle,
					'700px',
					{
						moduleList,
						result: _.cloneDeep(res.rows)
					},
					false,
					false
				);
			});
		},
		// Tab 切换处理
		handleTabChange(tab) {
			this.activeTab = tab.name;
			if (tab.name === 'chart' && this.diffList.length > 0) {
				this.$nextTick(() => {
					this.initChart();
				});
			}
		},
		// 初始化图表
		initChart() {
			if (!this.chartData) return;

			const chartDom = document.getElementById('diffChart');
			if (!chartDom) return;

			// 销毁旧图表
			if (this.diffChart) {
				this.diffChart.dispose();
			}

			this.diffChart = echarts.init(chartDom);

			const option = {
				tooltip: {
					trigger: 'axis',
					axisPointer: {
						type: 'shadow'
					},
					formatter: params => {
						let result = params[0].name + '<br/>';
						params.forEach(item => {
							// 使用 math.js 的 abs 进行高精度计算
							const absValue = abs(Number(item.value || 0));
							const formattedValue = absValue.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
							result += `${item.marker}${item.seriesName}: ${item.value >= 0 ? '+' : ''}${formattedValue}<br/>`;
						});
						return result;
					}
				},
				legend: {
					data: ['当日截取', '固定截取', '差异值'],
					top: 10
				},
				grid: {
					left: '3%',
					right: '4%',
					bottom: '15%',
					top: '15%',
					containLabel: true
				},
				xAxis: {
					type: 'category',
					data: this.chartData.categories,
					axisLabel: {
						rotate: 45,
						interval: 0,
						fontSize: 12
					}
				},
				yAxis: {
					type: 'value',
					axisLabel: {
						formatter: value => {
							// 使用 math.js 的 abs 进行高精度计算
							const absValue = abs(Number(value || 0));
							return absValue.toLocaleString('zh-CN', { maximumFractionDigits: 0 });
						}
					}
				},
				series: [
					{
						name: this.targetLeftDate || '当日截取',
						type: 'bar',
						data: this.chartData.leftValues,
						itemStyle: {
							color: '#409eff'
						},
						label: {
							show: true,
							position: 'top',
							formatter: value => {
								return value.value >= 0 ? '+' : '' + value.value.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
							}
						}
					},
					{
						name: this.targetRightDate || '固定截取',
						type: 'bar',
						data: this.chartData.rightValues,
						itemStyle: {
							color: '#67c23a'
						},
						label: {
							show: true,
							position: 'top',
							formatter: value => {
								return value.value >= 0 ? '+' : '' + value.value.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
							}
						}
					},
					{
						name: '差异值',
						type: 'line',
						data: this.chartData.diffValues,
						itemStyle: {
							color: '#e6a23c'
						},
						lineStyle: {
							width: 3
						},
						symbol: 'circle',
						symbolSize: 8,
						label: {
							show: true,
							position: 'top',
							formatter: value => {
								return value.value >= 0 ? '+' : '' + value.value.toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
							}
						}
					}
				]
			};

			this.diffChart.setOption(option);

			// 响应式调整
			window.addEventListener('resize', this.handleChartResize);
		},
		// 图表响应式调整
		handleChartResize() {
			if (this.diffChart) {
				this.diffChart.resize();
			}
		},
		// 计算当日利润变动（使用 math.js 进行高精度计算）
		calculateProfitChange(anotherLabel, value) {
			const anotherLabelNum = Number(anotherLabel || 0);
			const valueNum = Number(value || 0);
			const result = subtract(anotherLabelNum, valueNum);
			return format(result, { notation: 'fixed', precision: 2 });
		},
		// 判断差异值是否大于阈值（使用 math.js 进行高精度比较）
		isDiffLarge(diffValue, threshold = 1000) {
			const diffNum = Number(diffValue || 0);
			const absDiff = abs(diffNum);
			return compare(absDiff, threshold) === 1; // 返回 true 如果 absDiff > threshold
		},
		// 表格行类名方法，用于高亮差异行
		tableRowClassName({ row, rowIndex }) {
			return this.diffRows.includes(rowIndex) ? 'diff-row' : '';
		},
		// 处理表格行点击事件
		handleTableRowClick(row, column, event) {
			// 获取行索引（检查两个表格的数据源）
			const leftIndex = this.changeMoneyTableData.indexOf(row);
			const rightIndex = this.fixedMoneyTableData.indexOf(row);
			const rowIndex = leftIndex !== -1 ? leftIndex : rightIndex;
			// 判断是否是差异行且有模块名
			if (rowIndex !== -1 && this.diffRows.includes(rowIndex) && row.moduleName) {
				// 调用查看模块详情，传递项目名称
				this.viewModuleDetail(row.moduleName, row.label);
			}
		},
		// 合并行和列的方法
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
						rowspan: 6, // 合并 6 行
						colspan: 1
					};
				} else if (rowIndex === 7) {
					// 合并“负债类”行
					return {
						rowspan: 4, // 合并 4 行
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
						rowspan: this.fixedMoneyTableData.length,
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
	},
	beforeDestroy() {
		// 销毁图表
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
			<el-form id="top-search-form-item" :inline="true" :model="changeForm" class="search-form" label-width="150px">
				<el-form-item label="日期查询">
					<el-date-picker v-model="changeForm.endTime" type="date" value-format="yyyy-MM-dd" placeholder="选择日期" @change="handleTopDateChange"></el-date-picker>
				</el-form-item>
				<el-form-item>
					<el-button :disabled="!changeForm.endTime || !targetLeftDate || !targetRightDate" type="primary" @click="handleChangeSearch">搜索</el-button>
				</el-form-item>
			</el-form>

			<el-row>
				<el-alert title="请先选择顶部日期，然后从下拉框中选择两个表格的时间。差异对比信息将显示在表格下方" type="warning"></el-alert>
			</el-row>
			<br />
			<!-- 表格 -->
			<el-row :gutter="30">
				<el-col :span="12">
					<!--          日期选择框-->
					<el-row>
						<el-col :span="20">
							<el-select v-model="targetLeftDate" placeholder="选择当日截取查询日期" style="width: 100%" size="mini" :disabled="!availableDates.length" :loading="isLoadingDates" @change="changeLeftDate">
								<el-option v-for="date in availableDates" :key="date" :label="date" :value="date"></el-option>
							</el-select>
						</el-col>
					</el-row>
					<br />
					<el-table size="mini" :data="changeMoneyTableData" border class="money-table" :span-method="objectSpanMethod" :row-class-name="tableRowClassName" @row-click="handleTableRowClick">
						<el-table-column :label="columnHeaderChange" align="center" show-overflow-tooltip>
							<el-table-column label="科目名称" show-overflow-tooltip>
								<template slot-scope="scope">
									<!-- 只在第一行显示"股东权益" -->
									<div v-if="scope.$index === 0">股东权益</div>
									<!-- 合并"资产类" -->
									<div v-if="scope.$index === 1">资产类</div>
									<!-- 合并"负债类" -->
									<div v-if="scope.$index === 7">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目" show-overflow-tooltip width="300px"></el-table-column>
							<el-table-column prop="value" label="上日资金总额" show-overflow-tooltip></el-table-column>
							<el-table-column label="当日利润变动" show-overflow-tooltip>
								<template slot-scope="scope">
									<!-- 只在第一行显示差值 -->
									<div v-if="scope.$index === 0">
										{{ calculateProfitChange(scope.row.anotherLabel, scope.row.value) }}
									</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" show-overflow-tooltip></el-table-column>
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" show-overflow-tooltip></el-table-column>
						</el-table-column>
					</el-table>
				</el-col>
				<el-col :span="12">
					<el-row>
						<el-col :span="20">
							<el-select v-model="targetRightDate" placeholder="选择数据固定后日期" style="width: 100%" size="mini" :disabled="!availableDates.length" :loading="isLoadingDates" @change="changeRightDate">
								<el-option v-for="date in availableDates" :key="date" :label="date" :value="date"></el-option>
							</el-select>
						</el-col>
					</el-row>
					<br />
					<el-table size="mini" :data="fixedMoneyTableData" border class="money-table" :span-method="objectSpanMethod" :row-class-name="tableRowClassName" @row-click="handleTableRowClick">
						<el-table-column :label="columnHeaderFix" align="center" show-overflow-tooltip>
							<el-table-column label="科目名称" show-overflow-tooltip>
								<template slot-scope="scope">
									<!-- 只在第一行显示"股东权益" -->
									<div v-if="scope.$index === 0">股东权益</div>
									<!-- 合并"资产类" -->
									<div v-if="scope.$index === 1">资产类</div>
									<!-- 合并"负债类" -->
									<div v-if="scope.$index === 7">负债类</div>
								</template>
							</el-table-column>
							<el-table-column prop="label" label="项目" show-overflow-tooltip width="300px"></el-table-column>
							<el-table-column prop="value" label="上日资金总额" show-overflow-tooltip></el-table-column>
							<el-table-column label="当日利润变动" show-overflow-tooltip>
								<template slot-scope="scope">
									<!-- 只在第一行显示差值 -->
									<div v-if="scope.$index === 0">
										{{ calculateProfitChange(scope.row.anotherLabel, scope.row.value) }}
									</div>
								</template>
							</el-table-column>
							<el-table-column prop="anotherLabel" label="本日资金总额" show-overflow-tooltip></el-table-column>
							<el-table-column prop="anotherValue" label="当日资金总额变动情况" show-overflow-tooltip></el-table-column>
						</el-table-column>
					</el-table>
				</el-col>
			</el-row>

			<!-- 差异对比展示区域 -->
			<div v-if="diffList.length > 0" class="diff-comparison-section">
				<el-card class="diff-card">
					<div slot="header" class="diff-header">
						<span class="diff-title">
							<i class="el-icon-warning-outline"></i>
							差异对比结果
						</span>
						<el-tag v-if="diffSummary" type="warning" size="medium" class="diff-summary-tag">共发现 {{ diffSummary.totalCount }} 项差异</el-tag>
					</div>
					<el-tabs v-model="activeTab" @tab-click="handleTabChange">
						<!-- 卡片对比 Tab -->
						<el-tab-pane label="卡片对比" name="card">
							<div class="diff-content">
								<div v-for="(item, index) in diffList" :key="index" class="diff-item" @click="handleDiffItemClick(item)">
									<div class="diff-item-header">
										<span class="diff-label">{{ item.label }}</span>
										<el-tag :type="isDiffLarge(item.diffValue, 1000) ? 'danger' : 'warning'" size="medium" class="diff-value-tag">差异: {{ Number(item.diffValue) > 0 ? '+' : '' }}{{ item.diffValue }}</el-tag>
									</div>
									<div class="diff-item-body">
										<div class="diff-value-item">
											<span class="diff-value-label">{{ targetLeftDate || '当日截取' }}:</span>
											<span class="diff-value left-value">{{ item.leftValue }}</span>
										</div>
										<div class="diff-arrow">
											<i class="el-icon-right"></i>
										</div>
										<div class="diff-value-item">
											<span class="diff-value-label">{{ targetRightDate || '固定截取' }}:</span>
											<span class="diff-value right-value">{{ item.rightValue }}</span>
										</div>
									</div>
								</div>
							</div>
						</el-tab-pane>
						<!-- 图表对比 Tab -->
						<el-tab-pane label="图表对比" name="chart">
							<div class="chart-container">
								<div id="diffChart" class="diff-chart"></div>
							</div>
						</el-tab-pane>
					</el-tabs>
				</el-card>
			</div>

			<!-- 无差异提示 -->
			<div v-else-if="fixedMoneyTableData.length > 0 && changeMoneyTableData.length > 0" class="no-diff-tip">
				<el-alert title="两个时间点的数据完全一致，无差异" type="success" :closable="false"></el-alert>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss">
.container {
	margin: 30px;
}

// 差异对比区域
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

// 图表容器
.chart-container {
	padding: 20px 0;
}

.diff-chart {
	width: 100%;
	height: 500px;
	min-height: 500px;
}

// 差异标签字体放大
::v-deep .diff-summary-tag {
	font-size: 14px;
	padding: 4px 12px;
	line-height: 1.2;
	height: auto;
	display: inline-flex;
	align-items: center;

	.el-tag__content {
		line-height: 1.2;
	}
}

::v-deep .diff-value-tag {
	font-size: 16px;
	font-weight: bold;
	padding: 4px 16px;
	line-height: 1.2;
	height: auto;
	display: inline-flex;
	align-items: center;

	.el-tag__content {
		line-height: 1.2;
		display: flex;
		align-items: center;
	}
}

// 差异行高亮样式（需要更高的优先级来覆盖 element-ui.scss 中的样式）
.money-table {
	::v-deep .el-table__body-wrapper {
		.el-table__body {
			tr.diff-row {
				background-color: #ffeb3b !important;
				cursor: pointer !important;

				&:hover {
					background-color: #ffd54f !important;
				}

				td {
					background-color: #ffeb3b !important;
				}

				&:hover td {
					background-color: #ffd54f !important;
				}
			}
		}
	}

	// 固定列也需要高亮
	::v-deep .el-table__fixed-body-wrapper {
		.el-table__body {
			tr.diff-row {
				background-color: #ffeb3b !important;
				cursor: pointer !important;

				&:hover {
					background-color: #ffd54f !important;
				}

				td {
					background-color: #ffeb3b !important;
				}

				&:hover td {
					background-color: #ffd54f !important;
				}
			}
		}
	}
}
</style>
