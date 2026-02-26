<!--运费科目汇总账-->
<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh">刷新</el-button>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form id="top-search-form-item" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" />
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="queryParams.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" />
			</el-form-item>
			<el-form-item label="车牌号" prop="carNo">
				<el-input v-model="queryParams.carNo" placeholder="请输入车牌号" clearable @keyup.enter.native="handleQuery" />
			</el-form-item>
			<el-form-item label="运输类型" prop="isSea">
				<el-select v-model="queryParams.isSea" placeholder="请选择" @keyup.enter.native="handleQuery">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px">运费科目汇总账</el-row>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML" />
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-folder-opened" size="mini" @click="handleExport">导出Excel</el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 运费报表表格 -->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="lendMoneyList"
			size="mini"
			:cell-style="
				() => {
					return { padding: '1.5px' };
				}
			"
		>
			<!-- 序号 -->
			<el-table-column v-if="columns[0].visible" label="序号" align="center" type="index" width="160" show-overflow-tooltip />
			<!-- 任务9：表格左侧新增【日期】列，取顶部搜索开始/结束时间拼接展示（不精确到秒） -->
			<el-table-column label="日期" align="center" width="260" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ queryDateRangeText }}
				</template>
			</el-table-column>
			<!-- 车牌号 -->
			<el-table-column v-if="columns[6].visible" label="车牌号" align="center" prop="carNo" width="110" show-overflow-tooltip />
			<!-- 司机姓名 -->
			<el-table-column v-if="columns[1].visible" label="司机姓名" align="center" prop="companyName" width="110" show-overflow-tooltip />

			<!-- 初期方向 -->
			<el-table-column v-if="columns[2].visible" label="初期方向" align="center" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					<div v-if="scope">
						<span v-if="scope.row.beginningBalance < 0">贷</span>
						<span v-else-if="scope.row.beginningBalance > 0">借</span>
						<span v-else>平</span>
					</div>
				</template>
			</el-table-column>

			<!-- 初期余额 -->
			<el-table-column v-if="columns[3].visible" label="初期余额" align="center" prop="beginningBalance" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ formatBalance(scope.row.beginningBalance) }}
				</template>
			</el-table-column>

			<!-- 借方 -->
			<el-table-column v-if="columns[4].visible" label="借方" align="center" prop="positiveSum" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ fix(-scope.row.positiveSum) }}
				</template>
			</el-table-column>

			<!-- 贷方 -->
			<el-table-column v-if="columns[5].visible" label="贷方" align="center" prop="negativeSum" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ fix(scope.row.negativeSum) }}
				</template>
			</el-table-column>

			<!-- 期末方向 -->
			<el-table-column v-if="columns[7].visible" label="期末方向" align="center" prop="initialBalanceDirection" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					<div v-if="scope">
						<span v-if="scope.row.endingBalance < 0">贷</span>
						<span v-else-if="scope.row.endingBalance > 0">借</span>
						<span v-else>平</span>
					</div>
				</template>
			</el-table-column>

			<!-- 期末余额 -->
			<el-table-column v-if="columns[8].visible" label="期末余额" align="center" prop="endingBalance" width="160" show-overflow-tooltip>
				<template slot-scope="scope">
					{{ formatBalance(scope.row.endingBalance) }}
				</template>
			</el-table-column>

			<!-- 录入员 -->
			<el-table-column v-if="columns[9].visible" label="录入员" align="center" prop="salesman" width="160" show-overflow-tooltip />

			<!-- 操作 -->
			<!--			<el-table-column label="操作" align="center" prop="driverName" width="150" fixed="right">-->
			<!--				<template slot-scope="scope">-->
			<!--					<FreightDetail :detail="scope.row" />-->
			<!--				</template>-->
			<!--			</el-table-column>-->
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="请选择导出时间段" :visible.sync="dialogVisible" width="500px">
			<el-form ref="queryForm" :model="queryParams" size="mini" label-width="68px">
				<el-form-item label="车牌" prop="carNo">
					<el-input v-model="queryParams.carNo" placeholder="请输入车牌号" />
				</el-form-item>
				<el-form-item label="运输类型" prop="isSea">
					<el-select v-model="queryParams.isSea" placeholder="请选择">
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
					</el-select>
				</el-form-item>
				<el-form-item label="开始时间" prop="beginTime">
					<el-date-picker v-model="queryParams.beginTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" />
				</el-form-item>
				<el-form-item label="结束时间" prop="endTime">
					<el-date-picker v-model="queryParams.endTime" type="date" placeholder="选择时间" value-format="yyyy-MM-dd" size="mini" />
				</el-form-item>
			</el-form>
			<span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button type="primary" @click="handleSubmitTime">导 出</el-button>
			</span>
		</el-dialog>
	</div>
</template>

<script>
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { getFreightSubjectDetailSummary, getFreightSubjectDetailSummarySomeDay, getOrderFreightDetailSummary } from '../../../api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import { fix } from 'order-system/src/api/tool/format';
import { formatBalance } from '../../../utils/trash/utils';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';

export default {
	name: 'LendMoney',
	components: {},
	dicts: ['order_target_type'],
	mixins: [mixin_printHTML, common_excel],
	data() {
		return {
			// 遮罩层
			loading: true,
			total: 0,
			lendMoneyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 50,
				beginTime: parseTime(new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000), '{y}-{m}-{d}'),
				endTime: parseTime(new Date()),
				carNo: '',
				// 是否为海运 默认为false
				isSea: false
			},
			options: [
				{
					value: true,
					label: '海运'
				},
				{
					value: false,
					label: '陆运'
				}
			],
			// 表单校验
			columns: [
				{ key: 0, label: '序号', visible: true },
				{ key: 1, label: '司机姓名', visible: true },
				{ key: 2, label: '初期方向', visible: true },
				{ key: 3, label: '初期余额', visible: true },
				{ key: 4, label: '借方', visible: true },
				{ key: 5, label: '贷方', visible: true },
				{ key: 6, label: '车牌号', visible: true },
				{ key: 7, label: '期末方向', visible: true },
				{ key: 8, label: '期末余额', visible: true },
				{ key: 9, label: '录入员', visible: true }
			],

			dialogVisible: false,

			// 运费报表明细表
			detailVisible: false,
			detailTitle: '',
			detailList: [],
			detailLoading: false,
			beginTime: '',
			endTime: ''
		};
	},
	computed: {
		// 任务9：顶部搜索的开始/结束时间拼成：YYYY-MM-DD 00:00:00至YYYY-MM-DD 23:59:59
		queryDateRangeText() {
			const begin = this.queryParams?.beginTime ? String(this.queryParams.beginTime).slice(0, 10) : '';
			const end = this.queryParams?.endTime ? String(this.queryParams.endTime).slice(0, 10) : '';
			if (!begin || !end) return '-';
			return `${begin} 00:00:00至${end} 23:59:59`;
		}
	},
	created() {
		this.getList();
	},
	methods: {
		formatBalance,
		fix,
		/** 查询向外部借出款信息列表 */
		getList() {
			this.loading = true;
			getOrderFreightDetailSummary(this.queryParams).then(response => {
				this.lendMoneyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 运费明细获取
		handleCheckCarNoFreight(row) {
			const carNo = row.carNo;
			// 选择时间
			this.$datePicker().then(res => {
				// 封装查询对象
				const query = {
					carId: row.companyId,
					beginTime: res.beginTime,
					endTime: res.endTime
				};
				// 先查询上年结转
				getFreightSubjectDetailSummarySomeDay(query).then(res => {
					const item = res?.data;
					// 某个车牌的查询明细
					getFreightSubjectDetailSummary(query).then(res => {
						this.detailTitle = `车牌号为${carNo}的运费明细`;
						this.detailList = res.rows;
						// 对数据进行处理 如果借方发生额不为空 摘要为付运费 如果贷方发生额不为空 为司机运费
						this.detailList.forEach(item => {
							if (item.freightPaid) {
								this.$set(item, 'comments', '付运费');
							} else if (item.freightUnPaid) {
								this.$set(item, 'comments', '司机运费');
							}
						});
						if (item) {
							this.$set(item, 'comments', '上年结转');
							// 如果能查出来 那么就推入到头部
							this.detailList.unshift(item);
						}
						this.$message.success('查询成功');
						this.detailVisible = true;
					});
				});
			});
		},
		// 关闭
		close() {
			this.detailVisible = false;
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置查询条件（保留时间参数） */
		resetQuery() {
			// 清除除时间外的所有搜索条件
			this.queryParams.carNo = '';
			this.queryParams.isSea = false;
			this.queryParams.pageNum = 1;
			// 重置表单验证
			this.$nextTick(() => {
				if (this.$refs.queryForm) {
					this.$refs.queryForm.clearValidate();
				}
			});
		},
		refresh() {
			this.resetQuery();
			this.getList();
		},
		handleSubmitTime() {
			this.download(
				'statistics/export/orderfreightDetailsummary',
				{
					...this.queryParams
				},
				`运费科目汇总_${parseTime(new Date().getTime())}.xlsx`
			);
			this.dialogVisible = false;
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'statistics/export/freightDetails',
				{
					beginTime: this.queryParams.beginTime,
					endTime: this.queryParams.endTime,
					carNo: this.queryParams.carNo
				},
				`运费科目汇总账_${parseTime(new Date().getTime())}.xlsx`
			);
		}
	}
};
</script>
