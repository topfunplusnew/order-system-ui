<template>
	<div class="app-container">
		<!-- 搜索区域 -->
		<el-form
			:model="queryParams"
			ref="queryForm"
			:inline="true"
			class="search-form"
		>
			<el-form-item label="模块名称" prop="moduleName">
				<el-select
					v-model="queryParams.moduleName"
					placeholder="请选择模块"
					clearable
					style="width: 200px"
				>
					<el-option
						v-for="item in moduleOptions"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					/>
				</el-select>
			</el-form-item>
			<el-form-item label="时间范围" prop="dateRange">
				<el-date-picker
					v-model="queryParams.dateRange"
					type="daterange"
					range-separator="至"
					start-placeholder="开始日期"
					end-placeholder="结束日期"
					value-format="yyyy-MM-dd"
					:default-time="['00:00:00', '23:59:59']"
					style="width: 360px"
				/>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" @click="handleQuery"
					>搜索</el-button
				>
				<el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 图表区域 -->
		<div class="chart-container">
			<div ref="chart" style="height: 500px"></div>
		</div>

		<!-- 数据详情弹窗 -->
		<el-dialog
			title="数据详情"
			:visible.sync="dialogVisible"
			width="50%"
			:close-on-click-modal="false"
		>
			<el-descriptions :column="2" border>
				<el-descriptions-item label="模块名称">{{
					detailData.moduleName
				}}</el-descriptions-item>
				<el-descriptions-item label="时间点">{{
					detailData.date
				}}</el-descriptions-item>
				<el-descriptions-item label="数值">{{
					detailData.value
				}}</el-descriptions-item>
				<el-descriptions-item label="环比">
					<span :class="detailData.ratio >= 0 ? 'text-success' : 'text-danger'">
						{{ detailData.ratio }}%
						<i
							:class="detailData.ratio >= 0 ? 'el-icon-top' : 'el-icon-bottom'"
						></i>
					</span>
				</el-descriptions-item>
			</el-descriptions>

			<el-table
				:data="detailData.records"
				style="width: 100%; margin-top: 20px"
				border
				stripe
				size="mini"
			>
				<el-table-column prop="time" label="时间" width="180" />
				<el-table-column prop="type" label="类型" width="120" />
				<el-table-column prop="amount" label="金额" width="120">
					<template slot-scope="scope">
						<span
							:class="scope.row.amount >= 0 ? 'text-success' : 'text-danger'"
						>
							{{ scope.row.amount >= 0 ? '+' : '' }}{{ scope.row.amount }}
						</span>
					</template>
				</el-table-column>
				<el-table-column prop="operator" label="操作人" width="120" />
				<el-table-column prop="remark" label="备注" />
			</el-table>
		</el-dialog>
	</div>
</template>

<script>
import * as echarts from 'echarts';

export default {
	name: 'MoneyChange',
	data() {
		const end = new Date();
		const start = new Date();
		start.setMonth(start.getMonth() - 1);

		return {
			// 查询参数
			queryParams: {
				moduleName: undefined,
				dateRange: [this.parseTime(start), this.parseTime(end)]
			},
			// 模块选项
			moduleOptions: [
				{ label: '模块A', value: 'moduleA' },
				{ label: '模块B', value: 'moduleB' },
				{ label: '模块C', value: 'moduleC' },
				{ label: '模块D', value: 'moduleD' }
			],
			// 图表实例
			chart: null,
			// Mock数据
			mockData: {
				xAxis: ['1月', '2月', '3月', '4月', '5月', '6月'],
				series: [
					{
						name: '模块A',
						data: [120, 132, 101, 134, 90, 230]
					},
					{
						name: '模块B',
						data: [220, 182, 191, 234, 290, 330]
					},
					{
						name: '模块C',
						data: [150, 232, 201, 154, 190, 330]
					},
					{
						name: '模块D',
						data: [320, 332, 301, 334, 390, 330]
					}
				]
			},
			// 新增的数据
			dialogVisible: false,
			detailData: {
				moduleName: '',
				date: '',
				value: 0,
				ratio: 0,
				records: []
			}
		};
	},
	mounted() {
		this.initChart();
	},
	beforeDestroy() {
		if (this.chart) {
			this.chart.dispose();
			this.chart = null;
		}
	},
	methods: {
		// 格式化日期
		parseTime(date) {
			const year = date.getFullYear();
			const month = (date.getMonth() + 1).toString().padStart(2, '0');
			const day = date.getDate().toString().padStart(2, '0');
			return `${year}-${month}-${day}`;
		},
		// 初始化图表
		initChart() {
			this.chart = echarts.init(this.$refs.chart);
			this.setChartOption();
		},
		// 设置图表配置
		setChartOption() {
			const option = {
				title: {
					text: '模块数据变化趋势'
				},
				tooltip: {
					trigger: 'axis',
					formatter: params => {
						let result = params[0].axisValue + '<br/>';
						params.forEach(param => {
							result += `${param.seriesName}: ${param.value}<br/>`;
						});
						return result;
					}
				},
				legend: {
					data: this.mockData.series.map(item => item.name)
				},
				grid: {
					left: '3%',
					right: '4%',
					bottom: '3%',
					containLabel: true
				},
				toolbox: {
					feature: {
						saveAsImage: {}
					}
				},
				xAxis: {
					type: 'category',
					boundaryGap: false,
					data: this.mockData.xAxis
				},
				yAxis: {
					type: 'value'
				},
				series: this.mockData.series.map(item => ({
					name: item.name,
					type: 'line',
					data: item.data,
					smooth: true,
					showSymbol: false,
					emphasis: {
						focus: 'series',
						blurScope: 'coordinateSystem'
					}
				}))
			};
			this.chart.setOption(option);

			// 添加点击事件监听
			this.chart.on('click', params => {
				this.handleChartPointClick(params);
			});
		},
		// 处理查询
		handleQuery() {
			// TODO: 这里添加实际的数据查询逻辑
			console.log('查询参数：', this.queryParams);
			// 模拟数据更新
			this.setChartOption();
		},
		// 重置查询
		resetQuery() {
			this.$refs.queryForm.resetFields();
			const end = new Date();
			const start = new Date();
			start.setMonth(start.getMonth() - 1);
			this.queryParams.dateRange = [this.parseTime(start), this.parseTime(end)];
			this.handleQuery();
		},
		// 处理图表点击事件
		handleChartPointClick(params) {
			// 模拟获取详细数据
			this.detailData = {
				moduleName: params.seriesName,
				date: this.mockData.xAxis[params.dataIndex],
				value: params.value,
				ratio: (((params.value - 100) / 100) * 100).toFixed(2),
				records: [
					{
						time: '2024-01-15 09:30:00',
						type: '收入',
						amount: 1500,
						operator: '张三',
						remark: '项目款项'
					},
					{
						time: '2024-01-15 10:15:00',
						type: '支出',
						amount: -500,
						operator: '李四',
						remark: '设备采购'
					},
					{
						time: '2024-01-15 14:20:00',
						type: '收入',
						amount: 2000,
						operator: '王五',
						remark: '服务费'
					},
					{
						time: '2024-01-15 16:45:00',
						type: '支出',
						amount: -800,
						operator: '赵六',
						remark: '日常开支'
					}
				]
			};

			this.dialogVisible = true;
		}
	}
};
</script>

<style scoped>
.search-form {
	margin-bottom: 20px;
	background: #fff;
	padding: 20px;
	border-radius: 4px;
}

.chart-container {
	background: #fff;
	padding: 20px;
	border-radius: 4px;
}

.text-success {
	color: #67c23a;
}

.text-danger {
	color: #f56c6c;
}

/* 弹窗内容的样式 */
:deep(.el-dialog__body) {
	padding: 20px;
}

.el-descriptions {
	margin-bottom: 20px;
}

.el-descriptions-item {
	padding: 12px 20px;
}
</style>
