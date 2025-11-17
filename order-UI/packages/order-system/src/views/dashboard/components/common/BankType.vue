<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div style="display: flex; align-items: center; gap: 4px">
		<div class="select-container">
			<el-select :disabled="optionBaned" v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType" style="width: 140px">
				<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label" :value="item.value" />
			</el-select>
		</div>
		<div class="button-container">
			<!-- 承兑信息按钮：根据是否已填写信息显示不同状态 -->
			<el-button v-if="showAcceptanceButton()" size="small" @click="handleAcceptanceInfo">
				{{ acceptanceButtonText() }}
			</el-button>
		</div>
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose" :append-to-body="true" :close-on-click-modal="false" size="55%">
			<!-- 内嵌的承兑表单 -->
			<div>
				<div class="bank-body">
					<el-form ref="form" :model="form" :rules="rules" label-width="140px">
						<el-row>
							<el-col :span="12">
								<el-form-item label="票据号码" prop="billNo">
									<el-input v-model="form.billNo" placeholder="请输入票据号码" @blur="getBankAcceptanceDate" />
								</el-form-item>
								<el-form-item :label="`${getEndorserTypeLabel()}事由`" prop="reason">
									<template v-if="isInternalTransfer">
										<!-- 内部转账场景下的选项 -->
										<el-radio v-model="form.reason" label="内部转账">内部转账</el-radio>
										<el-radio v-model="form.reason" label="其他">其他</el-radio>
									</template>
									<template v-else>
										<template v-if="getEndorserActionType() === 'payment'">
											<el-radio v-model="form.reason" label="出售">出售</el-radio>
											<el-radio v-model="form.reason" label="对外付款">对外付款</el-radio>
										</template>
										<template v-if="getEndorserActionType() === 'receive'">
											<el-radio v-model="form.reason" label="购买">购买</el-radio>
											<el-radio v-model="form.reason" label="客户付款">客户付款</el-radio>
										</template>
									</template>
								</el-form-item>
								<el-form-item :label="`${getEndorserPersonTypeLabel()}`" prop="origin">
									<template v-if="isInternalTransfer">
										<!-- 内部转账场景下不可更改背书人类型 -->
										<el-radio v-model="type" label="己方公司" disabled>己方公司</el-radio>
									</template>
									<template v-else>
										<el-radio v-model="type" label="客户">客户</el-radio>
										<el-radio v-model="type" label="供应商">供应商</el-radio>
									</template>
								</el-form-item>
								<el-form-item :label="`${getEndorserPersonLabel()}`" prop="endorserName">
									<el-row>
										<el-col :span="20">
											<el-input :disabled="isInternalTransfer || !isInternalTransfer" :placeholder="`请输入${getEndorserPersonLabel()}`" v-model="form.endorserName" />
										</el-col>
										<el-col :span="4">
											<!--    如果是内部转账,那么就选择的是己方公司-->
											<template v-if="isInternalTransfer">
												<SearchOption
													title="我方账户"
													:get-data="listBankAccount"
													icon="el-icon-search"
													:limit-info="{
														acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY
													}"
													query-label="户名查找"
													query-info="acountsName"
													:query-name="companyName"
													@commitBack="
														value => {
															this.$set(this.form, 'endorserName', value.acountsName);
															this.$set(this.form, 'origin', PUBLIC_DICT_TYPE.SELF_COMPANY);
															this.$set(this.form, 'endorser', value.id);
														}
													"
													@update:queryName="value => (companyName = value)"
												>
													<template #table-columns>
														<el-table-column :label="form.targetType === '其他' || form.targetType === '员工' ? '名称' : form.targetType" align="center" prop="acountsName" />
														<el-table-column label="开户行" align="center" prop="bankName" />
														<el-table-column label="开户名" align="center" prop="acountsName" />
														<el-table-column label="账号" align="center" prop="bankNo" />
													</template>
												</SearchOption>
											</template>
											<template v-else>
												<!-- 选择的是客户或者供应商名称-->
												<SearchOption
													:limit-info="{ companyType: type }"
													:get-data="listCompany"
													query-info="companyName"
													query-label="公司名称"
													:query-name="companyName"
													@update:queryName="value => (companyName = value)"
													@commitBack="
														value => {
															// 使用 $set 确保响应式更新
															this.$set(this.form, 'endorserName', value.companyName);
															this.$set(this.form, 'origin', value.companyType);
															this.$set(this.form, 'endorser', value.id);
														}
													"
												>
													<template #table-columns>
														<el-table-column :label="type" align="center" prop="companyName" width="200" />
														<el-table-column label="老板姓名" align="center" prop="leader" />
														<el-table-column label="老板电话" align="center" prop="leaderTel" />
														<el-table-column label="区域" align="center" prop="region" />
														<el-table-column label="销售经理" align="center" prop="salesManager" />
													</template>
												</SearchOption>
											</template>
										</el-col>
									</el-row>
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel()}票据金额`" prop="billAmount">
									<el-input v-model="form.billAmount" placeholder="请输入票据金额" />
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel()}贴息点数`" prop="inDiscountPoints">
									<el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数" />
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel()}贴息金额`" prop="inDiscountAmount">
									<el-input disabled v-model="form.inDiscountAmount" placeholder="请输入贴息金额" />
								</el-form-item>
							</el-col>
							<el-col :span="12">
								<el-form-item label="票据种类" prop="billCategory">
									<el-radio v-model="form.billCategory" label="电子">电子</el-radio>
									<el-radio v-model="form.billCategory" label="纸质">纸质</el-radio>
								</el-form-item>
								<el-form-item label="我方承兑账户" prop="billAccount">
									<el-row>
										<el-col :span="20">
											<el-input disabled v-model="form.billAccount" placeholder="请输入我方承兑账户" />
										</el-col>
										<el-col :span="4">
											<SearchOption
												:get-data="listBankAccount"
												:limit-info="{
													acountsType: '己方公司'
												}"
												title="我方承兑账户"
												query-label="户名查找"
												query-info="acountsName"
												:query-name="queryBank"
												@commitBack="
													value => {
														this.$set(this.form, 'billAccount', value.acountsName);
														this.$set(this.form, 'billAccountId', value.id);
													}
												"
												@update:queryName="value => (queryBank = value)"
											>
												<template #table-columns>
													<el-table-column label="己方公司" align="center" prop="displayName" />
													<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
													<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
													<el-table-column label="开户行" align="center" prop="bankName" />
												</template>
											</SearchOption>
										</el-col>
									</el-row>
								</el-form-item>
								<el-form-item label="票据交易日期" prop="billDate">
									<el-date-picker v-model="form.billDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
								</el-form-item>
								<el-form-item label="出票日期" prop="issueDate">
									<el-date-picker v-model="form.issueDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
								</el-form-item>
								<el-form-item label="到期日期" prop="dueDate">
									<el-date-picker v-model="form.dueDate" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
								</el-form-item>
								<el-form-item label="备注" prop="comments">
									<el-input v-model="form.comments" placeholder="请输入备注" />
								</el-form-item>
							</el-col>
						</el-row>

						<div class="footer">
							<div class="footer-box">
								<el-button type="primary" @click="submitAcceptanceForm">确 定</el-button>
								<el-button @click="handleResetAcceptanceForm">重 置</el-button>
							</div>
						</div>
					</el-form>
				</div>
			</div>
		</el-drawer>
	</div>
</template>

<script>
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { BankAcceptanceType, PaymentState } from '@/api/tool/enums';
import { getBankAcceptance, getMinIdByBillNo } from '@/api/system/bankAcceptance';
import _ from 'lodash';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { mapGetters, mapActions } from 'vuex';
import dayjs from 'dayjs';

export default {
	name: 'BankType',
	components: { SearchOption },
	dicts: ['order_bank_card_type_nodel'],
	computed: {
		// Vuex getters 映射 - 银行承兑双选择状态管理
		...mapGetters('bankAcceptance', ['dualSelectionState', 'hasAcceptanceSelection', 'bothSelectedInDualMode', 'shouldShowAcceptanceDrawerInDualMode']),
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		},
		// 生成唯一的组件标识符
		componentId() {
			return `${this.formId}_${this.componentRole || 'default'}`;
		}
	},
	// 对于不需要选择的场景，设置optionBaned = true  banned= true
	props: {
		// 禁用选择
		optionBaned: {
			type: Boolean,
			default: false
		},
		// 已经选择的
		selectType: {
			type: String,
			default: null
		},
		// 是否禁用承兑右侧滑窗
		baned: {
			type: Boolean,
			default: false
		},
		billType: {
			type: String,
			default: '收入'
		},
		// 是否为内部转账
		isInternalTransfer: {
			type: Boolean,
			default: false
		},
		// 唯一标识，用于区分不同表单实例
		formId: {
			type: String,
			default: () => `bank-type-${Date.now()}`
		},
		// 是否需要等待业务全部选择（两个账户类型都选择承兑时才打开弹窗）
		waitForBothSelection: {
			type: Boolean,
			default: false
		},
		// 当前组件的角色（用于区分支出/收入）
		componentRole: {
			type: String,
			default: '', // 'source' 或 'target'
			validator: value => ['', 'source', 'target'].includes(value)
		},
		// 是否在出错时保护承兑信息不被清空（防止用户数据丢失）
		protectOnError: {
			type: Boolean,
			default: true
		}
	},
	data() {
		return {
			localSelectType: null,
			// 右侧抽屉
			drawer: false,
			flag: false,
			// 是否有已保存的承兑信息
			hasSavedAcceptanceInfo: false,
			// 统一存储键，用于检查是否已填写过承兑信息
			bankAcceptanceFilledKey: 'bankAcceptanceFilled',
			// 承兑表单数据 - 确保所有字段都预先定义，避免响应式问题
			form: {
				id: null,
				operateDate: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billAccountId: null, // 我方承兑账户的银行卡ID
				billDate: null,
				billType: null,
				reason: null,
				billAmount: null,
				inDiscountPoints: null,
				inDiscountAmount: null,
				billCategory: '电子',
				origin: null,
				endorserName: null,
				endorser: null,
				endorseReason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			},
			// 双选择状态管理键（用于内部转账账户类型选择状态）
			bothSelectionKey: 'internalTransferAccountTypeSelection',
			// 表单校验规则
			rules: {
				billNo: [
					{
						required: true,
						message: '请输入票据号码',
						trigger: 'blur'
					}
				],
				dueDate: [
					{
						required: true,
						message: '请输入到期日期',
						trigger: 'blur'
					}
				],
				reason: [
					{
						required: true,
						message: '请选择事由',
						trigger: 'change'
					}
				],
				issueDate: [
					{
						required: true,
						message: '请输入出票日期',
						trigger: 'blur'
					}
				],
				billCategory: [
					{
						required: true,
						message: '请选择票据分类',
						trigger: 'change'
					}
				],
				endorseReason: [
					{
						required: true,
						message: '请输入背书事由',
						trigger: 'blur'
					}
				],
				origin: [
					{
						required: true,
						message: '请选择票据来源',
						trigger: 'blur'
					}
				],
				// 添加校验
				billAccount: [
					{
						required: true,
						message: '请选择我方承兑账户',
						trigger: 'blur'
					}
				],
				billType: [
					{
						required: true,
						message: '请选择票据种类',
						trigger: 'change'
					}
				],
				billDate: [
					{
						required: true,
						message: '请选择票据日期',
						trigger: 'change'
					}
				],
				billAmount: [
					{
						required: true,
						message: '请输入票据金额',
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
				inDiscountPoints: [
					{
						required: true,
						message: '请输入贴息点数',
						trigger: 'blur'
					},
					// 金额校验
					{
						validator: (rule, value, callback) => {
							if (!/^\d+(\.\d{1,4})?$/.test(value)) {
								callback(new Error('金额只能为数字且小数点后最多四位'));
							} else if (parseFloat(value) > 1) {
								callback(new Error('贴息点数不能超过 1'));
							} else {
								callback();
							}
						},
						trigger: 'blur'
					}
				],
				endorserName: [
					{
						required: true,
						message: '请输入背书人或被背书人',
						trigger: 'blur'
					}
				],
				inDiscountAmount: [
					{
						required: true,
						message: '请输入贴息金额',
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
				]
			},
			queryBank: '',
			// 背书人类型 默认为客户，内部转账时为己方公司
			type: '客户',
			// 搜索客户
			companyName: ''
		};
	},
	mounted() {
		this.clearAllAcceptanceStatus();
		this.localSelectType = this.selectType;
		if (this.isInternalTransfer) {
			this.type = '己方公司';
		}
		console.log(`开始注册监听器`);
		// 使用命名函数，方便后续移除监听器
		this.handleChangeFlag = (value) => {
			console.log(`value`, value);
			if (this.baned) {
				this.flag = false;
				return;
			}
			if (!value) {
				if (this.protectOnError) {
					return;
				}
				this.flag = value;
				this.clearAcceptanceFillStatus();
				return;
			}
			// 立即设置 flag 为 true，表示正在处理承兑信息（避免异步请求期间状态不正确）
			this.flag = true;
			// 获取承兑信息
			getBankAcceptance(value).then(res => {
				this.$nextTick(() => {
					if (res.data) {
						console.log(res.data, 'res.data');
						this.hasSavedAcceptanceInfo = true;
						// 将获取到的数据保存到sessionStorage
						sessionStorage.setItem(this.bankAcceptanceFilledKey, JSON.stringify(res.data));
						// 从sessionStorage更新表单数据
						this.loadSavedFormFromSession();
						// 通知父组件更新状态
						this.$emit('updateBankAcceptance', _.cloneDeep(res.data));
					} else {
						// 如果没有数据，重置状态
						this.hasSavedAcceptanceInfo = false;
						this.flag = false;
					}

					console.log(`this.flag`, this.flag);
					console.log(`this.hasSavedAcceptanceInfo`, this.hasSavedAcceptanceInfo);
				});
			}).catch(error => {
				// 请求失败时重置状态
				console.error('获取承兑信息失败:', error);
				this.flag = false;
				this.hasSavedAcceptanceInfo = false;
			});
		};
		// 注册事件监听器
		this.$bus.$on('changeFlag', this.handleChangeFlag);
	},
	watch: {
		selectType(newVal) {
			this.localSelectType = newVal;
		},
		isInternalTransfer: {
			handler(val) {
				if (val) {
					this.type = '己方公司';
				}
			},
			immediate: true
		},
		form: {
			handler() {
				this.form.inDiscountAmount = Number(this.form.billAmount * this.form.inDiscountPoints).toFixed(2);
			},
			deep: true
		}
	},
	methods: {
		// Vuex actions 映射
		...mapActions('bankAcceptance', ['setAccountTypeSelection', 'resetDualSelection', 'clearRoleSelection']),
		listBankAccount,
		listCompany,
		// 控制承兑信息按钮的显示
		showAcceptanceButton() {
			if (this.baned || !this.localSelectType) {
				return false;
			}
			// 如果不是承兑类型，不显示按钮
			if (!this.localSelectType || this.localSelectType !== BankAcceptanceType.ACCEPTANCE) {
				return false;
			}

			if (this.waitForBothSelection) {
				return this.shouldShowAcceptanceDrawerInDualMode && this.hasAcceptanceSelection;
			} else {
				return true;
			}
		},
		// 承兑信息按钮文本
		acceptanceButtonText() {
			console.log(this.flag, this.hasSavedAcceptanceInfo);
			// 如果有正式保存的承兑信息
			if (this.flag && this.hasSavedAcceptanceInfo) {
				console.log(`修改承兑信息`, this.flag, this.hasSavedAcceptanceInfo);
				return '修改承兑信息';
			}
			// 默认状态
			return '填写承兑信息';
		},
		// 统一的承兑信息处理方法
		handleAcceptanceInfo() {
			if (this.baned) {
				return;
			}
			// 重置票据信息表单
			this.resetAcceptanceForm();
			// 如果有已保存的承兑信息，则从sessionStorage加载
			if (this.hasSavedAcceptanceInfo) {
				this.loadSavedFormFromSession();
			}
			// 内部转账时自动填充承兑表单字段
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				this.autoFillAcceptanceFormForInternalTransfer();
			}
			this.drawer = true;
		},
		// 获取事由类型标签（背书事由 或 收票事由）
		getEndorserTypeLabel() {
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				// 内部转账场景：根据新的业务规则判断
				if (this.isEndorserScenario()) {
					// 支出方银行活期存款 -> 收入方承兑：背书事由
					return '背书';
				} else {
					// 其他所有情况：收票事由
					return '收票';
				}
			}
			// 原有逻辑
			return this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '背书' : '收票';
		},

		// 获取动作类型（payment 或 receive）
		getEndorserActionType() {
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				// 内部转账场景：根据新的业务规则判断
				if (this.isEndorserScenario()) {
					// 支出方银行活期存款 -> 收入方承兑：收款动作
					return 'receive';
				} else {
					// 其他所有情况：付款动作
					return 'payment';
				}
			}
			// 原有逻辑
			return this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? 'payment' : 'receive';
		},
		isEndorserScenario() {
			if (!this.isInternalTransfer || !this.waitForBothSelection || !this.componentRole) {
				return this.billType !== BankAcceptanceType.PAY_TYPE.PAYMENT;
			}
			const accountTypes = this.dualSelectionState;
			if (!accountTypes || typeof accountTypes !== 'object') {
				return false;
			}
			if (!accountTypes.source || !accountTypes.target) {
				return false;
			}
			const validAccountTypes = [BankAcceptanceType.BANK_CASH, BankAcceptanceType.ACCEPTANCE];
			if (!validAccountTypes.includes(accountTypes.source) || !validAccountTypes.includes(accountTypes.target)) {
				return false;
			}
			const isSourceBankCashAndTargetAcceptance = accountTypes.source === BankAcceptanceType.BANK_CASH && accountTypes.target === BankAcceptanceType.ACCEPTANCE;
			return isSourceBankCashAndTargetAcceptance;
		},

		// 获取背书人类型标签（被背书人类型 或 背书人类型）
		getEndorserPersonTypeLabel() {
			if (this.isEndorserScenario()) {
				return '背书人类型';
			} else {
				return '被背书人类型';
			}
		},

		// 获取背书人标签（被背书人 或 背书人）
		getEndorserPersonLabel() {
			if (this.isEndorserScenario()) {
				// 背书人场景
				return '背书人';
			} else {
				// 被背书人场景（包含所有其他情况）
				return '被背书人';
			}
		},
		// 获取金额方向标签（支出 或 收入）
		getAmountDirectionLabel() {
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				// 内部转账场景：根据新的业务规则判断
				if (this.isEndorserScenario()) {
					// 支出方银行活期存款 -> 收入方承兑：收入
					return '收入';
				} else {
					// 其他所有情况：支出
					return '支出';
				}
			}
			// 原有逻辑
			return this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '支出' : '收入';
		},
		// 获取我方承兑账户的标识（用于确定应该显示哪个账户作为承兑账户）
		getMyAcceptanceAccount() {
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				const accountTypes = this.dualSelectionState;
				if (accountTypes) {
					const currentType = this.localSelectType;
					const otherRole = this.componentRole === 'source' ? 'target' : 'source';
					const otherType = accountTypes[otherRole];

					// 根据业务逻辑判断我方承兑账户是哪个
					if (currentType === BankAcceptanceType.BANK_CASH && otherType === BankAcceptanceType.ACCEPTANCE) {
						// A账户现金到A账户承兑 -> 我方承兑账户是A账户
						return 'current'; // 当前账户
					} else if (currentType === BankAcceptanceType.ACCEPTANCE && otherType === BankAcceptanceType.BANK_CASH) {
						// B账户承兑到B账户现金 -> 我方承兑账户是B账户
						return 'current'; // 当前账户
					} else if (currentType === BankAcceptanceType.ACCEPTANCE && otherType === BankAcceptanceType.ACCEPTANCE) {
						// C账户承兑到D账户承兑 -> 根据角色确定
						if (this.componentRole === 'source') {
							// C付款，我方承兑账户是C
							return 'current';
						} else {
							// D收款，我方承兑账户是D
							return 'current';
						}
					}
				}
			}
			// 默认返回当前账户
			return 'current';
		},
		// 设置已填写承兑信息状态
		setAcceptanceFilled() {
			sessionStorage.setItem(this.bankAcceptanceFilledKey, JSON.stringify(this.form));
		},
		// 清除承兑信息填写状态
		clearAcceptanceFillStatus() {
			sessionStorage.removeItem(this.bankAcceptanceFilledKey);
		},
		// 清除所有共享状态
		clearAllAcceptanceStatus() {
			sessionStorage.removeItem(this.bankAcceptanceFilledKey);
			// 如果需要等待双选择，也清除双选择状态
			if (this.waitForBothSelection) {
				this.resetDualSelection();
			}
		},
		// 用于在确实需要清空承兑信息时调用，绕过错误保护机制
		forceClearAcceptanceInfo() {
			this.flag = false;
			this.clearAcceptanceFillStatus();
			this.resetAcceptanceForm();
		},
		// **新增：完整的组件状态重置方法**
		resetComponentState() {
			// 重置本地状态 - 优先使用 selectType prop 的值（父组件传入的默认值）
			this.localSelectType = this.selectType || null;
			this.flag = false;
			this.drawer = false;
			this.resetAcceptanceForm();
			this.clearAcceptanceFillStatus();

			// 如果是双选择模式，清除对应的角色状态
			if (this.waitForBothSelection && this.componentRole) {
				this.clearRoleSelection({
					role: this.componentRole
				});
			}
		},
		handleEmitType(value) {
			if (value !== BankAcceptanceType.ACCEPTANCE) {
				this.clearAcceptanceFillStatus();
			}
			// 通知父组件更新
			this.$emit('updateBankAcceptance', null);
			this.$emit('updateSelectedType', value);
			// 如果是双选择模式
			if (this.waitForBothSelection && this.componentRole) {
				this.handleDualSelectionMode(value);
			} else {
				this.handleSingleSelectionMode(value);
			}
		},
		// 处理双选择模式的逻辑
		handleDualSelectionMode(value) {
			// 更新 Vuex 状态
			this.setAccountTypeSelection({
				role: this.componentRole,
				accountType: value,
				formId: this.formId
			});
			// 检查是否双方都已选择完成且有承兑选择，然后再弹窗
			this.$nextTick(() => {
				// 使用 Vuex store 中的计算逻辑：只有双方都选择完成且有承兑选择时才显示抽屉
				if (this.shouldShowAcceptanceDrawerInDualMode && !this.baned && !this.drawer) {
					this.checkAndRestoreSessionData();
					this.handleAcceptanceInfo();
				}
			});
		},
		// 从sessionStorage恢复承兑信息
		loadSavedFormFromSession() {
			const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
			if (json) {
				const savedData = JSON.parse(json);
				this.form = _.cloneDeep(savedData);
				this.hasSavedAcceptanceInfo = true;
				// 通知父组件已有承兑信息
				this.$emit('updateBankAcceptance', _.cloneDeep(savedData));
			}
		},

		// 检查并恢复sessionStorage中的承兑信息
		checkAndRestoreSessionData() {
			const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
			if (json) {
				const savedData = JSON.parse(json);
				this.hasSavedAcceptanceInfo = true;
				// 通知父组件已有承兑信息
				this.$emit('updateBankAcceptance', _.cloneDeep(savedData));
				return true;
			}
			return false;
		},
		handleSingleSelectionMode(value) {
			// 单选择模式：选择承兑类型时的处理
			if (BankAcceptanceType.ACCEPTANCE === value) {
				if (this.baned) {
					return;
				}
				// 检查是否已经填写过承兑信息
				if (this.checkAndRestoreSessionData()) {
					this.flag = true;
				}
				// 自动打开承兑信息填写抽屉
				this.handleAcceptanceInfo();
			}
		},
		// 右侧滑窗的提交逻辑（原handleSubmit方法）
		handleSubmit(value) {
			// 通知父组件更新
			this.$emit('updateBankAcceptance', _.cloneDeep(value));
			this.flag = true;
			this.drawer = false;
			// 标记有承兑信息
			this.hasSavedAcceptanceInfo = true;
			// 保存数据到sessionStorage
			this.setAcceptanceFilled();
			this.$message.success('承兑信息保存成功');
		},
		// 抽屉关闭的逻辑
		handleClose(done) {
			// 当点击 drawer 外区域关闭抽屉时，自动触发确定按钮的逻辑
			this.submitAcceptanceForm()
				.then(() => {
					// 表单验证通过，提交成功，关闭抽屉
					done();
				})
				.catch(() => {
					// 表单验证失败，不关闭抽屉，提示用户
					this.$message.warning('请完善表单信息后再关闭');
				});
		},
		handleAssign(value) {
			this.$emit('updateBankAcceptance', value);
		},
		// 承兑表单相关方法
		// 获取票据信息
		getBankAcceptanceDate(e) {
			let inputValue;
			if (e && e.target && e.target.value !== undefined) {
				// 事件对象
				inputValue = _.cloneDeep(e.target.value);
			}
			if (!inputValue) {
				return;
			}
			// 在这里 发送请求 获取三个时间 自动填充
			getMinIdByBillNo(inputValue).then(res => {
				if (!res.data) {
					return;
				}
				const obj = _.cloneDeep(res.data);
				console.log(`obj`, obj);
				// 检查获取到的数据是否有效（不为空且至少有一个有效字段）
				const hasValidData = obj && ((obj.issueDate && obj.issueDate.trim() !== '') || (obj.dueDate && obj.dueDate.trim() !== '') || (obj.billAccount && obj.billAccount.trim() !== ''));
				if (!hasValidData) {
					return;
				}
				if (!obj.bankAccountId) {
					console.warn('获取到的承兑信息缺少银行卡ID，无法填充我方承兑账户ID');
					return;
				}
				// 填充三个时间，只填充非空的字段
				this.$nextTick(() => {
					// 只有当获取到的值不为空时才填充，防止覆盖用户已填写的信息
					if (obj.issueDate && obj.issueDate.trim() !== '') {
						this.form.issueDate = obj.issueDate;
					}
					if (obj.dueDate && obj.dueDate.trim() !== '') {
						this.form.dueDate = obj.dueDate;
					}
					if (obj.billAccount && obj.billAccount.trim() !== '') {
						this.form.billAccount = obj.billAccount;
					}
					if (obj.bankAccountId) {
						// 这里使用后端返回的银行卡id来填充
						this.form.billAccountId = obj.bankAccountId;
						// TODO 特殊处理 后端在冲抵款的时候需要银行卡id
						this.form.bankAccountId = obj.bankAccountId;
					}
				});
			});
		},
		// 提交承兑表单
		submitAcceptanceForm() {
			return new Promise((resolve, reject) => {
				this.$refs['form'].validate(valid => {
					if (valid) {
						// 判断 billType 的逻辑
						if (this.waitForBothSelection && this.bothSelectedInDualMode) {
							const accountTypes = this.dualSelectionState;
							// 如果双方都是承兑，设置为"收入"
							if (accountTypes && accountTypes.source === BankAcceptanceType.ACCEPTANCE && accountTypes.target === BankAcceptanceType.ACCEPTANCE) {
								this.form.billType = '收入';
							} else {
								// 如果任意一方是承兑
								if (this.localSelectType === BankAcceptanceType.ACCEPTANCE) {
									// 如果是资金流入方（target/收入方）选择承兑，设置为"收入"
									if (this.componentRole === 'target') {
										this.form.billType = '收入';
									}
									// 如果是资金流出方（source/支出方）选择承兑，设置为"支出"
									else if (this.componentRole === 'source') {
										this.form.billType = '支出';
									} else {
										this.form.billType = this.billType;
									}
								} else {
									this.form.billType = this.billType;
								}
							}
						} else {
							this.form.billType = this.billType;
						}
						if (this.isInternalTransfer) {
							this.form.reason = '内部转账';
						}
						this.form = excludeParams(this.form, this.$exclude);
						const storageKey = 'bankAcceptanceFilled';
						sessionStorage.setItem(storageKey, JSON.stringify(this.form));
						sessionStorage.setItem('bankAcceptanceFilledTime', new Date().getTime());
						this.handleSubmit(_.cloneDeep(this.form));
						this.resetAcceptanceForm();
						resolve(true);
					} else {
						reject(false);
					}
				});
			});
		},
		// 重置承兑表单
		resetAcceptanceForm() {
			this.form = {
				id: null,
				operateDate: null,
				billNo: null,
				issueDate: null,
				dueDate: null,
				billAccount: null,
				billAccountId: null, // 重置我方承兑账户ID
				billDate: dayjs().format('YYYY-MM-DD HH:mm:ss'),
				billType: this.billType,
				// 内部转账时默认为内部转账，其他情况收票时默认为购买
				reason: this.isInternalTransfer ? '内部转账' : '购买',
				billAmount: null,
				inDiscountPoints: null,
				inDiscountAmount: null,
				// 票据种类默认为电子
				billCategory: '电子',
				origin: null,
				endorserName: null,
				endorser: null,
				endorseReason: null,
				comments: null,
				addtime: null,
				userId: null,
				UserName: null,
				updateTime: null,
				delFlag: null
			};
			if (this.$refs['form']) {
				this.$refs['form'].resetFields();
			}
		},

		// 处理重置承兑表单
		handleResetAcceptanceForm() {
			// 重置表单
			this.resetAcceptanceForm();
			this.$message.success('表单已重置');
		},

		/**
		 * 为内部转账自动填充承兑表单字段
		 * 根据四个场景自动填充背书人/被背书人和我方承兑账户
		 */
		autoFillAcceptanceFormForInternalTransfer() {
			// 从sessionStorage获取内部转账表单数据
			const savedDataStr = sessionStorage.getItem('internal_transfer_form_data');
			if (!savedDataStr) {
				console.warn('没有找到内部转账表单数据，无法自动填充');
				return;
			}

			try {
				const savedData = JSON.parse(savedDataStr);
				// 根据数据结构映射正确的字段
				const sourceType = savedData.selfBankCardType; // 支出方账户类型 (other)
				const targetType = savedData.otherBankCardType; // 收入方账户类型 (self)
				const targetName = savedData.targetName; // 支出方名称
				const sourceName = savedData.sourceName; // 收入方名称
				const sourceId = savedData.sourceId; // 支出方ID
				const targetId = savedData.targetId; // 收入方ID
				console.log(`自动填充承兑信息 - 支出方ID: ${sourceId}, 收入方ID: ${targetId}`);

				// 验证必要数据
				if (!sourceType || !targetType || !sourceName || !targetName) {
					return;
				}

				// 判断四种场景并自动填充
				const BankCash = BankAcceptanceType.BANK_CASH; // 银行活期存款
				const Acceptance = BankAcceptanceType.ACCEPTANCE; // 承兑

				console.log(`自动填充承兑信息 - 场景分析: 支出方${sourceType} → 收入方${targetType}`);

				// 场景判断
				if (sourceType === BankCash && targetType === Acceptance) {
					// ①A账户现金到A账户承兑
					// 相当于收款：A账户下的承兑类型账号收到一张承兑
					// 背书人是账户A, 我方承兑账户是账户A
					// 收入方承兑组件
					this.$nextTick(() => {
						this.form.endorserName = sourceName; // 背书人是支出方名称
						this.form.billAccount = targetName; // 我方承兑账户是收入方名称
						this.form.endorser = sourceId; // 背书人ID
						this.form.billAccountId = targetId; // 我方承兑账户ID
						// TODO 特殊处理 后端在冲抵款的时候需要银行卡id
						this.form.bankAccountId = targetId;
						console.log(`场景①自动填充: 背书人=${sourceName}, 我方承兑账户=${targetName}`);
					});
				} else if (sourceType === Acceptance && targetType === BankCash) {
					// ②B账户承兑到B账户现金
					// 相当于付款：B账户下的承兑类型账号支出一张承兑
					// 被背书人是账户B, 我方承兑账户是账户B
					// 支出方承兑组件
					this.$nextTick(() => {
						this.form.endorserName = targetName; // 被背书人是收入方名称
						this.form.billAccount = sourceName; // 我方承兑账户是支出方名称
						this.form.endorser = targetId; // 被背书人ID
						this.form.billAccountId = sourceId; // 我方承兑账户ID
						// TODO 特殊处理 后端在冲抵款的时候需要银行卡id
						this.form.bankAccountId = sourceId;
						console.log(`场景②自动填充: 被背书人=${targetName}, 我方承兑账户=${sourceName}`);
					});
				} else if (sourceType === Acceptance && targetType === Acceptance) {
					// ③C账户承兑到D账户承兑
					// 相当于两步：
					// 首先C付款：C账户承兑支出一张承兑
					// 被背书人是账户D, 我方承兑账户是账户C
					this.$nextTick(() => {
						this.form.endorserName = targetName; // 被背书人是收入方名称
						this.form.billAccount = sourceName; // 我方承兑账户是支出方名称
						this.form.endorser = targetId; // 被背书人ID
						this.form.billAccountId = sourceId; // 我方承兑账户ID
						// TODO 特殊处理 后端在冲抵款的时候需要银行卡id
						this.form.bankAccountId = sourceId;
						console.log(`场景③-支出自动填充: 被背书人=${targetName}, 我方承兑账户=${sourceName}`);
					});
				}
				this.$nextTick(() => {
					this.form.origin = PUBLIC_DICT_TYPE.SELF_COMPANY; // 票据来源为己方公司
				});
				console.log(`自动填充承兑信息完成 - 场景: ${sourceType} → ${targetType}`);
			} catch (error) {
				console.error('自动填充承兑信息失败:', error);
			}
		}
	},
	created() {
		// 重置表单
		this.resetAcceptanceForm();
	},
	beforeDestroy() {
		// 组件销毁时清除当前组件的sessionStorage
		sessionStorage.removeItem(this.bankAcceptanceFilledKey);
		// 移除总线事件监听（使用命名函数确保只移除当前组件的监听器）
		if (this.handleChangeFlag) {
			this.$bus.$off('changeFlag', this.handleChangeFlag);
		}
		// 清除双选择状态（当组件销毁时）
		if (this.waitForBothSelection && this.componentRole) {
			// 清除当前角色的选择状态
			this.clearRoleSelection({
				role: this.componentRole
			});
		}
	}
};
</script>

<style scoped lang="scss">
.footer {
	display: flex;
	justify-content: center;

	.footer-box {
		display: flex;
		justify-content: center;
	}
}

.bank-body {
	width: 700px;
	margin: 0 auto;
}

// 按钮容器样式
.button-container {
	display: flex;
	align-items: center;
	gap: 4px;
	flex-shrink: 0;
	margin-left: 4px;
}

// 选择框容器样式
.select-container {
	flex-shrink: 0;
	min-width: 140px;
}
</style>
