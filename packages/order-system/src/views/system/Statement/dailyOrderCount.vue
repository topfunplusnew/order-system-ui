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
				{ key: 1, label: `录入员`, visible: true },
				{ key: 2, label: `区域`, visible: true },
				{ key: 3, label: `联系方式`, visible: true }
			],
			statementList: [],
			dialogVisible: false
		};
	},
	created() {
		this.calculateTimeParams();
		getDailyOrderCount(this.queryParams).then(res => {
			this.statementList = res.data;
			this.handleData(this.statementList);
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
		// 根据选择的月份计算 beginTime 和 endTime
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
		// 处理年份数据l
		handleData(list, type) {
			// 如果传入的不是数组
			if (typeof list !== 'object') {
				return;
			}
			// flag 判断一下 如果是年份
			if (type === 0) {
				// 存放年份数据
				const ist = new Set();
				// 从传入的数组中填入年份
				const handleItemList = itemList => {
					itemList.forEach(item => {
						const element = item.orderDateButMonth.split('-')[type];
						// 如果已经存放过年份数据 就不存
						if (!ist.has(element)) {
							ist.add(element);
						}
					});
				};

				if (list.length > 0) {
					handleItemList(list[0].orderStatisticsList);
				}
				return Array.from(ist);
				// 处理月份数据
			} else {
				// 筛选函数
				const handler = orderStatisticsList => {
					return orderStatisticsList.filter(item => item.orderDateButMonth.split('-')[0] === type);
				};
				return handler(list[0].orderStatisticsList);
			}
		},
		// 时间查询
		handleQuery() {
			this.calculateTimeParams();
			getDailyOrderCount(this.queryParams).then(res => {
				this.statementList = res.data;
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
						v-horizontal-scroll="'always'"
						border
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
							<el-table-column v-if="columns[0].visible" label="客户" align="center" prop="companyName" width="200" show-overflow-tooltip />
							<el-table-column v-if="columns[1].visible" label="录入员" align="driverName" prop="salesman" width="200" show-overflow-tooltip />
							<el-table-column v-if="columns[2].visible" label="区域" align="center" prop="region" width="200" show-overflow-tooltip />
						</el-table-column>
						<!--            联系方式-->
						<el-table-column align="center" label="联系方式" prop="phone" show-overflow-tooltip></el-table-column>
						<!--            年份信息 遍历年份数组-->
						<template v-if="statementList.length !== 0">
							<el-table-column v-for="(item, index) in handleData(statementList, 0)" :key="index" align="center" :label="item + `年`" show-overflow-tooltip>
								<!--              遍历月份 先拿到该年份下的月份数据 然后在下面进行遍历-->
								<el-table-column v-for="(element, cols) in handleData(statementList, item)" :key="cols" label="发货量" align="center" width="100" show-overflow-tooltip>
									<template #header>
										{{ element.orderDateButMonth.split('-')[1] + `月份` }}
									</template>
									<template #default="scope">
										<div v-if="scope.row.orderStatisticsList.length !== 0">
											{{ scope.row.orderStatisticsList[index].orderCount }}
										</div>
										<div v-else>0</div>
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
