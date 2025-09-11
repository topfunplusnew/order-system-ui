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
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose" :append-to-body="true" size="55%">
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
										<template v-if="getEndorserActionType === 'payment'">
											>
											<el-radio v-model="form.reason" label="出售">出售</el-radio>
											<el-radio v-model="form.reason" label="对外付款">对外付款</el-radio>
										</template>
										<template v-if="getEndorserActionType === 'receive'">
											>
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
															// 这里给的户名
															form.endorserName = value.acountsName;
															form.origin = PUBLIC_DICT_TYPE.SELF_COMPANY;
															form.endorser = value.id;
														}
													"
													@update:queryName="value => (companyName = value)"
												>
													<template #table-columns>
														<el-table-column
															:label="form.targetType === '其他' || form.targetType === '员工' ? '名称' : form.targetType"
															align="center"
															prop="acountsName"
														/>
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
															form.endorserName = value.companyName;
															form.origin = value.companyType;
															form.endorser = value.id;
														}
													"
												>
													<template #table-columns>
														<el-table-column :label="type" align="center" prop="companyName" />
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
														form.billAccount = value.acountsName;
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
								<el-button @click="() => (drawer = false)">关 闭</el-button>
								<el-button @click="resetAcceptanceForm">重 置</el-button>
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
		// Vuex getters 映射
		...mapGetters(['bankAcceptanceDualSelectionState', 'bankAcceptanceHasSelection', 'bankAcceptanceBothSelected', 'bankAcceptanceShouldShowDrawer']),
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
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
			bankacceptanceInfo: {},
			hasBankAcceptanceInfo: false,
			// 统一存储键，用于检查是否已填写过承兑信息
			bankAcceptanceFilledKey: 'bankAcceptanceFilled',
			// 承兑表单数据
			form: {},
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
		this.$bus.$on('changeFlag', value => {
			if (this.baned) {
				this.flag = false;
				return;
			}
			if (!value) {
				if (this.protectOnError && this.bankacceptanceInfo && Object.keys(this.bankacceptanceInfo).length > 0) {
					const hasValidContent = this.bankacceptanceInfo.billNo || this.bankacceptanceInfo.billAmount || this.bankacceptanceInfo.billDate || this.bankacceptanceInfo.dueDate;
					if (hasValidContent) {
						return;
					}
				}
				this.flag = value;
				this.clearAcceptanceFillStatus();
				return;
			}
			// 获取承兑信息
			getBankAcceptance(value).then(res => {
				if (res.data) {
					this.hasBankAcceptanceInfo = true;
					this.bankacceptanceInfo = res.data;
				}
				this.flag = true;
			});
		});
	},
	watch: {
		selectType(newVal) {
			this.localSelectType = newVal;
		},
		isInternalTransfer: {
			handler(val) {
				if (val) {
					// 内部转账时默认设置为己方公司
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
				return this.bankAcceptanceShouldShowDrawer && this.bankAcceptanceHasSelection;
			} else {
				return true;
			}
		},
		// 承兑信息按钮文本
		acceptanceButtonText() {
			return this.flag && this.hasBankAcceptanceInfo ? '修改承兑信息' : '填写承兑信息';
		},
		// 统一的承兑信息处理方法
		handleAcceptanceInfo() {
			if (this.baned) {
				return;
			}
			this.resetAcceptanceForm();
			if (this.hasBankAcceptanceInfo) {
				this.form = _.cloneDeep(this.bankacceptanceInfo);
			}
			this.drawer = true;
		},
		// 获取事由类型标签（背书事由 或 收票事由）
		getEndorserTypeLabel() {
			if (this.isInternalTransfer && this.waitForBothSelection && this.componentRole) {
				// 内部转账场景：根据新的业务规则判断
				if (this.isEndorserScenario) {
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
				if (this.isEndorserScenario) {
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
			const accountTypes = this.bankAcceptanceDualSelectionState;
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
			if (this.isEndorserScenario) {
				return '背书人类型';
			} else {
				return '被背书人类型';
			}
		},

		// 获取背书人标签（被背书人 或 背书人）
		getEndorserPersonLabel() {
			if (this.isEndorserScenario) {
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
				if (this.isEndorserScenario) {
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
				const accountTypes = this.bankAcceptanceDualSelectionState;
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
			sessionStorage.setItem(this.bankAcceptanceFilledKey, JSON.stringify(this.bankacceptanceInfo));
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
				this.resetDualSelection(this.formId);
			}
		},
		// 用于在确实需要清空承兑信息时调用，绕过错误保护机制
		forceClearAcceptanceInfo() {
			this.flag = false;
			this.bankacceptanceInfo = {};
			this.clearAcceptanceFillStatus();
			this.resetAcceptanceForm();
		},
		// **新增：完整的组件状态重置方法**
		resetComponentState() {
			// 重置本地状态
			this.localSelectType = null;
			this.flag = false;
			this.bankacceptanceInfo = {};
			this.drawer = false;
			this.resetAcceptanceForm();
			this.clearAcceptanceFillStatus();
			// 如果是双选择模式，清除对应的角色状态
			if (this.waitForBothSelection && this.componentRole) {
				this.clearRoleSelection({
					role: this.componentRole,
					formId: this.formId
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
			if (this.waitForBothSelection && this.componentRole) {
				this.handleDualSelectionMode(value);
			} else {
				this.handleSingleSelectionMode(value);
			}
		},

		handleDualSelectionMode(value) {
			// 更新 Vuex 状态
			this.setAccountTypeSelection({
				role: this.componentRole,
				accountType: value,
				formId: this.formId
			});

			// 检查是否应该自动打开抽屉（基于 Vuex 计算属性）
			this.$nextTick(() => {
				if (this.bankAcceptanceShouldShowDrawer && !this.baned) {
					// 检查是否已有承兑信息
					const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
					if (json) {
						// 恢复已保存的承兑信息
						this.bankacceptanceInfo = JSON.parse(json);
						this.flag = true;
						// 通知父组件已有承兑信息
						this.$emit('updateBankAcceptance', _.cloneDeep(this.bankacceptanceInfo));
					}
				}
			});
		},

		handleSingleSelectionMode(value) {
			// 单选择模式：选择承兑类型时的处理
			if (BankAcceptanceType.ACCEPTANCE === value) {
				if (this.baned) {
					return;
				}

				const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
				// 检查是否已经填写过承兑信息
				if (json) {
					// 从sessionStorage恢复已保存的承兑信息
					this.bankacceptanceInfo = JSON.parse(json);
					this.flag = true;
					// 通知父组件已有承兑信息
					this.$emit('updateBankAcceptance', _.cloneDeep(this.bankacceptanceInfo));
				}
				this.drawer = true;
			}
		},
		// 右侧滑窗的提交逻辑（原handleSubmit方法）
		handleSubmit(value) {
			// 新扔一个emit 给父组件用
			this.$emit('updateBankAcceptance', _.cloneDeep(value));
			this.flag = true;
			this.drawer = false;
			// 标记有承兑信息
			this.hasBankAcceptanceInfo = true;
			this.bankacceptanceInfo = value;
			// 保存数据到sessionStorage
			this.setAcceptanceFilled();
			this.$message.success('承兑信息保存成功');
		},
		// 抽屉关闭的逻辑
		handleClose(done) {
			done();
		},
		handleAssign(value) {
			this.$emit('updateBankAcceptance', value);
		},
		// 承兑表单相关方法
		// 获取票据信息
		getBankAcceptanceDate(e) {
			let inputValue;

			// 处理两种调用方式：
			// 1. 从事件对象中获取值 (模板中的 @blur 事件)
			// 2. 直接传入字符串值 (watch 中的直接调用)
			if (typeof e === 'string') {
				// 直接传入的字符串
				inputValue = e;
			} else if (e && e.target && e.target.value !== undefined) {
				// 事件对象
				inputValue = _.cloneDeep(e.target.value);
			} else {
				return;
			}

			if (!inputValue) {
				this.$message.error('票据号码为空,填充失败');
				return;
			}
			// 如果是修改 不用获取
			if (this.form.id != null) {
				return;
			}
			// 在这里 发送请求 获取三个时间 自动填充
			getMinIdByBillNo(inputValue).then(res => {
				if (!res.data) {
					this.$message.error('该票据不存在,自动填充时间失败');
					return;
				}
				const obj = _.cloneDeep(res.data);
				// 填充三个时间
				this.$nextTick(() => {
					this.form.issueDate = obj.issueDate;
					this.form.dueDate = obj.dueDate;
					this.form.billAccount = obj.billAccount;
				});
			});
		},
		// 提交承兑表单
		submitAcceptanceForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.waitForBothSelection && this.bankAcceptanceBothSelected) {
						const accountTypes = this.bankAcceptanceDualSelectionState;
						if (accountTypes && accountTypes.source === BankAcceptanceType.ACCEPTANCE && accountTypes.target === BankAcceptanceType.ACCEPTANCE) {
							this.form.billType = '收入';
						} else {
							this.form.billType = this.billType;
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
				}
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
		}
	},
	created() {
		// 重置表单
		this.resetAcceptanceForm();
	},
	beforeDestroy() {
		// 组件销毁时清除当前组件的sessionStorage
		sessionStorage.removeItem(this.bankAcceptanceFilledKey);
		// 移除总线事件监听
		this.$bus.$off('changeFlag');
		// 清除双选择状态（当组件销毁时）
		if (this.waitForBothSelection && this.componentRole) {
			// 清除当前角色的选择状态
			this.clearRoleSelection({
				role: this.componentRole,
				formId: this.formId
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
