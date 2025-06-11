<template>
	<div class="freight-info">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form :inline="true" :model="searchForm" ref="form" :rules="rules" class="demo-form-inline" size="mini">
				<el-form-item label="开始时间：" prop="startTime">
					<el-date-picker v-model="searchForm.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间：" prop="endTime">
					<el-date-picker v-model="searchForm.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="车辆：" prop="vehicle">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{}"
								:get-data="listCars"
								query-label="车牌搜索"
								:query-name="queryCars"
								query-info="carNo"
								@update:queryName="updateQueryCars"
								@commitBack="handleCommitBackCars"
							>
								<template #table-columns>
									<el-table-column label="车牌" prop="carNo" />
									<el-table-column label="司机姓名/海运公司" align="center" prop="driver" />
									<el-table-column label="司机电话" align="center" prop="tel" />
									<el-table-column label="运输类型" align="center" prop="carType" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input disabled v-model="searchForm.vehicle" placeholder="请选择车牌" />
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="mini">查询</el-button>
					<el-button @click="reset" size="mini">刷新</el-button>
					<el-button type="success" @click="excelExport(['欠款明细'])" size="mini">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
			<el-table-column prop="operateDate" label="日期"></el-table-column>
			<el-table-column prop="payNo" label="欠款明细">
				<!--				<template slot-scope="scope">-->
				<!--					<el-button v-if="scope.row.payNo" type="text" size="mini" @click="handleSearch(scope.row)">点击查询对应信息</el-button>-->
				<!--				</template>-->

				<template slot-scope="scope">
					<div v-for="(item, index) in scope.row.lenderList" :key="index">
						<span style="color: red; margin-right: 6px">[{{ moduleNames[item.tableName] }}]</span>
						<span style="margin-right: 7px">{{ item.lender }}</span>
						<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(item)"></i>
					</div>
				</template>
			</el-table-column>
			<el-table-column prop="lender" label="借方发生额">
				<template slot-scope="scope">
					<span>
						{{ scope.row.lender }}
					</span>
				</template>
			</el-table-column>
			<el-table-column prop="borrower" label="贷方发生额">
				<template slot-scope="scope">
					<span style="margin-right: 10px">{{ scope.row.borrower }}</span>
					<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckBorrowerDetailList(scope.row)"></i>
				</template>
			</el-table-column>
			<el-table-column prop="moneyAmountLocal" label="余额本币">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.moneyAmountLocal < 0 }">{{ formatBalance(scope.row.moneyAmountLocal) }}</span>
				</template>
			</el-table-column>
		</el-table>
		<!-- 分页 -->
		<div class="pagination-container">
			<pagination v-show="total > 0" :total="total" :current-page.sync="searchForm.pageNum" :page-size.sync="searchForm.pageSize" @pagination="getList" />
		</div>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>

		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight title="明细信息" :visible.sync="detailVisible" width="900px" append-to-body>
			<el-table :data="detailList" border style="width: 100%" v-loading="detailLoading" size="mini" :summary-method="getSummaries" show-summary>
				<el-table-column prop="operateDate" label="日期"></el-table-column>
				<el-table-column prop="payNo" label="凭证号"></el-table-column>
				<el-table-column prop="lender" label="借方(客户提货+买票点)"></el-table-column>
				<el-table-column prop="borrower" label="贷方(收客户款)"></el-table-column>
				<el-table-column prop="moneyAmountLocal" label="余额本币"></el-table-column>
				<!--        添加查看列-->
				<el-table-column label="查看明细">
					<template slot-scope="scope">
						<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(scope.row)"></i>
					</template>
				</el-table-column>
			</el-table>
		</el-dialog>
	</div>
</template>

<script>
import { getFreightSubjectDetailSummary, getFreightSubjectDetailSummarySomeDay } from '@/api/system/statement';
import { aggregateByDay, fix } from '@/api/tool/format';
import { getFunction } from '@/utils/order/mapper';
import { moduleNames, TableName } from '@/api/tool/enums';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
import PAYMENT from '@/components/NeedToShow/PAYMENT.vue';
import INVOICE_IN from '@/components/NeedToShow/INVOICE_IN.vue';
import INVOICE_OUT from '@/components/NeedToShow/INVOICE_OUT.vue';
import INVOICE_ORTHER from '@/components/NeedToShow/INVOICE_ORTHER.vue';
import OFFSETTING from '@/components/NeedToShow/OFFSETTING.vue';
import REBATE from '@/components/NeedToShow/REBATE.vue';
import INVENTORY from '@/components/NeedToShow/INVENTORY.vue';
import ORDER_FREIGHTVue from '@/components/NeedToShow/ORDER_FREIGHT.vue';
import SearchOption from '@/components/SearchOption.vue';
import { listVehicles } from '@/api/system/vehicles';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue';
import { listCars } from '@/api/system/cars';
import _ from 'lodash';
import {formatBalance} from "../../../utils/trash/utils";

export default {
	name: 'FreightInfo',
	computed: {
		moduleNames() {
			return moduleNames;
		}
	},
	components: { SearchOption },
	mixins: [common_excel],
	data() {
		return {
			loading: false,
			currentPage: 1,
			pageSize: 10,
			total: 0,
			searchForm: {
				startTime: '',
				endTime: '',
				vehicle: '',
				companyId: null
			},
			tableData: [],
			infoVisible: false,
			needToShowInfo: {},
			Components: null,
			queryCars: null,
			rules: {
				startTime: [{ required: true, message: '请选择开始时间', trigger: 'blur' }],
				endTime: [{ required: true, message: '请选择结束时间', trigger: 'blur' }],
				vehicle: [{ required: true, message: '请选择车辆', trigger: 'blur' }]
			},
			detailLoading: false,
			detailList: [],
			detailVisible: false
		};
	},
	methods: {
    formatBalance,
		listCars,
		listVehicles,
		// 查询方法
		getList() {
			this.$refs['form']?.validate(valid => {
				if (valid) {
					this.loading = true;
					const body = {
						beginTime: this.searchForm.startTime,
						carId: this.searchForm.companyId
					};
					getFreightSubjectDetailSummarySomeDay(body).then(res => {
						// 校验
						if (!res.data) {
							this.$message.warning('上年结转数据不存在');
							return;
						}
						// 拿到上年的数据
						const lastYearDetail = res.data;
						const query = {
							companyId: this.searchForm.companyId,
							beginTime: this.searchForm.startTime,
							endTime: this.searchForm.endTime
						};
						// 查询客户明细账
						this.checkFreightDetail(query, lastYearDetail);
					});
				}
			});
		},
		reset() {
			Object.assign(this.searchForm, {
				startTime: '',
				endTime: '',
				vehicle: '',
				companyId: null
			});
			this.tableData = [];
		},
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '总价';
					return;
				}
				const values = data.map(item => Number(item[column.property]));
				const exclude = ['operateDate', 'payNo', 'lender', 'borrower'];
				if (exclude.includes(column.property)) {
					sums[index] = '';
					return;
				}
				if (!values.every(value => isNaN(value))) {
					sums[index] = values.reduce((prev, curr) => {
						const value = Number(curr);
						if (!isNaN(value)) {
							return prev + curr;
						} else {
							return prev;
						}
					}, 0);
					sums[index] += ' 元';
				} else {
					sums[index] = 'N/A';
				}
			});

			return sums;
		},
		// 点击小记事本查看详情
		handleCheckDetail(row) {
			this.handleSearch(row);
		},
		handleCheckBorrowerDetailList(row) {
			this.detailList = row.borrowerList;
			this.detailVisible = true;
		},
		checkFreightDetail(query, lastYearDetail) {
			// 查询运费明细账
			getFreightSubjectDetailSummary(query)
				.then(res => {
					if (!res.rows) {
						this.$message.warning('未查询到相关数据');
						this.loading = false;
						return;
					}

					// 辅助函数：计算某天数据的借方和贷方总额
					function calculateLenderAndBorrower(dayData) {
						const { itemTotalLender, itemTotalBorrower } = dayData.reduce(
							(acc, customerDetail) => {
								const amount = Number(customerDetail.moneyAmount);
								if (amount > 0) {
									acc.itemTotalLender += amount;
								} else {
									acc.itemTotalBorrower += amount;
								}
								return acc;
							},
							{ itemTotalLender: 0, itemTotalBorrower: 0 } // 初始值
						);
						return [itemTotalLender, itemTotalBorrower];
					}

					if (Array.isArray(res.rows)) {
						if (res.rows.length <= 0) {
							this.$message.warning('未查询到相关数据');
							this.loading = false;
							return;
						}
						try {
							let nowMoney = Number(0);
							// 上年结转的余额 (运费：正数表示对方欠我们运费，负数表示我们欠对方)
							let currentBalance = Number(lastYearDetail.moneyAmount || 0);
							let sourceData = _.cloneDeep(res.rows);

							// 按日期分组
							sourceData = _.groupBy(sourceData, item => {
								return item.operateDate.match(/^(\d{4}-\d{2}-\d{2})/)[1];
							});
							let dayData, itemTotalBorrower, itemTotalLender;
							let map = {};
							for (let date in sourceData) {
								dayData = _.cloneDeep(sourceData[date]);
								[itemTotalLender, itemTotalBorrower] = calculateLenderAndBorrower(dayData);
								map[date] = {
									lender: fix(itemTotalLender),
									borrower: fix(itemTotalBorrower)
								};
							}
							this.tableData = Object.keys(sourceData).map(date => {
								const item = _.cloneDeep(sourceData[date]);
								for (let i = 0; i < item.length; i++) {
									nowMoney += Number(item[i].moneyAmount);
								}
								// 准备当天借方和贷方明细列表 (用于弹窗)
								const condition = detail => {
									const lender = detail.moneyAmount > 0 ? Math.abs(detail.moneyAmountLocal) : 0;
									const borrower = detail.moneyAmount < 0 ? Math.abs(detail.moneyAmountLocal) : 0;
									return {
										date: detail.operateDate,
										payNo: detail.payNo,
										lender: fix(lender),
										borrower: fix(borrower),
										tableName: detail.tableName,
										moneyAmountLocal: fix(detail.moneyAmount)
									};
								};
								// 运费：借方列表是应收运费增加的操作 (moneyAmount > 0)
								const lenderList = item.map(condition).filter(d => Number(d.moneyAmount) > 0);
								// 运费：贷方列表是实收运费或冲减的操作 (moneyAmount < 0)
								const borrowerList = item.map(condition).filter(d => Number(d.moneyAmount) < 0);

								return {
									operateDate: date, // 日期列使用分组的key
									payNo: '', // 主表该列现在显示明细，留空或移除
									lender: map[date].lender,
									borrower: map[date].borrower,
									moneyAmountLocal: fix(Number(currentBalance) + Number(nowMoney)),
									lenderList, // 借方明细列表 (弹窗用)
									borrowerList // 贷方明细列表 (弹窗用)
								};
							});
							console.log(this.tableData);
						} catch (err) {
							console.error('计算运费明细账错误:', err);
							this.$message.error('计算错误，请检查数据或联系管理员');
						} finally {
							this.loading = false;
						}
					} else {
						this.$message.warning('查询结果格式不正确');
						this.loading = false;
					}
				})
				.catch(err => {
					console.error('查询运费明细账失败:', err);
					this.$message.error('查询失败');
					this.loading = false;
				});
		},
		handleSearch(row) {
			// 拿到表名和id
			const { tableName, payNo } = row;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}
			// 根据tableName动态获取某个JS模块
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
				this.$nextTick(() => {
					this.infoVisible = true;
				});
			});
		},
		// 根据对应的表名渲染对应的组件
		getComponents(tableName) {
			const components = {
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				[TableName.PAYMENT]: PAYMENT,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.OFFSETTING]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				[TableName.ORDER_DETAIL]: ORDER_DETAIL,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		},
		updateQueryCars(value) {
			this.queryCars = value;
		},
		handleCommitBackCars(value) {
			this.searchForm.vehicle = value.carNo;
			this.searchForm.companyId = value.id;
		}
	}
};
</script>

<style scoped lang="scss">
.freight-info {
	padding: 15px;

	.search-area {
		margin-bottom: 15px;
		padding: 15px;
		background-color: #fff;
		border-radius: 4px;
	}

	.pagination-container {
		margin-top: 15px;
		display: flex;
		justify-content: flex-end;
	}

	.negative {
		color: red;
	}

	:deep(.el-form-item) {
		margin-bottom: 10px;
		margin-right: 10px;
	}

	:deep(.el-form-item__label) {
		padding-right: 8px;
	}
}
</style>
