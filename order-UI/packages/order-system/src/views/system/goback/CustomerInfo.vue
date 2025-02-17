<template>
	<div class="customer-info">
		<!-- 搜索区域 -->
		<div class="search-area">
			<el-form :inline="true" :model="searchForm" class="demo-form-inline" size="small">
				<el-form-item label="开始时间：">
					<el-date-picker v-model="searchForm.startTime" type="date" placeholder="请选择开始时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="结束时间：">
					<el-date-picker v-model="searchForm.endTime" type="date" placeholder="请选择结束时间" value-format="yyyy-MM-dd" size="small"></el-date-picker>
				</el-form-item>
				<el-form-item label="客户">
					<el-row>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ companyType: PUBLIC_DICT_TYPE.CUSTOMER }"
								:get-data="listCompany"
								query-info="companyName"
								query-label="公司名称"
								:query-name="companyName"
								@update:queryName="handleUpdateCompanyName"
								@commitBack="handleCommitBackCompany"
							>
								<template #table-columns>
									<el-table-column :label="PUBLIC_DICT_TYPE.CUSTOMER" align="center" prop="companyName" />
									<el-table-column label="老板姓名" align="center" prop="leader" />
									<el-table-column label="老板电话" align="center" prop="leaderTel" />
									<el-table-column label="区域" align="center" prop="region" />
									<el-table-column label="销售经理" align="center" prop="salesManager" />
								</template>
							</SearchOption>
						</el-col>
						<el-col :span="20">
							<el-input v-model="searchForm.customer" placeholder="请输入客户" clearable size="small">
								<i slot="prefix" class="el-input__icon el-icon-search"></i>
							</el-input>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="getList" size="small">查询</el-button>
					<el-button type="success" @click="excelExport" size="small">导出Excel</el-button>
				</el-form-item>
			</el-form>
		</div>

		<!-- 表格区域 -->
		<el-table id="educe-table" :data="tableData" border style="width: 100%" v-loading="loading" size="small">
			<el-table-column prop="operateDate" label="日期"></el-table-column>
			<el-table-column prop="payNo" label="欠款明细">
				<template slot-scope="scope">
					<el-button v-if="scope.row.payNo" type="text" size="mini" @click="handleSearch(scope.row)">点击查询对应信息</el-button>
				</template>
			</el-table-column>
			<el-table-column prop="lender" label="借方(客户提货+买票点)"></el-table-column>
			<el-table-column prop="borrower" label="贷方(收客户款)"></el-table-column>
			<el-table-column prop="moneyAmountLocal" label="余额本币">
				<template slot-scope="scope">
					<span :class="{ negative: scope.row.moneyAmountLocal < 0 }">{{ scope.row.moneyAmountLocal }}</span>
				</template>
			</el-table-column>
		</el-table>

		<!-- 分页 -->
		<div class="pagination-container">
			<pagination v-show="total > 0" :total="total" :current-page.sync="searchForm.pageNum" :page-size.sync="searchForm.pageSize" @pagination="getList" />
		</div>

		<el-dialog title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<script>
import SearchOption from '@/components/SearchOption.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { listCompany } from '@/api/system/company';
import { common_excel } from '@/views/dashboard/mixins/common/common_excel';
import { getConfigValue } from '@/views/system/Statement/data/config_get';
import { getCustomerSubjectDetailSomeDay, getCustomerSubjectDetailSummary } from '@/api/system/statement';
import { fix } from '@/api/tool/format';
import { getFunction } from '@/utils/order/mapper';
import { TableName } from '@/api/tool/enums';
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

export default {
	name: 'CustomerInfo',
	computed: {
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
			pageSize: 10,
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
			Components: null
		};
	},
	created() {
		// 选择了客户再搜索
		if (this.searchForm.customer && this.searchForm.companyId) {
			this.getList();
		}
	},
	methods: {
		listCompany,
		// 查询方法
		getList() {
			this.loading = true;
			// 获取参数
			const key = {
				configKey: 'order.customerDetailSummary.subjectNo'
			};
			getConfigValue(key).then(({ configValue, subjectName }) => {
				if (!configValue || !subjectName) {
					this.$message.warning('配置信息查询有误');
					return;
				}
				// 查询明细账之前 要先查询上年结转的余额本币填充
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
					// 参数 包含配置值 和 科目名称
					const config = {
						configValue,
						subjectName
					};
					const query = {
						companyId: this.searchForm.companyId,
						beginTime: this.searchForm.startTime,
						endTime: this.searchForm.endTime
					};
					// 查询客户明细账
					this.checkCustomerDetail(query, lastYearDetail, config);
				});
			});
		},
		checkCustomerDetail(query, lastYearDetail, config) {
			// 查询客户明细账
			getCustomerSubjectDetailSummary(query).then(res => {
				if (!res.rows && !res.data) {
					this.$message.warning('未查询到相关数据');
					return;
				}
				try {
					// 上年结转的余额
					let lastMoney = Number(lastYearDetail.moneyAmount);
					// 累计金额
					let nowMoney = Number(0);
					// 拿到汇总账
					const append = res.data.map(item => {
						// 金额累计计算
						nowMoney = lastMoney + Number(item.moneyAmount);
						// 更新
						lastMoney = nowMoney;
						return {
							operateDate: item.operateDate,
							payNo: item.payNo,
							lender: fix(item.moneyAmount) > 0 ? fix(item.moneyAmount) : 0,
							borrower: fix(item.moneyAmount) < 0 ? fix(item.moneyAmount) : 0,
							moneyAmountLocal: fix(nowMoney),
							// 模块名
							tableName: item.tableName
						};
					});
					// 添加到上年结转数据的后面
					this.tableData = this.tableData.concat(append);
					this.loading = false;
				} catch (err) {
					this.$message.error('计算错误:', err);
				}
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
				// 付款
				[TableName.PAYMENT]: PAYMENT,
				// 付款
				[TableName.RECEIVE_MONEY]: RECEIVE_MONEY,
				[TableName.INVOICE_IN]: INVOICE_IN,
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				[TableName.OFFSETTING]: OFFSETTING,
				[TableName.REBATE]: REBATE,
				[TableName.INVENTORMAIN]: INVENTORY,
				// 需要前端在这两个明细表上进行适配bankacceptance
				[TableName.BANK_ACCOUNT_CHANGE]: BANK_ACCEPTANCE,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue
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
