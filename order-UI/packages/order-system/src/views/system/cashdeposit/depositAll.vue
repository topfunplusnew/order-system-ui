<template>
	<div class="app-container">
		<!-- 搜索条件 -->
		<el-form v-show="showSearch" ref="queryForm" :model="queryParams" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间">
				<el-date-picker v-model="queryParams.params.beginTime" type="datetime" placeholder="请选择开始时间" value-format="yyyy-MM-dd HH:mm:ss" />
			</el-form-item>
			<el-form-item label="结束时间">
				<el-date-picker v-model="queryParams.params.endTime" type="datetime" placeholder="请选择结束时间" value-format="yyyy-MM-dd HH:mm:ss" />
			</el-form-item>
			<el-form-item label="类型">
				<el-select v-model="queryParams.type" placeholder="全部类型" clearable>
					<el-option v-for="t in typeOptions" :key="t.value" :label="t.label" :value="t.value" />
				</el-select>
			</el-form-item>
			<el-form-item label="对方类型">
				<el-select v-model="queryParams.targetType" placeholder="请选择对方类型" clearable>
					<el-option v-for="o in counterpartOptions" :key="o.value" :label="o.label" :value="o.value" />
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
			</el-form-item>
		</el-form>

		<!-- 工具栏 -->
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="getList">刷新</el-button>
			</el-col>
			<el-col :span="2">
				<el-button size="mini" type="danger" @click="handleAdd">添加厂家保证金</el-button>
			</el-col>
			<right-toolbar :showSearch.sync="showSearch" :columns="columns" @queryTable="getList">
				<template #print>
					<el-col :span="1.5">
						<el-button plain icon="el-icon-printer" size="mini" @click="printHTML"></el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button v-hasPermi="['system:lendmoney:export']" plain icon="el-icon-folder-opened" size="mini" @click="handleExport"></el-button>
					</el-col>
				</template>
			</right-toolbar>
		</el-row>

		<!-- 表格 -->
		<el-table
			id="printBox"
			v-loading="loading"
			v-horizontal-scroll="'always'"
			border
			:data="lendMoneyList"
			size="mini"
			:cell-style="() => ({ padding: '1px' })"
			@selection-change="handleSelectionChange"
		>
			<el-table-column type="selection" width="40" />
			<el-table-column v-if="colVisible(0)" label="类型" prop="type" align="center" width="110" />
			<el-table-column v-if="colVisible(1)" :label="companyLabel" prop="futuresMarginCompany" align="center" show-overflow-tooltip>
				<template #default="{ row }">
					<span v-if="row.futuresMarginCompany">{{ row.futuresMarginCompany }}</span>
					<span v-else>无{{ row.type }}公司</span>
				</template>
			</el-table-column>
			<el-table-column v-if="colVisible(2)" label="对方类型" prop="targetType" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(3)" label="公司名称" prop="target" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(4)" label="金额" prop="moneyAmount" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(5)" label="未收回金额" prop="unrecoveredAmount" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(6)" label="对方账户" prop="targetAcountsName" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(7)" label="对方账号" prop="targetBankNo" align="center" show-overflow-tooltip width="170" />
			<el-table-column v-if="colVisible(8)" label="对方开户行" prop="targetBankName" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(9)" label="我方支付账户" prop="selfAcountsName" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(10)" label="我方账号" prop="selfBankNo" align="center" show-overflow-tooltip width="170" />
			<el-table-column v-if="colVisible(11)" label="我方开户行" prop="selfBankName" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(12)" :label="payTimeLabel" prop="futuresDate" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(13)" label="事由" prop="reason" align="center" show-overflow-tooltip />
			<el-table-column v-if="colVisible(14)" label="备注" prop="comments" align="center" show-overflow-tooltip />
			<el-table-column label="操作" width="350" align="center">
				<template #default="{ row }">
					<el-button type="text" size="mini" @click="handleUpdate(row)">修改</el-button>
					<el-button type="text" size="mini" @click="applyForPayment(row)">坏账损失</el-button>
					<el-button type="text" size="mini" @click="handleGetBackMoney(row)">收回资金</el-button>
					<el-button type="text" size="mini" @click="checkDetail(row)">历史收回</el-button>
					<el-button type="text" size="mini" style="color: red" @click="handleDelete(row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 新增/编辑弹窗 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			:title="dialogTitle"
			:visible.sync="open"
			width="55%"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="140px" size="mini">
				<el-row :gutter="10">
					<el-col :span="12">
						<el-form-item label="类型" prop="type">
							<el-select v-model="form.type" placeholder="请选择类型" @change="handleTypeChange">
								<el-option v-for="t in typeOptions" :key="t.value" :label="t.label" :value="t.value" />
							</el-select>
						</el-form-item>
						<el-form-item :label="companyLabel" prop="futuresMarginCompany">
							<el-input v-model="form.futuresMarginCompany" :placeholder="'请输入' + companyLabel" />
						</el-form-item>
						<el-form-item :label="payTimeLabel" prop="futuresDate">
							<el-date-picker v-model="form.futuresDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" :placeholder="'请选择' + payTimeLabel" />
						</el-form-item>
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入金额" />
						</el-form-item>
						<el-form-item label="公司名称" prop="target">
							<el-input v-model="form.target" placeholder="请输入公司名称" />
						</el-form-item>
						<el-form-item label="对方类型" prop="targetType">
							<el-select v-model="form.targetType" placeholder="请选择对方类型">
								<el-option v-for="o in counterpartOptions" :key="o.value" :label="o.label" :value="o.value" />
							</el-select>
						</el-form-item>
						<el-form-item label="对方账户" prop="targetAcountsName">
							<el-row>
								<el-col :span="14">
									<el-input v-model="form.targetAcountsName" placeholder="请选择对方账户" disabled />
								</el-col>
								<el-col :span="4">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{ acountsType: form.targetType === '其他' || form.targetType === '员工' ? '' : form.targetType }"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBankOther"
										@commitBack="handleCommitBackOther"
										@update:queryName="val => (queryBankOther = val)"
									>
										<template #table-columns>
											<CustomTableColumn :label="form.targetType === '其他' || form.targetType === '员工' ? '名称' : form.targetType" align="center" prop="acountsName" />
											<CustomTableColumn label="开户行" align="center" prop="bankName" />
											<CustomTableColumn label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="对方账号" prop="targetBankNo">
							<el-input v-model="form.targetBankNo" disabled placeholder="自动填充" />
						</el-form-item>
						<el-form-item label="对方开户行" prop="targetBankName">
							<el-input v-model="form.targetBankName" disabled placeholder="自动填充" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方支付账户" prop="selfAcountsName">
							<el-row>
								<el-col :span="14">
									<el-input v-model="form.selfAcountsName" disabled placeholder="请选择我方账户" />
								</el-col>
								<el-col :span="4">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{ acountsType: '己方公司' }"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBankSelf"
										@commitBack="handleCommitBackSelf"
										@update:queryName="val => (queryBankSelf = val)"
									>
										<template #table-columns>
											<CustomTableColumn label="开户行" align="center" prop="bankName" />
											<CustomTableColumn label="开户名" align="center" prop="acountsName" />
											<CustomTableColumn label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input v-model="form.selfBankNo" disabled placeholder="自动填充" />
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input v-model="form.selfBankName" disabled placeholder="自动填充" />
						</el-form-item>
						<el-form-item label="事由" prop="reason">
							<el-input v-model="form.reason" placeholder="请输入事由" />
						</el-form-item>
						<el-form-item label="备注" prop="comments">
							<el-input v-model="form.comments" placeholder="请输入备注" />
						</el-form-item>
					</el-col>
				</el-row>
			</el-form>
			<template #footer>
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</template>
		</el-dialog>

		<!-- 坏账损失 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight :close-on-click-modal="false" :show-close="false" title="坏账损失" :visible.sync="applyDialogVisible" width="45%">
			<keep-alive>
				<ApplyPayment
					:extra-information="{ __futuresNO: currentFuturesNO }"
					:table-name="TableName.LEND_MONEY"
					:t-i-d="tid"
					:need-money="needMoney"
					:need-info="needInfo"
					@changeOpen="changeOpen"
					:money-input-disabled="false"
				/>
			</keep-alive>
		</el-dialog>

		<!-- 收回资金弹窗 -->
		<el-dialog
			:modal="false"
			v-dialogDrag
			v-dialogDragWidth
			v-dialogDragHeight
			:close-on-click-modal="false"
			:show-close="false"
			title="收回资金操作"
			:visible.sync="giveRecoverMoneyShow"
			width="600px"
			append-to-body
		>
			<el-form :model="recoverMoneyEntity" :rules="recoverRules" ref="recoverForm" label-width="100px">
				<el-form-item label="收回账户" prop="acountsName">
					<el-row :gutter="8">
						<el-col :span="12">
							<el-input v-model="recoverMoneyEntity.acountsName" placeholder="请输入收回账户" />
						</el-col>
						<el-col :span="6">
							<SearchOption
								:get-data="listBankAccount"
								icon="el-icon-search"
								:limit-info="{ acountsType: '己方公司' }"
								query-label="户名查找"
								query-info="acountsName"
								:query-name="queryBankRecover"
								@commitBack="handleCommitBackBankAcountForm"
								@update:queryName="handleUpdateQueryBankAcountForm"
							>
								<template #table-columns>
									<el-table-column label="账户类型" align="center" prop="acountsType" />
									<el-table-column label="己方公司" align="center" prop="displayName" />
									<el-table-column label="开户行" align="center" prop="bankName" />
									<el-table-column label="开户名" align="center" prop="acountsName" />
									<el-table-column label="账号" align="center" prop="bankNo" />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>
				<el-form-item label="收回账号" prop="bankNo">
					<el-input v-model="recoverMoneyEntity.bankNo" placeholder="请输入收回账号" />
				</el-form-item>
				<el-form-item label="收回金额" prop="moneyAmount">
					<el-input v-model="recoverMoneyEntity.moneyAmount" placeholder="请输入收回金额" style="width: 200px" />
				</el-form-item>
				<el-form-item label="收回日期" prop="payDate">
					<el-date-picker v-model="recoverMoneyEntity.recoverDate" type="datetime" placeholder="请选择收回日期" value-format="yyyy-MM-dd HH:mm:ss" style="width: 100%"></el-date-picker>
				</el-form-item>
				<el-form-item label="备注信息" prop="comments">
					<el-input v-model="recoverMoneyEntity.comments" placeholder="请输入备注信息" type="textarea" :rows="3" />
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="RecoverMoney">收款</el-button>
					<el-button type="primary" @click="resetRecoverMoney">取消</el-button>
				</el-form-item>
			</el-form>
		</el-dialog>

		<!-- 历史收回记录 -->
		<InfoDialog title="历史收回记录" :visible.sync="dialogHistoryVisible" :width="'620px'">
			<template #info>
				<el-table v-if="tableData.length" :data="tableData" size="mini" border :span-method="mergeCells" :cell-style="() => ({ padding: '2px' })">
					<el-table-column width="160">
						<template #default="scope">
							<span v-if="scope.$index === 0">{{ firstMergeTitle }}</span>
						</template>
					</el-table-column>
					<el-table-column prop="recoverDate" label="时间" width="180" />
					<el-table-column prop="moneyAmount" label="收回金额" />
				</el-table>
				<pagination v-show="detailTotal > 0" :total="detailTotal" :page.sync="queryRepaymentParams.pageNum" :limit.sync="queryRepaymentParams.pageSize" @pagination="getRepaymentMoneyList" />
			</template>
		</InfoDialog>
	</div>
</template>

<script>
import { addLendMoney, delLendMoney, getLendMoney, listLendMoney, updateLendMoney } from '@/api/system/lendMoney';
import { addRecoverMoney, listRecoverMoney } from '@/api/system/recoverMoney';
import { mapGetters } from 'vuex';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName, DEPOSIT_TYPE, DEPOSIT_OPTIONS } from '@/api/tool/enums';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_reviveMoney } from '@/views/dashboard/mixins/receive';
import { mixin_printHTML } from '@/views/dashboard/mixins/print';
import { ReceiveType } from '@/api/tool/enums';
import InfoDialog from '@/components/InfoDialog.vue';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'DepositAll',
	components: { SearchOption, ApplyPayment, InfoDialog },
	mixins: [mixin_reviveMoney, mixin_printHTML],
	dicts: ['order_target_type'],
	data() {
		return {
			loading: false,
			showSearch: true,
			ids: [],
			total: 0,
			lendMoneyList: [],
			open: false,
			dialogTitle: '新增',
			currentFuturesNO: null,
			// 查询
			queryParams: {
				pageNum: 1,
				pageSize: 20,
				type: '厂家保证金和佣金',
				targetType: null,
				params: { beginTime: null, endTime: null }
			},
			// 表单
			form: {
				id: null,
				type: '厂家保证金',
				futuresMarginCompany: null,
				targetType: '供应商',
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				futuresDate: null,
				reason: null,
				comments: null
			},
			rules: {
				type: [{ required: true, message: '请选择类型', trigger: 'change' }],
				target: [{ required: true, message: '公司名称不能为空', trigger: 'blur' }],
				moneyAmount: [
					{ required: true, message: '金额不能为空', trigger: 'blur' },
					{
						validator: (r, v, cb) => {
							if (v == null || v === '') return cb();
							if (!/^\d+(\.\d{1,2})?$/.test(v)) cb(new Error('金额格式错误'));
							else cb();
						},
						trigger: 'blur'
					}
				],
				targetAcountsName: [{ required: true, message: '对方账户不能为空', trigger: 'blur' }],
				targetBankNo: [{ required: true, message: '对方账号不能为空', trigger: 'blur' }],
				selfAcountsName: [{ required: true, message: '我方账户不能为空', trigger: 'blur' }],
				selfBankNo: [{ required: true, message: '我方账号不能为空', trigger: 'blur' }],
				futuresDate: [{ required: true, message: '支付时间不能为空', trigger: 'change' }],
				reason: [{ required: true, message: '请输入事由', trigger: 'blur' }]
			},
			columns: [
				{ key: 0, visible: true },
				{ key: 1, visible: true },
				{ key: 2, visible: true },
				{ key: 3, visible: true },
				{ key: 4, visible: true },
				{ key: 5, visible: true },
				{ key: 6, visible: true },
				{ key: 7, visible: true },
				{ key: 8, visible: true },
				{ key: 9, visible: true },
				{ key: 10, visible: true },
				{ key: 11, visible: true },
				{ key: 12, visible: true },
				{ key: 13, visible: true },
				{ key: 14, visible: true }
			],
			typeOptions: [
				{ label: '厂家保证金', value: '厂家保证金' },
				{ label: '押金', value: '押金' }
			],
			counterpartOptions: [
				{ label: '员工', value: '员工' },
				{ label: '客户', value: '客户' },
				{ label: '供应商', value: '供应商' },
				{ label: '其他', value: '其他' }
			],
			// 坏账 / 收回相关
			applyDialogVisible: false,
			tid: '',
			needMoney: 0,
			needInfo: {},
			dialogHistoryVisible: false,
			tableData: [],
			detailTotal: 0,
			queryRepaymentParams: { pageNum: 1, pageSize: 20 },
			// 搜索控件本地变量
			queryBankOther: '',
			queryBankSelf: '',
			queryBankRecover: '',
			// 收回资金相关
			giveRecoverMoneyShow: false,
			recoverMoneyEntity: {
				acountsName: '',
				bankNo: '',
				moneyAmount: '',
				recoverDate: null,
				comments: '',
				futuresNO: null
			},
			recoverRules: {
				moneyAmount: [
					{ required: true, message: '收回金额不能为空', trigger: 'blur' },
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,2})?$/.test(value)) {
								callback(new Error('收回金额只能为正数且小数点后最多两位'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				]
			}
		};
	},
	computed: {
		...mapGetters(['tempLendMoneyList']),
		TableName() {
			return TableName;
		},
		DEPOSIT_TYPE() {
			return DEPOSIT_TYPE;
		},
		companyLabel() {
			return '公司名称';
		},
		payTimeLabel() {
			return '支付时间';
		},
		firstMergeTitle() {
			return '收回资金';
		}
	},
	created() {
		// 使用枚举选项
		this.typeOptions = DEPOSIT_OPTIONS;
		this.form.type = DEPOSIT_TYPE.FACTORY_GUARANTEE.value;

		this.getList();
		this.$store.dispatch('money/getTempLendMoneyList');
	},
	methods: {
		listBankAccount,
		colVisible(i) {
			return this.columns[i] && this.columns[i].visible;
		},
		handleTypeChange() {},
		handleQuery() {
			this.queryParams.pageNum = 1;
			this.getList();
		},
		resetQuery() {
			this.queryParams = { pageNum: 1, pageSize: 20, type: '', targetType: null, params: { beginTime: null, endTime: null } };
			this.getList();
		},
		getList() {
			this.loading = true;
			const params = { ...this.queryParams };
			listLendMoney(params)
				.then(res => {
					this.lendMoneyList = res.rows || [];
					this.total = res.total || 0;
					this.loading = false;
				})
				.catch(() => {
					this.loading = false;
				});
		},
		handleSelectionChange(sel) {
			this.ids = sel.map(s => s.id);
		},
		handleAdd() {
			this.reset();
			this.dialogTitle = '新增记录';
			this.form.type = DEPOSIT_TYPE.FACTORY_GUARANTEE.value;
			this.open = true;
		},
		handleUpdate(row) {
			this.reset();
			getLendMoney(row.id).then(res => {
				this.form = { ...this.form, ...res.data };
				this.dialogTitle = '修改记录';
				this.open = true;
			});
		},
		submitForm() {
			this.$refs.form.validate(valid => {
				if (!valid) return;
				const payload = excludeParams({ ...this.form }, this.$exclude || []);
				if (payload.id) {
					updateLendMoney(payload).then(() => {
						this.$modal.msgSuccess('修改成功');
						this.open = false;
						this.getList();
					});
				} else {
					addLendMoney(payload).then(() => {
						this.$modal.msgSuccess('新增成功');
						this.open = false;
						this.getList();
					});
				}
			});
		},
		cancel() {
			this.open = false;
		},
		reset() {
			this.form = {
				id: null,
				type: DEPOSIT_TYPE.FACTORY_GUARANTEE.value,
				futuresMarginCompany: null,
				targetType: '供应商',
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				futuresDate: null,
				reason: null,
				comments: null
			};
			this.queryBankOther = '';
			this.queryBankSelf = '';
			this.queryBankRecover = '';
		},
		handleCommitBackOther(val) {
			this.form.targetBankNo = val.bankNo;
			this.form.targetBankName = val.bankName;
			this.form.targetAcountsName = val.acountsName;
		},
		handleCommitBackSelf(val) {
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankName = val.bankName;
			this.form.selfAcountsName = val.acountsName;
		},
		// 坏账
		applyForPayment(row) {
			this.tid = row.id;
			this.currentFuturesNO = row.futuresNO;
			this.needInfo = {
				bankNo: row.selfBankNo,
				acountsName: row.selfAcountsName,
				bankName: row.selfBankName,
				companyId: 0,
				companyType: PUBLIC_DICT_TYPE.SELF_COMPANY
			};
			this.applyDialogVisible = true;
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyDialogVisible = false;
			this.getList();
		},
		// 收回
		handleGetBackMoney(row) {
			this.initReviveMoneyTableInfo(row.id, ReceiveType.LEND_MONEY_GET_BACK, TableName.LEND_MONEY);
			this.initReviveMoneyOtherAccountInfo(row.targetAcountsName, row.targetBankNo, row.targetBankName);
			this.giveRecoverMoneyShow = true;
			this.recoverMoneyEntity.futuresNO = row.futuresNO;
			this.initComment('借出款收回');
		},
		// 收回资金相关方法
		RecoverMoney() {
			this.$refs.recoverForm.validate(valid => {
				if (valid) {
					this.initReceiveTime(this.recoverMoneyEntity.recoverDate);
					addRecoverMoney(this.recoverMoneyEntity).then(res => {
						this.$modal.msgSuccess('添加借出款收回信息成功~');
						this.giveRecoverMoneyShow = false;
						this.resetRecoverMoney();
						this.getList();
					});
				}
			});
		},
		resetRecoverMoney() {
			this.recoverMoneyEntity = {
				acountsName: '',
				bankNo: '',
				moneyAmount: '',
				recoverDate: null,
				comments: '',
				futuresNO: null
			};
			this.giveRecoverMoneyShow = false;
		},
		// 收回资金的搜索按钮自动填充方法
		handleUpdateQueryBankAcountForm(val) {
			this.queryBankRecover = val;
		},
		handleCommitBackBankAcountForm(val) {
			// 初始化我方账户信息
			this.initReviveMoneySelfAccountInfo(val.acountsName, val.bankNo, val.bankName, val.id);
			this.recoverMoneyEntity.acountsName = val.acountsName;
			this.recoverMoneyEntity.bankNo = val.bankNo;
		},
		// 修改记录
		checkDetail(row) {
			this.getRepaymentMoneyList(row);
		},
		getRepaymentMoneyList(row) {
			listRecoverMoney({ futuresNO: row.futuresNO, ...this.queryRepaymentParams }).then(res => {
				this.tableData = res.rows || [];
				this.detailTotal = res.total || 0;
				if (!this.tableData.length) {
					this.$message.error('暂无数据');
				} else {
					this.$message.success('查询成功');
					this.dialogHistoryVisible = true;
				}
			});
		},
		mergeCells({ columnIndex, rowIndex }) {
			if (columnIndex === 0) {
				if (rowIndex === 0) {
					return { rowspan: this.tableData.length, colspan: 1 };
				} else {
					return { rowspan: 0, colspan: 0 };
				}
			}
		},
		handleDelete(row) {
			const ids = row.id || this.ids;
			this.$modal
				.confirm('确认删除编号为 ' + ids + ' 的数据?')
				.then(() => delLendMoney(ids))
				.then(() => {
					this.$modal.msgSuccess('删除成功');
					this.getList();
				})
				.catch(() => {});
		},
		/** 导出按钮操作 */
		handleExport() {
			this.download(
				'system/lendMoney/export',
				{
					...this.queryParams
				},
				`lendMoney_${new Date().getTime()}.xlsx`
			);
		}
	}
};
</script>

<style scoped>
.mb8 {
	margin-bottom: 8px;
}
</style>
