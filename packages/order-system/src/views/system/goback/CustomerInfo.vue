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
				<el-form-item label="客户" prop="customer">
					<el-row>
						<el-col :span="20">
							<el-input disabled v-model="searchForm.customer" placeholder="请选择客户" clearable @keyup.enter.native="getList" size="mini">
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
						<el-col :span="4">
							<SearchOption :limit-info="{ companyType: PUBLIC_DICT_TYPE.CUSTOMER }" :get-data="listCompany" query-info="companyName" query-label="公司名称" :query-name="companyName" @update:queryName="handleUpdateCompanyName" @commitBack="handleCommitBackCompany">
								<template #table-columns>
									<el-table-column :label="PUBLIC_DICT_TYPE.CUSTOMER" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="mini">查询</el-button>
					<el-button @click="reset" size="mini">刷新</el-button>
					<el-button type="success" @click="excelExport(['往来明细'])" size="mini">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="mini">
			<el-table-column prop="date" label="日期" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">{{ scope.row.date }}</template>
						<span>{{ scope.row.date }}</span>
					</el-tooltip>
				</template>
			</el-table-column>

			<el-table-column label="客户名称" width="150" prop="customerName" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">{{ scope.row.customerName }}</template>
						<span>{{ scope.row.customerName }}</span>
					</el-tooltip>
				</template>
			</el-table-column>

			<!--      借方列表-->
			<el-table-column label="往来明细" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">
							<div v-for="(item, index) in scope.row.lenderList" :key="index">
								<span style="color: red; margin-right: 6px">[{{ getOrAdvancedModule([item.tableName], item.flag) }}]</span>
								<span style="margin-right: 7px">{{ item.lender }}</span>
								<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(item)"></i>
							</div>
						</template>
						<div>
							<div v-for="(item, index) in scope.row.lenderList" :key="index">
								<span style="color: red; margin-right: 6px">[{{ getOrAdvancedModule([item.tableName], item.flag) }}]</span>
								<span style="margin-right: 7px">{{ item.lender }}</span>
								<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(item)"></i>
							</div>
						</div>
					</el-tooltip>
				</template>
			</el-table-column>

			<!--      借方总款-->
			<el-table-column prop="lender" label="借方（客户欠款增加）" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">
							<span>{{ scope.row.lender }}</span>
						</template>
						<span>{{ scope.row.lender }}</span>
					</el-tooltip>
				</template>
			</el-table-column>

			<!--      贷方总款-->
			<el-table-column prop="borrower" label="贷方（客户欠款减少）" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">
							<span style="margin-right: 10px">{{ scope.row.borrower }}</span>
							<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckBorrowerDetailList(scope.row)"></i>
						</template>
						<div style="display: flex; align-items: center; justify-content: center">
							<span style="margin-right: 5px; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap">{{ scope.row.borrower }}</span>
							<i v-if="scope.row.borrowerList && scope.row.borrowerList.length > 0" class="el-icon-s-order" style="cursor: pointer; flex-shrink: 0; margin-left: 5px" @click.stop="handleCheckBorrowerDetailList(scope.row)"></i>
						</div>
					</el-tooltip>
				</template>
			</el-table-column>

			<!--      余额本币-->
			<el-table-column prop="moneyAmountLocal" label="余额本币" show-overflow-tooltip>
				<template #default="scope">
					<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
						<template slot="content">
							<span :class="{ negative: scope.row.moneyAmountLocal < 0 }">
								{{ formatBalance(scope.row.moneyAmountLocal) }}
							</span>
						</template>
						<span :class="{ negative: scope.row.moneyAmountLocal < 0 }">
							{{ formatBalance(scope.row.moneyAmountLocal) }}
						</span>
					</el-tooltip>
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
				<el-table-column prop="date" label="日期" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">{{ scope.row.date }}</template>
							<span>{{ scope.row.date }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="payNo" label="凭证号" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">{{ scope.row.payNo }}</template>
							<span>{{ scope.row.payNo }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="lender" label="借方(客户欠款增加)" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">{{ scope.row.lender }}</template>
							<span>{{ scope.row.lender }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="borrower" label="贷方(客户欠款减少)" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">{{ scope.row.borrower }}</template>
							<span>{{ scope.row.borrower }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<el-table-column prop="moneyAmountLocal" label="余额本币" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">{{ formatBalance(scope.row.moneyAmountLocal) }}</template>
							<span>{{ formatBalance(scope.row.moneyAmountLocal) }}</span>
						</el-tooltip>
					</template>
				</el-table-column>
				<!--        添加查看列-->
				<el-table-column label="查看明细" show-overflow-tooltip>
					<template #default="scope">
						<el-tooltip effect="light" placement="top" enterable :open-delay="1000">
							<template slot="content">
								<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(scope.row)"></i>
							</template>
							<i class="el-icon-s-order" style="cursor: pointer" @click="handleCheckDetail(scope.row)"></i>
						</el-tooltip>
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
import { getCustomerSubjectDetailSomeDay, getCustomerSubjectDetailSummary } from '@/api/system/statement';
import { fix, fix_2 } from '@/api/tool/format';
import { getFunction } from '@/utils/order/mapper';
import { moduleNames, TableName, getOrAdvancedModule } from '@/api/tool/enums';
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
import BALANCEACCOUNT from '@/components/NeedToShow/BALANCEACCOUNT.vue';
import _ from 'lodash';
import { formatBalance, isDebit, isCredit } from '@/utils/trash/utils';
import { isGoodsOrderDisplay, isInventoryDisplay, mergeSpecialTableData } from '@/api/system/goodsOrder';
import OrderDayInfo from '@/components/OrderDayInfor/index.vue';
import InventoryDayInfo from '@/components/InventoryDayInfo/index.vue';
import { abs, add, subtract, number } from 'mathjs';

export default {
	name: 'CustomerInfo',
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
				customer: '',
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
				customer: [{ required: true, message: '请选择客户', trigger: 'blur' }]
			},
			detailLoading: false,
			detailList: [],
			detailVisible: false
		};
	},
	created() {
		// 选择了客户再搜索
		if (this.searchForm.customer && this.searchForm.companyId) {
			this.getList();
		}
	},
	methods: {
		formatBalance,
		fix,
		listCompany,
		abs,
		add,
		subtract,
		number,
		getOrAdvancedModule,
		// 查询方法
		getList() {
			this.$refs['form']?.validate(valid => {
				if (valid) {
					this.loading = true;
					const body = {
						beginTime: this.searchForm.startTime,
						companyId: this.searchForm.companyId
					};
					// 查询客户指定时间结转
					getCustomerSubjectDetailSomeDay(body).then(res => {
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
						this.checkCustomerDetail(query, lastYearDetail);
					});
				}
			});
		},
		reset() {
			Object.assign(this.searchForm, {
				startTime: '',
				endTime: '',
				customer: '',
				companyId: null
			});
		},
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '总价';
					return;
				}
				const values = data.map(item => number(item[column.property]));
				const exclude = ['operateDate', 'payNo', 'lender', 'borrower'];
				if (exclude.includes(column.property)) {
					sums[index] = '';
					return;
				}
				if (!values.every(value => isNaN(value))) {
					sums[index] = values.reduce((prev, curr) => {
						const value = number(curr);
						if (!isNaN(value)) {
							return add(prev, curr);
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
		checkCustomerDetail(query, lastYearDetail) {
			// 查询客户明细账
			getCustomerSubjectDetailSummary(query).then(res => {
				if (!res.data) {
					this.$message.warning('未查询到相关数据');
					this.loading = false;
					return;
				}

				const calculateLenderAndBorrower = dayData => {
					const { itemTotalLender, itemTotalBorrower } = dayData.reduce(
						(acc, customerDetail) => {
							const amount = number(customerDetail.moneyAmount || 0);
							if (isDebit(customerDetail.debitCredit)) {
								// 借方：客户欠款增加
								acc.itemTotalLender = add(acc.itemTotalLender, amount);
							} else if (isCredit(customerDetail.debitCredit)) {
								// 贷方：客户欠款减少
								acc.itemTotalBorrower = add(acc.itemTotalBorrower, -amount);
							}
							return acc;
						},
						{ itemTotalLender: 0, itemTotalBorrower: 0 } // 初始值
					);
					// 需要取反
					return [itemTotalLender, itemTotalBorrower];
				};

				if (Array.isArray(res.data)) {
					if (res.data.length <= 0) {
						this.$message.warning('未查询到相关数据');
						this.loading = false;
						return;
					}
					try {
						let nowMoney = number(0);
						let currentBalance = number(lastYearDetail.moneyAmount || 0);
						let sourceData = _.cloneDeep(res.data);

						// 对订单和库存数据进行合并预处理
						sourceData = mergeSpecialTableData(sourceData);
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
						// 维护表格数据
						this.tableData = Object.keys(sourceData).map(date => {
							const item = _.cloneDeep(sourceData[date]);
							if (Array.isArray(item)) {
								for (let i = 0; i < item.length; i++) {
									// 这里不取绝对值 要根据页面决定哪一列取相反数
									const amount = number(item[i].moneyAmount || 0);
									// 根据 debitCredit 判断金额的正负影响
									// 如果是客户 并且是借方
									if (isDebit(item[i].debitCredit)) {
										nowMoney = add(nowMoney, amount); // 借方：增加欠款

										// 这个地方后端对于数据进行了取反操作，根据判断是贷方，将金额（MoneyAmount）给正常取反就行。
									} else if (isCredit(item[i].debitCredit)) {
										nowMoney = subtract(nowMoney, -amount); // 贷方：减少欠款
									}
								}
								const condition = detail => {
									const amount = number(detail.moneyAmount || 0);
									const lender = amount;
									const borrower = -amount;
									return {
										date: date,
										payNo: detail.payNo,
										lender: fix(lender),
										borrower: fix(borrower),
										tableName: detail.tableName,
										debitCredit: detail.debitCredit,
										moneyAmountLocal: fix_2(amount),
										companyId: detail.companyId,
										flag: detail.flag,
										summary: Array.isArray(detail.summary) ? detail.summary.join('、') : detail.summary
									};
								};
								const lenderList = item.map(condition).filter(detail => isDebit(detail.debitCredit));
								const borrowerList = item.map(condition).filter(detail => isCredit(detail.debitCredit));
								return {
									customerName: map[date]?.companyName,
									date: date,
									lender: map[date].lender,
									borrower: map[date].borrower,
									moneyAmountLocal: fix_2(add(currentBalance, nowMoney)),
									lenderList,
									borrowerList
								};
							}
						});
					} catch (err) {
						this.$message.error('计算错误:', err);
					}
					this.loading = false;
				}
			});
		},
		// 点击小记事本查看详情
		handleCheckDetail(row) {
			this.handleSearch(row);
		},
		// 贷方查看明细的弹窗
		handleCheckBorrowerDetailList(row) {
			this.detailList = row.borrowerList;
			this.detailVisible = true;
		},
		handleSearch(row) {
			// 拿到表名和id
			const { tableName, payNo, companyId } = row;
			if (!tableName || !payNo) {
				this.$message.warning('该行数据有误:模块名或者凭证号不存在');
				return;
			}

			// 这里因为订单和库存需要特殊展示 额外判断
			if (isGoodsOrderDisplay(tableName)) {
				// 订单模块：将payNo数组传递给弹窗
				this.openDialog(
					OrderDayInfo,
					'订单信息',
					'1500px',
					{
						ids: payNo,
						isDetail: false,
						companyId: companyId,
						companyType: PUBLIC_DICT_TYPE.CUSTOMER
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
						isDetail: false,
						companyId: this.searchForm.companyId,
						companyType: PUBLIC_DICT_TYPE.CUSTOMER
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
			if (tableName == null) {
				return PAYMENT;
			}
			const components = {
				[TableName.GOODS_ORDER]: GOODS_ORDER,
				// 付款
				[TableName.PAYMENT]: PAYMENT,
				// 付款
				[TableName.RECEIVE_MONEY]: RECEIVE_MONEY,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.CASH_RECORD]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
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
			this.searchForm.customer = value.companyName;
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
