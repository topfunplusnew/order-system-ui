<!--向外借钱-->
<template>
	<div class="app-container">
		<el-form v-show="showSearch" ref="queryForm" :model="timesQuery" size="mini" :inline="true" label-width="68px">
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker v-model="timesQuery.beginTime" type="datetime" placeholder="请选择开始时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker v-model="timesQuery.endTime" type="datetime" placeholder="请选择结束时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
			</el-form-item>
			<el-form-item label="对象类型" prop="objectType">
				<el-select v-model="timesQuery.objectType" placeholder="请选择对象类型">
					<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value"></el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button type="primary" icon="el-icon-search" size="mini" @click="handleQueryTime">搜索</el-button>
			</el-form-item>
		</el-form>
		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新</el-button>
			</el-col>
			<el-col :span="1.5">
				<el-button size="mini" type="danger" @click="handleAdd">添加借出款信息</el-button>
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
			<el-table-column v-if="columns[0].visible" label="期货保证金公司" align="center" prop="futuresMarginCompany" width="130" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="futuresMarginCompany" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[1].visible" label="对象" align="center" prop="target" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="target" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[2].visible" label="对象类型" align="center" prop="targetType" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="targetType" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[3].visible" label="保证金金额" align="center" prop="moneyAmount" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="moneyAmount" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[4].visible" label="对方账户" align="center" prop="targetAcountsName" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="targetAcountsName" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[5].visible" label="对方账号" align="center" prop="targetBankNo" width="160" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="targetBankNo" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[6].visible" label="对方开户行" align="center" prop="targetBankName" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="targetBankName" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[7].visible" label="我方支付账户" align="center" prop="selfAcountsName" show-overflow-tooltip width="160">
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfAcountsName" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[8].visible" label="我方账号" align="center" prop="selfBankNo" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankNo" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[9].visible" label="我方开户行" align="center" prop="selfBankName" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="selfBankName" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[10].visible" label="支付期货保证金时间" align="center" prop="futuresDate" show-overflow-tooltip width="110">
				<template #default="scope">
					<DynamicField :row="scope.row" field="futuresDate" />
				</template>
			</el-table-column>

			<el-table-column v-if="columns[11].visible" label="事由" align="center" prop="reason" width="110" show-overflow-tooltip>
				<template #default="scope">
					<DynamicField :row="scope.row" field="reason" />
				</template>
			</el-table-column>

			<el-table-column label="备注" align="center" prop="comments" width="110" show-overflow-tooltip />

			<el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="230px" fixed="right">
				<template slot-scope="scope">
					<el-row>
						<el-button v-if="scope.row.checkState === '未申请'" size="mini" type="text" @click="applyForPayment(scope.row)">申请付款</el-button>
						<el-button v-if="scope.row.checkState === '审核中'" size="mini" type="warning" disabled>审核中</el-button>
						<el-button v-hasPermi="['system:lendmoney:remove']" size="mini" type="text" @click="handleGetBackMoney(scope.row)">收回资金</el-button>
						<el-button v-hasPermi="['system:lendmoney:edit']" size="mini" type="primary" @click="handleUpdate(scope.row)">修改</el-button>
						<el-button v-hasPermi="['system:lendmoney:remove']" size="mini" type="danger" @click="handleDelete(scope.row)">删除</el-button>
					</el-row>
				</template>
			</el-table-column>
		</el-table>

		<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

		<!-- 添加或修改向外部借出款信息对话框 -->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" :title="title" :visible.sync="open" width="1000px" append-to-body>
			<el-form ref="form" :model="form" :rules="rules" label-width="160px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="支付时间" prop="futuresDate">
							<el-date-picker v-model="form.futuresDate" type="datetime" placeholder="请选择支付时间" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
						</el-form-item>
						<el-form-item label="金额" prop="moneyAmount">
							<el-input v-model="form.moneyAmount" placeholder="请输入保证金金额" />
						</el-form-item>
						<el-form-item label="对象" prop="target">
							<el-input v-model="form.target" placeholder="请输入对象(员工姓名、公司名称)" />
						</el-form-item>
						<!--            这里应该根据对象类型 决定后面的选择器的公司类型是什么样的-->
						<el-form-item label="对象类型" prop="targetType">
							<el-select v-model="form.targetType" placeholder="请选择对象类型">
								<el-option v-for="dict in dict.type.order_target_type" :key="dict.value" :label="dict.label" :value="dict.value"></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="对方账户" prop="targetAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input disabled v-model="form.targetAcountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="3">
									<SearchOption
										title="对方账户"
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType: form.targetType
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column :label="form.targetType === '其他' || form.targetType === '员工' ? '名称' : form.targetType" align="center" prop="acountsName" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="开户名" align="center" prop="acountsName" />
											<el-table-column label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="对方账号" prop="targetBankNo">
							<el-input disabled v-model="form.targetBankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="对方开户行" prop="targetBankName">
							<el-input disabled v-model="form.targetBankName" placeholder="请选择" />
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方支付账户" prop="selfAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />
								</el-col>
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType: '己方公司'
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBackSelf"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column label="账户类型" align="center" prop="acountsType" />
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户行" align="center" prop="bankName" />
											<el-table-column label="开户名" align="center" prop="acountsName" />
											<el-table-column label="账号" align="center" prop="bankNo" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input disabled v-model="form.selfBankName" placeholder="请选择" />
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
			<div slot="footer" class="dialog-footer">
				<el-button type="primary" @click="submitForm">确 定</el-button>
				<el-button @click="cancel">取 消</el-button>
			</div>
		</el-dialog>

		<!--    回收弹窗-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="收回资金操作" :visible.sync="giveRecoverMoneyShow" width="40%" append-to-body>
			<el-row>
				<el-form :model="recoverMoneyEntity" label-width="120" :rules="receiveRules">
					<el-form-item label="收回账户" prop="acountsName">
						<el-row>
							<el-col :span="10">
								<el-input v-model="recoverMoneyEntity.acountsName" placeholder="请输入收回账户" />
							</el-col>
							<el-col :span="4">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: '己方公司' }"
									query-label="户名查找"
									query-info="acountsName"
									:query-name="queryBank"
									@commitBack="handleCommitBackBankAcountForm"
									@update:queryName="handleUpdateQueryBankAcountForm"
								>
									<template #table-columns>
										<el-table-column label="账户类型" align="center" prop="acountsType" />
										<el-table-column label="显示名称" align="center" prop="displayName" />
										<el-table-column label="开户行" align="center" prop="bankName" />
										<el-table-column label="开户名" align="center" prop="acountsName" />
										<el-table-column label="账号" align="center" prop="bankNo" />
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="我方银行账户类型">
						<BankType
							:bill-type="BankAcceptanceType.PAY_TYPE.RECEIVE"
							:select-type="recoverMoneyEntity.selfBankCardType"
							@updateSelectedType="changeCustomSelfBankType"
							@updateBankAcceptance="value => (form.params.bankacceptance = value)"
						/>
					</el-form-item>
					<el-form-item label="收回账号" prop="bankNo">
						<el-input v-model="recoverMoneyEntity.bankNo" placeholder="请输入收回账号" />
					</el-form-item>
					<el-form-item label="收回金额" prop="moneyAmount">
						<el-input v-model="recoverMoneyEntity.moneyAmount" placeholder="请输入收回金额" />
					</el-form-item>
					<el-form-item label="收回日期" prop="payDate">
						<el-date-picker v-model="recoverMoneyEntity.recoverDate" type="datetime" placeholder="请选择收回日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
					</el-form-item>
					<el-form-item label="备注信息" prop="comments">
						<el-input v-model="recoverMoneyEntity.comments" placeholder="请输入备注信息" />
					</el-form-item>
					<el-form-item>
						<el-button type="primary" @click="RecoverMoney">收款</el-button>
						<el-button type="primary" @click="resetRecoverMoney">取消</el-button>
					</el-form-item>
				</el-form>
			</el-row>
		</el-dialog>

		<!--    付款申请-->
		<el-dialog :modal="false" v-dialogDrag v-dialogDragWidth v-dialogDragHeight  :close-on-click-modal="false" :show-close="false" title="付款申请" :visible.sync="applyDialogVisible" width="45%">
			<keep-alive>
				<ApplyPayment :table-name="TableName.LEND_MONEY" :t-i-d="tid" :need-money="needMoney" :need-info="needInfo" @changeOpen="changeOpen" />
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import { addLendMoney, delLendMoney, getLendMoney, listLendMoney, updateLendMoney } from '@/api/system/lendMoney';
import { mapGetters } from 'vuex';
import { addRecoverMoney } from '@/api/system/recoverMoney';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { BankAcceptanceType, TableName } from '@/api/tool/enums';
import { excludeParams } from '@/api/tool/exclude';
import { mixin_reviveMoney } from '../../dashboard/mixins/receive';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { ReceiveType } from '../../../api/tool/enums';
import DynamicField from '@/components/DynamicField.vue';
import BankType from '@/views/dashboard/components/common/BankType.vue';
import { mixin_bankType } from '../../dashboard/mixins/common/common_bankType';
import { mixin_lend_money_fill } from './lendMoneyFill';

export default {
	name: 'LendMoney',
	components: { BankType, DynamicField, ApplyPayment, SearchOption },
	mixins: [mixin_reviveMoney, mixin_printHTML, mixin_lend_money_fill, mixin_bankType],
	dicts: ['order_target_type'],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 选中数组
			ids: [],
			// 非单个禁用
			single: true,
			// 非多个禁用
			multiple: true,
			// 显示搜索条件
			showSearch: true,
			// 总条数
			total: 0,
			// 向外部借出款信息表格数据
			lendMoneyList: [],
			// 弹出层标题
			title: '',
			// 是否显示弹出层
			open: false,
			// 查询参数
			queryParams: {
				pageNum: 1,
				pageSize: 10,
				futuresNO: null,
				futuresMarginCompany: null,
				targetType: null,
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
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			},
			// 表单参数
			form: { ishave: '' },
			// 表单校验
			rules: {
				// 添加校验
				futuresNO: [
					{
						required: true,
						message: '期货编号不能为空',
						trigger: 'blur'
					}
				],
				targetType: [
					{
						required: true,
						message: '对象类型不能为空',
						trigger: 'blur'
					}
				],

				target: [{ required: true, message: '对象不能为空', trigger: 'blur' }],

				moneyAmount: [
					{
						required: true,
						message: '保证金金额不能为空',
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

				targetAcountsName: [
					{
						required: true,
						message: '对方账户不能为空',
						trigger: 'blur'
					}
				],

				targetBankNo: [
					{
						required: true,
						message: '对方银行账号不能为空',
						trigger: 'blur'
					}
				],

				targetBankName: [
					{
						required: true,
						message: '对方银行不能为空',
						trigger: 'blur'
					}
				],

				selfAcountsName: [
					{
						required: true,
						message: '我方账户不能为空',
						trigger: 'blur'
					}
				],

				selfBankNo: [
					{
						required: true,
						message: '我方银行账号不能为空',
						trigger: 'blur'
					}
				],

				selfBankName: [
					{
						required: true,
						message: '我方银行不能为空',
						trigger: 'blur'
					}
				],

				futuresDate: [
					{
						required: true,
						message: '支付期货保证金日期不能为空',
						trigger: 'blur'
					}
				],
				reason: [{ required: true, message: '请输入是由!', trigger: 'blur' }]
			},
			receiveRules: {
				acountsName: [
					{
						required: true,
						message: '收回账户不能为空',
						trigger: 'blur'
					}
				],
				bankNo: [
					{
						required: true,
						message: '收回账号不能为空',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{
						required: true,
						message: '收回金额不能为空',
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
						message: '收回日期不能为空',
						trigger: 'blur'
					}
				]
			},
			columns: [
				{ key: 0, label: `期货保证金公司`, visible: true },
				{ key: 1, label: `对象`, visible: true },
				{ key: 2, label: `对象类型`, visible: true },
				{ key: 3, label: `保证金金额`, visible: true },
				{ key: 4, label: `对方账户`, visible: true },
				{ key: 5, label: `对方账号`, visible: true },
				{ key: 6, label: `对方开户行`, visible: true },
				{ key: 7, label: `我方支付账户`, visible: true },
				{ key: 8, label: `我方账号`, visible: true },
				{ key: 9, label: `我方开户行`, visible: true },
				{ key: 10, label: `支付期货保证金时间`, visible: true },
				{ key: 11, label: `事由`, visible: true }
			],

			// 搜索参数
			timesQuery: {
				beginTime: '',
				endTime: '',
				objectType: ''
			},
			// 员工、客户、供应商、其他
			options: [
				{
					label: '员工',
					value: '员工'
				},
				{
					label: '客户',
					value: '客户'
				},
				{
					label: '供应商',
					value: '供应商'
				},
				{
					label: '其他',
					value: '其他'
				}
			],
			// 收回资金弹窗
			giveRecoverMoneyShow: false,
			// 借出款收回信息实体
			recoverMoneyEntity: {
				acountsName: '',
				bankNo: ''
			},
			// 收款信息实体
			receiveMoneyEntity: {},
			applyDialogVisible: false,
			tid: '',
			needMoney: 0,
			needInfo: {}
		};
	},
	created() {
		this.getList();
		// 查向外借钱
		this.$store.dispatch('money/getTempLendMoneyList');
	},
	computed: {
		BankAcceptanceType() {
			return BankAcceptanceType;
		},
		TableName() {
			return TableName;
		},
		...mapGetters(['tempLendMoneyList'])
	},
	methods: {
		listBankAccount,
		// 付款申请
		applyForPayment(row) {
			this.tid = row.id;
			this.needMoney = row.moneyAmount;
			this.needInfo = {
				bankNo: row.targetBankNo,
				acountsName: row.targetAcountsName,
				bankName: row.targetBankName
			};
			this.applyDialogVisible = true;
		},
		// 修改对方账户类型
		changeCustomSelfBankType(value) {
			this.recoverMoneyEntity.selfBankCardType = value;
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyDialogVisible = false;
			this.getList();
		},
		// 点击收回资金按钮
		handleGetBackMoney(row) {
			// 初始化表的信息
			this.initReviveMoneyTableInfo(row.id, ReceiveType.LEND_MONEY_GET_BACK, TableName.LEND_MONEY);
			// 初始化对方账户信息
			this.initReviveMoneyOtherAccountInfo(row.targetAcountsName, row.targetBankNo, row.targetBankName);
			// 打开添加借出款收回的信息弹窗
			this.recoverMoneyEntity.futuresNO = row.futuresNO; // 初始化uuid
			// 赋值收款信息
			this.initComment('借出款收回');
			this.giveRecoverMoneyShow = true;
		},
		// 收回资金 首先添加借出款收回信息
		RecoverMoney() {
			this.initReceiveTime(this.recoverMoneyEntity.recoverDate);
			addRecoverMoney(this.recoverMoneyEntity).then(res => {
				this.$modal.msgSuccess('添加借出款收回信息成功~');
				// 同时也要添加到收款信息中
				// this.addReviveMoneyInfo()
				this.giveRecoverMoneyShow = false;
				this.resetRecoverMoney();
			});
		},
		resetRecoverMoney() {
			this.recoverMoneyEntity = {
				futuresNO: null,
				targetType: null,
				target: null,
				moneyAmount: null,
				targetAcountsName: null,
				targetBankNo: null,
				targetBankName: null,
				selfAcountsName: null,
				selfBankCardType: null,
				selfBankNo: null,
				selfBankName: null,
				recoverDate: null,
				reason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				delFlag: null
			};
			this.giveRecoverMoneyShow = false;
		},
		handleCommitBackBankAcountForm(val) {
			// 初始化我方账户信息
			this.initReviveMoneySelfAccountInfo(val.acountsName, val.bankNo, val.bankName, val.id);
			this.recoverMoneyEntity.acountsName = val.acountsName;
			this.recoverMoneyEntity.bankNo = val.bankNo;
		},
		// 时间查询
		handleQueryTime() {
			// 重置
			this.lendMoneyList = this.tempLendMoneyList;
			// 筛选事件
			this.lendMoneyList = this.filterTime();
		},
		// 筛选方法
		filterTime() {
			return this.lendMoneyList.filter(item => {
				// 时间转换
				const time_search = new Date(item.futuresDate).getTime();
				const time_start = new Date(this.timesQuery.beginTime).getTime();
				const date = new Date(this.timesQuery.endTime);
				date.setDate(date.getDate() + 1);
				const time_end = date.getTime();
				// 如果当前的客户类型给空
				if (this.timesQuery.beginTime !== '' && this.timesQuery.endTime !== '') {
					if (this.timesQuery.objectType !== '') {
						return time_search >= time_start && time_search <= time_end && item.targetType === this.timesQuery.objectType;
					} else {
						return time_search >= time_start && time_search <= time_end;
					}
				} else {
					return item.targetType === this.timesQuery.objectType;
				}
			});
		},

		/** 查询向外部借出款信息列表 */
		getList() {
			this.loading = true;
			listLendMoney(this.queryParams).then(response => {
				this.lendMoneyList = response.rows;
				this.total = response.total;
				this.loading = false;
			});
		},
		// 取消按钮
		cancel() {
			this.open = false;
			this.reset();
		},
		// 表单重置F
		reset() {
			this.form = {
				id: null,
				futuresNO: null,
				futuresMarginCompany: null,
				targetType: null,
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
			this.title = '添加向外部借出款信息';
		},
		/** 修改按钮操作 */
		handleUpdate(row) {
			this.reset();
			const id = row.id || this.ids;
			getLendMoney(id).then(response => {
				this.form = response.data;
				this.open = true;
				this.title = '修改向外部借出款信息';
			});
		},
		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						this.form = excludeParams(this.form, this.$exclude);
						updateLendMoney(this.form).then(response => {
							this.$modal.msgSuccess('修改成功');
							this.open = false;
							this.getList();
						});
					} else {
						this.form.delFlag = null;
						this.form.addtime = null;
						this.form.updateTime = null;
						this.form.userId = null;
						this.form = excludeParams(this.form, this.$exclude);
						addLendMoney(this.form).then(response => {
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
				.confirm('是否确认删除向外部借出款信息编号为"' + ids + '"的数据项？')
				.then(function () {
					return delLendMoney(ids);
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
