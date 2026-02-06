<!-- 客户每月发货次数-->
<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getDailyOrderCount } from '@/api/system/statement';
import { parseTime } from '@/utils/ruoyi';

export default {
	name: 'DailyOrderCount',
	mixins: [mixin_printHTML],
	data() {
		// 默认选择当前月份
		const currentMonth = parseTime(new Date(), '{y}-{m}');
		return {
			queryParams: {
				// 选择的月份（用于显示）
				selectedMonth: currentMonth,
				// 传给后端的时间（自动计算）
				beginTime: null,
				endTime: null
			},
			loading: '',
			columns: [
				{ key: 0, label: `客户`, visible: true },
				{ key: 1, label: `销售经理`, visible: true },
				{ key: 2, label: `区域`, visible: true }
			],
			statementList: [],
			dialogVisible: false
		};
	},
	computed: {
		/**
		 * 生成年份月份表头结构
		 * @returns {Array} 返回按年份分组的月份数组，格式：[{year: '2025', months: [{month: '11', dateKey: '2025-11'}]}]
		 */
		yearMonthHeaders() {
			if (!this.statementList || this.statementList.length === 0) {
				return [];
			}
			// 收集所有唯一的 orderDateButMonth
			const dateSet = new Set();
			this.statementList.forEach(item => {
				if (item.orderStatisticsList && Array.isArray(item.orderStatisticsList)) {
					item.orderStatisticsList.forEach(stat => {
						if (stat.orderDateButMonth) {
							dateSet.add(stat.orderDateButMonth);
						}
					});
				}
			});
			// 转换为数组并排序
			const dateArray = Array.from(dateSet).sort();
			// 按年份分组
			const yearMap = {};
			dateArray.forEach(dateKey => {
				const [year, month] = dateKey.split('-');
				if (!yearMap[year]) {
					yearMap[year] = [];
				}
				yearMap[year].push({
					month: month,
					dateKey: dateKey
				});
			});
			// 转换为数组格式，年份按升序排列，月份按升序排列
			return Object.keys(yearMap)
				.sort((a, b) => a.localeCompare(b))
				.map(year => ({
					year: year,
					months: yearMap[year].sort((a, b) => a.dateKey.localeCompare(b.dateKey))
				}));
		}
	},
	created() {
		this.calculateTimeParams();
		getDailyOrderCount(this.queryParams).then(res => {
			this.statementList = res.data || [];
		});
	},
	watch: {
		'queryParams.selectedMonth': {
			handler() {
				this.calculateTimeParams();
			}
		}
	},
	methods: {
		/**
		 * 根据选择的月份计算 beginTime 和 endTime
		 */
		calculateTimeParams() {
			if (!this.queryParams.selectedMonth) {
				return;
			}
			// 解析选择的月份，格式：yyyy-MM
			const [year, month] = this.queryParams.selectedMonth.split('-').map(Number);
			// endTime: 选择月份的最后一天（month 在 Date 中从 0 开始，所以 month 就是选择月份）
			const endDate = new Date(year, month, 0); // 获取选择月份的最后一天
			this.queryParams.endTime = parseTime(endDate, '{y}-{m}-{d}');
			// beginTime: 上个月的第一天
			let beginYear = year;
			let beginMonth = month - 2; // 往前跳一个月（month-2 因为 Date 中月份从 0 开始）
			if (beginMonth < 0) {
				// 如果跨年，处理上一年12月的情况
				beginYear = year - 1;
				beginMonth = 11; // 12月（在 Date 中是 11）
			}
			const beginDate = new Date(beginYear, beginMonth, 1);
			this.queryParams.beginTime = parseTime(beginDate, '{y}-{m}-{d}');
		},
		/**
		 * 根据 orderDateButMonth 获取对应的订单数量
		 * @param {Object} row - 表格行数据
		 * @param {String} dateKey - 日期键，格式：YYYY-MM
		 * @returns {Number} 订单数量
		 */
		getOrderCountByDate(row, dateKey) {
			if (!row.orderStatisticsList || !Array.isArray(row.orderStatisticsList)) {
				return 0;
			}
			const stat = row.orderStatisticsList.find(item => item.orderDateButMonth === dateKey);
			return stat ? stat.orderCount : 0;
		},
		/**
		 * 时间查询
		 */
		handleQuery() {
			this.calculateTimeParams();
			getDailyOrderCount(this.queryParams).then(res => {
				this.statementList = res.data || [];
			});
		},
		refresh() {
			this.handleQuery();
		},
		handleSubmitTime() {
			this.calculateTimeParams();
			this.download(
				'statistics/export/dailyOrderCount',
				{
					beginTime: this.queryParams.beginTime,
					endTime: this.queryParams.endTime
				},
				`客户每月发货次数_${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		handleExport() {
			this.dialogVisible = true;
		}
	}
};
</script>

<template>
	<div>
		<div class="app-container">
			<!--    刷新行-->
			<el-row style="background-color: #e6e6e6">
				<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
			</el-row>
			<hr color="#e6e6e6" />
			<!--    时间范围搜索行-->
			<el-row>
				<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
					<el-form-item label="月份" prop="selectedMonth">
						<el-date-picker v-model="queryParams.selectedMonth" type="month" size="mini" value-format="yyyy-MM" placeholder="选择月份"></el-date-picker>
					</el-form-item>
					<el-form-item>
						<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
					</el-form-item>
				</el-form>
			</el-row>
			<hr color="#e6e6e6" />
			<el-row>
				<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">客户每月发货次数</el-row>
				<el-row>
					<right-toolbar :columns="columns">
						<template #print>
							<el-col :span="1.5">
								<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
							</el-col>
						</template>
						<template #export>
							<el-col :span="1.5">
								<el-button v-hasPermi="['system:supplier:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
							</el-col>
						</template>
					</right-toolbar>

					<!-- todo表格 大数据 -->
					<el-table
						id="printBox"
						v-loading="loading"
						v-horizontal-scroll="'auto'"
						border
						fit
						:data="statementList"
						lazy
						height="570px"
						size="mini"
						:cell-style="
							() => {
								return { padding: '2px' };
							}
						"
					>
						<el-table-column align="center">
							<el-table-column v-if="columns[0].visible" label="客户" align="center" prop="companyName" min-width="150" show-overflow-tooltip />
							<el-table-column v-if="columns[1].visible" label="销售经理" align="center" prop="salesman" min-width="120" show-overflow-tooltip />
							<el-table-column v-if="columns[2].visible" label="区域" align="center" prop="region" min-width="150" show-overflow-tooltip />
						</el-table-column>
						<!--            年份信息 遍历年份数组-->
						<template v-if="yearMonthHeaders.length > 0">
							<el-table-column v-for="(yearItem, yearIndex) in yearMonthHeaders" :key="yearItem.year" align="center" :label="yearItem.year + `年`" show-overflow-tooltip>
								<!--              遍历月份 先拿到该年份下的月份数据 然后在下面进行遍历-->
								<el-table-column v-for="(monthItem, monthIndex) in yearItem.months" :key="monthItem.dateKey" align="center" min-width="80" show-overflow-tooltip>
									<template #header>
										{{ monthItem.month + `月份` }}
									</template>
									<template #default="scope">
										{{ getOrderCountByDate(scope.row, monthItem.dateKey) }}
									</template>
								</el-table-column>
							</el-table-column>
						</template>
					</el-table>
				</el-row>
			</el-row>
		</div>
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="请选择导出月份" :visible.sync="dialogVisible" width="30%">
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
				<el-form-item label="月份" prop="selectedMonth">
					<el-date-picker v-model="queryParams.selectedMonth" type="month" placeholder="选择月份" value-format="yyyy-MM" size="mini"></el-date-picker>
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<style scoped lang="scss">
.el-table-column {
	content-visibility: auto;
}
</style>
