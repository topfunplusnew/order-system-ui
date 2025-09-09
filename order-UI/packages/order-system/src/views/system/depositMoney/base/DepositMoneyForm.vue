<template>
	<DynamicForm ref="dynamicForm" :column-config="columnConfig" :form-data="formData" :external-data="externalData" @field-change="handleFieldChange" />
</template>

<script>
import DynamicForm from '@/components/DynamicForm';
import { addDepositMoney, updateDepositMoney } from '@/api/system/depositMoney';
import { excludeParams } from '@/api/tool/exclude';
import columnConfig from './columns';

export default {
	name: 'DepositMoneyForm',
	components: {
		DynamicForm
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
			externalData: {}
		};
	},
	methods: {
		// 字段变化处理
		handleFieldChange({ prop, value }) {
			// 这里可以处理字段变化的副作用
			console.log(`字段 ${prop} 变化为:`, value);
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
				console.log('获取到的表单数据:', formData);

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
				console.error('处理失败:', error);
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
		}
	}
};
</script>

<style scoped>
/* 组件样式 */
</style>
