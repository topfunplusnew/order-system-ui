<!-- 通用的银行卡账户类型填充 需要配合 mixin_bankType 使用 -->

<template>
	<div style="display: flex; align-items: center; gap: 4px;">
		<div class="select-container">
			<el-select :disabled="optionBaned" v-model="localSelectType" placeholder="请选择账户类型" @change="handleEmitType"
				style="width: 140px;">
				<el-option v-for="item in dict.type.order_bank_card_type_nodel" :key="item.value" :label="item.label"
					:value="item.value" />
			</el-select>
		</div>

		<div class="button-container">
			<!-- 修改按钮：当已填写承兑信息时显示 -->
			<el-button v-if="showModifyButton" type="primary" size="small" @click="handleReopenDrawer">修改</el-button>

			<!-- 填写承兑信息按钮：当选择承兑类型但未填写信息时显示 -->
			<el-button v-if="showFillButton" type="success" size="small"
				@click="handleFillAcceptance">填写承兑信息</el-button>
		</div>
		<el-drawer ref="drawer" title="承兑信息填写" :visible.sync="drawer" direction="rtl" :before-close="handleClose"
			:append-to-body="true" size="55%">
			<!-- 内嵌的承兑表单 -->
			<div>
				<div class="bank-body">
					<el-form ref="form" :model="form" :rules="rules" label-width="140px">
						<el-row>
							<el-col :span="12">
								<el-form-item label="票据号码" prop="billNo">
									<el-input v-model="form.billNo" placeholder="请输入票据号码"
										@blur="getBankAcceptanceDate" />
								</el-form-item>
								<el-form-item :label="`${getEndorserTypeLabel}事由`" prop="reason">
									<template v-if="isInternalTransfer">
										<!-- 内部转账场景下的选项 -->
										<el-radio v-model="form.reason" label="内部转账">内部转账</el-radio>
										<el-radio v-model="form.reason" label="其他">其他</el-radio>
									</template>
									<template v-else>
										<template v-if="getEndorserActionType === 'payment'">>
											<el-radio v-model="form.reason" label="出售">出售</el-radio>
											<el-radio v-model="form.reason" label="对外付款">对外付款</el-radio>
										</template>
										<template v-if="getEndorserActionType === 'receive'">>
											<el-radio v-model="form.reason" label="购买">购买</el-radio>
											<el-radio v-model="form.reason" label="客户付款">客户付款</el-radio>
										</template>
									</template>
								</el-form-item>
								<el-form-item :label="`${getEndorserPersonTypeLabel}`" prop="origin">
									<template v-if="isInternalTransfer">
										<!-- 内部转账场景下不可更改背书人类型 -->
										<el-radio v-model="type" label="己方公司" disabled>己方公司</el-radio>
									</template>
									<template v-else>
										<el-radio v-model="type" label="客户">客户</el-radio>
										<el-radio v-model="type" label="供应商">供应商</el-radio>
									</template>
								</el-form-item>
								<el-form-item :label="`${getEndorserPersonLabel}`" prop="endorserName">
									<el-row>
										<el-col :span="20">
											<el-input :disabled="isInternalTransfer || !isInternalTransfer"
												:placeholder="`请输入${getEndorserPersonLabel}`"
												v-model="form.endorserName" />
										</el-col>
										<el-col :span="4">
											<!--    如果是内部转账,那么就选择的是己方公司-->
											<template v-if="isInternalTransfer">
												<SearchOption title="我方账户" :get-data="listBankAccount"
													icon="el-icon-search" :limit-info="{
														acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY
													}" query-label="户名查找" query-info="acountsName" :query-name="companyName" @commitBack="
														value => {
															// 这里给的户名
															form.endorserName = value.acountsName;
															form.origin = PUBLIC_DICT_TYPE.SELF_COMPANY;
															form.endorser = value.id;
														}
													" @update:queryName="value => (companyName = value)">
													<template #table-columns>
														<el-table-column
															:label="form.targetType === '其他' || form.targetType === '员工' ? '名称' : form.targetType"
															align="center" prop="acountsName" />
														<el-table-column label="开户行" align="center" prop="bankName" />
														<el-table-column label="开户名" align="center"
															prop="acountsName" />
														<el-table-column label="账号" align="center" prop="bankNo" />
													</template>
												</SearchOption>
											</template>
											<template v-else>
												<!-- 选择的是客户或者供应商名称-->
												<SearchOption :limit-info="{ companyType: type }"
													:get-data="listCompany" query-info="companyName" query-label="公司名称"
													:query-name="companyName"
													@update:queryName="value => (companyName = value)" @commitBack="
														value => {
															form.endorserName = value.companyName;
															form.origin = value.companyType;
															form.endorser = value.id;
														}
													">
													<template #table-columns>
														<el-table-column :label="type" align="center"
															prop="companyName" />
														<el-table-column label="老板姓名" align="center" prop="leader" />
														<el-table-column label="老板电话" align="center" prop="leaderTel" />
														<el-table-column label="区域" align="center" prop="region" />
														<el-table-column label="销售经理" align="center"
															prop="salesManager" />
													</template>
												</SearchOption>
											</template>
										</el-col>
									</el-row>
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel}票据金额`" prop="billAmount">
									<el-input v-model="form.billAmount" placeholder="请输入票据金额" />
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel}贴息点数`" prop="inDiscountPoints">
									<el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数" />
								</el-form-item>
								<el-form-item :label="`${getAmountDirectionLabel}贴息金额`" prop="inDiscountAmount">
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
											<SearchOption :get-data="listBankAccount" :limit-info="{
												acountsType: '己方公司'
											}" title="我方承兑账户" query-label="户名查找" query-info="acountsName" :query-name="queryBank" @commitBack="
												value => {
													form.billAccount = value.acountsName;
												}
											" @update:queryName="value => (queryBank = value)">
												<template #table-columns>
													<el-table-column label="己方公司" align="center" prop="displayName" />
													<el-table-column label="开户名称(户名)" align="center"
														prop="acountsName" />
													<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
													<el-table-column label="开户行" align="center" prop="bankName" />
												</template>
											</SearchOption>
										</el-col>
									</el-row>
								</el-form-item>
								<el-form-item label="票据交易日期" prop="billDate">
									<el-date-picker v-model="form.billDate" type="datetime" placeholder="选择日期"
										value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
								</el-form-item>
								<el-form-item label="出票日期" prop="issueDate">
									<el-date-picker v-model="form.issueDate" type="datetime" placeholder="选择日期"
										value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
								</el-form-item>
								<el-form-item label="到期日期" prop="dueDate">
									<el-date-picker v-model="form.dueDate" type="datetime" placeholder="选择日期"
										value-format="yyyy-MM-dd HH:mm:ss"></el-date-picker>
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

export default {
	name: 'BankType',
	components: { SearchOption },
	dicts: ['order_bank_card_type_nodel'],
	computed: {
		// Vuex getters 映射
		...mapGetters([
			'bankAcceptanceDualSelectionState',
			'bankAcceptanceHasSelection',
			'bankAcceptanceBothSelected',
			'bankAcceptanceShouldShowDrawer'
		]),
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		},

		// **核心业务逻辑重构**
		// 控制填写承兑信息按钮的显示
		showFillButton() {
			if (this.baned || this.flag) {
				return false;
			}

			// **边界保护：确保组件状态同步**
			if (!this.localSelectType) {
				// 如果没有选择类型，无论什么模式都不显示按钮
				return false;
			}

			if (this.waitForBothSelection) {
				// 双选择模式：需要Vuex状态管理
				// 额外检查：避免Vuex状态与本地状态不同步
				return this.bankAcceptanceShouldShowDrawer &&
					(this.localSelectType === BankAcceptanceType.ACCEPTANCE ||
						this.bankAcceptanceHasSelection);
			} else {
				// 单选择模式：直接检查当前选择
				return this.localSelectType === BankAcceptanceType.ACCEPTANCE;
			}
		},

		// 控制修改按钮的显示
		showModifyButton() {
			// 边界条件检查
			if (!this.flag || !this.localSelectType) {
				return false;
			}

			if (this.waitForBothSelection) {
				// 双选择模式：需要有承兑选择且已填写信息
				return this.bankAcceptanceHasSelection;
			} else {
				// 单选择模式：当前选择承兑类型且已填写信息
				return this.localSelectType === BankAcceptanceType.ACCEPTANCE;
			}
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
		// **核心业务逻辑抽象：判断是否为背书人场景**
		// 时间复杂度：O(1) - 常数时间访问
		// 空间复杂度：O(1) - 无额外空间消耗
		isEndorserScenario() {
			// **边界条件1：非内部转账双选择场景**
			if (!this.isInternalTransfer || !this.waitForBothSelection || !this.componentRole) {
				// 使用原有逻辑作为fallback
				return this.billType !== BankAcceptanceType.PAY_TYPE.PAYMENT;
			}

			// **边界条件2：Vuex状态未初始化或无效**
			const accountTypes = this.bankAcceptanceDualSelectionState;
			if (!accountTypes || typeof accountTypes !== 'object') {
				console.warn('BankType: Vuex状态未初始化，使用默认逻辑');
				return false;
			}

			// **边界条件3：双方账户类型未完全选择**
			if (!accountTypes.source || !accountTypes.target) {
				// 未完全选择时，不展示任何背书相关信息，避免误导用户
				return false;
			}

			// **边界条件4：账户类型值有效性检查**
			const validAccountTypes = [BankAcceptanceType.BANK_CASH, BankAcceptanceType.ACCEPTANCE];
			if (!validAccountTypes.includes(accountTypes.source) ||
				!validAccountTypes.includes(accountTypes.target)) {
				console.error('BankType: 无效的账户类型', accountTypes);
				return false;
			}

			// **核心业务逻辑：只有支出方选择银行活期存款，收入方选择承兑时，才是背书人场景**
			const isSourceBankCashAndTargetAcceptance =
				accountTypes.source === BankAcceptanceType.BANK_CASH &&
				accountTypes.target === BankAcceptanceType.ACCEPTANCE;

			// **调试信息输出（开发环境）**
			if (process.env.NODE_ENV === 'development') {
				console.log('BankType: 背书人场景判断', {
					accountTypes,
					isEndorserScenario: isSourceBankCashAndTargetAcceptance,
					componentRole: this.componentRole
				});
			}

			return isSourceBankCashAndTargetAcceptance;
		},

		// 获取背书人类型标签（被背书人类型 或 背书人类型）
		getEndorserPersonTypeLabel() {
			if (this.isEndorserScenario) {
				// 背书人场景
				return '背书人类型';
			} else {
				// 被背书人场景（包含所有其他情况）
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
		// 接收父组件传递的承兑信息
		externalBankacceptanceInfo: {
			type: Object,
			default: () => ({})
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
		}
	},
	data() {
		return {
			localSelectType: null,
			// 右侧抽屉
			drawer: false,
			flag: false,
			bankacceptanceInfo: {},
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

		// 初始化localSelectType的值
		this.localSelectType = this.selectType;

		// 根据内部转账状态设置默认的背书人类型
		if (this.isInternalTransfer) {
			this.type = '己方公司';
		}

		// 传递过来的 只可能是数字 或者是false 如果是数字 就要拿取对应的承兑信息
		this.$bus.$on('changeFlag', value => {
			if (this.baned) {
				this.flag = false;
				return;
			}
			if (!value) {
				this.flag = value;
				// 清除填写状态
				this.clearAcceptanceFillStatus();
				return;
			}
			// 获取承兑信息
			getBankAcceptance(value).then(res => {
				this.bankacceptanceInfo = res.data;
				this.flag = true;
			});
		});

		// 重置承兑表单
		this.resetAcceptanceForm();
	},
	watch: {
		selectType(newVal) {
			this.localSelectType = newVal;
		},
		// 监听父组件传递的承兑信息变化
		externalBankacceptanceInfo: {
			handler(newVal) {
				// 如果有承兑信息且不是空对象，应该显示修改按钮
				if (newVal && Object.keys(newVal).length > 0) {
					// 避免无限循环：只有当内容真正不同时才更新
					if (JSON.stringify(this.bankacceptanceInfo) !== JSON.stringify(newVal)) {
						this.bankacceptanceInfo = { ...newVal };
						this.flag = true;
					}
				} else {
					// 如果承兑信息为空或null，隐藏修改按钮
					this.flag = false;
					this.bankacceptanceInfo = null;
				}
			},
			deep: true,
			immediate: true
		},
		// 监听承兑信息变化并填充表单
		bankacceptanceInfo: {
			handler(value) {
				if (!value) {
					return;
				}
				// 填充承兑信息数据（不再依赖id字段）
				if (value && typeof value === 'object') {
					this.$nextTick(() => {
						// 使用深拷贝避免引用问题
						const formData = _.cloneDeep(value);
						Object.assign(this.form, formData);
						this.$message.success('承兑信息加载成功');
					});
				}
				// 只有当 billNo 存在且不是编辑模式时才调用 getBankAcceptanceDate
				if (value.billNo && !value.id) {
					this.getBankAcceptanceDate(value.billNo);
				}
				// 只在非编辑模式下触发 assign 事件，避免无限循环
				if (!value.id) {
					this.handleAssign(value);
				}
			},
			deep: true
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
		// 贴息金额的自动计算
		form: {
			handler() {
				this.form.inDiscountAmount = Number(this.form.billAmount * this.form.inDiscountPoints).toFixed(2);
			},
			deep: true
		}
	},
	methods: {
		// Vuex actions 映射
		...mapActions('bankAcceptance', [
			'setAccountTypeSelection',
			'resetDualSelection',
			'clearRoleSelection'
		]),
		listBankAccount,
		listCompany,
		// 设置已填写承兑信息状态
		setAcceptanceFilled() {
			// 同时保存承兑信息到sessionStorage
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

		// **新增：完整的组件状态重置方法**
		resetComponentState() {
			// 重置本地状态
			this.localSelectType = null;
			this.flag = false;
			this.bankacceptanceInfo = {};
			this.drawer = false;

			// 重置表单数据
			this.resetAcceptanceForm();

			// 清除会话存储
			this.clearAcceptanceFillStatus();

			// 如果是双选择模式，清除对应的角色状态
			if (this.waitForBothSelection && this.componentRole) {
				this.clearRoleSelection({
					role: this.componentRole,
					formId: this.formId
				});
			}

			console.log('BankType组件状态已完全重置', {
				componentRole: this.componentRole,
				formId: this.formId
			});
		},
		// 修改承兑信息的处理方法
		handleReopenDrawer() {
			// 在打开抽屉前，确保承兑信息已经加载
			const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
			if (json) {
				try {
					this.bankacceptanceInfo = JSON.parse(json);
					console.log('修改模式加载承兑信息:', this.bankacceptanceInfo);
				} catch (error) {
					console.error('解析承兑信息失败:', error);
				}
			}
			// 直接打开抽屉进行修改
			this.drawer = true;
		},
		// 处理填写承兑信息按钮点击
		handleFillAcceptance() {
			if (this.baned) {
				return;
			}

			// 重置表单为初始状态
			this.resetAcceptanceForm();

			// 直接打开抽屉进行填写
			this.drawer = true;

			console.log('开始填写承兑信息');
		},
		// **核心方法重构：处理账户类型选择变化**
		handleEmitType(value) {
			// 重要：只有当不是承兑类型时才清空承兑的填写状态
			if (value !== BankAcceptanceType.ACCEPTANCE) {
				this.clearAcceptanceFillStatus();
			}

			// 通知父组件更新
			this.$emit('updateBankAcceptance', null);
			this.$emit('updateSelectedType', value);

			// **关键业务逻辑分支**
			if (this.waitForBothSelection && this.componentRole) {
				// 双选择模式：使用 Vuex 管理状态
				this.handleDualSelectionMode(value);
			} else {
				// 单选择模式：传统逻辑
				this.handleSingleSelectionMode(value);
			}
		},

		// **双选择模式处理逻辑**
		handleDualSelectionMode(value) {
			// 更新 Vuex 状态
			this.setAccountTypeSelection({
				role: this.componentRole,
				accountType: value,
				formId: this.formId
			});

			console.log('双选择模式：更新角色选择', {
				role: this.componentRole,
				accountType: value,
				vuexState: this.bankAcceptanceDualSelectionState
			});

			// 检查是否应该自动打开抽屉（基于 Vuex 计算属性）
			this.$nextTick(() => {
				if (this.bankAcceptanceShouldShowDrawer && !this.baned) {
					// 检查是否已有承兑信息
					const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
					if (json) {
						try {
							// 恢复已保存的承兑信息
							this.bankacceptanceInfo = JSON.parse(json);
							this.flag = true;
							console.log('双选择模式：恢复承兑信息', this.bankacceptanceInfo);
							// 通知父组件已有承兑信息
							this.$emit('updateBankAcceptance', _.cloneDeep(this.bankacceptanceInfo));
						} catch (error) {
							console.error('解析承兑信息失败:', error);
						}
					}
					// 注意：双选择模式下不自动打开抽屉，由按钮控制
					console.log('双选择模式：条件满足，等待用户点击按钮打开抽屉');
				}
			});
		},

		// **单选择模式处理逻辑**
		handleSingleSelectionMode(value) {
			// 单选择模式：选择承兑类型时的处理
			if (BankAcceptanceType.ACCEPTANCE === value) {
				if (this.baned) {
					return;
				}

				const json = sessionStorage.getItem(this.bankAcceptanceFilledKey);
				console.log('单选择模式：从sessionStorage获取数据:', json);

				// 检查是否已经填写过承兑信息
				if (json) {
					try {
						// 从sessionStorage恢复已保存的承兑信息
						this.bankacceptanceInfo = JSON.parse(json);
						this.flag = true;
						console.log('单选择模式：恢复的承兑信息:', this.bankacceptanceInfo);
						// 通知父组件已有承兑信息
						this.$emit('updateBankAcceptance', _.cloneDeep(this.bankacceptanceInfo));
					} catch (error) {
						console.error('解析承兑信息失败:', error);
					}
				}

				// 关键修复：单独使用场景下直接打开抽屉
				console.log('单选择模式：选择承兑类型，直接打开抽屉');
				this.drawer = true;
			}
		},
		// 右侧滑窗的提交逻辑（原handleSubmit方法）
		handleSubmit(value) {
			// 新扔一个emit 给父组件用
			this.$emit('updateBankAcceptance', _.cloneDeep(value));
			this.flag = true;
			this.drawer = false;
			this.bankacceptanceInfo = value;
			// 保存数据到sessionStorage
			this.setAcceptanceFilled();
			console.log('承兑信息已保存到sessionStorage:', value);

			// 在内部转账场景下，设置默认的收票事由为内部转账
			if (this.isInternalTransfer && value) {
				value.reason = '内部转账';
			}

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
				// 无效的参数
				console.warn('getBankAcceptanceDate 收到无效参数:', e);
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
					// 我方收票日期改为了票据日期,并且不再自动填充 文件15修改
					// this.form.billDate = obj.billDate;
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
					this.form.billType = this.billType;

					// 在内部转账场景下，确保收票事由为内部转账
					if (this.isInternalTransfer) {
						this.form.reason = '内部转账';
					}

					this.form = excludeParams(this.form, this.$exclude);
					// 保存到sessionStorage而不是localStorage
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
				billDate: null,
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
