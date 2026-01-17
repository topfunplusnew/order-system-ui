<template>
	<div class="app-container">
		<el-form id="top-search-form-item" v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="150px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="dateRange" style="width: 240px" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
				<el-button type="danger" size="mini" @click="handleAdd">新增借入款信息</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:borrowedmoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="borrowedMoneyList"
			show-summary
			:summary-method="getSummaries"
			size="mini"
			:cell-style="
				() => {
					return { padding: '.5px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column v-if="columns[0].visible" label="id" align="center" prop="id" show-overflow-tooltip />
			<el-table-column v-if="columns[1].visible" label="贷款来源" align="center" prop="origin" show-overflow-tooltip />
			<el-table-column v-if="columns[2].visible" label="借入金额" align="center" prop="moneyAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[3].visible" label="贷款利率" align="center" prop="ratio" show-overflow-tooltip />
			<el-table-column v-if="columns[4].visible" label="贷款发放日期" align="center" prop="loanDate" show-overflow-tooltip />
			<el-table-column v-if="columns[5].visible" label="贷款年限" align="center" prop="loanDuring" show-overflow-tooltip />
			<el-table-column v-if="columns[6].visible" label="抵押担保" align="center" prop="mortgageGuarantee" show-overflow-tooltip />
			<el-table-column v-if="columns[7].visible" label="打入账户" align="center" prop="acountsName" show-overflow-tooltip />
			<el-table-column v-if="columns[8].visible" label="打入账号" align="center" prop="bankNo" show-overflow-tooltip />
			<el-table-column v-if="columns[9] && columns[9].visible" label="已还款金额" align="center" prop="repaidAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[10] && columns[10].visible" label="未还款金额" align="center" prop="unrepaidAmount" show-overflow-tooltip />
			<el-table-column v-if="columns[11] && columns[11].visible" label="已还款利息" align="center" prop="repaidInterest" show-overflow-tooltip />
			<el-table-column label="备注" align="center" prop="comments" show-overflow-tooltip />
			<el-table-column label="复核状态" align="center" class-name="small-padding fixed-width" width="80" fixed="right">
				<template slot-scope="scope">
					<el-tooltip :content="hasAuditPermission ? '点击切换复核状态' : '您没有复核权限'" placement="top">
						<el-switch v-model="scope.row.auditState" :disabled="!hasAuditPermission" :active-value="'1'" :inactive-value="'0'" active-color="#13ce66" inactive-color="#ff4949" @change="value => hasAuditPermission && handleBorrowedMoneyAudit(scope.row, value)" />
					</el-tooltip>
				</template>
			</el-table-column>
			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="200px" fixed="right">
				<template slot-scope="scope">
					<el-button size="mini" type="text" @click="checkDetail(scope.row)">查看历史还款</el-button>
					<el-button v-if="scope.row.isEnd !== '0'" size="mini" type="warning" @click="handleGiveBackMoney(scope.row)">还款</el-button>
					<el-button v-if="scope.row.isEnd === '1'" size="mini" type="success" @click="handleGiveEnoughBackMoney(scope.row)">已还款</el-button>
					<el-button v-hasPermi="['system:borrowedmoney:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">编辑</el-button>
					<el-button v-hasPermi="['system:borrowedmoney:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改从外部借款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="60%" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="150px">
				<!-- 借入款编码（只读，仅编辑时展示） -->
				<el-form-item v-if="form && form.id != null" label="借入款编码">
					<el-input v-model="form.code" disabled />
				</el-form-item>
				<el-row>
					<el-col :span="12">
						<el-form-item label="贷款来源" prop="origin">
							<el-input v-model="form.origin" placeholder="请输入贷款来源" />
						</el-form-item>
						<el-form-item label="借入金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入借入金额" />
						</el-form-item>
						<el-form-item label="贷款利率" prop="ratio">
							<el-input v-model="form.ratio" placeholder="请输入贷款利率" />
						</el-form-item>
						<el-form-item label="贷款发放日期" prop="loanDate">
							<el-date-picker v-model="form.loanDate" type="datetime" placeholder="请选择贷款发放日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="贷款年限" prop="loanDuring">
							<el-input v-model="form.loanDuring" placeholder="请输入贷款年限" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="抵押担保" prop="mortgageGuarantee">
							<el-input v-model="form.mortgageGuarantee" placeholder="请输入抵押担保" />
						</el-form-item>
						<!-- <el-form-item label="我方银行账户类型">
              <BankType
                :select-type="form.selfBankCardType"
                @updateSelectedType="changeSelfBankType"
              />
            </el-form-item> -->
						<el-form-item label="打入账户" prop="acountsName">
							<el-row>
								<el-col :span="20">
									<el-input disabled v-model="form.acountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="4">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType: '己方公司'
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBackBankAcountForm"
										@update:queryName="handleUpdateQueryBankAcountForm"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="己方公司" align="center" prop="displayName" />
											<el-table-column label="银行户名" align="center" prop="acountsName" />
											<el-table-column label="银行账号" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="打入账号" prop="bankNo">
							<el-input disabled v-model="form.bankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    点击还款的弹框-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="还款操作" :visible.sync="giveBackMoneyShow" width="500px">
			<el-row>
				<el-form ref="form" :model="moneyBackInfo" label-width="140px" :rules="borrowedMoneyRules">
					<el-form-item label="还款金额" prop="moneyAmount">
						<el-input v-model="moneyBackInfo.moneyAmount" placeholder="请输入还款金额" />
					</el-form-item>
					<el-form-item label="付息金额" prop="ratio">
						<el-input v-model="moneyBackInfo.ratio" placeholder="请输入付息金额" />
					</el-form-item>
					<el-form-item label="支付日期" prop="payDate">
						<el-date-picker v-model="moneyBackInfo.payDate" type="datetime" placeholder="选择支付日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
					</el-form-item>
					<el-form-item label="银行户名" prop="acountsName">
						<el-row>
							<el-col :span="10">
								<el-input disabled v-model="moneyBackInfo.acountsName" placeholder="请选择" />
							</el-col>
							<el-col :span="3">
								<SearchOption :get-data="listBankAccount" icon="el-icon-search" :limit-info="{ acountsType: '己方公司' }" query-label="户名查找" query-info="acountsName" :query-name="queryBank" @commitBack="handleCommitBackBankAcount" @update:queryName="handleUpdateQueryBankAcount">
									<template #table-columns>
										<el-table-column label="己方公司" align="center" prop="displayName" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="银行账号" prop="bankNo">
						<el-input disabled v-model="moneyBackInfo.bankNo" placeholder="请选择" />
					</el-form-item>
					<el-form-item label="备注" prop="comments">
						<el-input v-model="moneyBackInfo.comments" placeholder="请输入备注" />
					</el-form-item>
				</el-form>
			</el-row>
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitAddBorrowedMoney">确 定</el-button>
				<el-button @click="giveBackMoneyShow = false">取 消</el-button>
			</div>
		</el-dialog>

		<InfoDialog title="历史还款记录" :visible.sync="dialogHistoryVisible" :width="'620px'">
			<template #info>
				<el-table
					v-if="tableData.length !== 0"
					:data="tableData"
					size="mini"
					:cell-style="
						() => {
							return { padding: '2px' };
						}
					"
					border
					:span-method="mergeCells"
				>
					<el-table-column prop="" width="180">
						<template #default="scope">
							<span v-if="scope.$index === 0">贷款还款</span>
						</template>
					</el-table-column>
					<el-table-column prop="payDate" label="时间" width="180"></el-table-column>
					<el-table-column prop="moneyAmount" label="还款金额"></el-table-column>
				</el-table>
				<pagination v-show="detailTotal > 0" :total="detailTotal" :page.sync="queryRepaymentParams.pageNum" :limit.sync="queryRepaymentParams.pageSize" @pagination="getRepaymentMoneyList" />
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { listBorrowedMoney, getBorrowedMoney, delBorrowedMoney, addBorrowedMoney, updateBorrowedMoney, borrowedMoneyAudit } from '@/api/system/borrowedMoney';
import { mapGetters, mapState } from 'vuex';
import { addRepayment, getRepaymentMoneyNoPage } from '@/api/system/repayment';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { listCompany } from '@/api/system/company';
import { TableName } from '@/api/tool/enums';
import { addDateRange } from '@/utils/ruoyi';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import InfoDialog from '@/components/InfoDialog.vue';
import * as math from 'mathjs';
import { checkPermi } from '@/utils/permission';
import { debounce } from '@/utils/trash/utils';

export default {
	name: 'BorrowedMoney',
	components: { InfoDialog, SearchOption },
	mixins: [mixin_printHTML, mixin_bankType],
	data() {
		var validateloanNO = (rule, value, callback) => {
			if (value === '') {
				callback(new Error('请输入loanNO'));
			} else {
				if (this.form.loanNO !== '') {
					this.$refs.form.validateField('check loanNO');
				}
				callback();
			}
		};
		return {
			loading: true,
			ids: [],
			single: true,
			multiple: true,
			showSearch: true,
			total: 0,
			borrowedMoneyList: [],
			title: '',
			open: false,
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				loanNO: null,
				origin: null,
				moneyAmount: null,
				ratio: null,
				loanDate: null,
				loanDuring: null,
				mortgageGuarantee: null,
				acountsName: null,
				bankNo: null,
				isEnd: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			form: {},
			rules: {
				loanNO: [{ validator: validateloanNO, trigger: 'blur' }],
				origin: [
					{
						required: true,
						message: '贷款来源不能为空',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{
						required: true,
						message: '借入金额不能为空',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				ratio: [
					{
						required: true,
						message: '贷款利率不能为空',
						trigger: 'blur'
					}
				],
				loanDate: [
					{
						required: true,
						message: '贷款发放日期不能为空',
						trigger: 'blur'
					}
				],
				loanDuring: [
					{
						required: true,
						message: '贷款期限不能为空',
						trigger: 'blur'
					}
				],
				mortgageGuarantee: [
					{
						required: true,
						message: '抵押担保不能为空',
						trigger: 'blur'
					}
				],
				acountsName: [
					{
						required: true,
						message: '打入账户不能为空',
						trigger: 'blur'
					}
				],
				bankNo: [
					{
						required: true,
						message: '打入账号不能为空',
						trigger: 'blur'
					}
				]
			},
			borrowedMoneyRules: {
				moneyAmount: [
					{
						required: true,
						message: '还款金额不能为空',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				ratio: [
					{
						required: true,
						message: '付息金额不能为空',
						trigger: 'blur'
					},
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				payDate: [
					{
						required: true,
						message: '支付日期不能为空',
						trigger: 'blur'
					}
				],
				acountsName: [
					{
						required: true,
						message: '银行户名不能为空',
						trigger: 'blur'
					}
				],
				bankNo: [
					{
						required: true,
						message: '开户行不能为空',
						trigger: 'blur'
					}
				]
			},
			dateRange: [],
			columns: [
				{ key: 0, label: `id`, visible: true },
				{ key: 1, label: `贷款来源`, visible: true },
				{ key: 2, label: `借入金额`, visible: true },
				{ key: 3, label: `付息金额`, visible: true },
				{ key: 4, label: `贷款发放日期`, visible: true },
				{ key: 5, label: `贷款年限`, visible: true },
				{ key: 6, label: `抵押担保`, visible: true },
				{ key: 7, label: `打入账户`, visible: true },
				{ key: 8, label: `打入账号`, visible: true },
				{ key: 9, label: `已还款金额`, visible: true },
				{ key: 10, label: `未还款金额`, visible: true },
				{ key: 11, label: `已还款利息`, visible: true }
				/* {key: 9, label: `已还款标记`, visible: true},*/
			],
			// 还款弹窗
			giveBackMoneyShow: false,
			// 是否偿还利息
			isNeedRatio: false,
			// 点击银行卡 查询银行卡
			queryBank: '',
			// 付款分类信息
			subjectTree: [],
			// 分类信息
			currentSort: {
				levelOne: '',
				levelTwo: ''
			},
			// 一级分类列表 二级分类
			OneLevelOption: [],
			TwoLevelOption: [],

			// 还款信息
			moneyBackInfo: {
				bankNo: '',
				acountsName: ''
			},

			// 查询变量
			queryBankAcount: '',
			loanNO: '',

			// 点击查看历史还款
			queryRepaymentParams: {
				pageNum: 1,
				pageSize: 20
			},
			tableData: [],
			detailTotal: 0,
			dialogHistoryVisible: false
		};
	},
	created() {
		this.getList();
		this.$store.dispatch('money/getTempBorrowedMoneyList');
	},
	computed: {
		// 检查是否有复核权限（包含admin权限）
		hasAuditPermission() {
			return checkPermi(['system:borrowedmoney:audit']);
		},
		TableName() {
			return TableName;
		},
		...mapGetters(['tempBorrowedMoneyList'])
	},
	// 展示与隐藏
	watch: {},
	methods: {
		listCompany,
		listBankAccount,
		// 查看历史还款信息
		checkDetail(row) {
			this.getRepaymentMoneyList(row);
		},
		getRepaymentMoneyList(row) {
			// 查询
			getRepaymentMoneyNoPage({
				loanNO: row.loanNO,
				...this.queryRepaymentParams
			}).then(res => {
				this.tableData = res.rows;
				this.detailTotal = res.total;
				if (res.rows.length === 0) {
					this.$message.error('暂无数据');
				} else {
					this.$message.success('查询成功');
					this.dialogHistoryVisible = true;
				}
			});
		},
		mergeCells({ row, column, rowIndex, columnIndex }) {
			if (columnIndex === 0) {
				// 合并第一列 "期货保证金收回"
				if (rowIndex === 0) {
					return {
						rowspan: this.tableData.length,
						colspan: 1
					};
				} else {
					return {
						rowspan: 0,
						colspan: 0
					};
				}
			}
		},
		// 处理还款的事件函数  这里应该先填写还款信息 然后在还款信息页面申请付款
		handleGiveBackMoney(row) {
			this.giveBackMoneyShow = true;
			// 补充关键字段
			this.moneyBackInfo.loanNO = row.loanNO;
		},
		// 已经还够了 在点击提示已经还够
		handleGiveEnoughBackMoney(row) {
			this.$antdconfirm({
				title: '提示',
				content: '已经还够了金额,是否继续还款?',
				okText: '确定',
				cancelText: '取消',
				type: 'warning',
				zIndex: 2600,
				onOk: async () => {
					try {
						await this.handleGiveBackMoney(row);
						this.$message.success('还款操作成功');
					} catch {
						this.$message.error('还款操作失败，请重试');
					}
				},
				onCancel: () => {
					this.$message.info('已取消继续还款');
				}
			});
		},
		// 添加还款信息
		submitAddBorrowedMoney() {
			addRepayment(this.moneyBackInfo).then(res => {
				this.$message.success('添加成功');
				this.reset();
				this.giveBackMoneyShow = false;
			});
		},
		// 还款的自动填充
		handleCommitBackBankAcount(val) {
			this.moneyBackInfo.acountsName = val.acountsName;
			this.moneyBackInfo.bankNo = val.bankNo;
		},
		handleUpdateQueryBankAcount(val) {
			this.queryBankAcount = val;
		},
		// 添加借入款的自动填充
		handleUpdateQueryBankAcountForm(val) {
			this.queryBankAcount = val;
		},
		handleCommitBackBankAcountForm(val) {
			this.form.bankNo = val.bankNo;
			this.form.acountsName = val.acountsName;
		},
		getSummaries(param) {
			const { columns, data } = param;
			const sums = [];
			columns.forEach((column, index) => {
				if (index === 0) {
					sums[index] = '统计';
					return;
				}
				const values = data.map(item => {
					return Number(item[column.property]);
				});
				const includes = [2];
				if (!values.every(value => isNaN(value))) {
					if (includes.includes(index)) {
						sums[index] = values.reduce((prev, curr) => {
							const value = Number(curr);
							if (!isNaN(value)) {
								return prev + curr;
							} else {
								return prev;
							}
						}, 0);
						sums[index] += ' ';
					}
				} else {
					sums[index] = '';
				}
			});
			return sums;
		},
		/** 查询从外部借款信息列表 */
		getList() {
			this.loading = true;
			listBorrowedMoney(addDateRange(this.queryParams, this.dateRange)).then(response => {
				this.borrowedMoneyList = response.rows;
				this.borrowedMoneyList.forEach(item => {
					item.isEnd = item.isEnd ? '是' : '否';

					// 规范化 auditState
					if (item.auditState === null || item.auditState === undefined || item.auditState === '0' || item.auditState === 0 || item.auditState === false) {
						item.auditState = '0';
					} else if (item.auditState === '1' || item.auditState === 1 || item.auditState === true) {
						item.auditState = '1';
					}

					// 计算已还款金额、未还款金额、已还款利息
					try {
						const moneyAmount = math.bignumber(item.moneyAmount || 0);
						const unrepaidAmount = math.bignumber(item.unrepaidAmount || 0);
						// 已还款金额 = moneyAmount - unrepaidAmount
						item.repaidAmount = math.format(math.subtract(moneyAmount, unrepaidAmount), { notation: 'fixed', precision: 2 });
						// 未还款金额 (格式化)
						item.unrepaidAmount = math.format(unrepaidAmount, { notation: 'fixed', precision: 2 });

						// 已还款利息 = repayments数组中ratio的求和
						if (item.repayments && Array.isArray(item.repayments)) {
							const totalInterest = item.repayments.reduce((sum, repayment) => {
								return math.add(sum, math.bignumber(repayment.ratio || 0));
							}, math.bignumber(0));
							item.repaidInterest = math.format(totalInterest, { notation: 'fixed', precision: 2 });
						} else {
							item.repaidInterest = '0.00';
						}
					} catch (e) {
						console.error('Calculation error:', e);
						item.repaidAmount = '0.00';
						item.repaidInterest = '0.00';
					}
				});
				this.total = response.total;
				this.loading = false;
			});
		},
		// 复核操作
		handleBorrowedMoneyAudit(row, e) {
			// 检查是否有权限
			if (!this.hasAuditPermission) {
				this.$message({
					type: 'warning',
					message: '您没有复核权限！'
				});
				// 还原开关状态
				row.auditState = e === '1' ? '0' : '1';
				return;
			}

			const debouncedBorrowedMoneyAudit = debounce(function (row, auditStatus) {
				borrowedMoneyAudit({ id: row.id, auditStatus })
					.then(() => {
						const message = auditStatus === '1' ? '复核成功!' : '取消复核!';
						this.$message({
							type: 'success',
							message: message
						});
						this.getList();
					})
					.catch(() => {
						// 如果API调用失败，还原开关状态
						row.auditState = auditStatus === '1' ? '0' : '1';
					});
			}, 1000);

			// 更新视图 (v-model already updated it, but just to be safe or if we want to manually control it)
			// row.auditState = e;
			// 调用防抖后的函数，传递最新的 row 和 auditStatus
			debouncedBorrowedMoneyAudit.call(this, row, e);
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				code: null,
				id: null,
				loanNO: null,
				origin: null,
				moneyAmount: null,
				ratio: null,
				loanDate: null,
				loanDuring: null,
				mortgageGuarantee: null,
				selfBankCardType: null,
				acountsName: null,
				bankNo: null,
				isEnd: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			this.resetForm('form');
		},
		/** 搜索按钮操作 */
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		/** 重置按钮操作 */
		resetQuery() {
			this.resetForm('queryForm');
			this.handleQuery();
		},
		// 多选框选中数据
		handleSelectionChange(selection) {
			this.ids = selection.map(item => item.id);
			this.single = selection.length !== 1;
			this.multiple = !selection.length;
		},
		/** 新增按钮操作 */
		handleAdd() {
			this.reset();
			this.open = true;
			this.title = '添加从外部借款信息';
		},
		/** 点击修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getBorrowedMoney(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改从外部借款信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						// 转换
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						this.form = excludeParams(this.form, this.$exclude);
						updateBorrowedMoney(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						// 转换
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						this.form.isEnd = 0;
						this.form = excludeParams(this.form, this.$exclude);
						addBorrowedMoney(this.form).then(response => {
							this.$modal.msgSuccess('新增成功');
							this.open = false;
							this.getList();
						});
					}
				}
			});
		},
		/** 删除按钮操作 */
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('是否确认删除从外部借款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delBorrowedMoney(ids);
				})
				.then(() => {
					this.getList();
					this.$modal.msgSuccess('删除成功');
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/borrowedMoney/export',
				{
					...this.queryParams
				},
				`外部借款_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>
