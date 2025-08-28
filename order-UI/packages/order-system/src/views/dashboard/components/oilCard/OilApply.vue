<script>
import { listSubject } from '@/api/system/subject';
import { listBankAccount } from '@/api/system/bankAccount';
import { addPaymentApply } from '@/api/system/paymentApply';
import { excludeParams } from '@/api/tool/exclude';
import { TableName } from '@/api/tool/enums';
import { mixin_payment_subject } from '@/views/dashboard/mixins/payment/payment_subject';
import UploadFilesButton from '@/components/UploadFilesButton/index.vue';
import { parseTime } from '@/utils/ruoyi';
import { PAYMENT_TARGET_TYPE } from '@/api/tool/enums';

export default {
	name: 'OilApply',
	components: { UploadFilesButton },
	mixins: [mixin_payment_subject],
	props: {
		// 关联表名 - 已弃用，保留用于兼容性
		tableName: {
			type: String,
			default: ''
		},
		// 关联表的主键ID - 已弃用，保留用于兼容性
		tID: {
			type: String,
			default: ''
		},
		// 需要自动填充的钱
		needMoney: {
			type: Number
		},
		// 需要自动填充的信息 包含 对方户名:acountsName 对方账号 bankNo 对方开户行 bankName 对方公司 companyName
		needInfo: {
			type: Object
		},
		// 表关联数组 - 新的付款申请结构
		tableReferences: {
			type: Array,
			default: () => []
		}
	},
	data() {
		return {
			// 遮罩层
			loading: true,
			// 表单参数
			form: {
				// 废弃字段，保留用于兼容性
				tID: null,
				tableName: null,
				// 核心业务字段
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				// 对方信息（统一字段名）
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				// 附件字段
				attachment: null,
				attachmentIds: null,
				// 申请人信息
				applyPerson: null,
				applyPersonId: null,
				checkState: null,
				comments: null,
				// 时间戳字段
				addTime: null,
				userId: null,
				userName: null,
				// 新增字段
				tableReferences: []
			},
			// 表单校验
			rules: {
				fundsDate: [
					{
						required: true,
						message: '付款日期不能为空',
						trigger: 'blur'
					}
				],
				moneyAmount: [
					{
						required: true,
						message: '付款金额不能为空',
						trigger: 'blur'
					}
				],
				reason: [
					{
						required: true,
						message: '付款事由不能为空',
						trigger: 'blur'
					}
				]
			},
			// 禁用输入框
			inputDisabled: false,
			// 禁用银行卡输入 因为现金支付不需要银行卡信息
			bankInputDisabled: false
		};
	},
	watch: {
		// 监听传入的金额
		needMoney: {
			handler() {
				// 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
				if (this.needMoney >= 0) {
					this.form.moneyAmount = this.needMoney;
					this.inputDisabled = true;
				}
			},
			deep: true,
			immediate: true
		},
		// 监听 tableReferences 变化，自动计算总金额
		tableReferences: {
			handler(newReferences) {
				if (newReferences && newReferences.length > 0) {
					// 构建表单的 tableReferences
					this.form.tableReferences = newReferences.map(ref => ({
						refTableName: ref.refTableName || ref.tableName,
						refTableId: ref.refTableId || ref.tID || ref.id,
						amount: parseFloat(ref.amount) || 0
					}));

					// 如果没有手动设置金额，则自动计算总金额
					if (!this.needMoney && this.form.tableReferences.length > 0) {
						const totalAmount = this.form.tableReferences.reduce((sum, ref) => sum + ref.amount, 0);
						if (totalAmount > 0) {
							this.form.moneyAmount = totalAmount;
						}
					}
				}
			},
			deep: true,
			immediate: true
		},
		// 监听表的变化
		tableName: {
			handler(val) {
				if (val === 'oilrecharge') {
					this.form.companyType = PAYMENT_TARGET_TYPE.PAYMENT_FEE;
				}
				if (val === 'repayment') {
					this.form.companyType = '其他';
				}
				if (val === 'orderfreight') {
					this.form.companyType = '司机';
				}
			}
		}
	},
	created() {
		// 填充金额
		this.fillMoney();
		// 填充表信息
		if (this.tableName === TableName.OIL_RECHARGE) {
			this.form.companyType = PAYMENT_TARGET_TYPE.PAYMENT_FEE;
		}
	},
	methods: {
		listBankAccount,

		/**
		 * **业务架构设计：数据结构兼容性转换**
		 * 
		 * 将旧的单表关联模式转换为新的多表关联模式
		 * 专门为油卡充值业务定制的转换逻辑
		 */
		buildTableReferences() {
			// 优先使用新的 tableReferences 结构
			if (this.tableReferences && this.tableReferences.length > 0) {
				return this.tableReferences.map(ref => ({
					refTableName: ref.refTableName || ref.tableName,
					refTableId: ref.refTableId || ref.tID || ref.id,
					amount: parseFloat(ref.amount) || parseFloat(this.form.moneyAmount) || 0
				}));
			}

			// 兼容旧的单表关联模式
			if (this.tableName && this.tID) {
				return [{
					refTableName: this.tableName,
					refTableId: this.tID,
					amount: parseFloat(this.form.moneyAmount) || 0
				}];
			}

			return [];
		},

		/**
		 * **表单数据标准化处理**
		 * 
		 * 构建符合新API要求的表单数据结构
		 * 油卡充值业务的数据映射和格式转换
		 */
		buildFormData() {
			const formData = {
				fundsDate: this.form.fundsDate,
				payType: Array.isArray(this.form.payType) ? this.form.payType.join('-') : this.form.payType,
				moneyAmount: parseFloat(this.form.moneyAmount) || 0,
				// 字段名映射
				otherAccountsName: this.form.otherAccountsName || this.form.otherAcountsName,
				otherBankNo: this.form.otherBankNo,
				otherBankName: this.form.otherBankName,
				companyName: this.form.companyName,
				companyId: this.form.companyId,
				companyType: this.form.companyType,
				reason: this.form.reason,
				applyPerson: this.form.applyPerson,
				applyPersonId: this.form.applyPersonId || this.form.applyPersonID,
				comments: this.form.comments,
				// 时间戳信息
				addTime: this.form.addTime || parseTime(new Date()),
				userId: this.form.userId,
				userName: this.form.userName,
				// 新的表关联结构
				tableReferences: this.buildTableReferences()
			};

			// 处理附件信息 - 统一使用 attachmentIds
			if (this.form.attachmentIds) {
				formData.attachmentIds = this.form.attachmentIds;
			} else if (this.form.attachment) {
				// 兼容旧的 attachment 字段
				formData.attachmentIds = this.form.attachment;
			}

			return formData;
		},

		// 上传的回调函数 - 更新为新的附件处理方式
		handleCommitUpload(uploadParams) {
			// 处理新的附件上传结构
			if (uploadParams && uploadParams.params && uploadParams.params.attachmentIds) {
				this.form.attachmentIds = uploadParams.params.attachmentIds;
			} else if (typeof uploadParams === 'string') {
				// 兼容旧的字符串方式
				this.form.attachment = uploadParams;
				this.form.attachmentIds = uploadParams;
			}
		},
		// 填充金额
		fillMoney() {
			// 如果传入的必须自动填充的金额大于0 则自动填充 且无法修改
			if (this.needMoney >= 0) {
				this.form.moneyAmount = this.needMoney;
				if (this.needMoney != 0) {
					this.inputDisabled = true;
				}
			}
		},
		// 表单重置
		reset() {
			this.form = {
				// 废弃字段，保留用于兼容性
				id: null,
				tableName: null,
				tID: null,
				// 核心业务字段
				fundsDate: null,
				payType: null,
				moneyAmount: null,
				// 对方信息
				otherAccountsName: null,
				otherBankNo: null,
				otherBankName: null,
				companyName: null,
				companyId: null,
				companyType: null,
				reason: null,
				// 附件信息
				attachment: null,
				attachmentIds: null,
				// 申请人信息
				applyPerson: null,
				applyPersonId: null,
				checkState: null,
				comments: null,
				// 时间戳字段
				addTime: null,
				userId: null,
				UserName: null,
				userName: null,
				updateTime: null,
				delFlag: null,
				submitflag: null,
				// 新增字段
				tableReferences: []
			};
			this.resetForm('form');
		},

		/** 提交按钮 */
		submitForm() {
			this.$refs['form'].validate(valid => {
				if (valid) {
					// 构建新的表单数据结构
					const formData = this.buildFormData();
					formData.checkState = ''; // 审核状态赋空

					// 对支付类型进行处理
					if (!formData.payType) {
						this.$message.warning('请选择付款类型');
						return;
					}

					// 数据验证
					if (formData.tableReferences.length === 0) {
						this.$message.warning('付款申请必须关联至少一个业务记录');
						return;
					}

					// 排除不必要的参数
					excludeParams(formData, this.$exclude);

					// 添加付款
					addPaymentApply(formData).then(() => {
						this.$modal.msgSuccess('付款申请添加成功');
						this.reset();
						this.$emit('changeOpen');
					});
				}
			});
		},
		close() {
			this.$emit('changeOpen');
			this.reset();
		}
	}
};
</script>

<template>
	<div>
		<div class="app-container">
			<el-form ref="form" :model="form" :rules="rules" label-width="120px">
				<el-form-item label="日期" prop="fundsDate">
					<el-date-picker v-model="form.fundsDate" type="datetime" value-format="yyyy-MM-dd HH:mm:ss"
						placeholder="选择日期"></el-date-picker>
				</el-form-item>
				<el-form-item label="支付类型" prop="payType">
					<el-cascader v-model="form.payType" :options="paymentTypeTree" :props="props"
						@change="handleChange"></el-cascader>
				</el-form-item>
				<el-form-item label="金额" prop="moneyAmount">
					<el-input v-model="form.moneyAmount" placeholder="请输入金额" :disabled="inputDisabled" />
				</el-form-item>
				<el-form-item label="付款原因" prop="reason">
					<el-input v-model="form.reason" type="textarea" placeholder="请输入内容" />
				</el-form-item>
				<el-form-item label="附件" prop="attachmentIds">
					<UploadFilesButton ref="attachmentUpload" flag="attachment"
						:initial-attachments="(form.params && form.params.attachments) || []"
						:extra-info="{ moduleType: 'oilRecharge', formId: form.id }"
						@files-updated="handleCommitUpload" />
				</el-form-item>
				<el-form-item label="备注" prop="comments">
					<el-input v-model="form.comments" placeholder="请输入备注" />
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer" style="text-align: center">
				<el-button type="primary" @click="submitForm">提交申请</el-button>
				<el-button @click="close">关闭</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="scss"></style>
