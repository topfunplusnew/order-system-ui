<!--专门给收付款用的 票据信息的填写的表单组件 可以在侧边打开栏目里使用-->

<script>
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { BankAcceptanceType, PaymentState } from '@/api/tool/enums';
import { getMinIdByBillNo } from '@/api/system/bankAcceptance';
import _ from 'lodash';
import { PUBLIC_DICT_TYPE } from '@/utils/order';

export default {
	name: 'BankacceptanceForm',
	computed: {
		PUBLIC_DICT_TYPE() {
			return PUBLIC_DICT_TYPE;
		},
		BankAcceptanceType() {
			return BankAcceptanceType;
		}
	},
	components: { SearchOption },
	props: {
		bankacceptanceInfo: {
			type: Object,
			default: () => {}
		},
		// 票据的类型 根据收付款类型确定
		billType: {
			type: String,
			default: '收入'
		},
		// 是否为内部转账
		isInternalTransfer: {
			type: Boolean,
			default: false
		}
	},
	data() {
		return {
			form: {},
			// 表单校验
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
						message: `请选择${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '背书' : '收票'}事由`,
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
			type: this.isInternalTransfer ? '己方公司' : '客户',
			// 搜索客户
			companyName: ''
		};
	},
	watch: {
		// 贴息金额的自动计算
		form: {
			handler() {
				this.form.inDiscountAmount = Number(this.form.billAmount * this.form.inDiscountPoints).toFixed(2);
			},
			deep: true
		},
		bankacceptanceInfo: {
			handler(value) {
				if (!value) {
					return;
				}
				console.log(`传递的value`, value);

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
					this.$emit('assign', value);
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
		}
	},
	created() {
		// 创建防抖函数
		this.reset();
	},
	mounted() {
		this.$bus.$on('changeFlag', value => {
			if (!value) {
				this.reset();
			}
		});
	},
	methods: {
		listBankAccount,
		listCompany,
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

			console.log('getBankAcceptanceDate inputValue:', inputValue);

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
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					this.form.billType = this.billType;

					// 在内部转账场景下，确保收票事由为内部转账
					if (this.isInternalTransfer) {
						this.form.reason = '内部转账';
					}

					this.form = excludeParams(this.form, this.$exclude);
					console.log(`表单`, this.form);

					// 保存到sessionStorage而不是localStorage
					const storageKey = 'bankAcceptanceFilled';
					sessionStorage.setItem(storageKey, JSON.stringify(this.form));
					sessionStorage.setItem('bankAcceptanceFilledTime', new Date().getTime());

					this.$emit('submitForm', _.cloneDeep(this.form));
					this.reset();
				}
			});
		},
		cancel() {
			this.$emit('cancel');
		},
		reset() {
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
			this.resetForm('form');
			// 通知已重置
			this.$emit('resetForm');
		}
	}
};
</script>

<template>
	<div>
		<div class="bank-body">
			<el-form ref="form" :model="form" :rules="rules" label-width="140px">
				<el-row>
					<el-col :span="12">
						<el-form-item label="票据号码" prop="billNo">
							<el-input v-model="form.billNo" placeholder="请输入票据号码" @blur="getBankAcceptanceDate" />
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '背书' : '收票'}事由`" prop="reason">
							<template v-if="isInternalTransfer">
								<!-- 内部转账场景下的选项 -->
								<el-radio v-model="form.reason" label="内部转账">内部转账</el-radio>
								<el-radio v-model="form.reason" label="其他">其他</el-radio>
							</template>
							<template v-else>
								<template v-if="this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT">
									<el-radio v-model="form.reason" label="出售">出售</el-radio>
									<el-radio v-model="form.reason" label="对外付款">对外付款</el-radio>
								</template>
								<template v-if="this.billType === BankAcceptanceType.PAY_TYPE.RECEIVE">
									<el-radio v-model="form.reason" label="购买">购买</el-radio>
									<el-radio v-model="form.reason" label="客户付款">客户付款</el-radio>
								</template>
							</template>
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人类型' : '背书人类型'}`" prop="reason">
							<template v-if="isInternalTransfer">
								<!-- 内部转账场景下不可更改背书人类型 -->
								<el-radio v-model="type" label="己方公司" disabled>己方公司</el-radio>
							</template>
							<template v-else>
								<el-radio v-model="type" label="客户">客户</el-radio>
								<el-radio v-model="type" label="供应商">供应商</el-radio>
							</template>
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人' : '背书人'}`" prop="endorserName">
							<el-row>
								<el-col :span="20">
									<el-input
										:disabled="isInternalTransfer || !isInternalTransfer"
										:placeholder="`请输入${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人' : '背书人'}`"
										v-model="form.endorserName"
									/>
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
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '支出' : '收入'}票据金额`" prop="billAmount">
							<el-input v-model="form.billAmount" placeholder="请输入票据金额" />
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '支出' : '收入'}贴息点数`" prop="inDiscountPoints">
							<el-input v-model="form.inDiscountPoints" placeholder="请输入贴息点数" />
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '支出' : '收入'}贴息金额`" prop="inDiscountAmount">
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
						<el-button type="primary" @click="submitForm">确 定</el-button>
						<el-button @click="cancel">关 闭</el-button>
						<el-button @click="reset">重 置</el-button>
					</div>
				</div>
			</el-form>
		</div>
	</div>
</template>

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
</style>
