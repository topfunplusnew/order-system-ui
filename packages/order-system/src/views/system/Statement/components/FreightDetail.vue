<!--司机科目明细表-->

<script>
import { getFreightSubjectDetailSummary, getFreightSubjectDetailSummarySomeDay } from '@/api/system/statement';
import { TableName } from '@/api/tool/enums';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import REBATE from '@/components/NeedToShow/REBATE.vue';
import { getFunction } from '@/utils/order/mapper';
import TotalTag from '@/views/system/Statement/components/TotalTag.vue';
import { ReportType } from '../../../../api/tool/enums';
import { fix } from '../../../../api/tool/format';
import { getConfigValue } from '../data/config_get';
import ORDER_FREIGHTVue from '../../../../components/NeedToShow/ORDER_FREIGHT.vue';
import SearchOption from '@/components/SearchOption.vue';
import { parseTime } from '@/utils/ruoyi';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { listCars } from '@/api/system/cars';
import { formatBalance, isDebit, isCredit } from '../../../../utils/trash/utils';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { number, add, subtract, abs } from 'mathjs';

export default {
	name: 'FreightDetail',
	components: { SearchOption, TotalTag },
	mixins: [common_excel],
	data() {
		return {
			searchForm: {
				dateRange: [],
				carNo: null,
				driverId: ''
			},
			carNo: null,
			loading: false,
			// 弹窗
			dialogVisible: false,
			tableData: [],

			// 查询对应信息的弹窗
			infoVisible: false,

			// 对应渲染的组件和信息
			Components: null,
			needToShowInfo: null,

			// 五个字段 tags
			tags: null
		};
	},
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		driverId() {
			return this.detail.companyId;
		}
	},

	methods: {
		formatBalance,
		listCars,
		fix,
		number,
		add,
		subtract,
		abs,
		isDebit,
		isCredit,
		getSelectedTimeRange() {
			const [beginTime, endTime] = this.searchForm.dateRange || [];
			if (!beginTime || !endTime) {
				this.$message.warning('请选择时间范围');
				return null;
			}
			return { beginTime, endTime };
		},
		// 查看明细 点击的时候 先让用户输入时间 然后拿该行数据的companyId查询该司机的明细账
		handleCheck() {
			// 打开时间选择框
			this.$datePicker().then(res => {
				// 清除一下状态
				this.tableData = [];
				// 组装查询条件 分别为开始时间 结束时间 司机id
				const query = {
					companyId: this.searchForm.driverId,
					beginTime: res.beginTime,
					endTime: res.endTime
				};
				// 查询科目信息
				const key = {
					configKey: 'order.freightDetailSummary.subjectNo'
				};
				getConfigValue(key).then(({ configValue, subjectName }) => {
					// 查询明细账之前 要先查询上年结转的余额本币填充
					const body = {
						beginTime: query.beginTime,
						carId: query.companyId
					};
					// 查询司机账户指定时间结转
					getFreightSubjectDetailSummarySomeDay(body).then(res => {
						// 校验一下
						if (!res.data) {
							this.$message.warning('上年结转数据不存在');
							return;
						}
						// 拿到上年的数据
						const lastYearDetail = res.data;
						// 把上年结转的数据放在最前面 并且摘要为上年结转
						this.tableData.push({
							...lastYearDetail,
							summary: '上年结转',
							moneyAmountLocal: fix(number(lastYearDetail.moneyAmount || 0)),
							subjectNo: configValue,
							subjectName: subjectName
						});
						// 查询明细账
						const config = {
							configValue,
							subjectName
						};
						this.checkFreightDetail(query, lastYearDetail, config);
					});
				});
			});
		},
		/**
		 * 查询司机的明细账
		 * @param {any} query
		 * @param {any} lastYearDetail
		 * @param {any} config
		 * @returns {any}
		 */
		checkFreightDetail(query, lastYearDetail, config) {
			// 查询司机明细账
			getFreightSubjectDetailSummary(query).then(res => {
				if (!res.rows && !res.data) {
					this.$message.warning('未查询到相关数据');
					return;
				}
				try {
					// 上年结转的余额
					let currentBalance = number(lastYearDetail.moneyAmount || 0);
					// 累计金额
					let nowMoney = number(0);
					// 拿到汇总账
					const append = res.rows.map(item => {
						// 金额累计计算 - 根据 debitCredit 判断借贷方向
						const amount = number(item.moneyAmount || 0);
						if (item.debitCredit && (isDebit(item.debitCredit) || isCredit(item.debitCredit))) {
							// 如果有 debitCredit 字段，根据借贷方向计算
							if (isDebit(item.debitCredit)) {
								// 借方：司机欠款减少
								nowMoney = add(currentBalance, -amount);
							} else if (isCredit(item.debitCredit)) {
								// 贷方：司机欠款增加
								nowMoney = subtract(currentBalance, amount);
							} else {
								// 没有明确的借贷方向，直接累加
								nowMoney = add(currentBalance, amount);
							}
						} else {
							// 没有 debitCredit 字段，直接累加
							nowMoney = add(currentBalance, amount);
						}
						// 更新余额
						currentBalance = nowMoney;
						// 如果有了摘要 不做处理
						if (item.summary) {
							return {
								...item,
								moneyAmountLocal: fix(nowMoney),
								subjectNo: config.configValue,
								subjectName: config.subjectName
							};
						} else {
							return {
								...item,
								// 如果没有摘要 就加上对应的摘要
								summary: ReportType.FREIGHT[item.tableName],
								moneyAmountLocal: fix(nowMoney),
								subjectNo: config.configValue,
								subjectName: config.subjectName
							};
						}
					});
					// 添加到上年结转数据的后面
					this.tableData = this.tableData.concat(append);
					// 打开弹窗
					this.dialogVisible = true;
				} catch (err) {
					this.$message.warning('查询失败');
				}
			});
		},
		// 查询对应的信息 通过拿表名和id  对应两个字段为tableName payNo
		handleSearch(row) {
			// 拿到表名和id
			const { tableName, payNo } = row;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}
			// 根据tableName动态获取某个JS模块
			if (tableName && payNo) {
				getFunction(tableName)(payNo).then(res => {
					if (!res.data) {
						this.$message.warning('查询该模块条件下，暂无详细数据');
						return;
					}
					// 填充数据
					this.needToShowInfo = res.data;
					// 根据对应表名渲染对应的展示组件
					this.Components = this.getComponents(tableName);
					if (this.Components == null) {
						this.$message.warning('组件渲染有误');
						return;
					}
					// 确保赋值完毕后再打开弹窗
					this.$nextTick(() => {
						this.infoVisible = true;
					});
				});
			}
		},
		// 根据对应的表名渲染对应的组件
		getComponents(tableName) {
			const components = {
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				[TableName.PAYMENT]: PAYMENT,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.CASH_RECORD]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				[TableName.ORDER_DETAIL]: ORDER_DETAIL,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		},
		// 导出Excel
		handleCheckByDateRange() {
			const timeRange = this.getSelectedTimeRange();
			if (!timeRange) return;
			this.tableData = [];
			const query = {
				companyId: this.searchForm.driverId,
				...timeRange
			};
			const key = {
				configKey: 'order.freightDetailSummary.subjectNo'
			};
			getConfigValue(key).then(({ configValue, subjectName }) => {
				const body = {
					beginTime: query.beginTime,
					carId: query.companyId
				};
				getFreightSubjectDetailSummarySomeDay(body).then(res => {
					if (!res.data) {
						this.$message.warning('上年结转数据不存在');
						return;
					}
					const lastYearDetail = res.data;
					this.tableData.push({
						...lastYearDetail,
						summary: '上年结转',
						moneyAmountLocal: fix(number(lastYearDetail.moneyAmount || 0)),
						subjectNo: configValue,
						subjectName: subjectName
					});
					const config = {
						configValue,
						subjectName
					};
					this.checkFreightDetail(query, lastYearDetail, config);
				});
			});
		},
		handleExportByDateRange() {
			if (!this.searchForm.driverId) {
				this.$message.warning('请先选择车牌');
				return;
			}
			const timeRange = this.getSelectedTimeRange();
			if (!timeRange) return;
			this.download(
				'statistics/export/freightBalanceDetails',
				{
					...timeRange,
					carId: this.searchForm.driverId
				},
				`运费科目明细表_${parseTime(new Date().getTime())}.xlsx`
			);
		},
		handleExport() {
			if (!this.searchForm.driverId) {
				this.$message.warning('请先选择车牌');
				return;
			}
			// 选择导出时间范围
			this.$datePicker().then(res => {
				this.download(
					'statistics/export/freightBalanceDetails',
					{
						beginTime: res.beginTime,
						endTime: res.endTime,
						carId: this.searchForm.driverId
					},
					`司机科目明细表_${parseTime(new Date().getTime())}.xlsx`
				);
			});
		}
	}
};
</script>

<template>
	<div>
		<div class="app-container">
			<el-form id="top-search-form-item" :inline="true" :model="searchForm" class="demo-form-inline" size="mini" label-width="150px">
				<el-form-item label="时间" prop="dateRange">
					<el-date-picker v-model="searchForm.dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" size="mini" clearable />
				</el-form-item>
				<el-form-item label="车牌" prop="carNo">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{}"
								:get-data="listCars"
								query-info="carNo"
								query-label="车牌号"
								:query-name="carNo"
								@update:queryName="value => (carNo = value)"
								@commitBack="
									value => {
										searchForm.driverId = value.id;
										searchForm.carNo = value.carNo;
									}
								"
							>
								<template #table-columns>
									<el-table-column label="车牌/柜号" align="center" prop="carNo" show-overflow-tooltip />
									<el-table-column label="司机姓名/海运公司" align="center" prop="driver" show-overflow-tooltip />
									<el-table-column label="司机电话" align="center" prop="tel" show-overflow-tooltip />
									<el-table-column label="运输类型" align="center" prop="carType" show-overflow-tooltip />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input disabled clearable v-model="searchForm.carNo" placeholder="请选择车牌" size="mini">
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleCheckByDateRange">搜索</el-button>
					<el-button type="success" icon="el-icon-folder-opened" size="mini" @click="handleExportByDateRange">导出Excel</el-button>
				</el-form-item>
				<el-form-item v-if="false">
					<el-button type="primary" icon="el-icon-search" size="mini" @click="handleCheck">搜索</el-button>
					<el-button type="success" icon="el-icon-folder-opened" size="mini" @click="handleExport">导出Excel</el-button>
				</el-form-item>
			</el-form>
			<!--      司机的结转数据-->
			<el-card class="box-card">
				<el-table
					id="printBox"
					v-loading="loading"
					v-horizontal-scroll="'always'"
					border
					:data="tableData"
					max-height="600px"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
				>
					<el-table-column show-overflow-tooltip label="时间" align="center" prop="operateDate" width="140" />
					<!--      操作列-->
					<el-table-column label="凭证号" align="center" class-name="small-padding fixed-width" width="140" prop="payNo">
						<template slot-scope="scope">
							<el-button v-if="scope.row.payNo" type="text" size="mini" @click="handleSearch(scope.row)">点击查询对应信息</el-button>
						</template>
					</el-table-column>
					<el-table-column show-overflow-tooltip label="科目编码" align="center" prop="subjectNo" width="140" />
					<el-table-column show-overflow-tooltip label="科目名称" align="center" prop="subjectName" width="140" />
					<el-table-column show-overflow-tooltip label="司机编号" align="center" prop="companyId" width="140" />
					<el-table-column show-overflow-tooltip label="司机名称" align="center" prop="companyName" width="140" />
					<el-table-column show-overflow-tooltip label="司机银行户名（对方真实收付款名称）" align="center" prop="otherAccountsName" width="140" />
					<el-table-column show-overflow-tooltip label="司机银行卡号" align="center" prop="otherBankNo" width="140" />

					<el-table-column show-overflow-tooltip label="摘要" align="center" prop="summary" width="140" />

					<!--        这两列应该是根据moneyAmount字段的正负进行判断-->
					<el-table-column show-overflow-tooltip label="借方发生额" align="center" width="140">
						<template slot-scope="scope">
							{{ isDebit(scope.row.debitCredit) ? -scope.row.moneyAmount : '-' }}
						</template>
					</el-table-column>
					<el-table-column show-overflow-tooltip label="贷方发生额" align="center" width="140">
						<template slot-scope="scope">
							{{ isCredit(scope.row.debitCredit) ? scope.row.moneyAmount : '-' }}
						</template>
					</el-table-column>

					<!--        方向根据余额本币的正负进行判断 这个要先查询上年结转的余额本币 进行填充-->
					<el-table-column show-overflow-tooltip label="方向" align="center" width="140">
						<template slot-scope="scope">
							{{ scope.row.moneyAmountLocal > 0 ? '借方' : '贷方' }}
						</template>
					</el-table-column>

					<el-table-column show-overflow-tooltip label="余额本币" align="center" prop="moneyAmountLocal" width="140">
						<template slot-scope="scope">
							{{ formatBalance(scope.row.moneyAmountLocal != null ? scope.row.moneyAmountLocal : 0) }}
						</template>
					</el-table-column>
					<el-table-column show-overflow-tooltip label="我方收款户名" align="center" prop="selfAccountsName" width="140" />
					<el-table-column show-overflow-tooltip label="我方银行账号" align="center" prop="selfBankNo" width="140" />
					<el-table-column show-overflow-tooltip label="我方开户行地址" align="center" prop="selfBankName" width="140" />
				</el-table>
			</el-card>

			<!--    对应信息的弹窗-->
			<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
				<component :is="Components" :need-to-show-info="needToShowInfo" />
			</el-dialog>
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
