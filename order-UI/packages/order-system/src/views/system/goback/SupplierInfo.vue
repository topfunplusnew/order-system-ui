<template>
	<div class="customer-info">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form id="top-search-form-item" :inline="true" :model="searchForm" ref="form" :rules="rules" class="demo-form-inline" size="mini" label-width="150">
				<el-form-item label="开始时间：" prop="startTime">
					<el-date-picker v-model="searchForm.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间：" prop="endTime">
					<el-date-picker v-model="searchForm.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" size="mini"></el-date-picker>
				</el-form-item>
				<el-form-item label="供应商" prop="supplier">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ companyType: PUBLIC_DICT_TYPE.SUPPLIER }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="PUBLIC_DICT_TYPE.SUPPLIER" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input disabled v-model="searchForm.supplier" placeholder="请选择供应商" clearable size="mini">
								<el-button @click="reset" size="mini">刷新</el-button>
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="mini">查询</el-button>
					<el-button type="success" @click="excelExport(['往来明细'])" size="mini">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
			<el-table-column prop="operateDate" label="日期"></el-table-column>
			<el-table-column label="供应商名称" width="150" prop="supplierName"></el-table-column>
			<el-table-column label="往来明细">
				<template slot-scope="scope">
					<div v-for="(item, index) in scope.row.lenderList" :key="index">
						<span style="color: red; margin-right: 6px">[{{ moduleNames[item.tableName] }}]</span>
						<span style="margin-right: 7px">{{ item.lender }}</span>
						<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(item)"></i>
					</div>
				</template>
			</el-table-column>
			<el-table-column prop="lender" label="借方(供应商欠款减少)">
				<template slot-scope="scope">
					<span>
						{{ Math.abs(scope.row.lender) }}
					</span>
				</template>
			</el-table-column>
			<el-table-column prop="borrower" label="贷方(供应商欠款增加)">
				<template slot-scope="scope">
					<span style="margin-right: 10px">{{ Math.abs(scope.row.borrower) }}</span>
					<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckBorrowerDetailList(scope.row)"></i>
				</template>
			</el-table-column>
			<el-table-column prop="moneyAmountLocal" label="余额本币">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.moneyAmountLocal < 0 }">
						{{ formatSupplierBalance(scope.row.moneyAmountLocal) }}
					</span>
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
			<el-table :data="detailList" border style="width: 100%" v-loading="loading" size="mini" :summary-method="getSummaries" show-summary>
				<el-table-column prop="operateDate" label="日期"></el-table-column>
				<el-table-column prop="payNo" label="凭证号"></el-table-column>
				<el-table-column prop="lender" label="借方(供应商欠款减少)"></el-table-column>
				<el-table-column prop="borrower" label="贷方(供应商欠款增加)"></el-table-column>
				<el-table-column prop="moneyAmountLocal" label="余额本币"></el-table-column>
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
import SearchOption from '@/components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { listCompany } from '@/api/system/company';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { getSupplierSubjectDetailSomeDay, getSupplierSubjectDetailSummary } from '@/api/system/statement';
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
import BANK_ACCEPTANCE from '@/components/NeedToShow/BANK_ACCEPTANCE.vue';
import ORDER_FREIGHTVue from '@/components/NeedToShow/ORDER_FREIGHT.vue';
import RECEIVE_MONEY from '@/components/NeedToShow/RECEIVE_MONEY.vue';
import INVENTORYDETAIL from '@/components/NeedToShow/INVENTORYDETAIL.vue';
import ORDER_DETAIL from '@/components/NeedToShow/ORDER_DETAIL.vue';
import BALANCEACCOUNT from '@/components/NeedToShow/BALANCEACCOUNT.vue';
import { formatSupplierBalance, isDebit, isCredit } from '@/utils/trash/utils';
import _ from 'lodash';
import { isGoodsOrderDisplay, isInventoryDisplay, mergeSpecialTableData } from '@/api/system/goodsOrder';
import InventoryDayInfo from '@/components/InventoryDayInfo/index.vue';
import OrderDayInfor from '@/components/OrderDayInfor/index.vue';

export default {
	name: 'SupplierInfo',
	computed: {
		moduleNames() {
			return moduleNames;
		},
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { SearchOption },
	mixins: [common_excel],
	data() {
		return {
			loading: false,
			currentPage: 1,
			pageSize: 20,
			total: 0,
			searchForm: {
				startTime: '',
				endTime: '',
				supplier: '',
				companyId: null
			},
			companyName: null,
			tableData: [],
			needToShowInfo: null,
			infoVisible: null,
			Components: null,
			rules: {
				startTime: [{ required: true, message: '请选择开始时间', trigger: 'blur' }],
				endTime: [{ required: true, message: '请选择结束时间', trigger: 'blur' }],
				supplier: [{ required: true, message: '请选择供应商', trigger: 'blur' }]
			},
			detailLoading: false,
			detailList: [],
			detailVisible: false
		};
	},
	created() {
		// 选择了供应商再搜索
		if (this.searchForm.supplier && this.searchForm.companyId) {
			this.getList();
		}
	},
	methods: {
		formatSupplierBalance,
		fix,
		listCompany,
		// 查询方法
		getList() {
			this.$refs['form']?.validate(valid => {
				if (valid) {
					this.loading = true;
					const body = {
						beginTime: this.searchForm.startTime,
						companyId: this.searchForm.companyId
					};
					// 查询供应商指定时间结转
					getSupplierSubjectDetailSomeDay(body).then(res => {
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
						// 查询供应商明细账
						this.checkSupplierDetail(query, lastYearDetail);
					});
				}
			});
		},
		reset() {
			Object.assign(this.searchForm, {
				startTime: '',
				endTime: '',
				supplier: '',
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
					sums[index] = '';
				}
			});

			return sums;
		}, // 贷方查看明细的弹窗
		handleCheckBorrowerDetailList(row) {
			this.detailList = row.borrowerList;
			this.detailVisible = true;
		},
		checkSupplierDetail(query, lastYearDetail) {
			// 查询供应商明细账
			getSupplierSubjectDetailSummary(query)
				.then(res => {
					if (!res.data) {
						this.$message.warning('未查询到相关数据');
						this.loading = false;
						return;
					}

					// 辅助函数：计算某天数据的借方和贷方总额
					function calculateLenderAndBorrower(dayData) {
						const { itemTotalLender, itemTotalBorrower } = dayData.reduce(
							(acc, customerDetail) => {
								const amount = Number(customerDetail.moneyAmount || 0);
								if (isDebit(customerDetail.debitCredit)) {
									// 借方：供应商欠款减少
									acc.itemTotalLender += amount;
								} else if (isCredit(customerDetail.debitCredit)) {
									// 贷方：供应商欠款增加
									acc.itemTotalBorrower += amount;
								}
								return acc;
							},
							{ itemTotalLender: 0, itemTotalBorrower: 0 } // 初始值
						);
						return [itemTotalLender, itemTotalBorrower];
					}

					if (Array.isArray(res.data)) {
						if (res.data.length <= 0) {
							this.$message.warning('未查询到相关数据');
							this.loading = false;
							return;
						}
						try {
							let nowMoney = Number(0);
							// 上年结转的余额 (供应商：正数表示我们欠供应商，负数表示供应商欠我们)
							let currentBalance = Number(lastYearDetail.moneyAmount || 0);
							let sourceData = _.cloneDeep(res.data);

							// 对订单和库存数据进行合并预处理
							sourceData = mergeSpecialTableData(sourceData);

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
									const amount = Number(item[i].moneyAmount || 0);
									// 根据 debitCredit 判断金额的正负影响
									if (isDebit(item[i].debitCredit)) {
										nowMoney -= amount; // 借方：减少欠款
									} else if (isCredit(item[i].debitCredit)) {
										nowMoney += amount; // 贷方：增加欠款
									}
								}
								// 准备当天借方和贷方明细列表 (用于弹窗)
								const condition = detail => {
									const amount = Number(detail.moneyAmount || 0);
									const lender = isDebit(detail.debitCredit) ? Math.abs(amount) : 0;
									const borrower = isCredit(detail.debitCredit) ? Math.abs(amount) : 0;

									return {
										date: detail.operateDate,
										payNo: detail.payNo,
										lender: fix(lender),
										borrower: fix(borrower),
										tableName: detail.tableName,
										debitCredit: detail.debitCredit,
										moneyAmountLocal: fix(amount),
										summary: Array.isArray(detail.summary) ? detail.summary.join('、') : detail.summary
									};
								};
								const lenderList = item.map(condition).filter(detail => isDebit(detail.debitCredit));
								const borrowerList = item.map(condition).filter(detail => isCredit(detail.debitCredit));

								return {
									supplierName: _.cloneDeep(this.searchForm.supplier),
									operateDate: date, // 日期列使用分组的key
									payNo: '', // 主表该列现在显示明细，留空或移除
									lender: map[date].lender,
									borrower: map[date].borrower,
									moneyAmountLocal: fix(Number(currentBalance) + Number(nowMoney)),
									lenderList, // 借方明细列表 (弹窗用)
									borrowerList // 贷方明细列表 (弹窗用)
								};
							});
						} catch (err) {
							console.error('计算供应商明细账错误:', err);
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
					console.error('查询供应商明细账失败:', err);
					this.$message.error('查询失败');
					this.loading = false;
				});
		},
		handleCheckDetail(row) {
			this.handleSearch(row);
		},
		handleSearch(row) {
			// 拿到表名和id
			const { tableName, payNo } = row;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}
			// 这里因为订单和库存需要特殊展示 额外判断
			if (isGoodsOrderDisplay(tableName)) {
				// 订单模块：将payNo数组传递给弹窗
				this.openDialog(
					OrderDayInfor,
					'订单信息',
					'1500px',
					{
						ids: payNo,
						isDetail: true,
						companyId: this.searchForm.companyId,
						companyType: PUBLIC_DICT_TYPE.SUPPLIER
					},
					false
				);
				return;
			}
			if (isInventoryDisplay(tableName)) {
				// 库存模块：将payNo数组传递给弹窗
				this.openDialog(
					InventoryDayInfo,
					'库存信息',
					'1500px',
					{
						ids: payNo,
						isDetail: true,
						companyId: this.searchForm.companyId,
						companyType: PUBLIC_DICT_TYPE.SUPPLIER
					},
					false
				);
				return;
			}
			// 其他模块：取数组的第一个元素作为单个ID
			const singlePayNo = Array.isArray(payNo) ? payNo[0] : payNo;

			// 根据tableName动态获取某个JS模块
			getFunction(tableName)(singlePayNo).then(res => {
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
				// 订单
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				// 货物 TODO 这里等后端接口完善之后再做 如果是订单明细 用id去查主表
				[TableName.ORDER_DETAIL]: GOODS_ORDER,
				// 付款
				[TableName.PAYMENT]: PAYMENT,
				// 收款
				[TableName.RECEIVE_MONEY]: RECEIVE_MONEY,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.CASH_RECORD]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORDETAIL]: INVENTORYDETAIL,
				// 需要前端在这两个明细表上进行适配bankacceptance
				[TableName.BANK_ACCOUNT_CHANGE]: BANK_ACCEPTANCE,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue,
				[TableName.BANK_ACCEPTANCE]: BANK_ACCEPTANCE,
				// 平账
				[TableName.BALANCEACCOUNT]: BALANCEACCOUNT
			};
			return components[tableName] || null; // 默认返回 null，如果没有匹配的 tableName
		},
		handleUpdateCompanyName(value) {
			this.companyName = value;
		},
		handleCommitBackCompany(value) {
			this.searchForm.supplier = value.companyName;
			this.searchForm.companyId = value.id;
		}
	}
};
</script>

<style scoped lang="scss">
.customer-info {
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
