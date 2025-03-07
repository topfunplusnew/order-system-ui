<!--供应商科目明细表-->

<script>
import { getSupplierSubjectDetailSomeDay, getSupplierSubjectDetailSummary } from '@/api/system/statement';
import { TableName } from '@/api/tool/enums';
import GOODS_ORDER from '@/components/NeedToShow/GOODS_ORDER.vue';
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
import BANK_ACCEPTANCE from '@/components/NeedToShow/BANK_ACCEPTANCE.vue';
import INVENTORYDETAILVue from '../../../../components/NeedToShow/INVENTORYDETAIL.vue';
import ORDER_FREIGHTVue from '../../../../components/NeedToShow/ORDER_FREIGHT.vue';
import RECEIVE_MONEY from '@/components/NeedToShow/RECEIVE_MONEY.vue';
import BALANCEACCOUNT from '@/components/NeedToShow/BALANCEACCOUNT.vue';
import SearchOption from '@/components/SearchOption.vue';
import { parseTime } from '@/utils/ruoyi';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { listCompany } from '@/api/system/company';

export default {
	name: 'SupplierDetail',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		}
	},
	components: { SearchOption, TotalTag },
	data() {
		return {
			searchForm: {
				customer: null,
				companyId: ''
			},
			companyName: null,
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

	methods: {
		listCompany,
		handleCheck() {
			// 清除一下状态
			this.tableData = [];
			// 打开时间选择框
			this.$datePicker().then(res => {
				// 组装查询条件 分别为开始时间 结束时间 供应商id
				const query = {
					companyId: this.searchForm.companyId,
					beginTime: res.beginTime,
					endTime: res.endTime
				};
				// 查询科目信息
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
						beginTime: query.beginTime,
						companyId: query.companyId
					};
					// 获取供应商结转
					getSupplierSubjectDetailSomeDay(body).then(res => {
						// 校验
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
							moneyAmountLocal: lastYearDetail.moneyAmount,
							subjectNo: configValue,
							subjectName: subjectName
						});
						// 参数 包含配置值 和 科目名称
						const config = {
							configValue,
							subjectName
						};
						// 查询明细账
						this.checkSupplierDetail(query, lastYearDetail, config);
					});
				});
			});
		},
		/**
		 * 查询供应商明细账
		 * @param {any} query
		 * @param {any} lastYearDetail
		 * @param {any} config
		 * @returns {any}
		 */
		checkSupplierDetail(query, lastYearDetail, config) {
			// 查询供应商明细账
			getSupplierSubjectDetailSummary(query).then(res => {
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
								summary: ReportType.SUPPLIER[item.tableName],
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
					this.$message.error(err);
					return;
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
			getFunction(tableName)(payNo).then(res => {
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
				// 发票买入
				[TableName.INVOICE_IN]: INVOICE_IN,
				// 发票卖出
				[TableName.INVOICE_OUT]: INVOICE_OUT,
				// 第三方发票
				[TableName.INVOICE_OTHER]: INVOICE_ORTHER,
				// 冲抵货款
				[TableName.OFFSETTING]: OFFSETTING,
				// 返利
				[TableName.REBATE]: REBATE,
				// 货款
				[TableName.INVENTORDETAIL]: INVENTORYDETAILVue,
				// 货物
				[TableName.ORDER_DETAIL]: ORDER_DETAIL,
				// 需要前端在这两个明细表上进行适配bankacceptance
				[TableName.BANK_ACCOUNT_CHANGE]: BANK_ACCEPTANCE,
				[TableName.ORDER_FREIGHT]: ORDER_FREIGHTVue,
				// 平账
				[TableName.BALANCEACCOUNT]: BALANCEACCOUNT
			};
			// 默认返回 null，如果没有匹配的 tableName
			return components[tableName] || null;
		}
	}
};
</script>

<template>
	<div class="app-container">
		<el-form :inline="true" :model="searchForm" class="demo-form-inline" size="mini">
			<el-form-item label="供应商" prop="customer">
				<el-row>
					<el-col :span="4">
						<SearchOption
							:limit-info="{ companyType: PUBLIC_DICT_TYPE.SUPPLIER }"
							:get-data="listCompany"
							query-info="companyName"
							query-label="公司名称"
							:query-name="companyName"
							@update:queryName="value => (companyName = value)"
							@commitBack="
								value => {
									searchForm.companyId = value.id;
									searchForm.customer = value.companyName;
								}
							"
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
						<el-input disabled clearable v-model="searchForm.customer" placeholder="请选择供应商" size="mini">
							<i slot="prefix" class="el-input__icon el-icon-search"></i>
						</el-input>
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleCheck">搜索</el-button>
			</el-form-item>
		</el-form>

		<!--      供应商的结转数据-->
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
				<el-table-column show-overflow-tooltip label="供应商编号" align="center" prop="companyId" width="140" />
				<el-table-column show-overflow-tooltip label="供应商名称" align="center" prop="companyName" width="140" />
				<el-table-column show-overflow-tooltip label="供应商银行户名（对方真实收付款名称）" align="center" prop="otherAccountsName" width="140" />
				<el-table-column show-overflow-tooltip label="供应商银行卡号" align="center" prop="otherBankNo" width="140" />

				<el-table-column show-overflow-tooltip label="摘要" align="center" prop="summary" width="140" />

				<!--        这两列应该是根据moneyAmount字段的正负进行判断-->
				<el-table-column show-overflow-tooltip label="借方发生额(付供应商货款)" align="center" width="140">
					<template slot-scope="scope">
						{{ scope.row.moneyAmount > 0 ? scope.row.moneyAmount : '-' }}
					</template>
				</el-table-column>
				<el-table-column show-overflow-tooltip label="贷方(在供应商那里提货)" align="center" width="140">
					<template slot-scope="scope">
						{{ scope.row.moneyAmount > 0 ? '-' : Math.abs(scope.row.moneyAmount) }}
					</template>
				</el-table-column>

				<!--        方向根据余额本币的正负进行判断 这个要先查询上年结转的余额本币 进行填充-->
				<el-table-column show-overflow-tooltip label="方向" align="center" width="140">
					<template slot-scope="scope">
						{{ scope.row.moneyAmountLocal > 0 ? '借方' : '贷方' }}
					</template>
				</el-table-column>

				<el-table-column show-overflow-tooltip label="余额本币" align="center" prop="moneyAmountLocal" width="140" />
				<el-table-column show-overflow-tooltip label="我方收款户名" align="center" prop="selfAccountsName" width="140" />
				<el-table-column show-overflow-tooltip label="我方银行账号" align="center" prop="selfBankNo" width="140" />
				<el-table-column show-overflow-tooltip label="我方开户行地址" align="center" prop="selfBankName" width="140" />
			</el-table>
		</el-card>

		<!--    对应信息的弹窗-->
		<el-dialog title="信息" :visible.sync="infoVisible" width="900px" append-to-body>
			<component :is="Components" :need-to-show-info="needToShowInfo" />
		</el-dialog>
	</div>
</template>

<style scoped lang="scss"></style>
