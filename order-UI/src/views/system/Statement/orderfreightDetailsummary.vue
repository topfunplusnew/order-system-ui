<!--运费科目汇总账-->
<template>
	<div class="app-container">
		<el-row style="background-color: #e6e6e6">
			<el-button type="primary" icon="el-icon-refresh" @click="refresh"
				>刷新</el-button
			>
		</el-row>
		<hr color="#e6e6e6" />
		<el-form
			ref="queryForm"
			:model="queryParams"
			size="mini"
			:inline="true"
			label-width="68px"
		>
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker
					v-model="queryParams.beginTime"
					type="datetime"
					placeholder="请选择开始时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				/>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker
					v-model="queryParams.endTime"
					type="datetime"
					placeholder="请选择结束时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				/>
			</el-form-item>
			<el-form-item label="车牌号" prop="carNo">
				<el-input
					v-model="queryParams.carNo"
					placeholder="请输入车牌号"
					clearable
					@keyup.enter.native="handleQuery"
				/>
			</el-form-item>
			<el-form-item label="运输类型" prop="isSea">
				<el-select v-model="queryParams.isSea" placeholder="请选择">
					<el-option
						v-for="item in options"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					/>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQuery"
				>
					搜索
				</el-button>
			</el-form-item>
		</el-form>
		<hr color="#e6e6e6" />
		<el-row style="font-weight: bold; font-size: 20px; margin: 0 30px"
			>运费科目汇总账</el-row
		>
		<el-row :gutter="10" class="mb8">
			<right-toolbar :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						/>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:company:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						/>
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
					return { padding: '2px' };
				}
			"
		>
			<el-table-column
				v-if="columns[0].visible"
				label="序号"
				align="center"
				type="index"
				width="160"
			/>
			<el-table-column
				label="司机姓名"
				align="center"
				prop="companyName"
				width="110"
			/>
			<el-table-column label="初期方向" align="center" width="160">
				<template slot-scope="scope">
					<div v-if="scope">
						<!--  现在总的需要前端自己计算方向,计算公式为 期初/期末余额>0 则为贷,反之为借,相等为平-->
						<span v-if="scope.row.beginningBalance > 0">贷</span>
						<span v-else-if="scope.row.beginningBalance < 0">借</span>
						<span v-else>平</span>
					</div>
				</template>
			</el-table-column>
			<el-table-column
				label="初期余额"
				align="center"
				prop="beginningBalance"
				width="160"
			/>
			<el-table-column
				label="借方"
				align="center"
				prop="positiveSum"
				width="160"
			/>
			<el-table-column
				label="贷方"
				align="center"
				prop="negativeSum"
				width="160"
			>
				<template slot-scope="scope">
					{{ Math.abs(scope.row.negativeSum) }}
				</template>
			</el-table-column>
			<el-table-column
				label="平账金额"
				align="center"
				prop="balanceaccountsAmount"
				width="160"
			/>
			<el-table-column label="车牌号" align="center" prop="carNo" width="110" />
			<el-table-column
				label="期末方向"
				align="center"
				prop="initialBalanceDirection"
				width="160"
			>
				<template slot-scope="scope">
					<div v-if="scope">
						<!--  现在总的需要前端自己计算方向,计算公式为 期初/期末余额>0 则为贷,反之为借,相等为平-->
						<span v-if="scope.row.endingBalance > 0">贷</span>
						<span v-else-if="scope.row.endingBalance < 0">借</span>
						<span v-else>平</span>
					</div>
				</template>
			</el-table-column>
			<el-table-column
				label="期末余额"
				align="center"
				prop="endingBalance"
				width="160"
			/>
			<el-table-column
				label="业务员"
				align="center"
				prop="salesman"
				width="160"
			/>
			<el-table-column
				label="操作"
				align="center"
				prop="driverName"
				width="150"
				fixed="right"
			>
				<template slot-scope="scope">
					<FreightDetail :detail="scope.row" />
				</template>
			</el-table-column>
		</el-table>

		<pagination
			v-show="total > 0"
			:total="total"
			:page.sync="queryParams.pageNum"
			:limit.sync="queryParams.pageSize"
			@pagination="getList"
		/>

		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="请选择导出时间段"
			:visible.sync="dialogVisible"
			width="30%"
		>
			<el-form
				ref="queryForm"
				:model="queryParams"
				size="mini"
				label-width="68px"
			>
				<el-form-item label="开始时间" prop="beginTime">
					<el-date-picker
						v-model="queryParams.beginTime"
						type="datetime"
						placeholder="选择时间"
						value-format="yyyy-MM-dd HH:mm:ss"
						size="mini"
					/>
				</el-form-item>
				<el-form-item label="结束时间" prop="endTime">
					<el-date-picker
						v-model="queryParams.endTime"
						type="datetime"
						placeholder="选择时间"
						value-format="yyyy-MM-dd HH:mm:ss"
						size="mini"
					/>
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
import {
	getFreightSubjectDetailSummary,
	getFreightSubjectDetailSummarySomeDay,
	getOrderFreightDetailSummary
} from '../../../api/system/statement';
import { parseTime } from '../../../utils/ruoyi';
import FreightDetail from './components/FreightDetail.vue';

export default {
	name: 'LendMoney',
	components: { FreightDetail },
	dicts: ['order_target_type'],
	mixins: [mixin_printHTML],
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
				beginTime: parseTime(
					new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000),
					'{y}-{m}-{d} {h}:{i}:{s}'
				),
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
				{ key: 0, label: `序号`, visible: true },
				{ key: 1, label: `初期方向`, visible: true },
				{ key: 2, label: `初期余额`, visible: true },
				{ key: 3, label: `车牌号`, visible: true },
				{ key: 4, label: `应付运费`, visible: true },
				{ key: 5, label: `已付运费`, visible: true },
				{ key: 6, label: `司机姓名`, visible: true },
				{ key: 7, label: `期末方向`, visible: true },
				{ key: 8, label: `期末余额`, visible: true }
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
	computed: {},
	created() {
		this.getList();
	},
	methods: {
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
						console.log(this.detailList);
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
		refresh() {
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
			this.dialogVisible = true;
		}
	}
};
</script>
