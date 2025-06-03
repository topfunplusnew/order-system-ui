<template>
	<div class="app-container">
		<el-form ref="form" :model="form" :rules="rules" label-width="120px">
			<el-form-item label="日期" prop="fundsDate">
				<el-date-picker v-model="form.fundsDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss" placeholder="选择日期" />
			</el-form-item>
			<el-form-item label="支付类型" prop="payType">
				<el-row :gutter="5">
					<el-col :span="12">
						<el-cascader :disabled="isPayment" v-model="form.payType" :options="paymentTypeTree" :props="props" />
					</el-col>
				</el-row>
			</el-form-item>
			<el-form-item label="金额" prop="moneyAmount">
				<el-row :gutter="5">
					<el-col :span="12">
						<el-input v-model="form.moneyAmount" placeholder="请输入金额" :disabled="inputDisabled && moneyInputDisabled" />
					</el-col>
				</el-row>
			</el-form-item>

			<!--      只有当为付款的时候 才会展示付款信息-->
			<!--			<template v-show="isPayment">-->
			<!--				<el-form-item label="我方银行账户类型">-->
			<!--					<BankType-->
			<!--						:bill-type="BankAcceptanceType.PAY_TYPE.PAYMENT"-->
			<!--						:select-type="form.selfBankCardType"-->
			<!--						@updateSelectedType="changeSelfBankType"-->
			<!--						@updateBankAcceptance="value => (form.params.bankacceptance = value)"-->
			<!--					/>-->
			<!--				</el-form-item>-->
			<!--				&lt;!&ndash;        对方信息&ndash;&gt;-->
			<!--				<el-form-item label="我方户名" prop="selfAcountsName">-->
			<!--					<el-row>-->
			<!--						<el-col :span="10">-->
			<!--							<el-input disabled v-model="form.selfAcountsName" placeholder="请选择" />-->
			<!--						</el-col>-->
			<!--						<el-col :span="3">-->
			<!--							<SearchOption-->
			<!--								:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SELF_COMPANY }"-->
			<!--								:get-data="listBankAccount"-->
			<!--								icon="el-icon-search"-->
			<!--								query-label="户名查找"-->
			<!--								query-info="acountsName"-->
			<!--								:query-name="queryBank"-->
			<!--								@commitBack="handleCommitBackSelfBank"-->
			<!--								@update:queryName="-->
			<!--									val => {-->
			<!--										queryBank = val;-->
			<!--									}-->
			<!--								"-->
			<!--							>-->
			<!--								<template #table-columns>-->
			<!--									<el-table-column label="账号类型" align="center" prop="acountsType" />-->
			<!--									<el-table-column label="显示名称" align="center" prop="displayName" />-->
			<!--									<el-table-column label="开户行" align="center" prop="bankName" />-->
			<!--									<el-table-column label="开户名" align="center" prop="acountsName" />-->
			<!--									<el-table-column label="账号" align="center" prop="bankNo" />-->
			<!--								</template>-->
			<!--							</SearchOption>-->
			<!--						</el-col>-->
			<!--					</el-row>-->
			<!--				</el-form-item>-->
			<!--				<el-form-item label="我方账号" prop="selfBankNo">-->
			<!--					<el-input disabled v-model="form.selfBankNo" placeholder="请选择" />-->
			<!--				</el-form-item>-->
			<!--				<el-form-item label="我方开户行" prop="selfBankName">-->
			<!--					<el-input disabled v-model="form.selfBankName" placeholder="请选择" />-->
			<!--				</el-form-item>-->
			<!--			</template>-->

			<template v-if="!isPayment">
				<el-form-item label="对方类型(请确认)">
					<el-select v-model="value" placeholder="请选择" @change="handleOpponentTypeChange">
						<!--      当选择了付款的时候 对方类型为 支付费用  并且禁用-->
						<el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
					</el-select>
					<span style="color: #1c84c6; font-size: 12px">请注意选择正确的对方公司类型!</span>
				</el-form-item>

				<el-form-item v-if="value !== PUBLIC_DICT_TYPE.EMPLOYEE && value !== PAYMENT_TARGET_TYPE.PAYMENT_FEE" label="对方公司" prop="companyName">
					<el-row>
						<el-col :span="14">
							<el-input disabled v-model="form.companyName" placeholder="请选择" />
						</el-col>
						<el-col :span="4">
							<SearchOption
								:limit-info="{ companyType: value }"
								:get-data="listCompany"
								icon="el-icon-search"
								:query-label="value"
								query-info="companyName"
								:query-name="queryOther"
								@update:queryName="handleUpdateQueryNameOther"
								@commitBack="handleCommitBackOther"
							>
								<template #table-columns>
									<el-table-column :label="`${value}名称`" align="center" prop="companyName" width="180" show-overflow-tooltip />
									<el-table-column label="老板姓名" align="center" prop="leader" width="180" show-overflow-tooltip />
									<el-table-column label="老板电话" align="center" prop="leaderTel" width="180" show-overflow-tooltip />
									<el-table-column label="区域" align="center" prop="region" width="180" show-overflow-tooltip />
									<el-table-column label="联系人" align="center" prop="relationName" width="180" show-overflow-tooltip />
									<el-table-column label="销售经理" align="center" prop="salesManager" width="180" show-overflow-tooltip />
									<el-table-column label="地址" align="center" prop="address" width="150" show-overflow-tooltip />
									<el-table-column label="电话" align="center" prop="relationTel" width="180" show-overflow-tooltip />
								</template>
							</SearchOption>
						</el-col>
					</el-row>
				</el-form-item>

				<el-row v-if="value === PUBLIC_DICT_TYPE.CUSTOMER">
					<el-form-item label="对方账号(客户)" prop="otherBankNo">
						<el-row>
							<el-col :span="14">
								<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
							</el-col>
							<el-col v-if="bankInputDisabled === false" :span="3">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.CUSTOMER }"
									query-label="银行卡查找"
									query-info="bankNo"
									:query-name="queryCompany"
									@commitBack="handleCommitBack"
									@update:queryName="handleUpdateQueryName"
								>
									<template #table-columns>
										<el-table-column label="公司名称" align="center" prop="companyName">
											<template #default="scope">
												{{ isNull(scope.row.companyName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户行" align="center" prop="bankName">
											<template #default="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户名" align="center" prop="acountsName">
											<template #default="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column label="账号" align="center" prop="bankNo">
											<template #default="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="对方开户行" prop="otherBankName">
						<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
					</el-form-item>
				</el-row>
				<el-row v-if="value === PUBLIC_DICT_TYPE.SUPPLIER">
					<el-form-item label="对方账号(供应商)" prop="otherBankNo">
						<el-row>
							<el-col :span="14">
								<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
							</el-col>
							<el-col v-if="bankInputDisabled === false" :span="3">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.SUPPLIER }"
									query-label="银行卡查找"
									query-info="bankNo"
									:query-name="queryCompany"
									@commitBack="handleCommitBack"
									@update:queryName="handleUpdateQueryName"
								>
									<template #table-columns>
										<el-table-column label="公司名称" align="center" prop="companyName">
											<template #default="scope">
												{{ isNull(scope.row.companyName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户行" align="center" prop="bankName">
											<template #default="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户名" align="center" prop="acountsName">
											<template #default="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column label="账号" align="center" prop="bankNo">
											<template #default="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>

					<el-form-item label="对方开户行" prop="otherBankName">
						<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
					</el-form-item>
				</el-row>
				<el-row v-if="value === PUBLIC_DICT_TYPE.DRIVER">
					<el-form-item label="对方账号(司机)" prop="otherBankNo">
						<el-row>
							<el-col :span="14">
								<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
							</el-col>
							<el-col v-if="bankInputDisabled === false" :span="3">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.DRIVER }"
									query-label="银行卡查找"
									query-info="bankNo"
									:query-name="queryCompany"
									@commitBack="handleCommitBack"
									@update:queryName="handleUpdateQueryName"
								>
									<template #table-columns>
										<el-table-column label="司机名称" align="center" prop="companyName">
											<template #default="scope">
												{{ isNull(scope.row.companyName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户行" align="center" prop="bankName">
											<template #default="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户名" align="center" prop="acountsName">
											<template #default="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column label="账号" align="center" prop="bankNo">
											<template #default="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="对方开户行" prop="otherBankName">
						<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
					</el-form-item>
				</el-row>

				<el-row v-if="value === PUBLIC_DICT_TYPE.EMPLOYEE">
					<el-form-item label="对方账号(员工)" prop="otherBankNo">
						<el-row>
							<el-col :span="14">
								<el-input v-model="form.otherBankNo" placeholder="请选择" disabled />
							</el-col>
							<el-col v-if="bankInputDisabled === false" :span="3">
								<SearchOption
									:get-data="listBankAccount"
									icon="el-icon-search"
									:limit-info="{ acountsType: PUBLIC_DICT_TYPE.EMPLOYEE }"
									query-label="银行卡查找"
									query-info="bankNo"
									:query-name="queryCompany"
									@commitBack="handleCommitBack"
									@update:queryName="handleUpdateQueryName"
								>
									<template #table-columns>
										<el-table-column label="员工名称" align="center" prop="companyName">
											<template #default="scope">
												{{ isNull(scope.row.companyName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户行" align="center" prop="bankName">
											<template #default="scope">
												{{ isNull(scope.row.bankName) }}
											</template>
										</el-table-column>
										<el-table-column label="开户名" align="center" prop="acountsName">
											<template #default="scope">
												{{ isNull(scope.row.acountsName) }}
											</template>
										</el-table-column>
										<el-table-column label="账号" align="center" prop="bankNo">
											<template #default="scope">
												{{ isNull(scope.row.bankNo) }}
											</template>
										</el-table-column>
									</template>
								</SearchOption>
							</el-col>
						</el-row>
					</el-form-item>
					<el-form-item label="对方开户行" prop="otherBankName">
						<el-input v-model="form.otherBankName" placeholder="请输入对方开户行" disabled />
					</el-form-item>
				</el-row>

				<el-form-item label="付款原因" prop="reason">
					<el-input v-model="form.reason" type="textarea" placeholder="请输入内容" />
				</el-form-item>
				<el-form-item label="附件" prop="attachment">
					<file-upload @input="handleCommitUpload" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</template>
		</el-form>
		<div slot="footer" class="dialog-footer" style="text-align: center">
			<!--      当类型为付款时,添加坏账损失信息-->
			<template v-if="isPayment">
				<el-button type="primary" @click="submitForm">确认付款</el-button>
				<el-button @click="clear">取消</el-button>
			</template>

			<!--      当类型为付款申请的时候 正常添加付款申请-->
			<template v-else>
				<el-tooltip class="item" effect="dark" content="提交信息至服务器" placement="top-start">
					<el-button type="primary" @click="submitForm" v-if="!isOtherButtonDisabled">提交到申请列表</el-button>
				</el-tooltip>
				<el-tooltip class="item" effect="dark" content="可以将填写的信息暂存下来,但不提交,下次打开可继续填写" placement="top-start">
					<el-button @click="close" v-if="!isOtherButtonDisabled">关闭并暂存</el-button>
				</el-tooltip>
				<el-button @click="clear" v-if="!isOtherButtonDisabled">取消填写</el-button>
			</template>
		</div>
	</div>
</template>

<script>
import { listPaymentApply, addPaymentApply, updatePaymentApply } from '@/api/system/paymentApply';
import { excludeParams } from '@/api/tool/exclude';
import SearchOption from '@/components/SearchOption.vue';
import { listBankAccount } from '@/api/system/bankAccount';
import { mixin_payment_apply } from '../../mixins/apply_payment/payment_apply';
import { mixin_payment_level } from '../../mixins/apply_payment/payment_level';
import { mixin_payment_watcher } from '../../mixins/apply_payment/payment_watcher';
import { listCompany } from '../../../../api/system/company';
import { mixin_payment_fill } from '../../mixins/apply_payment/payment_fill';
import { isNull } from '../../../../main';
import { mixin_receive_money_subject } from '../../mixins/receivemoney/receive_money_subject';
import { parseTime } from '@/utils/ruoyi';
import { BankAcceptanceType, PAYMENT_TARGET_TYPE, TableName } from '@/api/tool/enums';
import { mixin_bankType } from '@/views/dashboard/mixins/common/common_bankType';
import { addBadBetPayment, addPayment } from '@/api/system/payment';
import _ from 'lodash';
import { PUBLIC_DICT_TYPE } from '@/utils/order';
import { getRecoverMoney } from '@/api/system/recoverMoney';
import { getLendMoney } from '@/api/system/lendMoney';

export default {
	name: 'ApplyPayment',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		PAYMENT_TARGET_TYPE() {
			return PAYMENT_TARGET_TYPE;
		},
		rules() {
			// 基础校验规则 - 两种场景都需要的校验
			const baseRules = {
				fundsDate: [{ required: true, message: '付款日期不能为空', trigger: 'blur' }],
				moneyAmount: [{ required: true, message: '付款金额不能为空', trigger: 'blur' }]
			};

			// 付款场景特有的校验规则
			if (this.isPayment) {
				return {
					...baseRules,
					selfAcountsName: [{ required: true, message: '我方户名不能为空', trigger: 'change' }],
					selfBankNo: [{ required: true, message: '我方账号不能为空', trigger: 'change' }],
					selfBankName: [{ required: true, message: '我方开户行不能为空', trigger: 'change' }]
				};
			}

			// 付款申请场景的校验规则
			else {
				return {
					...baseRules,
					reason: [{ required: true, message: '付款事由不能为空', trigger: 'blur' }],
					// 根据对方类型动态添加校验
					...this.getOpponentTypeRules()
				};
			}
		}
	},
	components: { SearchOption },
	mixins: [mixin_payment_apply, mixin_payment_level, mixin_payment_watcher, mixin_payment_fill, mixin_receive_money_subject, mixin_bankType],
	data() {
		return {
			// 遮罩层
			loading: true,
			// 总条数
			total: 0,
			// 表单参数
			form: {
				tID: null,
				tableName: null,
				fundsDate: parseTime(new Date()),
				payType: null,
				moneyAmount: null,
				// 银行卡类型
				selfBankCardType: null,
				otherBankCardType: null,
				// 己方银行卡信息
				selfAcountsName: null,
				selfBankNo: null,
				selfBankName: null,
				selfBankID: null,
				// 对方银行卡信息
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachment: null,
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null
			},
			// 禁用输入框
			inputDisabled: false,
			// 禁用银行卡输入 因为现金支付不需要银行卡信息
			bankInputDisabled: false,
			// 本地存储的 key
			localStorageKey: 'paymentApplyForm',
			// 下拉框选项
			options: [
				{ value: '客户', label: '客户' },
				{ value: '供应商', label: '供应商' },
				{ value: '司机', label: '司机' },
				{ value: '员工', label: '员工' },
				{ value: '支付费用', label: '支付费用' }
			],
			value: '', // 对方类型
			queryOther: '', // 其他搜索参数
			queryCompany: '', // 公司搜索参数

			// 区分付款与付款申请的字段
			isPayment: false,
			queryBank: null
		};
	},
	watch: {
		value(newValue) {
			// 当对方类型改变时，清空之前选择的公司和银行卡信息
			if (this.form.companyType !== newValue) {
				this.form.companyName = null;
				this.form.companyId = null;
				this.form.otherBankNo = null;
				this.form.otherBankName = null;
			}
		}
	},
	mounted() {
		this.loadForm();
	},
	methods: {
		isNull,
		listCompany,
		listBankAccount,
		// 上传的回调函数
		handleCommitUpload(val) {
			this.form.attachment = val;
		},
		handleOpponentTypeChange(value) {
			// 当对方类型改变时，触发相应的逻辑，例如清空某些字段
			console.log('对方类型 changed to:', value);
		},
		handleUpdateQueryNameOther(val) {
			this.queryOther = val;
		},
		handleCommitBackOther(row) {
			this.form.companyName = row.companyName;
			this.form.companyId = row.id;
		},
		handleUpdateQueryName(val) {
			this.queryCompany = val;
		},
		handleCommitBack(row) {
			this.form.otherBankNo = row.bankNo;
			this.form.otherBankName = row.bankName;
		},
		// 自动填充我方信息
		handleCommitBackSelfBank(val) {
			this.form.selfBankName = val.bankName;
			this.form.selfAcountsName = val.acountsName;
			this.form.selfBankNo = val.bankNo;
			this.form.selfBankID = val.id;
		},
		// 根据对方类型返回相应的校验规则
		getOpponentTypeRules() {
			if (!this.value || this.value === PAYMENT_TARGET_TYPE.PAYMENT_FEE) {
				return {};
			}

			// 如果选择了对方类型且不是支付费用，则需要校验对方公司
			const rules = {
				companyName: [{ required: true, message: '对方公司不能为空', trigger: 'change' }]
			};

			// 如果是客户、供应商、司机或员工，则需要校验银行账号信息
			if (['客户', '供应商', '司机', '员工'].includes(this.value) && !this.bankInputDisabled) {
				rules.otherBankNo = [{ required: true, message: '对方账号不能为空', trigger: 'change' }];
				rules.otherBankName = [{ required: true, message: '对方开户行不能为空', trigger: 'change' }];
			}

			return rules;
		},
		// 正常付款申请
		submitForm() {
			// 只抽取付款信息所需要的字段
			this.$refs['form'].validate(valid => {
				if (valid) {
					const form = _.cloneDeep(this.form);
					if (this.isPayment) {
						this.handlePayment(form);
						return;
					}
					this.handlePaymentApply(form);
				}
			});
		},
		handlePaymentApply(form) {
			// 如果是多个付款审核 需要把信息返回给父组件进行使用 这种情况只有不在弹窗中才会使用其他情况没有
			if (this.isMulti) {
				this.$message.success('付款申请提交成功');
				this.$emit('getApplyPayment', form);
				this.$emit('changeOpen');
				return;
			}
			// 添加付款类型
			if (!form.payType) {
				this.$modal.msgError('请选择付款类型');
				return;
			}
			excludeParams(form, this.$exclude);
			form.tableName = this.tableName;
			form.tID = this.tID;
			form.checkState = ''; // 审核状态赋空
			form.companyType = this.value;
			const payType = form.payType.join('-');
			const body = { ...form, payType: payType };
			addPaymentApply(body).then(() => {
				this.$modal.msgSuccess('付款申请添加成功');
				this.reset();
				// 提交成功后删除本地的缓存
				this.clearForm();
				this.$emit('changeOpen');
			});
		},
		// 如果是付款 付款的逻辑
		handlePayment(form) {
			if (!form.payType) {
				this.$modal.msgError('请选择付款类型');
				return;
			}
			if (!this.tID) {
				console.error('付款申请 tid 为空');
				return;
			}
			const json = {},
				tid = _.cloneDeep(this.tID);
			const payType = form.payType.join('-');
			_.set(json, 'params.paymentInfo', {});
			// 坏账信息 先获取 资金收回信息 然后添加付款信息
			getLendMoney(tid).then(lendMoneyInfo => {
				if (!lendMoneyInfo.data) {
					this.$message.error('查询对应借款信息时出现错误');
					return;
				}
				// 组装收回信息
				Object.assign(json, {
					futuresNO: lendMoneyInfo.data.futuresNO,
					moneyAmount: lendMoneyInfo.data.moneyAmount,
					recoverDate: parseTime(new Date()),
					acountsName: lendMoneyInfo.data.selfAcountsName,
					bankNo: lendMoneyInfo.data.selfBankNo,
					comments: lendMoneyInfo.data.comments
				});
				// 组装付款信息
				Object.assign(json.params.paymentInfo, {
					fundsDate: parseTime(new Date()),
					payType: payType,
					moneyAmount: form.moneyAmount,
					selfAcountsName: lendMoneyInfo.data.selfAcountsName,
					selfBankName: lendMoneyInfo.data.selfBankName,
					selfBankNo: lendMoneyInfo.data.selfBankNo,
					selfBankID: lendMoneyInfo.data.selfBankID,
					// 表名和id
					tableName: TableName.RECOVER_MONEY,
					tID: tid,
					// 银行卡类型
					selfBankCardType: BankAcceptanceType.BANK_CASH,
					otherBankCardType: BankAcceptanceType.BANK_CASH,
					// 公司类型
					companyType: PAYMENT_TARGET_TYPE.PAYMENT_FEE
				});
				// 填充我方银行卡信息
				addBadBetPayment(json).then(res => {
					this.$message.success('付款成功');
					this.reset();
					this.$emit('changeOpen');
				});
			});
		},
		// 提交到数据库 但是状态是待提交 这个是当付款填写表单在弹窗中的时候
		submitAndUpdate(that) {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						// 填充公司类型
						if (!this.extraInformation.__companyType) {
							this.$message.error('请选择公司类型!');
							return;
						}
						// 添加付款类型
						if (!this.form.payType) {
							this.$modal.msgError('请选择付款类型');
							return;
						}
						this.form.companyType = this.extraInformation.__companyType;
						// 填充对应表名和主键
						this.form.tableName = this.tableName;
						this.form.tID = this.tID;
						const payType = this.form.payType.join('-');
						const body = { ...this.form, payType: payType };
						updatePaymentApply(body).then(() => {
							this.$modal.msgSuccess('付款申请保存成功,点击提交并审核可提交信息至审核流程');
							this.reset();
							that.dialogVisible = false;
							// 发布一个事件 提醒更新
							this.$bus.$emit('payment-apply-unaudit-list-update');
						});
					} else {
						this.$message.error('系统错误:付款时没有主键');
					}
				}
			});
		},
		close() {
			this.$emit('changeOpen');
			this.saveForm();
			this.reset();
		},
		clear() {
			this.$emit('changeOpen');
			this.clearForm();
			this.reset();
		},
		// 表单重置
		reset() {
			this.form = {
				id: null,
				tableName: null,
				tID: null,
				fundsDate: parseTime(new Date()),
				payType: null,
				moneyAmount: null,
				// 银行卡类型
				selfBankCardType: null,
				otherBankCardType: null,
				// 我方银行卡信息
				selfBankNo: null,
				selfBankName: null,
				selfAcountsName: null,
				// 对方银行卡类型
				otherAcountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				attachment: null,
				applyPerson: null,
				applyPersonID: null,
				checkState: null,
				comments: null
			};
			this.value = ''; // 重置对方类型
			this.currentSort = { levelOne: '', levelTwo: '' };
			this.resetForm('form');
		},
		// 保存表单数据到 localStorage
		saveForm() {
			try {
				localStorage.setItem(this.localStorageKey, JSON.stringify(this.form));
				localStorage.setItem('paymentApplyFormOpponentType', this.value); // 保存对方类型
				this.$message.success('表单信息已保存');
			} catch (error) {
				console.error('保存表单信息失败', error);
				this.$message.error('保存表单信息失败');
			}
		},
		// 清除本地保存的数据
		clearForm() {
			try {
				localStorage.removeItem(this.localStorageKey);
				localStorage.removeItem('paymentApplyFormOpponentType');
			} catch (error) {
				console.error('清除表单信息失败', error);
			}
		},
		// 从 localStorage 加载表单数据
		loadForm() {
			try {
				const savedForm = localStorage.getItem(this.localStorageKey);
				const savedOpponentType = localStorage.getItem('paymentApplyFormOpponentType');
				if (savedForm) {
					this.form = JSON.parse(savedForm);
					this.$message.success('已读取上次填写的数据');
				}
				if (savedOpponentType) {
					this.value = savedOpponentType;
				}
			} catch (error) {
				console.error('加载表单信息失败', error);
			}
		},
		handleProcess(that) {
			this.submitAndUpdate(that);
		},
		handleReject() {}
	}
};
</script>
