<!--向外借钱-->
<template>
	<div class="app-container">
		<el-form
			v-show="showSearch"
			ref="queryForm"
			:model="timesQuery"
			size="mini"
			:inline="true"
			label-width="68px"
		>
			<el-form-item label="开始时间" prop="beginTime">
				<el-date-picker
					v-model="timesQuery.beginTime"
					type="datetime"
					placeholder="请选择开始时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				>
				</el-date-picker>
			</el-form-item>
			<el-form-item label="结束时间" prop="endTime">
				<el-date-picker
					v-model="timesQuery.endTime"
					type="datetime"
					placeholder="请选择结束时间"
					value-format="yyyy-MM-dd HH:mm:ss"
				>
				</el-date-picker>
			</el-form-item>
			<el-form-item label="对象类型" prop="objectType">
				<el-select v-model="timesQuery.objectType" placeholder="请选择对象类型">
					<el-option
						v-for="item in options"
						:key="item.value"
						:label="item.label"
						:value="item.value"
					>
					</el-option>
				</el-select>
			</el-form-item>
			<el-form-item>
				<el-button
					type="primary"
					icon="el-icon-search"
					size="mini"
					@click="handleQueryTime"
					>搜索</el-button
				>
				<!--        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>-->
			</el-form-item>
		</el-form>

		<el-row :gutter="10" class="mb8">
			<el-col :span="1.5">
				<el-button icon="el-icon-refresh" size="mini" @click="resetQuery"
					>刷新</el-button
				>
			</el-col>
			<el-col :span="1.5">
				<el-button size="mini" type="danger" @click="handleAdd"
					>添加押金</el-button
				>
			</el-col>
			<right-toolbar
				:showSearch.sync="showSearch"
				:columns="columns"
				@queryTable="getList"
			>
				<template #print>
					<el-col :span="1.5">
						<el-button
							plain
							icon="el-icon-printer"
							size="mini"
							@click="printHTML"
						>
						</el-button>
					</el-col>
				</template>
				<!--        导出-->
				<template #export>
					<el-col :span="1.5">
						<el-button
							v-hasPermi="['system:lendmoney:export']"
							plain
							icon="el-icon-folder-opened"
							size="mini"
							@click="handleExport"
						>
						</el-button>
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
			:cell-style="
				() => {
					return { padding: '1px' };
				}
			"
			@selection-change="handleSelectionChange"
		>
			<el-table-column
				v-if="columns[0].visible"
				:label="columns[0].label"
				:prop="columns[0].prop"
				align="center"
				width="130"
				show-overflow-tooltip
			>
				<template slot-scope="scope">
					<span v-if="scope.row.futuresMarginCompany">{{
						scope.row.futuresMarginCompany
					}}</span>
					<span v-else> 无押金公司 </span>
				</template>
			</el-table-column>

			<el-table-column
				v-if="columns[1].visible"
				:label="columns[1].label"
				:prop="columns[1].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[2].visible"
				:label="columns[2].label"
				:prop="columns[2].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[3].visible"
				:label="columns[3].label"
				:prop="columns[3].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[4].visible"
				:label="columns[4].label"
				:prop="columns[4].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[5].visible"
				:label="columns[5].label"
				:prop="columns[5].prop"
				align="center"
				width="160"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[6].visible"
				:label="columns[6].label"
				:prop="columns[6].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[7].visible"
				:label="columns[7].label"
				:prop="columns[7].prop"
				align="center"
				width="160"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[8].visible"
				:label="columns[8].label"
				:prop="columns[8].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[9].visible"
				:label="columns[9].label"
				:prop="columns[9].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[10].visible"
				:label="columns[10].label"
				:prop="columns[10].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				v-if="columns[11].visible"
				:label="columns[11].label"
				:prop="columns[11].prop"
				align="center"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				label="备注"
				align="center"
				prop="comments"
				width="110"
				show-overflow-tooltip
			/>

			<el-table-column
				label="操作"
				align="center"
				class-name="small-padding fixed-width"
				width="230px"
				fixed="right"
			>
				<template slot-scope="scope">
					<el-row>
						<el-button
							v-if="scope.row.checkState === '未申请'"
							size="mini"
							type="text"
							@click="applyForPayment(scope.row)"
							>申请付款</el-button
						>
						<el-button
							v-if="scope.row.checkState === '审核中'"
							size="mini"
							type="warning"
							disabled
							>审核中</el-button
						>
						<el-button
							v-hasPermi="['system:lendmoney:remove']"
							size="mini"
							type="text"
							@click="handleGetBackMoney(scope.row)"
							>收回资金</el-button
						>
						<el-button
							v-hasPermi="['system:lendmoney:edit']"
							size="mini"
							type="primary"
							@click="handleUpdate(scope.row)"
							>修改</el-button
						>
						<el-button
							v-hasPermi="['system:lendmoney:remove']"
							size="mini"
							type="danger"
							@click="handleDelete(scope.row)"
							>删除</el-button
						>
					</el-row>
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

		<!-- 添加或修改向外部借出款信息对话框 -->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="添加押金"
			:visible.sync="open"
			width="50%"
			append-to-body
		>
			<el-form ref="form" :model="form" :rules="rules" label-width="160px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="对方公司" prop="futuresMarginCompany">
							<el-input
								v-model="form.futuresMarginCompany"
								placeholder="请输入对方公司"
							/>
						</el-form-item>
						<el-form-item label="支付押金时间" prop="futuresDate">
							<el-date-picker
								v-model="form.futuresDate"
								type="datetime"
								placeholder="请选择支付押金时间"
								value-format="yyyy-MM-dd HH:mm:ss"
							>
							</el-date-picker>
						</el-form-item>
						<el-form-item label="押金金额" prop="moneyAmount">
							<el-input
								v-model="form.moneyAmount"
								placeholder="请输入押金金额"
							/>
						</el-form-item>
						<el-form-item label="对象" prop="target">
							<el-input
								v-model="form.target"
								placeholder="请输入对象(员工姓名、公司名称)"
							/>
						</el-form-item>
						<el-form-item label="对象类型" prop="targetType">
							<el-select v-model="form.targetType" placeholder="请选择对象类型">
								<el-option
									v-for="dict in dict.type.order_target_type"
									:key="dict.value"
									:label="dict.label"
									:value="dict.value"
								></el-option>
							</el-select>
						</el-form-item>
						<el-form-item label="对方账户" prop="targetAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input
										v-model="form.targetAcountsName"
										placeholder="请输入对方账户"
									/>
								</el-col>
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{
											acountsType:
												form.targetType === '其他' || form.targetType === '员工'
													? ''
													: form.targetType
										}"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBack"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column
												:label="
													form.targetType === '其他' ||
													form.targetType === '员工'
														? '名称'
														: form.targetType
												"
												align="center"
												prop="acountsName"
											/>
											<el-table-column
												label="开户行"
												align="center"
												prop="bankName"
											/>
											<el-table-column
												label="开户名"
												align="center"
												prop="acountsName"
											/>
											<el-table-column
												label="账号"
												align="center"
												prop="bankNo"
											/>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="对方账号" prop="targetBankNo">
							<el-input
								v-model="form.targetBankNo"
								placeholder="请输入对方账号"
							/>
						</el-form-item>
						<el-form-item label="对方开户行" prop="targetBankName">
							<el-input
								v-model="form.targetBankName"
								placeholder="请输入对方开户行"
							/>
						</el-form-item>
					</el-col>
					<el-col :span="12">
						<el-form-item label="我方支付账户" prop="selfAcountsName">
							<el-row>
								<el-col :span="10">
									<el-input
										v-model="form.selfAcountsName"
										placeholder="请输入我方支付账户"
									/>
								</el-col>
								<el-col :span="3">
									<SearchOption
										:get-data="listBankAccount"
										icon="el-icon-search"
										:limit-info="{ acountsType: '己方公司' }"
										query-label="户名查找"
										query-info="acountsName"
										:query-name="queryBank"
										@commitBack="handleCommitBackSelf"
										@update:queryName="handleUpdateQueryName"
									>
										<template #table-columns>
											<el-table-column
												label="账户类型"
												align="center"
												prop="acountsType"
											/>
											<el-table-column
												label="显示名称"
												align="center"
												prop="displayName"
											/>
											<el-table-column
												label="开户行"
												align="center"
												prop="bankName"
											/>
											<el-table-column
												label="开户名"
												align="center"
												prop="acountsName"
											/>
											<el-table-column
												label="账号"
												align="center"
												prop="bankNo"
											/>
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方账号" prop="selfBankNo">
							<el-input
								v-model="form.selfBankNo"
								placeholder="请输入我方账号"
							/>
						</el-form-item>
						<el-form-item label="我方开户行" prop="selfBankName">
							<el-input
								v-model="form.selfBankName"
								placeholder="请输入我方开户行"
							/>
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
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="收回资金操作"
			:visible.sync="giveRecoverMoneyShow"
			width="40%"
			append-to-body
		>
			<el-row>
				<el-form :model="recoverMoneyEntity" label-width="120">
					<el-form-item label="收回账户" prop="acountsName">
						<el-row>
							<el-col :span="10">
								<el-input
									v-model="recoverMoneyEntity.acountsName"
									placeholder="请输入收回账户"
								/>
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
										<el-table-column
											label="账户类型"
											align="center"
											prop="acountsType"
										/>
										<el-table-column
											label="显示名称"
											align="center"
											prop="displayName"
										/>
										<el-table-column
											label="开户行"
											align="center"
											prop="bankName"
										/>
										<el-table-column
											label="开户名"
											align="center"
											prop="acountsName"
										/>
										<el-table-column
											label="账号"
											align="center"
											prop="bankNo"
										/>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="收回账号" prop="bankNo">
						<el-input
							v-model="recoverMoneyEntity.bankNo"
							placeholder="请输入收回账号"
						/>
					</el-form-item>
					<el-form-item label="收回金额" prop="moneyAmount">
						<el-input
							v-model="recoverMoneyEntity.moneyAmount"
							placeholder="请输入收回金额"
						/>
					</el-form-item>
					<el-form-item label="收回日期" prop="payDate">
						<el-date-picker
							v-model="recoverMoneyEntity.recoverDate"
							type="datetime"
							placeholder="请选择收回日期"
							value-format="yyyy-MM-dd HH:mm:ss"
						>
						</el-date-picker>
					</el-form-item>
					<el-form-item label="备注信息" prop="comments">
						<el-input
							v-model="recoverMoneyEntity.comments"
							placeholder="请输入备注信息"
						/>
					</el-form-item>
					<el-form-item>
						<el-button type="primary" @click="RecoverMoney">收款</el-button>
						<el-button type="primary" @click="resetRecoverMoney"
							>取消</el-button
						>
					</el-form-item>
				</el-form>
			</el-row>
		</el-dialog>

		<!--    付款申请-->
		<el-dialog
			:close-on-click-modal="false"
			:show-close="false"
			title="付款申请"
			:visible.sync="applyDialogVisible"
			width="45%"
		>
			<keep-alive>
				<ApplyPayment
					:table-name="TableName.LEND_MONEY"
					:t-i-d="tid"
					:need-money="needMoney"
					:need-info="needInfo"
					@changeOpen="changeOpen"
				/>
			</keep-alive>
		</el-dialog>
	</div>
</template>

<script>
import {
	addLendMoney,
	delLendMoney,
	getLendMoney,
	listLendMoney,
	updateLendMoney
} from '@/api/system/lendMoney';
import { mapGetters } from 'vuex';
import { addRecoverMoney } from '@/api/system/recoverMoney';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { listCompany } from '@/api/system/company';
import ApplyPayment from '@/views/dashboard/components/common/ApplyPayment.vue';
import { TableName } from '@/api/tool/enums';
import { excludeParams } from '@/api/tool/exclude';
import { addReceiveMoney } from '../../../api/system/receiveMoney';
import { parseTime } from '../../../utils/ruoyi';
import { mixin_reviveMoney } from '../../dashboard/mixins/receive';
import { mixin_printHTML } from '../../dashboard/mixins/print';
import { ReceiveType } from '../../../api/tool/enums';

export default {
	components: { ApplyPayment, SearchOption },
	mixins: [mixin_reviveMoney, mixin_printHTML],
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
				type: '押金',
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
					{ required: true, message: '期货编号不能为空', trigger: 'blur' }
				],
				targetType: [
					{ required: true, message: '对象类型不能为空', trigger: 'blur' }
				],

				target: [{ required: true, message: '对象不能为空', trigger: 'blur' }],

				moneyAmount: [
					{ required: true, message: '保证金金额不能为空', trigger: 'blur' }
				],

				targetAcountsName: [
					{ required: true, message: '对方账户不能为空', trigger: 'blur' }
				],

				targetBankNo: [
					{ required: true, message: '对方银行账号不能为空', trigger: 'blur' }
				],

				targetBankName: [
					{ required: true, message: '对方银行不能为空', trigger: 'blur' }
				],

				selfAcountsName: [
					{ required: true, message: '我方账户不能为空', trigger: 'blur' }
				],

				selfBankNo: [
					{ required: true, message: '我方银行账号不能为空', trigger: 'blur' }
				],

				selfBankName: [
					{
						required: true,
						message: '我方银行不能为空',
						trigger: 'blur'
					}
				],

				futuresDate: [
					{ required: true, message: '支付押金日期不能为空', trigger: 'blur' }
				],
				reason: [{ required: true, message: '请输入是由!', trigger: 'blur' }]
			},
			columns: [
				{
					key: 0,
					label: '押金公司',
					prop: 'futuresMarginCompany',
					visible: true
				},
				{ key: 1, label: '对象类型', prop: 'targetType', visible: true },
				{ key: 2, label: '对象', prop: 'target', visible: true },
				{ key: 3, label: '保证金金额', prop: 'moneyAmount', visible: true },
				{ key: 4, label: '对方账户', prop: 'targetAcountsName', visible: true },
				{ key: 5, label: '对方账号', prop: 'targetBankNo', visible: true },
				{ key: 6, label: '对方开户行', prop: 'targetBankName', visible: true },
				{
					key: 7,
					label: '我方支付账户',
					prop: 'selfAcountsName',
					visible: true
				},
				{ key: 8, label: '我方账号', prop: 'selfBankNo', visible: true },
				{ key: 9, label: '我方开户行', prop: 'selfBankName', visible: true },
				{ key: 10, label: '支付押金时间', prop: 'futuresDate', visible: true },
				{ key: 11, label: '事由', prop: 'reason', visible: true }
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
			queryBank: '',

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
		TableName() {
			return TableName;
		},
		...mapGetters(['tempLendMoneyList'])
	},
	methods: {
		listCompany,
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
		// 点击收回资金按钮
		handleGetBackMoney(row) {
			// 初始化表的信息
			this.initReviveMoneyTableInfo(
				row.id,
				ReceiveType.LEND_MONEY_GET_BACK,
				TableName.LEND_MONEY
			);
			// 初始化对方账户信息
			this.initReviveMoneyOtherAccountInfo(
				row.targetAcountsName,
				row.targetBankNo,
				row.targetBankName
			);
			// 打开添加借出款收回的信息弹窗
			this.giveRecoverMoneyShow = true;
			this.recoverMoneyEntity.futuresNO = row.futuresNO; // 初始化uuid
			// 赋值收款信息
			this.initComment('借出款收回');
		},
		changeOpen() {
			this.needMoney = 0;
			this.applyDialogVisible = false;
			this.getList();
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
		// 收回资金的搜索按钮自动填充方法
		handleUpdateQueryBankAcountForm(val) {
			this.queryBank = val;
		},
		handleCommitBackBankAcountForm(val) {
			// 初始化我方账户信息
			this.initReviveMoneySelfAccountInfo(
				val.acountsName,
				val.bankNo,
				val.bankName,
				val.id
			);
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
				if (
					this.timesQuery.beginTime !== '' &&
					this.timesQuery.endTime !== ''
				) {
					if (this.timesQuery.objectType !== '') {
						return (
							time_search >= time_start &&
							time_search <= time_end &&
							item.targetType === this.timesQuery.objectType
						);
					} else {
						return time_search >= time_start && time_search <= time_end;
					}
				} else {
					return item.targetType === this.timesQuery.objectType;
				}
			});
		},

		//
		handleCommitBack(val) {
			this.form.targetBankNo = val.bankNo;
			this.form.targetBankName = val.bankName;
			this.form.targetAcountsName = val.acountsName;
		},
		//
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		},
		//
		handleCommitBackSelf(val) {
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankName = val.bankName;
			this.form.selfAcountsName = val.acountsName;
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
		// 表单重置
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
						// 添加的时候 要注明type为 押金
						addLendMoney({ ...this.form, type: '押金' }).then(response => {
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
