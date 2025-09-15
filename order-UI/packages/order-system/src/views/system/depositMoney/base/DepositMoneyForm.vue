<template>
	<DynamicForm ref="dynamicForm" :config="columnConfig" :form-data="formData" :external-data="externalData" @field-change="handleFieldChange">
		<!-- 对方账户选择器插槽 -->
		<template #targetAccountsName="{ value, updateValue }">
			<el-row>
				<el-col :span="16">
					<el-input :value="value" disabled placeholder="请选择对方账户" />
				</el-col>
				<el-col :span="8">
					<SearchOption
						:limit-info="getTargetLimitInfo()"
						:get-data="listBankAccount"
						icon="el-icon-search"
						query-label="户名查找"
						query-info="acountsName"
						:query-name="queryBankOther"
						@commitBack="val => handleCommitBackOther(val, updateValue)"
						@update:queryName="val => (queryBankOther = val)"
					>
						<template #table-columns>
							<el-table-column :label="getTargetAccountLabel()" align="center" prop="acountsName" />
							<el-table-column label="开户行" align="center" prop="bankName" />
							<el-table-column label="账号" align="center" prop="bankNo" />
						</template>
					</SearchOption>
				</el-col>
			</el-row>
		</template>

		<!-- 我方收款账户选择器插槽 -->
		<template #selfAccountsName="{ value, updateValue }">
			<el-row>
				<el-col :span="16">
					<el-input :value="value" disabled placeholder="请选择我方账户" />
				</el-col>
				<el-col :span="8">
					<SearchOption
						:limit-info="{ acountsType: '己方公司' }"
						:get-data="listBankAccount"
						icon="el-icon-search"
						query-label="户名查找"
						query-info="acountsName"
						:query-name="queryBankSelf"
						@commitBack="val => handleCommitBackSelf(val, updateValue)"
						@update:queryName="val => (queryBankSelf = val)"
					>
						<template #table-columns>
							<el-table-column label="开户行" align="center" prop="bankName" />
							<el-table-column label="开户名" align="center" prop="acountsName" />
							<el-table-column label="账号" align="center" prop="bankNo" />
						</template>
					</SearchOption>
				</el-col>
			</el-row>
		</template>
	</DynamicForm>
</template>

<script>
import DynamicForm from '@/components/DynamicForm';
import SearchOption from '@/components/SearchOption.vue';
import { addDepositMoney, updateDepositMoney } from '@/api/system/depositMoney';
import { listBankAccount } from '@/api/system/bankAccount';
import { excludeParams } from '@/api/tool/exclude';
import columnConfig from './columns';

export default {
	name: 'DepositMoneyForm',
	components: {
		DynamicForm,
		SearchOption
	},
	props: {
		// 表单数据，由父组件传入
		formData: {
			type: Object,
			default: () => ({})
		},
		// 是否为编辑模式
		isEdit: {
			type: Boolean,
			default: false
		},
		// 弹窗标题
		title: {
			type: String,
			default: '添加保证金收取信息'
		}
	},
	data() {
		return {
			columnConfig,
			// 外部数据（如果需要的话）
			externalData: {},
			// 搜索控件本地变量
			queryBankOther: '',
			queryBankSelf: ''
		};
	},
	methods: {
		// 字段变化处理
		handleFieldChange({ prop, value }) {
			// 当对象类型发生变化时，清空对方账户相关信息
			if (prop === 'targetType') {
				this.handleTargetTypeChange();
			}
		},

		// 对象类型变化处理
		handleTargetTypeChange() {
			// 清空相关字段
			this.$refs.dynamicForm.updateFieldValue('targetAccountsName', null);
			this.$refs.dynamicForm.updateFieldValue('targetId', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankNo', null);
			this.$refs.dynamicForm.updateFieldValue('targetBankName', null);
			this.queryBankOther = '';
		},

		// 获取对方账户的限制信息
		getTargetLimitInfo() {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;

			// 根据对象类型返回不同的限制条件
			switch (targetType) {
				case '员工':
					return { acountsType: '员工' };
				case '客户':
					return { acountsType: '客户' };
				case '供应商':
					return { acountsType: '供应商' };
				case '其他':
					return { acountsType: '其他' };
				default:
					return {};
			}
		},

		// 获取对方账户的标签
		getTargetAccountLabel() {
			const formData = this.$refs.dynamicForm ? this.$refs.dynamicForm.getFormData() : {};
			const targetType = formData.targetType;
			return targetType === '其他' || targetType === '员工' ? '名称' : targetType || '名称';
		},

		// 对方账户选择回调
		handleCommitBackOther(val, updateValue) {
			// 更新当前字段值
			updateValue(val.acountsName);

			// 自动填充相关字段
			this.$refs.dynamicForm.updateFieldValue('targetId', val.id);
			this.$refs.dynamicForm.updateFieldValue('targetBankNo', val.bankNo);
			this.$refs.dynamicForm.updateFieldValue('targetBankName', val.bankName);
		},

		// 我方账户选择回调
		handleCommitBackSelf(val, updateValue) {
			// 更新当前字段值
			updateValue(val.acountsName);

			// 自动填充相关字段
			this.$refs.dynamicForm.updateFieldValue('selfBankNo', val.bankNo);
			this.$refs.dynamicForm.updateFieldValue('selfBankName', val.bankName);
		},

		// 确认操作处理函数 - 弹窗系统要求的方法
		async handleProcess() {
			try {
				// 1. 首先进行表单验证
				const isValid = await this.$refs.dynamicForm.validateForm();
				if (!isValid) {
					throw new Error('表单验证失败，请检查输入信息');
				}
				// 2. 获取表单数据
				const formData = this.$refs.dynamicForm.getFormData();
				// 3. 根据编辑模式执行相应的业务逻辑
				if (this.isEdit) {
					await this.updateDepositMoneyData(formData);
					this.$message.success('修改成功');
				} else {
					await this.addDepositMoneyData(formData);
					this.$message.success('新增成功');
				}

				// 4. 触发成功事件
				this.$emit('success', formData);
				return Promise.resolve(formData);
			} catch (error) {
				this.$message.error(error.message || (this.isEdit ? '修改失败' : '新增失败'));
				return Promise.reject(error);
			}
		},

		// 取消/关闭操作处理函数 - 弹窗系统要求的方法
		handleReject() {
			this.$emit('cancel');
			return Promise.resolve();
		},

		// 新增保证金数据
		async addDepositMoneyData(formData) {
			const data = excludeParams(formData);
			await addDepositMoney(data);
		},

		// 修改保证金数据
		async updateDepositMoneyData(formData) {
			const data = excludeParams(formData);
			await updateDepositMoney(data);
		},

		// 银行账户搜索方法
		listBankAccount
	}
};
</script>

<style scoped>
/* 组件样式 */
</style>
