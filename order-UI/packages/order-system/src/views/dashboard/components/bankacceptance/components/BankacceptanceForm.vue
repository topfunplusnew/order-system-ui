<!--专门给收付款用的 票据信息的填写的表单组件 可以在侧边打开栏目里使用-->

<script>
import SearchOption from '@/components/SearchOption.vue';
import { listCompany } from '@/api/system/company';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import { BankAcceptanceType, PaymentState } from '@/api/tool/enums';

export default {
	name: 'BankacceptanceForm',
	computed: {
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
			// 背书人类型 默认为客户
			type: '客户',
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
				this.$nextTick(() => {
					Object.assign(this.form, value);
				});
				// 提交给父组件BankType 触发提交时间
				this.$emit('assign', value);
			},
			deep: true,
			immediate: true
		}
	},
	created() {
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
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					if (this.form.id != null) {
						this.form.billType = this.billType;
						this.form = excludeParams(this.form, this.$exclude);
						this.$emit('submitForm', this.form, () => {
							this.reset();
						});
					} else {
						this.form.billType = this.billType;
						this.form = excludeParams(this.form, this.$exclude);
						this.$emit('submitForm', this.form, () => {
							this.reset();
						});
					}
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
				// 收票是由默认为购买
				reason: '购买',
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
							<el-input v-model="form.billNo" placeholder="请输入票据号码" />
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '背书' : '收票'}事由`" prop="reason">
							<el-radio v-model="form.reason" label="购买">购买</el-radio>
							<el-radio v-model="form.reason" label="客户付款">客户付款</el-radio>
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人类型' : '背书人类型'}`" prop="reason">
							<el-radio v-model="type" label="客户">客户</el-radio>
							<el-radio v-model="type" label="供应商">供应商</el-radio>
						</el-form-item>
						<el-form-item :label="`${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人' : '背书人'}`" prop="endorserName">
							<el-row>
								<el-col :span="20">
									<!--                  v-model="form.endorser"-->
									<el-input disabled :placeholder="`请输入${this.billType === BankAcceptanceType.PAY_TYPE.PAYMENT ? '被背书人' : '背书人'}`" v-model="form.endorserName" />
								</el-col>
								<el-col :span="4">
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
											<el-table-column label="显示名称" align="center" prop="displayName" />
											<el-table-column label="开户名称(户名)" align="center" prop="acountsName" />
											<el-table-column label="账号(银行账号)" align="center" prop="bankNo" />
											<el-table-column label="开户行" align="center" prop="bankName" />
										</template>
									</SearchOption>
								</el-col>
							</el-row>
						</el-form-item>
						<el-form-item label="我方收票日期" prop="billDate">
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
